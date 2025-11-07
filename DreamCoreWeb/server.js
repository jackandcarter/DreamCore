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
import {
  makeSoapConfig,
  ensureRetailAccount,
  executeRetailCommand,
  normalizeEmail,
  retailPasswordReset,
} from './lib/trinitySoap.js';

// ----- CONFIG (read from env or inline defaults for dev) -----
const CONFIG = {
  PORT: Number(process.env.PORT || 8787),
  BASE_URL: process.env.BASE_URL || 'https://wow.the-demiurge.com', // public URL for verify links

  // TrinityCore SOAP creds (use a dedicated non-playing GM account)
  TC_SOAP_HOST: process.env.TC_SOAP_HOST || '127.0.0.1',
  TC_SOAP_PORT: Number(process.env.TC_SOAP_PORT || 7878),
  TC_SOAP_USER: process.env.TC_SOAP_USER || 'gm_account_name',
  TC_SOAP_PASS: process.env.TC_SOAP_PASS || 'gm_account_password',
  SOAP_DEBUG: (process.env.SOAP_DEBUG || 'false').toLowerCase() === 'true',

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
  RESET_TOKEN_TTL_MIN: Number(process.env.RESET_TOKEN_TTL_MIN || 20), // minutes
  SESSION_TTL_HOURS: Number(process.env.SESSION_TTL_HOURS || 24),
  SESSION_COOKIE_NAME: process.env.SESSION_COOKIE_NAME || 'dreamcore_session',
  COOKIE_SECURE: (process.env.COOKIE_SECURE || 'true').toLowerCase() === 'true',
  CHARACTER_CACHE_TTL_MS: Number(process.env.CHARACTER_CACHE_TTL_MS || 30 * 1000),
};

const SOAP = makeSoapConfig({
  host: CONFIG.TC_SOAP_HOST,
  port: CONFIG.TC_SOAP_PORT,
  user: CONFIG.TC_SOAP_USER,
  pass: CONFIG.TC_SOAP_PASS,
});

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

