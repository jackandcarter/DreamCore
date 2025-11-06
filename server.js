/**
 * TrinityCore Self‑Serve Account Web App (single‑file)
 * ----------------------------------------------------
 * What you get:
 *  - Sleek modern registration page (Tailwind via CDN + Cloudflare Turnstile CAPTCHA)
 *  - Bot/spam protection: Turnstile + IP rate limiting + email verification flow
 *  - No public SOAP exposure: calls SOAP on 127.0.0.1:7878 using a GM account
 *  - Minimal deps; runs behind your existing Cloudflare Tunnel on the VPS
 *
 * How to use:
 *  1) Enable SOAP in worldserver.conf (keep on localhost):
 *       SOAP.Enabled = 1
 *       SOAP.IP = "127.0.0.1"
 *       SOAP.Port = 7878
 *
 *  2) Fill in the ENV VARS below (or provide via shell/.env):
 *       TC_SOAP_USER, TC_SOAP_PASS, TURNSTILE_SITEKEY, TURNSTILE_SECRET,
 *       SMTP_HOST, SMTP_PORT, SMTP_USER, SMTP_PASS, FROM_EMAIL, BASE_URL
 *
 *  3) Run:  npm i express express-rate-limit mysql2 nodemailer
 *           node server.js
 *
 *  4) Point Cloudflare Tunnel to http://127.0.0.1:8787   (or change PORT)
 *
 *  Optional: systemd unit example is printed on startup.
 */

import express from 'express';
import rateLimit from 'express-rate-limit';
import crypto from 'crypto';
import nodemailer from 'nodemailer';
import mysql from 'mysql2/promise';

// ----- CONFIG (read from env or inline defaults for dev) -----
const CONFIG = {
  PORT: Number(process.env.PORT || 8787),
  BASE_URL: process.env.BASE_URL || 'https://wow.the-demiurge.com', // public URL for verify links

  // TrinityCore SOAP creds (use a dedicated non-playing GM account)
  TC_SOAP_HOST: process.env.TC_SOAP_HOST || '127.0.0.1',
  TC_SOAP_PORT: Number(process.env.TC_SOAP_PORT || 7878),
  TC_SOAP_USER: process.env.TC_SOAP_USER || 'gm_account_name',
  TC_SOAP_PASS: process.env.TC_SOAP_PASS || 'gm_account_password',

  // Cloudflare Turnstile
  TURNSTILE_SITEKEY: process.env.TURNSTILE_SITEKEY || '1x00000000000000000000AA',
  TURNSTILE_SECRET: process.env.TURNSTILE_SECRET || '1x0000000000000000000000000000000AA',

  // SMTP for email verification links
  SMTP_HOST: process.env.SMTP_HOST || 'smtp.example.com',
  SMTP_PORT: Number(process.env.SMTP_PORT || 587),
  SMTP_SECURE: (process.env.SMTP_SECURE || 'false').toLowerCase() === 'true',
  SMTP_USER: process.env.SMTP_USER || 'apikey',
  SMTP_PASS: process.env.SMTP_PASS || 'secret',
  FROM_EMAIL: process.env.FROM_EMAIL || 'no-reply@example.com',

  // Branding
  BRAND_NAME: process.env.BRAND_NAME || 'DreamCore',
  HEADER_TITLE: process.env.HEADER_TITLE || 'DreamCore.WoW',
  CORNER_LOGO: process.env.CORNER_LOGO || 'DemiDevUnit',
  GUIDE_URL:
    process.env.GUIDE_URL ||
    'https://hissing-polonium-8c0.notion.site/Guide-to-install-and-play-DreamCore-2a22305ea64f80a58008c5024bfe8555',

  // Registration constraints
  MIN_PASS: Number(process.env.MIN_PASS || 8),
  MAX_PASS: Number(process.env.MAX_PASS || 72),
  MAX_USER: Number(process.env.MAX_USER || 20), // used to clip a derived username for DB storage
  TOKEN_TTL_MIN: Number(process.env.TOKEN_TTL_MIN || 30), // minutes
  SESSION_TTL_HOURS: Number(process.env.SESSION_TTL_HOURS || 24),
  SESSION_COOKIE_NAME: process.env.SESSION_COOKIE_NAME || 'dreamcore_session',
  COOKIE_SECURE: (process.env.COOKIE_SECURE || 'true').toLowerCase() === 'true',
  CHARACTER_CACHE_TTL_MS: Number(process.env.CHARACTER_CACHE_TTL_MS || 30 * 1000),
};

// ----- DB (MariaDB for pending verifications) -----
const DB = {
  HOST: process.env.DB_HOST || '127.0.0.1',
  PORT: Number(process.env.DB_PORT || 3306),
  USER: process.env.DB_USER || 'trinity',
  PASS: process.env.DB_PASS || 'trinity_password',
  NAME: process.env.DB_NAME || 'tc_register',
};

const AUTH_DB = {
  HOST: process.env.AUTH_DB_HOST || '127.0.0.1',
  PORT: Number(process.env.AUTH_DB_PORT || 3306),
  USER: process.env.AUTH_DB_USER || 'trinity',
  PASS: process.env.AUTH_DB_PASS || 'trinity_password',
  NAME: process.env.AUTH_DB_NAME || 'auth',
};

const CHAR_DB = {
  HOST: process.env.CHAR_DB_HOST || '127.0.0.1',
  PORT: Number(process.env.CHAR_DB_PORT || 3306),
  USER: process.env.CHAR_DB_USER || 'trinity',
  PASS: process.env.CHAR_DB_PASS || 'trinity_password',
  NAME: process.env.CHAR_DB_NAME || 'characters',
};

// Bootstrap: ensure database exists using a one-off connection
const admin = await mysql.createConnection({
  host: DB.HOST, port: DB.PORT, user: DB.USER, password: DB.PASS,
  multipleStatements: true,
});
await admin.query(
  `CREATE DATABASE IF NOT EXISTS \`${DB.NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`
);
await admin.end();

// Main pool — note the "database" option
const pool = await mysql.createPool({
  host: DB.HOST,
  port: DB.PORT,
  user: DB.USER,
  password: DB.PASS,
  database: DB.NAME,            // <-- important
  waitForConnections: true,
  connectionLimit: 10,
  namedPlaceholders: true,
  multipleStatements: true,
});

const authPool = await mysql.createPool({
  host: AUTH_DB.HOST,
  port: AUTH_DB.PORT,
  user: AUTH_DB.USER,
  password: AUTH_DB.PASS,
  database: AUTH_DB.NAME,
  waitForConnections: true,
  connectionLimit: 10,
  namedPlaceholders: true,
});

// Character DB pool reserved for future character-based endpoints.
const charPool = await mysql.createPool({
  host: CHAR_DB.HOST,
  port: CHAR_DB.PORT,
  user: CHAR_DB.USER,
  password: CHAR_DB.PASS,
  database: CHAR_DB.NAME,
  waitForConnections: true,
  connectionLimit: 10,
  namedPlaceholders: true,
});

const REALM_DB_CONFIGS = loadRealmDbConfigs();
const REALM_POOL_ENTRIES = buildRealmPoolEntries(REALM_DB_CONFIGS);
const REALM_LOOKUP = createRealmLookup(REALM_POOL_ENTRIES);

// Ensure table exists (and de-dupe by email)
await pool.query(`
  CREATE TABLE IF NOT EXISTS pending (
    token VARCHAR(64) PRIMARY KEY,
    username VARCHAR(32) NOT NULL,
    password VARCHAR(128) NOT NULL,
    email VARCHAR(254) NOT NULL,
    created_at BIGINT NOT NULL,
    KEY idx_created_at (created_at),
    UNIQUE KEY uniq_email (email)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
`);

