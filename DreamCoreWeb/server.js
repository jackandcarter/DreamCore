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

import { createTrinitySoap, parseSoapReturn } from './lib/trinitySoap.js';

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
  HOST: process.env.AUTH_DB_HOST || process.env.DB_HOST || '127.0.0.1',
  PORT: Number(process.env.AUTH_DB_PORT || process.env.DB_PORT || 3306),
  USER: process.env.AUTH_DB_USER || 'trinity',
  PASS: process.env.AUTH_DB_PASS || 'trinity_password',
  NAME: process.env.AUTH_DB_NAME || 'auth',
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

// Ensure table exists
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

const SOAP_CONFIG = {
  host: CONFIG.TC_SOAP_HOST,
  port: CONFIG.TC_SOAP_PORT,
  user: CONFIG.TC_SOAP_USER,
  pass: CONFIG.TC_SOAP_PASS,
};

const trinitySoap = createTrinitySoap({
  soapConfig: SOAP_CONFIG,
  authPool,
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
      0% {
        transform: rotate(0deg) scale(1.1);
      }
      50% {
        transform: rotate(180deg) scale(1.2);
      }
      100% {
        transform: rotate(360deg) scale(1.1);
      }
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
function normalizeEmail(value) {
  return typeof value === 'string' ? value.trim().toLowerCase() : '';
}
function isValidPassword(p) {
  return typeof p === 'string' && p.length >= CONFIG.MIN_PASS && p.length <= CONFIG.MAX_PASS;
}
function isValidEmail(e) {
  if (typeof e !== 'string') return false;
  const normalized = normalizeEmail(e);
  return /.+@.+\..+/.test(normalized) && normalized.length <= 254;
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
    const out = await trinitySoap.execute('server info');
    res.json({ ok: true, info: parseSoapReturn(out) });
  } catch (e) {
    res.status(500).json({ ok: false, error: String(e) });
  }
});