await pool.query(`
  CREATE TABLE IF NOT EXISTS password_resets (
    token VARCHAR(64) PRIMARY KEY,
    email VARCHAR(254) NOT NULL,
    created_at BIGINT NOT NULL,
    expires_at BIGINT NOT NULL,
    KEY idx_email (email),
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

const passwordResetLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5,
  standardHeaders: true,
  legacyHeaders: false,
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
                <input id="password" type="password" name="password" required minlength="${CONFIG.MIN_PASS}" maxlength="${CONFIG.MAX_PASS}" pattern="[^\\s'\"]+" title="No spaces or quotes"
                       class="w-full rounded-2xl bg-gray-800/80 border border-gray-700 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-400 p-3 text-[15px] font-semibold text-indigo-200 focus:text-indigo-100 transition placeholder-indigo-300/60" placeholder="••••••••" />
                <p class="text-xs text-indigo-200/70 mt-2">${CONFIG.MIN_PASS}+ characters. No spaces or quotes. Your email becomes your DreamCore login.</p>
              </div>
              <div class="pt-2" id="cf-box">
                <div class="cf-turnstile" data-sitekey="${CONFIG.TURNSTILE_SITEKEY}" data-theme="auto"></div>
              </div>
              <div class="grid gap-3 sm:grid-cols-2">
                <button class="w-full py-3.5 rounded-2xl bg-gradient-to-r from-indigo-500 via-purple-500 to-blue-500 hover:from-indigo-400 hover:via-purple-400 hover:to-blue-400 focus:ring-2 focus:ring-indigo-400 active:scale-[0.99] transition font-semibold text-[15px] shadow-lg shadow-indigo-900/50" type="submit">Create account</button>
                <a class="inline-flex w-full items-center justify-center rounded-2xl border border-indigo-400/60 bg-gray-900/70 px-5 py-3.5 text-[15px] font-semibold text-indigo-100 transition hover:border-indigo-300 hover:text-white hover:bg-indigo-500/20 focus:outline-none focus:ring-2 focus:ring-indigo-400 active:scale-[0.99] shadow-lg shadow-indigo-900/40" href="/login">Log in</a>
              </div>
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

const clientScript = () => {
  const form = document.getElementById('regForm');
  const msg = document.getElementById('msg');
  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    msg.textContent = 'Submitting…';

    // Get Turnstile token
    const tokenEl = document.querySelector('.cf-turnstile input[name="cf-turnstile-response"]');
    const cfToken = tokenEl ? tokenEl.value : '';

    const rawPassword = document.getElementById('password').value;
    if (/\s/.test(rawPassword) || /['"]/.test(rawPassword)) {
      msg.textContent = 'Password cannot contain spaces or quotes.';
      return;
    }

    const payload = {
      email: document.getElementById('email').value.trim(),
      password: rawPassword,
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
};
const CLIENT_JS = `(${clientScript.toString()})();`;

const LOGIN_PAGE = () => `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>${CONFIG.HEADER_TITLE} — Login</title>
  <script src="/login.js" defer></script>
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
          <h1 class="text-4xl font-semibold tracking-tight text-white">Welcome back</h1>
          <span class="text-xs font-medium uppercase tracking-[0.4em] text-indigo-400">Login</span>
        </div>
        <p class="mt-3 text-[15px] text-gray-100 drop-shadow-sm">Sign in to manage your <span class="font-semibold text-indigo-400 drop-shadow">${CONFIG.BRAND_NAME}</span> account and view your characters.</p>

        <div class="mt-8 space-y-8">
          <section class="rounded-3xl border border-indigo-500/40 bg-gray-900/60 p-6 shadow-inner shadow-indigo-900/30">
            <div class="flex items-center gap-4">
              <span class="flex h-10 w-10 items-center justify-center rounded-full bg-gradient-to-br from-indigo-500 via-purple-500 to-blue-500 text-lg font-semibold text-white shadow-lg shadow-indigo-900/40">1</span>
              <div>
                <h2 class="text-lg font-semibold text-white">Log in to your account</h2>
                <p class="text-[15px] text-indigo-100/90">Use the email and password you verified during registration.</p>
              </div>
            </div>
            <form id="loginForm" class="mt-6 space-y-5">
              <div>
                <label class="block text-sm font-medium text-indigo-200 mb-1" for="loginEmail">Email</label>
                <input id="loginEmail" type="email" name="email" autocomplete="username" required
                       class="w-full rounded-2xl bg-gray-800/80 border border-gray-700 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-400 p-3 text-[15px] font-semibold text-indigo-200 focus:text-indigo-100 transition placeholder-indigo-300/60" placeholder="you@example.com" />
              </div>
              <div>
                <label class="block text-sm font-medium text-indigo-200 mb-1" for="loginPassword">Password</label>
                <input id="loginPassword" type="password" name="password" autocomplete="current-password" required
                       class="w-full rounded-2xl bg-gray-800/80 border border-gray-700 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-400 p-3 text-[15px] font-semibold text-indigo-200 focus:text-indigo-100 transition placeholder-indigo-300/60" placeholder="••••••••" />
              </div>
              <button id="loginSubmit" class="w-full py-3.5 rounded-2xl bg-gradient-to-r from-indigo-500 via-purple-500 to-blue-500 hover:from-indigo-400 hover:via-purple-400 hover:to-blue-400 focus:ring-2 focus:ring-indigo-400 active:scale-[0.99] transition font-semibold text-[15px] shadow-lg shadow-indigo-900/50" type="submit">Sign in</button>
            </form>
            <div class="mt-4 flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
              <a class="text-sm font-medium text-indigo-200 hover:text-white transition" href="/reset-password">Forgot your password?</a>
              <a class="text-sm text-indigo-200/80 hover:text-white transition" href="/">Need an account? Create one</a>
            </div>
            <pre id="loginMsg" class="mt-6 text-sm whitespace-pre-wrap text-indigo-100 bg-gray-900/70 border border-indigo-500/30 rounded-2xl p-4 min-h-[3rem] transition"></pre>
          </section>
        </div>
      </div>
    </div>
    <p class="text-center text-xs text-gray-500 mt-5">Protected by Cloudflare · DreamCore DemiDev Unit 2025 · DreamCore.exe shortcut by Azar</p>
  </div>
</body>
</html>`;

const loginScript = () => {
  const form = document.getElementById('loginForm');
  const msg = document.getElementById('loginMsg');
  const submit = document.getElementById('loginSubmit');

  async function checkSession() {
    try {
      const res = await fetch('/api/session', { credentials: 'same-origin' });
      if (res.ok) {
        window.location.href = '/account';
      }
    } catch (err) {
      console.error('Session check failed', err);
    }
  }

  function setLoading(state) {
    if (!submit) return;
    submit.disabled = state;
    submit.classList.toggle('opacity-60', state);
  }

  form?.addEventListener('submit', async (event) => {
    event.preventDefault();
    const email = document.getElementById('loginEmail')?.value.trim();
    const password = document.getElementById('loginPassword')?.value || '';

    if (!email || !password) {
      msg.textContent = 'Email and password are required.';
      return;
    }

    setLoading(true);
    msg.textContent = 'Signing in…';

    try {
      const res = await fetch('/api/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'same-origin',
        body: JSON.stringify({ email, password })
      });
      const data = await res.json().catch(() => ({}));
      if (!res.ok) {
        msg.textContent = data?.error ? 'Error: ' + data.error : 'Unable to login.';
        return;
      }
      msg.textContent = 'Login successful. Redirecting…';
      setTimeout(() => { window.location.href = '/account'; }, 600);
    } catch (err) {
      console.error('Login request failed', err);
      msg.textContent = 'Network error. Please try again.';
    } finally {
      setLoading(false);
    }
  });

  checkSession();
};
const LOGIN_JS = `(${loginScript.toString()})();`;

const ACCOUNT_PAGE = () => `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>${CONFIG.HEADER_TITLE} — Account Management</title>
  <script src="/account.js" defer></script>
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
  <div class="w-full max-w-2xl relative z-10">
    <div class="bg-gray-900/80 backdrop-blur-xl rounded-3xl shadow-2xl border border-indigo-500/20 overflow-hidden">
      <div class="px-6 pt-8 pb-10 sm:px-10">
        <div class="flex items-baseline justify-between">
          <h1 class="text-4xl font-semibold tracking-tight text-white">User Account Management</h1>
          <span class="text-xs font-medium uppercase tracking-[0.4em] text-indigo-400">Manage</span>
        </div>
        <p class="mt-3 text-[15px] text-gray-100 drop-shadow-sm">Update credentials and keep your <span class="font-semibold text-indigo-400 drop-shadow">${CONFIG.BRAND_NAME}</span> Battle.net account secure.</p>

        <div class="mt-8 space-y-8">
          <section class="rounded-3xl border border-indigo-500/40 bg-gray-900/60 p-6 shadow-inner shadow-indigo-900/30">
            <div class="flex items-center gap-4">
              <span class="flex h-10 w-10 items-center justify-center rounded-full bg-gradient-to-br from-indigo-500 via-purple-500 to-blue-500 text-lg font-semibold text-white shadow-lg shadow-indigo-900/40">1</span>
              <div>
                <h2 class="text-lg font-semibold text-white">Reset your Battle.net password</h2>
                <p class="text-[15px] text-indigo-100/90">Choose a new password below. This updates your in-game login immediately.</p>
              </div>
            </div>
            <form id="accountForm" class="mt-6 space-y-5">
              <div>
                <label class="block text-sm font-medium text-indigo-200 mb-1" for="accountEmail">Email</label>
                <input id="accountEmail" type="email" name="email" readonly
                       class="w-full rounded-2xl bg-gray-800/60 border border-gray-700 px-3 py-3 text-[15px] font-semibold text-indigo-200 focus:outline-none"
                       value="" />
              </div>
              <div>
                <label class="block text-sm font-medium text-indigo-200 mb-1" for="accountPassword">New password</label>
                <input id="accountPassword" type="password" name="password" required minlength="${CONFIG.MIN_PASS}" maxlength="${CONFIG.MAX_PASS}" pattern="[^\\s'\"]+" title="No spaces or quotes"
                       class="w-full rounded-2xl bg-gray-800/80 border border-gray-700 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-400 p-3 text-[15px] font-semibold text-indigo-200 focus:text-indigo-100 transition placeholder-indigo-300/60"
                       placeholder="••••••••" />
                <p class="text-xs text-indigo-200/70 mt-2">${CONFIG.MIN_PASS}+ characters. No spaces or quotes.</p>
              </div>
              <button id="resetSubmit" class="w-full py-3.5 rounded-2xl bg-gradient-to-r from-indigo-500 via-purple-500 to-blue-500 hover:from-indigo-400 hover:via-purple-400 hover:to-blue-400 focus:ring-2 focus:ring-indigo-400 active:scale-[0.99] transition font-semibold text-[15px] shadow-lg shadow-indigo-900/50" type="submit">Reset password</button>
            </form>
            <pre id="accountMsg" class="mt-6 text-sm whitespace-pre-wrap text-indigo-100 bg-gray-900/70 border border-indigo-500/30 rounded-2xl p-4 min-h-[3rem] transition"></pre>
          </section>

          <section class="rounded-3xl border border-indigo-500/40 bg-gray-900/60 p-6 shadow-inner shadow-indigo-900/30">
            <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
              <div>
                <h2 class="text-lg font-semibold text-white">Need to view your characters?</h2>
                <p class="text-[15px] text-indigo-100/90">Head to the roster dashboard to see every character linked to your account.</p>
              </div>
              <a class="inline-flex items-center justify-center rounded-2xl border border-indigo-400/60 bg-gray-900/70 px-5 py-3 text-[15px] font-semibold text-indigo-100 transition hover:border-indigo-300 hover:text-white hover:bg-indigo-500/20 focus:outline-none focus:ring-2 focus:ring-indigo-400 shadow-lg shadow-indigo-900/40" href="/characters">Open character roster</a>
            </div>
            <button id="accountLogout" class="mt-6 inline-flex items-center justify-center rounded-2xl border border-indigo-400/40 px-4 py-2 text-sm font-semibold text-indigo-100 hover:text-white hover:border-indigo-300 hover:bg-indigo-500/20 focus:outline-none focus:ring-2 focus:ring-indigo-400">Log out</button>
          </section>
        </div>
      </div>
    </div>
    <p class="text-center text-xs text-gray-500 mt-5">Protected by Cloudflare · DreamCore DemiDev Unit 2025 · DreamCore.exe shortcut by Azar</p>
  </div>
</body>
</html>`;

const accountScript = () => {
  const form = document.getElementById('accountForm');
  const emailInput = document.getElementById('accountEmail');
  const passwordInput = document.getElementById('accountPassword');
  const msg = document.getElementById('accountMsg');
  const submit = document.getElementById('resetSubmit');
  const logoutButton = document.getElementById('accountLogout');

  function setLoading(state) {
    if (!submit) return;
    submit.disabled = state;
    submit.classList.toggle('opacity-60', state);
  }

  async function loadSession() {
    try {
      const res = await fetch('/api/session', { credentials: 'same-origin' });
      if (res.status === 401) {
        window.location.href = '/login';
        return;
      }
      const data = await res.json().catch(() => ({}));
      const email = data?.session?.email;
      if (emailInput && email) {
        emailInput.value = email;
      }
    } catch (err) {
      console.error('Session lookup failed', err);
      window.location.href = '/login';
    }
  }

  form?.addEventListener('submit', async (event) => {
    event.preventDefault();
    const newPassword = passwordInput?.value || '';

    if (!newPassword) {
      msg.textContent = 'Please provide a new password.';
      return;
    }
    if (/\s/.test(newPassword) || /['"]/.test(newPassword)) {
      msg.textContent = 'Password cannot contain spaces or quotes.';
      return;
    }
    if (newPassword.length < ${CONFIG.MIN_PASS}) {
      msg.textContent = `Password must be at least ${CONFIG.MIN_PASS} characters.`;
      return;
    }

    setLoading(true);
    msg.textContent = 'Submitting password reset…';

    try {
      const res = await fetch('/api/account/reset-password', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'same-origin',
        body: JSON.stringify({ newPassword }),
      });
      const data = await res.json().catch(() => ({}));
      if (!res.ok) {
        msg.textContent = data?.error ? 'Error: ' + data.error : 'Unable to reset password.';
        return;
      }
      msg.textContent = 'Password reset successfully. Use this new password the next time you log in.';
      if (passwordInput) {
        passwordInput.value = '';
      }
    } catch (err) {
      console.error('Password reset failed', err);
      msg.textContent = 'Network error. Please try again.';
    } finally {
      setLoading(false);
    }
  });

  logoutButton?.addEventListener('click', async () => {
    try {
      await fetch('/api/logout', { method: 'POST', credentials: 'same-origin' });
    } catch (err) {
      console.error('Logout failed', err);
    } finally {
      window.location.href = '/login';
    }
  });

  loadSession();
};
const ACCOUNT_JS = `(${accountScript.toString()})();`;

const RESET_PAGE = () => `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>${CONFIG.HEADER_TITLE} — Reset Password</title>
  <script src="/reset.js" defer></script>
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
          <h1 class="text-4xl font-semibold tracking-tight text-white">Reset your password</h1>
          <span class="text-xs font-medium uppercase tracking-[0.4em] text-indigo-400">Security</span>
        </div>
        <p class="mt-3 text-[15px] text-gray-100 drop-shadow-sm">Request a reset link or set a new password for your <span class="font-semibold text-indigo-400 drop-shadow">${CONFIG.BRAND_NAME}</span> account.</p>

        <div class="mt-8 space-y-8">
          <section id="resetRequest" class="hidden rounded-3xl border border-indigo-500/40 bg-gray-900/60 p-6 shadow-inner shadow-indigo-900/30">
            <div class="flex items-center gap-4">
              <span class="flex h-10 w-10 items-center justify-center rounded-full bg-gradient-to-br from-indigo-500 via-purple-500 to-blue-500 text-lg font-semibold text-white shadow-lg shadow-indigo-900/40">1</span>
              <div>
                <h2 class="text-lg font-semibold text-white">Send reset link</h2>
                <p class="text-[15px] text-indigo-100/90">We'll email you a secure link that expires in ${CONFIG.RESET_TOKEN_TTL_MIN} minutes.</p>
              </div>
            </div>
            <form id="requestForm" class="mt-6 space-y-5">
              <div>
                <label class="block text-sm font-medium text-indigo-200 mb-1" for="resetEmail">Email</label>
                <input id="resetEmail" type="email" name="email" required
                       class="w-full rounded-2xl bg-gray-800/80 border border-gray-700 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-400 p-3 text-[15px] font-semibold text-indigo-200 focus:text-indigo-100 transition placeholder-indigo-300/60" placeholder="you@example.com" />
              </div>
              <button id="requestSubmit" class="w-full py-3.5 rounded-2xl bg-gradient-to-r from-indigo-500 via-purple-500 to-blue-500 hover:from-indigo-400 hover:via-purple-400 hover:to-blue-400 focus:ring-2 focus:ring-indigo-400 active:scale-[0.99] transition font-semibold text-[15px] shadow-lg shadow-indigo-900/50" type="submit">Email me a reset link</button>
            </form>
            <pre id="requestMsg" class="mt-6 text-sm whitespace-pre-wrap text-indigo-100 bg-gray-900/70 border border-indigo-500/30 rounded-2xl p-4 min-h-[3rem] transition"></pre>
            <p class="mt-4 text-xs text-indigo-200/80">Need an account instead? <a class="font-semibold text-indigo-200 hover:text-white" href="/">Start registration</a>.</p>
          </section>

          <section id="resetConfirm" class="hidden rounded-3xl border border-indigo-500/40 bg-gray-900/60 p-6 shadow-inner shadow-indigo-900/30">
            <div class="flex items-center gap-4">
              <span class="flex h-10 w-10 items-center justify-center rounded-full bg-gradient-to-br from-indigo-500 via-purple-500 to-blue-500 text-lg font-semibold text-white shadow-lg shadow-indigo-900/40">2</span>
              <div>
                <h2 class="text-lg font-semibold text-white">Set a new password</h2>
                <p class="text-[15px] text-indigo-100/90">Choose a strong password to secure your account.</p>
              </div>
            </div>
            <form id="confirmForm" class="mt-6 space-y-5">
              <div>
                <label class="block text-sm font-medium text-indigo-200 mb-1" for="confirmPassword">New password</label>
                <input id="confirmPassword" type="password" name="password" required minlength="${CONFIG.MIN_PASS}" maxlength="${CONFIG.MAX_PASS}"
                       class="w-full rounded-2xl bg-gray-800/80 border border-gray-700 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-400 p-3 text-[15px] font-semibold text-indigo-200 focus:text-indigo-100 transition placeholder-indigo-300/60" placeholder="••••••••" />
              </div>
              <div>
                <label class="block text-sm font-medium text-indigo-200 mb-1" for="confirmPasswordAgain">Confirm password</label>
                <input id="confirmPasswordAgain" type="password" name="passwordConfirm" required minlength="${CONFIG.MIN_PASS}" maxlength="${CONFIG.MAX_PASS}"
                       class="w-full rounded-2xl bg-gray-800/80 border border-gray-700 focus:ring-2 focus:ring-indigo-500 focus:border-indigo-400 p-3 text-[15px] font-semibold text-indigo-200 focus:text-indigo-100 transition placeholder-indigo-300/60" placeholder="Repeat password" />
              </div>
              <button id="confirmSubmit" class="w-full py-3.5 rounded-2xl bg-gradient-to-r from-indigo-500 via-purple-500 to-blue-500 hover:from-indigo-400 hover:via-purple-400 hover:to-blue-400 focus:ring-2 focus:ring-indigo-400 active:scale-[0.99] transition font-semibold text-[15px] shadow-lg shadow-indigo-900/50" type="submit">Update password</button>
            </form>
            <pre id="confirmMsg" class="mt-6 text-sm whitespace-pre-wrap text-indigo-100 bg-gray-900/70 border border-indigo-500/30 rounded-2xl p-4 min-h-[3rem] transition"></pre>
            <div class="mt-4 flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
              <p class="text-xs text-indigo-200/80">Reset link token: <span id="tokenDisplay" class="font-semibold text-indigo-100"></span></p>
              <a class="text-sm font-medium text-indigo-200 hover:text-white transition" href="/login">Return to login</a>
            </div>
          </section>
        </div>
      </div>
    </div>
    <p class="text-center text-xs text-gray-500 mt-5">Protected by Cloudflare · DreamCore DemiDev Unit 2025 · DreamCore.exe shortcut by Azar</p>
  </div>
</body>
</html>`;

const resetScript = () => {
  const params = new URLSearchParams(window.location.search);
  const token = params.get('token') || '';
  const requestSection = document.getElementById('resetRequest');
  const confirmSection = document.getElementById('resetConfirm');
  const tokenDisplay = document.getElementById('tokenDisplay');

  const requestForm = document.getElementById('requestForm');
  const requestMsg = document.getElementById('requestMsg');
  const requestSubmit = document.getElementById('requestSubmit');

  const confirmForm = document.getElementById('confirmForm');
  const confirmMsg = document.getElementById('confirmMsg');
  const confirmSubmit = document.getElementById('confirmSubmit');

  function show(section) {
    if (requestSection) requestSection.classList.toggle('hidden', section !== 'request');
    if (confirmSection) confirmSection.classList.toggle('hidden', section !== 'confirm');
  }

  function setLoading(button, state) {
    if (!button) return;
    button.disabled = state;
    button.classList.toggle('opacity-60', state);
  }

  if (token) {
    show('confirm');
    if (tokenDisplay) tokenDisplay.textContent = token;
  } else {
    show('request');
  }

  requestForm?.addEventListener('submit', async (event) => {
    event.preventDefault();
    const email = document.getElementById('resetEmail')?.value.trim();
    if (!email) {
      requestMsg.textContent = 'Enter your account email to continue.';
      return;
    }
    setLoading(requestSubmit, true);
    requestMsg.textContent = 'Submitting request…';
    try {
      const res = await fetch('/api/password-reset/request', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'same-origin',
        body: JSON.stringify({ email })
      });
      if (res.ok) {
        requestMsg.textContent = 'If that email is registered, a reset link is on the way. Check your inbox!';
      } else {
        const data = await res.json().catch(() => ({}));
        requestMsg.textContent = data?.error
          ? 'Error: ' + data.error
          : 'Unable to submit reset request.';
      }
    } catch (err) {
      console.error('Reset request failed', err);
      requestMsg.textContent = 'Network error. Please try again.';
    } finally {
      setLoading(requestSubmit, false);
    }
  });

  confirmForm?.addEventListener('submit', async (event) => {
    event.preventDefault();
    const password = document.getElementById('confirmPassword')?.value || '';
    const confirm = document.getElementById('confirmPasswordAgain')?.value || '';

    if (!token) {
      confirmMsg.textContent = 'Missing or invalid reset token.';
      return;
    }
    if (!password || password !== confirm) {
      confirmMsg.textContent = 'Passwords must match.';
      return;
    }

    setLoading(confirmSubmit, true);
    confirmMsg.textContent = 'Updating password…';

    try {
      const res = await fetch('/api/password-reset/confirm', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'same-origin',
        body: JSON.stringify({ token, password })
      });
      const data = await res.json().catch(() => ({}));
      if (!res.ok) {
        confirmMsg.textContent = data?.error
          ? 'Error: ' + data.error
          : 'Unable to reset password.';
        return;
      }
      confirmMsg.textContent = 'Password updated! You can now log in with your new credentials.';
    } catch (err) {
      console.error('Reset confirm failed', err);
      confirmMsg.textContent = 'Network error. Please try again.';
    } finally {
      setLoading(confirmSubmit, false);
    }
  });
};
const RESET_JS = `(${resetScript.toString()})();`;

const CHARACTERS_PAGE = () => `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>${CONFIG.HEADER_TITLE} — My Characters</title>
  <script src="/characters.js" defer></script>
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
  <div class="w-full max-w-4xl relative z-10">
    <div class="bg-gray-900/80 backdrop-blur-xl rounded-3xl shadow-2xl border border-indigo-500/20 overflow-hidden">
      <div class="px-6 pt-8 pb-10 sm:px-10">
        <div class="flex flex-col gap-4 md:flex-row md:items-start md:justify-between">
          <div>
            <span class="inline-flex items-center gap-2 rounded-full bg-gradient-to-r from-blue-500 via-purple-500 to-indigo-500 px-4 py-1 text-xs font-semibold uppercase tracking-[0.3em] text-gray-900 shadow-lg shadow-indigo-900/30">Roster</span>
            <h1 class="mt-4 text-4xl font-semibold tracking-tight text-white">My Characters</h1>
            <p class="mt-3 text-[15px] text-indigo-100/90">Welcome back, <span id="sessionEmail" class="font-semibold text-indigo-200">loading…</span>. Here's your latest roster across DreamCore realms.</p>
          </div>
          <div class="flex flex-col gap-3 sm:flex-row sm:items-center">
            <a class="inline-flex items-center justify-center rounded-2xl border border-indigo-400/60 bg-gray-900/70 px-5 py-2.5 text-sm font-semibold text-indigo-100 transition hover:border-indigo-300 hover:text-white hover:bg-indigo-500/20 focus:outline-none focus:ring-2 focus:ring-indigo-400 shadow-lg shadow-indigo-900/40" href="/reset-password">Reset password</a>
            <button id="logoutBtn" class="inline-flex items-center justify-center rounded-2xl bg-gradient-to-r from-indigo-500 via-purple-500 to-blue-500 px-5 py-2.5 text-sm font-semibold text-white shadow-lg shadow-indigo-900/50 transition hover:from-indigo-400 hover:via-purple-400 hover:to-blue-400 focus:ring-2 focus:ring-indigo-400">Log out</button>
          </div>
        </div>
        <div class="mt-6 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
          <div class="text-sm text-indigo-200/90">Total characters: <span id="totalCharacters" class="font-semibold text-indigo-100">0</span> · Realms: <span id="totalRealms" class="font-semibold text-indigo-100">0</span></div>
          <button id="refreshRoster" class="inline-flex items-center justify-center rounded-2xl border border-indigo-400/60 bg-gray-900/70 px-4 py-2 text-sm font-semibold text-indigo-100 transition hover:border-indigo-300 hover:text-white hover:bg-indigo-500/20 focus:outline-none focus:ring-2 focus:ring-indigo-400 shadow-md shadow-indigo-900/30">Refresh roster</button>
        </div>
        <pre id="rosterStatus" class="mt-6 text-sm whitespace-pre-wrap text-indigo-100 bg-gray-900/70 border border-indigo-500/30 rounded-2xl p-4 min-h-[3rem] transition">Loading characters…</pre>
        <div id="characterGrid" class="mt-6 grid gap-5 sm:grid-cols-2 xl:grid-cols-3"></div>
      </div>
    </div>
    <p class="text-center text-xs text-gray-500 mt-5">Protected by Cloudflare · DreamCore DemiDev Unit 2025 · DreamCore.exe shortcut by Azar</p>
  </div>
</body>
</html>`;

const charactersScript = () => {
  const rosterStatus = document.getElementById('rosterStatus');
  const characterGrid = document.getElementById('characterGrid');
  const totalCharacters = document.getElementById('totalCharacters');
  const totalRealms = document.getElementById('totalRealms');
  const sessionEmail = document.getElementById('sessionEmail');
  const refreshButton = document.getElementById('refreshRoster');
  const logoutButton = document.getElementById('logoutBtn');

  const CLASS_NAMES = {
    1: 'Warrior',
    2: 'Paladin',
    3: 'Hunter',
    4: 'Rogue',
    5: 'Priest',
    6: 'Death Knight',
    7: 'Shaman',
    8: 'Mage',
    9: 'Warlock',
    10: 'Monk',
    11: 'Druid',
    12: 'Demon Hunter',
    13: 'Evoker',
  };

  const RACE_NAMES = {
    1: 'Human',
    2: 'Orc',
    3: 'Dwarf',
    4: 'Night Elf',
    5: 'Undead',
    6: 'Tauren',
    7: 'Gnome',
    8: 'Troll',
    9: 'Goblin',
    10: 'Blood Elf',
    11: 'Draenei',
    22: 'Worgen',
    24: 'Pandaren',
  };

  function escapeHtml(value) {
    return String(value || '').replace(/[&<>"']/g, (ch) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[ch] || ch));
  }

  function formatDate(value) {
    if (!value) return 'Unknown';
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) return 'Unknown';
    return date.toLocaleString();
  }

  function renderCharacters(payload) {
    if (!payload) {
      rosterStatus.textContent = 'Unable to load characters.';
      characterGrid.innerHTML = '';
      return;
    }

    const { characters = [], summary = {}, message } = payload;
    totalCharacters.textContent = summary?.totalCharacters ?? characters.length;
    totalRealms.textContent = summary?.totalRealms ?? 0;

    if (message) {
      rosterStatus.textContent = message;
    } else {
      rosterStatus.textContent = characters.length ? 'Roster loaded.' : 'No characters found for this account.';
    }

    if (!characters.length) {
      characterGrid.innerHTML = '<p class="text-sm text-indigo-200/90">Create a character in-game and refresh to see it here.</p>';
      return;
    }

    const cards = characters.map((character) => {
      const className = CLASS_NAMES[character.class] || `Class #${character.class}`;
      const raceName = RACE_NAMES[character.race] || `Race #${character.race}`;
      const realmName = character.realm?.name || 'Unknown realm';
      const lastPlayed = formatDate(character.lastLogin);
      return `
        <article class="rounded-3xl border border-indigo-500/30 bg-gray-900/70 p-5 shadow-inner shadow-indigo-900/40">
          <div class="flex items-baseline justify-between">
            <h3 class="text-xl font-semibold text-white">${escapeHtml(character.name)}</h3>
            <span class="text-sm font-semibold text-indigo-300">Lvl ${escapeHtml(character.level)}</span>
          </div>
          <p class="mt-2 text-[15px] text-indigo-100/90">${escapeHtml(raceName)} · ${escapeHtml(className)}</p>
          <p class="mt-2 text-sm text-indigo-200/80">Realm: <span class="font-semibold text-indigo-100">${escapeHtml(realmName)}</span></p>
          <p class="mt-2 text-xs text-indigo-200/70">Last seen: ${escapeHtml(lastPlayed)}</p>
        </article>
      `;
    });

    characterGrid.innerHTML = cards.join('');
  }

  async function loadSessionAndRoster() {
    try {
      const sessionRes = await fetch('/api/session', { credentials: 'same-origin' });
      if (sessionRes.status === 401) {
        window.location.href = '/login';
        return;
      }
      const sessionData = await sessionRes.json();
      if (sessionEmail && sessionData?.session?.email) {
        sessionEmail.textContent = sessionData.session.email;
      }
      await loadCharacters();
    } catch (err) {
      console.error('Session lookup failed', err);
      rosterStatus.textContent = 'Unable to confirm your session. Redirecting to login…';
      setTimeout(() => { window.location.href = '/login'; }, 1200);
    }
  }

  async function loadCharacters(forceRefresh = false) {
    try {
      rosterStatus.textContent = forceRefresh ? 'Refreshing roster…' : 'Loading characters…';
      const url = forceRefresh ? '/api/characters?refresh=1' : '/api/characters';
      const res = await fetch(url, { credentials: 'same-origin' });
      if (res.status === 401) {
        window.location.href = '/login';
        return;
      }
      const data = await res.json().catch(() => ({}));
      if (!res.ok) {
        rosterStatus.textContent = data?.error
          ? 'Error: ' + data.error
          : 'Unable to load characters.';
        characterGrid.innerHTML = '';
        return;
      }
      renderCharacters(data);
    } catch (err) {
      console.error('Character fetch failed', err);
      rosterStatus.textContent = 'Network error while loading characters.';
      characterGrid.innerHTML = '';
    }
  }

  refreshButton?.addEventListener('click', (event) => {
    event.preventDefault();
    loadCharacters(true);
  });

  logoutButton?.addEventListener('click', async () => {
    try {
      await fetch('/api/logout', { method: 'POST', credentials: 'same-origin' });
    } catch (err) {
      console.error('Logout failed', err);
    } finally {
      window.location.href = '/login';
    }
  });

  loadSessionAndRoster();
};
const CHARACTERS_JS = `(${charactersScript.toString()})();`;

