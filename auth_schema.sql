-- =============================================================================
-- BlackTek / ArkOT -- shared auth schema provisioning
-- =============================================================================
--
-- WHAT THIS IS
--
-- `accounts`, `account_sessions` and `store_history` are hoisted out of every
-- world schema into ONE shared auth schema, and every world schema then gets a
-- VIEW of the same name over each of those base tables.
--
-- The views are the entire point. Every unqualified `accounts` /
-- `account_sessions` / `store_history` reference keeps working untouched:
--
--   * the ~28 C++ query sites (src/iologindata.cpp, src/store.cpp, src/ban.cpp,
--     src/game.cpp) -- none of them is schema-qualified by this change,
--   * the Lua site at data/scripts/talkactions/remove_tutor.lua:6, 22,
--   * and, decisively, the third-party opentibiabr/login-server image, which is
--     unmodifiable by policy and issues unqualified SQL against the one schema
--     it is given in MYSQL_DBNAME (docker-compose.yaml:48).
--
-- Every one of those references resolves through the view into the auth schema,
-- so no query in the server or in the login-server changes at all.
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
-- ships COMMENTED OUT: this script never destroys data by default. Running it
-- against a schema that still owns a real `accounts` table simply fails at
-- section 3 with "table already exists", which is the loud, safe outcome.
--
-- SINGLE WORLD? RUN NOTHING.
--
-- With [mysql].auth_database empty (or equal to [mysql].database) there is no
-- auth schema, no view, and no boot probe; the server behaves exactly as it did
-- before this file existed and every foreign key in schema.sql still stands.
-- This script is only for a deployment that actually serves more than one world.
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
-- In a world schema those three names are views, so an `ALTER` from a world
-- process hits the view, not the table. schema.sql is deliberately NOT modified
-- by this change and there is no data/migrations/ entry for it: the auth schema
-- is provisioned out of band, by this script alone. The two existing account
-- migrations guard on `information_schema`.`COLUMNS`, which reports view columns,
-- so their guards pass and no `ALTER` fires (data/migrations/1.lua:33-38,
-- data/migrations/6.lua:4-7).
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
--   `account_bans`         -- FK `banned_by` -> per-world `players`(`id`)
--                             (schema.sql:1093).
--   `account_ban_history`  -- FK `banned_by` -> per-world `players`(`id`)
--                             (schema.sql:1100).
--   `account_viplist`      -- FK `player_id` -> per-world `players`(`id`)
--                             (schema.sql:1113).
--
-- A ban on world A therefore does not bar world B, and a VIP list is per-world.
-- Both are known, owner-visible consequences of keeping those tables local.
--
-- TWO THINGS THE CHECKOUT COULD NOT SETTLE -- VERIFY BEFORE ENABLING THIS
--
-- O1 -- ARE THESE VIEWS INSERTABLE AND UPDATABLE?
--
-- The design needs all of the following to work THROUGH the view:
--
--   INSERT INTO `accounts`       -- src/game.cpp:5735, 6043
--   UPDATE `accounts`            -- src/game.cpp:5881, src/iologindata.cpp:497,
--                                   src/iologindata.cpp:2013, src/store.cpp:367
--                                   (and the guarded coin delta of step 9)
--   INSERT INTO `store_history`  -- src/store.cpp:455
--
-- That is server behaviour, not repository fact. On the pinned `mariadb` image
-- (docker-compose.yaml:3), after running this script, verify with:
--
--   USE `__WORLD_SCHEMA__`;
--   INSERT INTO `accounts` (`name`, `password`) VALUES ('__probe__', 'x');
--   UPDATE `accounts` SET `coins` = `coins` + 1 WHERE `name` = '__probe__';
--   UPDATE `accounts` SET `coins` = `coins` - 1 WHERE `name` = '__probe__';
--   INSERT INTO `store_history` (`account_id`, `amount`, `description`)
--        SELECT `id`, 0, 'probe' FROM `accounts` WHERE `name` = '__probe__';
--   DELETE FROM `store_history`
--    WHERE `account_id` = (SELECT `id` FROM `accounts` WHERE `name`='__probe__');
--   DELETE FROM `accounts` WHERE `name` = '__probe__';
--
-- `ALGORITHM = MERGE` below is what makes an updatable view possible; a view the
-- server has to materialise (TEMPTABLE) is read-only. If any statement above is
-- refused, that ONE table's call sites get schema-qualified in C++ instead, and
-- its view stays as a read-only compatibility shim for the login-server.
--
-- O2 -- CAN THE REMAINING `accounts`(`id`) FOREIGN KEYS SURVIVE CROSS-SCHEMA?
--
-- Section 4 attempts them. THE DESIGN DOES NOT DEPEND ON THE ANSWER: if InnoDB
-- refuses a cross-schema constraint, leave them dropped and note that deleting an
-- account must then cascade in application code, because an orphaned `players`
-- row stops being impossible at the database level.
--
-- Note an off-by-one worth having in writing: seven FKs reference `accounts`(`id`)
-- (schema.sql:598, 702, 1092, 1099, 1106, 1112, 1176). Two of them
-- (`store_history`, `account_sessions`) move into the auth schema with their
-- parent and are recreated in section 1. That leaves FIVE, not four, to drop in a
-- world schema -- `players`, `account_bans`, `account_ban_history`,
-- `account_storage` AND `account_viplist` (schema.sql:1112), which the plan's
-- prose omits. `account_viplist`'s FK must be dropped too or `DROP TABLE
-- accounts` is refused.
--
-- =============================================================================


-- =============================================================================
-- SECTION 1 -- the shared auth schema and its base tables.
-- Idempotent. Run it for every world; after the first it is a no-op.
-- Table bodies are copied verbatim from schema.sql:35-51, :695-703 and :588-599,
-- including engine and charset. The two foreign keys that live entirely inside
-- the auth schema (schema.sql:598, 702) move here with their tables.
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
    -- schema.sql:750 adds this as a separate ALTER; inline here so the table is
    -- correct the moment it exists
    UNIQUE KEY `name` (`name`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3;

--
-- `account_sessions` -- schema.sql:686-703
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
-- `store_history` -- schema.sql:585-599
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
-- real accounts -- merge those by hand instead, then run 2b and 2c only.
--
-- Run 2b and 2c for every world, including a brand new one imported from
-- schema.sql: a fresh world schema still owns local `accounts`, `account_sessions`
-- and `store_history` tables (plus the seeded Account Manager row at
-- schema.sql:959), and a view cannot be created over a name a base table holds.
--
-- The constraint names in 2b are the ones schema.sql gives (schema.sql:1092,
-- 1099, 1106, 1112, 1176). An install created some other way may name them
-- differently -- confirm with:
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

-- -- 2b. Drop the five foreign keys that point at this world's local `accounts`.
-- --     InnoDB refuses to drop a table while a foreign key still references it.
-- --     `account_viplist` is in this list even though the plan's prose omits it.
-- ALTER TABLE `__WORLD_SCHEMA__`.`account_bans`        DROP FOREIGN KEY `account_bans_ibfk_1`;
-- ALTER TABLE `__WORLD_SCHEMA__`.`account_ban_history` DROP FOREIGN KEY `account_ban_history_ibfk_1`;
-- ALTER TABLE `__WORLD_SCHEMA__`.`account_storage`     DROP FOREIGN KEY `account_storage_ibfk_1`;
-- ALTER TABLE `__WORLD_SCHEMA__`.`account_viplist`     DROP FOREIGN KEY `account_viplist_ibfk_1`;
-- ALTER TABLE `__WORLD_SCHEMA__`.`players`             DROP FOREIGN KEY `players_ibfk_1`;

-- -- 2c. Drop the local tables so the views can take their names. Children first.
-- DROP TABLE IF EXISTS `__WORLD_SCHEMA__`.`account_sessions`;
-- DROP TABLE IF EXISTS `__WORLD_SCHEMA__`.`store_history`;
-- DROP TABLE IF EXISTS `__WORLD_SCHEMA__`.`accounts`;


-- =============================================================================
-- SECTION 3 -- the per-world views. This is the mechanism.
--
-- Same names, same columns, one shared set of rows. `ALGORITHM = MERGE` keeps
-- each view a rewrite rule over the base table rather than a materialised copy,
-- which is both what makes it updatable (O1) and what keeps a lookup on an
-- indexed column an index lookup instead of a scan of the whole account set.
--
-- Re-runnable: `CREATE OR REPLACE` refreshes the column list, which is exactly
-- what you must do after any change to an auth base table.
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


-- =============================================================================
-- SECTION 4 -- cross-schema foreign keys back to the auth schema (O2).
-- *** COMMENTED OUT: attempt these on the provisioning rig, keep what works. ***
--
-- A foreign key cannot reference a view, so these must name the auth base table
-- directly. If InnoDB refuses any of them, leave it out: nothing in the design
-- depends on them, but account deletion then has to cascade in application code,
-- and an orphaned `players` row is no longer impossible at the database level.
-- =============================================================================

-- ALTER TABLE `__WORLD_SCHEMA__`.`players`
--     ADD CONSTRAINT `players_ibfk_1` FOREIGN KEY (`account_id`)
--     REFERENCES `__AUTH_SCHEMA__`.`accounts` (`id`) ON DELETE CASCADE;
--
-- ALTER TABLE `__WORLD_SCHEMA__`.`account_bans`
--     ADD CONSTRAINT `account_bans_ibfk_1` FOREIGN KEY (`account_id`)
--     REFERENCES `__AUTH_SCHEMA__`.`accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
--
-- ALTER TABLE `__WORLD_SCHEMA__`.`account_ban_history`
--     ADD CONSTRAINT `account_ban_history_ibfk_1` FOREIGN KEY (`account_id`)
--     REFERENCES `__AUTH_SCHEMA__`.`accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
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
-- refuses to boot unless all three names below are views in the world schema and
-- all three base tables exist in the auth schema. These are the same two queries:
--
--   SELECT `TABLE_NAME`, `VIEW_DEFINITION` FROM `information_schema`.`VIEWS`
--    WHERE `TABLE_SCHEMA` = '__WORLD_SCHEMA__'
--      AND `TABLE_NAME` IN ('accounts', 'account_sessions', 'store_history');
--
--   SELECT `TABLE_NAME` FROM `information_schema`.`TABLES`
--    WHERE `TABLE_SCHEMA` = '__AUTH_SCHEMA__' AND `TABLE_TYPE` = 'BASE TABLE'
--      AND `TABLE_NAME` IN ('accounts', 'account_sessions', 'store_history');
--
-- It then probes every world listed in config/worlds.toml, which only warns:
--
--   SELECT EXISTS(SELECT 1 FROM `<each world schema>`.`players` LIMIT 1) AS `readable`;
-- =============================================================================
