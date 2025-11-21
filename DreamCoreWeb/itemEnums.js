// Shared item enumeration definitions for web and Node contexts
// High-level item class
export const ITEM_CLASS = {
  0: 'Consumable',
  1: 'Container',
  2: 'Weapon',
  3: 'Gem',
  4: 'Armor',
  5: 'Reagent',
  6: 'Projectile',
  7: 'Trade goods',
  8: 'Generic (obsolete)',
  9: 'Recipe',
  10: 'Money',
  11: 'Quiver',
  12: 'Quest',
  13: 'Key',
  14: 'Permanent (obsolete)',
  15: 'Miscellaneous',
  16: 'Glyph',
};

// Weapon subclasses (class = 2)
export const WEAPON_SUBCLASS = {
  0: 'Axe (1H)',
  1: 'Axe (2H)',
  2: 'Bow',
  3: 'Gun',
  4: 'Mace (1H)',
  5: 'Mace (2H)',
  6: 'Polearm',
  7: 'Sword (1H)',
  8: 'Sword (2H)',
  9: 'Obsolete weapon',
  10: 'Staff',
  11: 'Exotic (1H)',
  12: 'Exotic (2H)',
  13: 'Fist weapon',
  14: 'Miscellaneous weapon',
  15: 'Dagger',
  16: 'Thrown',
  17: 'Spear',
  18: 'Crossbow',
  19: 'Wand',
  20: 'Fishing pole',
};

// Armor subclasses (class = 4)
export const ARMOR_SUBCLASS = {
  0: 'Miscellaneous',
  1: 'Cloth',
  2: 'Leather',
  3: 'Mail',
  4: 'Plate',
  5: 'Buckler (obsolete)',
  6: 'Shield',
  7: 'Libram',
  8: 'Idol',
  9: 'Totem',
  10: 'Sigil',
};

// Equip slot / InventoryType
export const INVENTORY_TYPE = {
  0: 'Non-equip',
  1: 'Head',
  2: 'Neck',
  3: 'Shoulders',
  4: 'Shirt',
  5: 'Chest',
  6: 'Waist',
  7: 'Legs',
  8: 'Feet',
  9: 'Wrist',
  10: 'Hands',
  11: 'Finger',
  12: 'Trinket',
  13: 'Weapon (one-hand)',
  14: 'Shield',
  15: 'Ranged',
  16: 'Back (cloak)',
  17: 'Two-hand weapon',
  18: 'Bag',
  19: 'Tabard',
  20: 'Robe',
  21: 'Weapon (main hand)',
  22: 'Weapon (off hand)',
  23: 'Held in off-hand',
  24: 'Ammo',
  25: 'Thrown',
  26: 'Ranged (right)',
  27: 'Quiver',
  28: 'Relic',
};

// Item quality
export const ITEM_QUALITY = {
  0: 'Poor (grey)',
  1: 'Common (white)',
  2: 'Uncommon (green)',
  3: 'Rare (blue)',
  4: 'Epic (purple)',
  5: 'Legendary (orange)',
  6: 'Artifact',
  7: 'Heirloom / Account-bound',
};

// Bonding (“binds when…”)
export const ITEM_BONDING = {
  0: 'Not bound',
  1: 'Binds when picked up',
  2: 'Binds when equipped',
  3: 'Binds when used',
  4: 'Quest item',
  5: 'Quest item (alt)',
};

// Socket colors (3.3.5 values – numeric 0/1/2/4/8 in item_template.socketColor_*)
export const SOCKET_COLOR_335 = {
  0: 'None',
  1: 'Meta',
  2: 'Red',
  4: 'Yellow',
  8: 'Blue',
};

// Expanded socket colors (core enum, for master if needed)
export const SOCKET_COLOR = {
  0x000001: 'Meta',
  0x000002: 'Red',
  0x000004: 'Yellow',
  0x000008: 'Blue',
  0x000010: 'Hydraulic',
  0x000020: 'Cogwheel',
  0x00000e: 'Prismatic (R/Y/B)',
  0x000040: 'Relic – Iron',
  0x000080: 'Relic – Blood',
  // can add more relic variants here as needed
};

// Item stat types (stat_type1..10)
export const ITEM_MOD_TYPE = {
  0: 'Mana',
  1: 'Health',
  3: 'Agility',
  4: 'Strength',
  5: 'Intellect',
  6: 'Spirit',
  7: 'Stamina',

  12: 'Defense rating',
  13: 'Dodge rating',
  14: 'Parry rating',
  15: 'Block rating',

  16: 'Hit rating (melee)',
  17: 'Hit rating (ranged)',
  18: 'Hit rating (spell)',

  19: 'Crit rating (melee)',
  20: 'Crit rating (ranged)',
  21: 'Crit rating (spell)',

  22: 'Hit taken rating (melee)',
  23: 'Hit taken rating (ranged)',
  24: 'Hit taken rating (spell)',

  25: 'Crit taken rating (melee)',
  26: 'Crit taken rating (ranged)',
  27: 'Crit taken rating (spell)',

  28: 'Haste rating (melee)',
  29: 'Haste rating (ranged)',
  30: 'Haste rating (spell)',

  31: 'Hit rating (all)',
  32: 'Crit rating (all)',
  33: 'Hit taken rating (all)',
  34: 'Crit taken rating (all)',

  35: 'Resilience rating',
  36: 'Haste rating (all)',
  37: 'Expertise rating',

  38: 'Attack power',
  39: 'Ranged attack power',
  40: 'Feral attack power',

  41: 'Healing done (legacy)',
  42: 'Spell damage (legacy)',

  43: 'Mana per 5 sec',
  44: 'Armor penetration rating',
  45: 'Spell power',
  46: 'Health per 5 sec',
  47: 'Spell penetration',
  48: 'Block value',
};

// Damage school
export const SPELL_SCHOOL = {
  0: 'Physical',
  1: 'Holy',
  2: 'Fire',
  3: 'Nature',
  4: 'Frost',
  5: 'Shadow',
  6: 'Arcane',
};

// Item spell triggers
export const ITEM_SPELL_TRIGGER = {
  0: 'On use (with equip cooldown)',
  1: 'On equip',
  2: 'Chance on hit',
  4: 'Soulstone',
  5: 'On use (no equip cooldown)',
  6: 'Learn spell',
};

// Generic helpers for the UI
export function buildEnumOptions(enumObj) {
  return Object.keys(enumObj)
    .map((key) => {
      const id = Number(key);
      return { id, label: enumObj[key] };
    })
    .sort((a, b) => a.id - b.id);
}

export function enumLabel(enumObj, value) {
  const key = Number(value);
  if (Number.isNaN(key)) return null;
  const label = enumObj[key];
  return label || null;
}

export default {
  ITEM_CLASS,
  WEAPON_SUBCLASS,
  ARMOR_SUBCLASS,
  INVENTORY_TYPE,
  ITEM_QUALITY,
  ITEM_BONDING,
  SOCKET_COLOR_335,
  SOCKET_COLOR,
  ITEM_MOD_TYPE,
  SPELL_SCHOOL,
  ITEM_SPELL_TRIGGER,
  buildEnumOptions,
  enumLabel,
};
