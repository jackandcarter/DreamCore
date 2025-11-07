// Retail-only TrinityCore SOAP helpers with DB confirmation (no command probing)
// Requires: mysql2/promise

import crypto from "crypto";
import mysql from "mysql2/promise";

// ---------- Config plumbing ----------
export function makeAuthPool({ host, port, user, password, database }) {
  return mysql.createPool({
    host,
    port,
    user,
    password,
    database,
    waitForConnections: true,
    connectionLimit: 10,
    namedPlaceholders: true,
  });
}

export function makeSoapConfig({ host, port = 7878, user, pass }) {
  return { host, port, user, pass };
}

// ---------- SOAP ----------
function escapeXml(s) {
  return String(s).replace(/[<>&'"\\]/g, (c) => (
    { "<": "&lt;", ">": "&gt;", "&": "&amp;", "'": "&apos;", '"': "&quot;", "\\": "&#92;" }[c]
  ));
}

function envelope(cmd) {
  return `<?xml version="1.0" encoding="utf-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
  <SOAP-ENV:Body>
    <ns1:executeCommand xmlns:ns1="urn:TC"><command>${escapeXml(cmd)}</command></ns1:executeCommand>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>`;
}

function extractReturn(xml) {
  const m = xml.match(/<return[^>]*>([\s\S]*?)<\/return>/i);
  return m ? m[1].trim() : xml.trim();
}

const q = (s) => `"${String(s).replace(/(["\\])/g, "\\$1" )}"`;

export function normalizeEmail(e) {
  return String(e ?? "").trim().toLowerCase();
}

async function callSoap(soap, command) {
  const { host, port, user, pass } = soap;
  if (!host || !user || !pass) throw new Error("Missing SOAP configuration");
  const auth = Buffer.from(`${user}:${pass}`).toString("base64");
  const resp = await fetch(`http://${host}:${port}/`, {
    method: "POST",
    headers: { "Content-Type": "text/xml; charset=utf-8", Authorization: `Basic ${auth}` },
    body: envelope(command),
  });
  const text = await resp.text();
  const fault = text.match(/<faultstring[^>]*>([\s\S]*?)<\/faultstring>/i);
  if (fault) {
    const e = new Error(fault[1].trim());
    e.name = "SOAPFault";
    e.soapBody = text;
    throw e;
  }
  if (!resp.ok) {
    const e = new Error(`SOAP HTTP ${resp.status}`);
    e.soapBody = text;
    throw e;
  }
  return { raw: text, ret: extractReturn(text) };
}

// ---------- Deterministic naming ----------
export function wowAccountNameForEmail(email) {
  const norm = normalizeEmail(email);
  const h = crypto.createHash("sha1").update(norm).digest("hex").slice(0, 8);
  return `w_${h}`;
}

// ---------- DB reads (auth) ----------
async function row(authPool, sql, params) {
  const [rows] = await authPool.query(sql, params);
  return Array.isArray(rows) && rows.length ? rows[0] : null;
}

async function rows(authPool, sql, params) {
  const [r] = await authPool.query(sql, params);
  return Array.isArray(r) ? r : [];
}

function safeNumber(value) {
  const num = Number(value);
  return Number.isFinite(num) ? num : null;
}

async function getBattlenet(authPool, email) {
  const normalized = normalizeEmail(email);
  const tables = ["bnetaccount", "battlenet_accounts"];
  for (const table of tables) {
    try {
      const result = await row(
        authPool,
        `SELECT id, email FROM \`${table}\` WHERE UPPER(email) = UPPER(?) LIMIT 1`,
        [normalized]
      );
      if (result) {
        return { ...result, id: safeNumber(result.id) };
      }
    } catch (err) {
      if (err?.code === "ER_NO_SUCH_TABLE" || err?.code === "ER_BAD_FIELD_ERROR") {
        continue;
      }
      throw err;
    }
  }
  return null;
}

async function getAccountByUsername(authPool, username) {
  return await row(
    authPool,
    "SELECT id, username, battlenet_account FROM account WHERE username = ? LIMIT 1",
    [username]
  );
}

