-- =============================================================================
-- BlackTek / ArkOT -- shared auth schema provisioning
-- =============================================================================
--
-- WHAT THIS IS
--
-- Five account-level tables are hoisted out of every world schema into ONE
-- shared auth schema, and every world schema then gets a VIEW of the same name
-- over each of those base tables:
--
--   `accounts`, `account_sessions`, `store_history`   (phase 1)
--   `account_bans`, `account_ban_history`             (phase 2)
--
-- The views are the entire point. Every unqualified reference to those names
-- keeps working untouched:
--
--   * the C++ query sites (src/iologindata.cpp, src/store.cpp, src/ban.cpp,
--     src/game.cpp) -- none of them is schema-qualified by this change,
--   * the Lua sites (data/scripts/talkactions/remove_tutor.lua, ban.lua,
--     unban.lua, data/scripts/globalevents/startup.lua),
--   * and, decisively, the third-party opentibiabr/login-server image, which is
--     unmodifiable by policy and issues unqualified SQL against the one schema
--     it is given in MYSQL_DBNAME (docker-compose.yaml:48).
--
-- Every one of those references resolves through the view into the auth schema.
--
-- Two further tables live ONLY in the auth schema and get NO view:
--
--   `world_presence`, `account_presence`   (phase 2, cross-world presence)
--
-- Nothing old queries them, so all SQL for them names the auth schema directly
-- (`__AUTH_SCHEMA__`.`account_presence`). A view would only add a dependency.
--
-- DATABASE SERVER
--
-- The deployment database is MySQL 8.0 (the `blacktek-db` container runs
-- `mysql:8.0`), NOT MariaDB, whatever docker-compose.yaml:3 still says. Two
-- MySQL 8.0 facts matter to anyone writing SQL against these tables:
--
--   * unsigned arithmetic whose result would go below zero raises ERROR 1690;
--     it does not evaluate as signed. Never subtract from, or add a negative
--     to, an UNSIGNED column without casting to SIGNED first.
--   * the server runs with STRICT_TRANS_TABLES.
--
-- HOW TO RUN IT  (once per world schema)
--
--   sed -e 's/__AUTH_SCHEMA__/arkot_auth/g' \
--       -e 's/__WORLD_SCHEMA__/arkot_world_0/g' \
--       auth_schema.sql | mysql -h 127.0.0.1 -P 3307 -u root -p
--
-- `__AUTH_SCHEMA__` and `__WORLD_SCHEMA__` are the only two placeholders. Plain
-- SQL has no templating and none is invented here: substitute them with sed (or
-- by hand) before feeding the file to the client. `__AUTH_SCHEMA__` must equal
-- [mysql].auth_database in config/database.toml, and `__WORLD_SCHEMA__` must
-- equal that world's [mysql].database.
--
-- Sections 1 and 3 are idempotent and are the only sections that run. Section 2
-- -- the one-time hoist of an existing world's rows, and the drops it needs --
-- and section 4 -- the cross-schema foreign keys, which depend on section 2 --
-- ship COMMENTED OUT: this script never destroys data by default. Running it
-- against a schema that still owns a real base table under one of the five
-- hoisted names simply fails at section 3, which is the loud, safe outcome.
--
-- A world hoisted in phase 1 that has not yet had its ban tables moved will
-- therefore refresh its three account views and then stop at `account_bans` in
-- section 3. Do section 2's ban move (2b, then the ban lines of 2d) first.
--
-- SINGLE WORLD? RUN NOTHING.
--
-- With [mysql].auth_database empty (or equal to [mysql].database) there is no
-- auth schema, no view, and no boot probe; the server behaves exactly as it did
-- before this file existed and every foreign key in schema.sql still stands,
-- except the two ban-table foreign keys to `players`, which the version-8
-- migration (data/migrations/7.lua) removes on every install.
--
-- DEPLOYMENT INVARIANT THIS DESIGN RESTS ON
--
--   *** Every world's schema lives on the SAME MySQL instance. ***
--
-- One connection, one statement, any schema: that is what lets a world resolve
-- `accounts` through a view into the auth schema and read `<other_world>`.
-- `players` for the cross-world character list, with no second Database, no
-- second connection, and cross-schema transactional atomicity for free. The
-- codebase already exercises exactly this capability against `information_schema`
-- (src/databasemanager.cpp:18, 41, 47). If the worlds are ever split across
-- separate MySQL instances, this whole design stops working.
--
-- GRANTS  (open question O3)
--
-- The views below are created SQL SECURITY INVOKER, so the connecting user needs
-- the privileges in its own right rather than borrowing the definer's:
--
--   GRANT SELECT, INSERT, UPDATE, DELETE ON `__AUTH_SCHEMA__`.* TO '<user>'@'%';
--
-- and, because the character list reads other worlds' character tables directly
-- (`SELECT ... FROM <other_world>.players`), the login-serving user must hold at
-- minimum SELECT on EVERY world schema on the instance, not just its own:
--
--   GRANT SELECT ON `arkot_world_0`.* TO '<user>'@'%';
--   GRANT SELECT ON `arkot_world_1`.* TO '<user>'@'%';   -- ... and so on
--
-- A world that lacks that grant still boots and still serves its own players; it
-- logs a warning naming the unreadable world and omits that world's characters.
-- (If you prefer SQL SECURITY DEFINER instead, the views run with the creating
-- user's rights and the auth-schema grant above can be dropped -- at the cost of
-- handing every user of a world schema the definer's reach into the auth schema.
-- INVOKER is the explicit, least-surprising default and is what is used here.)
--
-- MIGRATION RULE  (not a mechanism, a rule -- keep it)
--
--   A world process must NEVER `ALTER` a hoisted table.
--
-- In a world schema those five names are views, so an `ALTER` from a world
-- process hits the view, not the table -- and MySQL 8.0 refuses it outright with
-- ERROR 1347 "is not BASE TABLE" (verified, see below). The auth schema is
-- provisioned out of band, by this script alone. Migrations that touch a
-- hoisted name must guard on `information_schema`: the two account migrations
-- guard on `information_schema`.`COLUMNS`, which reports view columns, so their
-- guards pass and no `ALTER` fires (data/migrations/1.lua:33-39,
-- data/migrations/6.lua:4-10). The version-8 ban migration
-- (data/migrations/7.lua) checks `information_schema`.`TABLES`.`TABLE_TYPE`,
-- alters only base tables, and refuses -- naming section 3 of this file -- on a
-- view that lacks `banned_by_name`.
--
-- Recommended order for an existing deployment: let every world migrate to
-- database version 8 first, then move the ban tables with section 2. Section 2
-- covers both orders, but migrating first means the names were backfilled by
-- each world against its own `players`.
--
-- After ANY change to an auth base table, re-run section 3 for every world: a
-- `SELECT *` view freezes its column list at creation time and would otherwise
-- keep serving the old set of columns.
--
-- WHAT DOES NOT MOVE, AND WHY
--
--   `account_storage`      -- src/game.cpp:6819 saves it as an unfiltered
--                             `DELETE FROM account_storage` followed by a bulk
--                             reinsert from THIS process's memory. Shared, one
--                             world's save would delete every other world's rows.
--                             It stays per-world. (Account storage therefore
--                             becomes per-world by construction.)
--   `account_viplist`      -- *** MUST NEVER BE MOVED INTO THE AUTH SCHEMA. ***
--                             Its `player_id` is a character id of THIS world,
--                             written from a name resolved on this world
--                             (src/game.cpp:4587-4602) and read back with names
--                             from this world's `players` (src/iologindata.cpp:
--                             1159, 2012). Shared, world A's `player_id`s would be
--                             fed to world B's VIP loading and name lookup and
--                             silently show world B's unrelated characters that
--                             happen to hold those ids. Its per-world foreign key
--                             on `player_id` (schema.sql:1117) is correct and stays.
--   `ip_bans`              -- stays per-world: an IP ban on world A does not bar
--                             world B, and /unban only clears this world's.
--
-- Account bans, by contrast, ARE shared: a ban issued on any world bars the
-- account on every world. `banned_by` is kept for compatibility but no longer
-- has a foreign key to `players` -- a character id cannot be resolved across
-- worlds -- and the issuer's name is stored in `banned_by_name` at ban time.
-- Dropping that foreign key also, deliberately, drops its ON DELETE CASCADE,
-- which used to delete every ban a GM issued when the GM's character was deleted.
--
-- GATE RESULTS -- VERIFIED ON MySQL 8.0.46, 2026-09-16
--
-- Run against two throwaway schemas provisioned by this script unmodified, every
-- write issued unqualified from the world schema as a world process issues it:
--
--   O1 -- views are insertable and updatable: PASSED. Every view reports
--         `information_schema`.`VIEWS`.`IS_UPDATABLE` = 'YES'; INSERT and UPDATE
--         through them land in the auth base table.
--   O2 -- cross-schema foreign keys: PASSED. Created, enforced (an orphan insert
--         fails with ERROR 1452), and ON DELETE CASCADE works across schemas.
--   Ban SQL -- insert through the view, guarded delete returns 1 row and 0 when
--         resent, so history is written exactly once.
--   Presence SQL -- `INSERT IGNORE` claim returns 1 then 0 for a competing claim;
--         a token-guarded takeover returns 0 with the wrong token and 1 with the
--         right one; release returns 1.
--   `ALTER TABLE` on a hoisted name -- refused with ERROR 1347 'is not BASE TABLE'.
--
-- These results hold for the server version they were taken on. After a major
-- server change, re-verify O1 from the world schema with:
--
--   USE `__WORLD_SCHEMA__`;
--   INSERT INTO `accounts` (`name`, `password`) VALUES ('__probe__', 'x');
--   UPDATE `accounts` SET `coins` = `coins` + 1 WHERE `name` = '__probe__';
--   INSERT INTO `store_history` (`account_id`, `amount`, `description`)
--        SELECT `id`, 0, 'probe' FROM `accounts` WHERE `name` = '__probe__';
--   DELETE FROM `store_history`
--    WHERE `account_id` = (SELECT `id` FROM `accounts` WHERE `name`='__probe__');
--   DELETE FROM `accounts` WHERE `name` = '__probe__';
--
-- `ALGORITHM = MERGE` below is what makes an updatable view possible; a view the
-- server has to materialise (TEMPTABLE) is read-only.
--
-- FOREIGN KEYS TO `accounts`(`id`) -- WHERE EACH ONE ENDS UP
--
-- Seven foreign keys reference `accounts`(`id`) in schema.sql (602, 706, 1096,
-- 1103, 1110, 1116, 1180). Four of them (`store_history`, `account_sessions`,
-- `account_bans`, `account_ban_history`) move into the auth schema with their
-- tables and are recreated in section 1. The other THREE stay in the world
-- schema and must be dropped before its local `accounts` can be dropped
-- (section 2c) and re-pointed at the auth schema afterwards (section 4):
-- `players`, `account_storage` and `account_viplist`.
--
-- =============================================================================


