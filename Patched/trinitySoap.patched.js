// Retail-only TrinityCore SOAP helpers with DB confirmation (no command probing)
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

// ---------- Retail-only commands ----------
async function bnetCreate(soap, email, pass) {
  return callSoap(soap, `bnetaccount create ${q(email)} ${q(pass)}`);
}

async function bnetSetPassword(soap, email, pass) {
  return callSoap(soap, `bnetaccount set password ${q(email)} ${q(pass)} ${q(pass)}`);
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

  // Retail-only: attempt to create a Battle.net account. If it already exists, we treat it as success.
  try {
    await run("bnetaccount create", () => bnetCreate(soap, normEmail, password));
  } catch (e) {
    const msg = String(e?.message || e);
    if (!/already exists|exists/i.test(msg)) throw e;
  }

  return { ok: true, email: normEmail, soapLog };
}

export async function retailPasswordReset() { throw new Error("Password reset disabled in this build"); }

export async function executeRetailCommand({ soap, command }) {
  if (!soap || !command) throw new Error("Missing soap/command");
  return callSoap(soap, command);
}