async function getLinkedGameAccounts(authPool, bnetId) {
  const queries = [
    {
      sql:
        "SELECT ga.id AS id, ga.username AS username, ga.realmID AS realmID" +
        " FROM `gameaccount` AS ga" +
        " JOIN `bnetaccount_gameaccount` AS link ON link.gameaccountid = ga.id" +
        " WHERE link.bnetaccountid = ? ORDER BY ga.id ASC",
      mapper: (row) => ({
        id: safeNumber(row.id),
        username: row.username || null,
        realmID: safeNumber(row.realmID ?? row.realmId),
      }),
    },
    {
      sql:
        "SELECT acc.id AS id, acc.username AS username, acc.realmID AS realmID" +
        " FROM `account` AS acc" +
        " WHERE acc.battlenet_account = ? ORDER BY acc.id ASC",
      mapper: (row) => ({
        id: safeNumber(row.id),
        username: row.username || null,
        realmID: safeNumber(row.realmID ?? row.realmId),
      }),
    },
  ];

  for (const query of queries) {
    try {
      const result = await rows(authPool, query.sql, [bnetId]);
      if (result.length) {
        return result.map(query.mapper);
      }
    } catch (err) {
      if (err?.code === "ER_NO_SUCH_TABLE" || err?.code === "ER_BAD_FIELD_ERROR") {
        continue;
      }
      throw err;
    }
  }

  return [];
}

// ---------- Retail-only commands ----------
async function bnetCreate(soap, email, pass) {
  return callSoap(soap, `bnetaccount create ${q(email)} ${q(pass)}`);
}

async function bnetSetPassword(soap, email, pass) {
  return callSoap(soap, `bnetaccount set password ${q(email)} ${q(pass)}`);
}

async function bnetGameAccountCreate(soap, email) {
  return callSoap(soap, `bnetaccount gameaccount create ${q(email)}`);
}

// ---------- High-level flows (confirm via DB, not text) ----------
export async function ensureRetailAccount({ soap, authPool, email, password, debug = false }) {
  if (!soap || !authPool) throw new Error("Missing soap/authPool");
  const normEmail = normalizeEmail(email);

  const soapLog = [];
  const record = (line) => {
    if (debug) {
      soapLog.push(line);
    }
  };
  const run = async (label, fn) => {
    try {
      const response = await fn();
      record(`${label}: ${response?.ret ?? "ok"}`.slice(0, 240));
      return response;
    } catch (err) {
      record(`${label} FAILED: ${String(err?.message || err).slice(0, 200)}`);
      throw err;
    }
  };

  let bnet = await getBattlenet(authPool, normEmail);
  const hadBnet = !!bnet;
  if (!hadBnet) {
    await run("bnetaccount create", () => bnetCreate(soap, normEmail, password));
    bnet = await getBattlenet(authPool, normEmail);
    if (!bnet) throw new Error("Battle.net account create did not persist");
  }

  await run("bnetaccount set password", () => bnetSetPassword(soap, normEmail, password));

  const bnetId = safeNumber(bnet.id);
  if (bnetId == null) {
    throw new Error("Battle.net account missing numeric id");
  }
  let gameAccounts = await getLinkedGameAccounts(authPool, bnetId);
  const hadGameAccount = gameAccounts.length > 0;

  if (!hadGameAccount) {
    try {
      await run("bnetaccount gameaccount create", () => bnetGameAccountCreate(soap, normEmail));
    } catch (err) {
      throw err;
    }
    gameAccounts = await getLinkedGameAccounts(authPool, bnetId);
    if (!gameAccounts.length) {
      throw new Error("Game account create did not persist");
    }
  }

  return {
    ok: true,
    email: normEmail,
    bnetId,
    gameAccounts: gameAccounts.map((entry) => ({
      id: safeNumber(entry?.id),
      username: entry?.username || null,
      realmID: safeNumber(entry?.realmID ?? entry?.realmId),
    })),
    hadBnet,
    hadGameAccount,
    soapLog,
  };
}

export async function retailPasswordReset({ soap, authPool, email, newPassword }) {
  if (!soap || !authPool) throw new Error("Missing soap/authPool");
  const normEmail = normalizeEmail(email);
  const wowName = wowAccountNameForEmail(normEmail);

  const bnet = await getBattlenet(authPool, normEmail);
  if (!bnet) throw new Error("Battle.net account not found for password reset");

  await bnetSetPassword(soap, normEmail, newPassword);

  const ga = await getAccountByUsername(authPool, wowName);
  if (ga) {
    await callSoap(soap, `account set password ${q(wowName)} ${q(newPassword)} ${q(newPassword)}`);
  }

  return {
    ok: true,
    email: normEmail,
    wowName,
    bnetId: safeNumber(bnet.id),
    gameId: ga ? safeNumber(ga.id) : null,
  };
}

export async function executeRetailCommand({ soap, command }) {
  if (!soap || !command) throw new Error("Missing soap/command");
  return callSoap(soap, command);
}