app.get('/', (req, res) => res.type('html').send(REG_PAGE()));
app.get('/client.js', (req, res) => res.type('application/javascript').send(CLIENT_JS));
app.get('/login', async (req, res) => {
  const session = await loadSession(req).catch(() => null);
  if (session) {
    return res.redirect('/account');
  }
  return res.type('text/html').send(LOGIN_PAGE());
});
app.get('/login.js', (req, res) => res.type('application/javascript').send(LOGIN_JS));
app.get('/account', async (req, res) => {
  const session = await loadSession(req).catch(() => null);
  if (!session) {
    return res.redirect('/login');
  }
  return res.type('text/html').send(ACCOUNT_PAGE());
});
app.get('/account.js', (req, res) => res.type('application/javascript').send(ACCOUNT_JS));
app.get('/reset-password', (req, res) => res.type('text/html').send(RESET_PAGE()));
app.get('/reset.js', (req, res) => res.type('application/javascript').send(RESET_JS));
app.get('/characters', async (req, res) => {
  const session = await loadSession(req).catch(() => null);
  if (!session) {
    return res.redirect('/login');
  }
  return res.type('text/html').send(CHARACTERS_PAGE());
});
app.get('/characters.js', (req, res) => res.type('application/javascript').send(CHARACTERS_JS));

