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
  BASE_URL: process.env.BASE_URL || 'https://your-bridge.example.com', // public URL for verify links
  // TrinityCore SOAP creds (use a dedicated non-playing GM account)
  TC_SOAP_HOST: process.env.TC_SOAP_HOST || '127.0.0.1',
  TC_SOAP_PORT: Number(process.env.TC_SOAP_PORT || 7878),
  TC_SOAP_USER: process.env.TC_SOAP_USER || 'gm_account_name',
  TC_SOAP_PASS: process.env.TC_SOAP_PASS || 'gm_account_password',
  // Optional: set default expansion after create (integer). Leave undefined to skip.
  DEFAULT_EXPANSION: process.env.DEFAULT_EXPANSION ? Number(process.env.DEFAULT_EXPANSION) : undefined,
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
  BRAND_NAME: process.env.BRAND_NAME || 'Your Realm',
  // Registration constraints
  MIN_USER: Number(process.env.MIN_USER || 3),
  MAX_USER: Number(process.env.MAX_USER || 20),
  MIN_PASS: Number(process.env.MIN_PASS || 8),
  MAX_PASS: Number(process.env.MAX_PASS || 72),
  TOKEN_TTL_MIN: Number(process.env.TOKEN_TTL_MIN || 30), // minutes
};

// ----- DB (MariaDB for pending verifications) -----
import mysql from 'mysql2/promise';

const DB = {
  HOST: process.env.DB_HOST || '127.0.0.1',
  PORT: Number(process.env.DB_PORT || 3306),
  USER: process.env.DB_USER || 'trinity',
  PASS: process.env.DB_PASS || 'trinity_password',
  NAME: process.env.DB_NAME || 'tc_register',
};

const pool = await mysql.createPool({
  host: DB.HOST,
  port: DB.PORT,
  user: DB.USER,
  password: DB.PASS,
  waitForConnections: true,
  connectionLimit: 10,
  namedPlaceholders: true,
  multipleStatements: true,
});