await pool.query(`
  CREATE TABLE IF NOT EXISTS sessions (
    id CHAR(64) PRIMARY KEY,
    account_id BIGINT UNSIGNED NOT NULL,
    email VARCHAR(254) NOT NULL,
    created_at BIGINT NOT NULL,
    expires_at BIGINT NOT NULL,
    last_ip VARCHAR(64) DEFAULT NULL,
    last_user_agent VARCHAR(255) DEFAULT NULL,
    KEY idx_account (account_id),
    KEY idx_expires (expires_at)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
`);

// ----- Mailer -----
const transporter = nodemailer.createTransport({
  host: CONFIG.SMTP_HOST,
  port: CONFIG.SMTP_PORT,
  secure: CONFIG.SMTP_SECURE,
  auth: { user: CONFIG.SMTP_USER, pass: CONFIG.SMTP_PASS },
});

// ----- App -----
const app = express();
app.set('trust proxy', 1); // one hop (Cloudflare)
app.use(express.json());

// Rate limit register endpoint (per IP)
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 20,
  standardHeaders: true,
  legacyHeaders: false,
});

const loginLimiter = rateLimit({
  windowMs: 10 * 60 * 1000,
  max: 8,
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => req.ip || req.headers['x-forwarded-for'] || 'global',
});

// ----- UI (modern, minimal, responsive) -----
const REG_PAGE = () => `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>${CONFIG.HEADER_TITLE} — Create Account</title>
  <script src="https://challenges.cloudflare.com/turnstile/v0/api.js" defer></script>
  <script>
    window.TURNSTILE_SITEKEY = ${JSON.stringify(CONFIG.TURNSTILE_SITEKEY)};
  </script>
  <script src="/client.js" defer></script>
  <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
  <style>
    body {
      background: radial-gradient(circle at top, rgba(76, 29, 149, 0.25), rgba(15, 23, 42, 0.95));
    }
    .aurora::before {
      content: "";
      position: fixed;
      inset: -30%;
      background: conic-gradient(from 90deg at 50% 50%, rgba(99, 102, 241, 0.35), rgba(14, 165, 233, 0.2), rgba(236, 72, 153, 0.25), rgba(99, 102, 241, 0.35));
      filter: blur(120px);
      opacity: 0.4;
      animation: aurora-shift 24s linear infinite;
      z-index: 0;
      pointer-events: none;
    }
    @keyframes aurora-shift {
      0% { transform: rotate(0deg) scale(1.1); }
      50% { transform: rotate(180deg) scale(1.2); }
      100% { transform: rotate(360deg) scale(1.1); }
    }
  </style>
</head>
<body class="min-h-screen text-gray-100 flex items-center justify-center p-6 aurora relative overflow-x-hidden">
  <div class="absolute top-6 left-6 text-2xl sm:text-3xl font-semibold tracking-[0.3em] text-indigo-300 drop-shadow-lg z-20 uppercase">${CONFIG.CORNER_LOGO}</div>
  <div class="w-full max-w-xl relative z-10">
    <div class="bg-gray-900/80 backdrop-blur-xl rounded-3xl shadow-2xl border border-indigo-500/20 overflow-hidden">
      <div class="px-6 pt-8 pb-10 sm:px-10">
        <div class="flex items-baseline justify-between">
          <h1 class="text-4xl font-semibold tracking-tight text-white">Welcome to DreamCore</h1>
          <span class="text-xs font-medium uppercase tracking-[0.4em] text-indigo-400">Create</span>
        </div>
        <p class="mt-3 text-[15px] text-gray-100 drop-shadow-sm">Create your account for <span class="font-semibold text-indigo-400 drop-shadow">${CONFIG.BRAND_NAME}</span> and get in-game fast.</p>

        <div class="mt-8 space-y-8">
          <section class="rounded-3xl border border-indigo-500/40 bg-gray-900/60 p-6 shadow-inner shadow-indigo-900/30">
            <div class="flex items-center gap-4">
              <span class="flex h-10 w-10 items-center justify-center rounded-full bg-gradient-to-br from-indigo-500 via-purple-500 to-blue-500 text-lg font-semibold text-white shadow-lg shadow-indigo-900/40">1</span>
              <div>
                <h2 class="text-lg font-semibold text-white">Step 1 · Create your account</h2>
                <p class="text-[15px] text-indigo-100/90">Fill out the secure form below. A verification email will be sent to the address you provide.</p>
              </div>
            </div>
            <form id="regForm" class="mt-6 space-y-5">
              <div>
                <label class="block text-sm font-medium text-indigo-200 mb-1" for="email">Email</label>
                <input id="email" type="email" name="email" required
                       class="w-full rounded-2xl bg-gray-800/80 border border-gray-700 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-400 p-3 text-[15px] font-semibold text-indigo-200 focus:text-indigo-100 transition placeholder-indigo-300/60" placeholder="you@example.com" />
              </div>
              <div>
                <label class="block text-sm font-medium text-indigo-200 mb-1" for="password">Password</label>
                <input id="password" type="password" name="password" required minlength="${CONFIG.MIN_PASS}" maxlength="${CONFIG.MAX_PASS}"
                       class="w-full rounded-2xl bg-gray-800/80 border border-gray-700 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-400 p-3 text-[15px] font-semibold text-indigo-200 focus:text-indigo-100 transition placeholder-indigo-300/60" placeholder="••••••••" />
                <p class="text-xs text-indigo-200/70 mt-2">${CONFIG.MIN_PASS}+ characters. Your email becomes your DreamCore login.</p>
              </div>
              <div class="pt-2" id="cf-box">
                <div class="cf-turnstile" data-sitekey="${CONFIG.TURNSTILE_SITEKEY}" data-theme="auto"></div>
              </div>
              <button class="w-full py-3.5 rounded-2xl bg-gradient-to-r from-indigo-500 via-purple-500 to-blue-500 hover:from-indigo-400 hover:via-purple-400 hover:to-blue-400 focus:ring-2 focus:ring-indigo-400 active:scale-[0.99] transition font-semibold text-[15px] shadow-lg shadow-indigo-900/50" type="submit">Create account</button>
            </form>
            <pre id="msg" class="mt-6 text-sm whitespace-pre-wrap text-indigo-100 bg-gray-900/70 border border-indigo-500/30 rounded-2xl p-4 min-h-[3rem] transition"></pre>
            <div class="mt-6 rounded-2xl border border-indigo-500/30 bg-gray-900/60 p-4 text-indigo-100 shadow-inner shadow-indigo-900/20">
              <p class="text-sm font-semibold uppercase tracking-[0.25em] text-indigo-200">What happens next?</p>
              <p class="mt-2 text-[15px] text-indigo-100/85">Check your inbox for our verification email. Once you confirm your address, the success page will walk you through the remaining steps.</p>
            </div>
          </section>
        </div>
      </div>
    </div>
    <p class="text-center text-xs text-gray-500 mt-5">Protected by Cloudflare · DreamCore DemiDev Unit 2025 · DreamCore.exe shortcut by Azar </p>
  </div>
</body>
</html>`;

const CLIENT_JS = `(() => {
  const form = document.getElementById('regForm');
  const msg = document.getElementById('msg');
  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    msg.textContent = 'Submitting…';

    // Get Turnstile token
    const tokenEl = document.querySelector('.cf-turnstile input[name="cf-turnstile-response"]');
    const cfToken = tokenEl ? tokenEl.value : '';

    const payload = {
      email: document.getElementById('email').value.trim(),
      password: document.getElementById('password').value,
      cfToken
    };

    const res = await fetch('/api/register', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
    const j = await res.json().catch(() => ({}));
    if (!res.ok) {
      msg.textContent = j.error ? ('Error: ' + j.error) : 'Something went wrong.';
      return;
    }
    msg.textContent = 'Check your email for a verification link to finish account creation.';
  });
})();`;

