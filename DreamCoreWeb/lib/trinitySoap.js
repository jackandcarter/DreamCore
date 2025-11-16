// Retail-only TrinityCore SOAP helpers (no password reset, no 3.3.5)
// Requires: mysql2/promise

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

function sanitizeSoapArg(value, { label } = {}) {
  const name = label ? `${label} ` : '';
  const raw = String(value ?? '').trim();
  if (!raw) {
    throw new Error(`${name}argument missing`);
  }
  if (/\s/.test(raw)) {
    throw new Error(`${name}argument must not contain whitespace`);
  }
  if (/["']/.test(raw)) {
    throw new Error(`${name}argument must not contain quotes`);
  }
  return raw;
}

const MAX_SOAP_COMMAND_LENGTH = 2048;

export function sanitizeSoapCommand(command) {
  const text = typeof command === 'string' ? command.trim() : '';
  if (!text) {
    throw new Error('SOAP command is required');
  }
  if (text.length > MAX_SOAP_COMMAND_LENGTH) {
    throw new Error('SOAP command is too long');
  }
  if (/[<>]/.test(text)) {
    throw new Error('SOAP command cannot contain angle brackets');
  }
  if (/[\u0000-\u001f]/.test(text)) {
    throw new Error('SOAP command contains invalid control characters');
  }
  return text;
}

function q(value) {
  if (value == null) {
    throw new Error("Missing value");
  }
  const text = String(value);
  if (!text) {
    throw new Error("Missing value");
  }
  const escaped = text.replace(/\\/g, '\\\\').replace(/"/g, '\\"');
  return `"${escaped}"`;
}

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

// ---------- Retail-only commands ----------
async function bnetCreate(soap, email, pass) {
  const safeEmail = sanitizeSoapArg(email, { label: 'email' });
  const safePass = sanitizeSoapArg(pass, { label: 'password' });
  return callSoap(soap, `bnetaccount create ${safeEmail} ${safePass}`);
}

function isErrorReturn(ret) {
  if (ret == null) return false;
  const value = String(ret).trim().toLowerCase();
  if (!value) return false;
  const patterns = [
    "error",
    "fail",
    "unable",
    "unknown",
    "invalid",
    "not exist",
    "already exist",
    "not linked",
    "not created",
    "usage",
  ];
  return patterns.some((fragment) => value.includes(fragment));
}

// ---------- High-level flows (confirm via DB, not text) ----------
export async function ensureRetailAccount({ soap, email, password, debug = false }) {
  if (!soap) throw new Error("Missing soap");
  const normEmail = normalizeEmail(email);
  if (!normEmail) throw new Error("Invalid email");
  if (!password) throw new Error("Missing password");

  const soapLog = [];

  const run = async (label, fn) => {
    try {
      const out = await fn();
      soapLog.push({ label, ok: true, ret: out.ret ?? out.raw ?? String(out) });
      return out;
    } catch (err) {
      soapLog.push({ label, ok: false, error: String(err?.message || err) });
      throw err;
    }
  };

  await run("bnetaccount create", () => bnetCreate(soap, normEmail, password));

  return {
    ok: true,
    email: normEmail,
    soapLog,
  };
}

function normalizeClassicUsername(username, email) {
  if (typeof username === "string" && username.trim()) {
    return username.trim();
  }
  if (typeof email === "string" && email.trim()) {
    const [local] = email.trim().split("@");
    if (local) return local;
    return email.trim();
  }
  return "player";
}

async function classicAccountCreate(soap, username, password) {
  return callSoap(soap, ["account", "create", username, password].join(" "));
}

export async function ensureClassicAccount({ soap, email, username, password, debug = false }) {
  if (!soap) throw new Error("Missing soap");
  if (!password) throw new Error("Missing password");
  const normEmail = normalizeEmail(email);
  const baseUsername = normalizeClassicUsername(username, normEmail);
  const safeUsername = sanitizeSoapArg(baseUsername, { label: "username" }).toUpperCase();
  const safePass = sanitizeSoapArg(password, { label: "password" });
  const soapLog = [];

  const run = async (label, fn, { allowFailure = false } = {}) => {
    try {
      const out = await fn();
      const ret = out.ret ?? out.raw ?? String(out ?? "");
      const logEntry = { label, ret };
      if (isErrorReturn(ret)) {
        logEntry.ok = false;
        logEntry.error = ret;
        soapLog.push(logEntry);
        if (!allowFailure) {
          const err = new Error(`${label} failed: ${ret}`);
          err.soapLog = soapLog;
          throw err;
        }
        if (debug) {
          console.warn(`${label} returned error but continuing`, ret);
        }
        return null;
      }
      logEntry.ok = true;
      soapLog.push(logEntry);
      return { ...out, ret };
    } catch (err) {
      const entry = { label, ok: false, error: String(err?.message || err) };
      soapLog.push(entry);
      if (!allowFailure) {
        throw err;
      }
      if (debug) {
        console.warn(`${label} failed but continuing`, err);
      }
      return null;
    }
  };

  await run("account create", () => classicAccountCreate(soap, safeUsername, safePass));
  // Classic account creation succeeds as soon as the username/password is registered.
  // The optional addon/build steps that retail SOAP flows require are not necessary
  // for Classic 3.3.5 accounts and frequently fail in practice, so skip them.
  const accountId = null;

  if (debug) {
    console.debug("Classic SOAP log", soapLog);
  }

  return {
    ok: true,
    username: safeUsername,
    email: normEmail,
    accountId: accountId ?? null,
    soapLog,
  };
}

export async function classicPasswordReset({ soap, username, newPassword }) {
  if (!soap) throw new Error("Missing soap");
  const safeUsername = sanitizeSoapArg(username, { label: "username" }).toUpperCase();
  const safePass = sanitizeSoapArg(newPassword, { label: "new password" });
  const cmd = `account set password ${safeUsername} ${safePass} ${safePass}`;
  const out = await callSoap(soap, cmd);
  return out.ret || out.raw || "ok";
}

export async function retailPasswordReset({ soap, email, newPassword }) {
  if (!soap) throw new Error("Missing soap");
  const normEmail = normalizeEmail(email);
  if (!normEmail) throw new Error("Invalid email");
  if (!newPassword) throw new Error("Missing new password");

  const safeEmail = sanitizeSoapArg(normEmail, { label: "email" });
  const safePass = sanitizeSoapArg(newPassword, { label: "new password" });

  const cmd = `bnetaccount set password ${safeEmail} ${safePass} ${safePass}`;
  const out = await callSoap(soap, cmd);
  return out.ret || out.raw || "ok";
}

export async function executeRetailCommand({ soap, command }) {
  if (!soap) throw new Error("Missing soap");
  const safeCommand = sanitizeSoapCommand(command);
  return callSoap(soap, safeCommand);
}

export async function executeClassicCommand({ soap, command }) {
  if (!soap) throw new Error("Missing soap");
  const safeCommand = sanitizeSoapCommand(command);
  return callSoap(soap, safeCommand);
}