// Ensure database & table exist
await pool.query(`CREATE DATABASE IF NOT EXISTS \`${DB.NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`);
await pool.query(`USE \`${DB.NAME}\`;`);
await pool.query(`
  CREATE TABLE IF NOT EXISTS pending (
    token VARCHAR(64) PRIMARY KEY,
    username VARCHAR(32) NOT NULL,
    password VARCHAR(128) NOT NULL,
    email VARCHAR(254) NOT NULL,
    created_at BIGINT NOT NULL,
    KEY idx_created_at (created_at)
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
app.set('trust proxy', true);
app.use(express.json());

// Rate limit register endpoint (per IP)
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 20,
  standardHeaders: true,
  legacyHeaders: false,
});

// ----- UI (modern, minimal, responsive) -----
const REG_PAGE = () => `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>${CONFIG.BRAND_NAME} — Create Account</title>
  <script src="https://challenges.cloudflare.com/turnstile/v0/api.js" defer></script>
  <script>
    window.TURNSTILE_SITEKEY = ${JSON.stringify(CONFIG.TURNSTILE_SITEKEY)};
  </script>
  <script src="/client.js" defer></script>
  <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="min-h-screen bg-gray-950 text-gray-100 flex items-center justify-center p-4">
  <div class="w-full max-w-md">
    <div class="bg-gray-900/70 backdrop-blur rounded-2xl shadow-xl border border-gray-800">
      <div class="p-6 sm:p-8">
        <h1 class="text-2xl font-semibold tracking-tight">Create your account</h1>
        <p class="text-sm text-gray-400 mt-1">for <span class="font-medium">${CONFIG.BRAND_NAME}</span></p>
        <form id="regForm" class="mt-6 space-y-4">
          <div>
            <label class="block text-sm mb-1" for="username">Username</label>
            <input id="username" name="username" required minlength="${CONFIG.MIN_USER}" maxlength="${CONFIG.MAX_USER}"
                   class="w-full rounded-xl bg-gray-800/70 border border-gray-700 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 p-3" placeholder="Your username" />
          </div>
          <div>
            <label class="block text-sm mb-1" for="email">Email</label>
            <input id="email" type="email" name="email" required
                   class="w-full rounded-xl bg-gray-800/70 border border-gray-700 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 p-3" placeholder="you@example.com" />
          </div>
          <div>
            <label class="block text-sm mb-1" for="password">Password</label>
            <input id="password" type="password" name="password" required minlength="${CONFIG.MIN_PASS}" maxlength="${CONFIG.MAX_PASS}"
                   class="w-full rounded-xl bg-gray-800/70 border border-gray-700 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 p-3" placeholder="••••••••" />
            <p class="text-xs text-gray-500 mt-1">${CONFIG.MIN_PASS}+ characters.</p>
          </div>
          <div class="mt-2" id="cf-box">
            <div class="cf-turnstile" data-sitekey="${CONFIG.TURNSTILE_SITEKEY}" data-theme="auto"></div>
          </div>
          <button class="w-full py-3 rounded-xl bg-indigo-600 hover:bg-indigo-500 focus:ring-2 focus:ring-indigo-400 active:bg-indigo-700 transition font-medium" type="submit">Create account</button>
        </form>
        <pre id="msg" class="mt-4 text-sm whitespace-pre-wrap text-gray-300"></pre>
      </div>
    </div>
    <p class="text-center text-xs text-gray-500 mt-4">Protected by Cloudflare Turnstile · No public SOAP exposure</p>
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
      username: document.getElementById('username').value.trim(),
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
function isValidUsername(u) {
  if (typeof u !== 'string') return false;
  if (u.length < CONFIG.MIN_USER || u.length > CONFIG.MAX_USER) return false;
  // Alnum + _ - . only (adjust if your realm allows spaces etc.)
  return /^[A-Za-z0-9_.-]+$/.test(u);
}
function isValidPassword(p) {
  return typeof p === 'string' && p.length >= CONFIG.MIN_PASS && p.length <= CONFIG.MAX_PASS;
}
function isValidEmail(e) {
  return typeof e === 'string' && /.+@.+\..+/.test(e) && e.length <= 254;
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

function buildSoapEnvelope(command) {
  return `<?xml version="1.0" encoding="utf-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:TC" xmlns:xsd="http://www.w3.org/1999/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
  <SOAP-ENV:Body>
    <ns1:executeCommand>
      <command>${command}</command>
    </ns1:executeCommand>
  </SOAP-ENV:Body>
</SOAP-ENV:Envelope>`;
}

async function callSoap(command) {
  const xml = buildSoapEnvelope(command);
  const auth = Buffer.from(`${CONFIG.TC_SOAP_USER}:${CONFIG.TC_SOAP_PASS}`).toString('base64');
  const resp = await fetch(`http://${CONFIG.TC_SOAP_HOST}:${CONFIG.TC_SOAP_PORT}/`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/xml',
      'Authorization': `Basic ${auth}`
    },
    body: xml,
  });
  const text = await resp.text();
  if (!resp.ok) {
    throw new Error(`SOAP HTTP ${resp.status}: ${text.slice(0, 200)}`);
  }
  return text;
}

async function tcCreateAccount(username, password) {
  // TrinityCore console command: account create <user> <pass>
  const out = await callSoap(`account create ${username} ${password}`);
  // Optional: set expansion if configured
  if (Number.isInteger(CONFIG.DEFAULT_EXPANSION)) {
    try { await callSoap(`account set expansion ${username} ${CONFIG.DEFAULT_EXPANSION}`); } catch {}
  }
  return out;
}