app.get('/', (req, res) => res.type('html').send(REG_PAGE()));
app.get('/client.js', (req, res) => res.type('application/javascript').send(CLIENT_JS));

// ----- Helpers -----
function badRequest(res, error) { return res.status(400).json({ error }); }
function isValidPassword(p) {
  return typeof p === 'string' && p.length >= CONFIG.MIN_PASS && p.length <= CONFIG.MAX_PASS;
}
function isValidEmail(e) {
  return typeof e === 'string' && /.+@.+\..+/.test(e) && e.length <= 254;
}

function maskEmail(e) {
  if (typeof e !== 'string') return 'unknown';
  const [local, domain] = e.split('@');
  if (!domain) return 'unknown';
  const prefix = local.slice(0, 2);
  const suffix = local.length > 2 ? local.slice(-1) : '';
  return `${prefix || '*'}***${suffix}@${domain}`;
}

function upperHex(buffer) {
  return Buffer.from(buffer).toString('hex').toUpperCase();
}

const SRP_N = BigInt('0xAC6BDB41324A9A9BF166DE5E1389582FAF72B6651987EE07FC3192943DB56050A37329CBB4A099ED8193E0757767A13DD52312AB4B03310DCD7F48A9DA04FD50E8083969EDB767B0CF609F1D0EA29DE2EF7FBE54FF5D6F52ABFDE5479F9DCF3CB31F4CFF55BCCC0A151AF5F0DC8B4BD45BF37DF365C1A65E68CFDA76D4DA708DF1FB26E40EE5B2FADD5B2115BD5A33D3FE3A8ABDF0195995B6D607339C3FD20915C6C1');
const SRP_G = 2n;

function srpHashIdentity(email, password) {
  const identity = Buffer.from(String(email || '').trim().toUpperCase());
  const pass = Buffer.from(String(password || ''));
  const sha256 = crypto
    .createHash('sha256')
    .update(identity)
    .update(':')
    .update(pass)
    .digest();
  const sha1 = crypto
    .createHash('sha1')
    .update(identity)
    .update(':')
    .update(pass)
    .digest();
  return { sha256, sha1 };
}

function modExp(base, exponent, modulus) {
  if (modulus === 1n) return 0n;
  let result = 1n;
  let b = base % modulus;
  let e = exponent;
  while (e > 0n) {
    if (e & 1n) result = (result * b) % modulus;
    e >>= 1n;
    b = (b * b) % modulus;
  }
  return result;
}

function deriveVerifier(email, password, salt) {
  if (!salt) return null;
  const { sha256 } = srpHashIdentity(email, password);
  const xBytes = crypto.createHash('sha256').update(salt).update(sha256).digest();
  const x = BigInt('0x' + xBytes.toString('hex'));
  const v = modExp(SRP_G, x, SRP_N);
  let hex = v.toString(16);
  if (hex.length % 2) hex = '0' + hex;
  return Buffer.from(hex, 'hex');
}

function matchesSrpHash({ storedHash, salt, verifier }, email, password) {
  const normalizedHash = typeof storedHash === 'string' ? storedHash.trim().toUpperCase() : null;
  const { sha256, sha1 } = srpHashIdentity(email, password);
  const sha256Hex = upperHex(sha256);
  const sha1Hex = upperHex(sha1);
  if (normalizedHash && (normalizedHash === sha256Hex || normalizedHash === sha1Hex)) {
    return true;
  }
  if (verifier) {
    try {
      const derived = deriveVerifier(email, password, salt);
      if (derived && Buffer.compare(Buffer.from(verifier), derived) === 0) {
        return true;
      }
    } catch (e) {
      console.error('Failed to derive SRP verifier', e);
    }
  }
  return false;
}

const CHARACTER_CACHE_TTL = (() => {
  const ms = Number(CONFIG.CHARACTER_CACHE_TTL_MS);
  if (Number.isFinite(ms) && ms >= 1000) return ms;
  return 30 * 1000;
})();

const CHARACTER_CACHE = new Map();

function pruneCharacterCache() {
  if (!CHARACTER_CACHE.size) return;
  const now = Date.now();
  for (const [key, entry] of CHARACTER_CACHE.entries()) {
    if (!entry || entry.expiresAt <= now) {
      CHARACTER_CACHE.delete(key);
    }
  }
}

if (CHARACTER_CACHE_TTL > 0) {
  const sweepInterval = setInterval(pruneCharacterCache, Math.max(CHARACTER_CACHE_TTL * 2, 60 * 1000));
  sweepInterval.unref?.();
}

function loadRealmDbConfigs() {
  const fallbackName = process.env.DEFAULT_REALM_NAME || `${CONFIG.BRAND_NAME || 'DreamCore'} Realm`;
  const fallback = [
    {
      key: 'default',
      realmId: null,
      name: fallbackName,
      host: CHAR_DB.HOST,
      port: CHAR_DB.PORT,
      user: CHAR_DB.USER,
      password: CHAR_DB.PASS,
      database: CHAR_DB.NAME,
      charactersTable: 'characters',
      charDbLabel: CHAR_DB.NAME,
      useDefaultPool: true,
    },
  ];
  const raw = process.env.REALM_DATABASES;
  if (!raw) return fallback;
  try {
    const parsed = JSON.parse(raw);
    if (!Array.isArray(parsed) || !parsed.length) {
      return fallback;
    }
    return parsed.map((item, idx) => {
      const cfg = {
        key: String(item.key || item.name || item.realmId || idx),
        realmId: item.realmId ?? item.realmID ?? null,
        name: item.name || fallbackName,
        host: item.host || CHAR_DB.HOST,
        port: Number(item.port || CHAR_DB.PORT),
        user: item.user || item.username || CHAR_DB.USER,
        password: item.password || item.pass || CHAR_DB.PASS,
        database: item.database || item.db || CHAR_DB.NAME,
        charactersTable: item.charactersTable || item.table || 'characters',
        charDbLabel: item.charDb || item.char_db || null,
        useDefaultPool: false,
      };
      if (!Number.isFinite(cfg.port) || cfg.port <= 0) cfg.port = CHAR_DB.PORT;
      if (cfg.charDbLabel == null || cfg.charDbLabel === '') {
        cfg.charDbLabel = cfg.database;
      }
      return cfg;
    });
  } catch (err) {
    console.warn('Failed to parse REALM_DATABASES', err?.message || err);
    return fallback;
  }
}

function buildRealmPoolEntries(configs) {
  return configs.map((cfg, idx) => {
    const key = cfg.key || `realm-${idx}`;
    const reuseDefault =
      cfg.useDefaultPool ||
      (idx === 0 &&
        cfg.host === CHAR_DB.HOST &&
        cfg.port === CHAR_DB.PORT &&
        cfg.user === CHAR_DB.USER &&
        cfg.password === CHAR_DB.PASS &&
        cfg.database === CHAR_DB.NAME);
    const pool = reuseDefault
      ? charPool
      : mysql.createPool({
          host: cfg.host,
          port: cfg.port,
          user: cfg.user,
          password: cfg.password,
          database: cfg.database,
          waitForConnections: true,
          connectionLimit: 10,
          namedPlaceholders: true,
        });
    const normalizedCharDb = String(cfg.charDbLabel || cfg.database || '').toLowerCase();
    return {
      key,
      pool,
      config: {
        ...cfg,
        key,
        charactersTable: String(cfg.charactersTable || 'characters'),
        charDbLabel: normalizedCharDb,
      },
    };
  });
}

