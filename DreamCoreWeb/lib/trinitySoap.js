import crypto from 'crypto';
import mysql from 'mysql2/promise';

function escapeXml(s) {
  return String(s).replace(/[<>&'\"]/g, (c) => ({ '<': '&lt;', '>': '&gt;', '&': '&amp;', "'": '&apos;', '"': '&quot;' }[c]));
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

async function callSoap(soapConfig, command) {
  const { host, port, user, pass } = soapConfig;
  if (!host || !user || !pass) {
    throw new Error('Missing SOAP configuration');
  }
  const xml = buildSoapEnvelope(command);
  const auth = Buffer.from(`${user}:${pass}`).toString('base64');

  const resp = await fetch(`http://${host}:${port}/`, {
    method: 'POST',
    headers: {
      'Content-Type': 'text/xml; charset=utf-8',
      Authorization: `Basic ${auth}`,
    },
    body: xml,
  });

  const text = await resp.text();
  const fault = buildSoapFaultError(text);
  if (fault) throw fault;

  if (!resp.ok) {
    const err = new Error(`SOAP HTTP ${resp.status}`);
    err.responseBody = text;
    throw err;
  }

  return text;
}

export function createSoapExecutor(soapConfig) {
  return {
    execute: (command) => callSoap(soapConfig, command),
  };
}

export async function executeSoapCommand(soapConfig, command) {
  return callSoap(soapConfig, command);
}

function extractSoapReturn(text) {
  const m = text.match(/<return[^>]*>([\s\S]*?)<\/return>/i);
  return m ? m[1].trim() : text.trim();
}

export function parseSoapReturn(text) {
  return extractSoapReturn(text);
}

const q = (s) => `"${String(s).replace(/"/g, '\\"')}"`;

const normalizeEmail = (value) => String(value || '').trim().toLowerCase();

function wowAccountNameForEmail(email) {
  const normalized = normalizeEmail(email);
  const hash = crypto.createHash('sha1').update(normalized).digest('hex').slice(0, 8);
  return `w_${hash}`;
}

function stripEntities(s) {
  return String(s)
    // Remove TrinityCore color codes (e.g. |cffff0000 ... |r) and ANSI escapes.
    .replace(/\|c[0-9a-f]{8}/gi, '')
    .replace(/\|r/gi, '')
    .replace(/\u001B\[[0-9;]*m/gi, '')
    // Replace common XML/HTML entities with spaces so words stay separated.
    .replace(/&[a-z]+;|&#\d+;/gi, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

function messageIncludes(msg, patterns) {
  if (!msg) return false;
  const normalized = stripEntities(msg).toLowerCase();
  return patterns.some((phrase) => normalized.includes(phrase));
}

function isAlreadyExistsMessage(msg) {
  return messageIncludes(msg, [
    'already exists',
    'already linked',
    'already assigned',
    'already in use',
    'account exists',
    'account already created',
    'account already linked',
  ]);
}

export async function setPassword(soapConfig, identifier, newPassword) {
  const tries = [
    `bnetaccount set password ${q(identifier)} ${q(newPassword)}`,
    `account set password ${q(identifier)} ${q(newPassword)} ${q(newPassword)}`,
  ];
  let last;
  for (const cmd of tries) {
    try {
      const raw = await callSoap(soapConfig, cmd);
      const msg = stripEntities(extractSoapReturn(raw)).toLowerCase();
      last = raw;
      if (!/unknown command|no such command|usage:/.test(msg)) return raw;
    } catch (err) {
      if (err?.name === 'SOAPFault' && isAlreadyExistsMessage(String(err.message || ''))) {
        return 'ok';
      }
      last = err;
    }
  }
  if (last instanceof Error) throw last;
  return last ?? 'ok';
}

async function setBnetPassword(soapConfig, email, password) {
  return callSoap(soapConfig, `bnetaccount set password ${q(email)} ${q(password)}`);
}

async function setWowAccountPassword(soapConfig, accountName, password) {
  return callSoap(
    soapConfig,
    `account set password ${q(accountName)} ${q(password)} ${q(password)}`
  );
}

async function createWowAccount(soapConfig, accountName, password) {
  const cmd = `account create ${q(accountName)} ${q(password)}`;
  try {
    const raw = await callSoap(soapConfig, cmd);
    const msg = stripEntities(extractSoapReturn(raw));
    if (messageIncludes(msg, [
      'already exists',
      'account exists',
      'account already created',
    ])) {
      return 'exists';
    }
    if (messageIncludes(msg, ['account created', 'created', 'successfully created'])) {
      return 'created';
    }
    return 'created';
  } catch (err) {
    if (err?.name === 'SOAPFault' && isAlreadyExistsMessage(String(err.message || ''))) {
      return 'exists';
    }
    throw err;
  }
}

async function ensureNamedGameAccount(soapConfig, accountName, password) {
  const result = await createWowAccount(soapConfig, accountName, password);
  if (result === 'exists') {
    await setWowAccountPassword(soapConfig, accountName, password);
    return 'exists';
  }
  return 'created';
}

export async function ensureGameAccount(soapConfig, emailOrOptions, maybePassword) {
  let email = emailOrOptions;
  let password = maybePassword;
  let accountName;

  if (emailOrOptions && typeof emailOrOptions === 'object' && !Array.isArray(emailOrOptions)) {
    email = emailOrOptions.email;
    password = emailOrOptions.password;
    accountName = emailOrOptions.accountName;
  }

  if (!password) {
    throw new Error('Password is required to ensure game account');
  }

  const normalizedEmail = normalizeEmail(email);
  const name = accountName || wowAccountNameForEmail(normalizedEmail);
  return ensureNamedGameAccount(soapConfig, name, password);
}

export async function linkGameAccount(soapConfig, email, accountName) {
  if (!accountName) return 'skipped';
  const normalizedEmail = normalizeEmail(email);
  const cmd = `bnetaccount link ${q(normalizedEmail)} ${q(accountName)}`;
  try {
    const raw = await callSoap(soapConfig, cmd);
    const msg = stripEntities(extractSoapReturn(raw));
    if (messageIncludes(msg, [
      'already linked',
      'link already established',
      'already assigned',
    ])) {
      return 'already-linked';
    }
    if (messageIncludes(msg, ['linked', 'successfully linked'])) {
      return 'linked';
    }
    return 'linked';
  } catch (err) {
    if (err?.name === 'SOAPFault' && messageIncludes(err?.message || '', [
      'already linked',
      'already assigned',
      'link already established',
    ])) {
      return 'already-linked';
    }
    throw err;
  }
}

export async function createBnetAccount(soapConfig, email, password) {
  const normalizedEmail = normalizeEmail(email);
  const commands = [
    `bnetaccount create ${q(normalizedEmail)} ${q(password)}`,
    `account create ${q(normalizedEmail)} ${q(password)}`,
  ];
  let lastError = null;
  for (const cmd of commands) {
    try {
      const raw = await callSoap(soapConfig, cmd);
      const msg = stripEntities(extractSoapReturn(raw));
      if (messageIncludes(msg, [
        'already exists',
        'account exists',
        'account already created',
      ])) {
        return 'exists';
      }
      if (/unknown command|no such command|usage:/i.test(msg)) {
        continue;
      }
      return 'created';
    } catch (err) {
      if (err?.name === 'SOAPFault' && isAlreadyExistsMessage(String(err.message || ''))) {
        return 'exists';
      }
      lastError = err;
    }
  }
  if (lastError) throw lastError;
  return 'exists';
}

async function safeQuery(pool, sql, params) {
  if (!pool) return [];
  try {
    const [rows] = await pool.query(sql, params);
    return Array.isArray(rows) ? rows : [];
  } catch (err) {
    if (err && err.code === 'ER_NO_SUCH_TABLE') {
      return [];
    }
    err.query = sql;
    throw err;
  }
}

async function findAccountByUsername(authPool, username) {
  const rows = await safeQuery(
    authPool,
    'SELECT id, username, battlenet_account FROM account WHERE username = ? LIMIT 1',
    [username]
  );
  return rows.length ? rows[0] : null;
}

export async function getAccountSummary(authPool, email) {
  const normalizedEmail = normalizeEmail(email);
  const summary = {
    email: normalizedEmail,
    requestedEmail: email,
    wowAccountName: wowAccountNameForEmail(normalizedEmail),
    bnetAccount: null,
    linkedAccounts: [],
    legacyAccount: null,
  };

  const battlenet = await safeQuery(
    authPool,
    'SELECT id, email FROM battlenet_accounts WHERE email = ? LIMIT 1',
    [normalizedEmail]
  );
  if (battlenet.length) {
    summary.bnetAccount = { id: battlenet[0].id, table: 'battlenet_accounts' };
  } else {
    const bnetAccount = await safeQuery(
      authPool,
      'SELECT id, email FROM bnetaccount WHERE email = ? LIMIT 1',
      [normalizedEmail]
    );
    if (bnetAccount.length) {
      summary.bnetAccount = { id: bnetAccount[0].id, table: 'bnetaccount' };
    }
  }

  if (summary.bnetAccount) {
    const linked = await safeQuery(
      authPool,
      'SELECT id, username, email FROM account WHERE battlenet_account = ? OR email = ? ORDER BY id ASC',
      [summary.bnetAccount.id, normalizedEmail]
    );
    summary.linkedAccounts = linked.map((row) => ({ id: row.id, username: row.username, email: row.email }));
  } else {
    const legacy = await safeQuery(
      authPool,
      'SELECT id, username, email FROM account WHERE email = ? OR username = ? LIMIT 1',
      [normalizedEmail, normalizedEmail]
    );
    if (legacy.length) {
      summary.legacyAccount = {
        id: legacy[0].id,
        username: legacy[0].username,
        email: legacy[0].email,
      };
    }
  }

  return summary;
}

export async function resolveAccountForEmail({ soapConfig, authPool, email, password }) {
  if (!email || !password) throw new Error('Email and password are required');

  const normalizedEmail = normalizeEmail(email);
  const wowAccountName = wowAccountNameForEmail(normalizedEmail);

  const before = await getAccountSummary(authPool, normalizedEmail);
  const actions = {
    createdBnet: false,
    linkedAccount: false,
    createdGameAccount: false,
    passwordUpdated: false,
  };

  if (!before.bnetAccount) {
    const created = await createBnetAccount(soapConfig, normalizedEmail, password);
    if (created === 'exists') {
      await setBnetPassword(soapConfig, normalizedEmail, password);
      actions.passwordUpdated = true;
    } else {
      actions.createdBnet = true;
    }
  } else {
    await setBnetPassword(soapConfig, normalizedEmail, password);
    actions.passwordUpdated = true;
  }

  const existingGameAccount = await findAccountByUsername(authPool, wowAccountName);
  if (!existingGameAccount) {
    const ensured = await ensureNamedGameAccount(soapConfig, wowAccountName, password);
    if (ensured === 'created') {
      actions.createdGameAccount = true;
    } else {
      actions.passwordUpdated = true;
    }
  } else {
    await setWowAccountPassword(soapConfig, wowAccountName, password);
    actions.passwordUpdated = true;
  }

  const linkResult = await linkGameAccount(soapConfig, normalizedEmail, wowAccountName);
  if (linkResult === 'linked') {
    actions.linkedAccount = true;
  }

  const after = await getAccountSummary(authPool, normalizedEmail);
  let status;
  if (actions.createdBnet) {
    status = 'created';
  } else if (actions.linkedAccount || actions.createdGameAccount) {
    status = 'linked';
  } else if (actions.passwordUpdated) {
    status = 'password-reset';
  } else {
    status = 'linked';
  }

  return {
    status,
    wowAccountName,
    summary: {
      before,
      after,
    },
  };
}

export function createTrinitySoap(options) {
  const {
    soapConfig,
    authDb,
  } = options;

  let authPool = options.authPool;
  if (!authPool && authDb) {
    authPool = mysql.createPool({
      host: authDb.host,
      port: authDb.port,
      user: authDb.user,
      password: authDb.password,
      database: authDb.database,
      waitForConnections: true,
      connectionLimit: 10,
      namedPlaceholders: true,
    });
  }

  return {
    createBnetAccount: (email, password) => createBnetAccount(soapConfig, email, password),
    ensureGameAccount: (emailOrOptions, password) => ensureGameAccount(soapConfig, emailOrOptions, password),
    linkGameAccount: (email, accountName) => linkGameAccount(soapConfig, email, accountName),
    setPassword: (identifier, password) => setPassword(soapConfig, identifier, password),
    getAccountSummary: (email) => getAccountSummary(authPool, email),
    resolveAccountForEmail: (email, password) => resolveAccountForEmail({ soapConfig, authPool, email, password }),
    execute: (command) => callSoap(soapConfig, command),
    wowAccountNameForEmail: (value) => wowAccountNameForEmail(value),
    normalizeEmail: (value) => normalizeEmail(value),
    authPool,
  };
}