// ----- API: Register -----
app.post('/api/register', limiter, async (req, res) => {
  try {
    const { username, password, email, cfToken } = req.body || {};

    if (!isValidUsername(username)) return badRequest(res, 'Invalid username');
    if (!isValidPassword(password)) return badRequest(res, 'Invalid password');
    if (!isValidEmail(email)) return badRequest(res, 'Invalid email');

    const ok = await verifyTurnstile(cfToken, req.ip);
    if (!ok) return badRequest(res, 'CAPTCHA failed');

    // Create a pending token, send email
    const token = crypto.randomBytes(24).toString('hex');
    const now = Date.now();
    await pool.execute(
      'INSERT INTO pending (token, username, password, email, created_at) VALUES (?, ?, ?, ?, ?)',
      [token, username, password, email, now]
    );

    const verifyUrl = `${CONFIG.BASE_URL}/verify?token=${token}`;
    const html = `
      <div style="font-family:system-ui,Segoe UI,Roboto,Helvetica,Arial,sans-serif">
        <h2>${CONFIG.BRAND_NAME} — Verify your email</h2>
        <p>Click to complete your account creation for <b>${username}</b>:</p>
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
    if (!token) return res.status(400).type('text/html').send('<pre>Invalid token</pre>');

    const [rows] = await pool.execute('SELECT * FROM pending WHERE token = ?', [token]);
    const row = Array.isArray(rows) ? rows[0] : undefined;
    if (!row) return res.status(400).type('text/html').send('<pre>Link is invalid or already used.</pre>');

    const ageMin = (Date.now() - row.created_at) / 60000;
    if (ageMin > CONFIG.TOKEN_TTL_MIN) {
      await pool.execute('DELETE FROM pending WHERE token = ?', [token]);
      return res.status(400).type('text/html').send('<pre>Link expired. Please register again.</pre>');
    }

    // Create real TC account now
    let resultText = '';
    try {
      resultText = await tcCreateAccount(row.username, row.password);
    } catch (e) {
      console.error('SOAP create failed:', e);
      return res.status(502).type('text/html').send('<pre>Account creation failed via SOAP. Please try again later.</pre>');
    }

    await pool.execute('DELETE FROM pending WHERE token = ?', [token]);

    return res.type('text/html').send(`<!doctype html><html><body style="font-family:system-ui"><h2>Success!</h2><p>Your account <b>${row.username}</b> has been created. You can now log in.</p><details><summary>Details</summary><pre>${escapeHtml(resultText).slice(0,4000)}</pre></details></body></html>`);
  } catch (e) {
    console.error(e);
    return res.status(500).type('text/html').send('<pre>Server error</pre>');
  }
});

function escapeHtml(s){return s.replace(/[&<>"']/g,c=>({"&":"&amp;","<":"&lt;",">":"&gt;","\"":"&quot;","'":"&#39;"}[c]))}

// ----- Housekeeping: cleanup expired tokens hourly -----
setInterval(async () => {
  const cutoff = Date.now() - CONFIG.TOKEN_TTL_MIN * 60000;
  try { await pool.execute('DELETE FROM pending WHERE created_at < ?', [cutoff]); } catch {}
}, 60 * 60 * 1000);

// ----- Start -----
app.listen(CONFIG.PORT, () => {
  console.log(`\n✔ ${CONFIG.BRAND_NAME} registration app listening on :${CONFIG.PORT}`);
  console.log(`   Public URL (BASE_URL): ${CONFIG.BASE_URL}`);
  console.log(`   Turnstile sitekey: ${CONFIG.TURNSTILE_SITEKEY}`);
  console.log(`\nExample systemd unit (save as /etc/systemd/system/tc-register.service):\n`);
  console.log(`[Unit]\nDescription=TrinityCore Self-Serve Registration\nAfter=network.target\n\n[Service]\nType=simple\nWorkingDirectory=${process.cwd()}\nExecStart=/usr/bin/node ${process.cwd()}/server.js\nRestart=always\nEnvironment=PORT=${CONFIG.PORT}\nEnvironment=BASE_URL=${CONFIG.BASE_URL}\nEnvironment=TC_SOAP_HOST=${CONFIG.TC_SOAP_HOST}\nEnvironment=TC_SOAP_PORT=${CONFIG.TC_SOAP_PORT}\nEnvironment=TC_SOAP_USER=${CONFIG.TC_SOAP_USER}\nEnvironment=TC_SOAP_PASS=${CONFIG.TC_SOAP_PASS}\nEnvironment=DEFAULT_EXPANSION=${CONFIG.DEFAULT_EXPANSION ?? ''}\nEnvironment=TURNSTILE_SITEKEY=${CONFIG.TURNSTILE_SITEKEY}\nEnvironment=TURNSTILE_SECRET=${CONFIG.TURNSTILE_SECRET}\nEnvironment=SMTP_HOST=${CONFIG.SMTP_HOST}\nEnvironment=SMTP_PORT=${CONFIG.SMTP_PORT}\nEnvironment=SMTP_SECURE=${CONFIG.SMTP_SECURE}\nEnvironment=SMTP_USER=${CONFIG.SMTP_USER}\nEnvironment=SMTP_PASS=${CONFIG.SMTP_PASS}\nEnvironment=FROM_EMAIL=${CONFIG.FROM_EMAIL}\nEnvironment=BRAND_NAME=${CONFIG.BRAND_NAME}\n\n[Install]\nWantedBy=multi-user.target\n`);
});
