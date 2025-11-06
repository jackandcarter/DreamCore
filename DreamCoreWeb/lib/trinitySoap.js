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
    `bnetaccount set password ${q(identifier)} ${q(newPassword)} ${q(newPassword)}`,
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
      throw err;
    }
  }
  return last ?? 'ok';
}

export async function ensureGameAccount(soapConfig, email) {
  const cmd = `bnetaccount gameaccountcreate ${q(email)}`;
  try {
    return await callSoap(soapConfig, cmd);
  } catch (err) {
    if (err?.name === 'SOAPFault' && messageIncludes(err?.message || '', [
      'already exists',
      'game account exists',
      'already has game account',
    ])) {
      return 'ok';
    }
    throw err;
  }
}

export async function linkGameAccount(soapConfig, email, accountName) {
  if (!accountName) return 'skipped';
  const cmd = `bnetaccount link ${q(email)} ${q(accountName)}`;
  try {
    return await callSoap(soapConfig, cmd);
  } catch (err) {
    if (err?.name === 'SOAPFault' && messageIncludes(err?.message || '', [
      'already linked',
      'already exists',
      'already assigned',
      'link already established',
    ])) {
      return 'ok';
    }
    throw err;
  }
}

export async function createBnetAccount(soapConfig, email, password) {
  const commands = [
    `bnetaccount create ${q(email)} ${q(password)}`,
    `account create ${q(email)} ${q(password)}`,
  ];
  let lastError = null;
  for (const cmd of commands) {
    try {
      const raw = await callSoap(soapConfig, cmd);
      const msg = stripEntities(extractSoapReturn(raw)).toLowerCase();
      if (/unknown command|no such command|usage:/.test(msg)) {
        continue;
      }
      return raw;
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

export async function getAccountSummary(authPool, email) {
  const summary = {
    email,
    bnetAccount: null,
    linkedAccounts: [],
    legacyAccount: null,
  };

  const battlenet = await safeQuery(
    authPool,
    'SELECT id, email FROM battlenet_accounts WHERE email = ? LIMIT 1',
    [email]
  );
  if (battlenet.length) {
    summary.bnetAccount = { id: battlenet[0].id, table: 'battlenet_accounts' };
  } else {
    const bnetAccount = await safeQuery(
      authPool,
      'SELECT id, email FROM bnetaccount WHERE email = ? LIMIT 1',
      [email]
    );
    if (bnetAccount.length) {
      summary.bnetAccount = { id: bnetAccount[0].id, table: 'bnetaccount' };
    }
  }

  if (summary.bnetAccount) {
    const linked = await safeQuery(
      authPool,
      'SELECT id, username, email FROM account WHERE battlenet_account = ? OR email = ? ORDER BY id ASC',
      [summary.bnetAccount.id, email]
    );
    summary.linkedAccounts = linked.map((row) => ({ id: row.id, username: row.username, email: row.email }));
  } else {
    const legacy = await safeQuery(
      authPool,
      'SELECT id, username, email FROM account WHERE email = ? OR username = ? LIMIT 1',
      [email, email]
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

  const before = await getAccountSummary(authPool, email);
  const actions = {
    createdBnet: false,
    linkedAccount: false,
    createdGameAccount: false,
    passwordUpdated: false,
  };

  if (!before.bnetAccount) {
    const created = await createBnetAccount(soapConfig, email, password);
    if (created === 'exists') {
      await setPassword(soapConfig, email, password);
      actions.passwordUpdated = true;
    } else {
      actions.createdBnet = true;
    }
  } else {
    await setPassword(soapConfig, email, password);
    actions.passwordUpdated = true;
  }

  let currentSummary = await getAccountSummary(authPool, email);
  if (!currentSummary.bnetAccount) {
    throw new Error('Unable to ensure Battle.net account exists for email');
  }

  if (currentSummary.linkedAccounts.length === 0) {
    const accountToLink = currentSummary.legacyAccount?.username || before.legacyAccount?.username;
    if (accountToLink) {
      await linkGameAccount(soapConfig, email, accountToLink);
      actions.linkedAccount = true;
      currentSummary = await getAccountSummary(authPool, email);
    }
  }

  if (currentSummary.linkedAccounts.length === 0) {
    await ensureGameAccount(soapConfig, email);
    actions.createdGameAccount = true;
    currentSummary = await getAccountSummary(authPool, email);
  } else {
    // Ensure at least one retail account exists under the Battle.net.
    await ensureGameAccount(soapConfig, email);
  }

  const after = currentSummary;
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
    ensureGameAccount: (email) => ensureGameAccount(soapConfig, email),
    linkGameAccount: (email, accountName) => linkGameAccount(soapConfig, email, accountName),
    setPassword: (identifier, password) => setPassword(soapConfig, identifier, password),
    getAccountSummary: (email) => getAccountSummary(authPool, email),
    resolveAccountForEmail: (email, password) => resolveAccountForEmail({ soapConfig, authPool, email, password }),
    execute: (command) => callSoap(soapConfig, command),
    authPool,
  };
}