function createRealmLookup(entries) {
  const lookup = {
    default: entries[0] || null,
    byId: new Map(),
    byCharDb: new Map(),
    entries,
  };
  for (const entry of entries) {
    const { config } = entry;
    const realmIdNum = toSafeNumber(config.realmId);
    if (realmIdNum != null && !lookup.byId.has(realmIdNum)) {
      lookup.byId.set(realmIdNum, entry);
    }
    const dbLabel = (config.charDbLabel || config.database || '').toLowerCase();
    if (dbLabel) lookup.byCharDb.set(dbLabel, entry);
  }
  return lookup;
}

function resolveRealmEntry({ realmId, realmCharDb }) {
  const numericRealmId = toSafeNumber(realmId);
  if (numericRealmId != null && REALM_LOOKUP.byId?.has(numericRealmId)) {
    return REALM_LOOKUP.byId.get(numericRealmId);
  }
  if (realmCharDb) {
    const key = String(realmCharDb).toLowerCase();
    const byCharDb = REALM_LOOKUP.byCharDb?.get(key);
    if (byCharDb) return byCharDb;
  }
  return REALM_LOOKUP.default || null;
}

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

function safeIdentifier(value, fallback) {
  const str = String(value || '').trim();
  if (!str) return fallback;
  if (!/^[0-9A-Za-z_]+$/.test(str)) return fallback;
  return str;
}

function normalizeTimestamp(value) {
  if (value == null) return null;
  if (value instanceof Date) return value.toISOString();
  const num = Number(value);
  if (!Number.isFinite(num) || num <= 0) return null;
  const millis = num < 1e11 ? num * 1000 : num;
  const date = new Date(millis);
  if (Number.isNaN(date.getTime())) return null;
  return date.toISOString();
}

let REALM_DIRECTORY_CACHE = null;

async function ensureRealmDirectory() {
  if (REALM_DIRECTORY_CACHE) return REALM_DIRECTORY_CACHE;
  try {
    const [rows] = await authPool.query('SELECT id, name, char_db FROM `realmlist`');
    REALM_DIRECTORY_CACHE = rows.map((row) => ({
      id: toSafeNumber(row.id),
      name: row.name || null,
      charDb: row.char_db || row.charDb || null,
    }));
  } catch (err) {
    if (err?.code === 'ER_NO_SUCH_TABLE') {
      REALM_DIRECTORY_CACHE = [];
    } else {
      console.error('Failed to load realm directory', err);
      REALM_DIRECTORY_CACHE = [];
    }
  }
  return REALM_DIRECTORY_CACHE;
}

async function fetchGameAccountsForBnet(bnetAccountId) {
  if (bnetAccountId == null) return [];
  const accounts = [];
  let missingLinkTable = false;
  let missingGameAccountTable = false;
  try {
    const [rows] = await authPool.query(
      `SELECT link.gameaccountid AS gameAccountId,
              ga.id AS gaId,
              ga.username AS username,
              ga.realmID AS realmId,
              r.name AS realmName,
              r.char_db AS realmCharDb
         FROM \`bnetaccount_gameaccount\` AS link
         JOIN \`gameaccount\` AS ga ON ga.id = link.gameaccountid
         LEFT JOIN \`realmlist\` AS r ON r.id = ga.realmID
        WHERE link.bnetaccountid = ?`,
      [bnetAccountId]
    );
    for (const row of rows) {
      accounts.push({
        gameAccountId: toSafeNumber(row.gameAccountId ?? row.gaId ?? row.id),
        username: row.username || null,
        realmId: toSafeNumber(row.realmId ?? row.realmID),
        realmName: row.realmName || null,
        realmCharDb: row.realmCharDb || row.char_db || null,
      });
    }
    if (accounts.length) {
      return accounts;
    }
  } catch (err) {
    const message = String(err?.message || '').toLowerCase();
    if (err?.code === 'ER_NO_SUCH_TABLE') {
      if (message.includes('bnetaccount_gameaccount')) {
        missingLinkTable = true;
      } else {
        missingGameAccountTable = true;
      }
    } else if (err?.code !== 'ER_BAD_FIELD_ERROR') {
      throw err;
    }
  }

  if (missingLinkTable) {
    return accounts;
  }

  if (!accounts.length) {
    try {
      const [rows] = await authPool.query(
        `SELECT link.gameaccountid AS gameAccountId,
                acc.id AS accountId,
                acc.username AS username,
                acc.realmID AS realmId
           FROM \`bnetaccount_gameaccount\` AS link
           JOIN \`account\` AS acc ON acc.id = link.gameaccountid
          WHERE link.bnetaccountid = ?`,
        [bnetAccountId]
      );
      const realms = await ensureRealmDirectory();
      for (const row of rows) {
        const realmId = toSafeNumber(row.realmId ?? row.realmID);
        const realmInfo = realms.find((r) => r.id === realmId) || null;
        accounts.push({
          gameAccountId: toSafeNumber(row.gameAccountId ?? row.accountId),
          username: row.username || null,
          realmId,
          realmName: realmInfo?.name || null,
          realmCharDb: realmInfo?.charDb || null,
        });
      }
    } catch (err) {
      if (err?.code === 'ER_NO_SUCH_TABLE' && missingGameAccountTable) {
        return accounts;
      }
      if (err?.code !== 'ER_NO_SUCH_TABLE') {
        throw err;
      }
    }
  }

  return accounts;
}

function entryCharactersTable(entry) {
  return safeIdentifier(entry?.config?.charactersTable, 'characters');
}

async function loadBattleNetCharacters(bnetAccountId) {
  const gameAccounts = await fetchGameAccountsForBnet(bnetAccountId);
  if (!gameAccounts.length) {
    return { characters: [], realms: [] };
  }

  const characters = [];
  const realmMetaMap = new Map();
  const groups = new Map();

  for (const account of gameAccounts) {
    const realmEntry = resolveRealmEntry(account);
    if (!realmEntry) continue;
    const realmId = toSafeNumber(account.realmId);
    const realmName = account.realmName || realmEntry.config.name || 'Realm';
    const groupKey = `${realmEntry.key}#${realmId ?? 'null'}`;
    let group = groups.get(groupKey);
    if (!group) {
      group = {
        entry: realmEntry,
        accountIds: [],
        realmId,
        realmName,
      };
      groups.set(groupKey, group);
    }
    if (account.gameAccountId != null) {
      group.accountIds.push(account.gameAccountId);
    }
    let realmMeta = realmMetaMap.get(groupKey);
    if (!realmMeta) {
      realmMeta = {
        id: realmId,
        name: realmName,
        accounts: [],
        hasCharacters: false,
      };
      realmMetaMap.set(groupKey, realmMeta);
    }
    if (account.gameAccountId != null) {
      const id = toSafeNumber(account.gameAccountId);
      if (id != null) {
        realmMeta.accounts.push({
          id,
          username: account.username || null,
        });
      }
    }
  }

  for (const group of groups.values()) {
    if (!group.accountIds.length) continue;
    const placeholders = group.accountIds.map(() => '?').join(', ');
    const tableName = entryCharactersTable(group.entry);
    try {
      const [rows] = await group.entry.pool.query(
        `SELECT account, name, level, class, race, logout_time FROM \`${tableName}\` WHERE account IN (${placeholders})`,
        group.accountIds
      );
      const realmMeta = realmMetaMap.get(`${group.entry.key}#${group.realmId ?? 'null'}`);
      for (const row of rows) {
        const accountId = toSafeNumber(row.account ?? row.accountId ?? row.id);
        const lastLogin = normalizeTimestamp(
          row.logout_time ?? row.logoutTime ?? row.last_login ?? row.lastLogin
        );
        const character = {
          name: row.name,
          level: Number(row.level),
          class: Number(row.class),
          race: Number(row.race),
          realm: {
            id: group.realmId,
            name: group.realmName,
          },
          lastLogin,
        };
        if (accountId != null) {
          character.gameAccountId = accountId;
        }
        characters.push(character);
        if (realmMeta) {
          realmMeta.hasCharacters = true;
        }
      }
    } catch (err) {
      console.error('Character lookup failed for realm', group.realmId ?? 'unknown', err);
      const realmMeta = realmMetaMap.get(`${group.entry.key}#${group.realmId ?? 'null'}`);
      if (realmMeta) {
        realmMeta.error = 'Character lookup failed';
      }
    }
  }

  characters.sort((a, b) => {
    const realmA = a.realm?.name || '';
    const realmB = b.realm?.name || '';
    const realmCompare = realmA.localeCompare(realmB, undefined, { sensitivity: 'base' });
    if (realmCompare !== 0) return realmCompare;
    return a.name.localeCompare(b.name, undefined, { sensitivity: 'base' });
  });

  const realms = Array.from(realmMetaMap.values()).map((realm) => {
    const seen = new Set();
    const accounts = [];
    for (const acc of realm.accounts) {
      if (acc?.id == null) continue;
      if (seen.has(acc.id)) continue;
      seen.add(acc.id);
      accounts.push({
        id: acc.id,
        username: acc.username || null,
      });
    }
    return {
      id: realm.id,
      name: realm.name,
      accounts,
      hasCharacters: !!realm.hasCharacters,
      error: realm.error || null,
    };
  });

  return { characters, realms };
}