// ----- API: Register -----
app.post('/api/register', limiter, async (req, res) => {
  try {
    const { password, email: emailInput, cfToken } = req.body || {};
    const email = normalizeEmail(emailInput);

    if (!isValidPassword(password)) return badRequest(res, 'Invalid password');
    if (!isValidEmail(email)) return badRequest(res, 'Invalid email');

    const ok = await verifyTurnstile(cfToken, req.ip);
    if (!ok) return badRequest(res, 'CAPTCHA failed');

    // Create a pending token, send email
    const token = crypto.randomBytes(24).toString('hex');
    const now = Date.now();
    const safeUser = email.split('@')[0].slice(0, CONFIG.MAX_USER) || 'player'; // pending bookkeeping only
    await pool.execute(
      'INSERT INTO pending (token, username, password, email, created_at) VALUES (?, ?, ?, ?, ?)',
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
      const wantsJson = /application\/json/i.test(req.headers.accept || '');
      if (!token) {
        if (wantsJson) {
          return res.status(400).json({ ok: false, error: 'invalid-token' });
        }
        return res
          .status(400)
          .type('text/html')
          .send(
            VERIFY_PAGE({
              state: 'error',
              title: 'Invalid verification link',
              message:
                'The verification link is missing a token or was formatted incorrectly.',
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
        if (wantsJson) {
          return res.status(400).json({ ok: false, error: 'not-found' });
        }
        return res
          .status(400)
          .type('text/html')
          .send(
            VERIFY_PAGE({
              state: 'expired',
              title: 'Verification link not found',
              message:
                'This verification link has already been used or does not match any pending registration.',
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
        if (wantsJson) {
          return res.status(400).json({ ok: false, error: 'expired' });
        }
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

      // Create real TC account now
      try {
        const result = await trinitySoap.resolveAccountForEmail(row.email, row.password);
        await pool.execute('DELETE FROM pending WHERE token = ?', [token]);

        if (wantsJson) {
          return res.json({ ok: true, status: result.status, summary: result.summary });
        }

        const statusMessages = {
          created:
            'We created a brand-new DreamCore Battle.net login and attached your first game account.',
          linked:
            'We linked your DreamCore login to the correct game account so you are ready to play.',
          'password-reset':
            'We refreshed the password on your existing DreamCore login so you can sign in again.',
        };

        const successMessage = [
          `Your DreamCore login <strong>${escapeHtml(row.email)}</strong> is now active.`,
          statusMessages[result.status] || '',
        ]
          .filter(Boolean)
          .join(' ');

        return res
          .type('text/html')
          .send(
            VERIFY_PAGE({
              state: 'success',
              title: 'Account verified!',
              message: successMessage,
              accountStatus: result.status,
              successSteps: [
                {
                  number: 2,
                  title: 'Verification completed',
                  body: [
                    'Nice work—you\'ve finished Step 2.',
                    'Your DreamCore account is active and ready for the final client setup steps below.',
                  ],
                },
                {
                  number: 3,
                  title: 'Review the DreamCore guide & latest updates',
                  body: [
                    'Before you dive in, read through the DreamCore guide that covers launcher tips, shortcut setup, and any hotfixes we\'ve published.',
                    'Bookmark the page so you always have the newest client download links, bug fixes, and community news in one place.',
                  ],
                  cta: CONFIG.GUIDE_URL
                    ? {
                        href: CONFIG.GUIDE_URL,
                        label: 'Open DreamCore Guide & Updates',
                      }
                    : null,
                },
              ],
            })
          );
      } catch (e) {
        console.error('SOAP create failed:', e);
        if (wantsJson) {
          return res.status(502).json({ ok: false, error: 'soap-error', detail: String(e?.message || e) });
        }
        return res
          .status(502)
          .type('text/html')
          .send(
            VERIFY_PAGE({
              state: 'error',
              title: 'Unable to finalize your account',
              message:
                'Our account service had trouble completing the setup. No worries—your email is still reserved.',
              steps: [
                'Wait a moment and try the verification link again.',
                'If the issue persists, open a support ticket so we can complete the registration for you.',
              ],
            })
          );
      }
    } catch (e) {
      console.error(e);
      if (wantsJson) {
        return res.status(500).json({ ok: false, error: 'server-error' });
      }
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

function VERIFY_PAGE({ state, title, message, steps, successSteps, accountStatus }) {
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
            const note = step.note
              ? `<div class="mt-5 rounded-2xl border border-amber-400/50 bg-amber-500/10 p-4 text-amber-100 shadow-inner shadow-amber-900/20"><p class="text-sm font-semibold uppercase tracking-[0.25em] text-amber-200">Heads up</p><p class="mt-1 text-[15px] text-amber-100/90">${escapeHtml(
                  String(step.note)
                )}</p></div>`
              : '';
            const wrapperClasses = idx === 0
              ? 'rounded-3xl border border-purple-500/40 bg-indigo-500/10 p-6 backdrop-blur-sm'
              : 'rounded-3xl border border-indigo-500/40 bg-gray-900/60 p-6 shadow-inner shadow-indigo-900/30';
            return `<section class="${wrapperClasses}"><div class="flex items-center gap-4"><span class="flex h-10 w-10 items-center justify-center rounded-full bg-gradient-to-br from-indigo-500 via-purple-500 to-blue-500 text-lg font-semibold text-white shadow-lg shadow-indigo-900/40">${number}</span><div><h2 class="text-lg font-semibold text-white">${title}</h2><p class="text-[15px] text-indigo-100/90">Follow this step before moving on.</p></div></div>${bodyHtml}${cta}${note}</section>`;
          })
          .join('')}</div>`
      : '';

  const safeMessage = message.replace(/<(?!\/?(a|strong)\b)[^>]*>/gi, '');
  const statusBadge =
    state === 'success' && accountStatus
      ? `<div class="mt-4"><span class="inline-flex items-center gap-2 rounded-full border border-emerald-400/50 bg-emerald-500/15 px-3 py-1 text-xs font-semibold uppercase tracking-[0.25em] text-emerald-100">${escapeHtml(
          String(accountStatus).replace(/-/g, ' ')
        )}</span></div>`
      : '';

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
      0% {
        transform: rotate(0deg) scale(1.1);
      }
      50% {
        transform: rotate(180deg) scale(1.2);
      }
      100% {
        transform: rotate(360deg) scale(1.1);
      }
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
        ${statusBadge}
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
  try { await pool.execute('DELETE FROM pending WHERE created_at < ?', [cutoff]); } catch {}
}, 60 * 60 * 1000);

// ----- Start -----
app.listen(CONFIG.PORT, () => {
  console.log(`\n✔ ${CONFIG.BRAND_NAME} registration app listening on :${CONFIG.PORT}`);
  console.log(`   Public URL (BASE_URL): ${CONFIG.BASE_URL}`);
  console.log(`   Turnstile sitekey: ${CONFIG.TURNSTILE_SITEKEY}`);
  console.log(`\nExample systemd unit (save as /etc/systemd/system/tc-register.service):\n`);
  console.log(`[Unit]\nDescription=TrinityCore Self-Serve Registration\nAfter=network.target\n\n[Service]\nType=simple\nWorkingDirectory=${process.cwd()}\nExecStart=/usr/bin/node ${process.cwd()}/server.js\nRestart=always\nEnvironment=PORT=${CONFIG.PORT}\nEnvironment=BASE_URL=${CONFIG.BASE_URL}\nEnvironment=TC_SOAP_HOST=${CONFIG.TC_SOAP_HOST}\nEnvironment=TC_SOAP_PORT=${CONFIG.TC_SOAP_PORT}\nEnvironment=TC_SOAP_USER=${CONFIG.TC_SOAP_USER}\nEnvironment=TC_SOAP_PASS=${CONFIG.TC_SOAP_PASS}\nEnvironment=TURNSTILE_SITEKEY=${CONFIG.TURNSTILE_SITEKEY}\nEnvironment=TURNSTILE_SECRET=${CONFIG.TURNSTILE_SECRET}\nEnvironment=SMTP_HOST=${CONFIG.SMTP_HOST}\nEnvironment=SMTP_PORT=${CONFIG.SMTP_PORT}\nEnvironment=SMTP_SECURE=${CONFIG.SMTP_SECURE}\nEnvironment=SMTP_USER=${CONFIG.SMTP_USER}\nEnvironment=SMTP_PASS=${CONFIG.SMTP_PASS}\nEnvironment=FROM_EMAIL=${CONFIG.FROM_EMAIL}\nEnvironment=BRAND_NAME=${CONFIG.BRAND_NAME}\n\n[Install]\nWantedBy=multi-user.target\n`);
});
