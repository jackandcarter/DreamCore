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
  const norm = String(email || "").trim().toLowerCase();
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

async function getBattlenet(authPool, email) {
  return await row(
    authPool,
    "SELECT id, email FROM battlenet_accounts WHERE email = ? LIMIT 1",
    [email.toLowerCase()]
  );
}

async function getAccountByUsername(authPool, username) {
  return await row(
    authPool,
    "SELECT id, username, battlenet_account FROM account WHERE username = ? LIMIT 1",
    [username]
  );
}

async function getLinkedGameAccounts(authPool, bnetId) {
  return await rows(
    authPool,
    "SELECT id, username, battlenet_account FROM account WHERE battlenet_account = ? ORDER BY id ASC",
    [bnetId]
  );
}

// ---------- Retail-only commands ----------
async function bnetCreate(soap, email, pass) {
  return callSoap(soap, `bnetaccount create ${q(email)} ${q(pass)}`);
}

async function bnetSetPassword(soap, email, pass) {
  return callSoap(soap, `bnetaccount set password ${q(email)} ${q(pass)}`);
}

async function gameCreate(soap, username, pass) {
  return callSoap(soap, `account create ${q(username)} ${q(pass)}`);
}

async function gameSetPassword(soap, username, pass) {
  return callSoap(soap, `account set password ${q(username)} ${q(pass)} ${q(pass)}`);
}

async function linkBnetToGame(soap, email, username) {
  return callSoap(soap, `bnetaccount link ${q(email)} ${q(username)}`);
}

// ---------- High-level flows (confirm via DB, not text) ----------
export async function ensureRetailAccount({ soap, authPool, email, password }) {
  if (!soap || !authPool) throw new Error("Missing soap/authPool");
  const normEmail = String(email || "").trim().toLowerCase();
  const wowName = wowAccountNameForEmail(normEmail);

  const result = {
    email: normEmail,
    wowName,
    actions: {
      bnetCreated: false,
      bnetPasswordSet: false,
      gameCreated: false,
      gamePasswordSet: false,
      linked: false,
    },
    ids: { bnetId: null, gameId: null },
  };

  let bnet = await getBattlenet(authPool, normEmail);
  if (!bnet) {
    await bnetCreate(soap, normEmail, password);
    bnet = await getBattlenet(authPool, normEmail);
    if (!bnet) throw new Error("BNet create did not appear in DB");
    result.actions.bnetCreated = true;
  }
  result.ids.bnetId = Number(bnet.id);

  await bnetSetPassword(soap, normEmail, password);
  result.actions.bnetPasswordSet = true;

  let ga = await getAccountByUsername(authPool, wowName);
  if (!ga) {
    await gameCreate(soap, wowName, password);
    ga = await getAccountByUsername(authPool, wowName);
    if (!ga) throw new Error("Game account create did not appear in DB");
    result.actions.gameCreated = true;
  }
  result.ids.gameId = Number(ga.id);

  await gameSetPassword(soap, wowName, password);
  result.actions.gamePasswordSet = true;

  const beforeLink = await getLinkedGameAccounts(authPool, result.ids.bnetId);
  const alreadyLinked = beforeLink.some((a) => Number(a.id) === result.ids.gameId);
  if (!alreadyLinked) {
    await linkBnetToGame(soap, normEmail, wowName);
    const afterLink = await getLinkedGameAccounts(authPool, result.ids.bnetId);
    const linked = afterLink.some((a) => Number(a.id) === result.ids.gameId);
    if (!linked) throw new Error("Link did not appear in DB");
    result.actions.linked = true;
  } else {
    result.actions.linked = true;
  }

  return result;
}

export async function retailPasswordReset({ soap, authPool, email, newPassword }) {
  if (!soap || !authPool) throw new Error("Missing soap/authPool");
  const normEmail = String(email || "").trim().toLowerCase();
  const wowName = wowAccountNameForEmail(normEmail);

  const bnet = await getBattlenet(authPool, normEmail);
  if (!bnet) throw new Error("Battle.net account not found for password reset");

  await bnetSetPassword(soap, normEmail, newPassword);

  const ga = await getAccountByUsername(authPool, wowName);
  if (ga) {
    await gameSetPassword(soap, wowName, newPassword);
  }

  return {
    ok: true,
    email: normEmail,
    wowName,
    bnetId: Number(bnet.id),
    gameId: ga ? Number(ga.id) : null,
  };
}

export async function executeRetailCommand({ soap, command }) {
  if (!soap || !command) throw new Error("Missing soap/command");
  return callSoap(soap, command);
}