function createEmptyCharacterResponse() {
  const refreshedAt = new Date().toISOString();
  return {
    ok: true,
    characters: [],
    realms: [],
    summary: { totalCharacters: 0, totalRealms: 0 },
    message: 'No characters found for this account.',
    refreshedAt,
  };
}

async function buildCharactersResponse(accountId) {
  const normalizedId = toSafeNumber(accountId);
  if (normalizedId == null) {
    return createEmptyCharacterResponse();
  }
  const roster = await loadBattleNetCharacters(normalizedId);
  const refreshedAt = new Date().toISOString();
  const payload = {
    ok: true,
    characters: roster.characters,
    realms: roster.realms,
    summary: {
      totalCharacters: roster.characters.length,
      totalRealms: roster.realms.length,
    },
    refreshedAt,
  };
  if (!roster.characters.length) {
    payload.message = 'No characters found for this account.';
  }
  return payload;
}

function hashSessionToken(token) {
  return crypto.createHash('sha256').update(String(token)).digest('hex').toUpperCase();
}

function getSessionToken(req) {
  const authHeader = req.headers['authorization'];
  if (typeof authHeader === 'string' && authHeader.toLowerCase().startsWith('bearer ')) {
    return authHeader.slice(7).trim();
  }
  const cookieHeader = req.headers['cookie'];
  if (!cookieHeader) return null;
  for (const part of cookieHeader.split(';')) {
    const [rawName, ...rest] = part.trim().split('=');
    if (!rawName) continue;
    if (rawName === CONFIG.SESSION_COOKIE_NAME) {
      return decodeURIComponent(rest.join('='));
    }
  }
  return null;
}

async function loadSession(req) {
  const token = getSessionToken(req);
  if (!token) return null;
  const hashed = hashSessionToken(token);
  const now = Date.now();
  const [rows] = await pool.execute(
    'SELECT id, account_id, email, created_at, expires_at FROM sessions WHERE id = ? AND expires_at > ?',
    [hashed, now]
  );
  if (!rows.length) return null;
  const session = rows[0];
  session.token = token;
  return session;
}

async function persistSession(accountId, email, req) {
  const token = crypto.randomBytes(48).toString('base64url');
  const hashed = hashSessionToken(token);
  const now = Date.now();
  const expiresAt = now + CONFIG.SESSION_TTL_HOURS * 60 * 60 * 1000;
  const userAgent = (req.headers['user-agent'] || '').slice(0, 255);
  const ip = (req.ip || req.headers['x-forwarded-for'] || '').toString().slice(0, 64);
  await pool.execute(
    `REPLACE INTO sessions (id, account_id, email, created_at, expires_at, last_ip, last_user_agent)
     VALUES (?, ?, ?, ?, ?, ?, ?)`,
    [hashed, accountId, email, now, expiresAt, ip || null, userAgent || null]
  );
  return { token, expiresAt };
}

async function requireSession(req, res, next) {
  try {
    const session = await loadSession(req);
    if (!session) {
      return res.status(401).json({ error: 'Unauthorized' });
    }
    req.session = session;
    return next();
  } catch (e) {
    console.error('Session lookup failed', e);
    return res.status(500).json({ error: 'Session lookup failed' });
  }
}

async function getAuthAccountByEmail(email) {
  const tables = ['bnetaccount', 'battlenet_accounts'];
  for (const table of tables) {
    try {
      const [rows] = await authPool.execute(
        `SELECT id, email, sha_pass_hash, salt, verifier FROM \`${table}\` WHERE email = ? LIMIT 1`,
        [email]
      );
      if (rows.length) return rows[0];
    } catch (err) {
      if (err?.code === 'ER_BAD_FIELD_ERROR') {
        try {
          const [fallbackRows] = await authPool.execute(
            `SELECT id, email, salt, verifier FROM \`${table}\` WHERE email = ? LIMIT 1`,
            [email]
          );
          if (fallbackRows.length) {
            const row = fallbackRows[0];
            row.sha_pass_hash = null;
            return row;
          }
        } catch (inner) {
          if (inner?.code === 'ER_NO_SUCH_TABLE') continue;
          throw inner;
        }
      } else if (err?.code === 'ER_NO_SUCH_TABLE') {
        continue;
      } else {
        throw err;
      }
    }
  }
  return null;
}

async function verifyTurnstile(token, ip) {
  if (!token) return false;
  const resp = await fetch('https://challenges.cloudflare.com/turnstile/v0/siteverify', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({ secret: CONFIG.TURNSTILE_SECRET, response: token, remoteip: ip })
  });
  const data = await resp.json();
  return !!data.success;
}

function escapeXml(s) {
  return String(s).replace(/[<>&'\"]/g, c => (
    { '<': '&lt;', '>': '&gt;', '&': '&amp;', "'": '&apos;', '"': '&quot;' }[c]
  ));
}
function buildSoapEnvelope(command) {
  return `<?xml version="1.0" encoding="utf-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
  <SOAP-ENV:Body>
    <ns1:executeCommand xmlns:ns1="urn:TC">
      <command>${escapeXml(command)}</command>
    </ns1:executeCommand>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>`;
}

function buildSoapFaultError(xml) {
  const m = xml.match(/<faultstring[^>]*>([\s\S]*?)<\/faultstring>/i);
  if (!m) return null;
  const msg = m[1].trim();
  const err = new Error(msg);
  err.name = 'SOAPFault';
  return err;
}

async function callSoap(command) {
  const xml = buildSoapEnvelope(command);
  const auth = Buffer.from(`${CONFIG.TC_SOAP_USER}:${CONFIG.TC_SOAP_PASS}`).toString('base64');
  const resp = await fetch(`http://${CONFIG.TC_SOAP_HOST}:${CONFIG.TC_SOAP_PORT}/`, {
    method: 'POST',
    headers: {
      'Content-Type': 'text/xml; charset=utf-8',
      'Authorization': `Basic ${auth}`,
    },
    body: xml,
  });
  const text = await resp.text();
  const fault = buildSoapFaultError(text);
  if (fault) throw fault; // prefer SOAP-level semantics
  if (!resp.ok) {
    console.error('SOAP HTTP error', resp.status, resp.statusText, '\nBody:\n', text);
    throw new Error(`SOAP HTTP ${resp.status}`);
  }
  return text;
}

