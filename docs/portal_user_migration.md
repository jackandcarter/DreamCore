# Portal user migration

The retail portal now stores login data in `portal_users` with explicit join tables for
retail and classic Trinity IDs. Existing installs that previously relied on the
`portal_credentials` table should run the helper script below once to migrate data
and drop the legacy table.

## Requirements

* Node.js 18+
* Access to the same MySQL/MariaDB instance used by `server.js`
* Environment variables that match the registration service configuration:
  * `DB_HOST` (default: `127.0.0.1`)
  * `DB_PORT` (default: `3306`)
  * `DB_USER` (default: `trinity`)
  * `DB_PASS` (default: `trinity_password`)
  * `DB_NAME` (default: `tc_register`)

## Running the migration

```bash
cd DreamCoreWeb
node ./scripts/migrate_portal_credentials.js
```

The script will:

1. Ensure the new `portal_users`, `portal_user_retail_accounts`, and
   `portal_user_classic_accounts` tables exist.
2. Copy every record from `portal_credentials` into `portal_users`, linking
   the stored `account_id` into the retail join table.
3. Drop the `portal_credentials` table once the data has been copied.

If the legacy table is missing (e.g., on a fresh install), the script exits
without making any changes.
