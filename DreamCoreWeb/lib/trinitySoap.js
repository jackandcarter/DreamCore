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
  if (!soap) throw new Error("Missing soap configuration");
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
      const ret = response?.ret ?? "";
      const retText = String(ret ?? "");
      record(`${label}: ${(retText || "ok").slice(0, 240)}`);
      if (isErrorReturn(ret)) {
        const err = new Error(`${label} returned error: ${retText}`);
        err.soapReturn = ret;
        throw err;
      }
      return response;
    } catch (err) {
      record(`${label} FAILED: ${String(err?.message || err).slice(0, 200)}`);
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

export async function retailPasswordReset({ soap, email, accountName, identifier, newPassword }) {
  if (!soap) throw new Error("Missing soap configuration");
  const raw = identifier ?? email ?? accountName;
  const target = (() => {
    if (typeof raw !== "string") return "";
    const trimmed = raw.trim();
    if (!trimmed) return "";
    return trimmed.includes("@") ? normalizeEmail(trimmed) : trimmed;
  })();

  if (!target) {
    throw new Error("Missing account identifier for password reset");
  }

  await bnetSetPassword(soap, target, newPassword);

  return {
    ok: true,
    target,
  };
}

export async function executeRetailCommand({ soap, command }) {
  if (!soap || !command) throw new Error("Missing soap/command");
  return callSoap(soap, command);
}