function extractSoapReturn(text) {
  const m = text.match(/<return[^>]*>([\s\S]*?)<\/return>/i);
  return m ? m[1].trim() : text.trim();
}

const q = s => String(s);

function stripEntities(s) {
  return String(s).replace(/&[a-z]+;|&#\d+;/gi, ' ').replace(/\s+/g, ' ').trim();
}

function looksUnknownOrUsage(msg) {
  return /unknown command|no such command|usage:/i.test(msg);
}

// ------ TrinityCore ops (idempotent) ------
async function tcSetPassword(identifier, newPassword) {
  const tries = [
    `bnetaccount set password ${q(identifier)} ${q(newPassword)} ${q(newPassword)}`,
    `account set password ${q(identifier)} ${q(newPassword)} ${q(newPassword)}`
  ];
  let last = '';
  for (const cmd of tries) {
    const raw = await callSoap(cmd).catch(e => e);
    if (raw instanceof Error) { last = String(raw.message||''); continue; }
    const msg = extractSoapReturn(raw);
    last = msg;
    if (!looksUnknownOrUsage(msg)) return raw; // success path
  }
  return last;
}

async function tcBnetLookup(email) {
  const raw = await callSoap(`bnetaccount lookup ${q(email)}`).catch(e => e);
  if (raw instanceof Error) return { exists: false, message: String(raw.message||'') };
  const msg = stripEntities(extractSoapReturn(raw)).toLowerCase();
  if (/not found|no account|0 results/.test(msg)) return { exists: false, message: msg };
  return { exists: true, message: msg };
}

}

async function tcCreateOrReset_BNET(email, password) {
  // 1) If exists -> reset pw; else create
  const look = await tcBnetLookup(email);
  if (look.exists) {
    await tcSetPassword(email, password);
  } else {
    const out = await callSoap(`bnetaccount create ${q(email)} ${q(password)}`);
    const msg = stripEntities(extractSoapReturn(out));
    if (/already exists/i.test(msg)) {
      await tcSetPassword(email, password);
    }
  }
  // 2) Ensure at least one retail game account exists
  // first WoW game account (#1) is created automatically by `bnetaccount create` on master
}

async function tcCreateOrReset_CLASSIC(email, password) {
  // Classic auth (no Battle.net)
  try {
    const out = await callSoap(`account create ${q(email)} ${q(password)}`);
    const msg = stripEntities(extractSoapReturn(out));
    if (/already exists/i.test(msg)) {
      await tcSetPassword(email, password);
    }
  } catch (e) {
    if (e?.name === 'SOAPFault' && /already exists/i.test(String(e.message||''))) {
      await tcSetPassword(email, password);
    } else {
      throw e;
    }
  }
}

let CAP_CACHE = { checked: false, bnet: false };
async function tcSupportsBNET() {
  if (CAP_CACHE.checked) return CAP_CACHE.bnet;
  const probe = await callSoap('bnetaccount help').catch(e => e);
  CAP_CACHE.checked = true;
  if (probe instanceof Error) { CAP_CACHE.bnet = false; return false; }
  const msg = stripEntities(extractSoapReturn(probe));
  CAP_CACHE.bnet = !/unknown command|no such command/i.test(msg);
  return CAP_CACHE.bnet;
}

async function tcEnsureAccount(email, password) {
  if (await tcSupportsBNET()) {
    return await tcCreateOrReset_BNET(email, password);
  } else {
    return await tcCreateOrReset_CLASSIC(email, password);
  }
}

app.get('/api/status', async (req, res) => {
  try {
    const out = await callSoap('server info');
    res.json({ ok: true, info: extractSoapReturn(out) });
  } catch (e) {
    res.status(500).json({ ok: false, error: String(e) });
  }
});

