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
  if (!soap || !command) throw new Error("Missing soap/command");
  return callSoap(soap, command);
}
