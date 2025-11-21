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
import * as itemEnums from './itemEnums.js';
import {
  makeAuthPool,
  makeSoapConfig,
  ensureRetailAccount,
  ensureClassicAccount,
  classicPasswordReset,
  executeRetailCommand,
  executeClassicCommand,
  normalizeEmail,
  retailPasswordReset,
  sanitizeSoapCommand,
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
  BRAND_NAME: process.env.BRAND_NAME || 'DreamCore Master',
  HEADER_TITLE: process.env.HEADER_TITLE || 'DreamCore Master Portal',
  CORNER_LOGO: process.env.CORNER_LOGO || 'DemiDevUnit',
  GUIDE_URL:
    process.env.GUIDE_URL ||
    'https://hissing-polonium-8c0.notion.site/Guide-to-install-and-play-DreamCore-2a22305ea64f80a58008c5024bfe8555',

  CLASSIC_BRAND_NAME: process.env.CLASSIC_BRAND_NAME || 'DreamCore Classic',
  CLASSIC_HEADER_TITLE: process.env.CLASSIC_HEADER_TITLE || 'DreamCore Classic Portal',
  CLASSIC_CORNER_LOGO: process.env.CLASSIC_CORNER_LOGO || 'DemiDevUnit',
  CLASSIC_GUIDE_URL:
    process.env.CLASSIC_GUIDE_URL ||
    process.env.GUIDE_URL ||
    'https://hissing-polonium-8c0.notion.site/Guide-to-install-and-play-DreamCore-2a22305ea64f80a58008c5024bfe8555',
  CLASSIC_CLIENT_DOWNLOAD_URL:
    process.env.CLASSIC_CLIENT_DOWNLOAD_URL ||
    'https://cdn.the-demiurge.com/WoWDC.zip',
  CLASSIC_BASE_URL:
    process.env.CLASSIC_BASE_URL ||
    `${process.env.BASE_URL || 'https://wow.the-demiurge.com'}/classic`,
  CLASSIC_TURNSTILE_SITEKEY:
    process.env.CLASSIC_TURNSTILE_SITEKEY ||
    process.env.TURNSTILE_SITEKEY ||
    '1x00000000000000000000AA',
  CLASSIC_TURNSTILE_SECRET:
    process.env.CLASSIC_TURNSTILE_SECRET ||
    process.env.TURNSTILE_SECRET ||
    '1x0000000000000000000000000000000AA',

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
  GM_ONLINE_POLL_MS: Number(process.env.GM_ONLINE_POLL_MS || 20 * 1000),
  GM_CLASSIC_ONLINE_LIMIT: Number(process.env.GM_CLASSIC_ONLINE_LIMIT || 12),
  GM_DEBUG: (process.env.GM_DEBUG || 'false').toLowerCase() === 'true',
  RETAIL_CHARACTER_DEBUG:
    (process.env.RETAIL_CHARACTER_DEBUG || 'false').toLowerCase() === 'true',
};

function gmDebug(message, details) {
  if (!CONFIG.GM_DEBUG) {
    return;
  }
  const timestamp = new Date().toISOString();
  if (details === undefined) {
    console.log(`[GM DEBUG ${timestamp}] ${message}`);
    return;
  }
  console.log(`[GM DEBUG ${timestamp}] ${message}`, details);
}

function retailCharacterDebug(message, details) {
  if (!CONFIG.RETAIL_CHARACTER_DEBUG) {
    return;
  }
  const timestamp = new Date().toISOString();
  if (details === undefined) {
    console.log(`[RETAIL CHAR DEBUG ${timestamp}] ${message}`);
    return;
  }
  console.log(`[RETAIL CHAR DEBUG ${timestamp}] ${message}`, details);
}

const SOAP = makeSoapConfig({
  host: CONFIG.TC_SOAP_HOST,
  port: CONFIG.TC_SOAP_PORT,
  user: CONFIG.TC_SOAP_USER,
  pass: CONFIG.TC_SOAP_PASS,
});

const CLASSIC_SOAP = makeSoapConfig({
  host: process.env.CLASSIC_SOAP_HOST || CONFIG.TC_SOAP_HOST || '127.0.0.1',
  port: Number(process.env.CLASSIC_SOAP_PORT || 7888),
  user: process.env.CLASSIC_SOAP_USER || CONFIG.TC_SOAP_USER,
  pass: process.env.CLASSIC_SOAP_PASS || CONFIG.TC_SOAP_PASS,
});

const RESET_TOKEN_TTL_MS = CONFIG.RESET_TOKEN_TTL_MIN * 60 * 1000;

const SHARED_STYLES = `
    :root {
      --dc-border-gradient: linear-gradient(120deg, #a855f7, #6366f1, #0ea5e9);
    }
    h1, h2, h3, h4, label {
      text-shadow: 0 12px 32px rgba(8, 7, 27, 0.55), 0 0 20px rgba(99, 102, 241, 0.4);
    }
    p, span, a, small {
      text-shadow: 0 6px 18px rgba(8, 7, 27, 0.45);
    }
    .gradient-border {
      position: relative;
      border: 1px solid transparent;
      box-shadow: 0 20px 45px rgba(8, 7, 27, 0.65), inset 0 0 25px rgba(79, 70, 229, 0.12);
    }
    .gradient-border::before {
      content: "";
      position: absolute;
      inset: 0;
      border-radius: inherit;
      padding: 1px;
      background: var(--dc-border-gradient);
      -webkit-mask:
        linear-gradient(#000 0 0) content-box,
        linear-gradient(#000 0 0);
      mask:
        linear-gradient(#000 0 0) content-box,
        linear-gradient(#000 0 0);
      -webkit-mask-composite: xor;
      mask-composite: exclude;
      pointer-events: none;
    }
    .gradient-divider {
      border: 0;
      height: 1px;
      background-image: var(--dc-border-gradient);
      box-shadow: 0 12px 28px rgba(14, 165, 233, 0.35);
      border-radius: 999px;
    }
    .glow-input {
      background: rgba(255, 255, 255, 0.97);
      color: #0f172a;
      border: 1px solid rgba(148, 163, 184, 0.6);
      box-shadow: 0 18px 40px rgba(15, 23, 42, 0.3);
      transition: box-shadow 0.25s ease, border-color 0.25s ease, background 0.25s ease;
    }
    .glow-input:focus {
      border-color: transparent;
      box-shadow: 0 0 0 2px rgba(129, 140, 248, 0.7), 0 20px 50px rgba(79, 70, 229, 0.4);
      background: rgba(255, 255, 255, 0.99);
    }
    .glow-input::placeholder {
      color: #475569;
      opacity: 1;
      text-shadow: 0 3px 8px rgba(15, 23, 42, 0.35);
    }
    .dark-select {
      background: rgba(15, 23, 42, 0.9);
      color: #f8fafc;
      border: 1px solid rgba(99, 102, 241, 0.6);
      box-shadow: 0 20px 45px rgba(8, 7, 27, 0.65);
      transition: box-shadow 0.25s ease, border-color 0.25s ease, background 0.25s ease;
    }
    .dark-select:focus {
      border-color: rgba(14, 165, 233, 0.8);
      box-shadow: 0 0 0 2px rgba(14, 165, 233, 0.35), 0 22px 50px rgba(8, 7, 27, 0.8);
    }
    .dark-select option {
      color: #f8fafc;
      background-color: #0f172a;
    }
    .corner-logo {
      position: fixed;
      top: clamp(1rem, 3vw, 2rem);
      left: clamp(1rem, 3vw, 2rem);
      z-index: 60;
      padding: 0.35rem 1rem;
      border-radius: 999px;
      background: rgba(2, 6, 23, 0.72);
      border: 1px solid rgba(129, 140, 248, 0.35);
      box-shadow: 0 18px 45px rgba(2, 6, 23, 0.65);
      pointer-events: none;
      backdrop-filter: blur(8px);
    }
    @media (max-width: 480px) {
      .corner-logo {
        padding: 0.25rem 0.75rem;
        letter-spacing: 0.22em;
      }
    }
    .corner-logo-offset {
      padding-top: clamp(5.5rem, 11vw, 7.5rem);
    }
    .client-username-glow {
      color: #e0f2fe;
      text-shadow: 0 0 14px rgba(56, 189, 248, 0.55), 0 0 28px rgba(129, 140, 248, 0.45);
      animation: username-pulse 1.35s ease-in-out infinite;
      letter-spacing: 0.02em;
    }
    @keyframes username-pulse {
      0%, 100% { transform: translateY(0); opacity: 1; }
      50% { transform: translateY(-2px); opacity: 0.8; }
    }
`;

// ----- DB (MariaDB for pending verifications) -----
// All TrinityCore-related databases (auth + characters) share the same default
// credentials in our local MariaDB installs. Default to "trinity" unless the
// environment overrides it.
const DEFAULT_DB_PASS = process.env.CHAR_DB_PASS || 'trinity';

const DB = {
  HOST: process.env.DB_HOST || '127.0.0.1',
  PORT: Number(process.env.DB_PORT || 3306),
  USER: process.env.DB_USER || 'trinity',
  PASS: process.env.DB_PASS || DEFAULT_DB_PASS,
  NAME: process.env.DB_NAME || 'tc_register',
};

const CLASSIC_DB = {
  HOST: process.env.CLASSIC_DB_HOST || '127.0.0.1',
  PORT: Number(process.env.CLASSIC_DB_PORT || 3306),
  USER: process.env.CLASSIC_DB_USER || 'trinity',
  PASS: process.env.CLASSIC_DB_PASS || DEFAULT_DB_PASS,
  NAME: process.env.CLASSIC_DB_NAME || 'tc_register_classic',
};

const AUTH_DB = {
  HOST: process.env.AUTH_DB_HOST || '127.0.0.1',
  PORT: Number(process.env.AUTH_DB_PORT || 3306),
  USER: process.env.AUTH_DB_USER || 'trinity',
  PASS: process.env.AUTH_DB_PASS || DEFAULT_DB_PASS,
  NAME: process.env.AUTH_DB_NAME || 'auth',
};

const CLASSIC_AUTH_DB = {
  HOST: process.env.CLASSIC_AUTH_DB_HOST || process.env.AUTH_DB_HOST || '127.0.0.1',
  PORT: Number(process.env.CLASSIC_AUTH_DB_PORT || process.env.AUTH_DB_PORT || 3306),
  USER: process.env.CLASSIC_AUTH_DB_USER || process.env.AUTH_DB_USER || 'trinity',
  PASS: process.env.CLASSIC_AUTH_DB_PASS || process.env.AUTH_DB_PASS || DEFAULT_DB_PASS,
  NAME: process.env.CLASSIC_AUTH_DB_NAME || 'tc_auth_335',
};

const CHAR_DB = {
  HOST: process.env.CHAR_DB_HOST || AUTH_DB.HOST || '127.0.0.1',
  PORT: Number(process.env.CHAR_DB_PORT || AUTH_DB.PORT || 3306),
  USER: process.env.CHAR_DB_USER || AUTH_DB.USER || 'trinity',
  PASS: process.env.CHAR_DB_PASS || AUTH_DB.PASS || DEFAULT_DB_PASS,
  NAME: process.env.CHAR_DB_NAME || 'characters',
};

const CLASSIC_CHAR_DB = {
  // Classic character roster should reuse the Trinity character credentials by default.
  HOST: process.env.CLASSIC_CHAR_DB_HOST || CHAR_DB.HOST,
  PORT: Number(process.env.CLASSIC_CHAR_DB_PORT || CHAR_DB.PORT || process.env.CLASSIC_DB_PORT || 3306),
  USER: process.env.CLASSIC_CHAR_DB_USER || CHAR_DB.USER || 'trinity',
  PASS: process.env.CLASSIC_CHAR_DB_PASS || CHAR_DB.PASS || DEFAULT_DB_PASS,
  NAME: process.env.CLASSIC_CHAR_DB_NAME || 'tc_characters_335',
};

const WORLD_DB = {
  HOST: process.env.WORLD_DB_HOST || AUTH_DB.HOST || '127.0.0.1',
  PORT: Number(process.env.WORLD_DB_PORT || AUTH_DB.PORT || 3306),
  USER: process.env.WORLD_DB_USER || AUTH_DB.USER || 'trinity',
  PASS: process.env.WORLD_DB_PASS || AUTH_DB.PASS || DEFAULT_DB_PASS,
  NAME: process.env.WORLD_DB_NAME || 'world',
};

const CLASSIC_WORLD_DB = {
  HOST: process.env.CLASSIC_WORLD_DB_HOST || WORLD_DB.HOST,
  PORT: Number(process.env.CLASSIC_WORLD_DB_PORT || WORLD_DB.PORT || 3306),
  USER: process.env.CLASSIC_WORLD_DB_USER || WORLD_DB.USER || 'trinity',
  PASS: process.env.CLASSIC_WORLD_DB_PASS || WORLD_DB.PASS || DEFAULT_DB_PASS,
  NAME: process.env.CLASSIC_WORLD_DB_NAME || 'tc_world_335',
};

function makeAuthPoolFromEnv(prefix) {
  const normalized = String(prefix || '').toUpperCase();
  const lookup = {
    AUTH_DB,
    CLASSIC_AUTH_DB,
  };
  const config = lookup[normalized];
  if (!config) {
    throw new Error(`Unknown auth DB prefix: ${prefix}`);
  }
  return makeAuthPool({
    host: config.HOST,
    port: config.PORT,
    user: config.USER,
    password: config.PASS,
    database: config.NAME,
  });
}

// Bootstrap: ensure database exists using a one-off connection
const admin = await mysql.createConnection({
  host: DB.HOST, port: DB.PORT, user: DB.USER, password: DB.PASS,
  multipleStatements: true,
});
await admin.query(
  `CREATE DATABASE IF NOT EXISTS \`${DB.NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`
);
await admin.end();

const classicAdmin = await mysql.createConnection({
  host: CLASSIC_DB.HOST,
  port: CLASSIC_DB.PORT,
  user: CLASSIC_DB.USER,
  password: CLASSIC_DB.PASS,
  multipleStatements: true,
});
await classicAdmin.query(
  `CREATE DATABASE IF NOT EXISTS \`${CLASSIC_DB.NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`
);
await classicAdmin.end();

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

const classicPool = await mysql.createPool({
  host: CLASSIC_DB.HOST,
  port: CLASSIC_DB.PORT,
  user: CLASSIC_DB.USER,
  password: CLASSIC_DB.PASS,
  database: CLASSIC_DB.NAME,
  waitForConnections: true,
  connectionLimit: 10,
  namedPlaceholders: true,
  multipleStatements: true,
});

const authPool = makeAuthPoolFromEnv('AUTH_DB');
const classicAuthPool = makeAuthPoolFromEnv('CLASSIC_AUTH_DB');

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

const classicCharPool =
  CHAR_DB.HOST === CLASSIC_CHAR_DB.HOST &&
  CHAR_DB.PORT === CLASSIC_CHAR_DB.PORT &&
  CHAR_DB.USER === CLASSIC_CHAR_DB.USER &&
  CHAR_DB.PASS === CLASSIC_CHAR_DB.PASS &&
  CHAR_DB.NAME === CLASSIC_CHAR_DB.NAME
    ? charPool
    : await mysql.createPool({
        host: CLASSIC_CHAR_DB.HOST,
        port: CLASSIC_CHAR_DB.PORT,
        user: CLASSIC_CHAR_DB.USER,
        password: CLASSIC_CHAR_DB.PASS,
        database: CLASSIC_CHAR_DB.NAME,
        waitForConnections: true,
        connectionLimit: 10,
        namedPlaceholders: true,
      });

const worldPool = await mysql.createPool({
  host: WORLD_DB.HOST,
  port: WORLD_DB.PORT,
  user: WORLD_DB.USER,
  password: WORLD_DB.PASS,
  database: WORLD_DB.NAME,
  waitForConnections: true,
  connectionLimit: 10,
  namedPlaceholders: true,
});

const classicWorldPool =
  WORLD_DB.HOST === CLASSIC_WORLD_DB.HOST &&
  WORLD_DB.PORT === CLASSIC_WORLD_DB.PORT &&
  WORLD_DB.USER === CLASSIC_WORLD_DB.USER &&
  WORLD_DB.PASS === CLASSIC_WORLD_DB.PASS &&
  WORLD_DB.NAME === CLASSIC_WORLD_DB.NAME
    ? worldPool
    : await mysql.createPool({
        host: CLASSIC_WORLD_DB.HOST,
        port: CLASSIC_WORLD_DB.PORT,
        user: CLASSIC_WORLD_DB.USER,
        password: CLASSIC_WORLD_DB.PASS,
        database: CLASSIC_WORLD_DB.NAME,
        waitForConnections: true,
        connectionLimit: 10,
        namedPlaceholders: true,
      });

const REALM_DB_CONFIGS = loadRealmDbConfigs();
const REALM_POOL_ENTRIES = buildRealmPoolEntries(REALM_DB_CONFIGS);
const REALM_FAMILY_MAP = {
  retail: REALM_POOL_ENTRIES.filter((entry) => entry?.config?.family !== 'classic'),
  classic: REALM_POOL_ENTRIES.filter((entry) => entry?.config?.family === 'classic'),
};
const REALM_LOOKUP = createRealmLookup(
  REALM_FAMILY_MAP.retail.length ? REALM_FAMILY_MAP.retail : REALM_POOL_ENTRIES
);
const CLASSIC_REALM_LOOKUP = createRealmLookup(
  REALM_FAMILY_MAP.classic.length ? REALM_FAMILY_MAP.classic : REALM_POOL_ENTRIES
);

const CLASSIC_CUSTOM_ITEM_MIN = Number(process.env.CLASSIC_CUSTOM_ITEM_MIN) || 60000;
const CLASSIC_CUSTOM_ITEM_MAX = Number(process.env.CLASSIC_CUSTOM_ITEM_MAX) || 69999;

const ITEM_TEMPLATE_COLUMNS = [
  'entry',
  'class',
  'subclass',
  'SoundOverrideSubclass',
  'name',
  'displayid',
  'Quality',
  'Flags',
  'FlagsExtra',
  'BuyCount',
  'BuyPrice',
  'SellPrice',
  'InventoryType',
  'AllowableClass',
  'AllowableRace',
  'ItemLevel',
  'RequiredLevel',
  'RequiredSkill',
  'RequiredSkillRank',
  'requiredspell',
  'requiredhonorrank',
  'RequiredCityRank',
  'RequiredReputationFaction',
  'RequiredReputationRank',
  'maxcount',
  'stackable',
  'ContainerSlots',
  'StatsCount',
  'stat_type1',
  'stat_value1',
  'stat_type2',
  'stat_value2',
  'stat_type3',
  'stat_value3',
  'stat_type4',
  'stat_value4',
  'stat_type5',
  'stat_value5',
  'stat_type6',
  'stat_value6',
  'stat_type7',
  'stat_value7',
  'stat_type8',
  'stat_value8',
  'stat_type9',
  'stat_value9',
  'stat_type10',
  'stat_value10',
  'ScalingStatDistribution',
  'ScalingStatValue',
  'dmg_min1',
  'dmg_max1',
  'dmg_type1',
  'dmg_min2',
  'dmg_max2',
  'dmg_type2',
  'armor',
  'holy_res',
  'fire_res',
  'nature_res',
  'frost_res',
  'shadow_res',
  'arcane_res',
  'delay',
  'ammo_type',
  'RangedModRange',
  'spellid_1',
  'spelltrigger_1',
  'spellcharges_1',
  'spellppmRate_1',
  'spellcooldown_1',
  'spellcategory_1',
  'spellcategorycooldown_1',
  'spellid_2',
  'spelltrigger_2',
  'spellcharges_2',
  'spellppmRate_2',
  'spellcooldown_2',
  'spellcategory_2',
  'spellcategorycooldown_2',
  'spellid_3',
  'spelltrigger_3',
  'spellcharges_3',
  'spellppmRate_3',
  'spellcooldown_3',
  'spellcategory_3',
  'spellcategorycooldown_3',
  'spellid_4',
  'spelltrigger_4',
  'spellcharges_4',
  'spellppmRate_4',
  'spellcooldown_4',
  'spellcategory_4',
  'spellcategorycooldown_4',
  'spellid_5',
  'spelltrigger_5',
  'spellcharges_5',
  'spellppmRate_5',
  'spellcooldown_5',
  'spellcategory_5',
  'spellcategorycooldown_5',
  'bonding',
  'description',
  'PageText',
  'LanguageID',
  'PageMaterial',
  'startquest',
  'lockid',
  'Material',
  'sheath',
  'RandomProperty',
  'RandomSuffix',
  'block',
  'itemset',
  'MaxDurability',
  'area',
  'Map',
  'BagFamily',
  'TotemCategory',
  'socketColor_1',
  'socketContent_1',
  'socketColor_2',
  'socketContent_2',
  'socketColor_3',
  'socketContent_3',
  'socketBonus',
  'GemProperties',
  'RequiredDisenchantSkill',
  'ArmorDamageModifier',
  'duration',
  'ItemLimitCategory',
  'HolidayId',
  'ScriptName',
  'DisenchantID',
  'FoodType',
  'minMoneyLoot',
  'maxMoneyLoot',
  'flagsCustom',
  'VerifiedBuild',
];

const ITEM_TEMPLATE_STRING_FIELDS = new Set(['name', 'description', 'ScriptName']);
const ITEM_TEMPLATE_MAX_LENGTHS = {
  name: 255,
  description: 255,
  ScriptName: 64,
};
const CLASSIC_WEAPON_FIELD_BOUNDS = {
  ItemLevel: { min: 0, max: 500 },
  RequiredLevel: { min: 0, max: 255 },
  Quality: { min: 0, max: 7 },
  InventoryType: { min: 0, max: 40 },
  displayid: { min: 0, max: 2000000 },
  BuyCount: { min: 1, max: 255 },
  BuyPrice: { min: 0, max: 2000000000 },
  SellPrice: { min: 0, max: 2000000000 },
  maxcount: { min: 0, max: 255 },
  stackable: { min: 0, max: 1000 },
  StatsCount: { min: 0, max: 10 },
  delay: { min: 0, max: 10000 },
  armor: { min: 0, max: 10000 },
  holy_res: { min: 0, max: 1000 },
  fire_res: { min: 0, max: 1000 },
  nature_res: { min: 0, max: 1000 },
  frost_res: { min: 0, max: 1000 },
  shadow_res: { min: 0, max: 1000 },
  arcane_res: { min: 0, max: 1000 },
  ammo_type: { min: 0, max: 5 },
  RangedModRange: { min: 0, max: 1000 },
  block: { min: 0, max: 1000 },
  MaxDurability: { min: 0, max: 500 },
  minMoneyLoot: { min: 0, max: 2000000000 },
  maxMoneyLoot: { min: 0, max: 2000000000 },
};
const CLASSIC_WEAPON_DAMAGE_LIMIT = 100000;
const CLASSIC_WEAPON_STAT_ABS_MAX = 10000;

const GM_COMMAND_CACHE = new Map();
const GM_COMMAND_CACHE_TTL_MS = Math.max(
  Number(process.env.GM_COMMAND_CACHE_TTL_MS) || 15 * 60 * 1000,
  30 * 1000
);

// Ensure table exists (and de-dupe by email)
await pool.query(`
  CREATE TABLE IF NOT EXISTS pending (
    token VARCHAR(64) PRIMARY KEY,
    username VARCHAR(32) NOT NULL,
    password VARCHAR(128) NOT NULL,
    email VARCHAR(254) NOT NULL,
    game_type VARCHAR(16) NOT NULL DEFAULT 'retail',
    created_at BIGINT NOT NULL,
    KEY idx_created_at (created_at),
    UNIQUE KEY uniq_email (email)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
`);

await classicPool.query(`
  CREATE TABLE IF NOT EXISTS pending_classic (
    token VARCHAR(64) PRIMARY KEY,
    username VARCHAR(32) NOT NULL,
    password VARCHAR(128) NOT NULL,
    email VARCHAR(254) NOT NULL,
    created_at BIGINT NOT NULL,
    KEY idx_created_at (created_at),
    UNIQUE KEY uniq_email_classic (email)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
`);

await pool.query(`
  CREATE TABLE IF NOT EXISTS pending_classic (
    token VARCHAR(64) PRIMARY KEY,
    username VARCHAR(32) NOT NULL,
    password VARCHAR(128) NOT NULL,
    email VARCHAR(254) NOT NULL,
    created_at BIGINT NOT NULL,
    KEY idx_created_at (created_at),
    UNIQUE KEY uniq_email_classic (email)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
`);

await pool.query(`
  CREATE TABLE IF NOT EXISTS sessions (
    id CHAR(64) PRIMARY KEY,
    portal_user_id BIGINT UNSIGNED NOT NULL,
    account_id BIGINT UNSIGNED DEFAULT NULL,
    email VARCHAR(254) NOT NULL,
    username VARCHAR(64) DEFAULT NULL,
    retail_accounts_json TEXT DEFAULT NULL,
    classic_accounts_json TEXT DEFAULT NULL,
    retail_gmlevel_json TEXT DEFAULT NULL,
    classic_gmlevel_json TEXT DEFAULT NULL,
    created_at BIGINT NOT NULL,
    expires_at BIGINT NOT NULL,
    last_ip VARCHAR(64) DEFAULT NULL,
    last_user_agent VARCHAR(255) DEFAULT NULL,
    KEY idx_account (account_id),
    KEY idx_expires (expires_at),
    KEY idx_session_portal_user (portal_user_id)
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

await pool.query(`
  CREATE TABLE IF NOT EXISTS portal_users (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    email VARCHAR(254) NOT NULL,
    username VARCHAR(64) DEFAULT NULL,
    password_hash VARBINARY(128) NOT NULL,
    salt VARBINARY(64) NOT NULL,
    version TINYINT UNSIGNED NOT NULL,
    created_at BIGINT NOT NULL,
    updated_at BIGINT NOT NULL,
    last_login_at BIGINT DEFAULT NULL,
    login_count BIGINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE KEY uniq_portal_email (email),
    UNIQUE KEY uniq_portal_username (username)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
`);

await pool.query(`
  CREATE TABLE IF NOT EXISTS portal_user_retail_accounts (
    portal_user_id BIGINT UNSIGNED NOT NULL,
    retail_account_id BIGINT UNSIGNED NOT NULL,
    linked_at BIGINT NOT NULL,
    PRIMARY KEY (portal_user_id, retail_account_id),
    UNIQUE KEY uniq_portal_retail_account (retail_account_id),
    CONSTRAINT fk_portal_retail_user FOREIGN KEY (portal_user_id)
      REFERENCES portal_users(id) ON DELETE CASCADE
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
`);

await pool.query(`
  CREATE TABLE IF NOT EXISTS portal_user_classic_accounts (
    portal_user_id BIGINT UNSIGNED NOT NULL,
    classic_account_id BIGINT UNSIGNED NOT NULL,
    linked_at BIGINT NOT NULL,
    PRIMARY KEY (portal_user_id, classic_account_id),
    UNIQUE KEY uniq_portal_classic_account (classic_account_id),
    CONSTRAINT fk_portal_classic_user FOREIGN KEY (portal_user_id)
      REFERENCES portal_users(id) ON DELETE CASCADE
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
`);

await pool.query(`
  CREATE TABLE IF NOT EXISTS portal_audit_logs (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    portal_user_id BIGINT UNSIGNED NOT NULL,
    action VARCHAR(64) NOT NULL,
    details TEXT DEFAULT NULL,
    created_at BIGINT NOT NULL,
    PRIMARY KEY (id),
    KEY idx_portal_audit_user (portal_user_id),
    KEY idx_portal_audit_action (action)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
`);

async function addColumnIfMissing(table, clause) {
  try {
    await pool.query(`ALTER TABLE \`${table}\` ADD COLUMN ${clause}`);
  } catch (err) {
    if (err?.code === 'ER_DUP_FIELDNAME') {
      return;
    }
    throw err;
  }
}

async function addIndexIfMissing(table, clause) {
  try {
    await pool.query(`ALTER TABLE \`${table}\` ${clause}`);
  } catch (err) {
    if (err?.code === 'ER_DUP_KEYNAME') {
      return;
    }
    if (err?.code === 'ER_DUP_KEY') {
      return;
    }
    throw err;
  }
}

async function ensurePortalSchemaUpgrades() {
  await addColumnIfMissing('portal_users', 'username VARCHAR(64) DEFAULT NULL AFTER email');
  await addIndexIfMissing('portal_users', 'ADD UNIQUE KEY uniq_portal_username (username)');
  await addColumnIfMissing('sessions', 'portal_user_id BIGINT UNSIGNED DEFAULT NULL AFTER id');
  await addColumnIfMissing('sessions', 'username VARCHAR(64) DEFAULT NULL AFTER email');
  await addColumnIfMissing('sessions', 'retail_accounts_json TEXT DEFAULT NULL AFTER username');
  await addColumnIfMissing('sessions', 'classic_accounts_json TEXT DEFAULT NULL AFTER retail_accounts_json');
  await addColumnIfMissing('sessions', 'retail_gmlevel_json TEXT DEFAULT NULL AFTER classic_accounts_json');
  await addColumnIfMissing('sessions', 'classic_gmlevel_json TEXT DEFAULT NULL AFTER retail_gmlevel_json');
  await addIndexIfMissing('sessions', 'ADD KEY idx_session_portal_user (portal_user_id)');
  await addColumnIfMissing('pending', "game_type VARCHAR(16) NOT NULL DEFAULT 'retail' AFTER email");
}

async function hydratePortalUserLinks(portalUser) {
  if (!portalUser || typeof portalUser !== 'object') {
    return { portalUser: portalUser || null, retailLinked: false, classicLinked: false };
  }
  const portalUserId = toSafeNumber(portalUser.id);
  if (portalUserId == null) {
    return { portalUser, retailLinked: false, classicLinked: false };
  }
  const normalizedEmail = normalizeEmail(portalUser.email);
  const retailIds = sanitizeAccountIdList(
    Array.isArray(portalUser.retailAccountIds) ? portalUser.retailAccountIds : []
  );
  const classicIds = sanitizeAccountIdList(
    Array.isArray(portalUser.classicAccountIds) ? portalUser.classicAccountIds : []
  );
  const retailIdSet = new Set(retailIds);
  const classicIdSet = new Set(classicIds);
  let retailLinked = false;
  let classicLinked = false;

  if (normalizedEmail) {
    try {
      const [primary, fallback] = await Promise.all([
        getAuthAccountByEmail(normalizedEmail),
        getGameAccountByEmail(normalizedEmail),
      ]);
      const candidates = [];
      if (primary) {
        candidates.push(primary);
      } else if (fallback) {
        candidates.push(fallback);
      }
      for (const candidate of candidates) {
        const retailAccountId = toSafeNumber(candidate?.id);
        if (retailAccountId == null || retailIdSet.has(retailAccountId)) continue;
        retailIds.push(retailAccountId);
        retailIdSet.add(retailAccountId);
        await linkPortalUserToRetailAccount(portalUserId, retailAccountId, { linkedAt: Date.now() });
        retailLinked = true;
      }
    } catch (err) {
      console.error('Failed to hydrate retail link for portal user', portalUserId, err);
    }
  }

  try {
    const resolvedClassic = await resolveClassicAccountLink({
      username: portalUser.username,
      email: normalizedEmail,
    });
    const classicAccountId = toSafeNumber(resolvedClassic?.accountId);
    if (classicAccountId != null && !classicIdSet.has(classicAccountId)) {
      classicIds.push(classicAccountId);
      classicIdSet.add(classicAccountId);
      await linkPortalUserToClassicAccount(portalUserId, classicAccountId, {
        linkedAt: Date.now(),
      });
      classicLinked = true;
      if (!portalUser.username && resolvedClassic?.username) {
        try {
          await pool.execute('UPDATE portal_users SET username = ? WHERE id = ? AND username IS NULL', [
            resolvedClassic.username,
            portalUserId,
          ]);
          portalUser.username = resolvedClassic.username;
        } catch (err) {
          console.error('Failed to backfill Classic username for portal user', portalUserId, err);
        }
      }
    }
  } catch (err) {
    console.error('Failed to hydrate classic link for portal user', portalUserId, err);
  }

  portalUser.retailAccountIds = sanitizeAccountIdList(retailIds);
  portalUser.classicAccountIds = sanitizeAccountIdList(classicIds);

  return { portalUser, retailLinked, classicLinked };
}

async function hydratePortalAccountLinks() {
  try {
    const [portalRows] = await pool.query('SELECT id, email, username FROM portal_users');
    if (!Array.isArray(portalRows) || !portalRows.length) {
      return;
    }
    const [retailLinkRows] = await pool.query(
      'SELECT portal_user_id, retail_account_id FROM portal_user_retail_accounts'
    );
    const [classicLinkRows] = await pool.query(
      'SELECT portal_user_id, classic_account_id FROM portal_user_classic_accounts'
    );
    const retailLinkMap = new Map();
    const classicLinkMap = new Map();
    for (const row of retailLinkRows) {
      const portalId = toSafeNumber(row.portal_user_id);
      const accountId = toSafeNumber(row.retail_account_id);
      if (portalId == null || accountId == null) continue;
      if (!retailLinkMap.has(portalId)) {
        retailLinkMap.set(portalId, []);
      }
      retailLinkMap.get(portalId).push(accountId);
    }
    for (const row of classicLinkRows) {
      const portalId = toSafeNumber(row.portal_user_id);
      const accountId = toSafeNumber(row.classic_account_id);
      if (portalId == null || accountId == null) continue;
      if (!classicLinkMap.has(portalId)) {
        classicLinkMap.set(portalId, []);
      }
      classicLinkMap.get(portalId).push(accountId);
    }
    let linkedRetailCount = 0;
    let linkedClassicCount = 0;
    for (const portalRow of portalRows) {
      const portalUserId = toSafeNumber(portalRow.id);
      if (portalUserId == null) continue;
      const portalUser = {
        id: portalUserId,
        email: portalRow.email,
        username: portalRow.username,
        retailAccountIds: retailLinkMap.get(portalUserId)?.slice() || [],
        classicAccountIds: classicLinkMap.get(portalUserId)?.slice() || [],
      };
      const { retailLinked, classicLinked } = await hydratePortalUserLinks(portalUser);
      if (retailLinked) linkedRetailCount += 1;
      if (classicLinked) linkedClassicCount += 1;
    }
    console.log(
      `Hydrated portal account links: ${linkedRetailCount} retail, ${linkedClassicCount} classic updates applied`
    );
  } catch (err) {
    console.error('Failed to hydrate portal account links', err);
  }
}

await ensurePortalSchemaUpgrades();
await hydratePortalAccountLinks();

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

const linkAccountLimiter = rateLimit({
  windowMs: 10 * 60 * 1000,
  max: 5,
  standardHeaders: true,
  legacyHeaders: false,
});

const requireGmCommandAccess = requireRequestGm({ source: 'body', key: 'realm' });
const requireGmCommandQueryAccess = requireRequestGm({
  source: 'query',
  key: 'realm',
  fallbackRealm: 'retail',
});

// ----- UI (modern, minimal, responsive) -----
const HOME_PAGE = () => `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Demi DreamCore — Account Portal</title>
  <script src="https://challenges.cloudflare.com/turnstile/v0/api.js" defer></script>
  <script>
    window.TURNSTILE_SITEKEY = ${JSON.stringify(CONFIG.TURNSTILE_SITEKEY)};
    window.REGISTER_ENDPOINT = '/api/register';
    window.REGISTRATION_HELPER_COPY = ${JSON.stringify({
      retail: {
        title: 'DreamCore Current Retail account',
        body: 'Retail accounts connect you to DreamCore Master using Battle.net-style credentials.',
        passwordHint: `${CONFIG.MIN_PASS}+ characters. No spaces or quotes. Your email becomes your DreamCore Current Retail login.`,
      },
      classic: {
        title: 'DreamCore Classic account',
        body: 'Classic accounts are for the Wrath of the Lich King realm using its dedicated Trinity database.',
        passwordHint: `${CONFIG.MIN_PASS}+ characters. No spaces or quotes. Your email becomes your DreamCore Classic login.`,
      },
    })};
  </script>
  <script src="/client.js" defer></script>
  <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
  <style>
    body {
      background:
        radial-gradient(circle at 20% 20%, rgba(88, 28, 135, 0.35), rgba(0, 0, 0, 0)),
        linear-gradient(160deg, #010101 0%, #04000f 45%, #160027 100%);
      background-color: #010005;
    }
    .aurora::before {
      content: "";
      position: fixed;
      inset: -30%;
      background: conic-gradient(from 90deg at 50% 50%, rgba(99, 102, 241, 0.35), rgba(14, 165, 233, 0.2), rgba(236, 72, 153, 0.25), rgba(99, 102, 241, 0.35));
      filter: blur(120px);
      opacity: 0.45;
      animation: aurora-shift 24s linear infinite;
      z-index: 0;
      pointer-events: none;
    }
    @keyframes aurora-shift {
      0% { transform: rotate(0deg) scale(1.05); }
      50% { transform: rotate(180deg) scale(1.15); }
      100% { transform: rotate(360deg) scale(1.05); }
    }
${SHARED_STYLES}
  </style>
</head>
<body class="corner-logo-offset min-h-screen text-gray-100 flex items-center justify-center p-6 aurora relative overflow-x-hidden">
  <div class="corner-logo text-2xl sm:text-3xl font-semibold tracking-[0.3em] text-indigo-300 drop-shadow-lg uppercase">${CONFIG.CORNER_LOGO}</div>
  <div class="w-full max-w-xl relative z-10">
    <div class="bg-gray-900/85 backdrop-blur-2xl rounded-3xl shadow-2xl gradient-border overflow-hidden">
      <div class="px-6 pt-8 pb-10 sm:px-10">
        <h1 class="text-4xl font-semibold tracking-tight text-white">Welcome to Demi DreamCore</h1>
        <p class="mt-3 text-[15px] text-indigo-100/90">Choose which DreamCore server you are creating an account for, enter your credentials, and finish verification from your email.</p>

        <form id="regForm" class="mt-8 space-y-5">
          <div>
            <label class="block text-sm font-medium text-indigo-200 mb-1" for="gameType">Server type</label>
            <select id="gameType" name="gameType" class="dark-select w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-indigo-400">
              <option value="retail">DreamCore Current Retail</option>
              <option value="classic">DreamCore Classic</option>
            </select>
          </div>
          <div class="rounded-2xl gradient-border bg-gray-900/60 p-4" aria-live="polite">
            <p id="gameHelperTitle" class="text-sm font-semibold uppercase tracking-[0.25em] text-indigo-300">DreamCore Current Retail account</p>
            <p id="gameHelperBody" class="mt-2 text-[15px] text-indigo-100/85">Retail accounts connect you to DreamCore Master using Battle.net-style credentials.</p>
          </div>
          <div>
            <label class="block text-sm font-medium text-indigo-200 mb-1" for="email">Email</label>
            <input id="email" type="email" name="email" required
                   class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-indigo-400"
                   placeholder="you@example.com" />
          </div>
          <div>
            <label class="block text-sm font-medium text-indigo-200 mb-1" for="password">Password</label>
            <input id="password" type="password" name="password" required minlength="${CONFIG.MIN_PASS}" maxlength="${CONFIG.MAX_PASS}" pattern="[^\\s'"]+" title="No spaces or quotes"
                   class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-indigo-400"
                   placeholder="••••••••" />
            <p id="passwordHint" class="text-xs text-indigo-200/70 mt-2">${CONFIG.MIN_PASS}+ characters. No spaces or quotes.</p>
          </div>
          <div class="pt-2" id="cf-box">
            <div class="cf-turnstile" data-sitekey="${CONFIG.TURNSTILE_SITEKEY}" data-theme="auto"></div>
          </div>
          <div class="grid gap-3 sm:grid-cols-2">
            <button class="w-full py-3.5 rounded-2xl bg-gradient-to-r from-indigo-500 via-purple-500 to-blue-500 hover:from-indigo-400 hover:via-purple-400 hover:to-blue-400 focus:ring-2 focus:ring-indigo-400 active:scale-[0.99] transition font-semibold text-[15px] shadow-lg shadow-indigo-900/50" type="submit">Register Account</button>
            <a class="inline-flex items-center justify-center rounded-2xl gradient-border bg-gray-900/60 px-5 py-3.5 text-[15px] font-semibold text-indigo-100/85 hover:border-indigo-300 hover:text-white transition" href="/login">Login</a>
          </div>
        </form>
        <pre id="msg" class="mt-6 text-sm whitespace-pre-wrap text-indigo-100 bg-gray-900/70 gradient-border rounded-2xl p-4 min-h-[3rem] transition"></pre>
      </div>
    </div>
    <p class="text-center text-xs text-gray-500 mt-5">DreamCore Network</p>
  </div>
</body>
</html>`;

const REG_PAGE = HOME_PAGE;
const CLASSIC_PAGE = HOME_PAGE;
const clientScript = () => {
  const form = document.getElementById('regForm');
  const msg = document.getElementById('msg');
  const passwordHint = document.getElementById('passwordHint');
  const helperTitle = document.getElementById('gameHelperTitle');
  const helperBody = document.getElementById('gameHelperBody');
  const helperCopy = window.REGISTRATION_HELPER_COPY || {};
  const gameTypeSelect = form ? form.querySelector('select[name="gameType"]') : null;

  function applyHelper(gameType) {
    const copy = helperCopy[gameType] || helperCopy.retail || {};
    if (helperTitle && copy.title) {
      helperTitle.textContent = copy.title;
    }
    if (helperBody && copy.body) {
      helperBody.textContent = copy.body;
    }
    if (passwordHint && copy.passwordHint) {
      passwordHint.textContent = copy.passwordHint;
    }
  }

  function initHelper() {
    if (!form) return;
    let selectedValue = 'retail';
    if (gameTypeSelect) {
      selectedValue = gameTypeSelect.value || 'retail';
      gameTypeSelect.addEventListener('change', () => {
        applyHelper(gameTypeSelect.value || 'retail');
      });
    } else {
      const current = form.querySelector('input[name="gameType"]:checked');
      selectedValue = current?.value || 'retail';
      form.querySelectorAll('input[name="gameType"]').forEach((input) => {
        input.addEventListener('change', () => {
          if (input.checked) {
            applyHelper(input.value);
          }
        });
      });
    }
    applyHelper(selectedValue);
  }

  initHelper();
  if (!form) return;
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

    let gameType = 'retail';
    if (gameTypeSelect && typeof gameTypeSelect.value === 'string') {
      gameType = gameTypeSelect.value;
    } else {
      const selectedType = form.querySelector('input[name="gameType"]:checked');
      if (selectedType && typeof selectedType.value === 'string') {
        gameType = selectedType.value;
      } else {
        const fallbackType = form.querySelector('input[name="gameType"]');
        if (fallbackType && typeof fallbackType.value === 'string') {
          gameType = fallbackType.value;
        }
      }
    }

    const payload = {
      email: document.getElementById('email').value.trim(),
      password: rawPassword,
      cfToken,
      gameType
    };

    const endpoint = window.REGISTER_ENDPOINT || '/api/register';
    const res = await fetch(endpoint, {
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
      background:
        radial-gradient(circle at 20% 20%, rgba(88, 28, 135, 0.35), rgba(0, 0, 0, 0)),
        linear-gradient(160deg, #010101 0%, #04000f 45%, #160027 100%);
      background-color: #010005;
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
    @keyframes blink-signal {
      0%, 100% { opacity: 1; }
      50% { opacity: 0.35; }
    }
    .blink-warning {
      animation: blink-signal 1.1s ease-in-out infinite;
      color: #c084fc;
      text-shadow: 0 0 12px rgba(192, 132, 252, 0.55);
    }
${SHARED_STYLES}
  </style>
</head>
<body class="corner-logo-offset min-h-screen text-gray-100 flex items-center justify-center p-6 aurora relative overflow-x-hidden">
  <div class="corner-logo text-2xl sm:text-3xl font-semibold tracking-[0.3em] text-indigo-300 drop-shadow-lg uppercase">${CONFIG.CORNER_LOGO}</div>
  <div class="w-full max-w-xl relative z-10">
    <div class="bg-gray-900/80 backdrop-blur-xl rounded-3xl shadow-2xl gradient-border overflow-hidden">
      <div class="px-6 pt-8 pb-10 sm:px-10">
        <div class="flex items-baseline justify-between">
          <h1 class="text-4xl font-semibold tracking-tight text-white">Welcome back</h1>
          <span class="text-xs font-medium uppercase tracking-[0.4em] text-indigo-400">Login</span>
        </div>
        <p class="mt-3 text-[15px] text-gray-100 drop-shadow-sm">Sign in to manage your <span class="font-semibold text-indigo-400 drop-shadow">${CONFIG.BRAND_NAME}</span> account and view your characters.</p>

        <div class="mt-8 space-y-8">
          <section class="rounded-3xl gradient-border bg-gray-900/60 p-6 shadow-inner shadow-indigo-900/30">
            <div class="flex items-center gap-4">
              <span class="flex h-10 w-10 items-center justify-center rounded-full bg-gradient-to-br from-indigo-500 via-purple-500 to-blue-500 text-lg font-semibold text-white shadow-lg shadow-indigo-900/40">1</span>
              <div>
                <h2 class="text-lg font-semibold text-white">Log in to your account</h2>
                <p class="text-[15px] text-indigo-100/90">Use the email or username and password you verified during registration.</p>
              </div>
            </div>
            <form id="loginForm" class="mt-6 space-y-5">
              <div>
                <label class="block text-sm font-medium text-indigo-200 mb-1" for="loginIdentity">Email or username</label>
                <input id="loginIdentity" type="text" name="identity" autocomplete="username" required
                       class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-indigo-400" placeholder="you@example.com or player123" />
              </div>
              <div>
                <label class="block text-sm font-medium text-indigo-200 mb-1" for="loginPassword">Password</label>
                <input id="loginPassword" type="password" name="password" autocomplete="current-password" required
                       class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-indigo-400" placeholder="••••••••" />
              </div>
              <button id="loginSubmit" class="w-full py-3.5 rounded-2xl bg-gradient-to-r from-indigo-500 via-purple-500 to-blue-500 hover:from-indigo-400 hover:via-purple-400 hover:to-blue-400 focus:ring-2 focus:ring-indigo-400 active:scale-[0.99] transition font-semibold text-[15px] shadow-lg shadow-indigo-900/50" type="submit">Sign in</button>
            </form>
            <div class="mt-4 flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
              <a class="text-sm font-medium text-indigo-200 hover:text-white transition" href="/reset-password">Forgot your password?</a>
              <a class="text-sm text-indigo-200/80 hover:text-white transition" href="/master">Need an account? Create one</a>
            </div>
            <pre id="loginMsg" class="mt-6 text-sm whitespace-pre-wrap text-indigo-100 bg-gray-900/70 gradient-border rounded-2xl p-4 min-h-[3rem] transition"></pre>
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
    const identity = document.getElementById('loginIdentity')?.value.trim();
    const password = document.getElementById('loginPassword')?.value || '';

    if (!identity || !password) {
      msg.textContent = 'Email or username and password are required.';
      return;
    }

    setLoading(true);
    msg.textContent = 'Signing in…';

    try {
      const res = await fetch('/api/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'same-origin',
        body: JSON.stringify({ identity, password })
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
const LOGIN_JS = `(() => {
  const run = ${loginScript.toString()};
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', run, { once: true });
  } else {
    run();
  }
})();`;

function buildPortalLimitsScriptTag() {
  const payload = {
    minPass: CONFIG.MIN_PASS,
    maxPass: CONFIG.MAX_PASS,
    maxUser: CONFIG.MAX_USER,
    brandName: CONFIG.BRAND_NAME,
    classicBrandName: CONFIG.CLASSIC_BRAND_NAME,
    familyLabels: {
      retail: CONFIG.BRAND_NAME || 'DreamCore Master',
      classic: CONFIG.CLASSIC_BRAND_NAME || 'DreamCore Classic',
    },
    gmOnlinePollMs: CONFIG.GM_ONLINE_POLL_MS,
    gmClassicOnlineLimit: CONFIG.GM_CLASSIC_ONLINE_LIMIT,
    gmClassicOnlineEndpoint: '/api/gm/online/classic',
    gmCommandEndpoint: '/api/gm/command',
    gmCommandListEndpoint: '/api/gm/commands',
    gmClassicWeaponSearchEndpoint: '/api/gm/classic/weapons/search',
    gmClassicWeaponDetailsEndpoint: '/api/gm/classic/weapons',
    gmClassicWeaponCloneEndpoint: '/api/gm/classic/weapons',
    gmClassicArmorSearchEndpoint: '/api/gm/classic/armors/search',
    gmClassicArmorDetailsEndpoint: '/api/gm/classic/armors',
    gmClassicArmorCloneEndpoint: '/api/gm/classic/armors',
    enums: {
      itemClass: itemEnums.ITEM_CLASS,
      weaponSubclass: itemEnums.WEAPON_SUBCLASS,
      armorSubclass: itemEnums.ARMOR_SUBCLASS,
      inventoryType: itemEnums.INVENTORY_TYPE,
      itemQuality: itemEnums.ITEM_QUALITY,
      itemBonding: itemEnums.ITEM_BONDING,
      socketColor335: itemEnums.SOCKET_COLOR_335,
      socketColor: itemEnums.SOCKET_COLOR,
      itemModType: itemEnums.ITEM_MOD_TYPE,
      spellSchool: itemEnums.SPELL_SCHOOL,
      itemSpellTrigger: itemEnums.ITEM_SPELL_TRIGGER,
    },
  };
  return `
  <script>
    window.PORTAL_LIMITS = ${JSON.stringify(payload)};
  </script>`;
}

const weaponStatInputsHtml = Array.from({ length: 10 }, (_, idx) => {
  const index = idx + 1;
  return `
      <div class="grid gap-3 sm:grid-cols-2">
        <div>
          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200" for="weaponField_stat_type${index}">Stat ${index} type</label>
          <input id="weaponField_stat_type${index}" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
        </div>
        <div>
          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200" for="weaponField_stat_value${index}">Stat ${index} value</label>
          <input id="weaponField_stat_value${index}" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
        </div>
      </div>`;
}).join('');

const weaponSpellInputsHtml = Array.from({ length: 5 }, (_, idx) => {
  const index = idx + 1;
  return `
      <div class="rounded-2xl border border-white/5 bg-black/20 p-4 space-y-3">
        <div class="flex items-center justify-between">
          <h5 class="text-sm font-semibold text-white">Spell slot ${index}</h5>
          <span class="text-[11px] uppercase tracking-[0.3em] text-indigo-200/70">#${index}</span>
        </div>
        <div class="grid gap-3 md:grid-cols-3">
          <div>
            <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200" for="weaponField_spellid_${index}">spellid_${index}</label>
            <input id="weaponField_spellid_${index}" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
          </div>
          <div>
            <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200" for="weaponField_spelltrigger_${index}">spelltrigger_${index}</label>
            <input id="weaponField_spelltrigger_${index}" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
          </div>
          <div>
            <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200" for="weaponField_spellcharges_${index}">spellcharges_${index}</label>
            <input id="weaponField_spellcharges_${index}" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
          </div>
          <div>
            <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200" for="weaponField_spellppmRate_${index}">spellppmRate_${index}</label>
            <input id="weaponField_spellppmRate_${index}" type="number" step="0.01" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
          </div>
          <div>
            <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200" for="weaponField_spellcooldown_${index}">spellcooldown_${index}</label>
            <input id="weaponField_spellcooldown_${index}" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="-1" />
          </div>
          <div>
            <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200" for="weaponField_spellcategory_${index}">spellcategory_${index}</label>
            <input id="weaponField_spellcategory_${index}" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
          </div>
          <div>
            <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200" for="weaponField_spellcategorycooldown_${index}">spellcategorycooldown_${index}</label>
            <input id="weaponField_spellcategorycooldown_${index}" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="-1" />
          </div>
        </div>
      </div>`;
}).join('');

const weaponSocketInputsHtml = Array.from({ length: 3 }, (_, idx) => {
  const index = idx + 1;
  return `
      <div class="grid gap-3 sm:grid-cols-2">
        <div>
          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200" for="weaponField_socketColor_${index}">socketColor_${index}</label>
          <input id="weaponField_socketColor_${index}" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
        </div>
        <div>
          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200" for="weaponField_socketContent_${index}">socketContent_${index}</label>
          <input id="weaponField_socketContent_${index}" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
        </div>
      </div>`;
}).join('');

const ACCOUNT_PAGE = () => `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>${CONFIG.HEADER_TITLE} — Account Dashboard</title>
  ${buildPortalLimitsScriptTag()}
  <script src="/account.js" defer></script>
  <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
  <style>
    body {
      background:
        radial-gradient(circle at 20% 20%, rgba(88, 28, 135, 0.35), rgba(0, 0, 0, 0)),
        linear-gradient(160deg, #010101 0%, #04000f 45%, #160027 100%);
      background-color: #010005;
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
${SHARED_STYLES}
  </style>
</head>
<body class="corner-logo-offset min-h-screen text-gray-100 flex items-center justify-center p-6 aurora relative overflow-x-hidden">
  <div class="corner-logo text-2xl sm:text-3xl font-semibold tracking-[0.3em] text-indigo-300 drop-shadow-lg uppercase">${CONFIG.CORNER_LOGO}</div>
  <div class="w-full max-w-6xl relative z-10">
    <div class="bg-gray-900/85 backdrop-blur-2xl rounded-3xl shadow-2xl gradient-border overflow-hidden">
      <div class="px-6 pt-8 pb-10 sm:px-10">
        <div class="flex flex-col gap-8 lg:flex-row lg:items-start lg:justify-between">
          <div class="max-w-2xl">
            <span class="inline-flex items-center gap-2 rounded-full bg-gradient-to-r from-blue-500 via-purple-500 to-indigo-500 px-4 py-1 text-xs font-semibold uppercase tracking-[0.3em] text-gray-900 shadow-lg shadow-indigo-900/30">Portal profile</span>
            <h1 class="mt-4 text-4xl font-semibold tracking-tight text-white">DreamCore account dashboard</h1>
            <p class="mt-3 text-[15px] text-indigo-100/90">Manage your DreamCore Accounts.</p>
            <div class="mt-6 grid gap-4 sm:grid-cols-2">
              <div class="rounded-2xl gradient-border bg-gray-900/60 p-4">
                <p class="text-xs font-semibold uppercase tracking-[0.35em] text-indigo-300">Portal email</p>
                <p id="profileEmail" class="mt-2 text-lg font-semibold text-white break-words">Loading…</p>
              </div>
            </div>
          </div>
          <div class="flex w-full max-w-sm flex-col gap-4">
          <div class="flex flex-col gap-3 sm:flex-row sm:justify-end">
            <button id="accountLogout" class="inline-flex items-center justify-center rounded-2xl bg-gradient-to-r from-indigo-500 via-purple-500 to-blue-500 px-5 py-3 text-[15px] font-semibold text-white shadow-lg shadow-indigo-900/50 transition hover:from-indigo-400 hover:via-purple-400 hover:to-blue-400 focus:ring-2 focus:ring-indigo-400">Log out</button>
          </div>
          </div>
        </div>

        <div class="mt-8 space-y-6">
          <section class="rounded-3xl gradient-border bg-gray-900/70 p-3 shadow-inner shadow-indigo-900/30">
            <div class="flex flex-wrap gap-2" role="tablist" aria-label="Account sections">
              <button type="button" role="tab" aria-selected="true" aria-controls="accountTabPanel"
                      data-tab-target="accountTabPanel"
                      class="flex-1 min-w-[120px] rounded-2xl border border-white/10 bg-gray-900/60 px-4 py-2 text-sm font-semibold text-indigo-100 transition hover:text-white focus:outline-none focus:ring-2 focus:ring-indigo-400">
                Account
              </button>
              <button type="button" role="tab" aria-selected="false" aria-controls="classicTabPanel"
                      data-tab-target="classicTabPanel"
                      class="flex-1 min-w-[120px] rounded-2xl border border-white/10 bg-gray-900/60 px-4 py-2 text-sm font-semibold text-indigo-100/70 transition hover:text-white focus:outline-none focus:ring-2 focus:ring-indigo-400">
                Classic
              </button>
              <button type="button" role="tab" aria-selected="false" aria-controls="retailTabPanel"
                      data-tab-target="retailTabPanel"
                      class="flex-1 min-w-[120px] rounded-2xl border border-white/10 bg-gray-900/60 px-4 py-2 text-sm font-semibold text-indigo-100/70 transition hover:text-white focus:outline-none focus:ring-2 focus:ring-indigo-400">
                Retail
              </button>
              <button type="button" role="tab" aria-selected="false" aria-controls="charactersTabPanel"
                      data-tab-target="charactersTabPanel"
                      class="flex-1 min-w-[140px] rounded-2xl border border-white/10 bg-gray-900/60 px-4 py-2 text-sm font-semibold text-indigo-100/70 transition hover:text-white focus:outline-none focus:ring-2 focus:ring-indigo-400">
                Characters
              </button>
              <button id="gmTabButton" type="button" role="tab" aria-selected="false" aria-controls="gmToolkitSection"
                      data-tab-target="gmToolkitSection"
                      class="hidden flex-1 min-w-[140px] rounded-2xl border border-white/10 bg-gray-900/60 px-4 py-2 text-sm font-semibold text-indigo-100/70 transition hover:text-white focus:outline-none focus:ring-2 focus:ring-indigo-400">
                GM toolkit
              </button>
            </div>
          </section>

          <section id="accountTabPanel" data-tab-panel class="rounded-3xl gradient-border bg-gray-900/70 p-6 shadow-inner shadow-indigo-900/30">
            <div class="grid gap-4 lg:grid-cols-2">
              <article class="rounded-2xl border border-white/5 bg-gray-900/60 p-5">
                <p class="text-xs font-semibold uppercase tracking-[0.4em] text-indigo-300">Retail login</p>
                <p id="accountRetailLogin" class="mt-3 text-xl font-semibold text-white break-words">—</p>
                <p id="accountRetailStatus" class="mt-1 text-sm text-indigo-200/80">Link required</p>
                <p class="mt-3 text-xs text-indigo-200/70">Use this email when signing in to ${CONFIG.BRAND_NAME}.</p>
              </article>
              <article class="rounded-2xl border border-white/5 bg-gray-900/60 p-5">
                <p class="text-xs font-semibold uppercase tracking-[0.4em] text-rose-200">Classic login</p>
                <p id="accountClassicLogin" class="mt-3 text-xl font-semibold text-white break-words">Pick a username</p>
                <p id="accountClassicStatus" class="mt-1 text-sm text-rose-100/80">Link required</p>
                <p class="mt-3 text-xs text-rose-100/70">Classic accounts use usernames instead of emails.</p>
              </article>
            </div>
            <div class="mt-8 rounded-3xl gradient-border bg-gray-900/70 p-6 shadow-inner shadow-indigo-900/30">
              <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
                <div>
                  <p class="text-xs font-semibold uppercase tracking-[0.4em] text-indigo-300">Portal security</p>
                  <h2 class="text-2xl font-semibold text-white">Update your portal password</h2>
                  <p class="text-[15px] text-indigo-100/85">This password unlocks the dashboard and syncs to every linked game account.</p>
                </div>
                <span class="rounded-full gradient-border px-4 py-1 text-xs font-semibold uppercase tracking-[0.4em] text-indigo-200">Universal</span>
              </div>
              <form id="accountForm" class="mt-6 space-y-5">
                <div>
                  <label class="block text-sm font-medium text-indigo-200 mb-1" for="accountEmail">Email</label>
                  <input id="accountEmail" type="email" name="email" readonly
                         class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold opacity-80 cursor-not-allowed"
                         value="" />
                </div>
                <div>
                  <label class="block text-sm font-medium text-indigo-200 mb-1" for="accountPassword">New password</label>
                  <input id="accountPassword" type="password" name="password" required minlength="${CONFIG.MIN_PASS}" maxlength="${CONFIG.MAX_PASS}" pattern="[^\\s'\"]+" title="No spaces or quotes"
                         class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-indigo-400"
                         placeholder="••••••••" />
                  <p class="text-xs text-indigo-200/70 mt-2">${CONFIG.MIN_PASS}+ characters. No spaces or quotes.</p>
                </div>
                <button id="resetSubmit" class="w-full py-3.5 rounded-2xl bg-gradient-to-r from-indigo-500 via-purple-500 to-blue-500 hover:from-indigo-400 hover:via-purple-400 hover:to-blue-400 focus:ring-2 focus:ring-indigo-400 active:scale-[0.99] transition font-semibold text-[15px] shadow-lg shadow-indigo-900/50" type="submit">Save password for portal & games</button>
              </form>
              <pre id="accountMsg" class="mt-6 text-sm whitespace-pre-wrap text-indigo-100 bg-gray-900/70 gradient-border rounded-2xl p-4 min-h-[3rem] transition"></pre>
            </div>
          </section>

          <section id="classicTabPanel" data-tab-panel class="hidden rounded-3xl gradient-border bg-gray-900/70 p-6 shadow-inner shadow-rose-900/30">
            <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
              <div>
                <p class="text-xs font-semibold uppercase tracking-[0.4em] text-rose-200">DreamCore Classic</p>
                <h2 class="text-2xl font-semibold text-white">Classic account</h2>
              </div>
              <span id="classicStatusText" class="text-sm font-semibold text-rose-100">Pending</span>
            </div>
            <div class="mt-6 space-y-5">
              <div id="classicLinkedSummary" class="hidden rounded-2xl gradient-border bg-gray-900/60 p-4">
                <p class="text-sm font-semibold text-white">Classic login linked</p>
                <p class="text-sm text-rose-100/80">Use your Classic username with the latest password you set inside this portal.</p>
                <div class="mt-3 flex flex-wrap gap-3">
                  <a id="classicDownloadButton" class="inline-flex items-center justify-center rounded-2xl bg-gradient-to-r from-blue-500 via-purple-500 to-indigo-500 px-4 py-2 text-sm font-semibold text-white shadow-lg shadow-indigo-900/40 transition hover:from-blue-400 hover:via-purple-400 hover:to-indigo-400 focus:ring-2 focus:ring-indigo-400" href="${CONFIG.CLASSIC_CLIENT_DOWNLOAD_URL}" target="_blank" rel="noopener">Download Classic client</a>
                </div>
              </div>
              <form id="classicLinkForm" class="space-y-4">
                <p class="text-sm text-rose-100/85">Pick a username and password to mint DreamCore Classic credentials. We'll link them straight to this portal.</p>
                <div>
                  <label class="block text-sm font-semibold text-rose-100 mb-1" for="classicLinkUsername">Classic username</label>
                  <input id="classicLinkUsername" type="text" required maxlength="${CONFIG.MAX_USER}" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-rose-400" placeholder="Pick an account name" />
                </div>
                <div>
                  <label class="block text-sm font-semibold text-rose-100 mb-1" for="classicLinkPassword">Account password</label>
                  <input id="classicLinkPassword" type="password" required minlength="${CONFIG.MIN_PASS}" maxlength="${CONFIG.MAX_PASS}" pattern="[^\\s'\"]+" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-rose-400" placeholder="Choose a secure password" />
                </div>
                <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
                  <p id="classicLinkMsg" class="text-sm text-rose-100/90"></p>
                  <button id="classicLinkSubmit" class="inline-flex items-center justify-center rounded-2xl bg-gradient-to-r from-rose-500 via-pink-500 to-orange-400 px-5 py-2.5 text-sm font-semibold text-gray-900 shadow-lg shadow-rose-900/40 transition hover:scale-[1.01] focus:ring-2 focus:ring-rose-300" type="submit">Create Classic login</button>
                </div>
              </form>
              <p class="text-xs text-rose-100/70">Need to change your Classic password later? Use the Account tab's universal reset—your portal login updates Classic and Retail together.</p>
            </div>
          </section>

          <section id="retailTabPanel" data-tab-panel class="hidden rounded-3xl gradient-border bg-gray-900/70 p-6 shadow-inner shadow-indigo-900/30">
            <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
              <div>
                <p class="text-xs font-semibold uppercase tracking-[0.4em] text-indigo-300">DreamCore Master</p>
                <h2 class="text-2xl font-semibold text-white">Retail account</h2>
              </div>
              <span id="retailStatusText" class="text-sm font-semibold text-indigo-200">Pending</span>
            </div>
            <div class="mt-6 space-y-5">
              <div id="retailLinkedSummary" class="hidden rounded-2xl gradient-border bg-gray-900/60 p-4">
                <p class="text-sm font-semibold text-white">Retail login linked</p>
                <p class="text-sm text-indigo-200/80">Use your portal email with the password you choose here to jump into the game.</p>
                <div class="mt-3 flex flex-wrap gap-3">
                  ${CONFIG.GUIDE_URL
                    ? `<a id="retailGuideButton" class="inline-flex items-center justify-center rounded-2xl bg-gradient-to-r from-blue-500 via-purple-500 to-indigo-500 px-4 py-2 text-sm font-semibold text-white shadow-lg shadow-indigo-900/40 transition hover:from-blue-400 hover:via-purple-400 hover:to-indigo-400 focus:ring-2 focus:ring-indigo-400" href="${CONFIG.GUIDE_URL}" target="_blank" rel="noopener">Open retail install guide</a>`
                    : ''}
                </div>
              </div>
              <form id="retailLinkForm" class="space-y-4">
                <p class="text-sm text-indigo-200/80">Need an in-game login? Enter a password and we'll mint your ${CONFIG.BRAND_NAME} credentials instantly.</p>
                <div>
                  <label class="block text-sm font-semibold text-indigo-200 mb-1" for="retailLinkPassword">Account password</label>
                  <input id="retailLinkPassword" type="password" required minlength="${CONFIG.MIN_PASS}" maxlength="${CONFIG.MAX_PASS}" pattern="[^\\s'\"]+" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-indigo-400" placeholder="Choose a secure password" />
                </div>
                <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
                  <p id="retailLinkMsg" class="text-sm text-indigo-200/90"></p>
                  <button id="retailLinkSubmit" class="inline-flex items-center justify-center rounded-2xl bg-gradient-to-r from-indigo-500 via-purple-500 to-blue-500 px-5 py-2.5 text-sm font-semibold text-white shadow-lg shadow-indigo-900/40 transition hover:from-indigo-400 hover:via-purple-400 hover:to-blue-400 focus:ring-2 focus:ring-indigo-400" type="submit">Create retail login</button>
                </div>
              </form>
              <p class="text-xs text-indigo-200/70">Need to change your password later? Head back to the Account tab and run the universal reset. We'll update your portal, Retail, and Classic logins in one shot.</p>
            </div>
          </section>

          <section id="charactersTabPanel" data-tab-panel class="hidden rounded-3xl gradient-border bg-gray-900/70 p-6 shadow-inner shadow-indigo-900/30">
            <div class="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
              <div>
                <p class="text-xs font-semibold uppercase tracking-[0.4em] text-indigo-300">Roster</p>
                <h2 class="text-2xl font-semibold text-white">Characters</h2>
                <p class="text-sm text-indigo-200/80">Use the dropdown to flip between Classic and Retail rosters.</p>
              </div>
              <div class="flex flex-col gap-3 sm:flex-row sm:items-center">
                <select id="characterFamilySelect" class="dark-select w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-indigo-400">
                  <option value="retail">Retail characters</option>
                  <option value="classic">Classic characters</option>
                </select>
                <button id="characterRefreshButton" type="button" class="inline-flex items-center justify-center rounded-2xl border border-indigo-400/60 bg-gray-900/70 px-4 py-2 text-sm font-semibold text-indigo-100 transition hover:border-indigo-300 hover:text-white hover:bg-indigo-500/20 focus:outline-none focus:ring-2 focus:ring-indigo-400 shadow-md shadow-indigo-900/30">Refresh roster</button>
              </div>
            </div>
            <div class="mt-6 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
              <article class="rounded-2xl border border-white/5 bg-gray-900/60 p-4">
                <p class="text-xs font-semibold uppercase tracking-[0.4em] text-indigo-300">Characters</p>
                <p id="charactersCount" class="mt-2 text-3xl font-semibold text-white">0</p>
              </article>
              <article class="rounded-2xl border border-white/5 bg-gray-900/60 p-4">
                <p class="text-xs font-semibold uppercase tracking-[0.4em] text-indigo-300">Realms</p>
                <p id="charactersRealmCount" class="mt-2 text-3xl font-semibold text-white">0</p>
              </article>
            </div>
            <pre id="charactersStatus" class="mt-6 text-sm whitespace-pre-wrap text-indigo-100 bg-gray-900/70 gradient-border rounded-2xl p-4 min-h-[3rem] transition">Select a family to load your roster.</pre>
            <div id="charactersEmptyState" class="mt-4 hidden rounded-2xl border border-white/10 bg-black/20 p-4 text-sm text-indigo-200/80">Link a retail or classic account to view characters.</div>
            <div id="characterCardGrid" class="mt-6 grid gap-5 sm:grid-cols-2 xl:grid-cols-3"></div>
          </section>

          <section id="gmToolkitSection" data-tab-panel class="hidden rounded-3xl gradient-border bg-gray-900/70 p-6 shadow-inner shadow-violet-900/30">
            <div class="flex flex-col gap-6">
              <div class="flex-1 space-y-5">
                <div class="rounded-2xl border border-violet-800/60 bg-gradient-to-r from-black via-gray-950 to-violet-950 p-3 shadow-inner shadow-violet-900/30">
                  <div class="grid grid-cols-2 gap-2 sm:grid-cols-4">
                    <button type="button" data-sub-tab-target="gmServerPanel" class="gm-subtab-btn w-full rounded-xl border border-violet-200/70 bg-gradient-to-r from-violet-600 via-purple-600 to-indigo-600 px-4 py-2 text-sm font-semibold text-white shadow-lg shadow-violet-900/40 transition focus:outline-none focus:ring-2 focus:ring-violet-400">Server</button>
                    <button type="button" data-sub-tab-target="gmWeaponPanel" class="gm-subtab-btn w-full rounded-xl border border-violet-900/60 bg-gradient-to-r from-black via-gray-950 to-violet-950 px-4 py-2 text-sm font-semibold text-indigo-200/80 shadow-md shadow-violet-900/20 transition focus:outline-none focus:ring-2 focus:ring-violet-400">Weapon Factory</button>
                    <button type="button" data-sub-tab-target="gmArmoryPanel" class="gm-subtab-btn w-full rounded-xl border border-violet-900/60 bg-gradient-to-r from-black via-gray-950 to-violet-950 px-4 py-2 text-sm font-semibold text-indigo-200/80 shadow-md shadow-violet-900/20 transition focus:outline-none focus:ring-2 focus:ring-violet-400">Armory</button>
                    <button type="button" data-sub-tab-target="gmQuestPanel" class="gm-subtab-btn w-full rounded-xl border border-violet-900/60 bg-gradient-to-r from-black via-gray-950 to-violet-950 px-4 py-2 text-sm font-semibold text-indigo-200/80 shadow-md shadow-violet-900/20 transition focus:outline-none focus:ring-2 focus:ring-violet-400">Quest Editor</button>
                  </div>
                </div>
                <div id="gmServerPanel" data-sub-tab-panel class="space-y-5">
                  <div class="grid gap-4 md:grid-cols-2">
                    <article data-health-card="classic" class="rounded-2xl border border-white/10 bg-gray-900/70 p-5 space-y-3">
                      <div class="flex items-center justify-between gap-3">
                        <div>
                          <p class="text-xs font-semibold uppercase tracking-[0.35em] text-rose-200">${CONFIG.CLASSIC_BRAND_NAME}</p>
                          <h3 class="text-lg font-semibold text-white">Server health</h3>
                          <p class="text-xs text-indigo-200/80">Live view of Classic world status.</p>
                        </div>
                        <span data-health-status class="rounded-full border border-white/10 px-3 py-1 text-[11px] font-semibold uppercase tracking-[0.3em] text-indigo-200/80">Unknown</span>
                      </div>
                      <div class="flex items-center justify-between text-xs text-indigo-200/70">
                        <span data-health-status-text>Awaiting status…</span>
                        <span data-health-updated>—</span>
                      </div>
                      <div class="grid gap-3 sm:grid-cols-2">
                        <div>
                          <p class="text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200">Uptime</p>
                          <p data-health-uptime class="text-sm font-semibold text-white">Unknown</p>
                          <p data-health-uptime-hint class="text-xs text-indigo-200/70">—</p>
                        </div>
                        <div>
                          <p class="text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200">Players online</p>
                          <p data-health-players class="text-sm font-semibold text-white">—</p>
                          <p class="text-xs text-indigo-200/70">Alliance <span data-health-faction-alliance>—</span> / Horde <span data-health-faction-horde>—</span></p>
                        </div>
                        <div>
                          <p class="text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200">World tick</p>
                          <p data-health-world-update class="text-sm font-semibold text-white">Unknown</p>
                          <p class="text-xs text-indigo-200/70">Lower is better.</p>
                        </div>
                        <div>
                          <p class="text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200">History</p>
                          <p data-health-history class="text-sm font-semibold text-white">—</p>
                          <p class="text-xs text-indigo-200/70">Last restart & record online.</p>
                        </div>
                      </div>
                      <div data-health-warning class="hidden rounded-xl border border-amber-200/40 bg-amber-500/10 p-3 text-xs text-amber-100/90">Partial data (some checks failed).</div>
                      <details data-health-errors class="hidden rounded-xl border border-white/10 bg-black/30 p-3 text-xs text-indigo-100/80">
                        <summary class="cursor-pointer text-sm font-semibold text-indigo-100">Details</summary>
                        <ul data-health-error-list class="mt-2 list-disc space-y-1 pl-4"></ul>
                      </details>
                    </article>

                    <article data-health-card="retail" class="rounded-2xl border border-white/10 bg-gray-900/70 p-5 space-y-3">
                      <div class="flex items-center justify-between gap-3">
                        <div>
                          <p class="text-xs font-semibold uppercase tracking-[0.35em] text-indigo-300">${CONFIG.BRAND_NAME}</p>
                          <h3 class="text-lg font-semibold text-white">Server health</h3>
                          <p class="text-xs text-indigo-200/80">Retail realm reachability & uptime.</p>
                        </div>
                        <span data-health-status class="rounded-full border border-white/10 px-3 py-1 text-[11px] font-semibold uppercase tracking-[0.3em] text-indigo-200/80">Unknown</span>
                      </div>
                      <div class="flex items-center justify-between text-xs text-indigo-200/70">
                        <span data-health-status-text>Awaiting status…</span>
                        <span data-health-updated>—</span>
                      </div>
                      <div class="grid gap-3 sm:grid-cols-2">
                        <div>
                          <p class="text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200">Uptime</p>
                          <p data-health-uptime class="text-sm font-semibold text-white">Unknown</p>
                          <p data-health-uptime-hint class="text-xs text-indigo-200/70">—</p>
                        </div>
                        <div>
                          <p class="text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200">Players online</p>
                          <p data-health-players class="text-sm font-semibold text-white">—</p>
                          <p class="text-xs text-indigo-200/70">Alliance <span data-health-faction-alliance>—</span> / Horde <span data-health-faction-horde>—</span></p>
                        </div>
                        <div>
                          <p class="text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200">World tick</p>
                          <p data-health-world-update class="text-sm font-semibold text-white">Unknown</p>
                          <p class="text-xs text-indigo-200/70">Lower is better.</p>
                        </div>
                        <div>
                          <p class="text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200">History</p>
                          <p data-health-history class="text-sm font-semibold text-white">—</p>
                          <p class="text-xs text-indigo-200/70">Last restart & record online.</p>
                        </div>
                      </div>
                      <div data-health-warning class="hidden rounded-xl border border-amber-200/40 bg-amber-500/10 p-3 text-xs text-amber-100/90">Partial data (some checks failed).</div>
                      <details data-health-errors class="hidden rounded-xl border border-white/10 bg-black/30 p-3 text-xs text-indigo-100/80">
                        <summary class="cursor-pointer text-sm font-semibold text-indigo-100">Details</summary>
                        <ul data-health-error-list class="mt-2 list-disc space-y-1 pl-4"></ul>
                      </details>
                    </article>
                  </div>
                  <div class="rounded-2xl border border-white/10 bg-gray-900/70 p-5">
                    <div class="flex items-center justify-between gap-3">
                      <div>
                        <p class="text-xs font-semibold uppercase tracking-[0.35em] text-rose-200">${CONFIG.CLASSIC_BRAND_NAME}</p>
                        <h3 class="text-lg font-semibold text-white">Classic online characters</h3>
                        <p class="text-xs text-indigo-200/80">Visibility limited to GM access.</p>
                      </div>
                      <span id="classicOnlineUpdated" class="text-[11px] font-semibold uppercase tracking-[0.35em] text-indigo-200/70">—</span>
                    </div>
                    <p id="classicOnlineStatus" class="mt-2 text-xs text-indigo-200/80">Classic GM access required.</p>
                    <div id="classicOnlineList" class="mt-4 max-h-80 space-y-3 overflow-y-auto rounded-2xl border border-white/5 bg-black/20 p-4 text-sm text-indigo-100/85">
                      <p class="text-sm text-indigo-200/70">Waiting for GM access…</p>
                    </div>
                  </div>
                  <div class="rounded-2xl border border-white/10 bg-gray-900/70 p-5">
                    <div class="flex flex-wrap items-center justify-between gap-3">
                      <div>
                        <p class="text-xs font-semibold uppercase tracking-[0.35em] text-indigo-300">GM toolkit</p>
                      <h2 class="text-2xl font-semibold text-white">SOAP command console</h2>
                      <p class="text-sm text-indigo-100/80">Send live commands to ${CONFIG.BRAND_NAME} and ${CONFIG.CLASSIC_BRAND_NAME} realms.</p>
                    </div>
                    <span class="rounded-full border border-white/10 px-3 py-1 text-[11px] font-semibold uppercase tracking-[0.35em] text-indigo-200/80">Secure</span>
                  </div>
                  <form id="gmCommandForm" class="mt-5 space-y-4">
                    <div class="grid gap-4 sm:grid-cols-2">
                      <div>
                        <label class="block text-sm font-medium text-indigo-200 mb-1" for="gmRealmSelect">Realm</label>
                        <select id="gmRealmSelect" class="dark-select w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-indigo-400">
                          <option value="">GM access required</option>
                        </select>
                      </div>
                      <div>
                        <label class="block text-sm font-medium text-indigo-200 mb-1" for="gmCommandContext">Target context</label>
                        <input id="gmCommandContext" type="text" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-indigo-400" placeholder="Realm or character (optional)" />
                      </div>
                    </div>
                    <div>
                      <label class="block text-sm font-medium text-indigo-200 mb-1" for="gmCommandInput">SOAP command</label>
                      <textarea id="gmCommandInput" rows="3" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-indigo-400" placeholder=".server info"></textarea>
                    </div>
                    <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
                      <p id="gmCommandMsg" class="text-sm text-indigo-200/90">Only GMs can run these commands.</p>
                      <button id="gmCommandSubmit" class="inline-flex items-center justify-center rounded-2xl bg-gradient-to-r from-indigo-500 via-purple-500 to-blue-500 px-5 py-2.5 text-sm font-semibold text-white shadow-lg shadow-indigo-900/40 transition hover:from-indigo-400 hover:via-purple-400 hover:to-blue-400 focus:ring-2 focus:ring-indigo-400" type="submit">Send command</button>
                    </div>
                  </form>
                </div>
                <div class="rounded-2xl border border-white/10 bg-gray-900/70 p-5">
                  <div class="flex items-center justify-between">
                    <h3 class="text-lg font-semibold text-white">Response log</h3>
                    <span class="text-xs font-medium uppercase tracking-[0.35em] text-indigo-200/80">Live</span>
                  </div>
                  <div id="gmResponseLog" role="log" aria-live="polite" class="mt-4 max-h-72 space-y-3 overflow-y-auto rounded-2xl bg-black/30 p-4 text-sm text-indigo-100/90">
                    <p id="gmResponseEmpty" class="text-sm text-indigo-200/70">No commands sent this session.</p>
                  </div>
                </div>
                <div class="rounded-2xl border border-white/10 bg-gray-900/70 p-5">
                  <div class="flex flex-wrap items-center justify-between gap-3">
                    <div>
                      <p class="text-xs font-semibold uppercase tracking-[0.35em] text-indigo-300">Command reference</p>
                      <h3 class="text-lg font-semibold text-white">GM command cheatsheet</h3>
                    </div>
                    <span id="gmCommandRealmBadge" class="text-[11px] font-semibold uppercase tracking-[0.35em] text-indigo-200/80">—</span>
                  </div>
                  <div class="mt-4 space-y-3">
                    <input id="gmCommandFilter" type="search" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-indigo-400" placeholder="Search commands (.ban, .tele)" />
                    <p id="gmCommandListStatus" class="text-xs text-indigo-200/80">GM access required to load commands.</p>
                    <div id="gmCommandList" class="max-h-80 space-y-3 overflow-y-auto rounded-2xl border border-white/5 bg-black/20 p-4 text-sm text-indigo-100/90">
                      <p class="text-sm text-indigo-200/70">GM access required.</p>
                    </div>
                  </div>
                </div>
                </div>
                <div id="gmWeaponPanel" data-sub-tab-panel class="hidden space-y-5">
                  <div id="weaponFactoryCard" class="rounded-2xl border border-white/10 bg-gray-900/70 p-5 space-y-5">
                  <div class="flex flex-wrap items-center justify-between gap-3">
                    <div>
                      <p class="text-xs font-semibold uppercase tracking-[0.35em] text-amber-200">Classic weapon lab</p>
                      <h3 class="text-lg font-semibold text-white">Classic Weapon Factory (3.3.5)</h3>
                      <p class="text-sm text-indigo-100/80">Clone any Classic weapon, edit every field, and mint it into the world DB.</p>
                    </div>
                    <span class="rounded-full border border-white/10 px-3 py-1 text-[11px] font-semibold uppercase tracking-[0.35em] text-indigo-200/80">Classic GM</span>
                  </div>
                  <form id="weaponSearchForm" class="space-y-3">
                    <div>
                      <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponSearchInput">Weapon name</label>
                      <input id="weaponSearchInput" type="search" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="Fury of Frostmourne" />
                    </div>
                    <div class="grid gap-3 sm:grid-cols-2">
                      <div>
                        <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponQualityFilter">Quality</label>
                        <select id="weaponQualityFilter" class="dark-select w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400">
                          <option value="">Any quality</option>
                          <option value="0">Poor</option>
                          <option value="1">Common</option>
                          <option value="2">Uncommon</option>
                          <option value="3">Rare</option>
                          <option value="4">Epic</option>
                          <option value="5">Legendary</option>
                          <option value="6">Artifact</option>
                          <option value="7">Heirloom</option>
                        </select>
                      </div>
                      <div>
                        <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponSubclassFilter">Weapon type</label>
                        <select id="weaponSubclassFilter" class="dark-select w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400">
                          <option value="">Any type</option>
                          <option value="0">One-Handed Axes</option>
                          <option value="1">Two-Handed Axes</option>
                          <option value="2">Bows</option>
                          <option value="3">Guns</option>
                          <option value="4">One-Handed Maces</option>
                          <option value="5">Two-Handed Maces</option>
                          <option value="6">Polearms</option>
                          <option value="7">One-Handed Swords</option>
                          <option value="8">Two-Handed Swords</option>
                          <option value="10">Staves</option>
                          <option value="11">Exotic</option>
                          <option value="12">Fist Weapons</option>
                          <option value="13">Miscellaneous</option>
                          <option value="14">Daggers</option>
                          <option value="15">Thrown</option>
                          <option value="16">Spears</option>
                          <option value="17">Crossbows</option>
                          <option value="18">Wands</option>
                          <option value="19">Fishing Poles</option>
                        </select>
                      </div>
                    </div>
                    <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
                      <p id="weaponSearchStatus" class="text-xs text-indigo-200/80">Classic GM access required to use the weapon factory.</p>
                      <button id="weaponSearchSubmit" type="submit" class="inline-flex items-center justify-center rounded-2xl bg-gradient-to-r from-amber-500 via-orange-500 to-pink-500 px-5 py-2.5 text-sm font-semibold text-white shadow-lg shadow-amber-900/30 transition hover:from-amber-400 hover:via-orange-400 hover:to-pink-400 focus:outline-none focus:ring-2 focus:ring-amber-400">Search weapons</button>
                    </div>
                  </form>
                  <div id="weaponSearchResults" class="grid gap-3">
                    <p class="text-sm text-indigo-200/75">Search for an existing Classic weapon to begin.</p>
                  </div>
                  <p id="weaponSearchMore" class="hidden text-xs text-indigo-200/70">More matches exist. Refine your search to narrow the list.</p>
                  <div id="weaponEditorPanel" class="hidden space-y-4 rounded-2xl border border-white/5 bg-black/30 p-4">
                    <div class="rounded-2xl border border-white/10 bg-gray-900/60 p-4">
                      <div class="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
                        <div>
                          <p class="text-xs font-semibold uppercase tracking-[0.4em] text-indigo-200">Selected base</p>
                          <h4 id="weaponEditorTitle" class="text-xl font-semibold text-white">Select a weapon</h4>
                          <p id="weaponEditorMeta" class="text-sm text-indigo-200/80">Pick a Classic weapon to load its template.</p>
                        </div>
                        <div class="flex flex-col items-end gap-2">
                          <span id="weaponEditorEntry" class="rounded-full border border-white/15 px-3 py-1 text-[11px] font-semibold uppercase tracking-[0.35em] text-indigo-200/90">#—</span>
                          <span id="weaponEditorQuality" class="text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200/70">—</span>
                        </div>
                      </div>
                    </div>
                    <form id="weaponCloneForm" class="space-y-4">
                      <section class="rounded-2xl border border-white/5 bg-gray-900/60 p-4 space-y-4">
                        <div>
                          <p class="text-xs font-semibold uppercase tracking-[0.4em] text-indigo-200">Basic identity</p>
                          <h4 class="text-lg font-semibold text-white">Core fields</h4>
                        </div>
                        <div>
                          <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_name">Custom name</label>
                          <input id="weaponField_name" type="text" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="My GM Blade" />
                        </div>
                        <div>
                          <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_description">Description</label>
                          <textarea id="weaponField_description" rows="3" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="Forged within the DreamCore."></textarea>
                        </div>
                        <div class="grid gap-3 md:grid-cols-2">
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_class">class</label>
                            <input id="weaponField_class" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="2" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_subclass">subclass</label>
                            <select id="weaponField_subclass" class="dark-select w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400"></select>
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_Quality">Quality</label>
                            <select id="weaponField_Quality" class="dark-select w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400"></select>
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_displayid">displayid</label>
                            <input id="weaponField_displayid" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_InventoryType">InventoryType</label>
                            <input id="weaponField_InventoryType" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="13" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_SoundOverrideSubclass">SoundOverrideSubclass</label>
                            <input id="weaponField_SoundOverrideSubclass" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="-1" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_Flags">Flags</label>
                            <input id="weaponField_Flags" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_FlagsExtra">FlagsExtra</label>
                            <input id="weaponField_FlagsExtra" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_BuyCount">BuyCount</label>
                            <input id="weaponField_BuyCount" type="number" min="1" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="1" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_BuyPrice">BuyPrice</label>
                            <input id="weaponField_BuyPrice" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_SellPrice">SellPrice</label>
                            <input id="weaponField_SellPrice" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_Material">Material</label>
                            <input id="weaponField_Material" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_sheath">sheath</label>
                            <input id="weaponField_sheath" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                        </div>
                      </section>
                      <section class="rounded-2xl border border-white/5 bg-gray-900/60 p-4 space-y-4">
                        <div>
                          <p class="text-xs font-semibold uppercase tracking-[0.4em] text-indigo-200">Levels & economy</p>
                          <h4 class="text-lg font-semibold text-white">Progression + stacking</h4>
                        </div>
                        <div class="grid gap-3 md:grid-cols-2">
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_ItemLevel">ItemLevel</label>
                            <input id="weaponField_ItemLevel" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="200" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_RequiredLevel">RequiredLevel</label>
                            <input id="weaponField_RequiredLevel" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="80" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_maxcount">maxcount</label>
                            <input id="weaponField_maxcount" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_stackable">stackable</label>
                            <input id="weaponField_stackable" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="1" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_ContainerSlots">ContainerSlots</label>
                            <input id="weaponField_ContainerSlots" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_StatsCount">StatsCount</label>
                            <input id="weaponField_StatsCount" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_ScalingStatDistribution">ScalingStatDistribution</label>
                            <input id="weaponField_ScalingStatDistribution" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_ScalingStatValue">ScalingStatValue</label>
                            <input id="weaponField_ScalingStatValue" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                        </div>
                      </section>
                      <section class="rounded-2xl border border-white/5 bg-gray-900/60 p-4 space-y-4">
                        <div>
                          <p class="text-xs font-semibold uppercase tracking-[0.4em] text-indigo-200">Usage & restrictions</p>
                          <h4 class="text-lg font-semibold text-white">Class, race, skills</h4>
                        </div>
                        <div class="grid gap-3 md:grid-cols-2">
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_AllowableClass">AllowableClass</label>
                            <input id="weaponField_AllowableClass" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="-1" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_AllowableRace">AllowableRace</label>
                            <input id="weaponField_AllowableRace" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="-1" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_RequiredSkill">RequiredSkill</label>
                            <input id="weaponField_RequiredSkill" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_RequiredSkillRank">RequiredSkillRank</label>
                            <input id="weaponField_RequiredSkillRank" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_requiredspell">requiredspell</label>
                            <input id="weaponField_requiredspell" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_requiredhonorrank">requiredhonorrank</label>
                            <input id="weaponField_requiredhonorrank" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_RequiredCityRank">RequiredCityRank</label>
                            <input id="weaponField_RequiredCityRank" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_RequiredReputationFaction">RequiredReputationFaction</label>
                            <input id="weaponField_RequiredReputationFaction" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_RequiredReputationRank">RequiredReputationRank</label>
                            <input id="weaponField_RequiredReputationRank" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_startquest">startquest</label>
                            <input id="weaponField_startquest" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_bonding">bonding</label>
                            <input id="weaponField_bonding" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                        </div>
                      </section>
                      <section class="rounded-2xl border border-white/5 bg-gray-900/60 p-4 space-y-4">
                        <div>
                          <p class="text-xs font-semibold uppercase tracking-[0.4em] text-indigo-200">Damage & resistances</p>
                          <h4 class="text-lg font-semibold text-white">Weapon profile</h4>
                        </div>
                        <div class="grid gap-3 md:grid-cols-3">
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_dmg_min1">dmg_min1</label>
                            <input id="weaponField_dmg_min1" type="number" step="0.01" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="100" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_dmg_max1">dmg_max1</label>
                            <input id="weaponField_dmg_max1" type="number" step="0.01" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="200" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_dmg_type1">dmg_type1</label>
                            <input id="weaponField_dmg_type1" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_dmg_min2">dmg_min2</label>
                            <input id="weaponField_dmg_min2" type="number" step="0.01" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_dmg_max2">dmg_max2</label>
                            <input id="weaponField_dmg_max2" type="number" step="0.01" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_dmg_type2">dmg_type2</label>
                            <input id="weaponField_dmg_type2" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_delay">delay</label>
                            <input id="weaponField_delay" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="3000" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_ammo_type">ammo_type</label>
                            <input id="weaponField_ammo_type" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_RangedModRange">RangedModRange</label>
                            <input id="weaponField_RangedModRange" type="number" step="0.01" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                        </div>
                        <div class="grid gap-3 md:grid-cols-3">
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_armor">armor</label>
                            <input id="weaponField_armor" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_holy_res">holy_res</label>
                            <input id="weaponField_holy_res" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_fire_res">fire_res</label>
                            <input id="weaponField_fire_res" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_nature_res">nature_res</label>
                            <input id="weaponField_nature_res" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_frost_res">frost_res</label>
                            <input id="weaponField_frost_res" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_shadow_res">shadow_res</label>
                            <input id="weaponField_shadow_res" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_arcane_res">arcane_res</label>
                            <input id="weaponField_arcane_res" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_block">block</label>
                            <input id="weaponField_block" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_MaxDurability">MaxDurability</label>
                            <input id="weaponField_MaxDurability" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                        </div>
                      </section>
                      <section class="rounded-2xl border border-white/5 bg-gray-900/60 p-4 space-y-4">
                        <div>
                          <p class="text-xs font-semibold uppercase tracking-[0.4em] text-indigo-200">Stats</p>
                          <h4 class="text-lg font-semibold text-white">All 10 stat slots</h4>
                        </div>
                        <div class="space-y-3">
${weaponStatInputsHtml}
                        </div>
                      </section>
                      <section class="rounded-2xl border border-white/5 bg-gray-900/60 p-4 space-y-4">
                        <div>
                          <p class="text-xs font-semibold uppercase tracking-[0.4em] text-indigo-200">Spells & procs</p>
                          <h4 class="text-lg font-semibold text-white">Use, proc, aura slots</h4>
                        </div>
                        <div class="space-y-3">
${weaponSpellInputsHtml}
                        </div>
                      </section>
                      <section class="rounded-2xl border border-white/5 bg-gray-900/60 p-4 space-y-4">
                        <div>
                          <p class="text-xs font-semibold uppercase tracking-[0.4em] text-indigo-200">Sockets</p>
                          <h4 class="text-lg font-semibold text-white">Socket colors & gems</h4>
                        </div>
                        <div class="space-y-3">
${weaponSocketInputsHtml}
                        </div>
                        <div class="grid gap-3 sm:grid-cols-2">
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_socketBonus">socketBonus</label>
                            <input id="weaponField_socketBonus" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_GemProperties">GemProperties</label>
                            <input id="weaponField_GemProperties" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                        </div>
                      </section>
                      <section class="rounded-2xl border border-white/5 bg-gray-900/60 p-4 space-y-4">
                        <div>
                          <p class="text-xs font-semibold uppercase tracking-[0.4em] text-indigo-200">Misc attributes</p>
                          <h4 class="text-lg font-semibold text-white">Everything else</h4>
                        </div>
                        <div class="grid gap-3 md:grid-cols-2">
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_PageText">PageText</label>
                            <input id="weaponField_PageText" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_LanguageID">LanguageID</label>
                            <input id="weaponField_LanguageID" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_PageMaterial">PageMaterial</label>
                            <input id="weaponField_PageMaterial" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_lockid">lockid</label>
                            <input id="weaponField_lockid" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_RandomProperty">RandomProperty</label>
                            <input id="weaponField_RandomProperty" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_RandomSuffix">RandomSuffix</label>
                            <input id="weaponField_RandomSuffix" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_itemset">itemset</label>
                            <input id="weaponField_itemset" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_area">area</label>
                            <input id="weaponField_area" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_Map">Map</label>
                            <input id="weaponField_Map" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_BagFamily">BagFamily</label>
                            <input id="weaponField_BagFamily" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_TotemCategory">TotemCategory</label>
                            <input id="weaponField_TotemCategory" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_RequiredDisenchantSkill">RequiredDisenchantSkill</label>
                            <input id="weaponField_RequiredDisenchantSkill" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="-1" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_ArmorDamageModifier">ArmorDamageModifier</label>
                            <input id="weaponField_ArmorDamageModifier" type="number" step="0.01" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_duration">duration</label>
                            <input id="weaponField_duration" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_ItemLimitCategory">ItemLimitCategory</label>
                            <input id="weaponField_ItemLimitCategory" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_HolidayId">HolidayId</label>
                            <input id="weaponField_HolidayId" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_ScriptName">ScriptName</label>
                            <input id="weaponField_ScriptName" type="text" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_DisenchantID">DisenchantID</label>
                            <input id="weaponField_DisenchantID" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_FoodType">FoodType</label>
                            <input id="weaponField_FoodType" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_minMoneyLoot">minMoneyLoot</label>
                            <input id="weaponField_minMoneyLoot" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_maxMoneyLoot">maxMoneyLoot</label>
                            <input id="weaponField_maxMoneyLoot" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_flagsCustom">flagsCustom</label>
                            <input id="weaponField_flagsCustom" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                          <div>
                            <label class="block text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200" for="weaponField_VerifiedBuild">VerifiedBuild</label>
                            <input id="weaponField_VerifiedBuild" type="number" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-violet-400" placeholder="0" />
                          </div>
                        </div>
                      </section>
                    <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
                      <p id="weaponCloneMsg" class="text-sm text-indigo-200/80">Select a weapon to begin cloning.</p>
                      <button id="weaponCloneSubmit" type="submit" class="inline-flex items-center justify-center rounded-2xl bg-gradient-to-r from-emerald-500 via-cyan-500 to-blue-500 px-5 py-2.5 text-sm font-semibold text-white shadow-lg shadow-emerald-900/30 transition hover:from-emerald-400 hover:via-cyan-400 hover:to-blue-400 focus:outline-none focus:ring-2 focus:ring-emerald-400">Clone weapon</button>
                    </div>
                  </form>
                </div>
              </div>
              <div id="gmArmoryPanel" data-sub-tab-panel class="space-y-5 hidden">
                <div class="rounded-2xl border border-white/10 bg-gray-900/70 p-5 space-y-4" id="armorSearchCard">
                  <div class="flex items-center justify-between gap-3">
                    <div>
                      <p class="text-xs font-semibold uppercase tracking-[0.35em] text-indigo-300">GM toolkit</p>
                      <h3 class="text-xl font-semibold text-white">Classic Armory (3.3.5)</h3>
                      <p class="text-xs text-indigo-200/80">Search and clone armor templates from the world database.</p>
                    </div>
                    <span class="rounded-full border border-white/10 px-3 py-1 text-[11px] font-semibold uppercase tracking-[0.35em] text-indigo-200/80">
                      Classic
                    </span>
                  </div>

                  <form id="armorSearchForm" class="mt-4 grid gap-4 md:grid-cols-4">
                    <div class="md:col-span-2">
                      <label for="armorSearchInput" class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200 mb-1">
                        Armor name or entry
                      </label>
                      <input id="armorSearchInput" type="text" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-sm text-indigo-50 placeholder:text-indigo-300/40 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400" placeholder="e.g. Wrathful Gladiator's Plate Chestpiece or 51305" />
                    </div>
                    <div>
                      <label for="armorSubclassFilter" class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200 mb-1">
                        Armor type
                      </label>
                      <select id="armorSubclassFilter" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-xs text-indigo-50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400">
                        <option value="">Any</option>
                      </select>
                    </div>
                    <div>
                      <label for="armorSlotFilter" class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200 mb-1">
                        Slot
                      </label>
                      <select id="armorSlotFilter" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-xs text-indigo-50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400">
                        <option value="">Any</option>
                      </select>
                    </div>
                    <div class="md:col-span-4 flex items-center justify-between gap-3">
                      <p id="armorSearchStatus" class="text-xs text-indigo-200/80">Enter a name or entry ID to begin.</p>
                      <button id="armorSearchSubmit" type="submit" class="inline-flex items-center rounded-xl border border-violet-400/70 bg-gradient-to-r from-violet-600 via-purple-600 to-indigo-600 px-4 py-2 text-xs font-semibold uppercase tracking-[0.3em] text-white shadow-lg shadow-violet-900/40 disabled:opacity-60 disabled:cursor-not-allowed">
                        Search
                      </button>
                    </div>
                  </form>

                  <div id="armorSearchResults" class="mt-4 max-h-72 space-y-2 overflow-y-auto rounded-2xl border border-white/5 bg-black/20 p-3 text-xs text-indigo-100/85">
                    <p class="text-xs text-indigo-200/70">No results yet.</p>
                  </div>
                </div>

                <div id="armorEditorPanel" class="rounded-2xl border border-white/10 bg-gray-900/70 p-5 space-y-4 hidden">
                  <div class="flex items-center justify-between gap-3">
                    <div>
                      <p class="text-xs font-semibold uppercase tracking-[0.35em] text-indigo-300">Armor editor</p>
                      <h3 id="armorEditorTitle" class="text-xl font-semibold text-white">No armor selected</h3>
                      <p id="armorEditorMeta" class="text-xs text-indigo-200/80"></p>
                    </div>
                    <span class="rounded-full border border-white/10 px-3 py-1 text-[11px] font-semibold uppercase tracking-[0.35em] text-indigo-200/80">
                      Clone only
                    </span>
                  </div>

                  <form id="armorCloneForm" class="space-y-5">
                    <section class="rounded-2xl border border-white/5 bg-black/20 p-4 space-y-3">
                      <div class="grid gap-4 md:grid-cols-2">
                        <div>
                          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200 mb-1" for="armorField_name">Name</label>
                          <input id="armorField_name" type="text" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-sm text-indigo-50 placeholder:text-indigo-200/50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400" placeholder="Custom armor name" />
                        </div>
                        <div>
                          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200 mb-1" for="armorField_description">Description</label>
                          <input id="armorField_description" type="text" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-sm text-indigo-50 placeholder:text-indigo-200/50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400" placeholder="Optional description" />
                        </div>
                      </div>
                      <div class="grid gap-4 md:grid-cols-4">
                        <div>
                          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200 mb-1" for="armorField_Quality">Quality</label>
                          <select id="armorField_Quality" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-xs text-indigo-50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400"></select>
                        </div>
                        <div>
                          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200 mb-1" for="armorField_subclass">Armor type</label>
                          <select id="armorField_subclass" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-xs text-indigo-50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400"></select>
                        </div>
                        <div>
                          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200 mb-1" for="armorField_InventoryType">Slot</label>
                          <select id="armorField_InventoryType" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-xs text-indigo-50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400"></select>
                        </div>
                        <div>
                          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200 mb-1" for="armorField_Armor">Armor value</label>
                          <input id="armorField_Armor" type="number" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-sm text-indigo-50 placeholder:text-indigo-200/50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400" placeholder="0" />
                        </div>
                      </div>
                      <div class="grid gap-4 md:grid-cols-3">
                        <div>
                          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200 mb-1" for="armorField_ItemLevel">Item level</label>
                          <input id="armorField_ItemLevel" type="number" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-sm text-indigo-50 placeholder:text-indigo-200/50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400" placeholder="200" />
                        </div>
                        <div>
                          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200 mb-1" for="armorField_RequiredLevel">Required level</label>
                          <input id="armorField_RequiredLevel" type="number" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-sm text-indigo-50 placeholder:text-indigo-200/50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400" placeholder="80" />
                        </div>
                        <div>
                          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200 mb-1" for="armorField_StatsCount">Stats count</label>
                          <input id="armorField_StatsCount" type="number" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-sm text-indigo-50 placeholder:text-indigo-200/50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400" placeholder="0" />
                        </div>
                      </div>
                    </section>

                    <section class="rounded-2xl border border-white/5 bg-black/20 p-4 space-y-3">
                      <div class="flex items-center justify-between">
                        <h4 class="text-sm font-semibold text-white">Primary stats</h4>
                        <span class="text-[11px] uppercase tracking-[0.3em] text-indigo-200/70">Up to 5</span>
                      </div>
                      <div class="grid gap-3 md:grid-cols-2">
                        <div>
                          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200" for="armorField_stat_type1">Stat 1 type</label>
                          <input id="armorField_stat_type1" type="number" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-sm text-indigo-50 placeholder:text-indigo-200/50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400" placeholder="7" />
                        </div>
                        <div>
                          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200" for="armorField_stat_value1">Stat 1 value</label>
                          <input id="armorField_stat_value1" type="number" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-sm text-indigo-50 placeholder:text-indigo-200/50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400" placeholder="0" />
                        </div>
                        <div>
                          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200" for="armorField_stat_type2">Stat 2 type</label>
                          <input id="armorField_stat_type2" type="number" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-sm text-indigo-50 placeholder:text-indigo-200/50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400" placeholder="4" />
                        </div>
                        <div>
                          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200" for="armorField_stat_value2">Stat 2 value</label>
                          <input id="armorField_stat_value2" type="number" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-sm text-indigo-50 placeholder:text-indigo-200/50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400" placeholder="0" />
                        </div>
                        <div>
                          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200" for="armorField_stat_type3">Stat 3 type</label>
                          <input id="armorField_stat_type3" type="number" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-sm text-indigo-50 placeholder:text-indigo-200/50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400" placeholder="5" />
                        </div>
                        <div>
                          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200" for="armorField_stat_value3">Stat 3 value</label>
                          <input id="armorField_stat_value3" type="number" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-sm text-indigo-50 placeholder:text-indigo-200/50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400" placeholder="0" />
                        </div>
                        <div>
                          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200" for="armorField_stat_type4">Stat 4 type</label>
                          <input id="armorField_stat_type4" type="number" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-sm text-indigo-50 placeholder:text-indigo-200/50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400" placeholder="0" />
                        </div>
                        <div>
                          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200" for="armorField_stat_value4">Stat 4 value</label>
                          <input id="armorField_stat_value4" type="number" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-sm text-indigo-50 placeholder:text-indigo-200/50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400" placeholder="0" />
                        </div>
                        <div>
                          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200" for="armorField_stat_type5">Stat 5 type</label>
                          <input id="armorField_stat_type5" type="number" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-sm text-indigo-50 placeholder:text-indigo-200/50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400" placeholder="0" />
                        </div>
                        <div>
                          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200" for="armorField_stat_value5">Stat 5 value</label>
                          <input id="armorField_stat_value5" type="number" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-sm text-indigo-50 placeholder:text-indigo-200/50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400" placeholder="0" />
                        </div>
                      </div>
                    </section>

                    <section class="rounded-2xl border border-white/5 bg-black/20 p-4 space-y-3">
                      <div class="grid gap-4 sm:grid-cols-3">
                        <div>
                          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200 mb-1">Socket 1</label>
                          <select id="armorField_socketColor_1" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-xs text-indigo-50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400"></select>
                        </div>
                        <div>
                          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200 mb-1">Socket 2</label>
                          <select id="armorField_socketColor_2" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-xs text-indigo-50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400"></select>
                        </div>
                        <div>
                          <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200 mb-1">Socket 3</label>
                          <select id="armorField_socketColor_3" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-xs text-indigo-50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400"></select>
                        </div>
                      </div>
                      <div>
                        <label class="block text-xs font-semibold uppercase tracking-[0.3em] text-indigo-200 mb-1" for="armorField_socketBonus">Socket bonus</label>
                        <input id="armorField_socketBonus" type="number" class="w-full rounded-xl border border-white/10 bg-black/40 px-3 py-2 text-sm text-indigo-50 placeholder:text-indigo-200/50 focus:border-violet-400 focus:outline-none focus:ring-1 focus:ring-violet-400" placeholder="0" />
                      </div>
                    </section>

                    <div class="pt-2 flex items-center justify-between gap-3">
                      <p id="armorCloneMsg" class="text-xs text-indigo-200/80">Select an armor template and adjust fields to clone it into a new item.</p>
                      <button id="armorCloneSubmit" type="submit" class="inline-flex items-center rounded-xl border border-emerald-400/70 bg-gradient-to-r from-emerald-600 via-lime-500 to-emerald-500 px-4 py-2 text-xs font-semibold uppercase tracking-[0.3em] text-gray-900 shadow-lg shadow-emerald-900/40 disabled:opacity-60 disabled:cursor-not-allowed">
                        Clone armor
                      </button>
                    </div>
                  </form>
                </div>
              </div>
              <div id="gmQuestPanel" data-sub-tab-panel class="hidden space-y-4">
                <div class="rounded-2xl border border-white/10 bg-gradient-to-br from-black via-gray-950 to-violet-950 p-6 text-center shadow-inner shadow-violet-900/30">
                  <p class="text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200">Quest Editor</p>
                  <h3 class="mt-2 text-xl font-semibold text-white">Coming soon</h3>
                  <p class="mt-3 text-sm text-indigo-100/80">Design, edit, and publish quests will be added in a future release.</p>
                </div>
              </div>
            </div>
            </div>
          </section>
        </div>
      </div>
    </div>
    <p class="text-center text-xs text-gray-500 mt-5">Protected by Cloudflare · DreamCore DemiDev Unit 2025 · DreamCore.exe shortcut by Azar</p>
  </div>
</body>
</html>`;

const accountScript = () => {
  const LIMITS = window.PORTAL_LIMITS || {};
  const MIN_PASS = Number(LIMITS.minPass) || 8;
  const ENUMS = (LIMITS && LIMITS.enums) || {};
  const safeStorage = (() => {
    try {
      return window.localStorage;
    } catch (err) {
      return null;
    }
  })();
  const STORAGE_KEYS = {
    tab: 'dreamcore.dashboard.activeTab',
    family: 'dreamcore.dashboard.characterFamily',
    gmSubtab: 'dreamcore.dashboard.gmSubtab',
  };

  function readStoredValue(key) {
    if (!safeStorage || typeof safeStorage.getItem !== 'function' || typeof key !== 'string') {
      return null;
    }
    try {
      return safeStorage.getItem(key);
    } catch (err) {
      return null;
    }
  }

  function persistStoredValue(key, value) {
    if (!safeStorage || typeof safeStorage.setItem !== 'function' || typeof key !== 'string') {
      return;
    }
    try {
      safeStorage.setItem(key, value);
    } catch (err) {
      // ignore storage quota failures
    }
  }

  function buildSelectOptions(selectEl, enumObj, { includeUnknown = false } = {}) {
    if (!selectEl || !enumObj) return;
    selectEl.innerHTML = '';
    const entries = Object.keys(enumObj)
      .map((key) => ({ id: Number(key), label: enumObj[key] }))
      .sort((a, b) => a.id - b.id);

    if (includeUnknown) {
      const opt = document.createElement('option');
      opt.value = '';
      opt.textContent = '—';
      selectEl.appendChild(opt);
    }

    for (const { id, label } of entries) {
      const opt = document.createElement('option');
      opt.value = String(id);
      opt.textContent = `${label} (ID ${id})`;
      selectEl.appendChild(opt);
    }
  }

  function formatEnumLabel(enumObj, value, prefix) {
    const key = Number(value);
    if (!enumObj || Number.isNaN(key)) return prefix ? `${prefix} —` : '—';
    const label = enumObj[key];
    if (!label) return prefix ? `${prefix} ${key}` : `Unknown (ID ${key})`;
    return `${label} (ID ${key})`;
  }

  function normalizeSocketColor(value) {
    const num = Number(value);
    if (!Number.isFinite(num) || num <= 0) return 0;
    return num;
  }
  const profileEmail = document.getElementById('profileEmail');
  const form = document.getElementById('accountForm');
  const emailInput = document.getElementById('accountEmail');
  const passwordInput = document.getElementById('accountPassword');
  const msg = document.getElementById('accountMsg');
  const submit = document.getElementById('resetSubmit');
  const logoutButton = document.getElementById('accountLogout');
  const retailStatusText = document.getElementById('retailStatusText');
  const classicStatusText = document.getElementById('classicStatusText');
  const accountRetailLogin = document.getElementById('accountRetailLogin');
  const accountRetailStatus = document.getElementById('accountRetailStatus');
  const accountClassicLogin = document.getElementById('accountClassicLogin');
  const accountClassicStatus = document.getElementById('accountClassicStatus');
  const retailLinkForm = document.getElementById('retailLinkForm');
  const retailLinkPassword = document.getElementById('retailLinkPassword');
  const retailLinkMsg = document.getElementById('retailLinkMsg');
  const retailLinkSubmit = document.getElementById('retailLinkSubmit');
  const retailLinkedSummary = document.getElementById('retailLinkedSummary');
  const retailGuideButton = document.getElementById('retailGuideButton');
  const classicLinkForm = document.getElementById('classicLinkForm');
  const classicLinkUsername = document.getElementById('classicLinkUsername');
  const classicLinkPassword = document.getElementById('classicLinkPassword');
  const classicLinkMsg = document.getElementById('classicLinkMsg');
  const classicLinkSubmit = document.getElementById('classicLinkSubmit');
  const classicLinkedSummary = document.getElementById('classicLinkedSummary');
  const classicDownloadButton = document.getElementById('classicDownloadButton');
  const tabButtons = document.querySelectorAll('[data-tab-target]');
  const tabPanels = document.querySelectorAll('[data-tab-panel]');
  const gmTabButton = document.getElementById('gmTabButton');
  const gmSubTabButtons = document.querySelectorAll('[data-sub-tab-target]');
  const gmSubTabPanels = document.querySelectorAll('[data-sub-tab-panel]');
  const gmCommandForm = document.getElementById('gmCommandForm');
  const gmRealmSelect = document.getElementById('gmRealmSelect');
  const gmCommandInput = document.getElementById('gmCommandInput');
  const gmCommandMsg = document.getElementById('gmCommandMsg');
  const gmCommandSubmit = document.getElementById('gmCommandSubmit');
  const gmCommandContext = document.getElementById('gmCommandContext');
  const gmResponseLog = document.getElementById('gmResponseLog');
  const gmResponseEmpty = document.getElementById('gmResponseEmpty');
  const gmCommandFilter = document.getElementById('gmCommandFilter');
  const gmCommandList = document.getElementById('gmCommandList');
  const gmCommandListStatus = document.getElementById('gmCommandListStatus');
  const gmCommandRealmBadge = document.getElementById('gmCommandRealmBadge');
  const classicOnlineList = document.getElementById('classicOnlineList');
  const classicOnlineStatus = document.getElementById('classicOnlineStatus');
  const classicOnlineUpdated = document.getElementById('classicOnlineUpdated');
  const healthCards = {};
  const weaponFactoryCard = document.getElementById('weaponFactoryCard');
  const armorSearchCard = document.getElementById('armorSearchCard');
  const weaponSearchForm = document.getElementById('weaponSearchForm');
  const weaponSearchInput = document.getElementById('weaponSearchInput');
  const weaponQualityFilter = document.getElementById('weaponQualityFilter');
  const weaponSubclassFilter = document.getElementById('weaponSubclassFilter');
  const weaponSearchSubmit = document.getElementById('weaponSearchSubmit');
  const weaponSearchStatus = document.getElementById('weaponSearchStatus');
  const weaponSearchResults = document.getElementById('weaponSearchResults');
  const weaponSearchMore = document.getElementById('weaponSearchMore');
  const weaponEditorPanel = document.getElementById('weaponEditorPanel');
  const weaponEditorTitle = document.getElementById('weaponEditorTitle');
  const weaponEditorMeta = document.getElementById('weaponEditorMeta');
  const weaponEditorEntry = document.getElementById('weaponEditorEntry');
  const weaponEditorQuality = document.getElementById('weaponEditorQuality');
  const weaponCloneForm = document.getElementById('weaponCloneForm');
  const weaponCloneMsg = document.getElementById('weaponCloneMsg');
  const weaponCloneSubmit = document.getElementById('weaponCloneSubmit');
  const armorSearchForm = document.getElementById('armorSearchForm');
  const armorSearchInput = document.getElementById('armorSearchInput');
  const armorSubclassFilter = document.getElementById('armorSubclassFilter');
  const armorSlotFilter = document.getElementById('armorSlotFilter');
  const armorSearchStatus = document.getElementById('armorSearchStatus');
  const armorSearchSubmit = document.getElementById('armorSearchSubmit');
  const armorSearchResults = document.getElementById('armorSearchResults');
  const armorEditorPanel = document.getElementById('armorEditorPanel');
  const armorEditorTitle = document.getElementById('armorEditorTitle');
  const armorEditorMeta = document.getElementById('armorEditorMeta');
  const armorCloneForm = document.getElementById('armorCloneForm');
  const armorCloneMsg = document.getElementById('armorCloneMsg');
  const armorCloneSubmit = document.getElementById('armorCloneSubmit');
  const weaponFieldNames = [
    'name',
    'description',
    'class',
    'subclass',
    'Quality',
    'displayid',
    'InventoryType',
    'SoundOverrideSubclass',
    'Flags',
    'FlagsExtra',
    'BuyCount',
    'BuyPrice',
    'SellPrice',
    'Material',
    'sheath',
    'ItemLevel',
    'RequiredLevel',
    'maxcount',
    'stackable',
    'ContainerSlots',
    'StatsCount',
    'ScalingStatDistribution',
    'ScalingStatValue',
    'AllowableClass',
    'AllowableRace',
    'RequiredSkill',
    'RequiredSkillRank',
    'requiredspell',
    'requiredhonorrank',
    'RequiredCityRank',
    'RequiredReputationFaction',
    'RequiredReputationRank',
    'startquest',
    'bonding',
    'dmg_min1',
    'dmg_max1',
    'dmg_type1',
    'dmg_min2',
    'dmg_max2',
    'dmg_type2',
    'delay',
    'ammo_type',
    'RangedModRange',
    'armor',
    'holy_res',
    'fire_res',
    'nature_res',
    'frost_res',
    'shadow_res',
    'arcane_res',
    'block',
    'MaxDurability',
    'PageText',
    'LanguageID',
    'PageMaterial',
    'lockid',
    'RandomProperty',
    'RandomSuffix',
    'itemset',
    'area',
    'Map',
    'BagFamily',
    'TotemCategory',
    'RequiredDisenchantSkill',
    'ArmorDamageModifier',
    'duration',
    'ItemLimitCategory',
    'HolidayId',
    'ScriptName',
    'DisenchantID',
    'FoodType',
    'minMoneyLoot',
    'maxMoneyLoot',
    'flagsCustom',
    'VerifiedBuild',
    'socketBonus',
    'GemProperties',
  ];
  for (let i = 1; i <= 10; i += 1) {
    weaponFieldNames.push(`stat_type${i}`);
    weaponFieldNames.push(`stat_value${i}`);
  }
  for (let i = 1; i <= 5; i += 1) {
    weaponFieldNames.push(`spellid_${i}`);
    weaponFieldNames.push(`spelltrigger_${i}`);
    weaponFieldNames.push(`spellcharges_${i}`);
    weaponFieldNames.push(`spellppmRate_${i}`);
    weaponFieldNames.push(`spellcooldown_${i}`);
    weaponFieldNames.push(`spellcategory_${i}`);
    weaponFieldNames.push(`spellcategorycooldown_${i}`);
  }
  for (let i = 1; i <= 3; i += 1) {
    weaponFieldNames.push(`socketColor_${i}`);
    weaponFieldNames.push(`socketContent_${i}`);
  }
  const weaponFieldInputs = weaponFieldNames.reduce((map, name) => {
    map[name] = document.getElementById(`weaponField_${name}`);
    return map;
  }, {});
  const armorFieldNames = [
    'name',
    'description',
    'Quality',
    'class',
    'subclass',
    'InventoryType',
    'Armor',
    'ItemLevel',
    'RequiredLevel',
    'StatsCount',
    'socketColor_1',
    'socketColor_2',
    'socketColor_3',
    'socketBonus',
  ];
  for (let i = 1; i <= 5; i += 1) {
    armorFieldNames.push(`stat_type${i}`);
    armorFieldNames.push(`stat_value${i}`);
  }
  const armorFieldInputs = armorFieldNames.reduce((map, name) => {
    map[name] = document.getElementById(`armorField_${name}`);
    return map;
  }, {});
  const charactersCount = document.getElementById('charactersCount');
  const charactersRealmCount = document.getElementById('charactersRealmCount');
  const characterStatus = document.getElementById('charactersStatus');
  const characterGrid = document.getElementById('characterCardGrid');
  const charactersEmptyState = document.getElementById('charactersEmptyState');
  const characterFamilySelect = document.getElementById('characterFamilySelect');
  const characterRefreshButton = document.getElementById('characterRefreshButton');

  const gmClassicOnlineEndpoint = LIMITS.gmClassicOnlineEndpoint || '/api/gm/online/classic';
  const gmCommandEndpoint = LIMITS.gmCommandEndpoint || '/api/gm/command';
  const gmCommandListEndpoint = LIMITS.gmCommandListEndpoint || '/api/gm/commands';
  const gmClassicWeaponSearchEndpoint = LIMITS.gmClassicWeaponSearchEndpoint || '/api/gm/classic/weapons/search';
  const gmClassicWeaponDetailsEndpoint = LIMITS.gmClassicWeaponDetailsEndpoint || '/api/gm/classic/weapons';
  const gmClassicWeaponCloneEndpoint = LIMITS.gmClassicWeaponCloneEndpoint || '/api/gm/classic/weapons';
  const gmClassicArmorSearchEndpoint = LIMITS.gmClassicArmorSearchEndpoint || '/api/gm/classic/armors/search';
  const gmClassicArmorDetailsEndpoint = LIMITS.gmClassicArmorDetailsEndpoint || '/api/gm/classic/armors';
  const gmClassicArmorCloneEndpoint = LIMITS.gmClassicArmorCloneEndpoint || '/api/gm/classic/armors';
  const gmOnlinePollMs = Math.max(Number(LIMITS.gmOnlinePollMs) || 20000, 5000);
  const gmClassicOnlineLimit = Math.max(Number(LIMITS.gmClassicOnlineLimit) || 12, 1);

  if (weaponQualityFilter && ENUMS.itemQuality) {
    weaponQualityFilter.innerHTML = '<option value="">Any quality</option>';
    buildSelectOptions(weaponQualityFilter, ENUMS.itemQuality);
  }
  if (weaponSubclassFilter && ENUMS.weaponSubclass) {
    weaponSubclassFilter.innerHTML = '<option value="">Any type</option>';
    buildSelectOptions(weaponSubclassFilter, ENUMS.weaponSubclass);
  }
  if (weaponFieldInputs.Quality && ENUMS.itemQuality) {
    buildSelectOptions(weaponFieldInputs.Quality, ENUMS.itemQuality, { includeUnknown: true });
  }
  if (weaponFieldInputs.subclass && ENUMS.weaponSubclass) {
    buildSelectOptions(weaponFieldInputs.subclass, ENUMS.weaponSubclass, { includeUnknown: true });
  }
  ['socketColor_1', 'socketColor_2', 'socketColor_3'].forEach((key) => {
    const el = weaponFieldInputs[key];
    if (el && ENUMS.socketColor335) {
      buildSelectOptions(el, ENUMS.socketColor335, { includeUnknown: true });
    }
  });
  if (armorSubclassFilter && ENUMS.armorSubclass) {
    buildSelectOptions(armorSubclassFilter, ENUMS.armorSubclass, { includeUnknown: true });
  }
  if (armorSlotFilter && ENUMS.inventoryType) {
    buildSelectOptions(armorSlotFilter, ENUMS.inventoryType, { includeUnknown: true });
  }
  if (armorFieldInputs.subclass && ENUMS.armorSubclass) {
    buildSelectOptions(armorFieldInputs.subclass, ENUMS.armorSubclass, { includeUnknown: true });
  }
  if (armorFieldInputs.InventoryType && ENUMS.inventoryType) {
    buildSelectOptions(armorFieldInputs.InventoryType, ENUMS.inventoryType, { includeUnknown: true });
  }
  if (armorFieldInputs.Quality && ENUMS.itemQuality) {
    buildSelectOptions(armorFieldInputs.Quality, ENUMS.itemQuality, { includeUnknown: true });
  }
  ['socketColor_1', 'socketColor_2', 'socketColor_3'].forEach((key) => {
    const el = armorFieldInputs[key];
    if (el && ENUMS.socketColor335) {
      buildSelectOptions(el, ENUMS.socketColor335, { includeUnknown: true });
    }
  });

  let currentSession = null;
  let activeTabId = 'accountTabPanel';
  let gmClassicAccessible = false;
  let gmRetailAccessible = false;
  let classicOnlineTimer = null;
  let healthLoaded = false;
  let charactersPayload = null;
  let charactersLoaded = false;
  let charactersLoading = false;
  let selectedFamilyKey = 'retail';
  let gmCommandReferenceRealm = null;
  let gmCommandReference = [];
  let gmCommandReferenceLoading = false;
  let gmCommandReferenceError = null;
  let gmCommandFilterValue = '';
  let weaponSearchLoading = false;
  let weaponSearchPage = 1;
  const weaponSearchPageSize = 25;
  let currentWeaponBase = null;
  let weaponCloneBusy = false;
  let armorSearchLoading = false;
  let armorSearchPage = 1;
  const armorSearchPageSize = 25;
  let currentArmorBase = null;
  let armorCloneBusy = false;
  let armorSearchAutoloaded = false;

  const storedTabId = readStoredValue(STORAGE_KEYS.tab);
  if (storedTabId && document.getElementById(storedTabId)) {
    activeTabId = storedTabId;
  }
  const storedFamily = readStoredValue(STORAGE_KEYS.family);
  if (storedFamily && (storedFamily === 'retail' || storedFamily === 'classic')) {
    selectedFamilyKey = storedFamily;
  }

  if (characterFamilySelect) {
    characterFamilySelect.value = selectedFamilyKey;
  }

  function setLoading(state) {
    if (!submit) return;
    submit.disabled = state;
    submit.classList.toggle('opacity-60', state);
  }

  function setLinkLoading(button, state) {
    if (!button) return;
    button.disabled = state;
    button.classList.toggle('opacity-60', state);
  }

  function realmLabel(realm) {
    const labels = LIMITS.familyLabels || {};
    return realm === 'classic'
      ? labels.classic || 'Classic'
      : labels.retail || 'Retail';
  }

  function normalizeGmPayload(value) {
    if (!value || typeof value !== 'object') {
      return { retail: {}, classic: {} };
    }
    const normalize = (info) => (info && typeof info === 'object' ? info : {});
    return {
      retail: normalize(value.retail),
      classic: normalize(value.classic),
    };
  }

  function makeClassicOnlineMessage(text) {
    const msg = document.createElement('p');
    msg.className = 'text-sm text-indigo-200/80';
    msg.textContent = text;
    return msg;
  }

  function setClassicOnlinePlaceholder(message) {
    if (!classicOnlineList) return;
    classicOnlineList.innerHTML = '';
    classicOnlineList.appendChild(makeClassicOnlineMessage(message));
  }

  function renderClassicOnlineList(items) {
    if (!classicOnlineList) return;
    classicOnlineList.innerHTML = '';
    const list = Array.isArray(items) ? items.slice(0, gmClassicOnlineLimit) : [];
    if (!list.length) {
      classicOnlineList.appendChild(makeClassicOnlineMessage('No Classic characters online right now.'));
      return;
    }
    list.forEach((entry) => {
      const container = document.createElement('div');
      container.className = 'rounded-2xl border border-white/5 bg-gray-900/80 p-3 text-sm text-indigo-100/90';
      const header = document.createElement('div');
      header.className = 'flex items-center justify-between gap-2';
      const nameEl = document.createElement('span');
      nameEl.className = 'font-semibold text-white';
      nameEl.textContent = entry?.name || entry?.characterName || entry?.player || 'Unknown';
      const levelEl = document.createElement('span');
      levelEl.className = 'text-xs uppercase tracking-[0.25em] text-indigo-200/70';
      const levelValue = Number(entry?.level ?? entry?.Level);
      levelEl.textContent = Number.isFinite(levelValue) && levelValue > 0 ? `Lv ${levelValue}` : '';
      header.appendChild(nameEl);
      header.appendChild(levelEl);
      container.appendChild(header);

      const meta = document.createElement('p');
      meta.className = 'text-xs text-indigo-200/80';
      const account = entry?.accountName || entry?.account || entry?.username || null;
      const accountId = entry?.accountId ?? entry?.account_id;
      const zone = entry?.zone || entry?.zoneName || entry?.map || entry?.area || '';
      const gmLevel =
        entry?.gmLevel ?? entry?.gmlevel ?? entry?.GMLevel ?? entry?.securitylevel ?? entry?.SecurityLevel;
      const parts = [];
      if (account) parts.push(account);
      if (accountId != null) parts.push(`#${accountId}`);
      if (zone) parts.push(zone);
      if (gmLevel != null) parts.push(`GM${gmLevel}`);
      meta.textContent = parts.length ? parts.join(' · ') : '—';
      container.appendChild(meta);

      classicOnlineList.appendChild(container);
    });
  }

  function buildHealthCardRefs(branchKey) {
    const card = document.querySelector(`[data-health-card="${branchKey}"]`);
    if (!card) return null;
    return {
      card,
      badge: card.querySelector('[data-health-status]'),
      statusText: card.querySelector('[data-health-status-text]'),
      updated: card.querySelector('[data-health-updated]'),
      uptime: card.querySelector('[data-health-uptime]'),
      uptimeHint: card.querySelector('[data-health-uptime-hint]'),
      players: card.querySelector('[data-health-players]'),
      factionAlliance: card.querySelector('[data-health-faction-alliance]'),
      factionHorde: card.querySelector('[data-health-faction-horde]'),
      worldUpdate: card.querySelector('[data-health-world-update]'),
      history: card.querySelector('[data-health-history]'),
      warning: card.querySelector('[data-health-warning]'),
      errors: card.querySelector('[data-health-errors]'),
      errorList: card.querySelector('[data-health-error-list]'),
    };
  }

  function formatDuration(seconds) {
    const value = Number(seconds);
    if (!Number.isFinite(value) || value < 0) return 'Unknown';
    const parts = [];
    const days = Math.floor(value / 86400);
    const hours = Math.floor((value % 86400) / 3600);
    const minutes = Math.floor((value % 3600) / 60);
    const secs = Math.floor(value % 60);
    if (days) parts.push(`${days}d`);
    if (hours) parts.push(`${hours}h`);
    if (minutes) parts.push(`${minutes}m`);
    if (!parts.length) parts.push(`${secs}s`);
    return parts.join(' ');
  }

  function formatTimestamp(value) {
    const date = value ? new Date(value) : null;
    if (!date || Number.isNaN(date.getTime())) return '—';
    return date.toLocaleString();
  }

  function renderBranchHealth(branchKey, health) {
    const refs = healthCards[branchKey] || buildHealthCardRefs(branchKey);
    if (!refs) return;
    healthCards[branchKey] = refs;

    const status = (health?.status || 'unknown').toLowerCase();
    const statusLabel = status.charAt(0).toUpperCase() + status.slice(1);
    const statusMessages = {
      online: 'All checks passed.',
      partial: 'Partial data (some checks failed).',
      offline: 'This realm appears offline or unreachable right now.',
      unknown: 'Status unknown.',
    };
    const badgeBase = 'rounded-full px-3 py-1 text-[11px] font-semibold uppercase tracking-[0.3em]';
    const badgeClass =
      status === 'online'
        ? 'border border-emerald-300/60 bg-emerald-500/15 text-emerald-100'
        : status === 'partial'
          ? 'border border-amber-300/60 bg-amber-500/15 text-amber-100'
          : status === 'offline'
            ? 'border border-rose-300/60 bg-rose-500/15 text-rose-100'
            : 'border border-white/20 bg-white/5 text-indigo-200/80';

    if (refs.badge) {
      refs.badge.className = `${badgeBase} ${badgeClass}`;
      refs.badge.textContent = statusLabel || 'Unknown';
    }

    if (refs.card) {
      const statusBorders = [
        'border-emerald-300/60',
        'border-amber-300/60',
        'border-rose-300/60',
        'shadow-emerald-900/30',
        'shadow-amber-900/30',
        'shadow-rose-900/30',
      ];
      refs.card.classList.remove(...statusBorders);
      if (status === 'online') {
        refs.card.classList.add('border-emerald-300/60', 'shadow-emerald-900/30');
      } else if (status === 'partial') {
        refs.card.classList.add('border-amber-300/60', 'shadow-amber-900/30');
      } else if (status === 'offline') {
        refs.card.classList.add('border-rose-300/60', 'shadow-rose-900/30');
      }
    }

    if (refs.statusText) {
      refs.statusText.textContent = statusMessages[status] || statusMessages.unknown;
    }
    if (refs.updated) {
      refs.updated.textContent = formatTimestamp(health?.lastUpdated);
    }

    const metrics = health?.metrics || {};
    const history = health?.history || {};
    const fallbackLabel = status === 'offline' ? 'Unavailable' : 'Unknown';

    if (refs.uptime) {
      refs.uptime.textContent =
        metrics.uptimeSeconds != null ? formatDuration(metrics.uptimeSeconds) : fallbackLabel;
    }
    if (refs.uptimeHint) {
      refs.uptimeHint.textContent =
        metrics.maxOnline != null ? `Max online: ${metrics.maxOnline}` : fallbackLabel;
    }
    if (refs.players) {
      refs.players.textContent =
        metrics.onlinePlayers != null && Number.isFinite(Number(metrics.onlinePlayers))
          ? String(metrics.onlinePlayers)
          : fallbackLabel;
    }
    if (refs.factionAlliance) {
      const alliance = metrics?.factionOnline?.alliance;
      refs.factionAlliance.textContent = alliance != null ? String(alliance) : '—';
    }
    if (refs.factionHorde) {
      const horde = metrics?.factionOnline?.horde;
      refs.factionHorde.textContent = horde != null ? String(horde) : '—';
    }
    if (refs.worldUpdate) {
      refs.worldUpdate.textContent =
        metrics.worldUpdateMs != null && Number.isFinite(Number(metrics.worldUpdateMs))
          ? `${metrics.worldUpdateMs} ms`
          : fallbackLabel;
    }
    if (refs.history) {
      const parts = [];
      if (history.lastRestartAt) parts.push(`Restart ${formatTimestamp(history.lastRestartAt)}`);
      if (history.recordOnline != null) parts.push(`Record ${history.recordOnline}`);
      if (history.avgSessionSeconds != null) parts.push(`Avg ${formatDuration(history.avgSessionSeconds)}`);
      refs.history.textContent = parts.length ? parts.join(' · ') : fallbackLabel;
    }

    if (refs.warning) {
      const warningText =
        status === 'offline'
          ? 'This realm appears offline or unreachable right now.'
          : status === 'partial'
            ? 'Partial data (some checks failed).'
            : '';
      if (warningText) {
        refs.warning.textContent = warningText;
        refs.warning.classList.remove('hidden');
      } else {
        refs.warning.classList.add('hidden');
      }
    }

    if (refs.errors && refs.errorList) {
      const errorList = Array.isArray(health?.errors)
        ? health.errors.filter((entry) => Boolean(entry))
        : [];
      refs.errorList.innerHTML = '';
      if (errorList.length) {
        errorList.forEach((item) => {
          const li = document.createElement('li');
          li.textContent = item;
          refs.errorList.appendChild(li);
        });
        refs.errors.classList.remove('hidden');
      } else {
        refs.errors.classList.add('hidden');
      }
    }
  }

  function formatWeaponQualityLabel(value) {
    const key = Number(value);
    if (Number.isFinite(key) && ENUMS.itemQuality && ENUMS.itemQuality[key] != null) {
      return ENUMS.itemQuality[key];
    }
    if (Number.isFinite(key) && WEAPON_QUALITY_NAMES[key] != null) {
      return WEAPON_QUALITY_NAMES[key];
    }
    return Number.isFinite(key) ? `Quality ${key}` : 'Quality —';
  }

  function formatWeaponSubclassLabel(value) {
    const key = Number(value);
    if (Number.isFinite(key) && ENUMS.weaponSubclass && ENUMS.weaponSubclass[key] != null) {
      return ENUMS.weaponSubclass[key];
    }
    if (Number.isFinite(key) && WEAPON_SUBCLASS_NAMES[key] != null) {
      return WEAPON_SUBCLASS_NAMES[key];
    }
    return Number.isFinite(key) ? `Subclass ${key}` : 'Subclass —';
  }

  function setWeaponSearchStatus(message) {
    if (weaponSearchStatus) {
      weaponSearchStatus.textContent = message;
    }
  }

  function setWeaponSearchLoadingState(state) {
    weaponSearchLoading = Boolean(state);
    if (weaponSearchSubmit) {
      weaponSearchSubmit.disabled = weaponSearchLoading || !gmClassicAccessible;
      weaponSearchSubmit.classList.toggle('opacity-60', weaponSearchSubmit.disabled);
    }
  }

  function updateWeaponCloneAvailability() {
    if (!weaponCloneSubmit) return;
    const disabled = weaponCloneBusy || !gmClassicAccessible || !currentWeaponBase;
    weaponCloneSubmit.disabled = disabled;
    weaponCloneSubmit.classList.toggle('opacity-60', disabled);
  }

  function setWeaponCloneLoading(state) {
    weaponCloneBusy = Boolean(state);
    updateWeaponCloneAvailability();
  }

  function setWeaponCloneMessage(message) {
    if (weaponCloneMsg) {
      weaponCloneMsg.textContent = message;
    }
  }

  function setArmorSearchStatus(message) {
    if (armorSearchStatus) {
      armorSearchStatus.textContent = message;
    }
  }

  function setArmorSearchLoading(state) {
    armorSearchLoading = Boolean(state);
    if (armorSearchSubmit) {
      armorSearchSubmit.disabled = armorSearchLoading || !gmClassicAccessible;
      armorSearchSubmit.classList.toggle('opacity-60', armorSearchSubmit.disabled);
    }
  }

  function updateArmorCloneAvailability() {
    if (!armorCloneSubmit) return;
    const disabled = armorCloneBusy || !gmClassicAccessible || !currentArmorBase;
    armorCloneSubmit.disabled = disabled;
    armorCloneSubmit.classList.toggle('opacity-60', disabled);
  }

  function setArmorCloneLoading(state) {
    armorCloneBusy = Boolean(state);
    updateArmorCloneAvailability();
  }

  function setArmorCloneMessage(message) {
    if (armorCloneMsg) {
      armorCloneMsg.textContent = message;
    }
  }

  function syncWeaponFactoryState() {
    const gmBlocked = !gmClassicAccessible;
    if (weaponFactoryCard) {
      weaponFactoryCard.classList.toggle('opacity-60', gmBlocked);
    }
    if (armorSearchCard) {
      armorSearchCard.classList.toggle('opacity-60', gmBlocked);
    }
    if (!weaponSearchStatus && !armorSearchStatus) {
      return;
    }
    if (gmBlocked) {
      setWeaponSearchStatus('Classic GM access required to use the weapon factory.');
      if (weaponSearchResults && !weaponSearchResults.childElementCount) {
        weaponSearchResults.innerHTML = '<p class="text-sm text-indigo-200/75">Classic GM access required.</p>';
      }
      if (weaponEditorPanel) {
        weaponEditorPanel.classList.add('hidden');
      }
      currentWeaponBase = null;
      setWeaponCloneMessage('Classic GM access required to clone weapons.');
      setArmorSearchStatus('Classic GM access required to search armors.');
      if (armorSearchResults && !armorSearchResults.childElementCount) {
        armorSearchResults.innerHTML = '<p class="text-xs text-indigo-200/70">Classic GM access required.</p>';
      }
      if (armorEditorPanel) {
        armorEditorPanel.classList.add('hidden');
      }
      currentArmorBase = null;
      setArmorCloneMessage('Classic GM access required to clone armor.');
    } else {
      if (!weaponSearchLoading) {
        setWeaponSearchStatus('Search or filter to choose a base weapon.');
        if (!currentWeaponBase) {
          setWeaponCloneMessage('Select a weapon to begin cloning.');
        }
      }
      if (!armorSearchLoading) {
        setArmorSearchStatus('Enter a name or entry ID to begin.');
        if (!currentArmorBase) {
          setArmorCloneMessage('Select an armor template and adjust fields to clone it into a new item.');
        }
      }
    }
    setWeaponSearchLoadingState(weaponSearchLoading);
    setArmorSearchLoading(armorSearchLoading);
    updateWeaponCloneAvailability();
    updateArmorCloneAvailability();
  }

  function ensureArmorSearchLoaded() {
    if (armorSearchAutoloaded || !gmClassicAccessible) {
      return;
    }
    armorSearchAutoloaded = true;
    loadArmorSearch(true);
  }

  function renderWeaponSearchResults(items, hasMore) {
    if (!weaponSearchResults) {
      return;
    }
    weaponSearchResults.innerHTML = '';
    const list = Array.isArray(items) ? items : [];
    if (!list.length) {
      weaponSearchResults.innerHTML = '<p class="text-sm text-indigo-200/75">No matching weapons found.</p>';
    } else {
      list.forEach((item) => {
        const entryValue = Number(item?.entry);
        const qualityLabel = formatWeaponQualityLabel(item?.Quality);
        const subclassLabel = formatWeaponSubclassLabel(item?.subclass);
        const itemLevel = Number(item?.ItemLevel ?? item?.itemLevel);
        const reqLevel = Number(item?.RequiredLevel ?? item?.requiredLevel);
        const button = document.createElement('button');
        button.type = 'button';
        button.dataset.weaponEntry = Number.isFinite(entryValue) ? String(entryValue) : '';
        button.className = 'rounded-2xl border border-white/10 bg-gray-900/60 p-3 text-left transition hover:border-amber-400 focus:outline-none focus:ring-2 focus:ring-amber-400';
        const entryLabel = Number.isFinite(entryValue) ? String(entryValue) : '—';
        button.innerHTML = `
          <div class="flex items-center justify-between gap-2">
            <span class="text-white font-semibold">${escapeHtml(item?.name || `Entry #${entryValue || '—'}`)}</span>
            <span class="text-xs font-semibold uppercase tracking-[0.35em] text-indigo-200/80">#${escapeHtml(entryLabel)}</span>
          </div>
          <p class="text-xs text-indigo-200/75">${escapeHtml(qualityLabel)} · ilvl ${Number.isFinite(itemLevel) ? itemLevel : '—'} · req ${Number.isFinite(reqLevel) ? reqLevel : '—'}</p>
          <p class="text-xs text-indigo-200/60">${escapeHtml(subclassLabel)}</p>
        `;
        weaponSearchResults.appendChild(button);
      });
    }
    if (weaponSearchMore) {
      weaponSearchMore.classList.toggle('hidden', !hasMore);
    }
  }

  async function runWeaponSearch(page = 1) {
    if (!gmClassicAccessible) {
      setWeaponSearchStatus('Classic GM access required to use the weapon factory.');
      return;
    }
    const query = weaponSearchInput?.value.trim() || '';
    const quality = weaponQualityFilter?.value || '';
    const subclass = weaponSubclassFilter?.value || '';
    const params = new URLSearchParams();
    params.set('page', String(page));
    params.set('pageSize', String(weaponSearchPageSize));
    if (query) params.set('q', query);
    if (quality) params.set('quality', quality);
    if (subclass) params.set('subclass', subclass);
    const url = `${gmClassicWeaponSearchEndpoint}?${params.toString()}`;
    setWeaponSearchStatus('Searching…');
    setWeaponSearchLoadingState(true);
    try {
      const res = await fetch(url, { credentials: 'same-origin' });
      if (res.status === 401) {
        window.location.href = '/login';
        return;
      }
      const data = await res.json().catch(() => ({}));
      if (!res.ok) {
        throw new Error(data?.error || 'Unable to search weapons.');
      }
      const items = Array.isArray(data?.items) ? data.items : [];
      renderWeaponSearchResults(items, Boolean(data?.hasMore));
      weaponSearchPage = Number(data?.page) || 1;
      if (items.length) {
        setWeaponSearchStatus(
          data?.hasMore
            ? `Showing ${items.length} weapons (refine search for more).`
            : `Found ${items.length} weapon${items.length === 1 ? '' : 's'}.`
        );
      } else {
        setWeaponSearchStatus('No matching weapons found.');
      }
    } catch (err) {
      console.error('Classic weapon search failed', err);
      setWeaponSearchStatus(err?.message || 'Weapon search failed.');
      if (weaponSearchResults) {
        weaponSearchResults.innerHTML = '<p class="text-sm text-rose-200/80">Unable to search weapons right now.</p>';
      }
      if (weaponSearchMore) {
        weaponSearchMore.classList.add('hidden');
      }
    } finally {
      setWeaponSearchLoadingState(false);
    }
  }

  function populateWeaponForm(item) {
    if (!item || typeof item !== 'object') {
      return;
    }
    Object.entries(weaponFieldInputs).forEach(([field, input]) => {
      if (!input) return;
      const raw = item[field];
      if (raw == null) {
        input.value = '';
      } else {
        input.value = typeof raw === 'string' ? raw : String(raw);
      }
    });
  }

  async function loadWeaponDetails(entry) {
    const numericEntry = Number(entry);
    if (!gmClassicAccessible || !Number.isFinite(numericEntry) || numericEntry <= 0) {
      return;
    }
    setWeaponCloneMessage('Loading weapon template…');
    try {
      const res = await fetch(`${gmClassicWeaponDetailsEndpoint}/${numericEntry}`, { credentials: 'same-origin' });
      if (res.status === 401) {
        window.location.href = '/login';
        return;
      }
      const data = await res.json().catch(() => ({}));
      if (!res.ok || !data?.item) {
        throw new Error(data?.error || 'Item not found.');
      }
      currentWeaponBase = data.item;
      populateWeaponForm(currentWeaponBase);
      const qualityLabel = formatWeaponQualityLabel(currentWeaponBase.Quality);
      const itemLevel = Number(currentWeaponBase.ItemLevel);
      const reqLevel = Number(currentWeaponBase.RequiredLevel);
      if (weaponEditorTitle) {
        weaponEditorTitle.textContent = currentWeaponBase.name || `Entry #${numericEntry}`;
      }
      if (weaponEditorEntry) {
        weaponEditorEntry.textContent = `#${numericEntry}`;
      }
      if (weaponEditorQuality) {
        weaponEditorQuality.textContent = `${qualityLabel} · ${formatWeaponSubclassLabel(currentWeaponBase.subclass)}`;
      }
      if (weaponEditorMeta) {
        weaponEditorMeta.textContent = `ilvl ${Number.isFinite(itemLevel) ? itemLevel : '—'} · req ${
          Number.isFinite(reqLevel) ? reqLevel : '—'
        } · InventoryType ${currentWeaponBase.InventoryType ?? '—'}`;
      }
      if (weaponEditorPanel) {
        weaponEditorPanel.classList.remove('hidden');
        weaponEditorPanel.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
      setWeaponCloneMessage('Ready to clone this weapon. Update any fields and mint a new entry.');
      updateWeaponCloneAvailability();
    } catch (err) {
      console.error('Failed to load weapon template', err);
      setWeaponCloneMessage(err?.message || 'Unable to load that weapon.');
    }
  }

  function collectWeaponPayload() {
    const payload = {};
    Object.entries(weaponFieldInputs).forEach(([field, input]) => {
      if (!input) return;
      const value = input.value;
      if (weaponStringFields.has(field)) {
        const normalized = field === 'description' ? value || '' : (value || '').trim();
        payload[field] = normalized;
        return;
      }
      if (value === '' || value == null) {
        return;
      }
      const num = Number(value);
      if (!Number.isFinite(num)) {
        throw new Error(`Invalid value for ${field}.`);
      }
      payload[field] = num;
    });
    const trimmedName = (payload.name || '').trim();
    if (!trimmedName) {
      throw new Error('Custom name is required.');
    }
    payload.name = trimmedName;
    if (payload.ScriptName != null) {
      payload.ScriptName = String(payload.ScriptName).trim();
    }
    return payload;
  }

  async function handleWeaponClone(event) {
    event?.preventDefault();
    if (!gmClassicAccessible) {
      setWeaponCloneMessage('Classic GM access required to clone weapons.');
      return;
    }
    if (!currentWeaponBase || !Number.isFinite(Number(currentWeaponBase.entry))) {
      setWeaponCloneMessage('Select a base weapon first.');
      return;
    }
    let payload;
    try {
      payload = collectWeaponPayload();
    } catch (err) {
      setWeaponCloneMessage(err?.message || 'Fix validation errors before cloning.');
      return;
    }
    setWeaponCloneMessage('Cloning weapon…');
    setWeaponCloneLoading(true);
    try {
      const res = await fetch(`${gmClassicWeaponCloneEndpoint}/${currentWeaponBase.entry}/clone`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'same-origin',
        body: JSON.stringify(payload),
      });
      if (res.status === 401) {
        window.location.href = '/login';
        return;
      }
      const data = await res.json().catch(() => ({}));
      if (!res.ok) {
        throw new Error(data?.error || 'Clone failed.');
      }
      const newEntry = data?.entry || data?.newEntry;
      const displayName = data?.name || payload.name;
      setWeaponCloneMessage(`Minted item #${newEntry}: ${displayName}. Reload your worldserver cache to use it.`);
    } catch (err) {
      console.error('Weapon clone failed', err);
      setWeaponCloneMessage(err?.message || 'Unable to clone weapon right now.');
    } finally {
      setWeaponCloneLoading(false);
    }
  }

  function renderArmorSearchResults(items) {
    if (!armorSearchResults) return;
    armorSearchResults.innerHTML = '';
    const list = Array.isArray(items) ? items : [];
    if (!list.length) {
      armorSearchResults.innerHTML = '<p class="text-xs text-indigo-200/70">No armor templates matched your search.</p>';
      return;
    }
    list.forEach((item) => {
      const row = document.createElement('button');
      row.type = 'button';
      row.className =
        'w-full rounded-xl border border-white/10 bg-black/30 px-3 py-2 text-left text-xs text-indigo-100/90 hover:border-violet-400/70 hover:bg-violet-900/20 transition flex items-center justify-between gap-3';
      const left = document.createElement('div');
      const title = document.createElement('p');
      title.className = 'font-semibold text-indigo-50';
      title.textContent = `${item.name || 'Unknown'} (ID ${item.entry})`;
      left.appendChild(title);
      const meta = document.createElement('p');
      meta.className = 'text-[11px] text-indigo-200/80';
      const slotLabel = formatEnumLabel(ENUMS.inventoryType, item.InventoryType, 'Slot');
      const armorTypeLabel = formatEnumLabel(ENUMS.armorSubclass, item.subclass, 'Type');
      const lvl = Number(item.ItemLevel);
      const req = Number(item.RequiredLevel);
      const parts = [];
      if (slotLabel) parts.push(slotLabel);
      if (armorTypeLabel) parts.push(armorTypeLabel);
      if (Number.isFinite(lvl) && lvl > 0) parts.push(`iLvl ${lvl}`);
      if (Number.isFinite(req) && req > 0) parts.push(`Req ${req}`);
      meta.textContent = parts.join(' · ');
      left.appendChild(meta);
      row.appendChild(left);
      row.addEventListener('click', () => {
        loadArmorDetails(item.entry);
      });
      armorSearchResults.appendChild(row);
    });
  }

  async function loadArmorSearch(resetPage = false) {
    if (!gmClassicAccessible) {
      setArmorSearchStatus('Classic GM access required to search armors.');
      return;
    }
    if (armorSearchLoading) return;
    if (resetPage) armorSearchPage = 1;
    setArmorSearchLoading(true);
    setArmorSearchStatus('Searching…');

    const params = new URLSearchParams();
    const q = (armorSearchInput?.value || '').trim();
    if (q) params.set('q', q);
    const subclassVal = armorSubclassFilter?.value || '';
    if (subclassVal) params.set('armorType', subclassVal);
    const slotVal = armorSlotFilter?.value || '';
    if (slotVal) params.set('slot', slotVal);
    params.set('page', String(armorSearchPage));
    params.set('pageSize', String(armorSearchPageSize));

    try {
      const url = `${gmClassicArmorSearchEndpoint}?${params.toString()}`;
      const res = await fetch(url, { credentials: 'same-origin' });
      if (res.status === 401) {
        window.location.href = '/login';
        return;
      }
      const data = await res.json().catch(() => ({}));
      if (!res.ok || !data?.ok) {
        throw new Error(data?.error || 'Search failed.');
      }
      const items = Array.isArray(data.items) ? data.items : [];
      renderArmorSearchResults(items);
      armorSearchPage = Number(data.page) || 1;
      const total = items.length;
      setArmorSearchStatus(
        total
          ? `Showing ${total} result${total === 1 ? '' : 's'} (page ${data.page || 1}).`
          : 'No armor templates matched your search.'
      );
    } catch (err) {
      console.error('Armor search failed', err);
      setArmorSearchStatus(err?.message || 'Search failed.');
      if (armorSearchResults) {
        armorSearchResults.innerHTML = '<p class="text-xs text-rose-200/80">Failed to search armors. Check console for details.</p>';
      }
    } finally {
      setArmorSearchLoading(false);
    }
  }

  async function loadArmorDetails(entryId) {
    if (!gmClassicAccessible) return;
    const numericEntry = Number(entryId);
    if (!Number.isFinite(numericEntry) || numericEntry <= 0) return;
    if (armorCloneMsg) {
      armorCloneMsg.textContent = 'Loading armor template…';
    }
    try {
      const res = await fetch(`${gmClassicArmorDetailsEndpoint}/${numericEntry}`, {
        credentials: 'same-origin',
      });
      if (res.status === 401) {
        window.location.href = '/login';
        return;
      }
      const data = await res.json().catch(() => ({}));
      if (!res.ok || !data?.ok || !data?.armor) {
        throw new Error(data?.error || 'Failed to load armor template.');
      }
      const armor = data.armor;
      currentArmorBase = armor;
      if (armorEditorPanel) armorEditorPanel.classList.remove('hidden');
      if (armorEditorTitle) {
        armorEditorTitle.textContent = `${armor.name || 'Unknown armor'} (ID ${armor.entry})`;
      }
      if (armorEditorMeta) {
        const slotLabel = formatEnumLabel(ENUMS.inventoryType, armor.InventoryType, 'Slot');
        const armorTypeLabel = formatEnumLabel(ENUMS.armorSubclass, armor.subclass, 'Type');
        const qualityLabel = formatEnumLabel(ENUMS.itemQuality, armor.Quality, 'Quality');
        const lvl = Number(armor.ItemLevel);
        const req = Number(armor.RequiredLevel);
        const parts = [];
        if (slotLabel) parts.push(slotLabel);
        if (armorTypeLabel) parts.push(armorTypeLabel);
        if (qualityLabel) parts.push(qualityLabel);
        if (Number.isFinite(lvl) && lvl > 0) parts.push(`iLvl ${lvl}`);
        if (Number.isFinite(req) && req > 0) parts.push(`Req ${req}`);
        armorEditorMeta.textContent = parts.join(' · ');
      }
      Object.entries(armorFieldInputs).forEach(([name, input]) => {
        if (!input) return;
        let value = armor[name];
        if (name.startsWith('socketColor_')) {
          value = normalizeSocketColor(value);
        }
        if (value == null) {
          input.value = '';
        } else {
          input.value = String(value);
        }
      });
      if (armorCloneMsg) {
        armorCloneMsg.textContent = 'Adjust any fields you want to change, then use Clone armor to create a new custom template.';
      }
      updateArmorCloneAvailability();
    } catch (err) {
      console.error('Armor details failed', err);
      if (armorCloneMsg) {
        armorCloneMsg.textContent = err?.message || 'Failed to load armor template.';
      }
    }
  }

  async function handleArmorClone(event) {
    event?.preventDefault();
    if (!gmClassicAccessible) {
      setArmorCloneMessage('Classic GM access required to clone armor.');
      return;
    }
    if (!currentArmorBase) {
      setArmorCloneMessage('Select an armor template first.');
      return;
    }
    setArmorCloneLoading(true);
    if (armorCloneMsg) armorCloneMsg.textContent = 'Cloning armor template…';
    try {
      const fields = {};
      Object.entries(armorFieldInputs).forEach(([name, input]) => {
        if (!input) return;
        const raw = input.value;
        if (name.startsWith('socketColor_')) {
          fields[name] = normalizeSocketColor(raw || 0);
        } else if (raw === '' || raw == null) {
          fields[name] = currentArmorBase[name];
        } else {
          const num = Number(raw);
          fields[name] = Number.isFinite(num) ? num : raw;
        }
      });
      const res = await fetch(`${gmClassicArmorCloneEndpoint}/${currentArmorBase.entry}/clone`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'same-origin',
        body: JSON.stringify({ fields }),
      });
      if (res.status === 401) {
        window.location.href = '/login';
        return;
      }
      const data = await res.json().catch(() => ({}));
      if (!res.ok || !data?.ok) {
        throw new Error(data?.error || 'Clone failed.');
      }
      const newEntry = data.entry;
      if (armorCloneMsg) {
        armorCloneMsg.textContent = `Cloned armor as entry ${newEntry}. Remember to add it to loot, vendors, or scripts as needed.`;
      }
    } catch (err) {
      console.error('Armor clone failed', err);
      if (armorCloneMsg) {
        armorCloneMsg.textContent = err?.message || 'Failed to clone armor template.';
      }
    } finally {
      setArmorCloneLoading(false);
    }
  }

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

  const WEAPON_QUALITY_NAMES = {
    0: 'Poor',
    1: 'Common',
    2: 'Uncommon',
    3: 'Rare',
    4: 'Epic',
    5: 'Legendary',
    6: 'Artifact',
    7: 'Heirloom',
  };

  const WEAPON_SUBCLASS_NAMES = {
    0: 'One-Handed Axes',
    1: 'Two-Handed Axes',
    2: 'Bows',
    3: 'Guns',
    4: 'One-Handed Maces',
    5: 'Two-Handed Maces',
    6: 'Polearms',
    7: 'One-Handed Swords',
    8: 'Two-Handed Swords',
    9: 'Obsolete',
    10: 'Staves',
    11: 'Exotic',
    12: 'Fist Weapons',
    13: 'Miscellaneous',
    14: 'Daggers',
    15: 'Thrown',
    16: 'Spears',
    17: 'Crossbows',
    18: 'Wands',
    19: 'Fishing Poles',
  };

  const weaponStringFields = new Set(['name', 'description', 'ScriptName']);

  const FAMILY_DEFAULTS = {
    retail: 'DreamCore Master',
    classic: 'DreamCore Classic',
  };
  const configuredLabels = LIMITS.familyLabels || {};
  const FAMILY_LABELS = {
    retail: configuredLabels.retail || LIMITS.brandName || FAMILY_DEFAULTS.retail,
    classic: configuredLabels.classic || LIMITS.classicBrandName || FAMILY_DEFAULTS.classic,
  };

  function formatFamilyLabel(family) {
    if (!family) return FAMILY_LABELS.retail;
    return FAMILY_LABELS[family] || family.charAt(0).toUpperCase() + family.slice(1);
  }

  function escapeHtml(value) {
    return String(value || '').replace(/[&<>"']/g, (ch) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[ch] || ch));
  }

  function escapeAttribute(value) {
    return String(value || '')
      .replace(/\s+/g, ' ')
      .replace(/[&<>"']/g, (ch) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[ch] || ch));
  }

  function formatDate(value) {
    if (!value) return 'Unknown';
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) return 'Unknown';
    return date.toLocaleString();
  }

  function renderCharacterCard(character) {
    const className = CLASS_NAMES[character.class] || `Class #${character.class}`;
    const raceName = RACE_NAMES[character.race] || `Race #${character.race}`;
    const realmName = character.realm?.name || 'Unknown realm';
    const lastPlayed = formatDate(character.lastLogin);
    return `
      <article class="rounded-3xl gradient-border bg-gray-900/70 p-5 shadow-inner shadow-indigo-900/40">
        <div class="flex items-baseline justify-between">
          <h3 class="text-xl font-semibold text-white">${escapeHtml(character.name)}</h3>
          <span class="text-sm font-semibold text-indigo-300">Lvl ${escapeHtml(character.level)}</span>
        </div>
        <p class="mt-2 text-[15px] text-indigo-100/90">${escapeHtml(raceName)} · ${escapeHtml(className)}</p>
        <p class="mt-2 text-sm text-indigo-200/80">Realm: <span class="font-semibold text-indigo-100">${escapeHtml(realmName)}</span></p>
        <p class="mt-2 text-xs text-indigo-200/70">Last seen: ${escapeHtml(lastPlayed)}</p>
      </article>
    `;
  }

  function updateFamilySelectState(families) {
    if (!characterFamilySelect) return;
    const availableKeys = new Set((Array.isArray(families) ? families : []).map((family) => (family?.family || 'retail')));
    Array.from(characterFamilySelect.options || []).forEach((option) => {
      const isAvailable = availableKeys.has(option.value);
      option.disabled = !isAvailable;
      option.classList.toggle('opacity-60', !isAvailable);
    });
  }

  function updateCharactersUI() {
    if (!characterStatus || !characterGrid || !charactersCount || !charactersRealmCount) {
      return;
    }
    if (!charactersPayload) {
      return;
    }
    const families = Array.isArray(charactersPayload?.families) ? charactersPayload.families : [];
    updateFamilySelectState(families);
    if (!families.length) {
      charactersCount.textContent = '0';
      charactersRealmCount.textContent = '0';
      characterGrid.innerHTML = '';
      const fallbackMessage = charactersPayload?.message || 'Link a retail or classic account to view characters.';
      if (charactersEmptyState) {
        charactersEmptyState.classList.remove('hidden');
        charactersEmptyState.textContent = fallbackMessage;
      }
      characterStatus.textContent = fallbackMessage;
      return;
    }
    let targetFamily = families.find((family) => (family?.family || 'retail') === selectedFamilyKey) || families[0];
    if (targetFamily && (targetFamily.family || 'retail') !== selectedFamilyKey) {
      selectedFamilyKey = targetFamily.family || 'retail';
      persistStoredValue(STORAGE_KEYS.family, selectedFamilyKey);
      if (characterFamilySelect) {
        characterFamilySelect.value = selectedFamilyKey;
      }
    }
    const characters = Array.isArray(targetFamily?.characters) ? targetFamily.characters : [];
    const realms = Array.isArray(targetFamily?.realms) ? targetFamily.realms : [];
    const summary = targetFamily?.summary || {};
    charactersCount.textContent = String(summary.totalCharacters ?? characters.length ?? 0);
    charactersRealmCount.textContent = String(summary.totalRealms ?? realms.length ?? 0);
    const label = formatFamilyLabel(targetFamily?.family || selectedFamilyKey);
    if (targetFamily?.message) {
      characterStatus.textContent = targetFamily.message;
    } else if (characters.length) {
      characterStatus.textContent = `${label} roster loaded.`;
    } else {
      characterStatus.textContent = `No ${label} characters yet. Play a bit and refresh the roster.`;
    }
    if (!characters.length) {
      if (charactersEmptyState) {
        charactersEmptyState.classList.remove('hidden');
        charactersEmptyState.textContent = `No ${label} characters yet.`;
      }
      characterGrid.innerHTML = '';
    } else {
      if (charactersEmptyState) {
        charactersEmptyState.classList.add('hidden');
      }
      characterGrid.innerHTML = characters.map(renderCharacterCard).join('');
    }
  }

  function ensureCharactersLoaded() {
    if (charactersLoaded || charactersLoading) {
      return;
    }
    loadCharacters();
  }

  async function loadCharacters(forceRefresh = false) {
    if (!characterStatus) {
      return;
    }
    charactersLoading = true;
    characterStatus.textContent = forceRefresh ? 'Refreshing roster…' : 'Loading roster…';
    const url = forceRefresh ? '/api/characters?refresh=1' : '/api/characters';
    try {
      const res = await fetch(url, { credentials: 'same-origin' });
      if (res.status === 401) {
        window.location.href = '/login';
        return;
      }
      const data = await res.json().catch(() => ({}));
      if (!res.ok) {
        characterStatus.textContent = data?.error ? 'Error: ' + data.error : 'Unable to load characters.';
        if (characterGrid) {
          characterGrid.innerHTML = '';
        }
        if (charactersCount) {
          charactersCount.textContent = '0';
        }
        if (charactersRealmCount) {
          charactersRealmCount.textContent = '0';
        }
        if (charactersEmptyState) {
          charactersEmptyState.classList.remove('hidden');
          charactersEmptyState.textContent = 'Unable to load roster right now.';
        }
        charactersPayload = null;
        charactersLoaded = false;
        return;
      }
      charactersPayload = data;
      charactersLoaded = true;
      updateCharactersUI();
      updateGmAccessUI();
    } catch (err) {
      console.error('Character fetch failed', err);
      characterStatus.textContent = 'Network error while loading characters.';
      if (characterGrid) {
        characterGrid.innerHTML = '';
      }
      if (charactersCount) {
        charactersCount.textContent = '0';
      }
      if (charactersRealmCount) {
        charactersRealmCount.textContent = '0';
      }
      if (charactersEmptyState) {
        charactersEmptyState.classList.remove('hidden');
        charactersEmptyState.textContent = 'Network error while loading characters.';
      }
      charactersLoaded = false;
    } finally {
      charactersLoading = false;
    }
  }

  function gmRealmSelectLabel(realm) {
    if (realm === 'classic') return 'DreamCore Classic';
    if (realm === 'retail') return 'DreamCore Retail';
    return `${realmLabel(realm)} GM`;
  }

  function updateGmRealmOptions(realms) {
    if (!gmRealmSelect) return;
    const available = Array.isArray(realms) ? realms : [];
    gmRealmSelect.innerHTML = '';
    if (!available.length) {
      const option = document.createElement('option');
      option.value = '';
      option.textContent = 'GM access required';
      gmRealmSelect.appendChild(option);
      gmRealmSelect.disabled = true;
      if (gmCommandMsg) {
        gmCommandMsg.textContent = 'GM access is required to send SOAP commands.';
      }
      gmCommandReferenceRealm = null;
      gmCommandReference = [];
      gmCommandReferenceError = null;
      gmCommandReferenceLoading = false;
      renderGmCommandReferenceList();
      return;
    }
    gmRealmSelect.disabled = available.length === 1;
    const preferredRealm = available.includes('classic') ? 'classic' : available[0];
    available.forEach((realm) => {
      const option = document.createElement('option');
      option.value = realm;
      option.textContent = gmRealmSelectLabel(realm);
      option.selected = realm === preferredRealm;
      gmRealmSelect.appendChild(option);
    });
    gmRealmSelect.value = preferredRealm;
    if (gmCommandMsg) {
      gmCommandMsg.textContent = 'Enter a command and send it to the selected realm.';
    }
    const selectedRealm = gmRealmSelect.value || '';
    syncGmCommandReference(selectedRealm !== gmCommandReferenceRealm);
  }

  function setGmSubmitting(state) {
    if (!gmCommandSubmit) return;
    gmCommandSubmit.disabled = state;
    gmCommandSubmit.classList.toggle('opacity-60', state);
  }

  function updateGmCommandListStatus(message) {
    if (!gmCommandListStatus) return;
    gmCommandListStatus.textContent = message || '';
  }

  function updateGmCommandRealmBadge(realm) {
    if (!gmCommandRealmBadge) return;
    if (!realm) {
      gmCommandRealmBadge.textContent = '—';
      return;
    }
    gmCommandRealmBadge.textContent = `${realmLabel(realm)} GM`;
  }

  function setGmCommandFilterEnabled(enabled) {
    if (!gmCommandFilter) return;
    gmCommandFilter.disabled = !enabled;
    gmCommandFilter.classList.toggle('opacity-60', !enabled);
    if (!enabled) {
      gmCommandFilter.value = '';
      gmCommandFilterValue = '';
    }
  }

  function formatCommandHelpPreview(helpText) {
    if (!helpText) {
      return 'No help description available for this command.';
    }
    const normalized = String(helpText || '').replace(/\s+/g, ' ').trim();
    if (normalized.length <= 160) {
      return normalized;
    }
    return `${normalized.slice(0, 157)}…`;
  }

  function buildCommandEntryHtml(entry) {
    const rawName = typeof entry?.name === 'string' ? entry.name.trim() : String(entry?.name || '').trim();
    const name = rawName ? `.${rawName}` : 'Command';
    const help = entry?.help || 'No help description available for this command.';
    const preview = formatCommandHelpPreview(help);
    return `
      <article class="rounded-2xl border border-white/10 bg-gray-900/60 p-4" title="${escapeAttribute(help)}">
        <div class="flex items-center justify-between gap-3">
          <code class="text-sm font-semibold text-indigo-100">${escapeHtml(name)}</code>
          <span class="text-[11px] font-semibold uppercase tracking-[0.35em] text-indigo-200/70">Hover for help</span>
        </div>
        <p class="mt-2 text-xs text-indigo-200/80">${escapeHtml(preview)}</p>
      </article>
    `;
  }

  function getFilteredGmCommands() {
    if (!Array.isArray(gmCommandReference)) {
      return [];
    }
    if (!gmCommandFilterValue) {
      return gmCommandReference;
    }
    const query = gmCommandFilterValue.toLowerCase();
    return gmCommandReference.filter((entry) => {
      const name = String(entry?.name || '').toLowerCase();
      const help = String(entry?.help || '').toLowerCase();
      return name.includes(query) || help.includes(query);
    });
  }

  function renderGmCommandReferenceList() {
    if (!gmCommandList) {
      return;
    }
    updateGmCommandRealmBadge(gmCommandReferenceRealm);
    if (!gmCommandReferenceRealm) {
      setGmCommandFilterEnabled(false);
      updateGmCommandListStatus('GM access required to load commands.');
      gmCommandList.innerHTML = '<p class="text-sm text-indigo-200/70">GM access required.</p>';
      return;
    }
    if (gmCommandReferenceLoading) {
      setGmCommandFilterEnabled(false);
      updateGmCommandListStatus('Loading command reference…');
      gmCommandList.innerHTML = '<p class="text-sm text-indigo-200/70">Loading command reference…</p>';
      return;
    }
    if (gmCommandReferenceError) {
      setGmCommandFilterEnabled(false);
      updateGmCommandListStatus(gmCommandReferenceError);
      gmCommandList.innerHTML = `<p class="text-sm text-rose-200/80">${escapeHtml(gmCommandReferenceError)}</p>`;
      return;
    }
    setGmCommandFilterEnabled(true);
    updateGmCommandListStatus(
      gmCommandReference.length
        ? `Loaded ${gmCommandReference.length} commands for ${realmLabel(gmCommandReferenceRealm)}.`
        : `No commands published for ${realmLabel(gmCommandReferenceRealm)}.`
    );
    const filtered = getFilteredGmCommands();
    if (!filtered.length) {
      if (gmCommandFilterValue) {
        gmCommandList.innerHTML = '<p class="text-sm text-indigo-200/70">No commands match your search.</p>';
      } else {
        gmCommandList.innerHTML = '<p class="text-sm text-indigo-200/70">No commands were returned from the database.</p>';
      }
      return;
    }
    gmCommandList.innerHTML = filtered.map(buildCommandEntryHtml).join('');
  }

  async function loadGmCommandReferenceForRealm(realm, { force = false } = {}) {
    if (!realm) {
      gmCommandReferenceRealm = null;
      gmCommandReference = [];
      gmCommandReferenceError = null;
      gmCommandReferenceLoading = false;
      renderGmCommandReferenceList();
      return;
    }
    if (!force && gmCommandReferenceRealm === realm && gmCommandReference.length) {
      renderGmCommandReferenceList();
      return;
    }
    gmCommandReferenceRealm = realm;
    gmCommandReferenceLoading = true;
    gmCommandReferenceError = null;
    if (gmCommandFilter) {
      gmCommandFilter.value = '';
    }
    gmCommandFilterValue = '';
    renderGmCommandReferenceList();
    try {
      const url = `${gmCommandListEndpoint}?realm=${encodeURIComponent(realm)}`;
      const res = await fetch(url, { credentials: 'same-origin' });
      const data = await res.json().catch(() => ({}));
      if (!res.ok) {
        throw new Error(data?.error || 'Unable to load command reference.');
      }
      gmCommandReference = Array.isArray(data?.commands) ? data.commands : [];
      gmCommandReferenceError = null;
    } catch (err) {
      console.error('GM command reference lookup failed', err);
      gmCommandReference = [];
      gmCommandReferenceError = err?.message || 'Unable to load command reference.';
    } finally {
      gmCommandReferenceLoading = false;
      renderGmCommandReferenceList();
    }
  }

  function syncGmCommandReference(force = false) {
    if (!gmRealmSelect) {
      return;
    }
    const realm = gmRealmSelect.value || '';
    if (!realm) {
      gmCommandReferenceRealm = null;
      gmCommandReference = [];
      gmCommandReferenceError = null;
      gmCommandReferenceLoading = false;
      renderGmCommandReferenceList();
      return;
    }
    loadGmCommandReferenceForRealm(realm, { force });
  }

  renderGmCommandReferenceList();

  function formatLogMessage(payload) {
    if (payload == null) {
      return 'No response payload.';
    }
    if (typeof payload === 'string') {
      return payload;
    }
    try {
      return JSON.stringify(payload, null, 2);
    } catch (err) {
      return String(payload);
    }
  }

  function appendGmLogEntry({ command, realm, context, ok, message }) {
    if (!gmResponseLog || !command) return;
    if (gmResponseEmpty && gmResponseEmpty.parentElement) {
      gmResponseEmpty.parentElement.removeChild(gmResponseEmpty);
    }
    const entry = document.createElement('article');
    entry.className = 'rounded-2xl border border-white/5 bg-gray-900/80 p-3 space-y-2';
    const header = document.createElement('div');
    header.className = 'flex items-center justify-between text-xs uppercase tracking-[0.3em]';
    const status = document.createElement('span');
    status.className = ok ? 'text-emerald-300' : 'text-rose-300';
    status.textContent = ok ? 'Success' : 'Fault';
    const meta = document.createElement('span');
    meta.className = 'text-indigo-200/80';
    meta.textContent = `${realmLabel(realm)} · ${new Date().toLocaleTimeString()}`;
    header.appendChild(status);
    header.appendChild(meta);
    entry.appendChild(header);

    const commandLine = document.createElement('pre');
    commandLine.className = 'whitespace-pre-wrap text-[13px] font-mono text-indigo-100/90';
    commandLine.textContent = `> ${command}`;
    entry.appendChild(commandLine);

    if (context) {
      const contextLine = document.createElement('p');
      contextLine.className = 'text-xs text-indigo-200/75';
      contextLine.textContent = `Context: ${context}`;
      entry.appendChild(contextLine);
    }

    const body = document.createElement('pre');
    body.className = 'whitespace-pre-wrap text-[13px] text-indigo-100/90';
    body.textContent = message || 'No response body.';
    entry.appendChild(body);

    gmResponseLog.prepend(entry);
    while (gmResponseLog.childElementCount > 20) {
      const last = gmResponseLog.lastElementChild;
      if (!last) break;
      gmResponseLog.removeChild(last);
    }
  }

  function buildClientHealthFallback(branchKey, errorMessage) {
    const label = branchKey === 'classic' ? CONFIG.CLASSIC_BRAND_NAME : CONFIG.BRAND_NAME;
    const displayName =
      branchKey === 'classic'
        ? `${label || 'DreamCore Classic'} (3.3.5)`
        : `${label || 'DreamCore Retail'} (master)`;
    const message = errorMessage || 'Unable to fetch health.';
    return {
      branch: branchKey,
      displayName,
      status: 'unknown',
      lastUpdated: new Date().toISOString(),
      services: {
        auth: { status: 'unknown', details: '' },
        world: { status: 'unknown', details: '' },
        soap: { status: 'offline', details: `Failed to load health: ${message}` },
        db: { status: 'unknown', details: '' },
      },
      metrics: {
        uptimeSeconds: null,
        onlinePlayers: null,
        maxOnline: null,
        worldUpdateMs: null,
        factionOnline: { alliance: null, horde: null },
      },
      history: {
        lastRestartAt: null,
        avgSessionSeconds: null,
        recordOnline: null,
      },
      errors: [`Failed to fetch health: ${message}`],
    };
  }

  async function fetchHealth(branchKey) {
    try {
      const resp = await fetch(`/api/health/${branchKey}`, {
        headers: { Accept: 'application/json' },
      });
      if (!resp.ok) {
        throw new Error(`HTTP ${resp.status}`);
      }
      return await resp.json();
    } catch (err) {
      console.error('Failed to load health', branchKey, err);
      return buildClientHealthFallback(branchKey, err?.message || String(err));
    }
  }

  async function loadHealthStatuses() {
    const [classicHealth, retailHealth] = await Promise.all([
      fetchHealth('classic'),
      fetchHealth('retail'),
    ]);
    renderBranchHealth('classic', classicHealth);
    renderBranchHealth('retail', retailHealth);
  }

  function ensureHealthLoaded() {
    if (healthLoaded) return;
    healthLoaded = true;
    loadHealthStatuses();
  }

  async function loadClassicOnlineSnapshot() {
    if (!gmClassicOnlineEndpoint || !gmClassicAccessible) {
      return;
    }
    if (classicOnlineStatus) {
      classicOnlineStatus.textContent = 'Refreshing…';
    }
    try {
      const res = await fetch(gmClassicOnlineEndpoint, { credentials: 'same-origin' });
      const data = await res.json().catch(() => ({}));
      if (!res.ok) {
        throw new Error(data?.error || 'Unable to load roster.');
      }
      const online = Array.isArray(data?.characters)
        ? data.characters
        : Array.isArray(data?.online)
          ? data.online
          : [];
      renderClassicOnlineList(online);
      if (classicOnlineStatus) {
        const total = typeof data?.count === 'number' ? data.count : online.length;
        classicOnlineStatus.textContent = `${total} online`;
      }
      if (classicOnlineUpdated) {
        const refreshedAt = data?.refreshedAtIso || data?.refreshedAt || Date.now();
        classicOnlineUpdated.textContent = new Date(refreshedAt).toLocaleTimeString();
      }
    } catch (err) {
      console.error('Classic online fetch failed', err);
      if (classicOnlineStatus) {
        classicOnlineStatus.textContent = 'Unable to load online characters.';
      }
      if (classicOnlineList && !classicOnlineList.childElementCount) {
        setClassicOnlinePlaceholder('Unable to load roster right now.');
      }
    }
  }

  function syncClassicOnlinePolling() {
    const shouldPoll =
      gmClassicAccessible &&
      activeTabId === 'gmToolkitSection' &&
      classicOnlineList &&
      gmClassicOnlineEndpoint;
    if (shouldPoll && classicOnlineTimer == null) {
      loadClassicOnlineSnapshot();
      classicOnlineTimer = window.setInterval(loadClassicOnlineSnapshot, gmOnlinePollMs);
    } else if (!shouldPoll && classicOnlineTimer != null) {
      window.clearInterval(classicOnlineTimer);
      classicOnlineTimer = null;
    }
  }

  const gmSubTabActiveClasses = [
    'from-violet-600',
    'via-purple-600',
    'to-indigo-600',
    'text-white',
    'border-violet-200/70',
    'shadow-violet-900/40',
  ];
  const gmSubTabInactiveClasses = [
    'from-black',
    'via-gray-950',
    'to-violet-950',
    'text-indigo-200/80',
    'border-violet-900/60',
    'shadow-violet-900/20',
  ];

  function setActiveGmSubTab(targetId) {
    if (!gmSubTabPanels.length || !gmSubTabButtons.length) return;
    const fallbackPanel = gmSubTabPanels[0];
    const nextPanel = (targetId && document.getElementById(targetId)) || fallbackPanel;
    if (!nextPanel) return;
    gmSubTabPanels.forEach((panel) => {
      panel.classList.toggle('hidden', panel.id !== nextPanel.id);
    });
    gmSubTabButtons.forEach((button) => {
      const matches = button.getAttribute('data-sub-tab-target') === nextPanel.id;
      button.setAttribute('aria-selected', matches ? 'true' : 'false');
      button.classList.remove(...gmSubTabActiveClasses, ...gmSubTabInactiveClasses);
      button.classList.add(...(matches ? gmSubTabActiveClasses : gmSubTabInactiveClasses));
    });
    persistStoredValue(STORAGE_KEYS.gmSubtab, nextPanel.id);
  }

  function setActiveTab(targetId) {
    if (!targetId) return;
    const nextPanel = document.getElementById(targetId);
    if (!nextPanel) return;
    activeTabId = targetId;
    persistStoredValue(STORAGE_KEYS.tab, targetId);
    tabPanels.forEach((panel) => {
      panel.classList.toggle('hidden', panel.id !== targetId);
    });
    tabButtons.forEach((button) => {
      const matches = button.getAttribute('data-tab-target') === targetId;
      button.setAttribute('aria-selected', matches ? 'true' : 'false');
      button.classList.toggle('bg-gradient-to-r', matches);
      button.classList.toggle('from-indigo-500', matches);
      button.classList.toggle('via-purple-500', matches);
      button.classList.toggle('to-blue-500', matches);
      button.classList.toggle('text-gray-900', matches);
      button.classList.toggle('text-indigo-100', matches);
      button.classList.toggle('border-transparent', matches);
      button.classList.toggle('bg-gray-900/60', !matches);
      button.classList.toggle('text-indigo-100/70', !matches);
      button.classList.toggle('border-white/10', !matches);
    });
    if (targetId === 'gmToolkitSection') {
      ensureHealthLoaded();
    }
    if (classicOnlineStatus && gmClassicAccessible) {
      classicOnlineStatus.textContent =
        targetId === 'gmToolkitSection'
          ? 'Refreshing…'
          : 'Open the GM tab to load the roster.';
    }
    if (targetId === 'charactersTabPanel') {
      ensureCharactersLoaded();
    }
    syncClassicOnlinePolling();
  }

  function updateGmAccessUI() {
    const gmAccess = normalizeGmPayload(currentSession?.gmAccess);
    const retailMax = Number(gmAccess.retail?.maxLevel) || 0;
    const classicMax = Number(gmAccess.classic?.maxLevel) || 0;
    const gmSessionFlag = Boolean(charactersPayload?.isGm);
    const gmAccountFlags =
      charactersPayload && typeof charactersPayload === 'object'
        ? charactersPayload.gmAccounts || {}
        : {};
    const gmRetailFromRoster = Object.values(gmAccountFlags?.retail || {}).some((entry) => {
      const level =
        Number(
          entry?.gmlevel ??
            entry?.gmLevel ??
            entry?.GMLevel ??
            entry?.securitylevel ??
            entry?.SecurityLevel
        ) || 0;
      return level > 0;
    });
    const gmClassicFromRoster = Object.values(gmAccountFlags?.classic || {}).some((entry) => {
      const level =
        Number(
          entry?.gmlevel ??
            entry?.gmLevel ??
            entry?.GMLevel ??
            entry?.securitylevel ??
            entry?.SecurityLevel
        ) || 0;
      return level > 0;
    });
    gmRetailAccessible = retailMax > 0 || gmRetailFromRoster || gmSessionFlag;
    gmClassicAccessible = classicMax > 0 || gmClassicFromRoster || gmSessionFlag;
    const hasGm = gmSessionFlag || gmRetailAccessible || gmClassicAccessible;
    const realms = [];
    if (gmRetailAccessible) realms.push('retail');
    if (gmClassicAccessible) realms.push('classic');

    if (gmTabButton) {
      gmTabButton.classList.toggle('hidden', !hasGm);
      gmTabButton.setAttribute('aria-hidden', hasGm ? 'false' : 'true');
    }
    if (!hasGm && activeTabId === 'gmToolkitSection') {
      setActiveTab('accountTabPanel');
    }

    updateGmRealmOptions(realms);

    if (!gmClassicAccessible) {
      if (classicOnlineUpdated) classicOnlineUpdated.textContent = '—';
      if (classicOnlineStatus) classicOnlineStatus.textContent = 'Classic GM access required.';
      setClassicOnlinePlaceholder('Classic GM access required.');
    } else if (classicOnlineStatus && activeTabId !== 'gmToolkitSection') {
      classicOnlineStatus.textContent = 'Open the GM tab to load the roster.';
      setClassicOnlinePlaceholder('Open the GM tab to load the roster.');
    }

    if (gmClassicAccessible && activeTabId === 'gmToolkitSection') {
      ensureArmorSearchLoaded();
    }

    syncWeaponFactoryState();
    syncClassicOnlinePolling();
  }

  gmSubTabButtons.forEach((button) => {
    button.addEventListener('click', () => {
      const targetId = button.getAttribute('data-sub-tab-target');
      if (targetId) {
        setActiveGmSubTab(targetId);
        if (targetId === 'gmArmoryPanel') {
          ensureArmorSearchLoaded();
        }
      }
    });
  });

  tabButtons.forEach((button) => {
    button.addEventListener('click', () => {
      if (button.classList.contains('hidden')) return;
      const targetId = button.getAttribute('data-tab-target');
      if (targetId) {
        setActiveTab(targetId);
      }
    });
  });

  setActiveGmSubTab(readStoredValue(STORAGE_KEYS.gmSubtab) || 'gmServerPanel');
  setActiveTab(activeTabId);
  ensureHealthLoaded();
  syncWeaponFactoryState();
  if (activeTabId === 'gmToolkitSection') {
    ensureArmorSearchLoaded();
  }

  characterFamilySelect?.addEventListener('change', (event) => {
    const value = event.target?.value || 'retail';
    selectedFamilyKey = value;
    persistStoredValue(STORAGE_KEYS.family, selectedFamilyKey);
    updateCharactersUI();
  });

  gmRealmSelect?.addEventListener('change', () => {
    syncGmCommandReference(true);
  });

  gmCommandFilter?.addEventListener('input', (event) => {
    gmCommandFilterValue = (event.target?.value || '').trim().toLowerCase();
    renderGmCommandReferenceList();
  });

  characterRefreshButton?.addEventListener('click', (event) => {
    event.preventDefault();
    loadCharacters(true);
  });

  function deriveClassicUsername() {
    if (classicLinkUsername && classicLinkUsername.value.trim()) {
      return classicLinkUsername.value.trim();
    }
    const base = currentSession?.username || (currentSession?.email || '').split('@')[0] || '';
    return base.trim();
  }

  function updateLinkingUI() {
    const retailIds = Array.isArray(currentSession?.retailAccountIds) ? currentSession.retailAccountIds : [];
    const classicIds = Array.isArray(currentSession?.classicAccountIds) ? currentSession.classicAccountIds : [];
    const hasRetail = retailIds.length > 0;
    const hasClassic = classicIds.length > 0;

    if (profileEmail && currentSession?.email) {
      profileEmail.textContent = currentSession.email;
    }
    if (accountRetailLogin) {
      accountRetailLogin.textContent = currentSession?.email || '—';
    }
    if (accountRetailStatus) {
      accountRetailStatus.textContent = hasRetail ? 'Ready to play' : 'Link required';
    }
    if (accountClassicLogin) {
      if (hasClassic && currentSession?.username) {
        accountClassicLogin.textContent = currentSession.username;
      } else {
        accountClassicLogin.textContent = deriveClassicUsername() || 'Pick a username';
      }
    }
    if (accountClassicStatus) {
      accountClassicStatus.textContent = hasClassic ? 'Ready to play' : 'Link required';
    }

    if (retailStatusText) {
      retailStatusText.textContent = hasRetail ? 'Ready to play' : 'Link required';
    }
    if (classicStatusText) {
      classicStatusText.textContent = hasClassic ? 'Ready to play' : 'Link required';
    }

    if (retailLinkForm) {
      retailLinkForm.classList.toggle('hidden', hasRetail);
    }
    if (retailLinkedSummary) {
      retailLinkedSummary.classList.toggle('hidden', !hasRetail);
    }
    if (retailGuideButton) {
      retailGuideButton.classList.toggle('hidden', !hasRetail);
    }
    if (classicLinkForm) {
      classicLinkForm.classList.toggle('hidden', hasClassic);
    }
    if (classicLinkedSummary) {
      classicLinkedSummary.classList.toggle('hidden', !hasClassic);
    }
    if (classicDownloadButton) {
      classicDownloadButton.classList.toggle('hidden', !hasClassic);
    }
    if (classicLinkUsername && !classicLinkUsername.value.trim() && currentSession) {
      classicLinkUsername.value = deriveClassicUsername();
    }
  }

  async function refreshSession() {
    const res = await fetch('/api/session', { credentials: 'same-origin' });
    if (res.status === 401) {
      window.location.href = '/login';
      return;
    }
    const data = await res.json().catch(() => ({}));
    const sessionData = data?.session || null;
    if (sessionData) {
      sessionData.gmAccess = normalizeGmPayload(sessionData.gmAccess);
    }
    currentSession = sessionData;
    if (emailInput && currentSession?.email) {
      emailInput.value = currentSession.email;
    }
    updateLinkingUI();
    updateGmAccessUI();
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
    if (newPassword.length < MIN_PASS) {
      msg.textContent = `Password must be at least ${MIN_PASS} characters.`;
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

  retailLinkForm?.addEventListener('submit', async (event) => {
    event.preventDefault();
    const passwordValue = retailLinkPassword?.value || '';
    if (!passwordValue) {
      retailLinkMsg.textContent = 'Enter a password to continue.';
      return;
    }
    retailLinkMsg.textContent = 'Provisioning retail login…';
    setLinkLoading(retailLinkSubmit, true);
    try {
      const res = await fetch('/api/account/link/retail', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'same-origin',
        body: JSON.stringify({ password: passwordValue }),
      });
      const data = await res.json().catch(() => ({}));
      if (!res.ok) {
        retailLinkMsg.textContent = data?.error ? 'Error: ' + data.error : 'Unable to link retail login.';
        return;
      }
      retailLinkMsg.textContent = `${LIMITS.brandName || 'Retail'} login created! Password synced with your portal.`;
      if (retailLinkPassword) {
        retailLinkPassword.value = '';
      }
      await refreshSession();
      if (charactersLoaded) {
        await loadCharacters(true);
      }
    } catch (err) {
      console.error('Retail link failed', err);
      retailLinkMsg.textContent = 'Network error while linking retail login.';
    } finally {
      setLinkLoading(retailLinkSubmit, false);
    }
  });

  classicLinkForm?.addEventListener('submit', async (event) => {
    event.preventDefault();
    const usernameValue = classicLinkUsername?.value.trim() || '';
    const passwordValue = classicLinkPassword?.value || '';
    if (!usernameValue) {
      classicLinkMsg.textContent = 'Enter a Classic username to continue.';
      return;
    }
    if (!passwordValue) {
      classicLinkMsg.textContent = 'Enter a password to continue.';
      return;
    }
    classicLinkMsg.textContent = 'Provisioning Classic login…';
    setLinkLoading(classicLinkSubmit, true);
    try {
      const res = await fetch('/api/account/link/classic', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'same-origin',
        body: JSON.stringify({ username: usernameValue, password: passwordValue }),
      });
      const data = await res.json().catch(() => ({}));
      if (!res.ok) {
        classicLinkMsg.textContent = data?.error ? 'Error: ' + data.error : 'Unable to link Classic login.';
        return;
      }
      classicLinkMsg.textContent = `${LIMITS.classicBrandName || 'Classic'} login created! Password synced across the portal.`;
      if (classicLinkPassword) {
        classicLinkPassword.value = '';
      }
      await refreshSession();
      if (charactersLoaded) {
        await loadCharacters(true);
      }
    } catch (err) {
      console.error('Classic link failed', err);
      classicLinkMsg.textContent = 'Network error while linking Classic login.';
    } finally {
      setLinkLoading(classicLinkSubmit, false);
    }
  });

  weaponSearchForm?.addEventListener('submit', (event) => {
    event.preventDefault();
    runWeaponSearch(1);
  });

  armorSearchForm?.addEventListener('submit', (event) => {
    event.preventDefault();
    loadArmorSearch(true);
  });

  weaponSearchResults?.addEventListener('click', (event) => {
    const target = event?.target;
    if (!(target instanceof Element)) {
      return;
    }
    const button = target.closest('[data-weapon-entry]');
    if (!button) {
      return;
    }
    const entry = Number(button.getAttribute('data-weapon-entry'));
    if (!Number.isFinite(entry) || entry <= 0) {
      return;
    }
    loadWeaponDetails(entry);
  });

  weaponCloneForm?.addEventListener('submit', handleWeaponClone);
  armorCloneForm?.addEventListener('submit', handleArmorClone);

  gmCommandForm?.addEventListener('submit', async (event) => {
    event.preventDefault();
    const command = gmCommandInput?.value.trim() || '';
    const realm = gmRealmSelect?.value || '';
    const context = gmCommandContext?.value.trim() || '';
    if (!realm) {
      if (gmCommandMsg) gmCommandMsg.textContent = 'Select a realm to send the command to.';
      return;
    }
    if (!command) {
      if (gmCommandMsg) gmCommandMsg.textContent = 'Enter a SOAP command to send.';
      return;
    }
    if (gmCommandMsg) {
      gmCommandMsg.textContent = `Sending command to ${realmLabel(realm)}…`;
    }
    setGmSubmitting(true);
    try {
      const res = await fetch(gmCommandEndpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'same-origin',
        body: JSON.stringify({
          command,
          realm,
          context: context || undefined,
        }),
      });
      const data = await res.json().catch(() => ({}));
      if (!res.ok) {
        const errorMessage = data?.error || 'Unable to run command.';
        if (gmCommandMsg) gmCommandMsg.textContent = 'Error: ' + errorMessage;
        appendGmLogEntry({ command, realm, context, ok: false, message: errorMessage });
        return;
      }
      const payload = data?.response || data?.result || data?.ret || data;
      const formatted = formatLogMessage(payload);
      if (gmCommandMsg) gmCommandMsg.textContent = 'Command executed successfully.';
      appendGmLogEntry({ command, realm, context, ok: true, message: formatted });
      if (gmCommandInput) {
        gmCommandInput.value = '';
      }
    } catch (err) {
      console.error('GM command failed', err);
      if (gmCommandMsg) gmCommandMsg.textContent = 'Network error while sending command.';
      appendGmLogEntry({ command, realm, context, ok: false, message: 'Network error. Please try again.' });
    } finally {
      setGmSubmitting(false);
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

  refreshSession().catch((err) => {
    console.error('Session lookup failed', err);
    window.location.href = '/login';
  });
};
const ACCOUNT_JS = `(() => {
  const run = ${accountScript.toString()};
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', run, { once: true });
  } else {
    run();
  }
})();`;

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
      background:
        radial-gradient(circle at 20% 20%, rgba(88, 28, 135, 0.35), rgba(0, 0, 0, 0)),
        linear-gradient(160deg, #010101 0%, #04000f 45%, #160027 100%);
      background-color: #010005;
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
${SHARED_STYLES}
  </style>
</head>
<body class="corner-logo-offset min-h-screen text-gray-100 flex items-center justify-center p-6 aurora relative overflow-x-hidden">
  <div class="corner-logo text-2xl sm:text-3xl font-semibold tracking-[0.3em] text-indigo-300 drop-shadow-lg uppercase">${CONFIG.CORNER_LOGO}</div>
  <div class="w-full max-w-xl relative z-10">
    <div class="bg-gray-900/80 backdrop-blur-xl rounded-3xl shadow-2xl gradient-border overflow-hidden">
      <div class="px-6 pt-8 pb-10 sm:px-10">
        <div class="flex items-baseline justify-between">
          <h1 class="text-4xl font-semibold tracking-tight text-white">Reset your password</h1>
          <span class="text-xs font-medium uppercase tracking-[0.4em] text-indigo-400">Security</span>
        </div>
        <p class="mt-3 text-[15px] text-gray-100 drop-shadow-sm">Request a reset link or set a new password for your <span class="font-semibold text-indigo-400 drop-shadow">${CONFIG.BRAND_NAME}</span> account.</p>

        <div class="mt-8 space-y-8">
          <section id="resetRequest" class="hidden rounded-3xl gradient-border bg-gray-900/60 p-6 shadow-inner shadow-indigo-900/30">
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
                       class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-indigo-400" placeholder="you@example.com" />
              </div>
              <button id="requestSubmit" class="w-full py-3.5 rounded-2xl bg-gradient-to-r from-indigo-500 via-purple-500 to-blue-500 hover:from-indigo-400 hover:via-purple-400 hover:to-blue-400 focus:ring-2 focus:ring-indigo-400 active:scale-[0.99] transition font-semibold text-[15px] shadow-lg shadow-indigo-900/50" type="submit">Email me a reset link</button>
            </form>
            <pre id="requestMsg" class="mt-6 text-sm whitespace-pre-wrap text-indigo-100 bg-gray-900/70 gradient-border rounded-2xl p-4 min-h-[3rem] transition"></pre>
            <p class="mt-4 text-xs text-indigo-200/80">Need an account instead? <a class="font-semibold text-indigo-200 hover:text-white" href="/">Start registration</a>.</p>
          </section>

          <section id="resetConfirm" class="hidden rounded-3xl gradient-border bg-gray-900/60 p-6 shadow-inner shadow-indigo-900/30">
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
                       class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-indigo-400" placeholder="••••••••" />
              </div>
              <div>
                <label class="block text-sm font-medium text-indigo-200 mb-1" for="confirmPasswordAgain">Confirm password</label>
                <input id="confirmPasswordAgain" type="password" name="passwordConfirm" required minlength="${CONFIG.MIN_PASS}" maxlength="${CONFIG.MAX_PASS}"
                       class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-indigo-400" placeholder="Repeat password" />
              </div>
              <button id="confirmSubmit" class="w-full py-3.5 rounded-2xl bg-gradient-to-r from-indigo-500 via-purple-500 to-blue-500 hover:from-indigo-400 hover:via-purple-400 hover:to-blue-400 focus:ring-2 focus:ring-indigo-400 active:scale-[0.99] transition font-semibold text-[15px] shadow-lg shadow-indigo-900/50" type="submit">Update password</button>
            </form>
            <pre id="confirmMsg" class="mt-6 text-sm whitespace-pre-wrap text-indigo-100 bg-gray-900/70 gradient-border rounded-2xl p-4 min-h-[3rem] transition"></pre>
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
  ${buildPortalLimitsScriptTag()}
  <script src="/characters.js" defer></script>
  <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
  <style>
    body {
      background:
        radial-gradient(circle at 20% 20%, rgba(88, 28, 135, 0.35), rgba(0, 0, 0, 0)),
        linear-gradient(160deg, #010101 0%, #04000f 45%, #160027 100%);
      background-color: #010005;
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
${SHARED_STYLES}
  </style>
</head>
<body class="corner-logo-offset min-h-screen text-gray-100 flex items-center justify-center p-6 aurora relative overflow-x-hidden">
  <div class="corner-logo text-2xl sm:text-3xl font-semibold tracking-[0.3em] text-indigo-300 drop-shadow-lg uppercase">${CONFIG.CORNER_LOGO}</div>
  <div class="w-full max-w-4xl relative z-10">
    <div class="bg-gray-900/80 backdrop-blur-xl rounded-3xl shadow-2xl gradient-border overflow-hidden">
      <div class="px-6 pt-8 pb-10 sm:px-10">
        <div class="flex flex-col gap-4 md:flex-row md:items-start md:justify-between">
          <div>
            <span class="inline-flex items-center gap-2 rounded-full bg-gradient-to-r from-blue-500 via-purple-500 to-indigo-500 px-4 py-1 text-xs font-semibold uppercase tracking-[0.3em] text-gray-900 shadow-lg shadow-indigo-900/30">Roster</span>
            <h1 class="mt-4 text-4xl font-semibold tracking-tight text-white">My Characters</h1>
            <p class="mt-3 text-[15px] text-indigo-100/90">Welcome back, <span id="sessionEmail" class="font-semibold text-indigo-200">loading…</span>. Here's your latest roster across DreamCore realms.</p>
          </div>
          <div class="flex flex-col gap-3 sm:flex-row sm:items-center">
            <a class="inline-flex items-center justify-center rounded-2xl border border-indigo-400/60 bg-gray-900/70 px-5 py-2.5 text-sm font-semibold text-indigo-100 transition hover:border-indigo-300 hover:text-white hover:bg-indigo-500/20 focus:outline-none focus:ring-2 focus:ring-indigo-400 shadow-lg shadow-indigo-900/40" href="/account">← Back to portal</a>
            <a class="inline-flex items-center justify-center rounded-2xl border border-indigo-400/60 bg-gray-900/70 px-5 py-2.5 text-sm font-semibold text-indigo-100 transition hover:border-indigo-300 hover:text-white hover:bg-indigo-500/20 focus:outline-none focus:ring-2 focus:ring-indigo-400 shadow-lg shadow-indigo-900/40" href="/reset-password">Reset password</a>
            <button id="logoutBtn" class="inline-flex items-center justify-center rounded-2xl bg-gradient-to-r from-indigo-500 via-purple-500 to-blue-500 px-5 py-2.5 text-sm font-semibold text-white shadow-lg shadow-indigo-900/50 transition hover:from-indigo-400 hover:via-purple-400 hover:to-blue-400 focus:ring-2 focus:ring-indigo-400">Log out</button>
          </div>
        </div>
        <div class="mt-6 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
          <div class="text-sm text-indigo-200/90">Total characters: <span id="totalCharacters" class="font-semibold text-indigo-100">0</span> · Realms: <span id="totalRealms" class="font-semibold text-indigo-100">0</span></div>
          <button id="refreshRoster" class="inline-flex items-center justify-center rounded-2xl border border-indigo-400/60 bg-gray-900/70 px-4 py-2 text-sm font-semibold text-indigo-100 transition hover:border-indigo-300 hover:text-white hover:bg-indigo-500/20 focus:outline-none focus:ring-2 focus:ring-indigo-400 shadow-md shadow-indigo-900/30">Refresh roster</button>
        </div>
        <pre id="rosterStatus" class="mt-6 text-sm whitespace-pre-wrap text-indigo-100 bg-gray-900/70 gradient-border rounded-2xl p-4 min-h-[3rem] transition">Loading characters…</pre>
        <div id="familySections" class="mt-6 space-y-6"></div>
        <div id="linkingPanel" class="mt-8 space-y-6 hidden">
          <section id="retailLinkSection" class="rounded-3xl gradient-border bg-gray-900/70 p-5 shadow-inner shadow-indigo-900/30">
            <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
              <div>
                <p class="text-xs font-semibold uppercase tracking-[0.4em] text-indigo-300">DreamCore Master</p>
                <h2 class="text-xl font-semibold text-white">Create your retail login</h2>
                <p class="text-sm text-indigo-200/80">Provision a Battle.net-style account that links back to this portal.</p>
              </div>
            </div>
            <form id="retailLinkForm" class="mt-4 space-y-4">
              <div>
                <label class="block text-sm font-semibold text-indigo-200 mb-1" for="retailLinkPassword">Account password</label>
                <input id="retailLinkPassword" type="password" required minlength="${CONFIG.MIN_PASS}" maxlength="${CONFIG.MAX_PASS}" pattern="[^\s'\"]+" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-indigo-400" placeholder="Choose a secure password" />
                <p class="mt-2 text-xs text-indigo-200/80">We'll sync this password across your portal and retail login.</p>
              </div>
              <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
                <p id="retailLinkMsg" class="text-sm text-indigo-200/90"></p>
                <button id="retailLinkSubmit" class="inline-flex items-center justify-center rounded-2xl bg-gradient-to-r from-indigo-500 via-purple-500 to-blue-500 px-5 py-2.5 text-sm font-semibold text-white shadow-lg shadow-indigo-900/40 transition hover:from-indigo-400 hover:via-purple-400 hover:to-blue-400 focus:ring-2 focus:ring-indigo-400" type="submit">Create retail login</button>
              </div>
            </form>
          </section>
          <section id="classicLinkSection" class="rounded-3xl gradient-border bg-gray-900/70 p-5 shadow-inner shadow-rose-900/30">
            <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
              <div>
                <p class="text-xs font-semibold uppercase tracking-[0.4em] text-rose-300">DreamCore Classic</p>
                <h2 class="text-xl font-semibold text-white">Add a Classic realm account</h2>
                <p class="text-sm text-rose-100/85">Spin up Wrath credentials without leaving this portal.</p>
              </div>
            </div>
            <form id="classicLinkForm" class="mt-4 space-y-4">
              <div>
                <label class="block text-sm font-semibold text-rose-100 mb-1" for="classicLinkUsername">Classic username</label>
                <input id="classicLinkUsername" type="text" required maxlength="${CONFIG.MAX_USER}" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-rose-400" placeholder="Pick an account name" />
              </div>
              <div>
                <label class="block text-sm font-semibold text-rose-100 mb-1" for="classicLinkPassword">Account password</label>
                <input id="classicLinkPassword" type="password" required minlength="${CONFIG.MIN_PASS}" maxlength="${CONFIG.MAX_PASS}" pattern="[^\s'\"]+" class="glow-input w-full rounded-2xl p-3 text-[15px] font-semibold focus:outline-none focus:ring-2 focus:ring-rose-400" placeholder="Choose a secure password" />
                <p class="mt-2 text-xs text-rose-100/80">This password replaces any existing Classic login tied to your portal account.</p>
              </div>
              <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
                <p id="classicLinkMsg" class="text-sm text-rose-100/90"></p>
                <button id="classicLinkSubmit" class="inline-flex items-center justify-center rounded-2xl bg-gradient-to-r from-rose-500 via-pink-500 to-orange-400 px-5 py-2.5 text-sm font-semibold text-gray-900 shadow-lg shadow-rose-900/40 transition hover:scale-[1.01] focus:ring-2 focus:ring-rose-300" type="submit">Create Classic login</button>
              </div>
            </form>
          </section>
        </div>
      </div>
    </div>
    <p class="text-center text-xs text-gray-500 mt-5">Protected by Cloudflare · DreamCore DemiDev Unit 2025 · DreamCore.exe shortcut by Azar</p>
  </div>
</body>
</html>`;

const charactersScript = () => {
  const rosterStatus = document.getElementById('rosterStatus');
  const familySections = document.getElementById('familySections');
  const totalCharacters = document.getElementById('totalCharacters');
  const totalRealms = document.getElementById('totalRealms');
  const sessionEmail = document.getElementById('sessionEmail');
  const refreshButton = document.getElementById('refreshRoster');
  const logoutButton = document.getElementById('logoutBtn');
  const linkingPanel = document.getElementById('linkingPanel');
  const retailLinkSection = document.getElementById('retailLinkSection');
  const classicLinkSection = document.getElementById('classicLinkSection');
  const retailLinkForm = document.getElementById('retailLinkForm');
  const retailLinkPassword = document.getElementById('retailLinkPassword');
  const retailLinkMsg = document.getElementById('retailLinkMsg');
  const retailLinkSubmit = document.getElementById('retailLinkSubmit');
  const classicLinkForm = document.getElementById('classicLinkForm');
  const classicLinkUsername = document.getElementById('classicLinkUsername');
  const classicLinkPassword = document.getElementById('classicLinkPassword');
  const classicLinkMsg = document.getElementById('classicLinkMsg');
  const classicLinkSubmit = document.getElementById('classicLinkSubmit');

  let currentSession = null;

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

  const FAMILY_DEFAULTS = {
    retail: 'DreamCore Master',
    classic: 'DreamCore Classic',
  };
  const portalLimits = window.PORTAL_LIMITS || {};
  const configuredLabels = portalLimits.familyLabels || {};
  const FAMILY_LABELS = {
    retail: configuredLabels.retail || portalLimits.brandName || FAMILY_DEFAULTS.retail,
    classic: configuredLabels.classic || portalLimits.classicBrandName || FAMILY_DEFAULTS.classic,
  };

  function formatFamilyLabel(family) {
    if (!family) return FAMILY_LABELS.retail;
    return FAMILY_LABELS[family] || family.charAt(0).toUpperCase() + family.slice(1);
  }

  function escapeHtml(value) {
    return String(value || '').replace(/[&<>"']/g, (ch) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[ch] || ch));
  }

  function formatDate(value) {
    if (!value) return 'Unknown';
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) return 'Unknown';
    return date.toLocaleString();
  }

  function renderCharacterCard(character) {
    const className = CLASS_NAMES[character.class] || `Class #${character.class}`;
    const raceName = RACE_NAMES[character.race] || `Race #${character.race}`;
    const realmName = character.realm?.name || 'Unknown realm';
    const lastPlayed = formatDate(character.lastLogin);
    return `
      <article class="rounded-3xl gradient-border bg-gray-900/70 p-5 shadow-inner shadow-indigo-900/40">
        <div class="flex items-baseline justify-between">
          <h3 class="text-xl font-semibold text-white">${escapeHtml(character.name)}</h3>
          <span class="text-sm font-semibold text-indigo-300">Lvl ${escapeHtml(character.level)}</span>
        </div>
        <p class="mt-2 text-[15px] text-indigo-100/90">${escapeHtml(raceName)} · ${escapeHtml(className)}</p>
        <p class="mt-2 text-sm text-indigo-200/80">Realm: <span class="font-semibold text-indigo-100">${escapeHtml(realmName)}</span></p>
        <p class="mt-2 text-xs text-indigo-200/70">Last seen: ${escapeHtml(lastPlayed)}</p>
      </article>
    `;
  }

  function renderFamilySection(familyPayload) {
    const familyKey = familyPayload?.family || 'retail';
    const familyLabel = formatFamilyLabel(familyKey);
    const characters = Array.isArray(familyPayload?.characters) ? familyPayload.characters : [];
    const realms = Array.isArray(familyPayload?.realms) ? familyPayload.realms : [];
    const summary = familyPayload?.summary || {};
    const familyMessage = typeof familyPayload?.message === 'string' ? familyPayload.message : '';
    const content = characters.length
      ? `<div class="grid gap-5 sm:grid-cols-2 xl:grid-cols-3">${characters.map(renderCharacterCard).join('')}</div>`
      : `<p class="text-sm text-indigo-200/90">No characters linked to your ${escapeHtml(familyLabel)} accounts yet.</p>`;
    return `
      <section class="rounded-3xl gradient-border bg-gray-900/60 p-5 shadow-inner shadow-indigo-900/30">
        <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
          <div>
            <p class="text-xs font-semibold uppercase tracking-[0.4em] text-indigo-300">${escapeHtml(familyLabel)}</p>
            <h2 class="text-2xl font-semibold text-white">${escapeHtml(familyLabel)} roster</h2>
            ${familyMessage ? `<p class="text-sm text-indigo-200/80">${escapeHtml(familyMessage)}</p>` : ''}
          </div>
          <div class="text-sm text-indigo-200/80">Characters: <span class="font-semibold text-indigo-100">${escapeHtml(summary?.totalCharacters ?? characters.length)}</span> · Realms: <span class="font-semibold text-indigo-100">${escapeHtml(summary?.totalRealms ?? realms.length)}</span></div>
        </div>
        <div class="mt-4">${content}</div>
      </section>
    `;
  }

  function renderCharacters(payload) {
    if (!payload) {
      rosterStatus.textContent = 'Unable to load characters.';
      familySections.innerHTML = '';
      return;
    }

    const families = Array.isArray(payload.families) ? payload.families : [];
    const summary = payload.summary || {};
    totalCharacters.textContent = summary?.totalCharacters ?? 0;
    totalRealms.textContent = summary?.totalRealms ?? 0;

    const hasCharacters = families.some((family) => Array.isArray(family?.characters) && family.characters.length);

    if (payload.message) {
      rosterStatus.textContent = payload.message;
    } else if (hasCharacters) {
      rosterStatus.textContent = 'Roster loaded.';
    } else if (families.length) {
      rosterStatus.textContent = 'No characters found for your linked accounts.';
    } else {
      rosterStatus.textContent = 'Link an account to view characters.';
    }

    if (!families.length) {
      familySections.innerHTML = '<p class="text-sm text-indigo-200/90">Link a retail or classic account to view your roster.</p>';
      return;
    }

    familySections.innerHTML = families.map((family) => renderFamilySection(family)).join('');
  }

  function updateLinkingVisibility() {
    const hasRetail = Array.isArray(currentSession?.retailAccountIds)
      ? currentSession.retailAccountIds.length > 0
      : false;
    const hasClassic = Array.isArray(currentSession?.classicAccountIds)
      ? currentSession.classicAccountIds.length > 0
      : false;
    if (retailLinkSection) {
      retailLinkSection.classList.toggle('hidden', hasRetail);
    }
    if (classicLinkSection) {
      classicLinkSection.classList.toggle('hidden', hasClassic);
    }
    if (linkingPanel) {
      linkingPanel.classList.toggle('hidden', hasRetail && hasClassic);
    }
  }

  function setLinkLoading(button, state) {
    if (!button) return;
    button.disabled = state;
    button.classList.toggle('opacity-60', state);
  }

  function deriveClassicUsername() {
    if (classicLinkUsername && classicLinkUsername.value.trim()) {
      return classicLinkUsername.value.trim();
    }
    const candidate = currentSession?.username || (currentSession?.email || '').split('@')[0] || '';
    return candidate.trim();
  }

  async function refreshSession() {
    const sessionRes = await fetch('/api/session', { credentials: 'same-origin' });
    if (sessionRes.status === 401) {
      window.location.href = '/login';
      throw new Error('Unauthorized');
    }
    const sessionData = await sessionRes.json().catch(() => ({}));
    currentSession = sessionData?.session || null;
    if (sessionEmail && currentSession?.email) {
      sessionEmail.textContent = currentSession.email;
    }
    if (classicLinkUsername && currentSession && !classicLinkUsername.value.trim()) {
      classicLinkUsername.value = deriveClassicUsername();
    }
    updateLinkingVisibility();
  }

  async function initDashboard() {
    try {
      await refreshSession();
      await loadCharacters();
    } catch (err) {
      if (err?.message === 'Unauthorized') {
        return;
      }
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
        familySections.innerHTML = '';
        return;
      }
      renderCharacters(data);
    } catch (err) {
      console.error('Character fetch failed', err);
      rosterStatus.textContent = 'Network error while loading characters.';
      familySections.innerHTML = '';
    }
  }

  retailLinkForm?.addEventListener('submit', async (event) => {
    event.preventDefault();
    const passwordValue = retailLinkPassword?.value || '';
    if (!passwordValue) {
      retailLinkMsg.textContent = 'Enter a password to continue.';
      return;
    }
    retailLinkMsg.textContent = 'Provisioning retail login…';
    setLinkLoading(retailLinkSubmit, true);
    try {
      const res = await fetch('/api/account/link/retail', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'same-origin',
        body: JSON.stringify({ password: passwordValue }),
      });
      const data = await res.json().catch(() => ({}));
      if (!res.ok) {
        retailLinkMsg.textContent = data?.error ? 'Error: ' + data.error : 'Unable to link retail login.';
        return;
      }
      retailLinkMsg.textContent = 'Retail login created! Password updated across your portal.';
      if (retailLinkPassword) {
        retailLinkPassword.value = '';
      }
      await refreshSession();
      await loadCharacters(true);
    } catch (err) {
      console.error('Retail link failed', err);
      retailLinkMsg.textContent = 'Network error while linking retail login.';
    } finally {
      setLinkLoading(retailLinkSubmit, false);
    }
  });

  classicLinkForm?.addEventListener('submit', async (event) => {
    event.preventDefault();
    const usernameValue = classicLinkUsername?.value.trim() || '';
    const passwordValue = classicLinkPassword?.value || '';
    if (!usernameValue) {
      classicLinkMsg.textContent = 'Enter a Classic username to continue.';
      return;
    }
    if (!passwordValue) {
      classicLinkMsg.textContent = 'Enter a password to continue.';
      return;
    }
    classicLinkMsg.textContent = 'Provisioning Classic login…';
    setLinkLoading(classicLinkSubmit, true);
    try {
      const res = await fetch('/api/account/link/classic', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'same-origin',
        body: JSON.stringify({ password: passwordValue, username: usernameValue }),
      });
      const data = await res.json().catch(() => ({}));
      if (!res.ok) {
        classicLinkMsg.textContent = data?.error ? 'Error: ' + data.error : 'Unable to link Classic login.';
        return;
      }
      classicLinkMsg.textContent = 'Classic login created! Password updated across your portal.';
      if (classicLinkPassword) {
        classicLinkPassword.value = '';
      }
      await refreshSession();
      await loadCharacters(true);
    } catch (err) {
      console.error('Classic link failed', err);
      classicLinkMsg.textContent = 'Network error while linking Classic login.';
    } finally {
      setLinkLoading(classicLinkSubmit, false);
    }
  });

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

  initDashboard();
};
const CHARACTERS_JS = `(${charactersScript.toString()})();`;

app.get('/', (req, res) => res.type('html').send(HOME_PAGE()));
app.get('/master', (req, res) => res.type('html').send(REG_PAGE()));
app.get('/classic', (req, res) => res.type('html').send(CLASSIC_PAGE()));
app.get('/client.js', (req, res) => res.type('application/javascript').send(CLIENT_JS));
app.get('/login', async (req, res) => {
  const session = await loadSession(req).catch(() => null);
  if (session) {
    return res.redirect('/account');
  }
  return res.type('text/html').send(LOGIN_PAGE());
});
app.get('/master/login', (req, res) => res.redirect('/login'));
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
class PortalHttpError extends Error {
  constructor(message, statusCode = 400) {
    super(message);
    this.statusCode = statusCode;
  }
}

function normalizeItemTemplateString(column, value) {
  let text = value == null ? '' : String(value);
  if (column !== 'description') {
    text = text.trim();
  }
  const maxLength = ITEM_TEMPLATE_MAX_LENGTHS[column];
  if (typeof maxLength === 'number' && maxLength > 0) {
    return text.slice(0, maxLength);
  }
  return text;
}

function applyItemTemplateOverrides(baseItem, overrides, { entry }) {
  if (!baseItem || typeof baseItem !== 'object') {
    throw new PortalHttpError('Invalid base item.', 400);
  }
  const payload = overrides && typeof overrides === 'object' ? overrides : {};
  const clone = {};
  for (const column of ITEM_TEMPLATE_COLUMNS) {
    clone[column] = baseItem[column];
  }
  clone.entry = entry;
  const overriddenFields = [];

  const overrideName = typeof payload.name === 'string' ? payload.name : '';
  const normalizedName = normalizeItemTemplateString('name', overrideName);
  if (!normalizedName) {
    throw new PortalHttpError('Custom name is required.', 400);
  }
  clone.name = normalizedName;
  if (!Object.is(normalizedName, baseItem.name)) {
    overriddenFields.push('name');
  }

  for (const column of ITEM_TEMPLATE_COLUMNS) {
    if (column === 'entry' || column === 'name') {
      continue;
    }
    if (!Object.prototype.hasOwnProperty.call(payload, column)) {
      continue;
    }
    if (ITEM_TEMPLATE_STRING_FIELDS.has(column)) {
      const textValue = normalizeItemTemplateString(column, payload[column]);
      clone[column] = textValue;
      if (!Object.is(textValue, baseItem[column])) {
        overriddenFields.push(column);
      }
      continue;
    }
    const rawValue = payload[column];
    if (rawValue == null || rawValue === '') {
      continue;
    }
    const numericValue = toSafeNumber(rawValue);
    if (numericValue == null) {
      throw new PortalHttpError(`Invalid numeric value for ${column}.`, 400);
    }
    clone[column] = numericValue;
    if (!Object.is(numericValue, baseItem[column])) {
      overriddenFields.push(column);
    }
  }

  return { clone, overriddenFields };
}

function ensureClassicWeaponCloneValid(item) {
  if (!item || typeof item !== 'object') {
    throw new PortalHttpError('Invalid weapon payload.', 400);
  }
  const classValue = toSafeNumber(item.class);
  const subclassValue = toSafeNumber(item.subclass);
  if (classValue == null || subclassValue == null) {
    throw new PortalHttpError('Weapon class and subclass are required.', 400);
  }
  const requiredNumericFields = ['InventoryType', 'Quality', 'ItemLevel', 'RequiredLevel', 'BuyCount', 'BuyPrice', 'SellPrice'];
  for (const field of requiredNumericFields) {
    if (toSafeNumber(item[field]) == null) {
      throw new PortalHttpError(`Invalid value for ${field}.`, 400);
    }
  }
  for (const [field, bounds] of Object.entries(CLASSIC_WEAPON_FIELD_BOUNDS)) {
    const value = toSafeNumber(item[field]);
    if (value == null) {
      throw new PortalHttpError(`Invalid value for ${field}.`, 400);
    }
    if (bounds.min != null && value < bounds.min) {
      throw new PortalHttpError(`${field} must be at least ${bounds.min}.`, 400);
    }
    if (bounds.max != null && value > bounds.max) {
      throw new PortalHttpError(`${field} must be <= ${bounds.max}.`, 400);
    }
  }
  const dmgMin1 = toSafeNumber(item.dmg_min1) ?? 0;
  const dmgMax1 = toSafeNumber(item.dmg_max1) ?? 0;
  if (dmgMin1 < 0 || dmgMax1 < 0 || dmgMax1 < dmgMin1 || dmgMax1 > CLASSIC_WEAPON_DAMAGE_LIMIT) {
    throw new PortalHttpError('Invalid primary damage values.', 400);
  }
  const dmgMin2 = toSafeNumber(item.dmg_min2) ?? 0;
  const dmgMax2 = toSafeNumber(item.dmg_max2) ?? 0;
  if (dmgMin2 < 0 || dmgMax2 < 0 || dmgMax2 < dmgMin2 || dmgMax2 > CLASSIC_WEAPON_DAMAGE_LIMIT) {
    throw new PortalHttpError('Invalid secondary damage values.', 400);
  }
  const minMoney = toSafeNumber(item.minMoneyLoot) ?? 0;
  const maxMoney = toSafeNumber(item.maxMoneyLoot) ?? 0;
  if (maxMoney < minMoney) {
    throw new PortalHttpError('maxMoneyLoot must be greater than or equal to minMoneyLoot.', 400);
  }
  const statsCount = toSafeNumber(item.StatsCount) ?? 0;
  if (statsCount < 0 || statsCount > 10) {
    throw new PortalHttpError('StatsCount must be between 0 and 10.', 400);
  }
  for (let i = 1; i <= 10; i += 1) {
    const statValue = toSafeNumber(item[`stat_value${i}`]);
    if (statValue != null && Math.abs(statValue) > CLASSIC_WEAPON_STAT_ABS_MAX) {
      throw new PortalHttpError(`stat_value${i} is out of range.`, 400);
    }
  }
}

function ensureClassicArmorCloneValid(item) {
  if (!item || typeof item !== 'object') {
    throw new PortalHttpError('Invalid armor payload.', 400);
  }
  const classValue = toSafeNumber(item.class);
  if (classValue !== 4) {
    throw new PortalHttpError('Only armor templates can be cloned with this tool.', 400);
  }
  const requiredNumericFields = ['InventoryType', 'Quality', 'ItemLevel', 'RequiredLevel', 'Armor'];
  for (const field of requiredNumericFields) {
    if (toSafeNumber(item[field]) == null) {
      throw new PortalHttpError(`Invalid value for ${field}.`, 400);
    }
  }
  const statsCount = toSafeNumber(item.StatsCount) ?? 0;
  if (statsCount < 0 || statsCount > 10) {
    throw new PortalHttpError('StatsCount must be between 0 and 10.', 400);
  }
  for (let i = 1; i <= 10; i += 1) {
    const statValue = toSafeNumber(item[`stat_value${i}`]);
    if (statValue != null && Math.abs(statValue) > CLASSIC_WEAPON_STAT_ABS_MAX) {
      throw new PortalHttpError(`stat_value${i} is out of range.`, 400);
    }
  }
}

async function allocateClassicCustomArmorEntry(connection) {
  const executor = connection || classicWorldPool;
  const [rangeRows] = await executor.execute(
    'SELECT entry FROM item_template WHERE entry BETWEEN ? AND ? ORDER BY entry DESC LIMIT 1 FOR UPDATE',
    [CLASSIC_CUSTOM_ITEM_MIN, CLASSIC_CUSTOM_ITEM_MAX]
  );
  const lastEntry = rangeRows.length ? toSafeNumber(rangeRows[0].entry) : null;
  const newEntry = lastEntry == null ? CLASSIC_CUSTOM_ITEM_MIN : lastEntry + 1;
  if (!Number.isFinite(newEntry) || newEntry > CLASSIC_CUSTOM_ITEM_MAX) {
    throw new PortalHttpError('Custom item range exhausted', 409);
  }
  return newEntry;
}

function escapeHtml(s) {
  return String(s).replace(/[&<>"']/g, c => (
    ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]
  ));
}

function formatClassicClientUsername(value) {
  if (value == null) {
    return '';
  }
  const trimmed = String(value).trim();
  if (!trimmed) {
    return '';
  }
  const [localPart] = trimmed.split('@');
  return localPart || trimmed;
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
        <hr style="border:none;height:1px;background-image:linear-gradient(120deg,#a855f7,#6366f1,#0ea5e9);box-shadow:0 12px 24px rgba(14,165,233,0.35);margin:28px 0;border-radius:999px;">
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

function maskPortalIdentity(value) {
  if (typeof value !== 'string') return 'unknown';
  const trimmed = value.trim();
  if (!trimmed) return 'unknown';
  if (trimmed.includes('@')) {
    return maskEmail(trimmed);
  }
  if (trimmed.length <= 2) {
    return `${trimmed || '*'}***`;
  }
  return `${trimmed.slice(0, 2)}***${trimmed.slice(-1)}`;
}

function normalizePortalUsername(value) {
  if (typeof value !== 'string') return null;
  const trimmed = value.trim();
  if (!trimmed) return null;
  const clipped = trimmed.slice(0, CONFIG.MAX_USER);
  return clipped || null;
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

function normalizeHashValue(value) {
  if (value == null) return null;
  if (typeof value === 'string') {
    return value.trim().toUpperCase();
  }
  try {
    if (Buffer.isBuffer(value)) {
      const ascii = value.toString('utf8');
      return /^[0-9a-fA-F]+$/.test(ascii) ? ascii.toUpperCase() : value.toString('hex').toUpperCase();
    }
  } catch (err) {
    // fall through to generic handler
  }
  try {
    return Buffer.from(value).toString('hex').toUpperCase();
  } catch (err) {
    return String(value).trim().toUpperCase();
  }
}

function normalizeBuffer(value) {
  if (value == null) return null;
  if (Buffer.isBuffer(value)) return value.length ? Buffer.from(value) : null;
  if (value instanceof Uint8Array) return value.length ? Buffer.from(value) : null;
  if (typeof value === 'string') {
    if (!value.length) return null;
    if (/^[0-9a-fA-F]+$/.test(value) && value.length % 2 === 0) {
      return Buffer.from(value, 'hex');
    }
    return Buffer.from(value, 'utf8');
  }
  try {
    const buf = Buffer.from(value);
    return buf.length ? buf : null;
  } catch (err) {
    return null;
  }
}

function legacyAccountHash(username, password) {
  const userUpper = String(username || '').trim().toUpperCase();
  if (!userUpper) return null;
  const passUpper = String(password || '').trim().toUpperCase();
  return crypto.createHash('sha1').update(`${userUpper}:${passUpper}`).digest('hex').toUpperCase();
}

function matchesAccountPassword({ storedHash, salt, verifier, email, username }, password) {
  const normalizedHash = typeof storedHash === 'string' ? storedHash : normalizeHashValue(storedHash);
  const saltBuffer = normalizeBuffer(salt);
  const verifierBuffer = normalizeBuffer(verifier);
  const emailIdentities = [];
  const usernameIdentities = [];

  if (typeof email === 'string' && email.trim()) {
    emailIdentities.push(email.trim());
  }
  if (typeof username === 'string' && username.trim()) {
    usernameIdentities.push(username.trim());
  }

  const attempts = new Set();
  if (typeof password === 'string') {
    attempts.add(password);
    const trimmed = password.trim();
    if (trimmed && trimmed !== password) attempts.add(trimmed);
    const upperPassword = password.toUpperCase();
    if (upperPassword !== password) attempts.add(upperPassword);
  }

  for (const candidate of attempts) {
    for (const identity of emailIdentities) {
      const { sha256, sha1 } = srpHashIdentity(identity, candidate);
      const sha256Hex = upperHex(sha256);
      const sha1Hex = upperHex(sha1);
      if (normalizedHash && (normalizedHash === sha256Hex || normalizedHash === sha1Hex)) {
        return true;
      }
      if (saltBuffer && verifierBuffer) {
        try {
          const derived = deriveVerifier(identity, candidate, saltBuffer);
          if (derived && Buffer.compare(verifierBuffer, derived) === 0) {
            return true;
          }
        } catch (e) {
          console.error('Failed to derive SRP verifier', e);
        }
      }
    }

    if (normalizedHash && usernameIdentities.length) {
      for (const identity of usernameIdentities) {
        const legacy = legacyAccountHash(identity, candidate);
        if (legacy && legacy === normalizedHash) {
          return true;
        }
      }
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

function parseBooleanFlag(value, fallback = false) {
  if (typeof value === 'boolean') {
    return value;
  }
  if (typeof value === 'string') {
    const normalized = value.trim().toLowerCase();
    if (!normalized) return fallback;
    if (['1', 'true', 'yes', 'on'].includes(normalized)) return true;
    if (['0', 'false', 'no', 'off'].includes(normalized)) return false;
    return fallback;
  }
  if (typeof value === 'number') {
    if (!Number.isFinite(value)) return fallback;
    return value !== 0;
  }
  if (value == null) return fallback;
  return Boolean(value);
}

function determineRealmFamily(value) {
  const text = typeof value === 'string' ? value.trim().toLowerCase() : '';
  if (['classic', 'wotlk', '335', '3.3.5'].includes(text)) {
    return 'classic';
  }
  return 'retail';
}

function isSameDbConfig(a, b) {
  if (!a || !b) return false;
  return (
    a.HOST === b.HOST &&
    a.PORT === b.PORT &&
    a.USER === b.USER &&
    a.PASS === b.PASS &&
    a.NAME === b.NAME
  );
}

function loadRealmDbConfigs() {
  const fallbackRetailName = process.env.DEFAULT_REALM_NAME || `${CONFIG.BRAND_NAME || 'DreamCore'} Realm`;
  const fallbackClassicName =
    process.env.CLASSIC_REALM_NAME || `${CONFIG.CLASSIC_BRAND_NAME || 'DreamCore Classic'} Realm`;
  const fallbackEntries = [
    {
      key: 'retail-default',
      realmId: null,
      name: fallbackRetailName,
      host: CHAR_DB.HOST,
      port: CHAR_DB.PORT,
      user: CHAR_DB.USER,
      password: CHAR_DB.PASS,
      database: CHAR_DB.NAME,
      charactersTable: 'characters',
      charDbLabel: CHAR_DB.NAME,
      useDefaultPool: true,
      family: 'retail',
    },
  ];
  const classicDiffers = !isSameDbConfig(CHAR_DB, CLASSIC_CHAR_DB);
  if (classicDiffers) {
    fallbackEntries.push({
      key: 'classic-default',
      realmId: null,
      name: fallbackClassicName,
      host: CLASSIC_CHAR_DB.HOST,
      port: CLASSIC_CHAR_DB.PORT,
      user: CLASSIC_CHAR_DB.USER,
      password: CLASSIC_CHAR_DB.PASS,
      database: CLASSIC_CHAR_DB.NAME,
      charactersTable: 'characters',
      charDbLabel: CLASSIC_CHAR_DB.NAME,
      useDefaultPool:
        CLASSIC_CHAR_DB.HOST === CHAR_DB.HOST &&
        CLASSIC_CHAR_DB.PORT === CHAR_DB.PORT &&
        CLASSIC_CHAR_DB.USER === CHAR_DB.USER &&
        CLASSIC_CHAR_DB.PASS === CHAR_DB.PASS &&
        CLASSIC_CHAR_DB.NAME === CHAR_DB.NAME,
      family: 'classic',
    });
  }
  const raw = process.env.REALM_DATABASES;
  if (!raw) return fallbackEntries;
  try {
    const parsed = JSON.parse(raw);
    if (!Array.isArray(parsed) || !parsed.length) {
      return fallbackEntries;
    }
    const normalized = parsed.map((item, idx) => {
      const useDefaultPool = parseBooleanFlag(
        item.useDefaultPool ??
          item.use_default_pool ??
          item.useDefault ??
          item.use_default ??
          item.useSharedPool ??
          item.use_shared_pool,
        false
      );
      const family = determineRealmFamily(
        item.family ?? item.gameType ?? item.realmType ?? item.branch ?? null
      );
      const cfg = {
        key: String(item.key || item.name || item.realmId || idx),
        realmId: item.realmId ?? item.realmID ?? null,
        name: item.name || (family === 'classic' ? fallbackClassicName : fallbackRetailName),
        host: item.host || CHAR_DB.HOST,
        port: Number(item.port || CHAR_DB.PORT),
        user: item.user || item.username || CHAR_DB.USER,
        password: item.password || item.pass || CHAR_DB.PASS,
        database: item.database || item.db || CHAR_DB.NAME,
        charactersTable: item.charactersTable || item.table || 'characters',
        charDbLabel: item.charDb || item.char_db || null,
        useDefaultPool,
        family,
      };
      if (!Number.isFinite(cfg.port) || cfg.port <= 0) cfg.port = CHAR_DB.PORT;
      if (cfg.charDbLabel == null || cfg.charDbLabel === '') {
        cfg.charDbLabel = cfg.database;
      }
      return cfg;
    });
    const seenFamilies = new Set(normalized.map((cfg) => cfg.family));
    for (const fallback of fallbackEntries) {
      if (!seenFamilies.has(fallback.family)) {
        normalized.push(fallback);
        seenFamilies.add(fallback.family);
      }
    }
    return normalized;
  } catch (err) {
    console.warn('Failed to parse REALM_DATABASES', err?.message || err);
    return fallbackEntries;
  }
}

function buildRealmPoolEntries(configs) {
  return configs.map((cfg, idx) => {
    const key = cfg.key || `realm-${idx}`;
    const family = cfg.family === 'classic' ? 'classic' : 'retail';
    const reuseDefault =
      cfg.useDefaultPool === true ||
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
        family,
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

function getRealmEntriesForFamily(family) {
  if (family === 'classic') {
    return REALM_FAMILY_MAP.classic.length ? REALM_FAMILY_MAP.classic : REALM_POOL_ENTRIES;
  }
  return REALM_FAMILY_MAP.retail.length ? REALM_FAMILY_MAP.retail : REALM_POOL_ENTRIES;
}

function resolveRealmEntry({ realmId, realmCharDb }, lookup = REALM_LOOKUP) {
  const activeLookup = lookup || REALM_LOOKUP;
  const numericRealmId = toSafeNumber(realmId);
  if (numericRealmId != null && activeLookup.byId?.has(numericRealmId)) {
    return activeLookup.byId.get(numericRealmId);
  }
  if (realmCharDb) {
    const key = String(realmCharDb).toLowerCase();
    const byCharDb = activeLookup.byCharDb?.get(key);
    if (byCharDb) return byCharDb;
  }
  return activeLookup.default || null;
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

function buildRealmDirectoryFromConfig(family = null) {
  const configs = Array.isArray(REALM_DB_CONFIGS) ? REALM_DB_CONFIGS : [];
  return configs
    .filter((cfg) => {
      if (family === 'classic') return cfg.family === 'classic';
      if (family === 'retail') return cfg.family !== 'classic';
      return true;
    })
    .map((cfg) => ({
      id: toSafeNumber(cfg.realmId),
      name: cfg.name || null,
      charDb: cfg.charDbLabel || cfg.database || null,
    }));
}

function defaultRealmIdForFamily(family) {
  const entries = family === 'classic' ? REALM_FAMILY_MAP.classic : REALM_FAMILY_MAP.retail;
  const primary = entries.find((entry) => toSafeNumber(entry?.config?.realmId) != null);
  if (primary) {
    const parsed = toSafeNumber(primary.config.realmId);
    if (parsed != null) return parsed;
  }
  const fallback = family === 'classic' ? CLASSIC_REALM_LOOKUP?.default : REALM_LOOKUP?.default;
  const parsedFallback = toSafeNumber(fallback?.config?.realmId ?? fallback?.id);
  return parsedFallback;
}

function getBranchConfig(branchKey) {
  const normalized = typeof branchKey === 'string' ? branchKey.trim().toLowerCase() : '';
  if (normalized === 'classic') {
    return {
      key: 'classic',
      displayName: `${CONFIG.CLASSIC_BRAND_NAME || 'DreamCore Classic'} (3.3.5)`,
      realmId: defaultRealmIdForFamily('classic'),
      dbAuthPool: classicAuthPool,
      dbCharsPool: classicCharPool,
      soapProfile: 'classic',
      worldPort: Number(process.env.CLASSIC_WORLD_PORT) || null,
      authPort: Number(process.env.CLASSIC_AUTH_PORT) || null,
    };
  }
  if (normalized === 'retail') {
    return {
      key: 'retail',
      displayName: `${CONFIG.BRAND_NAME || 'DreamCore Retail'} (master)`,
      realmId: defaultRealmIdForFamily('retail'),
      dbAuthPool: authPool,
      dbCharsPool: charPool,
      soapProfile: 'retail',
      worldPort: Number(process.env.TC_WORLD_PORT) || null,
      authPort: Number(process.env.TC_AUTH_PORT) || null,
    };
  }
  return null;
}

function normalizeRealmDirectoryEntries(entries) {
  if (!Array.isArray(entries)) return [];
  return entries.map((entry) => ({
    id: toSafeNumber(entry?.id ?? entry?.realmId ?? entry?.realmID),
    name: entry?.name || null,
    charDb: entry?.charDb || entry?.char_db || entry?.database || null,
  }));
}

function mergeRealmDirectoryRows(rows, fallbackEntries = []) {
  const normalizedFallback = normalizeRealmDirectoryEntries(fallbackEntries);
  if (!Array.isArray(rows) || !rows.length) {
    return normalizedFallback;
  }
  const fallbackById = new Map();
  for (const entry of normalizedFallback) {
    if (entry?.id == null || fallbackById.has(entry.id)) continue;
    fallbackById.set(entry.id, entry);
  }
  const merged = [];
  const seenIds = new Set();
  for (const row of rows) {
    const realmId = toSafeNumber(row?.id);
    const fallback = realmId != null ? fallbackById.get(realmId) : null;
    merged.push({
      id: realmId,
      name: row?.name || fallback?.name || null,
      charDb: fallback?.charDb || null,
    });
    if (realmId != null) {
      seenIds.add(realmId);
    }
  }
  for (const entry of normalizedFallback) {
    if (entry.id != null && seenIds.has(entry.id)) continue;
    merged.push({ ...entry });
  }
  return merged;
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
  const fallbackDirectory = buildRealmDirectoryFromConfig();
  try {
    const [rows] = await authPool.query('SELECT id, name FROM `realmlist`');
    REALM_DIRECTORY_CACHE = mergeRealmDirectoryRows(rows, fallbackDirectory);
  } catch (err) {
    if (err?.code !== 'ER_NO_SUCH_TABLE') {
      console.error('Failed to load realm directory', err);
    }
    REALM_DIRECTORY_CACHE = fallbackDirectory;
  }
  return REALM_DIRECTORY_CACHE;
}

let CLASSIC_REALM_DIRECTORY_CACHE = null;

async function ensureClassicRealmDirectory() {
  if (CLASSIC_REALM_DIRECTORY_CACHE) return CLASSIC_REALM_DIRECTORY_CACHE;
  if (!classicAuthPool) {
    CLASSIC_REALM_DIRECTORY_CACHE = buildRealmDirectoryFromConfig('classic');
    return CLASSIC_REALM_DIRECTORY_CACHE;
  }
  const fallbackDirectory = buildRealmDirectoryFromConfig('classic');
  try {
    const [rows] = await classicAuthPool.query('SELECT id, name FROM `realmlist`');
    CLASSIC_REALM_DIRECTORY_CACHE = mergeRealmDirectoryRows(rows, fallbackDirectory);
  } catch (err) {
    if (err?.code !== 'ER_NO_SUCH_TABLE') {
      console.error('Failed to load classic realm directory', err);
    }
    CLASSIC_REALM_DIRECTORY_CACHE = fallbackDirectory;
  }
  return CLASSIC_REALM_DIRECTORY_CACHE;
}

const LEGACY_BNET_ACCOUNT_COLUMNS = [
  'battlenetAccount',
  'battlenet_account',
  'bnetAccount',
  'bnet_account',
  'bnetaccount',
];

let ACCOUNT_TABLE_COLUMN_INFO = null;

async function ensureAccountTableColumnInfo() {
  if (ACCOUNT_TABLE_COLUMN_INFO) {
    return ACCOUNT_TABLE_COLUMN_INFO;
  }
  const info = { realmColumn: null };
  if (!authPool) {
    ACCOUNT_TABLE_COLUMN_INFO = info;
    return info;
  }
  try {
    const [rows] = await authPool.query('SHOW COLUMNS FROM `account`');
    const lookup = new Map();
    for (const row of rows || []) {
      const raw = row?.Field || row?.field || row?.COLUMN_NAME;
      if (!raw) continue;
      lookup.set(String(raw).toLowerCase(), String(raw));
    }
    const realmCandidates = ['realmid', 'realm_id', 'realmId', 'RealmID'];
    for (const candidate of realmCandidates) {
      const normalized = lookup.get(candidate.toLowerCase());
      if (normalized) {
        info.realmColumn = normalized;
        break;
      }
    }
  } catch (err) {
    if (err?.code !== 'ER_NO_SUCH_TABLE') {
      console.warn('Failed to inspect auth.account columns', err?.message || err);
    }
  }
  ACCOUNT_TABLE_COLUMN_INFO = info;
  return info;
}

async function fetchAccountsViaLegacyLink(bnetAccountId) {
  if (bnetAccountId == null) return [];
  retailCharacterDebug('fetchAccountsViaLegacyLink:start', { bnetAccountId });
  const realms = await ensureRealmDirectory();
  const realmMap = new Map();
  for (const realm of realms) {
    if (realm?.id == null || realmMap.has(realm.id)) continue;
    realmMap.set(realm.id, realm);
  }
  const accountColumns = await ensureAccountTableColumnInfo();
  const realmColumnName = safeIdentifier(accountColumns?.realmColumn, null);
  const realmSelect = realmColumnName ? `\`${realmColumnName}\` AS realmId` : 'NULL AS realmId';
  for (const column of LEGACY_BNET_ACCOUNT_COLUMNS) {
    retailCharacterDebug('fetchAccountsViaLegacyLink:tryColumn', {
      bnetAccountId,
      column,
    });
    let rows;
    try {
      const columnName = safeIdentifier(column, null);
      if (!columnName) {
        retailCharacterDebug('fetchAccountsViaLegacyLink:skipColumn', {
          bnetAccountId,
          column,
          reason: 'invalidColumnName',
        });
        continue;
      }
      [rows] = await authPool.query(
        `SELECT id, username, ${realmSelect} FROM \`account\` WHERE \`${columnName}\` = ?`,
        [bnetAccountId]
      );
    } catch (err) {
      if (err?.code === 'ER_BAD_FIELD_ERROR') {
        retailCharacterDebug('fetchAccountsViaLegacyLink:missingColumn', {
          bnetAccountId,
          column,
        });
        continue;
      }
      if (err?.code === 'ER_NO_SUCH_TABLE') {
        retailCharacterDebug('fetchAccountsViaLegacyLink:missingAccountTable', {
          bnetAccountId,
        });
        return [];
      }
      throw err;
    }
    if (!Array.isArray(rows) || !rows.length) {
      retailCharacterDebug('fetchAccountsViaLegacyLink:noRows', {
        bnetAccountId,
        column,
      });
      continue;
    }
    retailCharacterDebug('fetchAccountsViaLegacyLink:rowsFound', {
      bnetAccountId,
      column,
      rowCount: rows.length,
    });
    return rows
      .map((row) => {
        const realmId = toSafeNumber(row.realmId ?? row.realmID);
        const realmEntry = resolveRealmEntry({ realmId }, REALM_LOOKUP);
        const realmInfo = (realmId != null && realmMap.get(realmId)) || null;
        return {
          gameAccountId: toSafeNumber(row.id),
          username: row.username || null,
          realmId,
          realmName: realmInfo?.name || realmEntry?.config?.name || null,
          realmCharDb: realmEntry?.config?.charDbLabel || realmEntry?.config?.database || null,
        };
      })
      .filter((entry) => entry.gameAccountId != null);
  }
  retailCharacterDebug('fetchAccountsViaLegacyLink:complete', {
    bnetAccountId,
    rowCount: 0,
  });
  return [];
}

async function fetchGameAccountsForBnet(bnetAccountId) {
  if (bnetAccountId == null) return [];
  const accounts = [];
  let missingLinkTable = false;
  let missingGameAccountTable = false;
  retailCharacterDebug('fetchGameAccountsForBnet:start', { bnetAccountId });
  try {
    retailCharacterDebug('fetchGameAccountsForBnet:queryGameAccountLink', {
      bnetAccountId,
    });
    const [rows] = await authPool.query(
      `SELECT link.gameaccountid AS gameAccountId,
              ga.id AS gaId,
              ga.username AS username,
              ga.realmID AS realmId,
              r.name AS realmName
         FROM \`bnetaccount_gameaccount\` AS link
         JOIN \`gameaccount\` AS ga ON ga.id = link.gameaccountid
         LEFT JOIN \`realmlist\` AS r ON r.id = ga.realmID
        WHERE link.bnetaccountid = ?`,
      [bnetAccountId]
    );
    retailCharacterDebug('fetchGameAccountsForBnet:primaryResults', {
      bnetAccountId,
      rowCount: Array.isArray(rows) ? rows.length : 0,
    });
    for (const row of rows) {
      const realmId = toSafeNumber(row.realmId ?? row.realmID);
      const realmEntry = resolveRealmEntry({ realmId }, REALM_LOOKUP);
      accounts.push({
        gameAccountId: toSafeNumber(row.gameAccountId ?? row.gaId ?? row.id),
        username: row.username || null,
        realmId,
        realmName: row.realmName || realmEntry?.config?.name || null,
        realmCharDb: realmEntry?.config?.charDbLabel || realmEntry?.config?.database || null,
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
        retailCharacterDebug('fetchGameAccountsForBnet:missingLinkTable');
      } else {
        missingGameAccountTable = true;
        retailCharacterDebug('fetchGameAccountsForBnet:missingGameAccountTable');
      }
    } else if (err?.code !== 'ER_BAD_FIELD_ERROR') {
      retailCharacterDebug('fetchGameAccountsForBnet:primaryError', {
        error: err?.message || String(err),
      });
      throw err;
    }
  }

  if (!accounts.length && !missingLinkTable) {
    try {
      retailCharacterDebug('fetchGameAccountsForBnet:fallbackAccountJoin', {
        bnetAccountId,
      });
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
      retailCharacterDebug('fetchGameAccountsForBnet:fallbackAccountResults', {
        bnetAccountId,
        rowCount: Array.isArray(rows) ? rows.length : 0,
      });
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
        retailCharacterDebug('fetchGameAccountsForBnet:fallbackMissingAccountTable');
        return accounts;
      }
      if (err?.code !== 'ER_NO_SUCH_TABLE') {
        retailCharacterDebug('fetchGameAccountsForBnet:fallbackError', {
          error: err?.message || String(err),
        });
        throw err;
      }
      retailCharacterDebug('fetchGameAccountsForBnet:fallbackMissingLinkTable');
    }
  }

  if (!accounts.length) {
    retailCharacterDebug('fetchGameAccountsForBnet:legacyFallback', { bnetAccountId });
    const legacyAccounts = await fetchAccountsViaLegacyLink(bnetAccountId);
    accounts.push(...legacyAccounts);
    retailCharacterDebug('fetchGameAccountsForBnet:legacyResults', {
      bnetAccountId,
      rowCount: legacyAccounts.length,
    });
  }

  retailCharacterDebug('fetchGameAccountsForBnet:complete', {
    bnetAccountId,
    accountCount: accounts.length,
  });
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

async function loadBattleNetCharacters(bnetAccountIds) {
  const normalizedIds = Array.isArray(bnetAccountIds)
    ? sanitizeAccountIdList(bnetAccountIds)
    : sanitizeAccountIdList([bnetAccountIds]);
  retailCharacterDebug('loadBattleNetCharacters:start', {
    input: bnetAccountIds,
    normalized: normalizedIds,
  });
  if (!normalizedIds.length) {
    retailCharacterDebug('loadBattleNetCharacters:emptyInput');
    return { characters: [], realms: [] };
  }

  const characters = [];
  const realmMetaMap = new Map();
  const groups = new Map();

  for (const bnetAccountId of normalizedIds) {
    const gameAccounts = await fetchGameAccountsForBnet(bnetAccountId);
    retailCharacterDebug('loadBattleNetCharacters:accountsLoaded', {
      bnetAccountId,
      accountCount: gameAccounts.length,
    });
    for (const account of gameAccounts) {
      const realmEntry = resolveRealmEntry(account, REALM_LOOKUP);
      if (!realmEntry) {
        retailCharacterDebug('loadBattleNetCharacters:missingRealmEntry', {
          account,
        });
        continue;
      }
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
          seen: new Set(),
        };
        groups.set(groupKey, group);
      }
      if (account.gameAccountId != null) {
        const numeric = toSafeNumber(account.gameAccountId);
        if (numeric != null && !group.seen.has(numeric)) {
          group.accountIds.push(numeric);
          group.seen.add(numeric);
        }
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
  }

  if (!groups.size) {
    retailCharacterDebug('loadBattleNetCharacters:noGroups');
    return { characters: [], realms: [] };
  }

  for (const group of groups.values()) {
    if (!group.entry?.pool || !group.accountIds.length) {
      retailCharacterDebug('loadBattleNetCharacters:skipGroup', {
        realmKey: `${group.entry?.key}#${group.realmId ?? 'null'}`,
        hasPool: !!group.entry?.pool,
        accountCount: group.accountIds.length,
      });
      continue;
    }
    const placeholders = group.accountIds.map(() => '?').join(', ');
    const tableName = entryCharactersTable(group.entry);
    try {
      retailCharacterDebug('loadBattleNetCharacters:queryCharacters', {
        realmKey: `${group.entry.key}#${group.realmId ?? 'null'}`,
        tableName,
        accountIds: group.accountIds,
      });
      const [rows] = await group.entry.pool.query(
        `SELECT account, name, level, class, race, logout_time FROM \`${tableName}\` WHERE account IN (${placeholders})`,
        group.accountIds
      );
      retailCharacterDebug('loadBattleNetCharacters:queryResults', {
        realmKey: `${group.entry.key}#${group.realmId ?? 'null'}`,
        rowCount: Array.isArray(rows) ? rows.length : 0,
      });
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
      retailCharacterDebug('loadBattleNetCharacters:queryError', {
        realmKey: `${group.entry.key}#${group.realmId ?? 'null'}`,
        error: err?.message || String(err),
      });
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

  const result = { characters, realms };
  retailCharacterDebug('loadBattleNetCharacters:complete', {
    totalCharacters: characters.length,
    realmCount: realms.length,
  });
  return result;
}

async function fetchClassicAccountMetadata(accountIds) {
  if (!accountIds.length) {
    return new Map();
  }
  const placeholders = accountIds.map(() => '?').join(', ');
  try {
    const [rows] = await classicAuthPool.query(
      `SELECT id, username FROM \`account\` WHERE id IN (${placeholders})`,
      accountIds
    );
    const map = new Map();
    for (const row of rows) {
      const id = toSafeNumber(row.id);
      if (id != null && !map.has(id)) {
        map.set(id, { id, username: row.username || null });
      }
    }
    return map;
  } catch (err) {
    console.error('Failed to load classic account metadata', err);
    return new Map();
  }
}

async function loadClassicCharacters(classicAccountIds) {
  const sanitized = Array.isArray(classicAccountIds)
    ? sanitizeAccountIdList(classicAccountIds)
    : sanitizeAccountIdList([classicAccountIds]);
  const uniqueIds = Array.from(new Set(sanitized));
  if (!uniqueIds.length) {
    return { characters: [], realms: [] };
  }

  const accountMetadata = await fetchClassicAccountMetadata(uniqueIds);
  const characters = [];
  const realmMetaMap = new Map();
  const realmDirectory = await ensureClassicRealmDirectory();
  const realmLookupById = new Map();
  const realmLookupByCharDb = new Map();
  if (Array.isArray(realmDirectory)) {
    for (const realm of realmDirectory) {
      const id = toSafeNumber(realm.id);
      if (id != null && !realmLookupById.has(id)) {
        realmLookupById.set(id, realm);
      }
      if (realm.charDb) {
        const normalizedDb = String(realm.charDb).toLowerCase();
        if (normalizedDb && !realmLookupByCharDb.has(normalizedDb)) {
          realmLookupByCharDb.set(normalizedDb, realm);
        }
      }
    }
  }

  const fallbackRealmName = CONFIG.CLASSIC_BRAND_NAME
    ? `${CONFIG.CLASSIC_BRAND_NAME} Realm`
    : `${CONFIG.BRAND_NAME || 'DreamCore'} Realm`;

  function resolveClassicRealm(entry) {
    if (!entry) return null;
    const entryRealmId = toSafeNumber(entry?.config?.realmId);
    if (entryRealmId != null && realmLookupById.has(entryRealmId)) {
      return realmLookupById.get(entryRealmId);
    }
    const label = typeof entry?.config?.charDbLabel === 'string' ? entry.config.charDbLabel : '';
    if (label) {
      const normalized = label.toLowerCase();
      if (realmLookupByCharDb.has(normalized)) {
        return realmLookupByCharDb.get(normalized);
      }
    }
    const fallbackEntry = resolveRealmEntry({ realmId: entryRealmId, realmCharDb: label }, CLASSIC_REALM_LOOKUP);
    if (fallbackEntry?.config) {
      return {
        id: toSafeNumber(fallbackEntry.config.realmId),
        name: fallbackEntry.config.name || fallbackRealmName,
        charDb: fallbackEntry.config.charDbLabel || null,
      };
    }
    if (entry?.config) {
      return {
        id: entryRealmId,
        name: entry.config.name || fallbackRealmName,
        charDb: label || null,
      };
    }
    return null;
  }

  const classicEntries = getRealmEntriesForFamily('classic');
  for (const entry of classicEntries) {
    if (!entry?.pool) continue;
    const tableName = entryCharactersTable(entry);
    const resolvedRealm = resolveClassicRealm(entry);
    const realmId = toSafeNumber(resolvedRealm?.id ?? entry?.config?.realmId);
    const realmName = resolvedRealm?.name || entry?.config?.name || 'Realm';
    const placeholders = uniqueIds.map(() => '?').join(', ');
    if (!placeholders) continue;
    const realmKey = `${entry.key}#${realmId ?? 'null'}`;
    const ensureRealmMeta = () => {
      let realmMeta = realmMetaMap.get(realmKey);
      if (!realmMeta) {
        realmMeta = {
          id: realmId,
          name: realmName,
          accounts: [],
          hasCharacters: false,
        };
        realmMetaMap.set(realmKey, realmMeta);
      }
      return realmMeta;
    };
    try {
      const [rows] = await entry.pool.query(
        `SELECT account, name, level, class, race, logout_time FROM \`${tableName}\` WHERE account IN (${placeholders})`,
        uniqueIds
      );
      if (!rows.length) continue;
      const realmMeta = ensureRealmMeta();
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
          realm: { id: realmId, name: realmName },
          lastLogin,
        };
        if (accountId != null) {
          character.gameAccountId = accountId;
        }
        characters.push(character);
        realmMeta.hasCharacters = true;
        if (accountId != null) {
          const metadata = accountMetadata.get(accountId);
          realmMeta.accounts.push({
            id: accountId,
            username: metadata?.username || null,
          });
        }
      }
    } catch (err) {
      console.error('Classic character lookup failed for realm', realmName, err);
      const realmMeta = ensureRealmMeta();
      realmMeta.error = 'Character lookup failed';
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

function normalizeFamilyRoster(family, roster = {}) {
  const characters = Array.isArray(roster.characters) ? roster.characters : [];
  const realms = Array.isArray(roster.realms) ? roster.realms : [];
  const payload = {
    family,
    characters,
    realms,
    summary: {
      totalCharacters: characters.length,
      totalRealms: realms.length,
    },
  };
  if (roster.message) {
    payload.message = roster.message;
  }
  return payload;
}

function createEmptyCharacterResponse() {
  const refreshedAt = new Date().toISOString();
  return {
    ok: true,
    families: [normalizeFamilyRoster('retail'), normalizeFamilyRoster('classic')],
    summary: { totalCharacters: 0, totalRealms: 0 },
    message: 'No characters found for your linked accounts.',
    refreshedAt,
    isGm: false,
    gmAccounts: {
      retail: {},
      classic: {},
    },
  };
}

async function deriveBattleNetAccountIds(accountIds) {
  const sanitized = sanitizeAccountIdList(accountIds);
  if (!sanitized.length || !authPool) {
    return sanitized;
  }
  const normalized = [];
  const seen = new Set();
  const pending = new Set(sanitized);
  const push = (value) => {
    const id = toSafeNumber(value);
    if (id == null || seen.has(id)) return;
    seen.add(id);
    normalized.push(id);
  };

  const accountCandidates = Array.from(pending);
  if (accountCandidates.length) {
    const placeholders = accountCandidates.map(() => '?').join(', ');
    try {
      const [rows] = await authPool.query(
        `SELECT id, battlenet_account FROM \`account\` WHERE id IN (${placeholders})`,
        accountCandidates
      );
      for (const row of rows || []) {
        const accountId = toSafeNumber(row.id);
        if (accountId == null || !pending.has(accountId)) continue;
        pending.delete(accountId);
        const parent = toSafeNumber(row.battlenet_account);
        if (parent != null) {
          push(parent);
        } else {
          push(accountId);
        }
      }
    } catch (err) {
      if (err?.code !== 'ER_NO_SUCH_TABLE') {
        console.warn('Failed to inspect auth.account for retail IDs', err?.message || err);
      }
    }
  }

  if (pending.size) {
    const remaining = Array.from(pending);
    const placeholders = remaining.map(() => '?').join(', ');
    try {
      const [rows] = await authPool.query(
        `SELECT id FROM \`battlenet_accounts\` WHERE id IN (${placeholders})`,
        remaining
      );
      for (const row of rows || []) {
        const id = toSafeNumber(row.id);
        if (id == null || !pending.has(id)) continue;
        pending.delete(id);
        push(id);
      }
    } catch (err) {
      if (err?.code !== 'ER_NO_SUCH_TABLE') {
        console.warn('Failed to inspect battlenet_accounts for retail IDs', err?.message || err);
      }
    }
  }

  for (const leftover of pending) {
    push(leftover);
  }
  return normalized;
}

async function buildCharactersResponse({ retailAccountIds = [], classicAccountIds = [] } = {}) {
  const sanitizedRetailIds = sanitizeAccountIdList(retailAccountIds);
  const sanitizedClassicIds = sanitizeAccountIdList(classicAccountIds);
  if (!sanitizedRetailIds.length && !sanitizedClassicIds.length) {
    return createEmptyCharacterResponse();
  }
  const [retailGmFlags, classicGmFlags, retailBattleNetIds] = await Promise.all([
    loadGmFlagsForAccounts({ type: 'retail', accountIds: sanitizedRetailIds }),
    loadGmFlagsForAccounts({ type: 'classic', accountIds: sanitizedClassicIds }),
    deriveBattleNetAccountIds(sanitizedRetailIds),
  ]);
  gmDebug('buildCharactersResponse:gm-flags', {
    retailAccounts: sanitizedRetailIds,
    retailBattleNetAccounts: retailBattleNetIds,
    classicAccounts: sanitizedClassicIds,
    retailGmAccounts: Object.keys(retailGmFlags || {}).length,
    classicGmAccounts: Object.keys(classicGmFlags || {}).length,
    retailHasGm: hasAnyGmFlags(retailGmFlags),
    classicHasGm: hasAnyGmFlags(classicGmFlags),
  });
  const refreshedAt = new Date().toISOString();
  const families = [];
  let totalCharacters = 0;
  let totalRealms = 0;

  const descriptors = [
    { key: 'retail', ids: retailBattleNetIds, loader: loadBattleNetCharacters },
    { key: 'classic', ids: sanitizedClassicIds, loader: loadClassicCharacters },
  ];

  for (const descriptor of descriptors) {
    let roster = { characters: [], realms: [] };
    if (descriptor.ids.length) {
      roster = await descriptor.loader(descriptor.ids);
    }
    const normalized = normalizeFamilyRoster(descriptor.key, roster);
    families.push(normalized);
    totalCharacters += normalized.summary.totalCharacters;
    totalRealms += normalized.summary.totalRealms;
  }

  const payload = {
    ok: true,
    families,
    summary: { totalCharacters, totalRealms },
    refreshedAt,
    isGm: hasAnyGmFlags(retailGmFlags) || hasAnyGmFlags(classicGmFlags),
    gmAccounts: {
      retail: retailGmFlags,
      classic: classicGmFlags,
    },
  };
  gmDebug('buildCharactersResponse:payload', {
    totalCharacters,
    totalRealms,
    isGm: payload.isGm,
  });
  if (!totalCharacters) {
    payload.message = 'No characters found for your linked accounts.';
  }
  return payload;
}

function getWorldPoolForRealm(realm) {
  const normalized = realm === 'classic' ? 'classic' : 'retail';
  return normalized === 'classic' ? classicWorldPool : worldPool;
}

async function loadGmCommandReference(realm = 'retail') {
  const normalized = realm === 'classic' ? 'classic' : 'retail';
  const cacheKey = normalized;
  const cached = GM_COMMAND_CACHE.get(cacheKey);
  if (cached && cached.expiresAt > Date.now()) {
    return cached.commands;
  }
  const poolRef = getWorldPoolForRealm(normalized);
  if (!poolRef) {
    throw new Error('World database unavailable');
  }
  const [rows] = await poolRef.execute('SELECT name, help FROM command ORDER BY name ASC');
  const commands = rows
    .map((row) => ({
      name: typeof row?.name === 'string' ? row.name.trim() : '',
      help: typeof row?.help === 'string' ? row.help.trim() : '',
    }))
    .filter((entry) => entry.name.length);
  GM_COMMAND_CACHE.set(cacheKey, {
    commands,
    expiresAt: Date.now() + GM_COMMAND_CACHE_TTL_MS,
  });
  return commands;
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

function sanitizeAccountIdList(values) {
  if (!Array.isArray(values)) return [];
  const clean = [];
  for (const value of values) {
    const numeric = toSafeNumber(value);
    if (numeric != null) {
      clean.push(numeric);
    }
  }
  return clean;
}

async function loadGmFlagsForAccounts({ type, accountIds }) {
  const sanitized = sanitizeAccountIdList(accountIds);
  gmDebug('loadGmFlagsForAccounts:start', {
    type,
    requestedCount: Array.isArray(accountIds) ? accountIds.length : 0,
    sanitizedCount: sanitized.length,
  });
  if (!sanitized.length) {
    gmDebug('loadGmFlagsForAccounts:skip-empty', { type });
    return {};
  }

  const pool = type === 'classic' ? classicAuthPool : authPool;
  let columnRows;
  try {
    [columnRows] = await pool.query('SHOW COLUMNS FROM `account_access`');
  } catch (err) {
    if (err?.code === 'ER_NO_SUCH_TABLE') {
      return {};
    }
    throw err;
  }

  const columnNames = Array.isArray(columnRows) ? columnRows.map((col) => col.Field) : [];
  const columnLookup = new Map(columnNames.map((name) => [String(name).toLowerCase(), name]));
  const pickColumn = (...candidates) => {
    for (const candidate of candidates) {
      if (!candidate) continue;
      if (columnNames.includes(candidate)) {
        return candidate;
      }
      const normalized = String(candidate).toLowerCase();
      if (columnLookup.has(normalized)) {
        return columnLookup.get(normalized);
      }
    }
    return null;
  };
  const idCol = pickColumn('id', 'account_id', 'accountid', 'accountId', 'AccountID');
  const gmColCandidates = ['gmlevel', 'gmLevel', 'GMLevel', 'securitylevel', 'SecurityLevel'];
  const gmCol = pickColumn(...gmColCandidates);
  const realmColCandidates = ['RealmID', 'realmId', 'realmID', 'realm_id'];
  const realmCol = pickColumn(...realmColCandidates);

  if (!idCol || !gmCol) {
    gmDebug('loadGmFlagsForAccounts:missing-columns', { type, idCol, gmCol, realmCol });
    return {};
  }

  const selectParts = [`${idCol} AS accountId`, `${gmCol} AS gmlevel`];
  if (realmCol) {
    selectParts.push(`${realmCol} AS realmId`);
  }
  const placeholders = sanitized.map(() => '?').join(', ');
  const sql = `SELECT ${selectParts.join(', ')} FROM \`account_access\` WHERE ${idCol} IN (${placeholders})`;

  gmDebug('loadGmFlagsForAccounts:query', { type, idCol, gmCol, realmCol, sql });
  const [rows] = await pool.query(sql, sanitized);
  const result = {};
  for (const row of rows) {
    const id = toSafeNumber(row?.accountId);
    if (id == null) continue;
    result[id] = {
      gmlevel:
        toSafeNumber(
          row?.gmlevel ?? row?.gmLevel ?? row?.GMLevel ?? row?.securitylevel ?? row?.SecurityLevel
        ) ?? 0,
      realmId: toSafeNumber(row?.realmId ?? row?.RealmID ?? row?.RealmId) ?? -1,
    };
  }
  gmDebug('loadGmFlagsForAccounts:result', {
    type,
    rowCount: rows.length,
    gmAccounts: Object.keys(result).length,
    gmHits: Object.values(result).filter((entry) => (toSafeNumber(entry?.gmlevel) ?? 0) > 0).length,
  });
  return result;
}

function hasAnyGmFlags(flags) {
  if (!flags || typeof flags !== 'object') {
    return false;
  }
  return Object.values(flags).some((entry) => {
    const gmLevel = toSafeNumber(
      entry?.gmlevel ?? entry?.gmLevel ?? entry?.GMLevel ?? entry?.securitylevel ?? entry?.SecurityLevel
    );
    return gmLevel != null && gmLevel > 0;
  });
}

function createEmptyGmInfo() {
  return { maxLevel: 0, highestRealms: [], entries: [] };
}

function normalizeGmInfo(raw) {
  if (!raw || typeof raw !== 'object') {
    return createEmptyGmInfo();
  }
  const maxLevel = toSafeNumber(raw.maxLevel);
  const highestRealms = Array.isArray(raw.highestRealms)
    ? raw.highestRealms
        .map((value) => toSafeNumber(value))
        .filter((value) => value != null)
    : [];
  const entries = Array.isArray(raw.entries)
    ? raw.entries
        .map((entry) => {
          if (!entry || typeof entry !== 'object') return null;
          const gmLevel = toSafeNumber(entry.gmLevel);
          if (gmLevel == null) return null;
          return {
            accountId: toSafeNumber(entry.accountId),
            gmLevel,
            realmId: toSafeNumber(entry.realmId),
          };
        })
        .filter(Boolean)
    : [];
  return {
    maxLevel: maxLevel == null ? 0 : maxLevel,
    highestRealms,
    entries,
  };
}

function cloneGmInfo(value) {
  const normalized = normalizeGmInfo(value);
  return {
    maxLevel: normalized.maxLevel,
    highestRealms: normalized.highestRealms.slice(),
    entries: normalized.entries.map((entry) => ({ ...entry })),
  };
}

function encodeGmInfo(info) {
  return JSON.stringify(normalizeGmInfo(info));
}

function decodeGmInfo(raw) {
  if (!raw) {
    return createEmptyGmInfo();
  }
  if (typeof raw === 'string') {
    try {
      return normalizeGmInfo(JSON.parse(raw));
    } catch (err) {
      return createEmptyGmInfo();
    }
  }
  return normalizeGmInfo(raw);
}

function buildGmInfoFromRows(rows) {
  if (!Array.isArray(rows) || !rows.length) {
    return createEmptyGmInfo();
  }
  const info = createEmptyGmInfo();
  const highestRealmSet = new Set();
  for (const row of rows) {
    const gmLevel = toSafeNumber(
      row?.gmlevel ?? row?.gmLevel ?? row?.GMLevel ?? row?.securitylevel ?? row?.SecurityLevel
    );
    if (gmLevel == null) continue;
    const entry = {
      accountId: toSafeNumber(row?.id ?? row?.account_id ?? row?.accountId),
      gmLevel,
      realmId: toSafeNumber(row?.RealmID ?? row?.realmId ?? row?.realmID ?? row?.RealmId),
    };
    info.entries.push(entry);
    if (gmLevel > info.maxLevel) {
      info.maxLevel = gmLevel;
      highestRealmSet.clear();
      if (entry.realmId != null) {
        highestRealmSet.add(entry.realmId);
      }
    } else if (gmLevel === info.maxLevel && entry.realmId != null) {
      highestRealmSet.add(entry.realmId);
    }
  }
  info.highestRealms = Array.from(highestRealmSet);
  return normalizeGmInfo(info);
}

async function fetchAccountGmRows(dbPool, accountIds, { realm = 'retail' } = {}) {
  const ids = sanitizeAccountIdList(accountIds);
  gmDebug('fetchAccountGmRows:start', {
    realm,
    requestedCount: Array.isArray(accountIds) ? accountIds.length : 0,
    sanitizedCount: ids.length,
  });
  if (!ids.length) {
    gmDebug('fetchAccountGmRows:skip-empty', { realm });
    return createEmptyGmInfo();
  }
  const placeholders = ids.map(() => '?').join(', ');
  const queries = [
    `SELECT AccountID AS id, gmlevel, RealmID FROM account_access WHERE AccountID IN (${placeholders})`,
    `SELECT AccountID AS id, SecurityLevel AS gmlevel, RealmID FROM account_access WHERE AccountID IN (${placeholders})`,
    `SELECT id, gmlevel, RealmID FROM account_access WHERE id IN (${placeholders})`,
    `SELECT id, SecurityLevel AS gmlevel, RealmID FROM account_access WHERE id IN (${placeholders})`,
  ];
  let lastError = null;
  for (const sql of queries) {
    try {
      gmDebug('fetchAccountGmRows:query', { realm, sql });
      const [rows] = await dbPool.query(sql, ids);
      const info = buildGmInfoFromRows(rows);
      gmDebug('fetchAccountGmRows:success', {
        realm,
        rowCount: rows.length,
        maxLevel: info.maxLevel,
        entryCount: info.entries.length,
      });
      return info;
    } catch (err) {
      if (err?.code === 'ER_BAD_FIELD_ERROR') {
        gmDebug('fetchAccountGmRows:query-fallback', { realm, sql, error: err?.message });
        lastError = err;
        continue;
      }
      if (err?.code === 'ER_NO_SUCH_TABLE') {
        gmDebug('fetchAccountGmRows:no-table', { realm });
        return createEmptyGmInfo();
      }
      gmDebug('fetchAccountGmRows:query-error', { realm, error: err?.message });
      throw err;
    }
  }
  if (lastError) {
    gmDebug('fetchAccountGmRows:exhausted', { realm, error: lastError?.message });
    throw lastError;
  }
  return createEmptyGmInfo();
}

async function getRetailGmInfo(accountIds) {
  gmDebug('getRetailGmInfo:invoke', { accountIds: sanitizeAccountIdList(accountIds) });
  return fetchAccountGmRows(authPool, accountIds, { realm: 'retail' });
}

async function getClassicGmInfo(accountIds) {
  gmDebug('getClassicGmInfo:invoke', { accountIds: sanitizeAccountIdList(accountIds) });
  return fetchAccountGmRows(classicAuthPool, accountIds, { realm: 'classic' });
}

function pickPrimaryAccountId(portalUser) {
  if (!portalUser || typeof portalUser !== 'object') {
    return 0;
  }
  const retailIds = Array.isArray(portalUser.retailAccountIds) ? portalUser.retailAccountIds : [];
  const classicIds = Array.isArray(portalUser.classicAccountIds) ? portalUser.classicAccountIds : [];
  const raw = (retailIds.length ? retailIds[0] : null) ?? (classicIds.length ? classicIds[0] : null);
  const id = toSafeNumber(raw);
  return id == null ? 0 : id;
}

function encodeAccountIdList(values) {
  const clean = sanitizeAccountIdList(values);
  return clean.length ? JSON.stringify(clean) : null;
}

function decodeAccountIdList(raw) {
  if (!raw) return [];
  if (Array.isArray(raw)) {
    return sanitizeAccountIdList(raw);
  }
  if (typeof raw === 'string') {
    try {
      const parsed = JSON.parse(raw);
      return sanitizeAccountIdList(Array.isArray(parsed) ? parsed : []);
    } catch (err) {
      // fall through
    }
  }
  return [];
}

function attachSessionHelpers(session) {
  if (!session) return session;
  const retailAccountIds = sanitizeAccountIdList(
    session.retailAccountIds ?? decodeAccountIdList(session.retail_accounts_json)
  );
  const classicAccountIds = sanitizeAccountIdList(
    session.classicAccountIds ?? decodeAccountIdList(session.classic_accounts_json)
  );
  const retailGmInfo = normalizeGmInfo(session.retailGmInfo ?? decodeGmInfo(session.retail_gmlevel_json));
  const classicGmInfo = normalizeGmInfo(
    session.classicGmInfo ?? decodeGmInfo(session.classic_gmlevel_json)
  );
  session.retailAccountIds = retailAccountIds;
  session.classicAccountIds = classicAccountIds;
  session.retailGmInfo = retailGmInfo;
  session.classicGmInfo = classicGmInfo;
  delete session.retail_accounts_json;
  delete session.classic_accounts_json;
  delete session.retail_gmlevel_json;
  delete session.classic_gmlevel_json;
  Object.defineProperty(session, 'getRetailAccountIds', {
    value: () => (Array.isArray(session.retailAccountIds) ? session.retailAccountIds.slice() : []),
    enumerable: false,
    configurable: true,
  });
  Object.defineProperty(session, 'getClassicAccountIds', {
    value: () => (Array.isArray(session.classicAccountIds) ? session.classicAccountIds.slice() : []),
    enumerable: false,
    configurable: true,
  });
  Object.defineProperty(session, 'getPrimaryRetailAccountId', {
    value: () =>
      Array.isArray(session.retailAccountIds) && session.retailAccountIds.length
        ? session.retailAccountIds[0]
        : null,
    enumerable: false,
    configurable: true,
  });
  Object.defineProperty(session, 'getRetailGmInfo', {
    value: () => cloneGmInfo(session.retailGmInfo),
    enumerable: false,
    configurable: true,
  });
  Object.defineProperty(session, 'getClassicGmInfo', {
    value: () => cloneGmInfo(session.classicGmInfo),
    enumerable: false,
    configurable: true,
  });
  return session;
}

async function loadSession(req) {
  const token = getSessionToken(req);
  if (!token) return null;
  const hashed = hashSessionToken(token);
  const now = Date.now();
  const [rows] = await pool.execute(
    `SELECT id, portal_user_id, account_id, email, username, retail_accounts_json, classic_accounts_json,
            retail_gmlevel_json, classic_gmlevel_json, created_at, expires_at
       FROM sessions
      WHERE id = ? AND expires_at > ?
      LIMIT 1`,
    [hashed, now]
  );
  if (!rows.length) return null;
  const session = rows[0];
  if (session.portal_user_id == null) {
    return null;
  }
  session.token = token;
  session.retailAccountIds = decodeAccountIdList(session.retail_accounts_json);
  session.classicAccountIds = decodeAccountIdList(session.classic_accounts_json);
  return attachSessionHelpers(session);
}

async function persistSession({ portalUserId, email, username, retailAccountIds = [], classicAccountIds = [] }, req) {
  const safePortalId = toSafeNumber(portalUserId);
  if (safePortalId == null) {
    throw new Error('Cannot persist session without portal user id');
  }
  const normalizedEmail = normalizeEmail(email) || (typeof email === 'string' ? email.trim() : null);
  if (!normalizedEmail) {
    throw new Error('Cannot persist session without email');
  }
  const token = crypto.randomBytes(48).toString('base64url');
  const hashed = hashSessionToken(token);
  const now = Date.now();
  const expiresAt = now + CONFIG.SESSION_TTL_HOURS * 60 * 60 * 1000;
  const userAgent = (req.headers['user-agent'] || '').slice(0, 255);
  const ip = (req.ip || req.headers['x-forwarded-for'] || '').toString().slice(0, 64);
  const sanitizedRetailIds = sanitizeAccountIdList(retailAccountIds);
  const sanitizedClassicIds = sanitizeAccountIdList(classicAccountIds);
  gmDebug('persistSession:start', {
    portalUserId: safePortalId,
    retailAccounts: sanitizedRetailIds,
    classicAccounts: sanitizedClassicIds,
  });
  const primaryAccountId = pickPrimaryAccountId({
    retailAccountIds: sanitizedRetailIds,
    classicAccountIds: sanitizedClassicIds,
  });
  let retailGmInfo = createEmptyGmInfo();
  let classicGmInfo = createEmptyGmInfo();
  try {
    [retailGmInfo, classicGmInfo] = await Promise.all([
      getRetailGmInfo(sanitizedRetailIds),
      getClassicGmInfo(sanitizedClassicIds),
    ]);
    gmDebug('persistSession:gm-loaded', {
      portalUserId: safePortalId,
      retailMax: retailGmInfo?.maxLevel,
      retailEntries: retailGmInfo?.entries?.length || 0,
      classicMax: classicGmInfo?.maxLevel,
      classicEntries: classicGmInfo?.entries?.length || 0,
    });
  } catch (err) {
    console.error('Failed to load GM metadata for session', err);
    gmDebug('persistSession:gm-error', { portalUserId: safePortalId, error: err?.message });
  }
  const sessionUsername = normalizePortalUsername(username);
  await pool.execute(
    `REPLACE INTO sessions (id, portal_user_id, account_id, email, username, retail_accounts_json, classic_accounts_json,
                            retail_gmlevel_json, classic_gmlevel_json, created_at, expires_at, last_ip, last_user_agent)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      hashed,
      safePortalId,
      primaryAccountId,
      normalizedEmail,
      sessionUsername,
      encodeAccountIdList(sanitizedRetailIds),
      encodeAccountIdList(sanitizedClassicIds),
      encodeGmInfo(retailGmInfo),
      encodeGmInfo(classicGmInfo),
      now,
      expiresAt,
      ip || null,
      userAgent || null,
    ]
  );
  return { token, expiresAt };
}

async function updateSessionAccountLinks(session, { retailAccountIds, classicAccountIds }) {
  if (!session?.token) {
    return;
  }
  const hashed = hashSessionToken(session.token);
  const nextRetail = retailAccountIds != null ? sanitizeAccountIdList(retailAccountIds) : session.retailAccountIds || [];
  const nextClassic = classicAccountIds != null ? sanitizeAccountIdList(classicAccountIds) : session.classicAccountIds || [];
  gmDebug('updateSessionAccountLinks:start', {
    sessionId: session.id,
    retailAccounts: nextRetail,
    classicAccounts: nextClassic,
  });
  let retailGmInfo = session.retailGmInfo || createEmptyGmInfo();
  let classicGmInfo = session.classicGmInfo || createEmptyGmInfo();
  try {
    [retailGmInfo, classicGmInfo] = await Promise.all([
      getRetailGmInfo(nextRetail),
      getClassicGmInfo(nextClassic),
    ]);
    gmDebug('updateSessionAccountLinks:gm-loaded', {
      sessionId: session.id,
      retailMax: retailGmInfo?.maxLevel,
      retailEntries: retailGmInfo?.entries?.length || 0,
      classicMax: classicGmInfo?.maxLevel,
      classicEntries: classicGmInfo?.entries?.length || 0,
    });
  } catch (err) {
    console.error('Failed to refresh GM metadata for session update', err);
    gmDebug('updateSessionAccountLinks:gm-error', { sessionId: session.id, error: err?.message });
  }
  try {
    await pool.execute(
      'UPDATE sessions SET retail_accounts_json = ?, classic_accounts_json = ?, retail_gmlevel_json = ?, classic_gmlevel_json = ? WHERE id = ?',
      [
        encodeAccountIdList(nextRetail),
        encodeAccountIdList(nextClassic),
        encodeGmInfo(retailGmInfo),
        encodeGmInfo(classicGmInfo),
        hashed,
      ]
    );
    session.retailAccountIds = nextRetail;
    session.classicAccountIds = nextClassic;
    session.retailGmInfo = retailGmInfo;
    session.classicGmInfo = classicGmInfo;
  } catch (err) {
    console.error('Failed to update session account links', err);
  }
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

function hasGmAccess(session, realm, minLevel = 1) {
  if (!session) {
    return false;
  }
  const normalizedRealm = realm === 'classic' ? 'classic' : 'retail';
  const targetLevel = toSafeNumber(minLevel) ?? 1;
  const info = normalizedRealm === 'classic' ? session.classicGmInfo : session.retailGmInfo;
  const gmLevel = toSafeNumber(info?.maxLevel) ?? 0;
  return gmLevel >= targetLevel;
}

function normalizeRealmInput(value, fallback = null) {
  const text = typeof value === 'string' ? value.trim().toLowerCase() : '';
  if (text === 'classic') return 'classic';
  if (text === 'retail') return 'retail';
  return fallback;
}

function hasAnyGmAccess(session, minLevel = 1) {
  return hasGmAccess(session, 'retail', minLevel) || hasGmAccess(session, 'classic', minLevel);
}

function requireGm({ realm = 'retail', minLevel = 1 } = {}) {
  const normalizedRealm = realm === 'classic' ? 'classic' : 'retail';
  const requiredLevel = toSafeNumber(minLevel) ?? 1;
  return (req, res, next) => {
    if (!req.session) {
      return res.status(401).json({ error: 'Unauthorized' });
    }
    if (
      !hasGmAccess(req.session, normalizedRealm, requiredLevel) &&
      !hasAnyGmAccess(req.session, requiredLevel)
    ) {
      return res.status(403).json({ error: 'GM access required' });
    }
    return next();
  };
}

function requireRequestGm({ source = 'body', key = 'realm', fallbackRealm = null, minLevel = 1 } = {}) {
  const requiredLevel = toSafeNumber(minLevel) ?? 1;
  return (req, res, next) => {
    if (!req.session) {
      return res.status(401).json({ error: 'Unauthorized' });
    }
    let realmValue = null;
    if (source === 'query') {
      realmValue = req.query?.[key];
    } else if (source === 'params') {
      realmValue = req.params?.[key];
    } else {
      realmValue = req.body?.[key];
    }
    const resolvedRealm = normalizeRealmInput(realmValue, fallbackRealm);
    if (!resolvedRealm) {
      return res.status(400).json({ error: 'Invalid realm selection' });
    }
    if (
      !hasGmAccess(req.session, resolvedRealm, requiredLevel) &&
      !hasAnyGmAccess(req.session, requiredLevel)
    ) {
      return res.status(403).json({ error: 'GM access required' });
    }
    req.gmRealm = resolvedRealm;
    return next();
  };
}

async function recordPortalAuditEvent({ portalUserId, action, details }) {
  const safePortalId = toSafeNumber(portalUserId);
  const trimmedAction = typeof action === 'string' ? action.trim() : '';
  if (safePortalId == null || !trimmedAction) {
    return;
  }
  const payload = details ? JSON.stringify(details) : null;
  try {
    await pool.execute(
      'INSERT INTO portal_audit_logs (portal_user_id, action, details, created_at) VALUES (?, ?, ?, ?)',
      [safePortalId, trimmedAction.slice(0, 64), payload, Date.now()]
    );
  } catch (err) {
    console.error('Failed to record portal audit event', err);
  }
}

async function loadPortalUserAccountLinks(portalUserId) {
  const safePortalId = toSafeNumber(portalUserId);
  if (safePortalId == null) {
    return { retailAccountIds: [], classicAccountIds: [] };
  }
  try {
    const [[retailRows], [classicRows]] = await Promise.all([
      pool.execute('SELECT retail_account_id FROM portal_user_retail_accounts WHERE portal_user_id = ?', [safePortalId]),
      pool.execute('SELECT classic_account_id FROM portal_user_classic_accounts WHERE portal_user_id = ?', [safePortalId]),
    ]);
    const retailAccountIds = retailRows
      .map((row) => toSafeNumber(row.retail_account_id))
      .filter((value) => value != null);
    const classicAccountIds = classicRows
      .map((row) => toSafeNumber(row.classic_account_id))
      .filter((value) => value != null);
    return { retailAccountIds, classicAccountIds };
  } catch (err) {
    console.error('Failed to load portal user account links', err);
    return { retailAccountIds: [], classicAccountIds: [] };
  }
}

async function loadPortalUser(whereClause, params) {
  try {
    const [rows] = await pool.execute(
      `SELECT id, email, username, password_hash, salt, version, created_at, updated_at, last_login_at, login_count
       FROM portal_users WHERE ${whereClause} LIMIT 1`,
      params
    );
    if (!rows.length) return null;
    const user = rows[0];
    const links = await loadPortalUserAccountLinks(user.id);
    user.retailAccountIds = links.retailAccountIds;
    user.classicAccountIds = links.classicAccountIds;
    const hydrated = await hydratePortalUserLinks(user);
    return hydrated?.portalUser || user;
  } catch (err) {
    console.error('Failed to load portal user', err);
    return null;
  }
}

async function getPortalUserByEmail(email) {
  const normalized = normalizeEmail(email);
  if (!normalized) return null;
  return loadPortalUser('email = ?', [normalized]);
}

async function getPortalUserByUsername(username) {
  const normalized = normalizePortalUsername(username);
  if (!normalized) return null;
  return loadPortalUser('UPPER(username) = UPPER(?)', [normalized]);
}

async function getPortalUserById(portalUserId) {
  const safePortalId = toSafeNumber(portalUserId);
  if (safePortalId == null) return null;
  return loadPortalUser('id = ?', [safePortalId]);
}

async function getPortalUserByIdentity(identity) {
  if (typeof identity !== 'string') return null;
  const emailCandidate = normalizeEmail(identity);
  if (emailCandidate) {
    const byEmail = await getPortalUserByEmail(emailCandidate);
    if (byEmail) return byEmail;
  }
  return getPortalUserByUsername(identity);
}

async function linkPortalUserToRetailAccount(portalUserId, accountId, { linkedAt } = {}) {
  const safePortalId = toSafeNumber(portalUserId);
  const safeAccountId = toSafeNumber(accountId);
  if (safePortalId == null || safeAccountId == null) return;
  const timestamp = toSafeNumber(linkedAt) ?? Date.now();
  try {
    await pool.execute(
      `INSERT INTO portal_user_retail_accounts (portal_user_id, retail_account_id, linked_at)
       VALUES (?, ?, ?)
       ON DUPLICATE KEY UPDATE linked_at = VALUES(linked_at)`,
      [safePortalId, safeAccountId, timestamp]
    );
    await recordPortalAuditEvent({
      portalUserId: safePortalId,
      action: 'link:retail',
      details: { accountId: safeAccountId },
    });
  } catch (err) {
    console.error('Failed to link portal user to retail account', err);
  }
}

async function linkPortalUserToClassicAccount(portalUserId, accountId, { linkedAt } = {}) {
  const safePortalId = toSafeNumber(portalUserId);
  const safeAccountId = toSafeNumber(accountId);
  if (safePortalId == null) return;
  if (safeAccountId == null) {
    console.warn('Skipping classic account link due to invalid account id', {
      portalUserId,
      accountId,
    });
    return;
  }
  const timestamp = toSafeNumber(linkedAt) ?? Date.now();
  try {
    await pool.execute(
      `INSERT INTO portal_user_classic_accounts (portal_user_id, classic_account_id, linked_at)
       VALUES (?, ?, ?)
       ON DUPLICATE KEY UPDATE linked_at = VALUES(linked_at)`,
      [safePortalId, safeAccountId, timestamp]
    );
    await recordPortalAuditEvent({
      portalUserId: safePortalId,
      action: 'link:classic',
      details: { accountId: safeAccountId },
    });
  } catch (err) {
    console.error('Failed to link portal user to classic account', err);
  }
}

async function recordPortalLogin(portalUserId) {
  const safePortalId = toSafeNumber(portalUserId);
  if (safePortalId == null) return;
  try {
    await pool.execute('UPDATE portal_users SET last_login_at = ?, login_count = login_count + 1 WHERE id = ?', [
      Date.now(),
      safePortalId,
    ]);
  } catch (err) {
    console.error('Failed to record portal login metadata', err);
  }
}

async function upsertPortalUser({ email, password, retailAccountId, classicAccountId, username }) {
  const normalized = normalizeEmail(email);
  if (!normalized || typeof password !== 'string' || !password.length) return null;
  const normalizedUsername = normalizePortalUsername(username);
  try {
    const { hash, salt, version } = await hashPortalPassword(password);
    const now = Date.now();
    await pool.execute(
      `INSERT INTO portal_users (email, username, password_hash, salt, version, created_at, updated_at)
       VALUES (?, ?, ?, ?, ?, ?, ?)
       ON DUPLICATE KEY UPDATE
         username = COALESCE(VALUES(username), portal_users.username),
         password_hash = VALUES(password_hash),
         salt = VALUES(salt),
         version = VALUES(version),
         updated_at = VALUES(updated_at)`,
      [normalized, normalizedUsername, hash, salt, version, now, now]
    );
    const [rows] = await pool.execute('SELECT id FROM portal_users WHERE email = ? LIMIT 1', [normalized]);
    const portalUserId = rows?.[0]?.id ?? null;
    if (portalUserId != null) {
      if (retailAccountId != null) {
        await linkPortalUserToRetailAccount(portalUserId, retailAccountId, { linkedAt: now });
      }
      if (classicAccountId != null) {
        await linkPortalUserToClassicAccount(portalUserId, classicAccountId, { linkedAt: now });
      }
    }
    return portalUserId;
  } catch (err) {
    console.error('Failed to upsert portal user', err);
    return null;
  }
}

async function setPortalUserPassword(portalUserId, password) {
  const safePortalId = toSafeNumber(portalUserId);
  if (safePortalId == null || typeof password !== 'string' || !password.length) {
    return false;
  }
  try {
    const { hash, salt, version } = await hashPortalPassword(password);
    await pool.execute(
      'UPDATE portal_users SET password_hash = ?, salt = ?, version = ?, updated_at = ? WHERE id = ?',
      [hash, salt, version, Date.now(), safePortalId]
    );
    return true;
  } catch (err) {
    console.error('Failed to update portal password', err);
    return false;
  }
}

async function applyLinkedPasswordUpdate({ portalUser, newPassword }) {
  if (!portalUser || typeof newPassword !== 'string' || !newPassword.length) {
    throw new Error('Missing portal user or password');
  }
  const retailIds = Array.isArray(portalUser.retailAccountIds) ? portalUser.retailAccountIds : [];
  const classicIds = Array.isArray(portalUser.classicAccountIds) ? portalUser.classicAccountIds : [];
  if (retailIds.length) {
    await retailPasswordReset({ soap: SOAP, email: portalUser.email, newPassword });
  }
  if (classicIds.length) {
    const classicAccounts = await loadClassicAccountCredentials(classicIds);
    for (const account of classicAccounts) {
      if (!account?.username) {
        console.warn('Classic account missing username for password reset', {
          portalUserId: portalUser.id,
          accountId: account?.id,
        });
        continue;
      }
      await classicPasswordReset({ soap: CLASSIC_SOAP, username: account.username, newPassword });
    }
  }
}

async function updatePortalAndLinkedPasswords({ portalUser, newPassword }) {
  if (!portalUser || portalUser.id == null || typeof newPassword !== 'string' || !newPassword.length) {
    throw new Error('Missing portal user or password');
  }
  await setPortalUserPassword(portalUser.id, newPassword);
  await applyLinkedPasswordUpdate({ portalUser, newPassword });
}

async function linkPortalAccounts({ portalUserId, password, username, gameType }) {
  if (!isValidPassword(password)) {
    throw new PortalHttpError('Invalid password');
  }
  const portalUser = await getPortalUserById(portalUserId);
  if (!portalUser) {
    throw new PortalHttpError('Portal account not found.', 404);
  }
  const targetType = gameType === 'classic' ? 'classic' : 'retail';
  const retailIds = Array.isArray(portalUser.retailAccountIds) ? [...portalUser.retailAccountIds] : [];
  const classicIds = Array.isArray(portalUser.classicAccountIds) ? [...portalUser.classicAccountIds] : [];

  if (targetType === 'retail') {
    if (retailIds.length) {
      throw new PortalHttpError('A retail account is already linked to this portal user.');
    }
    await ensureRetailAccount({
      soap: SOAP,
      email: portalUser.email,
      password,
      debug: CONFIG.SOAP_DEBUG,
    });
    const [createdPrimary, createdFallback] = await Promise.all([
      getAuthAccountByEmail(portalUser.email),
      getGameAccountByEmail(portalUser.email),
    ]);
    const retailAccountId = createdPrimary?.id ?? createdFallback?.id ?? null;
    if (retailAccountId == null) {
      throw new Error('Retail account provisioning completed but no ID was returned.');
    }
    retailIds.push(retailAccountId);
    await linkPortalUserToRetailAccount(portalUser.id, retailAccountId, { linkedAt: Date.now() });
  } else {
    if (classicIds.length) {
      throw new PortalHttpError('A classic account is already linked to this portal user.');
    }
    const fallbackUsername =
      normalizePortalUsername(username) ||
      normalizePortalUsername(portalUser.username) ||
      normalizePortalUsername((portalUser.email || '').split('@')[0]);
    if (!fallbackUsername) {
      throw new PortalHttpError('Username is required for Classic accounts.');
    }
    await ensureClassicAccount({
      soap: CLASSIC_SOAP,
      email: portalUser.email,
      username: fallbackUsername,
      password,
      debug: CONFIG.SOAP_DEBUG,
    });
    const resolvedClassicAccount = await resolveClassicAccountLink({
      username: fallbackUsername,
      email: portalUser.email,
    });
    const classicAccountId = resolvedClassicAccount?.accountId ?? null;
    if (classicAccountId == null) {
      throw new Error('Classic account provisioning completed but no ID was returned.');
    }
    classicIds.push(classicAccountId);
    portalUser.username = portalUser.username || resolvedClassicAccount?.username || fallbackUsername;
    await linkPortalUserToClassicAccount(portalUser.id, classicAccountId, { linkedAt: Date.now() });
  }

  portalUser.retailAccountIds = retailIds;
  portalUser.classicAccountIds = classicIds;

  await updatePortalAndLinkedPasswords({ portalUser, newPassword: password });

  return { portalUser, linked: targetType, retailAccountIds: retailIds, classicAccountIds: classicIds };
}

async function getAuthAccountByEmail(email) {
  const normalized = normalizeEmail(email);
  if (!normalized) return null;
  retailCharacterDebug('getAuthAccountByEmail:start', { email, normalized });
  const tables = ['bnetaccount', 'battlenet_accounts'];
  for (const table of tables) {
    retailCharacterDebug('getAuthAccountByEmail:queryTable', {
      table,
      normalized,
    });
    try {
      const [rows] = await authPool.execute(
        `SELECT id, email FROM \`${table}\` WHERE UPPER(email) = UPPER(?) LIMIT 1`,
        [normalized]
      );
      retailCharacterDebug('getAuthAccountByEmail:queryResult', {
        table,
        rowCount: Array.isArray(rows) ? rows.length : 0,
      });
      if (rows.length) {
        retailCharacterDebug('getAuthAccountByEmail:hit', {
          table,
          accountId: rows[0]?.id ?? null,
        });
        return rows[0];
      }
    } catch (err) {
      if (err?.code === 'ER_NO_SUCH_TABLE') {
        retailCharacterDebug('getAuthAccountByEmail:missingTable', { table });
        continue;
      }
      if (err?.code === 'ER_BAD_FIELD_ERROR') {
        retailCharacterDebug('getAuthAccountByEmail:fieldError', { table });
        // Older schema variants sometimes omit auth columns such as sha_pass_hash.
        // Fall back to a minimal column set so the lookup still succeeds.
        try {
          const [fallbackRows] = await authPool.execute(
            `SELECT id FROM \`${table}\` WHERE UPPER(email) = UPPER(?) LIMIT 1`,
            [normalized]
          );
          retailCharacterDebug('getAuthAccountByEmail:fallbackResult', {
            table,
            rowCount: Array.isArray(fallbackRows) ? fallbackRows.length : 0,
          });
          if (fallbackRows.length) {
            const row = fallbackRows[0];
            row.email = normalized;
            retailCharacterDebug('getAuthAccountByEmail:fallbackHit', {
              table,
              accountId: row?.id ?? null,
            });
            return row;
          }
        } catch (inner) {
          if (inner?.code === 'ER_NO_SUCH_TABLE') continue;
          retailCharacterDebug('getAuthAccountByEmail:fallbackError', {
            table,
            error: inner?.message || String(inner),
          });
          throw inner;
        }
        continue;
      }
      throw err;
    }
  }
  retailCharacterDebug('getAuthAccountByEmail:notFound', { normalized });
  return null;
}

async function getGameAccountByEmail(email) {
  const normalized = normalizeEmail(email);
  if (!normalized) return null;
  try {
    const [rows] = await authPool.execute(
      'SELECT id, username, email FROM `account` WHERE UPPER(email) = UPPER(?) LIMIT 1',
      [normalized]
    );
    if (rows.length) return rows[0];
  } catch (err) {
    if (err?.code === 'ER_BAD_FIELD_ERROR') {
      try {
        const [fallbackRows] = await authPool.execute(
          'SELECT id, username FROM `account` WHERE UPPER(email) = UPPER(?) LIMIT 1',
          [normalized]
        );
        if (fallbackRows.length) {
          const row = fallbackRows[0];
          row.email = normalized;
          return row;
        }
      } catch (inner) {
        if (inner?.code === 'ER_NO_SUCH_TABLE') {
          return null;
        }
        throw inner;
      }
      return null;
    }
    if (err?.code === 'ER_NO_SUCH_TABLE') {
      return null;
    }
    throw err;
  }
  return null;
}

async function getClassicAccountByEmail(email) {
  const normalized = normalizeEmail(email);
  if (!normalized) return null;
  try {
    const [rows] = await classicAuthPool.execute(
      'SELECT id, username, email FROM `account` WHERE UPPER(email) = UPPER(?) LIMIT 1',
      [normalized]
    );
    if (rows.length) return rows[0];
  } catch (err) {
    if (err?.code === 'ER_BAD_FIELD_ERROR') {
      try {
        const [fallbackRows] = await classicAuthPool.execute(
          'SELECT id, username FROM `account` WHERE UPPER(email) = UPPER(?) LIMIT 1',
          [normalized]
        );
        if (fallbackRows.length) {
          const row = fallbackRows[0];
          row.email = normalized;
          return row;
        }
        return null;
      } catch (inner) {
        if (inner?.code === 'ER_NO_SUCH_TABLE') {
          return null;
        }
        throw inner;
      }
    }
    if (err?.code === 'ER_NO_SUCH_TABLE') return null;
    throw err;
  }
  return null;
}

async function getClassicAccountByUsername(username) {
  if (typeof username !== 'string' || !username.trim()) return null;
  const normalized = username.trim();
  try {
    const [rows] = await classicAuthPool.execute(
      'SELECT id, username, email FROM `account` WHERE UPPER(username) = UPPER(?) LIMIT 1',
      [normalized]
    );
    if (rows.length) return rows[0];
  } catch (err) {
    if (err?.code === 'ER_NO_SUCH_TABLE') return null;
    throw err;
  }
  return null;
}

async function resolveClassicAccountLink({ username, email }) {
  const normalizedUsername = normalizePortalUsername(username);
  if (normalizedUsername) {
    const byUsername = await getClassicAccountByUsername(normalizedUsername);
    if (byUsername?.id != null) {
      return {
        accountId: byUsername.id,
        username: byUsername.username ?? normalizedUsername,
      };
    }
  }

  const normalizedEmail = normalizeEmail(email);
  if (normalizedEmail) {
    const byEmail = await getClassicAccountByEmail(normalizedEmail);
    if (byEmail?.id != null) {
      return {
        accountId: byEmail.id,
        username: byEmail.username ?? normalizedUsername ?? null,
      };
    }
  }

  return null;
}

async function loadClassicAccountCredentials(accountIds) {
  const sanitized = sanitizeAccountIdList(accountIds);
  if (!sanitized.length) return [];
  const placeholders = sanitized.map(() => '?').join(',');
  try {
    const [rows] = await classicAuthPool.execute(
      `SELECT id, username, email FROM \`account\` WHERE id IN (${placeholders})`,
      sanitized
    );
    return rows.map((row) => ({
      id: toSafeNumber(row.id),
      username: row.username,
      email: row.email,
    }));
  } catch (err) {
    if (err?.code === 'ER_NO_SUCH_TABLE') return [];
    throw err;
  }
}

async function findBnetIdForGameAccount(accountId) {
  const safeId = toSafeNumber(accountId);
  if (safeId == null) return null;
  try {
    const [rows] = await authPool.execute(
      'SELECT bnetaccountid FROM `bnetaccount_gameaccount` WHERE gameaccountid = ? LIMIT 1',
      [safeId]
    );
    if (rows.length) {
      const row = rows[0];
      const raw = row.bnetaccountid ?? row.bnetAccountId ?? row.id;
      const parsed = toSafeNumber(raw);
      return parsed == null ? null : parsed;
    }
  } catch (err) {
    if (err?.code !== 'ER_NO_SUCH_TABLE') {
      throw err;
    }
  }
  for (const column of LEGACY_BNET_ACCOUNT_COLUMNS) {
    try {
      const [rows] = await authPool.execute(
        `SELECT ${column} AS bnetAccountId FROM \`account\` WHERE id = ? LIMIT 1`,
        [safeId]
      );
      if (!rows.length) {
        continue;
      }
      const raw = rows[0]?.bnetAccountId ?? rows[0]?.bnetaccountid ?? rows[0]?.[column];
      const parsed = toSafeNumber(raw);
      if (parsed != null) {
        return parsed;
      }
    } catch (err) {
      if (err?.code === 'ER_BAD_FIELD_ERROR') {
        continue;
      }
      if (err?.code === 'ER_NO_SUCH_TABLE') {
        return null;
      }
      throw err;
    }
  }
  return null;
}

async function verifyTurnstile(token, ip, secret = CONFIG.TURNSTILE_SECRET) {
  if (!token) return false;
  const resp = await fetch('https://challenges.cloudflare.com/turnstile/v0/siteverify', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({ secret, response: token, remoteip: ip })
  });
  const data = await resp.json();
  return !!data.success;
}

const PORTAL_HASH_VERSION = 1;
const PORTAL_SCRYPT_KEYLEN = 64;
const PORTAL_SCRYPT_OPTIONS = { N: 1 << 14, r: 8, p: 1 };

function scryptAsync(password, salt, keylen, options = PORTAL_SCRYPT_OPTIONS) {
  return new Promise((resolve, reject) => {
    crypto.scrypt(password, salt, keylen, options, (err, derivedKey) => {
      if (err) {
        reject(err);
        return;
      }
      resolve(derivedKey);
    });
  });
}

async function hashPortalPassword(password) {
  const salt = crypto.randomBytes(16);
  const hash = await scryptAsync(password, salt, PORTAL_SCRYPT_KEYLEN);
  return { salt, hash, version: PORTAL_HASH_VERSION };
}

async function verifyPortalPassword(password, record) {
  if (!record || typeof password !== 'string' || !password.length) return false;
  if (record.version !== PORTAL_HASH_VERSION) return false;
  const saltBuffer = normalizeBuffer(record.salt);
  const hashBuffer = normalizeBuffer(record.password_hash);
  if (!saltBuffer || !hashBuffer) return false;
  try {
    const derived = await scryptAsync(password, saltBuffer, hashBuffer.length);
    return derived.length === hashBuffer.length && crypto.timingSafeEqual(hashBuffer, derived);
  } catch (err) {
    console.error('Failed to verify portal password', err);
    return false;
  }
}

const ALLIANCE_RACE_IDS = [1, 3, 4, 7, 11, 22, 25, 29, 30, 32, 34, 36, 37, 52, 69, 70];
const HORDE_RACE_IDS = [2, 5, 6, 8, 9, 10, 26, 27, 28, 31, 35, 38, 40, 41, 42, 45, 46, 47, 48, 51, 56, 66];

function createHealthSkeleton(branchConfig, timestamp = new Date()) {
  const nowIso = timestamp instanceof Date ? timestamp.toISOString() : new Date().toISOString();
  return {
    branch: branchConfig?.key || 'unknown',
    displayName: branchConfig?.displayName || 'Unknown realm',
    status: 'unknown',
    lastUpdated: nowIso,
    services: {
      auth: { status: 'unknown', details: '' },
      world: { status: 'unknown', details: '' },
      soap: { status: 'unknown', details: '' },
      db: { status: 'unknown', details: '' },
    },
    metrics: {
      uptimeSeconds: null,
      onlinePlayers: null,
      maxOnline: null,
      worldUpdateMs: null,
      factionOnline: {
        alliance: null,
        horde: null,
      },
    },
    history: {
      lastRestartAt: null,
      avgSessionSeconds: null,
      recordOnline: null,
    },
    errors: [],
  };
}

function deriveOverallStatus(base) {
  const svc = base.services || {};
  const svcStates = Object.values(svc).map((s) => s?.status || 'unknown');
  if (svcStates.every((s) => s === 'offline')) return 'offline';
  if (svcStates.every((s) => s === 'unknown')) return 'unknown';
  if (svcStates.includes('offline') || svcStates.includes('unknown')) return 'partial';
  return 'online';
}

function parseUptimeSeconds(text) {
  if (!text) return null;
  const numbers = {
    days: /([0-9]+)\s*Day\(s\)/i,
    hours: /([0-9]+)\s*Hour\(s\)/i,
    minutes: /([0-9]+)\s*Minute\(s\)/i,
    seconds: /([0-9]+)\s*Second\(s\)/i,
  };
  const days = Number(text.match(numbers.days)?.[1] || 0);
  const hours = Number(text.match(numbers.hours)?.[1] || 0);
  const minutes = Number(text.match(numbers.minutes)?.[1] || 0);
  const seconds = Number(text.match(numbers.seconds)?.[1] || 0);
  const total = days * 86400 + hours * 3600 + minutes * 60 + seconds;
  return Number.isFinite(total) ? total : null;
}

function parseServerInfo(ret) {
  const metrics = {
    uptimeSeconds: null,
    onlinePlayers: null,
    maxOnline: null,
    worldUpdateMs: null,
  };
  if (typeof ret !== 'string') return metrics;
  const uptimeLine = ret.match(/Server uptime:\s*([^\n]+)/i);
  if (uptimeLine?.[1]) {
    metrics.uptimeSeconds = parseUptimeSeconds(uptimeLine[1]);
  }
  const playersMatch = ret.match(/Players online:\s*(\d+)(?:\s*\(max:\s*(\d+)\))?/i) ||
    ret.match(/Current Players Online:\s*(\d+)(?:\s*\(max:\s*(\d+)\))?/i);
  if (playersMatch) {
    metrics.onlinePlayers = Number(playersMatch[1]);
    metrics.maxOnline = Number(playersMatch[2] ?? playersMatch[1]);
    if (!Number.isFinite(metrics.onlinePlayers)) metrics.onlinePlayers = null;
    if (!Number.isFinite(metrics.maxOnline)) metrics.maxOnline = null;
  }
  const updateMatch =
    ret.match(/Update time diff:\s*([0-9]+(?:\.[0-9]+)?)/i) || ret.match(/Average update time:\s*([0-9]+(?:\.[0-9]+)?)/i);
  if (updateMatch?.[1]) {
    const parsed = Number(updateMatch[1]);
    metrics.worldUpdateMs = Number.isFinite(parsed) ? parsed : null;
  }
  return metrics;
}

async function collectBranchHealth(branchConfig) {
  const base = createHealthSkeleton(branchConfig, new Date());
  const { errors } = base;

  const soapConfig = branchConfig?.soapProfile === 'classic' ? CLASSIC_SOAP : SOAP;
  const soapRunner = branchConfig?.soapProfile === 'classic' ? executeClassicCommand : executeRetailCommand;

  const runWithTimeout = (promise, timeoutMs, label) =>
    Promise.race([
      promise,
      new Promise((_, reject) =>
        setTimeout(() => reject(new Error(`${label} timeout after ${timeoutMs}ms`)), timeoutMs)
      ),
    ]);

  const realmId = toSafeNumber(branchConfig?.realmId);
  let authRealmRow = null;
  let authOk = false;

  if (branchConfig?.dbAuthPool) {
    try {
      const sql = realmId != null
        ? 'SELECT id, name, realmflags FROM `realmlist` WHERE id = ? LIMIT 1'
        : 'SELECT id, name, realmflags FROM `realmlist` ORDER BY id LIMIT 1';
      const params = realmId != null ? [realmId] : [];
      const [rows] = await branchConfig.dbAuthPool.execute(sql, params);
      authRealmRow = Array.isArray(rows) && rows.length ? rows[0] : null;
      base.services.auth.status = 'online';
      base.services.auth.details = authRealmRow?.name ? `Auth DB OK (${authRealmRow.name})` : 'Auth DB OK';
      base.services.db.status = 'partial';
      authOk = true;
    } catch (err) {
      base.services.auth.status = 'offline';
      base.services.auth.details = 'Auth DB unreachable';
      base.services.db.status = 'offline';
      errors.push(`Auth DB error: ${err?.message || err}`);
    }
  }

  if (branchConfig?.dbCharsPool) {
    try {
      const [rows] = await branchConfig.dbCharsPool.execute(
        `SELECT COUNT(*) AS total,
                SUM(CASE WHEN race IN (${ALLIANCE_RACE_IDS.join(',')}) THEN 1 ELSE 0 END) AS alliance,
                SUM(CASE WHEN race IN (${HORDE_RACE_IDS.join(',')}) THEN 1 ELSE 0 END) AS horde
           FROM characters
          WHERE online = 1`
      );
      const row = Array.isArray(rows) && rows.length ? rows[0] : {};
      const total = toSafeNumber(row.total);
      const alliance = toSafeNumber(row.alliance);
      const horde = toSafeNumber(row.horde);
      base.metrics.onlinePlayers = total;
      base.metrics.factionOnline.alliance = alliance;
      base.metrics.factionOnline.horde = horde;
      if (authOk) {
        base.services.db.status = 'online';
        base.services.db.details = 'Auth + characters DB OK';
      } else {
        base.services.db.status = 'partial';
        base.services.db.details = 'Characters DB reachable';
      }
    } catch (err) {
      if (base.services.db.status !== 'offline') {
        base.services.db.status = authOk ? 'partial' : 'offline';
      }
      base.services.db.details = base.services.db.details || 'Characters DB unreachable';
      errors.push(`Characters DB error: ${err?.message || err}`);
    }
  }

  if (branchConfig?.dbAuthPool) {
    try {
      const uptimeRealmId = realmId ?? toSafeNumber(authRealmRow?.id);
      const whereClause = uptimeRealmId != null ? 'WHERE realmid = ?' : '';
      const [rows] = await branchConfig.dbAuthPool.execute(
        `SELECT starttime, uptime, maxplayers
           FROM uptime
           ${whereClause}
       ORDER BY starttime DESC
          LIMIT 10`,
        uptimeRealmId != null ? [uptimeRealmId] : []
      );
      if (Array.isArray(rows) && rows.length) {
        const last = rows[0];
        const lastRestart = toSafeNumber(last?.starttime);
        if (lastRestart != null) {
          base.history.lastRestartAt = new Date(lastRestart * 1000).toISOString();
        }
        const recordOnline = rows
          .map((row) => toSafeNumber(row?.maxplayers))
          .filter((v) => v != null);
        if (recordOnline.length) {
          base.history.recordOnline = Math.max(...recordOnline);
          if (base.metrics.maxOnline == null) {
            base.metrics.maxOnline = base.history.recordOnline;
          }
        }
        const uptimeSecondsList = rows
          .map((row) => toSafeNumber(row?.uptime))
          .filter((v) => v != null && v > 0);
        if (uptimeSecondsList.length) {
          const avg =
            uptimeSecondsList.reduce((sum, value) => sum + value, 0) /
            uptimeSecondsList.length;
          base.history.avgSessionSeconds = Math.round(avg);
          if (base.metrics.uptimeSeconds == null) {
            base.metrics.uptimeSeconds = toSafeNumber(rows[0]?.uptime) ?? null;
          }
        }
      }
    } catch (err) {
      errors.push(`Uptime lookup failed: ${err?.message || err}`);
    }
  }

  if (soapConfig && typeof soapRunner === 'function') {
    try {
      const { ret } = await runWithTimeout(
        soapRunner({ soap: soapConfig, command: 'server info' }),
        2500,
        'SOAP'
      );
      const parsed = parseServerInfo(ret);
      base.metrics.uptimeSeconds = base.metrics.uptimeSeconds ?? parsed.uptimeSeconds;
      base.metrics.onlinePlayers = base.metrics.onlinePlayers ?? parsed.onlinePlayers;
      base.metrics.maxOnline = base.metrics.maxOnline ?? parsed.maxOnline;
      base.metrics.worldUpdateMs = base.metrics.worldUpdateMs ?? parsed.worldUpdateMs;
      base.services.soap.status = 'online';
      base.services.soap.details = 'server info OK';
      base.services.world.status = 'online';
      base.services.world.details = 'SOAP reachable';
    } catch (err) {
      base.services.soap.status = 'offline';
      base.services.soap.details = 'SOAP unreachable';
      errors.push(`SOAP error: ${err?.message || err}`);
    }
  }

  base.status = deriveOverallStatus(base);
  return base;
}

app.get('/api/status', async (req, res) => {
  try {
    const { ret } = await executeRetailCommand({ soap: SOAP, command: 'server info' });
    res.json({ ok: true, info: ret });
  } catch (e) {
    res.status(500).json({ ok: false, error: String(e) });
  }
});

app.get('/api/health/:branch', async (req, res) => {
  const branchConfig = getBranchConfig(req.params.branch);
  if (!branchConfig) {
    return res.status(400).json({ error: 'Unknown branch' });
  }

  try {
    const health = await collectBranchHealth(branchConfig);
    return res.json(health);
  } catch (err) {
    const fallback = createHealthSkeleton(branchConfig, new Date());
    fallback.errors.push(`Unhandled error in collectBranchHealth: ${err?.message || err}`);
    return res.status(500).json(fallback);
  }
});

app.post('/api/login', loginLimiter, async (req, res) => {
  try {
    const { identity: rawIdentity, email: fallbackEmail, password } = req.body || {};
    const identitySource = typeof rawIdentity === 'string' ? rawIdentity : fallbackEmail;
    const identity = typeof identitySource === 'string' ? identitySource.trim() : '';
    if (!identity) return badRequest(res, 'Email or username is required.');
    if (typeof password !== 'string' || !password.length) return badRequest(res, 'Invalid password');

    const portalUser = await getPortalUserByIdentity(identity);
    if (!portalUser) {
      console.warn('Portal login attempt for unknown identity', {
        target: maskPortalIdentity(identity),
        ip: req.ip,
      });
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const passwordOk = await verifyPortalPassword(password, portalUser);
    if (!passwordOk) {
      console.warn('Portal login attempt with incorrect password', {
        target: maskPortalIdentity(identity),
        portalUserId: portalUser.id,
        ip: req.ip,
      });
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const hydration = await hydratePortalUserLinks(portalUser);
    const activePortalUser = hydration?.portalUser || portalUser;

    await recordPortalLogin(activePortalUser.id);

    const retailAccountIds = sanitizeAccountIdList(
      Array.isArray(activePortalUser.retailAccountIds) ? activePortalUser.retailAccountIds : []
    );
    const classicAccountIds = sanitizeAccountIdList(
      Array.isArray(activePortalUser.classicAccountIds) ? activePortalUser.classicAccountIds : []
    );
    const primaryRetailAccountId = retailAccountIds.length ? retailAccountIds[0] : null;

    const session = await persistSession(
      {
        portalUserId: activePortalUser.id,
        email: activePortalUser.email,
        username: activePortalUser.username,
        retailAccountIds,
        classicAccountIds,
      },
      req
    );

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
      portalUserId: activePortalUser.id,
      accountId: primaryRetailAccountId,
      email: activePortalUser.email,
      username: activePortalUser.username,
      retailAccountIds,
      classicAccountIds,
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
    const session = await loadSession(req);
    const token = session?.token || getSessionToken(req);
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
  const retailAccountIds = req.session?.getRetailAccountIds?.() || [];
  const classicAccountIds = req.session?.getClassicAccountIds?.() || [];
  res.json({
    ok: true,
    session: {
      portalUserId: req.session.portal_user_id,
      accountId: req.session.account_id ?? (retailAccountIds[0] ?? null),
      email: req.session.email,
      username: req.session.username,
      retailAccountIds,
      classicAccountIds,
      gmAccess: {
        retail: cloneGmInfo(req.session.retailGmInfo),
        classic: cloneGmInfo(req.session.classicGmInfo),
      },
      expiresAt: req.session.expires_at,
    },
  });
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

    const portalUserId = req.session?.portal_user_id;
    if (portalUserId == null) {
      return res.status(400).json({ error: 'Missing portal session.' });
    }

    const portalUser = await getPortalUserById(portalUserId);
    if (!portalUser) {
      return res.status(404).json({ error: 'Portal account not found.' });
    }

    await updatePortalAndLinkedPasswords({ portalUser, newPassword });

    return res.json({ ok: true });
  } catch (e) {
    console.error('Account password reset failed', e);
    return res.status(500).json({ error: 'Unable to reset password at this time.' });
  }
});

async function handleLinkAccountRequest(req, res, forcedGameType) {
  try {
    const portalUserId = req.session?.portal_user_id;
    if (portalUserId == null) {
      return res.status(400).json({ error: 'Missing portal session.' });
    }
    const { password, username, gameType: rawGameType } = req.body || {};
    const resolvedType = forcedGameType || (typeof rawGameType === 'string' && rawGameType.trim().toLowerCase() === 'classic'
      ? 'classic'
      : 'retail');
    const result = await linkPortalAccounts({
      portalUserId,
      password,
      username,
      gameType: resolvedType,
    });
    await updateSessionAccountLinks(req.session, {
      retailAccountIds: result.retailAccountIds,
      classicAccountIds: result.classicAccountIds,
    });
    return res.json({ ok: true, linked: result.linked });
  } catch (err) {
    if (err instanceof PortalHttpError) {
      return res.status(err.statusCode || 400).json({ error: err.message });
    }
    console.error('Link account failed', err);
    return res.status(500).json({ error: 'Unable to link account right now.' });
  }
}

app.post('/api/account/link/retail', requireSession, linkAccountLimiter, (req, res) =>
  handleLinkAccountRequest(req, res, 'retail')
);
app.post('/api/account/link/classic', requireSession, linkAccountLimiter, (req, res) =>
  handleLinkAccountRequest(req, res, 'classic')
);
app.post('/api/account/link-game', requireSession, linkAccountLimiter, (req, res) =>
  handleLinkAccountRequest(req, res)
);

app.get('/api/characters', requireSession, async (req, res) => {
  try {
    const retailAccountIds = req.session?.getRetailAccountIds?.() || [];
    const classicAccountIds = req.session?.getClassicAccountIds?.() || [];
    const hasAccounts = retailAccountIds.length || classicAccountIds.length;
    const cacheKey = hasAccounts
      ? `retail:${retailAccountIds.join(',')}|classic:${classicAccountIds.join(',')}`
      : null;
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

    const payload = await buildCharactersResponse({ retailAccountIds, classicAccountIds });

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

app.post('/api/gm/command', requireSession, requireGmCommandAccess, async (req, res) => {
  const realm = req.gmRealm || normalizeRealmInput(req.body?.realm, 'retail') || 'retail';
  const { context } = req.body || {};
  let safeCommand;
  try {
    safeCommand = sanitizeSoapCommand(req.body?.command);
  } catch (err) {
    return res.status(400).json({ error: err?.message || 'Invalid command' });
  }
  const sanitizedContext = typeof context === 'string' ? context.trim().slice(0, 200) : null;
  const exec = realm === 'classic' ? executeClassicCommand : executeRetailCommand;
  const soapConfig = realm === 'classic' ? CLASSIC_SOAP : SOAP;
  const portalUserId = req.session?.portal_user_id;
  const buildResponsePayload = (result) => ({
    return: result?.ret ?? result?.return ?? null,
    raw: result?.raw ?? null,
  });
  try {
    const result = await exec({ soap: soapConfig, command: safeCommand });
    await recordPortalAuditEvent({
      portalUserId,
      action: 'gm:command',
      details: {
        realm,
        command: safeCommand,
        context: sanitizedContext || undefined,
        ok: true,
        ret: typeof result?.ret === 'string' ? result.ret.slice(0, 512) : result?.ret ?? null,
      },
    });
    return res.json({
      ok: true,
      realm,
      command: safeCommand,
      response: buildResponsePayload(result),
    });
  } catch (err) {
    console.error('GM SOAP command failed', err);
    const soapFault = typeof err?.soapBody === 'string' ? err.soapBody : null;
    await recordPortalAuditEvent({
      portalUserId,
      action: 'gm:command',
      details: {
        realm,
        command: safeCommand,
        context: sanitizedContext || undefined,
        ok: false,
        error: err?.message || 'SOAP fault',
      },
    });
    const status = err?.name === 'SOAPFault' ? 400 : 500;
    return res.status(status).json({
      error: err?.message || 'Command failed',
      realm,
      command: safeCommand,
      response: soapFault ? { raw: soapFault } : undefined,
    });
  }
});

app.get('/api/gm/commands', requireSession, requireGmCommandQueryAccess, async (req, res) => {
  const realm = req.gmRealm || 'retail';
  try {
    const commands = await loadGmCommandReference(realm);
    return res.json({
      ok: true,
      realm,
      total: commands.length,
      commands,
    });
  } catch (err) {
    console.error('Failed to load GM command reference', err);
    return res.status(503).json({ error: 'Command reference unavailable' });
  }
});

app.get('/api/gm/online/classic', requireSession, requireGm({ realm: 'classic' }), async (req, res) => {
  try {
    if (!classicCharPool) {
      return res.status(503).json({ error: 'Classic character database unavailable' });
    }
    const limit = Math.max(Number(CONFIG.GM_CLASSIC_ONLINE_LIMIT) || 12, 1);
    const [rows] = await classicCharPool.execute(
      'SELECT name, account, race, class, level FROM characters WHERE online = 1 ORDER BY name ASC LIMIT ?',
      [limit]
    );
    const accountIds = [...new Set(rows.map((row) => toSafeNumber(row.account)).filter((id) => id != null))];
    const accountMeta = new Map();
    if (accountIds.length) {
      const placeholders = accountIds.map(() => '?').join(',');
      const [accounts] = await classicAuthPool.execute(
        `SELECT id, username FROM account WHERE id IN (${placeholders})`,
        accountIds
      );
      for (const row of accounts) {
        const id = toSafeNumber(row.id);
        if (id == null) continue;
        accountMeta.set(id, {
          accountName: row.username || null,
          gmLevel: null,
        });
      }
      const gmFlags = await loadGmFlagsForAccounts({ type: 'classic', accountIds });
      for (const [rawId, info] of Object.entries(gmFlags || {})) {
        const id = toSafeNumber(rawId);
        if (id == null) continue;
        const gmLevel =
          toSafeNumber(
            info?.gmlevel ?? info?.gmLevel ?? info?.GMLevel ?? info?.securitylevel ?? info?.SecurityLevel
          ) ?? 0;
        const existing = accountMeta.get(id) || {};
        accountMeta.set(id, {
          ...existing,
          gmLevel,
        });
      }
    }
    const now = Date.now();
    const characters = rows.map((row) => {
      const accountId = toSafeNumber(row.account);
      const meta = accountId != null ? accountMeta.get(accountId) : null;
      return {
        name: row.name,
        accountId,
        accountName: meta?.accountName || null,
        gmLevel: meta?.gmLevel ?? null,
        race: toSafeNumber(row.race) ?? null,
        class: toSafeNumber(row.class) ?? null,
        level: toSafeNumber(row.level) ?? null,
      };
    });
    return res.json({
      ok: true,
      realm: 'classic',
      count: characters.length,
      refreshedAt: now,
      refreshedAtIso: new Date(now).toISOString(),
      characters,
    });
  } catch (err) {
    console.error('Classic GM online lookup failed', err);
    return res.status(500).json({ error: 'Unable to load Classic roster.' });
  }
});

app.get('/api/gm/classic/armors/search', requireSession, requireGm({ realm: 'classic' }), async (req, res) => {
  try {
    if (!classicWorldPool) {
      return res.status(503).json({ error: 'Classic world database unavailable' });
    }
    const rawQuery = typeof req.query?.q === 'string' ? req.query.q.trim() : '';
    const searchQuery = rawQuery ? rawQuery.slice(0, 64) : '';
    const page = Math.max(Number(req.query?.page) || 1, 1);
    const requestedPageSize = Number(req.query?.pageSize);
    const pageSize = Math.min(Math.max(Number.isFinite(requestedPageSize) ? requestedPageSize : 25, 1), 100);
    const subclassFilter = toSafeNumber(req.query?.armorType ?? req.query?.subclass);
    const slotFilter = toSafeNumber(req.query?.slot ?? req.query?.InventoryType);
    const offset = (page - 1) * pageSize;
    const limit = pageSize + 1;
    const clauses = ['class = 4'];
    const params = [];
    if (searchQuery) {
      clauses.push('name LIKE ?');
      params.push(`%${searchQuery}%`);
    }
    if (subclassFilter != null) {
      clauses.push('subclass = ?');
      params.push(subclassFilter);
    }
    if (slotFilter != null) {
      clauses.push('InventoryType = ?');
      params.push(slotFilter);
    }
    params.push(limit, offset);
    const whereSql = clauses.join(' AND ');
    const [rows] = await classicWorldPool.execute(
      `SELECT entry, name, class, subclass, InventoryType, Quality, ItemLevel, RequiredLevel, Armor
       FROM item_template
       WHERE ${whereSql}
       ORDER BY ItemLevel DESC, RequiredLevel DESC, Quality DESC, name ASC
       LIMIT ? OFFSET ?`,
      params
    );
    const hasMore = rows.length > pageSize;
    const items = hasMore ? rows.slice(0, pageSize) : rows;
    return res.json({ ok: true, items, page, pageSize, hasMore });
  } catch (err) {
    console.error('Classic armor search failed', err);
    return res.status(500).json({ error: 'Unable to search armors right now.' });
  }
});

app.get('/api/gm/classic/armors/:entry', requireSession, requireGm({ realm: 'classic' }), async (req, res) => {
  try {
    if (!classicWorldPool) {
      return res.status(503).json({ error: 'Classic world database unavailable' });
    }
    const entry = toSafeNumber(req.params?.entry);
    if (!Number.isFinite(entry) || entry <= 0) {
      return res.status(400).json({ error: 'Invalid entry id' });
    }
    const [rows] = await classicWorldPool.execute('SELECT * FROM item_template WHERE entry = ? AND class = 4 LIMIT 1', [entry]);
    if (!rows.length) {
      return res.status(404).json({ error: 'Item not found' });
    }
    return res.json({ ok: true, armor: rows[0] });
  } catch (err) {
    console.error('Classic armor lookup failed', err);
    return res.status(500).json({ error: 'Unable to load armor right now.' });
  }
});

app.post('/api/gm/classic/armors/:entry/clone', requireSession, requireGm({ realm: 'classic' }), async (req, res) => {
  if (!classicWorldPool) {
    return res.status(503).json({ error: 'Classic world database unavailable' });
  }
  const sourceEntry = toSafeNumber(req.params?.entry);
  if (!Number.isFinite(sourceEntry) || sourceEntry <= 0) {
    return res.status(400).json({ error: 'Invalid base entry id' });
  }
  try {
    const [rows] = await classicWorldPool.execute('SELECT * FROM item_template WHERE entry = ? AND class = 4 LIMIT 1', [sourceEntry]);
    if (!rows.length) {
      return res.status(404).json({ error: 'Item not found' });
    }
    const baseItem = rows[0];
    let connection;
    try {
      connection = await classicWorldPool.getConnection();
      await connection.beginTransaction();
      const newEntry = await allocateClassicCustomArmorEntry(connection);
      const overrides = req.body && typeof req.body === 'object' ? req.body.fields || req.body : {};
      const { clone, overriddenFields } = applyItemTemplateOverrides(baseItem, overrides, { entry: newEntry });
      clone.class = 4;
      ensureClassicArmorCloneValid(clone);
      const insertColumns = ITEM_TEMPLATE_COLUMNS.join(', ');
      const placeholders = ITEM_TEMPLATE_COLUMNS.map(() => '?').join(', ');
      const values = ITEM_TEMPLATE_COLUMNS.map((column) => clone[column]);
      await connection.execute(`INSERT INTO item_template (${insertColumns}) VALUES (${placeholders})`, values);
      await connection.commit();
      await recordPortalAuditEvent({
        portalUserId: req.session?.portal_user_id,
        action: 'gm:classic-armor-clone',
        details: {
          sourceEntry,
          newEntry,
          name: clone.name,
          overriddenFields,
        },
      });
      return res.json({ ok: true, entry: newEntry, name: clone.name, sourceEntry });
    } catch (err) {
      if (connection) {
        try {
          await connection.rollback();
        } catch (rollbackErr) {
          console.error('Classic armor clone rollback failed', rollbackErr);
        }
      }
      if (err instanceof PortalHttpError) {
        return res.status(err.statusCode || 400).json({ error: err.message });
      }
      console.error('Classic armor clone failed', err);
      return res.status(500).json({ error: 'Unable to clone armor right now.' });
    } finally {
      connection?.release();
    }
  } catch (err) {
    if (err instanceof PortalHttpError) {
      return res.status(err.statusCode || 400).json({ error: err.message });
    }
    console.error('Classic armor clone setup failed', err);
    return res.status(500).json({ error: 'Unable to prepare armor clone.' });
  }
});

app.get('/api/gm/classic/weapons/search', requireSession, requireGm({ realm: 'classic' }), async (req, res) => {
  try {
    if (!classicWorldPool) {
      return res.status(503).json({ error: 'Classic world database unavailable' });
    }
    const rawQuery = typeof req.query?.q === 'string' ? req.query.q.trim() : '';
    const searchQuery = rawQuery ? rawQuery.slice(0, 64) : '';
    const page = Math.max(Number(req.query?.page) || 1, 1);
    const requestedPageSize = Number(req.query?.pageSize);
    const pageSize = Math.min(Math.max(Number.isFinite(requestedPageSize) ? requestedPageSize : 25, 1), 100);
    const qualityFilter = toSafeNumber(req.query?.quality);
    const subclassFilter = toSafeNumber(req.query?.subclass);
    const offset = (page - 1) * pageSize;
    const limit = pageSize + 1;
    const clauses = ['class = 2'];
    const params = [];
    if (searchQuery) {
      clauses.push('name LIKE ?');
      params.push(`%${searchQuery}%`);
    }
    if (qualityFilter != null && qualityFilter >= 0 && qualityFilter <= 7) {
      clauses.push('Quality = ?');
      params.push(qualityFilter);
    }
    if (subclassFilter != null && subclassFilter >= 0) {
      clauses.push('subclass = ?');
      params.push(subclassFilter);
    }
    params.push(limit, offset);
    const whereSql = clauses.join(' AND ');
    const [rows] = await classicWorldPool.execute(
      `SELECT entry, name, Quality, class, subclass, ItemLevel, RequiredLevel, InventoryType, displayid
       FROM item_template
       WHERE ${whereSql}
       ORDER BY Quality DESC, ItemLevel DESC, name ASC
       LIMIT ? OFFSET ?`,
      params
    );
    const hasMore = rows.length > pageSize;
    const items = hasMore ? rows.slice(0, pageSize) : rows;
    return res.json({ ok: true, items, page, pageSize, hasMore });
  } catch (err) {
    console.error('Classic weapon search failed', err);
    return res.status(500).json({ error: 'Unable to search weapons right now.' });
  }
});

app.get('/api/gm/classic/weapons/:entry', requireSession, requireGm({ realm: 'classic' }), async (req, res) => {
  try {
    if (!classicWorldPool) {
      return res.status(503).json({ error: 'Classic world database unavailable' });
    }
    const entry = toSafeNumber(req.params?.entry);
    if (!Number.isFinite(entry) || entry <= 0) {
      return res.status(400).json({ error: 'Invalid entry id' });
    }
    const [rows] = await classicWorldPool.execute('SELECT * FROM item_template WHERE entry = ?', [entry]);
    if (!rows.length) {
      return res.status(404).json({ error: 'Item not found' });
    }
    return res.json({ ok: true, item: rows[0] });
  } catch (err) {
    console.error('Classic weapon lookup failed', err);
    return res.status(500).json({ error: 'Unable to load weapon right now.' });
  }
});

app.post('/api/gm/classic/weapons/:entry/clone', requireSession, requireGm({ realm: 'classic' }), async (req, res) => {
  if (!classicWorldPool) {
    return res.status(503).json({ error: 'Classic world database unavailable' });
  }
  const sourceEntry = toSafeNumber(req.params?.entry);
  if (!Number.isFinite(sourceEntry) || sourceEntry <= 0) {
    return res.status(400).json({ error: 'Invalid base entry id' });
  }
  try {
    const [rows] = await classicWorldPool.execute('SELECT * FROM item_template WHERE entry = ?', [sourceEntry]);
    if (!rows.length) {
      return res.status(404).json({ error: 'Item not found' });
    }
    const baseItem = rows[0];
    const baseClass = toSafeNumber(baseItem.class);
    if (baseClass !== 2) {
      return res.status(400).json({ error: 'Only weapon templates can be cloned with this tool.' });
    }
    const overrides = req.body && typeof req.body === 'object' ? req.body : {};
    let connection;
    try {
      connection = await classicWorldPool.getConnection();
      await connection.beginTransaction();
      const [rangeRows] = await connection.execute(
        'SELECT entry FROM item_template WHERE entry BETWEEN ? AND ? ORDER BY entry DESC LIMIT 1 FOR UPDATE',
        [CLASSIC_CUSTOM_ITEM_MIN, CLASSIC_CUSTOM_ITEM_MAX]
      );
      const lastEntry = rangeRows.length ? toSafeNumber(rangeRows[0].entry) : null;
      const newEntry = lastEntry == null ? CLASSIC_CUSTOM_ITEM_MIN : lastEntry + 1;
      if (!Number.isFinite(newEntry) || newEntry > CLASSIC_CUSTOM_ITEM_MAX) {
        await connection.rollback();
        return res.status(409).json({ error: 'Custom item range exhausted' });
      }
      const { clone, overriddenFields } = applyItemTemplateOverrides(baseItem, overrides, { entry: newEntry });
      ensureClassicWeaponCloneValid(clone);
      const insertColumns = ITEM_TEMPLATE_COLUMNS.join(', ');
      const placeholders = ITEM_TEMPLATE_COLUMNS.map(() => '?').join(', ');
      const values = ITEM_TEMPLATE_COLUMNS.map((column) => clone[column]);
      await connection.execute(`INSERT INTO item_template (${insertColumns}) VALUES (${placeholders})`, values);
      await connection.commit();
      await recordPortalAuditEvent({
        portalUserId: req.session?.portal_user_id,
        action: 'gm:classic-weapon-clone',
        details: {
          sourceEntry,
          newEntry,
          name: clone.name,
          overriddenFields,
        },
      });
      return res.json({ ok: true, entry: newEntry, name: clone.name, sourceEntry });
    } catch (err) {
      if (connection) {
        try {
          await connection.rollback();
        } catch (rollbackErr) {
          console.error('Classic weapon clone rollback failed', rollbackErr);
        }
      }
      if (err instanceof PortalHttpError) {
        return res.status(err.statusCode || 400).json({ error: err.message });
      }
      console.error('Classic weapon clone failed', err);
      return res.status(500).json({ error: 'Unable to clone weapon right now.' });
    } finally {
      connection?.release();
    }
  } catch (err) {
    if (err instanceof PortalHttpError) {
      return res.status(err.statusCode || 400).json({ error: err.message });
    }
    console.error('Classic weapon clone setup failed', err);
    return res.status(500).json({ error: 'Unable to prepare weapon clone.' });
  }
});

// ----- API: Register -----
app.post('/api/register', limiter, async (req, res) => {
  try {
    const { password, email: rawEmail, cfToken, gameType: rawGameType } = req.body || {};
    const email = normalizeEmail(rawEmail);
    const normalizedGameType = typeof rawGameType === 'string' ? rawGameType.trim().toLowerCase() : '';
    const gameType = normalizedGameType === 'classic' ? 'classic' : 'retail';
    const gameLabel = gameType === 'classic' ? CONFIG.CLASSIC_BRAND_NAME : CONFIG.BRAND_NAME;

    if (!isValidPassword(password)) return badRequest(res, 'Invalid password');
    if (!isValidEmail(email)) return badRequest(res, 'Invalid email');

    const existingPortalUser = await getPortalUserByEmail(email);
    if (existingPortalUser) {
      return res.status(400).json({ error: 'You already have a portal account, please login instead.' });
    }

    const ok = await verifyTurnstile(cfToken, req.ip, CONFIG.TURNSTILE_SECRET);
    if (!ok) return badRequest(res, 'CAPTCHA failed');

    // Upsert a single pending row per email (prevents duplicate verify links)
    const token = crypto.randomBytes(24).toString('hex');
    const now = Date.now();
    const safeUser = email.split('@')[0].slice(0, CONFIG.MAX_USER) || 'player';
    await pool.execute(
      'INSERT INTO pending (token, username, password, email, game_type, created_at) VALUES (?, ?, ?, ?, ?, ?)\n       ON DUPLICATE KEY UPDATE token = VALUES(token), username = VALUES(username), password = VALUES(password), game_type = VALUES(game_type), created_at = VALUES(created_at)',
      [token, safeUser, password, email, gameType, now]
    );

    const verifyUrl = `${CONFIG.BASE_URL}/verify?token=${token}`;
    const safeEmail = escapeHtml(email);
    const html = renderTransactionalEmail({
      title: `${gameLabel} — Verify your email`,
      intro: `You're almost ready to enter ${gameLabel}.`,
      paragraphs: [
        `Complete the signup for ${safeEmail} within ${CONFIG.TOKEN_TTL_MIN} minutes to activate your DreamCore ${gameLabel} login.`,
        'Need the other realm too? The DreamCore Master portal lets you create both Retail and Classic credentials from the same place.',
        'If you did not start this registration, you can safely ignore this message.',
      ],
      button: { href: verifyUrl, label: 'Finish registration' },
    });
    const text = [
      `${gameLabel}: verify your email`,
      `Finish creating the account for ${email} by visiting: ${verifyUrl}`,
      `This link expires in ${CONFIG.TOKEN_TTL_MIN} minutes.`,
      'Remember: this same portal can mint both DreamCore Master (retail) and DreamCore Classic accounts whenever you need them.',
      '',
      `If you did not request this, you can ignore this email.`,
    ].join('\n');

    await transporter.sendMail({
      to: email,
      from: CONFIG.FROM_EMAIL,
      subject: `DreamCore Portal: confirm your ${gameLabel} account`,
      html,
      text,
    });

    return res.json({ ok: true });
  } catch (e) {
    console.error(e);
    return res.status(500).json({ error: 'Server error' });
  }
});

app.post('/api/classic/register', limiter, async (req, res) => {
  try {
    const { password, email: rawEmail, cfToken } = req.body || {};
    const email = normalizeEmail(rawEmail);

    if (!isValidPassword(password)) return badRequest(res, 'Invalid password');
    if (!isValidEmail(email)) return badRequest(res, 'Invalid email');

    const existingPortalUser = await getPortalUserByEmail(email);
    if (existingPortalUser) {
      return res.status(400).json({ error: 'You already have a portal account, please login instead.' });
    }

    const ok = await verifyTurnstile(cfToken, req.ip, CONFIG.CLASSIC_TURNSTILE_SECRET);
    if (!ok) return badRequest(res, 'CAPTCHA failed');

    const token = crypto.randomBytes(24).toString('hex');
    const now = Date.now();
    const safeUser = email.split('@')[0].slice(0, CONFIG.MAX_USER) || 'player';
    await classicPool.execute(
      'INSERT INTO pending_classic (token, username, password, email, created_at) VALUES (?, ?, ?, ?, ?)\n       ON DUPLICATE KEY UPDATE token = VALUES(token), username = VALUES(username), password = VALUES(password), created_at = VALUES(created_at)',
      [token, safeUser, password, email, now]
    );

    const base = (CONFIG.CLASSIC_BASE_URL || `${CONFIG.BASE_URL}/classic`).replace(/\/+$/, '');
    const verifyUrl = `${base || `${CONFIG.BASE_URL}/classic`}/verify?token=${token}`;
    const safeEmail = escapeHtml(email);
    const html = renderTransactionalEmail({
      title: `${CONFIG.CLASSIC_BRAND_NAME} — Verify your email`,
      intro: `You're almost ready to enter ${CONFIG.CLASSIC_BRAND_NAME}.`,
      paragraphs: [
        `Complete the signup for ${safeEmail} within ${CONFIG.TOKEN_TTL_MIN} minutes to activate your login.`,
        'The DreamCore Master portal now provisions both Retail and Classic accounts—just choose the realm you need.',
        'If you did not start this registration, you can safely ignore this message.',
      ],
      button: { href: verifyUrl, label: 'Finish registration' },
    });
    const text = [
      `${CONFIG.CLASSIC_BRAND_NAME}: verify your email`,
      `Finish creating the account for ${email} by visiting: ${verifyUrl}`,
      `This link expires in ${CONFIG.TOKEN_TTL_MIN} minutes.`,
      'One secure portal handles DreamCore Master and DreamCore Classic logins whenever you need them.',
      '',
      `If you did not request this, you can ignore this email.`,
    ].join('\n');

    await transporter.sendMail({
      to: email,
      from: CONFIG.FROM_EMAIL,
      subject: `${CONFIG.CLASSIC_BRAND_NAME}: confirm your account`,
      html,
      text,
    });

    return res.json({ ok: true });
  } catch (e) {
    console.error(e);
    return res.status(500).json({ error: 'Server error' });
  }
});

app.post('/api/password-reset/request', passwordResetLimiter, async (req, res) => {
  try {
    const { email: rawEmail } = req.body || {};
    const email = normalizeEmail(rawEmail);
    if (!isValidEmail(email)) {
      return badRequest(res, 'Invalid email');
    }
    const portalUser = await getPortalUserByEmail(email);
    if (!portalUser) {
      return res.json({ ok: true });
    }
    await pool.execute('DELETE FROM password_resets WHERE email = ?', [portalUser.email]);
    const token = crypto.randomBytes(32).toString('hex');
    const now = Date.now();
    const expiresAt = now + RESET_TOKEN_TTL_MS;
    await pool.execute('INSERT INTO password_resets (token, email, created_at, expires_at) VALUES (?, ?, ?, ?)', [
      token,
      portalUser.email,
      now,
      expiresAt,
    ]);
    const base = (CONFIG.BASE_URL || '').replace(/\/+$/, '');
    const resetUrl = `${base || CONFIG.BASE_URL}/reset-password?token=${token}`;
    const safeEmail = escapeHtml(portalUser.email);
    const html = renderTransactionalEmail({
      title: `${CONFIG.BRAND_NAME} — Reset your password`,
      intro: `We received a request to reset the DreamCore portal password for ${safeEmail}.`,
      paragraphs: [
        `Use the secure button within ${CONFIG.RESET_TOKEN_TTL_MIN} minutes to choose a new password.`,
        'This update refreshes any linked DreamCore Master or DreamCore Classic logins tied to this portal.',
      ],
      button: { href: resetUrl, label: 'Set a new password' },
      footerLines: ['If you did not request this, you can safely ignore this email.'],
    });
    const text = [
      'DreamCore Portal — Reset your password',
      `We received a request to reset the DreamCore portal password for ${portalUser.email}.`,
      `Use this link within ${CONFIG.RESET_TOKEN_TTL_MIN} minutes: ${resetUrl}`,
      'This update also refreshes any linked DreamCore Master or Classic logins.',
      'If you did not make this request, ignore this email.',
    ].join('\n\n');
    await transporter.sendMail({
      to: portalUser.email,
      from: CONFIG.FROM_EMAIL,
      subject: `${CONFIG.BRAND_NAME}: reset your password`,
      html,
      text,
    });
    return res.json({ ok: true });
  } catch (e) {
    console.error('Password reset request failed', e);
    return res.status(500).json({ error: 'Unable to process password reset request.' });
  }
});

app.post('/api/password-reset/confirm', passwordResetLimiter, async (req, res) => {
  try {
    const { token, password } = req.body || {};
    if (typeof token !== 'string' || !token.trim()) {
      return badRequest(res, 'Missing token');
    }
    if (!isValidPassword(password)) {
      return badRequest(
        res,
        `Password must be at least ${CONFIG.MIN_PASS} characters with no spaces or quotes.`
      );
    }
    const [rows] = await pool.execute(
      'SELECT email, expires_at FROM password_resets WHERE token = ? LIMIT 1',
      [token]
    );
    const row = Array.isArray(rows) ? rows[0] : null;
    if (!row || row.expires_at < Date.now()) {
      await pool.execute('DELETE FROM password_resets WHERE token = ?', [token]);
      return badRequest(res, 'Reset link is invalid or expired.');
    }
    const portalUser = await getPortalUserByEmail(row.email);
    if (!portalUser) {
      await pool.execute('DELETE FROM password_resets WHERE token = ?', [token]);
      return badRequest(res, 'Reset link is invalid or expired.');
    }
    await updatePortalAndLinkedPasswords({ portalUser, newPassword: password });
    await pool.execute('DELETE FROM password_resets WHERE email = ?', [portalUser.email]);
    return res.json({ ok: true });
  } catch (e) {
    console.error('Password reset confirmation failed', e);
    return res.status(500).json({ error: 'Unable to update password at this time.' });
  }
});
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

    const rowGameType = typeof row.game_type === 'string' ? row.game_type.trim().toLowerCase() : '';
    const isClassic = rowGameType === 'classic';
    const brandConfig = isClassic
      ? {
          brand: CONFIG.CLASSIC_BRAND_NAME,
          guideUrl: CONFIG.CLASSIC_GUIDE_URL,
          cornerLogo: CONFIG.CLASSIC_CORNER_LOGO,
          successTitle: 'Your DreamCore Classic account is ready!',
          successMessage: 'Your DreamCore Classic credentials are now active and linked to this portal.',
        }
      : {
          brand: CONFIG.BRAND_NAME,
          guideUrl: CONFIG.GUIDE_URL,
          cornerLogo: CONFIG.CORNER_LOGO,
          successTitle: 'Your account is ready!',
          successMessage: 'Your Battle.net-style DreamCore Master account has been created.',
        };

    const portalUserId = await upsertPortalUser({
      email: row.email,
      password: row.password,
      username: row.username,
    });
    if (!portalUserId) {
      return res
        .status(500)
        .type('text/html')
        .send(
          VERIFY_PAGE({
            cornerLogo: brandConfig.cornerLogo,
            state: 'error',
            title: 'Unable to save your portal login',
            message: 'We could not finish linking your credentials to the DreamCore portal. Please try again shortly.',
            steps: [
              'Submit the registration form again to receive a new verification link.',
              'If the problem persists, open a support ticket so we can assist manually.',
            ],
          })
        );
    }

    let ensureResult = null;
    let reusedClassicAccount = false;
    try {
      if (isClassic) {
        ensureResult = await ensureClassicAccount({
          soap: CLASSIC_SOAP,
          email: row.email,
          username: row.username,
          password: row.password,
          debug: CONFIG.SOAP_DEBUG,
        });
      } else {
        ensureResult = await ensureRetailAccount({
          soap: SOAP,
          email: row.email,
          password: row.password,
          debug: CONFIG.SOAP_DEBUG,
        });
      }
    } catch (e) {
      if (isClassic && e?.code === 'CLASSIC_ACCOUNT_EXISTS') {
        reusedClassicAccount = true;
        const existingClassic = await resolveClassicAccountLink({
          username: row.username,
          email: row.email,
        });
        if (existingClassic?.accountId != null) {
          ensureResult = {
            accountId: existingClassic.accountId,
            username: existingClassic.username || row.username,
          };
        } else {
          console.error('Classic account reported as existing but could not be located');
          return res
            .status(502)
            .type('text/html')
            .send(
              VERIFY_PAGE({
                cornerLogo: brandConfig.cornerLogo,
                state: 'error',
                title: 'Classic account already exists',
                message:
                  'We detected an existing DreamCore Classic account for this email but could not link it automatically. Please open a support ticket so we can connect it for you.',
                steps: [
                  'Include the email used for registration and let us know you saw this message.',
                  'We will attach your Classic login to the DreamCore portal manually.',
                ],
              })
            );
        }
      } else {
        console.error('SOAP create failed:', e);
        return res
          .status(502)
          .type('text/html')
          .send(
            VERIFY_PAGE({
              cornerLogo: brandConfig.cornerLogo,
              state: 'error',
              title: 'Unable to finalize your account',
              message: isClassic
                ? 'We could not create your DreamCore Classic account. Please try again in a minute.'
                : 'We could not create your Battle.net account. Please try again in a minute.',
              steps: [
                'If it keeps failing, open a support ticket and include this error:',
                String(e?.message || e),
              ],
            })
          );
      }
    }

    await pool.execute('DELETE FROM pending WHERE token = ?', [token]);

    if (isClassic) {
      let classicAccount = null;
      if (ensureResult?.accountId != null) {
        classicAccount = {
          accountId: ensureResult.accountId,
          username: ensureResult.username || row.username,
        };
      } else {
        classicAccount = await resolveClassicAccountLink({
          username: row.username,
          email: row.email,
        });
      }
      const classicAccountId = classicAccount?.accountId ?? null;
      if (classicAccountId != null) {
        await linkPortalUserToClassicAccount(portalUserId, classicAccountId, { linkedAt: Date.now() });
      }
    } else {
      const [createdPrimary, createdFallback] = await Promise.all([
        getAuthAccountByEmail(row.email),
        getGameAccountByEmail(row.email),
      ]);
      const retailAccountId = createdPrimary?.id ?? createdFallback?.id ?? null;
      if (retailAccountId != null) {
        await linkPortalUserToRetailAccount(portalUserId, retailAccountId, { linkedAt: Date.now() });
      }
    }

    const verificationSuccessMessage =
      isClassic && reusedClassicAccount
        ? 'Your DreamCore Classic login was already active. We linked it to your portal account so you can manage it from the dashboard.'
        : brandConfig.successMessage;

    const steps = [
      {
        number: 'Step 2',
        title: 'Verification complete!',
        body: isClassic
          ? [
              reusedClassicAccount
                ? 'These DreamCore Classic credentials already existed, so we linked them to your portal automatically.'
                : `Sign in with ${escapeHtml(row.email)} using the password you chose during sign-up.`,
              'Your DreamCore portal login now manages both Classic and Retail credentials.',
            ]
          : [
              `Sign in with ${escapeHtml(row.email)}.`,
              'Use this same portal whenever you want to create a DreamCore Classic login.',
            ],
      },
      {
        number: 'Step 3',
        title: isClassic ? 'Download & connect' : 'Install & connect',
        body: [
          isClassic
            ? 'Download the DreamCore Classic client below, extract it, and log in with your new credentials.'
            : 'Follow the installation guide below to set up DreamCore on your system.',
        ],
        cta: isClassic
          ? {
              href: CONFIG.CLASSIC_CLIENT_DOWNLOAD_URL,
              label: 'Download DreamCore Classic client',
            }
          : {
              href: brandConfig.guideUrl,
              label: 'Open installation guide',
            },
      },
    ];

    return res
      .type('text/html')
      .send(
        VERIFY_PAGE({
          cornerLogo: brandConfig.cornerLogo,
          state: 'success',
          title: brandConfig.successTitle,
          message: verificationSuccessMessage,
          successSteps: steps,
          successFooter:
            'Need the other realm? Return to the <a class="font-semibold text-indigo-200 hover:text-white" href="/login">DreamCore Master portal</a> any time to spin up Retail or Classic accounts from the same login.',
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

app.get('/classic/verify', async (req, res) => {
  try {
    const token = String(req.query.token || '');
    if (!token) {
      return res
        .status(400)
        .type('text/html')
        .send(
          VERIFY_PAGE({
            cornerLogo: CONFIG.CLASSIC_CORNER_LOGO,
            state: 'error',
            title: 'Invalid verification link',
            message: 'The verification link is missing a token or was formatted incorrectly.',
            steps: [
              'Return to the DreamCore Classic registration page and request a new verification email.',
              'If you continue to see this message, contact support so we can assist you manually.',
            ],
          })
        );
    }

    const [rows] = await classicPool.execute('SELECT * FROM pending_classic WHERE token = ?', [token]);
    const row = Array.isArray(rows) ? rows[0] : undefined;
    if (!row) {
      return res
        .status(400)
        .type('text/html')
        .send(
          VERIFY_PAGE({
            cornerLogo: CONFIG.CLASSIC_CORNER_LOGO,
            state: 'expired',
            title: 'Verification link not found',
            message: 'This DreamCore Classic verification link has already been used or does not match any pending registration.',
            steps: [
              'Head back to the classic registration page to start a new signup.',
              'Use the most recent verification email—older links deactivate once a new one is issued.',
            ],
          })
        );
    }

    const ageMin = (Date.now() - row.created_at) / 60000;
    if (ageMin > CONFIG.TOKEN_TTL_MIN) {
      await classicPool.execute('DELETE FROM pending_classic WHERE token = ?', [token]);
      return res
        .status(400)
        .type('text/html')
        .send(
          VERIFY_PAGE({
            cornerLogo: CONFIG.CLASSIC_CORNER_LOGO,
            state: 'expired',
            title: 'Verification link expired',
            message: `This link expired after ${CONFIG.TOKEN_TTL_MIN} minutes for your security.`,
            steps: [
              'Revisit the classic registration page and submit the form again to receive a fresh email.',
              'Complete verification promptly to finalize your DreamCore Classic account.',
            ],
          })
        );
    }

    const portalUserId = await upsertPortalUser({
      email: row.email,
      password: row.password,
      username: row.username,
    });
    if (!portalUserId) {
      return res
        .status(500)
        .type('text/html')
        .send(
          VERIFY_PAGE({
            cornerLogo: CONFIG.CLASSIC_CORNER_LOGO,
            state: 'error',
            title: 'Unable to save your portal login',
            message: 'We could not link these Classic credentials to your DreamCore portal account. Please try again shortly.',
            steps: [
              'Submit the Classic registration form again to receive a new verification email.',
              'If the issue repeats, open a support ticket so we can complete it manually.',
            ],
          })
        );
    }

    let ensureResult = null;
    let reusedClassicAccount = false;
    try {
      ensureResult = await ensureClassicAccount({
        soap: CLASSIC_SOAP,
        email: row.email,
        username: row.username,
        password: row.password,
        debug: CONFIG.SOAP_DEBUG,
      });
    } catch (e) {
      if (e?.code === 'CLASSIC_ACCOUNT_EXISTS') {
        reusedClassicAccount = true;
        const existingClassic = await resolveClassicAccountLink({
          username: row.username,
          email: row.email,
        });
        if (existingClassic?.accountId != null) {
          ensureResult = {
            accountId: existingClassic.accountId,
            username: existingClassic.username || row.username,
          };
        } else {
          console.error('Classic account reported as existing but could not be located');
          return res
            .status(502)
            .type('text/html')
            .send(
              VERIFY_PAGE({
                cornerLogo: CONFIG.CLASSIC_CORNER_LOGO,
                state: 'error',
                title: 'Classic account already exists',
                message:
                  'We detected an existing DreamCore Classic account for this email but could not link it automatically. Please open a support ticket so we can connect it for you.',
                steps: [
                  'Include the email used for registration and mention this message so the support team can relink it.',
                  'We will attach your Classic login to the DreamCore portal manually.',
                ],
              })
            );
        }
      } else {
        console.error('Classic SOAP create failed:', e);
        return res
          .status(502)
          .type('text/html')
          .send(
            VERIFY_PAGE({
              cornerLogo: CONFIG.CLASSIC_CORNER_LOGO,
              state: 'error',
              title: 'Unable to finalize your account',
              message: 'We could not create your DreamCore Classic account. Please try again in a minute.',
              steps: [
                'If it keeps failing, open a support ticket and include this error:',
                String(e?.message || e),
              ],
            })
          );
      }
    }

    await classicPool.execute('DELETE FROM pending_classic WHERE token = ?', [token]);

    let classicAccount = null;
    if (ensureResult?.accountId != null) {
      classicAccount = {
        accountId: ensureResult.accountId,
        username: ensureResult.username || row.username,
      };
    } else {
      classicAccount = await resolveClassicAccountLink({
        username: row.username,
        email: row.email,
      });
    }
    const classicAccountId = classicAccount?.accountId ?? null;
    if (classicAccountId != null) {
      await linkPortalUserToClassicAccount(portalUserId, classicAccountId, { linkedAt: Date.now() });
    }

    const portalUsername = formatClassicClientUsername(row.username || row.email || '');
    const clientLoginUsername = formatClassicClientUsername(
      classicAccount?.username || row.username || row.email || ''
    );

    const loginNotices = [];
    if (portalUsername) {
      loginNotices.push({
        label: 'Portal Username',
        value: portalUsername,
        description: 'Use this to sign in to the DreamCore portal for managing your accounts.',
      });
    }
    if (clientLoginUsername) {
      loginNotices.push({
        label: 'Classic Client Username',
        value: clientLoginUsername,
        valueClass: 'client-username-glow',
        description: 'Enter this exact username (without @ or email formatting) inside the Wrath of the Lich King client.',
      });
    }

    const successMessage = reusedClassicAccount
      ? 'Your DreamCore Classic login was already active. We linked it to your portal account so you can jump in immediately.'
      : 'Your DreamCore Classic account is ready. Download the game client below to start playing.';

    return res
      .type('text/html')
      .send(
        VERIFY_PAGE({
          cornerLogo: CONFIG.CLASSIC_CORNER_LOGO,
          state: 'success',
          title: 'Verification Successful',
          message: successMessage,
          successSteps: [
            {
              number: 'Step 1',
              title: 'Save your login usernames',
              body: [
                'Your portal and Classic client usernames are ready. Keep them handy before you start downloading.',
                'Use the portal username for the DreamCore portal and the Classic username inside the Wrath of the Lich King client.',
              ],
              notice: loginNotices,
            },
            {
              number: 'Step 2',
              title: 'Download the DreamCore Classic client',
              body: [
                reusedClassicAccount
                  ? 'We detected that these Classic credentials already existed and simply linked them to your portal account.'
                  : 'Use the button below to grab the Wrath of the Lich King client that is already set up for DreamCore.',
                'After installing, launch it and log in with the account you just verified.',
              ],
              notice: clientLoginUsername
                ? {
                    label: 'Client Login Username',
                    value: clientLoginUsername,
                    valueClass: 'client-username-glow',
                    description:
                      'Do not log in with an email address in the Classic client. Use this username exactly as shown.',
                  }
                : loginNotices,
              warning:
                'Wrath of the Lich King client logins require the username only—do not include an email address or @ symbol.',
              cta: {
                href: CONFIG.CLASSIC_CLIENT_DOWNLOAD_URL,
                label: 'Download Client',
              },
            },
          ],
          successFooter:
            'This client is already configured to connect to our server, you can now login with your account info.',
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
          cornerLogo: CONFIG.CLASSIC_CORNER_LOGO,
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

function VERIFY_PAGE({ state, title, message, steps, successSteps, successFooter, cornerLogo = CONFIG.CORNER_LOGO }) {
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
            const noticesRaw = Array.isArray(step.notice)
              ? step.notice
              : step.notice && (step.notice.label || step.notice.value || step.notice.description)
                ? [step.notice]
                : [];
            const notices = noticesRaw.filter((n) => n && (n.label || n.value || n.description));
            const noticeHtml = notices.length
              ? `<div class="mt-5 rounded-2xl border border-indigo-400/40 bg-gray-900/70 p-4 text-sm text-indigo-100/90">
                  ${notices
                    .map((notice, noticeIdx) => {
                      const label = escapeHtml(String(notice.label || 'Note'));
                      const valueClass = notice.valueClass ? ` ${escapeHtml(String(notice.valueClass))}` : '';
                      const value = notice.value
                        ? `: <span class="text-white${valueClass}">${escapeHtml(String(notice.value))}</span>`
                        : '';
                      const description = notice.description
                        ? `<p class="mt-2 text-xs text-indigo-200/80">${escapeHtml(String(notice.description))}</p>`
                        : '';
                      const spacing = noticeIdx > 0 ? 'mt-3' : '';
                      return `<div class="${spacing}"><p class="font-semibold text-indigo-200">${label}${value}</p>${description}</div>`;
                    })
                    .join('')}
                </div>`
              : '';
            const warningHtml = step.warning
              ? `<p class="mt-5 rounded-2xl border border-violet-500/40 bg-purple-900/30 px-4 py-3 text-sm font-semibold blink-warning text-center">${escapeHtml(
                  String(step.warning)
                )}</p>`
              : '';
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
                ? 'rounded-3xl gradient-border bg-indigo-500/10 p-6 backdrop-blur-sm'
                : 'rounded-3xl gradient-border bg-gray-900/60 p-6 shadow-inner shadow-indigo-900/30';
            return `<section class="${wrapperClasses}"><div class="flex items-center gap-4"><span class="flex h-10 w-10 items-center justify-center rounded-full bg-gradient-to-br from-indigo-500 via-purple-500 to-blue-500 text-lg font-semibold text-white shadow-lg shadow-indigo-900/40">${number}</span><div><h2 class="text-lg font-semibold text-white">${title}</h2><p class="text-[15px] text-indigo-100/90">Follow this step before moving on.</p></div></div>${bodyHtml}${noticeHtml}${warningHtml}${cta}</section>`;
          })
          .join('')}</div>`
      : '';

  const loginButton =
    state === 'success'
      ? `<div class="mt-8 flex flex-wrap items-center gap-3">
          <a class="inline-flex items-center justify-center rounded-2xl bg-gradient-to-r from-indigo-500 via-purple-500 to-blue-500 px-5 py-3 text-[15px] font-semibold text-white shadow-lg shadow-indigo-900/40 transition hover:from-indigo-400 hover:via-purple-400 hover:to-blue-400 focus:ring-2 focus:ring-indigo-400" href="/login">Return to portal login</a>
        </div>`
      : '';

  const successFooterHtml =
    state === 'success' && successFooter
      ? `<div class="mt-10 rounded-3xl gradient-border bg-gray-900/60 p-5 text-[15px] text-indigo-100/90 shadow-inner shadow-indigo-900/20">${successFooter}</div>`
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
      background:
        radial-gradient(circle at 20% 20%, rgba(88, 28, 135, 0.35), rgba(0, 0, 0, 0)),
        linear-gradient(160deg, #010101 0%, #04000f 45%, #160027 100%);
      background-color: #010005;
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
${SHARED_STYLES}
  </style>
</head>
<body class="corner-logo-offset min-h-screen text-gray-100 flex items-center justify-center p-6 aurora relative overflow-x-hidden">
  <div class="corner-logo text-2xl sm:text-3xl font-semibold tracking-[0.3em] text-indigo-300 drop-shadow-lg uppercase">${cornerLogo}</div>
  <div class="w-full max-w-xl relative z-10">
    <div class="bg-gray-900/80 backdrop-blur-xl rounded-3xl shadow-2xl border ${tone.border} overflow-hidden">
      <div class="px-6 pt-8 pb-10 sm:px-10">
        <span class="inline-flex items-center gap-2 rounded-full bg-gradient-to-r ${tone.badgeGradient} px-4 py-1 text-xs font-semibold uppercase tracking-[0.3em] text-gray-900 shadow-lg shadow-indigo-900/30">${tone.icon} ${tone.badge}</span>
        <h1 class="mt-6 text-3xl font-semibold tracking-tight text-white">${title}</h1>
        <p class="mt-3 text-[15px] text-indigo-100/90">${safeMessage}</p>
        ${stepsList}
        ${successGuide}
        ${loginButton}
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
  try { await classicPool.execute('DELETE FROM pending_classic WHERE created_at < ?', [cutoff]); } catch (e) {
    console.error('Failed to prune classic pending tokens', e);
  }
  try { await pool.execute('DELETE FROM sessions WHERE expires_at <= ?', [now]); } catch (e) {
    console.error('Failed to prune sessions', e);
  }
  try { await pool.execute('DELETE FROM password_resets WHERE expires_at <= ?', [now]); } catch (e) {
    console.error('Failed to prune password reset tokens', e);
  }
}, 60 * 60 * 1000);

// ----- Start -----
app.listen(CONFIG.PORT, () => {
  console.log(`\n✔ ${CONFIG.BRAND_NAME} registration app listening on :${CONFIG.PORT}`);
  console.log(`   Public URL (BASE_URL): ${CONFIG.BASE_URL}`);
  console.log(`   Turnstile sitekey: ${CONFIG.TURNSTILE_SITEKEY}`);
  console.log(`   Classic portal URL: ${CONFIG.CLASSIC_BASE_URL}`);
  console.log(`   Classic SOAP endpoint: ${CLASSIC_SOAP.host}:${CLASSIC_SOAP.port}`);
  console.log(`\nExample systemd unit (save as /etc/systemd/system/tc-register.service):\n`);
  console.log(`[Unit]\nDescription=TrinityCore Self-Serve Registration\nAfter=network.target\n\n[Service]\nType=simple\nWorkingDirectory=${process.cwd()}\nExecStart=/usr/bin/node ${process.cwd()}/server.js\nRestart=always\nEnvironment=PORT=${CONFIG.PORT}\nEnvironment=BASE_URL=${CONFIG.BASE_URL}\nEnvironment=TC_SOAP_HOST=${CONFIG.TC_SOAP_HOST}\nEnvironment=TC_SOAP_PORT=${CONFIG.TC_SOAP_PORT}\nEnvironment=TC_SOAP_USER=${CONFIG.TC_SOAP_USER}\nEnvironment=TC_SOAP_PASS=${CONFIG.TC_SOAP_PASS}\nEnvironment=SOAP_DEBUG=${CONFIG.SOAP_DEBUG}\nEnvironment=TURNSTILE_SITEKEY=${CONFIG.TURNSTILE_SITEKEY}\nEnvironment=TURNSTILE_SECRET=${CONFIG.TURNSTILE_SECRET}\nEnvironment=CLASSIC_TURNSTILE_SITEKEY=${CONFIG.CLASSIC_TURNSTILE_SITEKEY}\nEnvironment=CLASSIC_TURNSTILE_SECRET=${CONFIG.CLASSIC_TURNSTILE_SECRET}\nEnvironment=SMTP_HOST=${CONFIG.SMTP_HOST}\nEnvironment=SMTP_PORT=${CONFIG.SMTP_PORT}\nEnvironment=SMTP_SECURE=${CONFIG.SMTP_SECURE}\nEnvironment=SMTP_USER=${CONFIG.SMTP_USER}\nEnvironment=SMTP_PASS=${CONFIG.SMTP_PASS}\nEnvironment=FROM_EMAIL=${CONFIG.FROM_EMAIL}\nEnvironment=BRAND_NAME=${CONFIG.BRAND_NAME}\nEnvironment=CLASSIC_BRAND_NAME=${CONFIG.CLASSIC_BRAND_NAME}\nEnvironment=CLASSIC_HEADER_TITLE=${CONFIG.CLASSIC_HEADER_TITLE}\nEnvironment=CLASSIC_GUIDE_URL=${CONFIG.CLASSIC_GUIDE_URL}\nEnvironment=CLASSIC_CLIENT_DOWNLOAD_URL=${CONFIG.CLASSIC_CLIENT_DOWNLOAD_URL}\nEnvironment=CLASSIC_BASE_URL=${CONFIG.CLASSIC_BASE_URL}\nEnvironment=CLASSIC_SOAP_HOST=${CLASSIC_SOAP.host}\nEnvironment=CLASSIC_SOAP_PORT=${CLASSIC_SOAP.port}\nEnvironment=CLASSIC_SOAP_USER=${CLASSIC_SOAP.user}\nEnvironment=CLASSIC_SOAP_PASS=${CLASSIC_SOAP.pass}\nEnvironment=DB_HOST=${DB.HOST}\nEnvironment=DB_PORT=${DB.PORT}\nEnvironment=DB_USER=${DB.USER}\nEnvironment=DB_PASS=${DB.PASS}\nEnvironment=DB_NAME=${DB.NAME}\nEnvironment=CLASSIC_DB_HOST=${CLASSIC_DB.HOST}\nEnvironment=CLASSIC_DB_PORT=${CLASSIC_DB.PORT}\nEnvironment=CLASSIC_DB_USER=${CLASSIC_DB.USER}\nEnvironment=CLASSIC_DB_PASS=${CLASSIC_DB.PASS}\nEnvironment=CLASSIC_DB_NAME=${CLASSIC_DB.NAME}\nEnvironment=AUTH_DB_HOST=${AUTH_DB.HOST}\nEnvironment=AUTH_DB_PORT=${AUTH_DB.PORT}\nEnvironment=AUTH_DB_USER=${AUTH_DB.USER}\nEnvironment=AUTH_DB_PASS=${AUTH_DB.PASS}\nEnvironment=AUTH_DB_NAME=${AUTH_DB.NAME}\nEnvironment=CLASSIC_AUTH_DB_HOST=${CLASSIC_AUTH_DB.HOST}\nEnvironment=CLASSIC_AUTH_DB_PORT=${CLASSIC_AUTH_DB.PORT}\nEnvironment=CLASSIC_AUTH_DB_USER=${CLASSIC_AUTH_DB.USER}\nEnvironment=CLASSIC_AUTH_DB_PASS=${CLASSIC_AUTH_DB.PASS}\nEnvironment=CLASSIC_AUTH_DB_NAME=${CLASSIC_AUTH_DB.NAME}\nEnvironment=CHAR_DB_HOST=${CHAR_DB.HOST}\nEnvironment=CHAR_DB_PORT=${CHAR_DB.PORT}\nEnvironment=CHAR_DB_USER=${CHAR_DB.USER}\nEnvironment=CHAR_DB_PASS=${CHAR_DB.PASS}\nEnvironment=CHAR_DB_NAME=${CHAR_DB.NAME}\nEnvironment=CLASSIC_CHAR_DB_HOST=${CLASSIC_CHAR_DB.HOST}\nEnvironment=CLASSIC_CHAR_DB_PORT=${CLASSIC_CHAR_DB.PORT}\nEnvironment=CLASSIC_CHAR_DB_USER=${CLASSIC_CHAR_DB.USER}\nEnvironment=CLASSIC_CHAR_DB_PASS=${CLASSIC_CHAR_DB.PASS}\nEnvironment=CLASSIC_CHAR_DB_NAME=${CLASSIC_CHAR_DB.NAME}\nEnvironment=SESSION_TTL_HOURS=${CONFIG.SESSION_TTL_HOURS}\nEnvironment=SESSION_COOKIE_NAME=${CONFIG.SESSION_COOKIE_NAME}\nEnvironment=COOKIE_SECURE=${CONFIG.COOKIE_SECURE}\nEnvironment=RETAIL_CHARACTER_DEBUG=${CONFIG.RETAIL_CHARACTER_DEBUG}\n\n[Install]\nWantedBy=multi-user.target\n`);
});