-- =============================================================================
-- SECTION 1 -- the shared auth schema and its base tables.
-- Idempotent. Run it for every world; after the first it is a no-op.
-- Hoisted table bodies are copied from schema.sql (accounts :35-51,
-- account_bans :59-68 with indexes :759-761, account_ban_history :76-84 with
-- indexes :766-768, store_history :592-603, account_sessions :699-707),
-- including engine and charset. Every foreign key here lives entirely inside the
-- auth schema.
-- =============================================================================

CREATE DATABASE IF NOT EXISTS `__AUTH_SCHEMA__` DEFAULT CHARACTER SET utf8mb3;

--
-- `accounts` -- schema.sql:35-51
--
CREATE TABLE IF NOT EXISTS `__AUTH_SCHEMA__`.`accounts` (
    `id` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` varchar(32) NOT NULL,
    `password` char(40) NOT NULL,
    `secret` char(16) DEFAULT NULL,
    `type` int NOT NULL DEFAULT '1',
    `premium_ends_at` int UNSIGNED NOT NULL DEFAULT '0',
    `email` varchar(255) NOT NULL DEFAULT '',
    `creation` int NOT NULL DEFAULT '0',
    -- read (not written) by the opentibiabr login webservice; premium_ends_at
    -- stays the authoritative premium source for the game server
    `premdays` int NOT NULL DEFAULT '0',
    `lastday` int UNSIGNED NOT NULL DEFAULT '0',
    -- store coins; the transferable ones may be handed to other accounts
    `coins` int UNSIGNED NOT NULL DEFAULT '0',
    `coins_transferable` int UNSIGNED NOT NULL DEFAULT '0',
    -- schema.sql:754 adds this as a separate ALTER; inline here so the table is
    -- correct the moment it exists
    UNIQUE KEY `name` (`name`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3;

--
-- `account_sessions` -- schema.sql:699-707
--
-- Rows are written by the external login webservice, which stores the hash of
-- the session key it hands the client; the game server only reads them
-- (src/iologindata.cpp:152-177). Every world must be able to read every session,
-- which is exactly why this table is shared.
--
CREATE TABLE IF NOT EXISTS `__AUTH_SCHEMA__`.`account_sessions` (
    `id` varchar(191) NOT NULL PRIMARY KEY,
    `account_id` int NOT NULL,
    `ip` int UNSIGNED NOT NULL DEFAULT '0',
    `created` bigint NOT NULL DEFAULT '0',
    `expires` bigint NOT NULL DEFAULT '0',
    `character_name` varchar(255) DEFAULT NULL,
    FOREIGN KEY (`account_id`) REFERENCES `__AUTH_SCHEMA__`.`accounts` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3;

--
-- `store_history` -- schema.sql:592-603
--
-- Follows the coins. Safe to share: append-only INSERT plus SELECT ... WHERE
-- `account_id` (src/store.cpp:455, 466, 476), never a whole-table rewrite.
--
CREATE TABLE IF NOT EXISTS `__AUTH_SCHEMA__`.`store_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int NOT NULL,
  `mode` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `amount` int NOT NULL DEFAULT '0',
  `coin_type` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `description` varchar(255) NOT NULL DEFAULT '',
  `created` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  INDEX `account_id` (`account_id`),
  FOREIGN KEY (`account_id`) REFERENCES `__AUTH_SCHEMA__`.`accounts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- `account_bans` -- schema.sql:59-68, indexes :759-761
--
-- One active ban per account (primary key), shared by every world. `banned_by`
-- is the issuing character's id on whichever world issued the ban; it is kept
-- for compatibility and deliberately has NO foreign key to any `players`.
-- `banned_by_name` is the issuer's name frozen at ban time, and is what the
-- server displays.
--
CREATE TABLE IF NOT EXISTS `__AUTH_SCHEMA__`.`account_bans` (
    `account_id` int NOT NULL,
    `reason` varchar(255) NOT NULL,
    `banned_at` bigint NOT NULL,
    `expires_at` bigint NOT NULL,
    `banned_by` int NOT NULL,
    `banned_by_name` varchar(255) NOT NULL DEFAULT '',
    PRIMARY KEY (`account_id`),
    KEY `banned_by` (`banned_by`),
    FOREIGN KEY (`account_id`) REFERENCES `__AUTH_SCHEMA__`.`accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3;

--
-- `account_ban_history` -- schema.sql:76-84, indexes :766-768
--
-- Same `banned_by` / `banned_by_name` rules as `account_bans`.
--
CREATE TABLE IF NOT EXISTS `__AUTH_SCHEMA__`.`account_ban_history` (
    `id` int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `account_id` int NOT NULL,
    `reason` varchar(255) NOT NULL,
    `banned_at` bigint NOT NULL,
    `expired_at` bigint NOT NULL,
    `banned_by` int NOT NULL,
    `banned_by_name` varchar(255) NOT NULL DEFAULT '',
    KEY `account_id` (`account_id`),
    KEY `banned_by` (`banned_by`),
    FOREIGN KEY (`account_id`) REFERENCES `__AUTH_SCHEMA__`.`accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3;

--
-- `world_presence` -- one heartbeat row per running world.
--
-- Auth schema only, no view. Liveness belongs to the world process, so this is
-- one write per world per beat regardless of player count. Staleness is judged
-- against the database's own `UNIX_TIMESTAMP()`, never a process clock. InnoDB,
-- not MEMORY: a MySQL restart must not silently free every claim.
--
CREATE TABLE IF NOT EXISTS `__AUTH_SCHEMA__`.`world_presence` (
    `world_id` tinyint UNSIGNED NOT NULL PRIMARY KEY,
    `beat_at`  bigint NOT NULL DEFAULT '0'
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3;

--
-- `account_presence` -- one deployment-wide login claim per account.
--
-- Auth schema only, no view. The primary key lets exactly one world's
-- `INSERT IGNORE` claim an account; `claim_token` guards every takeover and
-- release, so a resent query after a lost connection is harmless.
--
CREATE TABLE IF NOT EXISTS `__AUTH_SCHEMA__`.`account_presence` (
    `account_id`     int NOT NULL PRIMARY KEY,
    `world_id`       tinyint UNSIGNED NOT NULL,
    `player_id`      int NOT NULL,
    `character_name` varchar(255) NOT NULL,
    `claim_token`    bigint UNSIGNED NOT NULL,
    `claimed_at`     bigint NOT NULL DEFAULT '0',
    INDEX `world_id` (`world_id`),
    FOREIGN KEY (`account_id`) REFERENCES `__AUTH_SCHEMA__`.`accounts` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3;

--
-- `account_roles` -- what an account is, beyond its type. One row per role held.
--
-- Auth schema only, no view: nothing old queries it, and a world names it through
-- the auth schema the way the presence tables are named. That is also what keeps a
-- second role from ever obliging a section 3 re-run -- adding a row is not adding
-- a column.
--
-- A world declaring `access = "<role>"` in config/worlds.toml admits an account
-- holding that role, and any account of type >= 4 (ACCOUNT_TYPE_GAMEMASTER)
-- regardless. A world that declares no `access` is public and never reads this
-- table at all.
--
-- Role names are lowercase [a-z0-9_], at most 32 characters, and carry no order:
-- holding the string is the whole meaning. `granted_by_name` freezes the granting
-- character's name at grant time, the same discipline `banned_by_name` settled on.
--
CREATE TABLE IF NOT EXISTS `__AUTH_SCHEMA__`.`account_roles` (
    `account_id`      int NOT NULL,
    `role`            varchar(32) NOT NULL,
    `granted_at`      bigint NOT NULL DEFAULT '0',
    `granted_by_name` varchar(255) NOT NULL DEFAULT '',
    PRIMARY KEY (`account_id`, `role`),
    INDEX `role` (`role`),
    FOREIGN KEY (`account_id`) REFERENCES `__AUTH_SCHEMA__`.`accounts` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3;


-- =============================================================================
-- SECTION 2 -- ONE-TIME HOIST of an existing world schema.  *** COMMENTED OUT ***
--
-- READ THIS BEFORE YOU UNCOMMENT ANYTHING. These statements DROP TABLES. Take a
-- backup (`mysqldump __WORLD_SCHEMA__`) first, every time, no exceptions.
--
-- Run 2a ONLY for the first, already-populated world; its rows become the shared
-- account set with their ids preserved, which is what keeps every existing
-- `players`.`account_id` truthful. For a SECOND already-populated world the ids
-- would collide with the first world's and `INSERT IGNORE` would silently drop
-- real accounts -- merge those by hand instead, then run 2b (after remapping that
-- world's ban `account_id`s to the merged ids), 2c and 2d only.
--
-- A world already hoisted in phase 1 has done 2a, the `players` /
-- `account_storage` / `account_viplist` lines of 2c, and the 2d drops of
-- `accounts`, `account_sessions` and `store_history`: for it, run only 2b and
-- the two ban-table drops of 2d.
--
-- Run 2c and 2d for every world, including a brand new one imported from
-- schema.sql: a fresh world schema still owns local `accounts`,
-- `account_sessions`, `store_history`, `account_bans` and `account_ban_history`
-- tables (plus the seeded Account Manager row at schema.sql:963), and a view
-- cannot be created over a name a base table holds.
--
-- The constraint names in 2c are the ones schema.sql gives (schema.sql:1110,
-- 1116, 1180). An install created some other way may name them differently --
-- confirm with:
--   SELECT `CONSTRAINT_NAME`, `TABLE_NAME` FROM `information_schema`.`KEY_COLUMN_USAGE`
--    WHERE `CONSTRAINT_SCHEMA` = '__WORLD_SCHEMA__' AND `REFERENCED_TABLE_NAME` = 'accounts';
-- =============================================================================

-- -- 2a. Copy this world's rows into the shared auth schema, ids preserved.
-- INSERT IGNORE INTO `__AUTH_SCHEMA__`.`accounts`
--     (`id`, `name`, `password`, `secret`, `type`, `premium_ends_at`, `email`,
--      `creation`, `premdays`, `lastday`, `coins`, `coins_transferable`)
-- SELECT `id`, `name`, `password`, `secret`, `type`, `premium_ends_at`, `email`,
--        `creation`, `premdays`, `lastday`, `coins`, `coins_transferable`
--   FROM `__WORLD_SCHEMA__`.`accounts`;
--
-- -- Sessions are ephemeral; copying them only avoids logging everyone out.
-- INSERT IGNORE INTO `__AUTH_SCHEMA__`.`account_sessions`
--     (`id`, `account_id`, `ip`, `created`, `expires`, `character_name`)
-- SELECT `s`.`id`, `s`.`account_id`, `s`.`ip`, `s`.`created`, `s`.`expires`, `s`.`character_name`
--   FROM `__WORLD_SCHEMA__`.`account_sessions` AS `s`
--  WHERE `s`.`account_id` IN (SELECT `id` FROM `__AUTH_SCHEMA__`.`accounts`);
--
-- -- `id` is deliberately NOT copied: it is a bare AUTO_INCREMENT surrogate that
-- -- nothing references, so letting the auth schema assign fresh ones sidesteps
-- -- collisions between worlds entirely. The account_id filter keeps the FK happy.
-- INSERT INTO `__AUTH_SCHEMA__`.`store_history`
--     (`account_id`, `mode`, `amount`, `coin_type`, `description`, `created`)
-- SELECT `h`.`account_id`, `h`.`mode`, `h`.`amount`, `h`.`coin_type`, `h`.`description`, `h`.`created`
--   FROM `__WORLD_SCHEMA__`.`store_history` AS `h`
--  WHERE `h`.`account_id` IN (SELECT `id` FROM `__AUTH_SCHEMA__`.`accounts`);

-- -- 2b. Move this world's bans into the shared auth schema.
-- --
-- --     Every world with ban rows runs this, once, while its ban tables are
-- --     still base tables. The `account_id` filter keeps the auth FK happy.
-- --
-- --     `account_ban_history`.`id` is deliberately NOT copied: several worlds'
-- --     histories would collide on it, and nothing references it.
-- --
-- --     `account_bans` holds one active ban per account. If another world already
-- --     moved a ban for the same account, `INSERT IGNORE` keeps the one already
-- --     in the auth schema and skips this world's. List those first and resolve
-- --     them by hand if the skipped ban matters:
-- --
-- --   SELECT `w`.`account_id`, `w`.`reason`, `w`.`expires_at`, `a`.`reason`, `a`.`expires_at`
-- --     FROM `__WORLD_SCHEMA__`.`account_bans` AS `w`
-- --     JOIN `__AUTH_SCHEMA__`.`account_bans` AS `a` ON `a`.`account_id` = `w`.`account_id`;
-- --
-- --     Find out which variant applies -- this returns one row per ban table
-- --     that already has the column (i.e. the world has migrated to version 8):
-- --
-- --   SELECT `TABLE_NAME` FROM `information_schema`.`COLUMNS`
-- --    WHERE `TABLE_SCHEMA` = '__WORLD_SCHEMA__' AND `COLUMN_NAME` = 'banned_by_name'
-- --      AND `TABLE_NAME` IN ('account_bans', 'account_ban_history');
--
-- -- 2b-i. The world table HAS `banned_by_name` (migrated): copy it as it is.
-- INSERT IGNORE INTO `__AUTH_SCHEMA__`.`account_bans`
--     (`account_id`, `reason`, `banned_at`, `expires_at`, `banned_by`, `banned_by_name`)
-- SELECT `b`.`account_id`, `b`.`reason`, `b`.`banned_at`, `b`.`expires_at`, `b`.`banned_by`, `b`.`banned_by_name`
--   FROM `__WORLD_SCHEMA__`.`account_bans` AS `b`
--  WHERE `b`.`account_id` IN (SELECT `id` FROM `__AUTH_SCHEMA__`.`accounts`);
--
-- INSERT INTO `__AUTH_SCHEMA__`.`account_ban_history`
--     (`account_id`, `reason`, `banned_at`, `expired_at`, `banned_by`, `banned_by_name`)
-- SELECT `h`.`account_id`, `h`.`reason`, `h`.`banned_at`, `h`.`expired_at`, `h`.`banned_by`, `h`.`banned_by_name`
--   FROM `__WORLD_SCHEMA__`.`account_ban_history` AS `h`
--  WHERE `h`.`account_id` IN (SELECT `id` FROM `__AUTH_SCHEMA__`.`accounts`);
--
-- -- 2b-ii. The world table LACKS `banned_by_name` (not migrated): backfill the
-- --        name from THIS world's `players`, where `banned_by` is meaningful.
-- --        A `banned_by` with no matching character gets an empty name.
-- INSERT IGNORE INTO `__AUTH_SCHEMA__`.`account_bans`
--     (`account_id`, `reason`, `banned_at`, `expires_at`, `banned_by`, `banned_by_name`)
-- SELECT `b`.`account_id`, `b`.`reason`, `b`.`banned_at`, `b`.`expires_at`, `b`.`banned_by`, COALESCE(`p`.`name`, '')
--   FROM `__WORLD_SCHEMA__`.`account_bans` AS `b`
--   LEFT JOIN `__WORLD_SCHEMA__`.`players` AS `p` ON `p`.`id` = `b`.`banned_by`
--  WHERE `b`.`account_id` IN (SELECT `id` FROM `__AUTH_SCHEMA__`.`accounts`);
--
-- INSERT INTO `__AUTH_SCHEMA__`.`account_ban_history`
--     (`account_id`, `reason`, `banned_at`, `expired_at`, `banned_by`, `banned_by_name`)
-- SELECT `h`.`account_id`, `h`.`reason`, `h`.`banned_at`, `h`.`expired_at`, `h`.`banned_by`, COALESCE(`p`.`name`, '')
--   FROM `__WORLD_SCHEMA__`.`account_ban_history` AS `h`
--   LEFT JOIN `__WORLD_SCHEMA__`.`players` AS `p` ON `p`.`id` = `h`.`banned_by`
--  WHERE `h`.`account_id` IN (SELECT `id` FROM `__AUTH_SCHEMA__`.`accounts`);

-- -- 2c. Drop the three foreign keys that point at this world's local `accounts`
-- --     from tables that STAY in the world schema. InnoDB refuses to drop a
-- --     table while a foreign key still references it. (The ban tables' own
-- --     foreign keys go away with the tables in 2d.) Section 4 re-points these
-- --     three at the auth schema afterwards.
-- ALTER TABLE `__WORLD_SCHEMA__`.`account_storage`     DROP FOREIGN KEY `account_storage_ibfk_1`;
-- ALTER TABLE `__WORLD_SCHEMA__`.`account_viplist`     DROP FOREIGN KEY `account_viplist_ibfk_1`;
-- ALTER TABLE `__WORLD_SCHEMA__`.`players`             DROP FOREIGN KEY `players_ibfk_1`;

-- -- 2d. Drop the local tables so the views can take their names. Children first.
-- DROP TABLE IF EXISTS `__WORLD_SCHEMA__`.`account_sessions`;
-- DROP TABLE IF EXISTS `__WORLD_SCHEMA__`.`store_history`;
-- DROP TABLE IF EXISTS `__WORLD_SCHEMA__`.`account_bans`;
-- DROP TABLE IF EXISTS `__WORLD_SCHEMA__`.`account_ban_history`;
-- DROP TABLE IF EXISTS `__WORLD_SCHEMA__`.`accounts`;


-- =============================================================================
-- SECTION 3 -- the per-world views. This is the mechanism.
--
-- Same names, same columns, one shared set of rows. `ALGORITHM = MERGE` keeps
-- each view a rewrite rule over the base table rather than a materialised copy,
-- which is both what makes it updatable (O1, verified) and what keeps a lookup
-- on an indexed column an index lookup instead of a scan of the whole set.
--
-- Re-runnable: `CREATE OR REPLACE` refreshes the column list, which is exactly
-- what you must do after any change to an auth base table -- and what the
-- version-8 migration tells you to do when a ban view lacks `banned_by_name`.
--
-- `world_presence` and `account_presence` deliberately get no view.
-- =============================================================================

CREATE OR REPLACE
    ALGORITHM = MERGE
    SQL SECURITY INVOKER
    VIEW `__WORLD_SCHEMA__`.`accounts` AS
SELECT * FROM `__AUTH_SCHEMA__`.`accounts`;

CREATE OR REPLACE
    ALGORITHM = MERGE
    SQL SECURITY INVOKER
    VIEW `__WORLD_SCHEMA__`.`account_sessions` AS
SELECT * FROM `__AUTH_SCHEMA__`.`account_sessions`;

CREATE OR REPLACE
    ALGORITHM = MERGE
    SQL SECURITY INVOKER
    VIEW `__WORLD_SCHEMA__`.`store_history` AS
SELECT * FROM `__AUTH_SCHEMA__`.`store_history`;

CREATE OR REPLACE
    ALGORITHM = MERGE
    SQL SECURITY INVOKER
    VIEW `__WORLD_SCHEMA__`.`account_bans` AS
SELECT * FROM `__AUTH_SCHEMA__`.`account_bans`;

CREATE OR REPLACE
    ALGORITHM = MERGE
    SQL SECURITY INVOKER
    VIEW `__WORLD_SCHEMA__`.`account_ban_history` AS
SELECT * FROM `__AUTH_SCHEMA__`.`account_ban_history`;


-- =============================================================================
-- SECTION 4 -- cross-schema foreign keys back to the auth schema (O2).
-- *** COMMENTED OUT because they depend on section 2 -- not because O2 is open. ***
--
-- O2 IS VERIFIED on MySQL 8.0.46 (2026-09-16): cross-schema foreign keys are
-- created, enforced (an orphan insert fails with ERROR 1452), and ON DELETE
-- CASCADE works across schemas. With these in place, deleting an account from
-- the auth schema cascades into every world, and an orphaned `players` row stays
-- impossible at the database level.
--
-- These statements are safe to run ONCE PER WORLD, AFTER SECTION 2 HAS RUN for
-- that world. They depend on it in two ways:
--
--   * 2c must have dropped the old constraints, or these fail on the duplicate
--     constraint name (and a world-local `accounts` would still be the target
--     of the old key);
--   * every existing `account_id` in the three tables must already exist in the
--     auth schema (2a, or the hand merge), or the ALTER is refused with 1452.
--     Check first -- each of these must return no rows:
--
--   SELECT `id`, `account_id` FROM `__WORLD_SCHEMA__`.`players`
--    WHERE `account_id` NOT IN (SELECT `id` FROM `__AUTH_SCHEMA__`.`accounts`);
--   SELECT DISTINCT `account_id` FROM `__WORLD_SCHEMA__`.`account_storage`
--    WHERE `account_id` NOT IN (SELECT `id` FROM `__AUTH_SCHEMA__`.`accounts`);
--   SELECT DISTINCT `account_id` FROM `__WORLD_SCHEMA__`.`account_viplist`
--    WHERE `account_id` NOT IN (SELECT `id` FROM `__AUTH_SCHEMA__`.`accounts`);
--
-- They are not idempotent: re-running one that already succeeded fails on the
-- duplicate constraint name, harmlessly.
--
-- A foreign key cannot reference a view, so these name the auth base table
-- directly. The ban tables are not listed: their `account_id` key lives inside
-- the auth schema (section 1).
-- =============================================================================

-- ALTER TABLE `__WORLD_SCHEMA__`.`players`
--     ADD CONSTRAINT `players_ibfk_1` FOREIGN KEY (`account_id`)
--     REFERENCES `__AUTH_SCHEMA__`.`accounts` (`id`) ON DELETE CASCADE;
--
-- ALTER TABLE `__WORLD_SCHEMA__`.`account_storage`
--     ADD CONSTRAINT `account_storage_ibfk_1` FOREIGN KEY (`account_id`)
--     REFERENCES `__AUTH_SCHEMA__`.`accounts` (`id`) ON DELETE CASCADE;
--
-- ALTER TABLE `__WORLD_SCHEMA__`.`account_viplist`
--     ADD CONSTRAINT `account_viplist_ibfk_1` FOREIGN KEY (`account_id`)
--     REFERENCES `__AUTH_SCHEMA__`.`accounts` (`id`) ON DELETE CASCADE;


-- =============================================================================
-- SECTION 5 -- what the server checks at boot, so you can check it yourself.
--
-- With [mysql].auth_database set and different from [mysql].database, mainLoader
-- refuses to boot, before any migration runs, unless all of these hold. Any query
-- that fails counts as a missing name, so a check never passes by erroring.
--
-- 1. `accounts` is readable through this world's schema:
--
--   SELECT EXISTS(SELECT 1 FROM `accounts` LIMIT 1) AS `readable`;
--
-- 2. All five shared names are views in the world schema, and all five base tables
--    exist in the auth schema:
--
--   SELECT `TABLE_NAME`, `VIEW_DEFINITION` FROM `information_schema`.`VIEWS`
--    WHERE `TABLE_SCHEMA` = '__WORLD_SCHEMA__'
--      AND `TABLE_NAME` IN ('accounts', 'account_sessions', 'store_history',
--                           'account_bans', 'account_ban_history');
--
--   SELECT `TABLE_NAME` FROM `information_schema`.`TABLES`
--    WHERE `TABLE_SCHEMA` = '__AUTH_SCHEMA__' AND `TABLE_TYPE` = 'BASE TABLE'
--      AND `TABLE_NAME` IN ('accounts', 'account_sessions', 'store_history',
--                           'account_bans', 'account_ban_history');
--
--    A view whose VIEW_DEFINITION does not name the auth schema only warns.
--
-- 3. The two presence tables are base tables in the auth schema (they have no
--    per-world view):
--
--   SELECT `TABLE_NAME` FROM `information_schema`.`TABLES`
--    WHERE `TABLE_SCHEMA` = '__AUTH_SCHEMA__' AND `TABLE_TYPE` = 'BASE TABLE'
--      AND `TABLE_NAME` IN ('world_presence', 'account_presence');
--
-- 4. `banned_by_name` exists on both ban base tables in the auth schema, and on
--    both ban views in the world schema (a view's column list is frozen when it is
--    created, so a view made before the column existed lacks it -- re-run section 3):
--
--   SELECT `TABLE_NAME` FROM `information_schema`.`COLUMNS`
--    WHERE `TABLE_SCHEMA` = '__AUTH_SCHEMA__' AND `COLUMN_NAME` = 'banned_by_name'
--      AND `TABLE_NAME` IN ('account_bans', 'account_ban_history');
--
--   SELECT `TABLE_NAME` FROM `information_schema`.`COLUMNS`
--    WHERE `TABLE_SCHEMA` = '__WORLD_SCHEMA__' AND `COLUMN_NAME` = 'banned_by_name'
--      AND `TABLE_NAME` IN ('account_bans', 'account_ban_history');
--
-- It then probes every world listed in config/worlds.toml, which only warns:
--
--   SELECT EXISTS(SELECT 1 FROM `<each world schema>`.`players` LIMIT 1) AS `readable`;
--
-- On EVERY install, whether or not [mysql].auth_database is set, and AFTER the
-- migrations have run (the version-8 migration is what adds the column to a
-- single-world install's base tables), boot refuses unless both ban names in the
-- world's own schema carry `banned_by_name`, whatever they are -- base tables on a
-- single-world install, views on a shared one. Without the column every ban query
-- fails, and a failed ban query reads as "not banned":
--
--   SELECT `TABLE_NAME` FROM `information_schema`.`COLUMNS`
--    WHERE `TABLE_SCHEMA` = DATABASE() AND `COLUMN_NAME` = 'banned_by_name'
--      AND `TABLE_NAME` IN ('account_bans', 'account_ban_history');
--
-- Finally, with [mysql].auth_database set, boot refuses unless at least one game or
-- login listener (game_port, game_port_modern, login_port) actually bound. Starting
-- cross-world presence clears this world's leftover presence rows, which is only
-- safe once a successful bind has proven no other process is serving this world;
-- the status port does not count.
-- =============================================================================
