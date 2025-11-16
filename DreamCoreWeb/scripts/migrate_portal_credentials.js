#!/usr/bin/env node
import mysql from 'mysql2/promise';
import { normalizeEmail } from '../lib/trinitySoap.js';

const DEFAULT_DB_PASS = process.env.CHAR_DB_PASS || '';

const DB = {
  HOST: process.env.DB_HOST || '127.0.0.1',
  PORT: Number(process.env.DB_PORT || 3306),
  USER: process.env.DB_USER || 'trinity',
  PASS: process.env.DB_PASS || DEFAULT_DB_PASS,
  NAME: process.env.DB_NAME || 'tc_register',
};

function toSafeNumber(value) {
  if (value == null) return null;
  if (typeof value === 'number') return Number.isFinite(value) ? value : null;
  if (typeof value === 'bigint') {
    const num = Number(value);
    return Number.isFinite(num) ? num : null;
  }
  const num = Number(value);
  return Number.isFinite(num) ? num : null;
}

async function ensurePortalTables(conn) {
  await conn.query(`
    CREATE TABLE IF NOT EXISTS portal_users (
      id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
      email VARCHAR(254) NOT NULL,
      username VARCHAR(64) DEFAULT NULL,
      password_hash VARBINARY(128) NOT NULL,
      salt VARBINARY(64) NOT NULL,
      version TINYINT UNSIGNED NOT NULL,
      created_at BIGINT NOT NULL,
      updated_at BIGINT NOT NULL,
      last_login_at BIGINT DEFAULT NULL,
      login_count BIGINT UNSIGNED NOT NULL DEFAULT 0,
      PRIMARY KEY (id),
      UNIQUE KEY uniq_portal_email (email),
      UNIQUE KEY uniq_portal_username (username)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  await conn.query(`
    CREATE TABLE IF NOT EXISTS portal_user_retail_accounts (
      portal_user_id BIGINT UNSIGNED NOT NULL,
      retail_account_id BIGINT UNSIGNED NOT NULL,
      linked_at BIGINT NOT NULL,
      PRIMARY KEY (portal_user_id, retail_account_id),
      UNIQUE KEY uniq_portal_retail_account (retail_account_id),
      CONSTRAINT fk_portal_retail_user FOREIGN KEY (portal_user_id)
        REFERENCES portal_users(id) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);

  await conn.query(`
    CREATE TABLE IF NOT EXISTS portal_user_classic_accounts (
      portal_user_id BIGINT UNSIGNED NOT NULL,
      classic_account_id BIGINT UNSIGNED NOT NULL,
      linked_at BIGINT NOT NULL,
      PRIMARY KEY (portal_user_id, classic_account_id),
      UNIQUE KEY uniq_portal_classic_account (classic_account_id),
      CONSTRAINT fk_portal_classic_user FOREIGN KEY (portal_user_id)
        REFERENCES portal_users(id) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  `);
}

async function migrate() {
  const connection = await mysql.createConnection({
    host: DB.HOST,
    port: DB.PORT,
    user: DB.USER,
    password: DB.PASS,
    database: DB.NAME,
    multipleStatements: true,
  });

  await ensurePortalTables(connection);

  const [legacyTables] = await connection.query("SHOW TABLES LIKE 'portal_credentials'");
  if (!Array.isArray(legacyTables) || !legacyTables.length) {
    console.log('portal_credentials table not found. Nothing to migrate.');
    await connection.end();
    return;
  }

  const [rows] = await connection.execute(
    'SELECT email, account_id, password_hash, salt, version, created_at, updated_at FROM portal_credentials'
  );
  console.log(`Migrating ${rows.length} credential record(s) ...`);

  for (const row of rows) {
    const email = normalizeEmail(row.email);
    if (!email) continue;
    const createdAt = toSafeNumber(row.created_at) ?? Date.now();
    const updatedAt = toSafeNumber(row.updated_at) ?? createdAt;
    const version = row.version ?? 1;
    try {
      await connection.execute(
        `INSERT INTO portal_users (email, username, password_hash, salt, version, created_at, updated_at, last_login_at, login_count)
         VALUES (?, ?, ?, ?, ?, ?, ?, NULL, 0)
         ON DUPLICATE KEY UPDATE
           username = COALESCE(VALUES(username), portal_users.username),
           password_hash = VALUES(password_hash),
           salt = VALUES(salt),
           version = VALUES(version),
           updated_at = VALUES(updated_at)`,
        [email, null, row.password_hash, row.salt, version, createdAt, updatedAt]
      );
      const [userRows] = await connection.execute('SELECT id FROM portal_users WHERE email = ? LIMIT 1', [email]);
      const portalUserId = userRows?.[0]?.id;
      const legacyAccountId = toSafeNumber(row.account_id);
      if (portalUserId != null && legacyAccountId != null) {
        await connection.execute(
          `INSERT INTO portal_user_retail_accounts (portal_user_id, retail_account_id, linked_at)
           VALUES (?, ?, ?)
           ON DUPLICATE KEY UPDATE linked_at = VALUES(linked_at)`,
          [portalUserId, legacyAccountId, updatedAt]
        );
      }
    } catch (err) {
      console.error(`Failed to migrate credential for ${email}`, err);
      throw err;
    }
  }

  await connection.execute('DROP TABLE IF EXISTS portal_credentials');
  console.log('Dropped legacy portal_credentials table.');

  await connection.end();
  console.log('Migration complete.');
}

migrate().catch((err) => {
  console.error('Migration failed', err);
  process.exit(1);
});