// ----- Helpers -----
function badRequest(res, error) { return res.status(400).json({ error }); }
function escapeHtml(s) {
  return String(s).replace(/[&<>"']/g, c => (
    ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]
  ));
}
function renderTransactionalEmail({ title, intro, paragraphs = [], button, footerLines = [] }) {
  const brand = escapeHtml(CONFIG.BRAND_NAME || 'DreamCore');
  const corner = escapeHtml(CONFIG.CORNER_LOGO || brand);
  const heading = escapeHtml(title || brand);
  const baseUrl = escapeHtml(CONFIG.BASE_URL || '');
  const introHtml = intro
    ? `<p style="margin:0 0 16px;color:#cbd5f5;font-size:15px;line-height:1.6;">${escapeHtml(intro)}</p>`
    : '';
  const paragraphsHtml = Array.isArray(paragraphs)
    ? paragraphs
        .map((text) =>
          `<p style="margin:0 0 16px;color:#e0e7ff;font-size:14px;line-height:1.7;">${escapeHtml(text)}</p>`
        )
        .join('')
    : '';
  const hasButton = button && button.href && button.label;
  const buttonHref = hasButton ? escapeHtml(button.href) : '';
  const buttonLabel = hasButton ? escapeHtml(button.label) : '';
  const buttonHtml = hasButton
    ? `<p style="margin:24px 0 16px;"><a href="${buttonHref}" style="background:#6366f1;color:#0f172a;padding:12px 22px;border-radius:999px;text-decoration:none;font-weight:600;display:inline-block;">${buttonLabel}</a></p>`
    : '';
  const fallbackHtml = hasButton
    ? `<p style="margin:0 0 16px;color:#94a3b8;font-size:13px;line-height:1.5;">If the button doesn't open, copy and paste this link:<br><a href="${buttonHref}" style="color:#a5b4fc;">${buttonHref}</a></p>`
    : '';
  const footerHtml = footerLines.length
    ? footerLines
        .map((text) => `<p style="margin:12px 0 0;color:#64748b;font-size:12px;line-height:1.5;">${escapeHtml(text)}</p>`)
        .join('')
    : `<p style="margin:12px 0 0;color:#64748b;font-size:12px;line-height:1.5;">${brand} • ${baseUrl}</p>`;

  return `
    <div style="background-color:#0f172a;padding:32px 16px;font-family:'Segoe UI',Roboto,Helvetica,Arial,sans-serif;">
      <div style="max-width:520px;margin:0 auto;background:#111827;border-radius:18px;padding:32px;border:1px solid rgba(129,140,248,0.25);box-shadow:0 25px 50px -12px rgba(79,70,229,0.35);">
        <div style="text-transform:uppercase;letter-spacing:0.14em;font-size:12px;font-weight:600;color:#a5b4fc;">${corner}</div>
        <h1 style="color:#f8fafc;font-size:22px;margin:12px 0 18px;">${heading}</h1>
        ${introHtml}
        ${paragraphsHtml}
        ${buttonHtml}
        ${fallbackHtml}
        <hr style="border:none;border-top:1px solid rgba(148,163,184,0.25);margin:28px 0;">
        <p style="margin:0;color:#94a3b8;font-size:13px;">${brand} Support Team</p>
        ${footerHtml}
      </div>
    </div>
  `;
}
function isValidPassword(p) {
  return (
    typeof p === 'string' &&
    p.length >= CONFIG.MIN_PASS &&
    p.length <= CONFIG.MAX_PASS &&
    !/\s/.test(p) &&
    !/['"]/.test(p)
  );
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

async function confirmRetailProvisioning(email) {
  const normalized = normalizeEmail(email);
  if (!normalized) {
    return { ok: false, reason: 'invalidEmail' };
  }

  const account = await getAuthAccountByEmail(normalized);
  if (!account) {
    return { ok: false, reason: 'missingAccount' };
  }

  const bnetId = toSafeNumber(account.id);
  if (bnetId == null) {
    return { ok: false, reason: 'missingBnetId' };
  }

  const gameAccounts = await fetchGameAccountsForBnet(bnetId);
  if (!Array.isArray(gameAccounts) || !gameAccounts.length) {
    return { ok: false, reason: 'missingGameAccount', bnetId };
  }

  return { ok: true, bnetId, gameAccounts };
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
  const normalizedEmail = normalizeEmail(email);
  const token = crypto.randomBytes(48).toString('base64url');
  const hashed = hashSessionToken(token);
  const now = Date.now();
  const expiresAt = now + CONFIG.SESSION_TTL_HOURS * 60 * 60 * 1000;
  const userAgent = (req.headers['user-agent'] || '').slice(0, 255);
  const ip = (req.ip || req.headers['x-forwarded-for'] || '').toString().slice(0, 64);
  await pool.execute(
    `REPLACE INTO sessions (id, account_id, email, created_at, expires_at, last_ip, last_user_agent)
     VALUES (?, ?, ?, ?, ?, ?, ?)`,
    [hashed, accountId, normalizedEmail, now, expiresAt, ip || null, userAgent || null]
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
  const normalized = normalizeEmail(email);
  if (!normalized) return null;
  const tables = ['bnetaccount', 'battlenet_accounts'];
  for (const table of tables) {
    try {
      const [rows] = await authPool.execute(
        `SELECT id, email, sha_pass_hash, salt, verifier FROM \`${table}\` WHERE UPPER(email) = UPPER(?) LIMIT 1`,
        [normalized]
      );
      if (rows.length) return rows[0];
    } catch (err) {
      if (err?.code === 'ER_BAD_FIELD_ERROR') {
        try {
          const [fallbackRows] = await authPool.execute(
            `SELECT id, email, salt, verifier FROM \`${table}\` WHERE UPPER(email) = UPPER(?) LIMIT 1`,
            [normalized]
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

app.get('/api/status', async (req, res) => {
  try {
    const { ret } = await executeRetailCommand({ soap: SOAP, command: 'server info' });
    res.json({ ok: true, info: ret });
  } catch (e) {
    res.status(500).json({ ok: false, error: String(e) });
  }
});

app.post('/api/login', loginLimiter, async (req, res) => {
  try {
    const { email: rawEmail, password } = req.body || {};
    const email = normalizeEmail(rawEmail);
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
      path: '/',
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

app.post('/api/logout', async (req, res) => {
  try {
    const token = getSessionToken(req);
    if (token) {
      const hashed = hashSessionToken(token);
      try {
        await pool.execute('DELETE FROM sessions WHERE id = ?', [hashed]);
      } catch (err) {
        console.error('Failed to delete session during logout', err);
      }
    }
    res.clearCookie(CONFIG.SESSION_COOKIE_NAME, {
      httpOnly: true,
      sameSite: 'lax',
      secure: CONFIG.COOKIE_SECURE,
      path: '/',
    });
    return res.json({ ok: true });
  } catch (e) {
    console.error('Logout error', e);
    return res.status(500).json({ error: 'Unable to logout' });
  }
});

app.get('/api/session', requireSession, (req, res) => {
  res.json({ ok: true, session: { accountId: req.session.account_id, email: req.session.email, expiresAt: req.session.expires_at } });
});

app.post('/api/account/reset-password', requireSession, async (req, res) => {
  try {
    const { newPassword } = req.body || {};
    if (!isValidPassword(newPassword)) {
      return badRequest(
        res,
        `Password must be at least ${CONFIG.MIN_PASS} characters with no spaces or quotes.`
      );
    }

    const email = req.session?.email;
    if (!email) {
      return res.status(400).json({ error: 'Unable to determine account email for this session.' });
    }

    await retailPasswordReset({
      soap: SOAP,
      email,
      newPassword,
    });

    return res.json({ ok: true });
  } catch (e) {
    console.error('Account password reset failed', e);
    return res.status(500).json({ error: 'Unable to reset password at this time.' });
  }
});

app.get('/api/characters', requireSession, async (req, res) => {
  try {
    const accountId = req.session?.account_id;
    const cacheKey = accountId != null ? String(accountId) : null;
    const refreshFlag = String(req.query?.refresh ?? req.query?.force ?? req.query?.nocache ?? '').toLowerCase();
    const bypassCache = ['1', 'true', 'yes'].includes(refreshFlag);

    if (cacheKey && !bypassCache) {
      const cached = CHARACTER_CACHE.get(cacheKey);
      if (cached && cached.expiresAt > Date.now()) {
        return res.json(cached.payload);
      }
    }

    if (cacheKey && bypassCache) {
      CHARACTER_CACHE.delete(cacheKey);
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
    const { password, email: rawEmail, cfToken } = req.body || {};
    const email = normalizeEmail(rawEmail);

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
    const html = renderTransactionalEmail({
      title: `${CONFIG.BRAND_NAME} — Verify your email`,
      intro: `You're almost ready to enter ${CONFIG.BRAND_NAME}.`,
      paragraphs: [
        `Complete the signup for ${safeEmail} within ${CONFIG.TOKEN_TTL_MIN} minutes to activate your login.`,
        'If you did not start this registration, you can safely ignore this message.',
      ],
      button: { href: verifyUrl, label: 'Finish registration' },
    });
    const text = [
      `${CONFIG.BRAND_NAME}: verify your email`,
      `Finish creating the account for ${email} by visiting: ${verifyUrl}`,
      `This link expires in ${CONFIG.TOKEN_TTL_MIN} minutes.`,
      '',
      `If you did not request this, you can ignore this email.`,
    ].join('\n');

    await transporter.sendMail({
      to: email,
      from: CONFIG.FROM_EMAIL,
      subject: `${CONFIG.BRAND_NAME}: confirm your account`,
      html,
      text,
    });

    return res.json({ ok: true });
  } catch (e) {
    console.error(e);
    return res.status(500).json({ error: 'Server error' });
  }
});

// [removed] password reset request endpoint disabled
// [removed] password reset confirm endpoint disabled
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

    let ensureResult = null;
    try {
      ensureResult = await ensureRetailAccount({
        soap: SOAP,
        email: row.email,
        password: row.password,
        debug: CONFIG.SOAP_DEBUG,
      });
    } catch (e) {
      console.error('SOAP create failed:', e);
      return res
        .status(502)
        .type('text/html')
        .send(
          VERIFY_PAGE({
            state: 'error',
            title: 'Unable to finalize your account',
            message: 'We could not create your Battle.net account. Please try again in a minute.',
            steps: [
              'If it keeps failing, open a support ticket and include this error:',
              String(e?.message || e),
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
          title: 'Your account is ready!',
          message: 'Your Battle.net account for the private server has been created.',
          successSteps: [
            {
              number: 'Step 1',
              title: 'Your DreamCore login',
              body: [
                `Sign in with ${escapeHtml(row.email)}.`,
                'Keep using the password you chose during sign-up.',
              ],
            },
            {
              number: 'Step 2',
              title: 'Verification complete',
              body: ['Step 2 is complete — you are fully verified and ready to continue.'],
            },
            {
              number: 'Step 3',
              title: 'Install & connect',
              body: ['Step 3: follow the installation guide below to set up DreamCore on your system.'],
              cta: {
                href: CONFIG.GUIDE_URL,
                label: 'Open installation guide',
              },
            },
          ],
          successFooter:
            'You can return to the <a class="font-semibold text-indigo-200 hover:text-white" href="/login">DreamCore portal</a> from the landing page whenever you need to change your password.',
          debug: CONFIG.SOAP_DEBUG ? [{ label: 'soapLog', data: ensureResult?.soapLog || [] }] : [],
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

function VERIFY_PAGE({ state, title, message, steps, successSteps, successFooter }) {
  const tone = {
    success: {
      badge: 'Verified',
      badgeGradient: 'from-emerald-400 via-green-400 to-teal-400',
      border: 'border-emerald-400/40',
      glow: 'shadow-emerald-900/30',
      highlight: 'text-emerald-300',
      icon: '✓',
    },
    pending: {
      badge: 'Setup queued',
      badgeGradient: 'from-sky-400 via-cyan-400 to-indigo-400',
      border: 'border-sky-400/40',
      glow: 'shadow-sky-900/30',
      highlight: 'text-sky-300',
      icon: '⧗',
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

  const successFooterHtml =
    state === 'success' && successFooter
      ? `<div class="mt-10 rounded-3xl border border-indigo-500/30 bg-gray-900/60 p-5 text-[15px] text-indigo-100/90 shadow-inner shadow-indigo-900/20">${successFooter}</div>`
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
        ${successFooterHtml}
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
  console.log(`[Unit]\nDescription=TrinityCore Self-Serve Registration\nAfter=network.target\n\n[Service]\nType=simple\nWorkingDirectory=${process.cwd()}\nExecStart=/usr/bin/node ${process.cwd()}/server.js\nRestart=always\nEnvironment=PORT=${CONFIG.PORT}\nEnvironment=BASE_URL=${CONFIG.BASE_URL}\nEnvironment=TC_SOAP_HOST=${CONFIG.TC_SOAP_HOST}\nEnvironment=TC_SOAP_PORT=${CONFIG.TC_SOAP_PORT}\nEnvironment=TC_SOAP_USER=${CONFIG.TC_SOAP_USER}\nEnvironment=TC_SOAP_PASS=${CONFIG.TC_SOAP_PASS}\nEnvironment=SOAP_DEBUG=${CONFIG.SOAP_DEBUG}\nEnvironment=TURNSTILE_SITEKEY=${CONFIG.TURNSTILE_SITEKEY}\nEnvironment=TURNSTILE_SECRET=${CONFIG.TURNSTILE_SECRET}\nEnvironment=SMTP_HOST=${CONFIG.SMTP_HOST}\nEnvironment=SMTP_PORT=${CONFIG.SMTP_PORT}\nEnvironment=SMTP_SECURE=${CONFIG.SMTP_SECURE}\nEnvironment=SMTP_USER=${CONFIG.SMTP_USER}\nEnvironment=SMTP_PASS=${CONFIG.SMTP_PASS}\nEnvironment=FROM_EMAIL=${CONFIG.FROM_EMAIL}\nEnvironment=BRAND_NAME=${CONFIG.BRAND_NAME}\nEnvironment=DB_HOST=${DB.HOST}\nEnvironment=DB_PORT=${DB.PORT}\nEnvironment=DB_USER=${DB.USER}\nEnvironment=DB_PASS=${DB.PASS}\nEnvironment=DB_NAME=${DB.NAME}\nEnvironment=AUTH_DB_HOST=${AUTH_DB.HOST}\nEnvironment=AUTH_DB_PORT=${AUTH_DB.PORT}\nEnvironment=AUTH_DB_USER=${AUTH_DB.USER}\nEnvironment=AUTH_DB_PASS=${AUTH_DB.PASS}\nEnvironment=AUTH_DB_NAME=${AUTH_DB.NAME}\nEnvironment=CHAR_DB_HOST=${CHAR_DB.HOST}\nEnvironment=CHAR_DB_PORT=${CHAR_DB.PORT}\nEnvironment=CHAR_DB_USER=${CHAR_DB.USER}\nEnvironment=CHAR_DB_PASS=${CHAR_DB.PASS}\nEnvironment=CHAR_DB_NAME=${CHAR_DB.NAME}\nEnvironment=SESSION_TTL_HOURS=${CONFIG.SESSION_TTL_HOURS}\nEnvironment=SESSION_COOKIE_NAME=${CONFIG.SESSION_COOKIE_NAME}\nEnvironment=COOKIE_SECURE=${CONFIG.COOKIE_SECURE}\n\n[Install]\nWantedBy=multi-user.target\n`);
});