app.post('/api/login', loginLimiter, async (req, res) => {
  try {
    const { email, password } = req.body || {};
    if (!isValidEmail(email)) return badRequest(res, 'Invalid email');
    if (typeof password !== 'string' || !password.length) return badRequest(res, 'Invalid password');

    const account = await getAuthAccountByEmail(email);
    if (!account) {
      console.warn('Suspicious login attempt (no account)', {
        target: maskEmail(email),
        ip: req.ip,
      });
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    let storedHash = null;
    if (account.sha_pass_hash != null) {
      if (typeof account.sha_pass_hash === 'string') {
        storedHash = account.sha_pass_hash;
      } else if (Buffer.isBuffer(account.sha_pass_hash)) {
        const ascii = account.sha_pass_hash.toString('utf8');
        storedHash = /^[0-9a-fA-F]+$/.test(ascii) ? ascii : account.sha_pass_hash.toString('hex');
      } else {
        storedHash = String(account.sha_pass_hash);
      }
    }

    const salt = account.salt ? Buffer.from(account.salt) : null;
    const verifier = account.verifier ? Buffer.from(account.verifier) : null;

    const matches = matchesSrpHash({ storedHash, salt, verifier }, email, password);
    if (!matches) {
      console.warn('Suspicious login attempt (hash mismatch)', {
        target: maskEmail(email),
        ip: req.ip,
      });
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const session = await persistSession(account.id, email, req);
    const maxAge = CONFIG.SESSION_TTL_HOURS * 60 * 60 * 1000;
    res.cookie(CONFIG.SESSION_COOKIE_NAME, session.token, {
      httpOnly: true,
      sameSite: 'lax',
      secure: CONFIG.COOKIE_SECURE,
      maxAge,
    });

    return res.json({
      ok: true,
      accountId: account.id,
      session: {
        token: session.token,
        expiresAt: session.expiresAt,
      },
    });
  } catch (e) {
    console.error('Login error', e);
    return res.status(500).json({ error: 'Unable to login' });
  }
});

app.get('/api/session', requireSession, (req, res) => {
  res.json({ ok: true, session: { accountId: req.session.account_id, email: req.session.email, expiresAt: req.session.expires_at } });
});

app.get('/api/characters', requireSession, async (req, res) => {
  try {
    const accountId = req.session?.account_id;
    const cacheKey = accountId != null ? String(accountId) : null;
    if (cacheKey) {
      const cached = CHARACTER_CACHE.get(cacheKey);
      if (cached && cached.expiresAt > Date.now()) {
        return res.json(cached.payload);
      }
    }

    const payload = await buildCharactersResponse(accountId);

    if (cacheKey) {
      CHARACTER_CACHE.set(cacheKey, {
        expiresAt: Date.now() + CHARACTER_CACHE_TTL,
        payload,
      });
    }

    return res.json(payload);
  } catch (e) {
    console.error('Character roster lookup failed', e);
    return res.status(500).json({ error: 'Unable to load characters' });
  }
});

// ----- API: Register -----
app.post('/api/register', limiter, async (req, res) => {
  try {
    const { password, email, cfToken } = req.body || {};

    if (!isValidPassword(password)) return badRequest(res, 'Invalid password');
    if (!isValidEmail(email)) return badRequest(res, 'Invalid email');

    const ok = await verifyTurnstile(cfToken, req.ip);
    if (!ok) return badRequest(res, 'CAPTCHA failed');

    // Upsert a single pending row per email (prevents duplicate verify links)
    const token = crypto.randomBytes(24).toString('hex');
    const now = Date.now();
    const safeUser = email.split('@')[0].slice(0, CONFIG.MAX_USER) || 'player';
    await pool.execute(
      'INSERT INTO pending (token, username, password, email, created_at) VALUES (?, ?, ?, ?, ?)\n       ON DUPLICATE KEY UPDATE token = VALUES(token), username = VALUES(username), password = VALUES(password), created_at = VALUES(created_at)',
      [token, safeUser, password, email, now]
    );

    const verifyUrl = `${CONFIG.BASE_URL}/verify?token=${token}`;
    const safeEmail = escapeHtml(email);
    const html = `
      <div style="font-family:system-ui,Segoe UI,Roboto,Helvetica,Arial,sans-serif">
        <h2>${CONFIG.BRAND_NAME} — Verify your email</h2>
        <p>Click to complete your account creation for <b>${safeEmail}</b>:</p>
        <p><a href="${verifyUrl}">Finish registration</a></p>
        <p>This link expires in ${CONFIG.TOKEN_TTL_MIN} minutes.</p>
      </div>`;

    await transporter.sendMail({
      to: email,
      from: CONFIG.FROM_EMAIL,
      subject: `${CONFIG.BRAND_NAME}: confirm your account`,
      html,
    });

    return res.json({ ok: true });
  } catch (e) {
    console.error(e);
    return res.status(500).json({ error: 'Server error' });
  }
});

// ----- Verify link -----
app.get('/verify', async (req, res) => {
  try {
    const token = String(req.query.token || '');
    if (!token) {
      return res
        .status(400)
        .type('text/html')
        .send(
          VERIFY_PAGE({
            state: 'error',
            title: 'Invalid verification link',
            message: 'The verification link is missing a token or was formatted incorrectly.',
            steps: [
              'Return to the registration page and request a new verification email.',
              'If you continue to see this message, contact support so we can assist you manually.',
            ],
          })
        );
    }

    const [rows] = await pool.execute('SELECT * FROM pending WHERE token = ?', [token]);
    const row = Array.isArray(rows) ? rows[0] : undefined;
    if (!row) {
      return res
        .status(400)
        .type('text/html')
        .send(
          VERIFY_PAGE({
            state: 'expired',
            title: 'Verification link not found',
            message: 'This verification link has already been used or does not match any pending registration.',
            steps: [
              'Head back to the registration page to start a new signup.',
              'Use the most recent verification email—older links immediately deactivate once a new one is issued.',
            ],
          })
        );
    }

    const ageMin = (Date.now() - row.created_at) / 60000;
    if (ageMin > CONFIG.TOKEN_TTL_MIN) {
      await pool.execute('DELETE FROM pending WHERE token = ?', [token]);
      return res
        .status(400)
        .type('text/html')
        .send(
          VERIFY_PAGE({
            state: 'expired',
            title: 'Verification link expired',
            message: `This link expired after ${CONFIG.TOKEN_TTL_MIN} minutes for your security.`,
            steps: [
              'Revisit the registration page and submit the form again to receive a fresh email.',
              'Complete verification promptly to finalize your DreamCore account.',
            ],
          })
        );
    }

    // Create/reset TC account now (idempotent) + ensure gameaccount
    try {
      await tcEnsureAccount(row.email, row.password);
    } catch (e) {
      console.error('SOAP create/reset failed:', e);
      return res
        .status(502)
        .type('text/html')
        .send(
          VERIFY_PAGE({
            state: 'error',
            title: 'Unable to finalize your account',
            message: 'Our account service had trouble completing the setup. No worries—your email is still reserved.',
            steps: [
              'Wait a moment and try the verification link again.',
              'If the issue persists, open a support ticket so we can complete the registration for you.',
            ],
          })
        );
    }

    // Consume token (best-effort)
    await pool.execute('DELETE FROM pending WHERE token = ?', [token]);

    return res
      .type('text/html')
      .send(
        VERIFY_PAGE({
          state: 'success',
          title: 'Account verified!',
          message: `Your DreamCore login <strong>${escapeHtml(row.email)}</strong> is now active.`,
          successSteps: [
            {
              number: 2,
              title: 'Verification completed',
              body: [
                "Nice work—you've finished Step 2.",
                'Your DreamCore account is active and ready for the final client setup steps below.',
              ],
            },
            {
              number: 3,
              title: 'Review the DreamCore guide & latest updates',
              body: [
                "Before you dive in, read through the DreamCore guide that covers launcher tips, shortcut setup, and any hotfixes we've published.",
                'Bookmark the page so you always have the newest client download links, bug fixes, and community news in one place.',
              ],
              cta: CONFIG.GUIDE_URL ? { href: CONFIG.GUIDE_URL, label: 'Open DreamCore Guide & Updates' } : null,
            },
          ],
        })
      );
  } catch (e) {
    console.error(e);
    return res
      .status(500)
      .type('text/html')
      .send(
        VERIFY_PAGE({
          state: 'error',
          title: 'Something went wrong',
          message: 'An unexpected error occurred while checking your verification link.',
          steps: [
            'Wait a minute and refresh this page.',
            'If the problem continues, please open a support ticket so we can finish creating your account.',
          ],
        })
      );
  }
});

function escapeHtml(s){return s.replace(/[&<>"']/g,c=>({"&":"&amp;","<":"&lt;",">":"&gt;","\"":"&quot;","'":"&#39;"}[c]))}

function VERIFY_PAGE({ state, title, message, steps, successSteps }) {
  const tone = {
    success: {
      badge: 'Verified',
      badgeGradient: 'from-emerald-400 via-green-400 to-teal-400',
      border: 'border-emerald-400/40',
      glow: 'shadow-emerald-900/30',
      highlight: 'text-emerald-300',
      icon: '✓',
    },
    expired: {
      badge: 'Link expired',
      badgeGradient: 'from-amber-400 via-orange-400 to-rose-400',
      border: 'border-amber-400/40',
      glow: 'shadow-amber-900/30',
      highlight: 'text-amber-300',
      icon: '⌛',
    },
    error: {
      badge: 'Action needed',
      badgeGradient: 'from-rose-500 via-red-500 to-pink-500',
      border: 'border-rose-400/40',
      glow: 'shadow-rose-900/30',
      highlight: 'text-rose-300',
      icon: '⚠',
    },
  }[state] || {
    badge: 'Update',
    badgeGradient: 'from-indigo-400 via-purple-400 to-blue-400',
    border: 'border-indigo-400/40',
    glow: 'shadow-indigo-900/30',
    highlight: 'text-indigo-300',
    icon: 'ℹ',
  };

  const stepsList =
    state !== 'success' && Array.isArray(steps) && steps.length
      ? `<ol class="mt-6 space-y-3 text-sm text-indigo-100/90 list-decimal list-inside">${steps
          .map(
            (step) =>
              `<li class="leading-relaxed">${step.replace(
                /<(?!\/?(a|strong)\b)[^>]*>/gi,
                ''
              )}</li>`
          )
          .join('')}</ol>`
      : '';

  const successGuide =
    state === 'success' && Array.isArray(successSteps) && successSteps.length
      ? `<div class="mt-8 space-y-6">${successSteps
          .map((step, idx) => {
            const number = escapeHtml(String(step.number ?? idx + 1));
            const title = escapeHtml(String(step.title || 'Step'));
            const bodyArr = Array.isArray(step.body) ? step.body : [];
            const bodyHtml = bodyArr
              .map((paragraph, pIdx) => {
                const spacing = pIdx === 0 ? 'mt-4' : 'mt-3';
                return `<p class="${spacing} text-[15px] text-indigo-100/90">${escapeHtml(
                  String(paragraph || '')
                )}</p>`;
              })
              .join('');
            const cta = step.cta && step.cta.href
              ? `<a class="mt-5 inline-flex items-center justify-center rounded-2xl ${
                  idx === 0
                    ? 'border border-indigo-400/60 bg-gray-900/70 px-5 py-3 text-[15px] font-semibold text-indigo-200 hover:bg-indigo-500/20 hover:text-white shadow-lg shadow-indigo-900/40'
                    : 'bg-gradient-to-r from-blue-500 via-purple-500 to-indigo-500 px-5 py-3.5 text-[15px] font-semibold text-white shadow-xl shadow-indigo-900/40 hover:from-blue-400 hover:via-purple-400 hover:to-indigo-400 focus:ring-2 focus:ring-indigo-400'
                }" href="${escapeHtml(String(step.cta.href))}" target="_blank" rel="noopener">${escapeHtml(
                  String(step.cta.label || 'Learn more')
                )}</a>`
              : '';
            const wrapperClasses = idx === 0
              ? 'rounded-3xl border border-purple-500/40 bg-indigo-500/10 p-6 backdrop-blur-sm'
              : 'rounded-3xl border border-indigo-500/40 bg-gray-900/60 p-6 shadow-inner shadow-indigo-900/30';
            return `<section class="${wrapperClasses}"><div class="flex items-center gap-4"><span class="flex h-10 w-10 items-center justify-center rounded-full bg-gradient-to-br from-indigo-500 via-purple-500 to-blue-500 text-lg font-semibold text-white shadow-lg shadow-indigo-900/40">${number}</span><div><h2 class="text-lg font-semibold text-white">${title}</h2><p class="text-[15px] text-indigo-100/90">Follow this step before moving on.</p></div></div>${bodyHtml}${cta}</section>`;
          })
          .join('')}</div>`
      : '';

  const safeMessage = message.replace(/<(?!\/?(a|strong)\b)[^>]*>/gi, '');

  return `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>${CONFIG.HEADER_TITLE} — Verification</title>
  <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
  <style>
    body {
      background: radial-gradient(circle at top, rgba(76, 29, 149, 0.25), rgba(15, 23, 42, 0.95));
    }
    .aurora::before {
      content: "";
      position: fixed;
      inset: -30%;
      background: conic-gradient(from 90deg at 50% 50%, rgba(99, 102, 241, 0.35), rgba(14, 165, 233, 0.2), rgba(236, 72, 153, 0.25), rgba(99, 102, 241, 0.35));
      filter: blur(120px);
      opacity: 0.4;
      animation: aurora-shift 24s linear infinite;
      z-index: 0;
      pointer-events: none;
    }
    @keyframes aurora-shift {
      0% { transform: rotate(0deg) scale(1.1); }
      50% { transform: rotate(180deg) scale(1.2); }
      100% { transform: rotate(360deg) scale(1.1); }
    }
  </style>
</head>
<body class="min-h-screen text-gray-100 flex items-center justify-center p-6 aurora relative overflow-x-hidden">
  <div class="absolute top-6 left-6 text-2xl sm:text-3xl font-semibold tracking-[0.3em] text-indigo-300 drop-shadow-lg z-20 uppercase">${CONFIG.CORNER_LOGO}</div>
  <div class="w-full max-w-xl relative z-10">
    <div class="bg-gray-900/80 backdrop-blur-xl rounded-3xl shadow-2xl border ${tone.border} overflow-hidden">
      <div class="px-6 pt-8 pb-10 sm:px-10">
        <span class="inline-flex items-center gap-2 rounded-full bg-gradient-to-r ${tone.badgeGradient} px-4 py-1 text-xs font-semibold uppercase tracking-[0.3em] text-gray-900 shadow-lg shadow-indigo-900/30">${tone.icon} ${tone.badge}</span>
        <h1 class="mt-6 text-3xl font-semibold tracking-tight text-white">${title}</h1>
        <p class="mt-3 text-[15px] text-indigo-100/90">${safeMessage}</p>
        ${stepsList}
        ${successGuide}
      </div>
      <div class="bg-gray-900/70 border-t ${tone.border} px-6 py-5 sm:px-10">
        <p class="text-xs text-indigo-200/80">Need a hand? Contact the DreamCore team and mention this verification message for quicker help.</p>
      </div>
    </div>
  </div>
</body>
</html>`;
}

// ----- Housekeeping: cleanup expired tokens hourly -----
setInterval(async () => {
  const cutoff = Date.now() - CONFIG.TOKEN_TTL_MIN * 60000;
  const now = Date.now();
  try { await pool.execute('DELETE FROM pending WHERE created_at < ?', [cutoff]); } catch (e) {
    console.error('Failed to prune pending tokens', e);
  }
  try { await pool.execute('DELETE FROM sessions WHERE expires_at <= ?', [now]); } catch (e) {
    console.error('Failed to prune sessions', e);
  }
}, 60 * 60 * 1000);

// ----- Start -----
app.listen(CONFIG.PORT, () => {
  console.log(`\n✔ ${CONFIG.BRAND_NAME} registration app listening on :${CONFIG.PORT}`);
  console.log(`   Public URL (BASE_URL): ${CONFIG.BASE_URL}`);
  console.log(`   Turnstile sitekey: ${CONFIG.TURNSTILE_SITEKEY}`);
  console.log(`\nExample systemd unit (save as /etc/systemd/system/tc-register.service):\n`);
  console.log(`[Unit]\nDescription=TrinityCore Self-Serve Registration\nAfter=network.target\n\n[Service]\nType=simple\nWorkingDirectory=${process.cwd()}\nExecStart=/usr/bin/node ${process.cwd()}/server.js\nRestart=always\nEnvironment=PORT=${CONFIG.PORT}\nEnvironment=BASE_URL=${CONFIG.BASE_URL}\nEnvironment=TC_SOAP_HOST=${CONFIG.TC_SOAP_HOST}\nEnvironment=TC_SOAP_PORT=${CONFIG.TC_SOAP_PORT}\nEnvironment=TC_SOAP_USER=${CONFIG.TC_SOAP_USER}\nEnvironment=TC_SOAP_PASS=${CONFIG.TC_SOAP_PASS}\nEnvironment=TURNSTILE_SITEKEY=${CONFIG.TURNSTILE_SITEKEY}\nEnvironment=TURNSTILE_SECRET=${CONFIG.TURNSTILE_SECRET}\nEnvironment=SMTP_HOST=${CONFIG.SMTP_HOST}\nEnvironment=SMTP_PORT=${CONFIG.SMTP_PORT}\nEnvironment=SMTP_SECURE=${CONFIG.SMTP_SECURE}\nEnvironment=SMTP_USER=${CONFIG.SMTP_USER}\nEnvironment=SMTP_PASS=${CONFIG.SMTP_PASS}\nEnvironment=FROM_EMAIL=${CONFIG.FROM_EMAIL}\nEnvironment=BRAND_NAME=${CONFIG.BRAND_NAME}\nEnvironment=DB_HOST=${DB.HOST}\nEnvironment=DB_PORT=${DB.PORT}\nEnvironment=DB_USER=${DB.USER}\nEnvironment=DB_PASS=${DB.PASS}\nEnvironment=DB_NAME=${DB.NAME}\nEnvironment=AUTH_DB_HOST=${AUTH_DB.HOST}\nEnvironment=AUTH_DB_PORT=${AUTH_DB.PORT}\nEnvironment=AUTH_DB_USER=${AUTH_DB.USER}\nEnvironment=AUTH_DB_PASS=${AUTH_DB.PASS}\nEnvironment=AUTH_DB_NAME=${AUTH_DB.NAME}\nEnvironment=CHAR_DB_HOST=${CHAR_DB.HOST}\nEnvironment=CHAR_DB_PORT=${CHAR_DB.PORT}\nEnvironment=CHAR_DB_USER=${CHAR_DB.USER}\nEnvironment=CHAR_DB_PASS=${CHAR_DB.PASS}\nEnvironment=CHAR_DB_NAME=${CHAR_DB.NAME}\nEnvironment=SESSION_TTL_HOURS=${CONFIG.SESSION_TTL_HOURS}\nEnvironment=SESSION_COOKIE_NAME=${CONFIG.SESSION_COOKIE_NAME}\nEnvironment=COOKIE_SECURE=${CONFIG.COOKIE_SECURE}\n\n[Install]\nWantedBy=multi-user.target\n`);
});
