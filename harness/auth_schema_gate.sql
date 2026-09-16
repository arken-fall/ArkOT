-- =============================================================================
-- auth_schema_gate.sql -- Gate G for the shared auth schema (multi-world phase 2)
-- =============================================================================
--
-- WHAT THIS PROVES
--
-- That the tables and views auth_schema.sql ships work on the MySQL server this
-- is run against, statement by statement, the way a world process issues them.
-- The gate never creates its own copy of a shipped table or view: every check
-- below exercises exactly what sections 1 and 3 of auth_schema.sql provisioned.
--
--   G0     the server version every result below belongs to.
--   G4     the five shipped world views are updatable, view columns are
--          reported by information_schema.COLUMNS, and the two presence tables
--          have no world-side view.
--   O1     unqualified INSERT / UPDATE through the `accounts`, `store_history`
--          and `account_sessions` views land in the auth base tables.
--   COIN   the guarded coin delta from src/store.cpp (ApplyCoinDelta) refuses an
--          unaffordable debit by matching no row, not by raising ERROR 1690.
--   BAN    the shipped ban tables (plan 3.B) work through their MERGE views:
--          insert, guarded delete, resent delete matches nothing, history insert.
--   PRES   the shipped presence tables (plan 3.A), schema-qualified, no views:
--          heartbeat, one claim wins, holder/expiry lookup, token-guarded
--          release, and Presence::Claim's takeover exactly as the code issues
--          it: taken when the holder world is expired, has no heartbeat row,
--          or is this world; refused on a wrong token, and refused when the
--          holder world's heartbeat is fresh at write time.
--   O2     a world-side foreign key into the auth schema is created, and
--          ON DELETE CASCADE works across schemas.
--   E      (separate block, see below) an orphan insert is refused with
--          ERROR 1452, and ALTER TABLE on a hoisted view is refused with
--          ERROR 1347.
--
-- Every check prints one labelled row: `check`, `expected`, `actual`. Pass/fail
-- is read straight off the output: a row passes when `actual` equals `expected`.
--
-- PREREQUISITE
--
-- Sections 1 and 3 of auth_schema.sql already run against the same two schemas,
-- so that the auth schema holds the seven base tables (`accounts`,
-- `account_sessions`, `store_history`, `account_bans`, `account_ban_history`,
-- `world_presence`, `account_presence`) and the world schema holds the five
-- views (`accounts`, `account_sessions`, `store_history`, `account_bans`,
-- `account_ban_history`). Use throwaway schemas: the gate writes rows into the
-- shipped tables and removes them again.
--
-- WHAT THE GATE OWNS
--
-- Only these, and cleanup touches nothing else:
--
--   tables  `__WORLD_SCHEMA__`.`gate_o2_child`, `__WORLD_SCHEMA__`.`gate_e_child`
--   rows    `accounts` named `__gate_o1__` / `__gate_o2__`, and every row keyed
--           to those accounts in `account_sessions`, `store_history`,
--           `account_bans`, `account_ban_history` and `account_presence`;
--           `world_presence` rows for world ids 254 and 255 (reserved for the
--           gate -- no real world may use them).
--
-- The account names, session id and world ids above are reserved for the gate.
-- It fails loudly, before it writes over anything, if any of those already
-- exists: the gate tables are created with plain CREATE TABLE (never IF NOT
-- EXISTS), the gate accounts are inserted plainly against `accounts`'s unique
-- `name`, and PRE-FLIGHT claims world ids 254 and 255 with plain INSERTs against
-- `world_presence`'s primary key. The shipped tables and views existing is
-- normal and never trips it. If pass 1 aborts at PRE-FLIGHT because world 254
-- or 255 already has a row, that row is not the gate's: do NOT run cleanup,
-- which deletes those two world ids.
--
-- PRIVILEGES
--
-- The connecting user must be able to create tables in both scratch schemas:
-- CREATE, DROP and REFERENCES (for the cross-schema foreign keys) on
-- `__WORLD_SCHEMA__`, REFERENCES on `__AUTH_SCHEMA__`, and SELECT, INSERT,
-- UPDATE, DELETE on both. The views are SQL SECURITY INVOKER, so the user needs
-- the auth-schema DML rights in its own right. Block E's ALTER is refused by
-- the server for being a view; without ALTER on `__WORLD_SCHEMA__` it would be
-- refused for privileges instead (ERROR 1142), which proves nothing, so grant
-- ALTER there too. A grant scoped to the scratch schema names (e.g. `gate\_%`)
-- is enough.
--
-- HOW TO RUN IT
--
-- `__AUTH_SCHEMA__` and `__WORLD_SCHEMA__` are the same two placeholders as
-- auth_schema.sql and are substituted the same way. The expected-error checks
-- (block E) cannot share a run with everything else: the mysql client aborts on
-- the first error, and running the whole file with --force would also let a
-- genuinely failed pre-flight or setup statement slide past. So the file is run
-- in two passes, selected by the marker lines around block E:
--
--   Pass 1 -- every check except E, strict (aborts on any error):
--
--   sed -e 's/__AUTH_SCHEMA__/gate_auth/g' \
--       -e 's/__WORLD_SCHEMA__/gate_world/g' \
--       -e '/^-- >>> EXPECTED-ERRORS BEGIN/,/^-- <<< EXPECTED-ERRORS END/d' \
--       harness/auth_schema_gate.sql | mysql -t -h 127.0.0.1 -P 3307 -u <user> -p
--
--   Pass 2 -- block E only, with --force so the second error still runs:
--
--   sed -n -e 's/__AUTH_SCHEMA__/gate_auth/g' \
--          -e 's/__WORLD_SCHEMA__/gate_world/g' \
--          -e '/^-- >>> EXPECTED-ERRORS BEGIN/,/^-- <<< EXPECTED-ERRORS END/p' \
--          harness/auth_schema_gate.sql | mysql -t --force -h 127.0.0.1 -P 3307 -u <user> -p 2>&1
--
-- Pass 1 passes when it runs to the end with no ERROR line and every row's
-- `actual` equals its `expected`. Pass 2 passes when its output holds exactly
-- two ERROR lines -- `ERROR 1452` then `ERROR 1347`, in that order -- and every
-- row's `actual` equals its `expected`. Any other ERROR code in pass 2 (1050,
-- 1146, 1142, ...) means a fixture failed and the check proved nothing. Block E
-- creates and drops its own table, so the two passes can run in either order.
--
-- If pass 1 aborts part-way after PRE-FLIGHT, the gate's objects and rows are
-- left behind; the CLEANUP section at the end is idempotent (IF EXISTS drops,
-- deletes matched to the gate's own names and ids) and can be run on its own to
-- clear them before retrying:
--
--   sed -n -e 's/__AUTH_SCHEMA__/gate_auth/g' \
--          -e 's/__WORLD_SCHEMA__/gate_world/g' \
--          -e '/^-- >>> CLEANUP BEGIN/,/^-- <<< CLEANUP END/p' \
--          harness/auth_schema_gate.sql | mysql -t -h 127.0.0.1 -P 3307 -u <user> -p
--
-- Cleanup drops only the gate's two tables and deletes only the gate's rows. It
-- never drops a shipped table or view, and never either schema: the operator
-- provisioned those with auth_schema.sql and decides what happens to them.
--
-- RECORDED RESULTS
--
-- The first run (by hand, MySQL 8.0.46, 2026-09-16) PASSED; see the
-- "Verification notes" block at the top of docs/plans/multi-world-phase2.md.
-- That run used gate-created copies of the ban and presence tables; this script
-- exercises the ones auth_schema.sql now ships. The result only holds for the
-- version G0 prints: re-run this gate whenever the server version or
-- auth_schema.sql changes, or before a real multi-world deployment, and record
-- the new result there.
--
-- NOTE ON UNSIGNED ARITHMETIC
--
-- On MySQL 8.0 an UNSIGNED column plus a negative value raises ERROR 1690 when
-- the result would go below zero. The only statements here that add a negative
-- to an UNSIGNED column are the COIN checks, which use the production guard's
-- CAST(... AS SIGNED) form on purpose. Nothing else subtracts from one: PRES's
-- `UNIX_TIMESTAMP() - 45` subtracts from a function result, not a column.
--
-- =============================================================================


-- =============================================================================
-- G0 -- server version
-- =============================================================================

SELECT 'G0 server version' AS `check`, 'MySQL 8.0.x (record it)' AS `expected`, VERSION() AS `actual`;


-- =============================================================================
-- PRE-FLIGHT -- claim everything the gate owns, failing loudly if it exists.
--
-- Nothing shipped is created here: auth_schema.sql sections 1 and 3 provide
-- every table and view the checks use.
-- =============================================================================

--
-- O2 fixture: a world-side base table whose foreign key names the auth base
-- table. Plain CREATE: an existing `gate_o2_child` stops pass 1 here. If the
-- server refuses a cross-schema foreign key, pass 1 also stops HERE with the
-- refusal on screen -- that is the O2 "created" result.
--
CREATE TABLE `__WORLD_SCHEMA__`.`gate_o2_child` (
    `id` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `account_id` int NOT NULL,
    INDEX `account_id` (`account_id`),
    FOREIGN KEY (`account_id`) REFERENCES `__AUTH_SCHEMA__`.`accounts` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3;

--
-- World ids 254 and 255 are the gate's. Plain INSERTs against the primary key
-- stop pass 1 here if either already has a row. 255 keeps its row as PRES's
-- stale world (last beat at 0); 254's is removed again so PRES's heartbeat
-- upsert starts from no row, as a freshly started world's does.
--
INSERT INTO `__AUTH_SCHEMA__`.`world_presence` (`world_id`, `beat_at`) VALUES (255, 0);
INSERT INTO `__AUTH_SCHEMA__`.`world_presence` (`world_id`, `beat_at`) VALUES (254, 0);
DELETE FROM `__AUTH_SCHEMA__`.`world_presence` WHERE `world_id` = 254;


-- =============================================================================
-- G4 -- the five views auth_schema.sql section 3 created are updatable
-- =============================================================================

SELECT CONCAT('G4 IS_UPDATABLE ', `TABLE_NAME`) AS `check`, 'YES' AS `expected`, `IS_UPDATABLE` AS `actual`
  FROM `information_schema`.`VIEWS`
 WHERE `TABLE_SCHEMA` = '__WORLD_SCHEMA__'
 ORDER BY `TABLE_NAME`;

SELECT 'G4 shipped views present in world schema' AS `check`,
       'account_ban_history,account_bans,account_sessions,accounts,store_history' AS `expected`,
       GROUP_CONCAT(`TABLE_NAME` ORDER BY `TABLE_NAME` SEPARATOR ',') AS `actual`
  FROM `information_schema`.`VIEWS`
 WHERE `TABLE_SCHEMA` = '__WORLD_SCHEMA__'
   AND `TABLE_NAME` IN ('accounts', 'account_sessions', 'store_history', 'account_bans', 'account_ban_history');

-- presence is auth-schema only by design: no world-side object of either name
SELECT 'G4 presence names absent from world schema' AS `check`, '0' AS `expected`, COUNT(*) AS `actual`
  FROM `information_schema`.`TABLES`
 WHERE `TABLE_SCHEMA` = '__WORLD_SCHEMA__'
   AND `TABLE_NAME` IN ('world_presence', 'account_presence');

SELECT 'G4 presence tables are auth base tables' AS `check`, 'BASE TABLE,BASE TABLE' AS `expected`,
       GROUP_CONCAT(`TABLE_TYPE` ORDER BY `TABLE_NAME` SEPARATOR ',') AS `actual`
  FROM `information_schema`.`TABLES`
 WHERE `TABLE_SCHEMA` = '__AUTH_SCHEMA__'
   AND `TABLE_NAME` IN ('world_presence', 'account_presence');

-- the migration guards (data/migrations) read COLUMNS, which must report view columns
SELECT 'G4 COLUMNS reports banned_by_name on both ban views' AS `check`, '2' AS `expected`, COUNT(*) AS `actual`
  FROM `information_schema`.`COLUMNS`
 WHERE `TABLE_SCHEMA` = '__WORLD_SCHEMA__'
   AND `TABLE_NAME` IN ('account_bans', 'account_ban_history')
   AND `COLUMN_NAME` = 'banned_by_name';


-- =============================================================================
-- O1 -- writes through the views, issued unqualified from the world schema
-- =============================================================================

-- a world process resolves unqualified names against its own schema
USE `__WORLD_SCHEMA__`;

INSERT INTO `accounts` (`name`, `password`) VALUES ('__gate_o1__', 'x');
SELECT 'O1 INSERT INTO accounts' AS `check`, '1' AS `expected`, ROW_COUNT() AS `actual`;

UPDATE `accounts` SET `coins` = `coins` + 1 WHERE `name` = '__gate_o1__';
SELECT 'O1 UPDATE accounts' AS `check`, '1' AS `expected`, ROW_COUNT() AS `actual`;

-- captured once; a MERGE view cannot be written while a subquery reads the same view
SET @gate_account = (SELECT `id` FROM `accounts` WHERE `name` = '__gate_o1__');

INSERT INTO `store_history` (`account_id`, `amount`, `description`) VALUES (@gate_account, 0, '__gate_o1__');
SELECT 'O1 INSERT INTO store_history' AS `check`, '1' AS `expected`, ROW_COUNT() AS `actual`;

INSERT INTO `account_sessions` (`id`, `account_id`, `ip`, `created`, `expires`, `character_name`)
     VALUES ('__gate_o1_session__', @gate_account, 0, 0, 0, '__gate_o1__');
SELECT 'O1 INSERT INTO account_sessions' AS `check`, '1' AS `expected`, ROW_COUNT() AS `actual`;

-- read back from the auth BASE tables by schema name: the writes landed there
SELECT 'O1 auth accounts row, coins = 1' AS `check`, '1' AS `expected`, COUNT(*) AS `actual`
  FROM `__AUTH_SCHEMA__`.`accounts`
 WHERE `name` = '__gate_o1__' AND `coins` = 1;

SELECT 'O1 auth store_history row' AS `check`, '1' AS `expected`, COUNT(*) AS `actual`
  FROM `__AUTH_SCHEMA__`.`store_history`
 WHERE `account_id` = @gate_account AND `description` = '__gate_o1__';

SELECT 'O1 auth account_sessions row' AS `check`, '1' AS `expected`, COUNT(*) AS `actual`
  FROM `__AUTH_SCHEMA__`.`account_sessions`
 WHERE `id` = '__gate_o1_session__' AND `account_id` = @gate_account;

-- and the world-side names really are views, not tables the rows could hide in
SELECT 'O1 world-side TABLE_TYPE of the 3 hoisted names' AS `check`, 'VIEW,VIEW,VIEW' AS `expected`,
       GROUP_CONCAT(`TABLE_TYPE` ORDER BY `TABLE_NAME` SEPARATOR ',') AS `actual`
  FROM `information_schema`.`TABLES`
 WHERE `TABLE_SCHEMA` = '__WORLD_SCHEMA__'
   AND `TABLE_NAME` IN ('accounts', 'account_sessions', 'store_history');


-- =============================================================================
-- COIN -- the guarded delta, exactly as src/store.cpp ApplyCoinDelta issues it
--
-- The SQL string is copied from ApplyCoinDelta; its fmt placeholders are
-- replaced by literal deltas, and the account id by @gate_account (the id is
-- AUTO_INCREMENT, so it is not known when this file is written).
-- =============================================================================

-- fixture: a known starting balance, set absolutely (no arithmetic)
UPDATE `accounts` SET `coins` = 10, `coins_transferable` = 5 WHERE `id` = @gate_account;
SELECT 'COIN setup: balance 10 / 5' AS `check`, '1' AS `expected`, ROW_COUNT() AS `actual`;

-- affordable debit: 10/5 -> 7/5
UPDATE `accounts` SET `coins` = `coins` + (-3), `coins_transferable` = `coins_transferable` + (0) WHERE `id` = @gate_account AND CAST(`coins` AS SIGNED) + (-3) >= 0 AND CAST(`coins_transferable` AS SIGNED) + (0) >= 0;
SELECT 'COIN affordable debit (-3, 0)' AS `check`, '1' AS `expected`, ROW_COUNT() AS `actual`;

-- exact-balance debit: 7/5 -> 0/0
UPDATE `accounts` SET `coins` = `coins` + (-7), `coins_transferable` = `coins_transferable` + (-5) WHERE `id` = @gate_account AND CAST(`coins` AS SIGNED) + (-7) >= 0 AND CAST(`coins_transferable` AS SIGNED) + (-5) >= 0;
SELECT 'COIN exact-balance debit (-7, -5)' AS `check`, '1' AS `expected`, ROW_COUNT() AS `actual`;

-- unaffordable debit: must match no row and raise NO error (not ERROR 1690)
UPDATE `accounts` SET `coins` = `coins` + (-1), `coins_transferable` = `coins_transferable` + (0) WHERE `id` = @gate_account AND CAST(`coins` AS SIGNED) + (-1) >= 0 AND CAST(`coins_transferable` AS SIGNED) + (0) >= 0;
SELECT 'COIN unaffordable debit (-1, 0), no error' AS `check`, '0' AS `expected`, ROW_COUNT() AS `actual`;

-- credit: 0/0 -> 4/2
UPDATE `accounts` SET `coins` = `coins` + (4), `coins_transferable` = `coins_transferable` + (2) WHERE `id` = @gate_account AND CAST(`coins` AS SIGNED) + (4) >= 0 AND CAST(`coins_transferable` AS SIGNED) + (2) >= 0;
SELECT 'COIN credit (+4, +2)' AS `check`, '1' AS `expected`, ROW_COUNT() AS `actual`;

SELECT 'COIN final balance in auth base table' AS `check`, '4 / 2' AS `expected`,
       CONCAT(`coins`, ' / ', `coins_transferable`) AS `actual`
  FROM `__AUTH_SCHEMA__`.`accounts`
 WHERE `id` = @gate_account;


-- =============================================================================
-- BAN -- plan 3.B, through the world-side views, unqualified
-- =============================================================================

INSERT INTO `account_bans` (`account_id`, `reason`, `banned_at`, `expires_at`, `banned_by`, `banned_by_name`)
     VALUES (@gate_account, '__gate_ban__', 1000, 2000, 0, '__gate_banner__');
SELECT 'BAN insert via view' AS `check`, '1' AS `expected`, ROW_COUNT() AS `actual`;

-- the guarded delete that decides who writes history (RetireExpiredBan)
DELETE FROM `account_bans` WHERE `account_id` = @gate_account AND `banned_at` = 1000 AND `expires_at` = 2000;
SELECT 'BAN guarded delete' AS `check`, '1' AS `expected`, ROW_COUNT() AS `actual`;

-- the same delete resent (a second world, or executeQuery after a lost connection)
DELETE FROM `account_bans` WHERE `account_id` = @gate_account AND `banned_at` = 1000 AND `expires_at` = 2000;
SELECT 'BAN same delete resent' AS `check`, '0' AS `expected`, ROW_COUNT() AS `actual`;

INSERT INTO `account_ban_history` (`account_id`, `reason`, `banned_at`, `expired_at`, `banned_by`, `banned_by_name`)
     VALUES (@gate_account, '__gate_ban__', 1000, 2000, 0, '__gate_banner__');
SELECT 'BAN history insert via view' AS `check`, '1' AS `expected`, ROW_COUNT() AS `actual`;

SELECT 'BAN history row in auth base table' AS `check`, '1' AS `expected`, COUNT(*) AS `actual`
  FROM `__AUTH_SCHEMA__`.`account_ban_history`
 WHERE `account_id` = @gate_account AND `banned_by_name` = '__gate_banner__';


-- =============================================================================
-- PRES -- plan 3.A, against the shipped auth-schema tables, no views
--
-- World 254 plays "this world" throughout: it beats now and issues every
-- takeover. World 255 is the other world; its heartbeat row is moved through
-- expired (beat_at 0, from PRE-FLIGHT), fresh, and missing. Lease is the plan's
-- 45 seconds, so pass 1 must reach the end of this block within 45 s of the
-- world 254 upsert below (it normally takes well under a second).
--
-- Every takeover UPDATE is Presence::Claim's takeoverQuery (src/presence.cpp)
-- copied exactly, one line as fmt renders it: this world 254, player 2541,
-- name '__gate_char_w254__', Lease 45, the account id as @gate_account (it is
-- AUTO_INCREMENT, so it is not known when this file is written). Only the new
-- claim token and the holder token differ between checks. Its WHERE re-checks
-- at execution that the holder is still abandoned: the row is this world's,
-- or its world's heartbeat row is missing or older than the lease.
--
-- UNIX_TIMESTAMP() - 45 subtracts from a function result, never an UNSIGNED
-- column; `beat_at` is signed. Tokens and world ids are compared for equality.
-- =============================================================================

-- The guard's world_presence read is a locking read under REPEATABLE READ, so a
-- takeover and a heartbeat upsert on the holder world serialize. Record it.
SELECT 'PRES global transaction isolation' AS `check`, 'REPEATABLE-READ' AS `expected`, @@GLOBAL.transaction_isolation AS `actual`;

-- heartbeat upsert (Presence::Beat); PRE-FLIGHT left no row for 254, so it reports 1
INSERT INTO `__AUTH_SCHEMA__`.`world_presence` (`world_id`, `beat_at`) VALUES (254, UNIX_TIMESTAMP())
    ON DUPLICATE KEY UPDATE `beat_at` = UNIX_TIMESTAMP();
SELECT 'PRES heartbeat upsert, world 254 (new row)' AS `check`, '1' AS `expected`, ROW_COUNT() AS `actual`;

--
-- 1. holder world's heartbeat EXPIRED
--

-- first claim, by world 255
INSERT IGNORE INTO `__AUTH_SCHEMA__`.`account_presence` (`account_id`, `world_id`, `player_id`, `character_name`, `claim_token`, `claimed_at`)
     VALUES (@gate_account, 255, 2552, '__gate_char_w255__', 222, UNIX_TIMESTAMP());
SELECT 'PRES first claim (world 255, token 222)' AS `check`, '1' AS `expected`, ROW_COUNT() AS `actual`;

-- competing claim, by world 254: the primary key lets exactly one win
INSERT IGNORE INTO `__AUTH_SCHEMA__`.`account_presence` (`account_id`, `world_id`, `player_id`, `character_name`, `claim_token`, `claimed_at`)
     VALUES (@gate_account, 254, 2541, '__gate_char_w254__', 111, UNIX_TIMESTAMP());
SELECT 'PRES competing claim (world 254, token 111)' AS `check`, '0' AS `expected`, ROW_COUNT() AS `actual`;

-- holder/expiry lookup (Presence::Claim step 2): world 255's beat is stale
SELECT 'PRES holder lookup: expired holder' AS `check`, '255 | 222 | __gate_char_w255__ | 1' AS `expected`,
       (SELECT CONCAT_WS(' | ', `p`.`world_id`, `p`.`claim_token`, `p`.`character_name`,
                         (COALESCE(`w`.`beat_at`, 0) < UNIX_TIMESTAMP() - 45))
          FROM `__AUTH_SCHEMA__`.`account_presence` AS `p`
          LEFT JOIN `__AUTH_SCHEMA__`.`world_presence` AS `w` ON `w`.`world_id` = `p`.`world_id`
         WHERE `p`.`account_id` = @gate_account) AS `actual`;

-- takeover with a wrong holder token: the holder IS abandoned, so only the token refuses it
UPDATE `__AUTH_SCHEMA__`.`account_presence` `p` SET `world_id` = 254, `player_id` = 2541, `character_name` = '__gate_char_w254__', `claim_token` = 111, `claimed_at` = UNIX_TIMESTAMP() WHERE `p`.`account_id` = @gate_account AND `p`.`claim_token` = 999 AND (`p`.`world_id` = 254 OR NOT EXISTS (SELECT 1 FROM `__AUTH_SCHEMA__`.`world_presence` `w` WHERE `w`.`world_id` = `p`.`world_id` AND `w`.`beat_at` >= UNIX_TIMESTAMP() - 45));
SELECT 'PRES takeover, wrong token (999), holder expired' AS `check`, '0' AS `expected`, ROW_COUNT() AS `actual`;

-- takeover with the right holder token of an expired holder world
UPDATE `__AUTH_SCHEMA__`.`account_presence` `p` SET `world_id` = 254, `player_id` = 2541, `character_name` = '__gate_char_w254__', `claim_token` = 111, `claimed_at` = UNIX_TIMESTAMP() WHERE `p`.`account_id` = @gate_account AND `p`.`claim_token` = 222 AND (`p`.`world_id` = 254 OR NOT EXISTS (SELECT 1 FROM `__AUTH_SCHEMA__`.`world_presence` `w` WHERE `w`.`world_id` = `p`.`world_id` AND `w`.`beat_at` >= UNIX_TIMESTAMP() - 45));
SELECT 'PRES takeover, holder world expired (token 222)' AS `check`, '1' AS `expected`, ROW_COUNT() AS `actual`;

-- the same lookup now finds a live holder
SELECT 'PRES holder lookup: live holder' AS `check`, '254 | 111 | __gate_char_w254__ | 0' AS `expected`,
       (SELECT CONCAT_WS(' | ', `p`.`world_id`, `p`.`claim_token`, `p`.`character_name`,
                         (COALESCE(`w`.`beat_at`, 0) < UNIX_TIMESTAMP() - 45))
          FROM `__AUTH_SCHEMA__`.`account_presence` AS `p`
          LEFT JOIN `__AUTH_SCHEMA__`.`world_presence` AS `w` ON `w`.`world_id` = `p`.`world_id`
         WHERE `p`.`account_id` = @gate_account) AS `actual`;

-- token-guarded release (PresenceClaim)
DELETE FROM `__AUTH_SCHEMA__`.`account_presence` WHERE `account_id` = @gate_account AND `claim_token` = 111;
SELECT 'PRES token-guarded release (token 111)' AS `check`, '1' AS `expected`, ROW_COUNT() AS `actual`;

--
-- 2. holder world's heartbeat FRESH -- the race: a lookup read world 255 as
--    expired, then world 255 recovered before the takeover executed
--

-- world 255 recovers: the upsert overwrites its existing beat_at 0, so it reports 2
INSERT INTO `__AUTH_SCHEMA__`.`world_presence` (`world_id`, `beat_at`) VALUES (255, UNIX_TIMESTAMP())
    ON DUPLICATE KEY UPDATE `beat_at` = UNIX_TIMESTAMP();
SELECT 'PRES heartbeat upsert, world 255 recovers (existing row)' AS `check`, '2' AS `expected`, ROW_COUNT() AS `actual`;

INSERT IGNORE INTO `__AUTH_SCHEMA__`.`account_presence` (`account_id`, `world_id`, `player_id`, `character_name`, `claim_token`, `claimed_at`)
     VALUES (@gate_account, 255, 2552, '__gate_char_w255__', 333, UNIX_TIMESTAMP());
SELECT 'PRES claim (world 255, token 333)' AS `check`, '1' AS `expected`, ROW_COUNT() AS `actual`;

SELECT 'PRES holder lookup: recovered holder' AS `check`, '255 | 333 | __gate_char_w255__ | 0' AS `expected`,
       (SELECT CONCAT_WS(' | ', `p`.`world_id`, `p`.`claim_token`, `p`.`character_name`,
                         (COALESCE(`w`.`beat_at`, 0) < UNIX_TIMESTAMP() - 45))
          FROM `__AUTH_SCHEMA__`.`account_presence` AS `p`
          LEFT JOIN `__AUTH_SCHEMA__`.`world_presence` AS `w` ON `w`.`world_id` = `p`.`world_id`
         WHERE `p`.`account_id` = @gate_account) AS `actual`;

-- the takeover a stale lookup would issue, with the CORRECT holder token: must match nothing
UPDATE `__AUTH_SCHEMA__`.`account_presence` `p` SET `world_id` = 254, `player_id` = 2541, `character_name` = '__gate_char_w254__', `claim_token` = 444, `claimed_at` = UNIX_TIMESTAMP() WHERE `p`.`account_id` = @gate_account AND `p`.`claim_token` = 333 AND (`p`.`world_id` = 254 OR NOT EXISTS (SELECT 1 FROM `__AUTH_SCHEMA__`.`world_presence` `w` WHERE `w`.`world_id` = `p`.`world_id` AND `w`.`beat_at` >= UNIX_TIMESTAMP() - 45));
SELECT 'PRES takeover, holder world fresh (token 333), race closed' AS `check`, '0' AS `expected`, ROW_COUNT() AS `actual`;

SELECT 'PRES claim untouched by the refused takeover' AS `check`, '255 | 333 | __gate_char_w255__' AS `expected`,
       (SELECT CONCAT_WS(' | ', `world_id`, `claim_token`, `character_name`)
          FROM `__AUTH_SCHEMA__`.`account_presence`
         WHERE `account_id` = @gate_account) AS `actual`;

--
-- 3. holder world has NO heartbeat row (e.g. it retired, or never beat)
--

DELETE FROM `__AUTH_SCHEMA__`.`world_presence` WHERE `world_id` = 255;
SELECT 'PRES remove world 255 heartbeat row' AS `check`, '1' AS `expected`, ROW_COUNT() AS `actual`;

SELECT 'PRES holder lookup: holder without heartbeat row' AS `check`, '255 | 333 | __gate_char_w255__ | 1' AS `expected`,
       (SELECT CONCAT_WS(' | ', `p`.`world_id`, `p`.`claim_token`, `p`.`character_name`,
                         (COALESCE(`w`.`beat_at`, 0) < UNIX_TIMESTAMP() - 45))
          FROM `__AUTH_SCHEMA__`.`account_presence` AS `p`
          LEFT JOIN `__AUTH_SCHEMA__`.`world_presence` AS `w` ON `w`.`world_id` = `p`.`world_id`
         WHERE `p`.`account_id` = @gate_account) AS `actual`;

UPDATE `__AUTH_SCHEMA__`.`account_presence` `p` SET `world_id` = 254, `player_id` = 2541, `character_name` = '__gate_char_w254__', `claim_token` = 444, `claimed_at` = UNIX_TIMESTAMP() WHERE `p`.`account_id` = @gate_account AND `p`.`claim_token` = 333 AND (`p`.`world_id` = 254 OR NOT EXISTS (SELECT 1 FROM `__AUTH_SCHEMA__`.`world_presence` `w` WHERE `w`.`world_id` = `p`.`world_id` AND `w`.`beat_at` >= UNIX_TIMESTAMP() - 45));
SELECT 'PRES takeover, holder world has no heartbeat row (token 333)' AS `check`, '1' AS `expected`, ROW_COUNT() AS `actual`;

--
-- 4. claim held by THIS world (a leftover token), whose own heartbeat is fresh
--

SELECT 'PRES holder lookup: this world, fresh' AS `check`, '254 | 444 | __gate_char_w254__ | 0' AS `expected`,
       (SELECT CONCAT_WS(' | ', `p`.`world_id`, `p`.`claim_token`, `p`.`character_name`,
                         (COALESCE(`w`.`beat_at`, 0) < UNIX_TIMESTAMP() - 45))
          FROM `__AUTH_SCHEMA__`.`account_presence` AS `p`
          LEFT JOIN `__AUTH_SCHEMA__`.`world_presence` AS `w` ON `w`.`world_id` = `p`.`world_id`
         WHERE `p`.`account_id` = @gate_account) AS `actual`;

UPDATE `__AUTH_SCHEMA__`.`account_presence` `p` SET `world_id` = 254, `player_id` = 2541, `character_name` = '__gate_char_w254__', `claim_token` = 555, `claimed_at` = UNIX_TIMESTAMP() WHERE `p`.`account_id` = @gate_account AND `p`.`claim_token` = 444 AND (`p`.`world_id` = 254 OR NOT EXISTS (SELECT 1 FROM `__AUTH_SCHEMA__`.`world_presence` `w` WHERE `w`.`world_id` = `p`.`world_id` AND `w`.`beat_at` >= UNIX_TIMESTAMP() - 45));
SELECT 'PRES takeover, holder is this world, heartbeat fresh (token 444)' AS `check`, '1' AS `expected`, ROW_COUNT() AS `actual`;

SELECT 'PRES claim after this-world takeover' AS `check`, '254 | 555 | __gate_char_w254__' AS `expected`,
       (SELECT CONCAT_WS(' | ', `world_id`, `claim_token`, `character_name`)
          FROM `__AUTH_SCHEMA__`.`account_presence`
         WHERE `account_id` = @gate_account) AS `actual`;

DELETE FROM `__AUTH_SCHEMA__`.`account_presence` WHERE `account_id` = @gate_account AND `claim_token` = 555;
SELECT 'PRES token-guarded release (token 555)' AS `check`, '1' AS `expected`, ROW_COUNT() AS `actual`;


-- =============================================================================
-- O2 -- cross-schema foreign key with ON DELETE CASCADE
--
-- Uses its own account so the cascade touches nothing the checks above made.
-- (The foreign key itself was created in PRE-FLIGHT.)
-- =============================================================================

INSERT INTO `__AUTH_SCHEMA__`.`accounts` (`name`, `password`) VALUES ('__gate_o2__', 'x');
SET @gate_o2_account = (SELECT `id` FROM `__AUTH_SCHEMA__`.`accounts` WHERE `name` = '__gate_o2__');

INSERT INTO `__WORLD_SCHEMA__`.`gate_o2_child` (`account_id`) VALUES (@gate_o2_account);
SELECT 'O2 valid child insert' AS `check`, '1' AS `expected`, ROW_COUNT() AS `actual`;

DELETE FROM `__AUTH_SCHEMA__`.`accounts` WHERE `id` = @gate_o2_account;
SELECT 'O2 delete the auth account' AS `check`, '1' AS `expected`, ROW_COUNT() AS `actual`;

SELECT 'O2 child rows remaining after cascade' AS `check`, '0' AS `expected`, COUNT(*) AS `actual`
  FROM `__WORLD_SCHEMA__`.`gate_o2_child`
 WHERE `account_id` = @gate_o2_account;


-- >>> EXPECTED-ERRORS BEGIN
-- =============================================================================
-- E -- checks that MUST raise an error.  PASS 2 ONLY, run with `mysql --force`.
--
-- Excluded from pass 1 by the sed range in the header. Self-contained: it
-- creates its own fixture and drops it, so it does not depend on pass 1 having
-- run, or on pass 1's cleanup not having run.
--
-- Expected output, in order: ERROR 1452 at the orphan insert, then ERROR 1347 at
-- the ALTER. The label row printed before each statement names the error to
-- look for; the row after it confirms nothing was written.
-- =============================================================================

USE `__WORLD_SCHEMA__`;

CREATE TABLE `__WORLD_SCHEMA__`.`gate_e_child` (
    `id` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `account_id` int NOT NULL,
    INDEX `account_id` (`account_id`),
    FOREIGN KEY (`account_id`) REFERENCES `__AUTH_SCHEMA__`.`accounts` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3;

-- no account has id -1 (AUTO_INCREMENT never issues it), so this row is an orphan
SELECT 'E1 orphan child insert (next statement)' AS `check`, 'ERROR 1452' AS `expected`, 'see the ERROR line below' AS `actual`;
INSERT INTO `__WORLD_SCHEMA__`.`gate_e_child` (`account_id`) VALUES (-1);
SELECT 'E1 orphan rows written' AS `check`, '0' AS `expected`, COUNT(*) AS `actual`
  FROM `__WORLD_SCHEMA__`.`gate_e_child`;

-- a world process must never ALTER a hoisted table; the server enforces it
SELECT 'E2 ALTER TABLE on hoisted view accounts (next statement)' AS `check`, 'ERROR 1347' AS `expected`, 'see the ERROR line below' AS `actual`;
ALTER TABLE `__WORLD_SCHEMA__`.`accounts` ADD COLUMN `gate_e_probe` int NOT NULL DEFAULT '0';
SELECT 'E2 gate_e_probe column present anywhere' AS `check`, '0' AS `expected`, COUNT(*) AS `actual`
  FROM `information_schema`.`COLUMNS`
 WHERE `TABLE_SCHEMA` IN ('__WORLD_SCHEMA__', '__AUTH_SCHEMA__')
   AND `COLUMN_NAME` = 'gate_e_probe';

DROP TABLE IF EXISTS `__WORLD_SCHEMA__`.`gate_e_child`;
-- <<< EXPECTED-ERRORS END


-- >>> CLEANUP BEGIN
-- =============================================================================
-- CLEANUP -- remove only what the gate owns.
--
-- Drops the gate's two tables and deletes the gate's rows from the shipped
-- tables. NEVER drops a shipped table or view (auth_schema.sql provisioned
-- those) and NEVER either schema.
--
-- Idempotent: drops are IF EXISTS and every delete matches the gate's own
-- account names, session id and world ids, so this section can also be run on
-- its own after pass 1 aborted past PRE-FLIGHT (command in the header). Rows
-- keyed to a gate account are deleted explicitly, children before `accounts`,
-- rather than left to the cascades, so cleanup does not depend on them.
-- All deletes name the auth base tables directly.
-- =============================================================================

DROP TABLE IF EXISTS `__WORLD_SCHEMA__`.`gate_o2_child`;
DROP TABLE IF EXISTS `__WORLD_SCHEMA__`.`gate_e_child`;

DELETE FROM `__AUTH_SCHEMA__`.`account_presence`
 WHERE `account_id` IN (SELECT `id` FROM `__AUTH_SCHEMA__`.`accounts` WHERE `name` IN ('__gate_o1__', '__gate_o2__'));
DELETE FROM `__AUTH_SCHEMA__`.`world_presence` WHERE `world_id` IN (254, 255);
DELETE FROM `__AUTH_SCHEMA__`.`account_bans`
 WHERE `account_id` IN (SELECT `id` FROM `__AUTH_SCHEMA__`.`accounts` WHERE `name` IN ('__gate_o1__', '__gate_o2__'));
DELETE FROM `__AUTH_SCHEMA__`.`account_ban_history`
 WHERE `account_id` IN (SELECT `id` FROM `__AUTH_SCHEMA__`.`accounts` WHERE `name` IN ('__gate_o1__', '__gate_o2__'));
DELETE FROM `__AUTH_SCHEMA__`.`account_sessions` WHERE `id` = '__gate_o1_session__';
DELETE FROM `__AUTH_SCHEMA__`.`store_history`
 WHERE `account_id` IN (SELECT `id` FROM `__AUTH_SCHEMA__`.`accounts` WHERE `name` IN ('__gate_o1__', '__gate_o2__'));
DELETE FROM `__AUTH_SCHEMA__`.`accounts` WHERE `name` IN ('__gate_o1__', '__gate_o2__');

SELECT 'CLEANUP gate accounts remaining' AS `check`, '0' AS `expected`, COUNT(*) AS `actual`
  FROM `__AUTH_SCHEMA__`.`accounts`
 WHERE `name` IN ('__gate_o1__', '__gate_o2__');

SELECT 'CLEANUP gate rows remaining in shipped tables' AS `check`, '0' AS `expected`,
       (SELECT COUNT(*) FROM `__AUTH_SCHEMA__`.`world_presence` WHERE `world_id` IN (254, 255))
     + (SELECT COUNT(*) FROM `__AUTH_SCHEMA__`.`account_presence` WHERE `world_id` IN (254, 255))
     + (SELECT COUNT(*) FROM `__AUTH_SCHEMA__`.`account_sessions` WHERE `id` = '__gate_o1_session__')
     + (SELECT COUNT(*) FROM `__AUTH_SCHEMA__`.`store_history` WHERE `description` = '__gate_o1__')
     + (SELECT COUNT(*) FROM `__AUTH_SCHEMA__`.`account_bans` WHERE `reason` = '__gate_ban__')
     + (SELECT COUNT(*) FROM `__AUTH_SCHEMA__`.`account_ban_history` WHERE `reason` = '__gate_ban__') AS `actual`;

SELECT 'CLEANUP gate tables remaining' AS `check`, '0' AS `expected`, COUNT(*) AS `actual`
  FROM `information_schema`.`TABLES`
 WHERE `TABLE_SCHEMA` = '__WORLD_SCHEMA__'
   AND `TABLE_NAME` IN ('gate_o2_child', 'gate_e_child');

SELECT 'CLEANUP shipped views/tables still present' AS `check`, '12' AS `expected`, COUNT(*) AS `actual`
  FROM `information_schema`.`TABLES`
 WHERE (`TABLE_SCHEMA` = '__WORLD_SCHEMA__'
        AND `TABLE_NAME` IN ('accounts', 'account_sessions', 'store_history', 'account_bans', 'account_ban_history'))
    OR (`TABLE_SCHEMA` = '__AUTH_SCHEMA__'
        AND `TABLE_NAME` IN ('accounts', 'account_sessions', 'store_history', 'account_bans', 'account_ban_history',
                             'world_presence', 'account_presence'));
-- <<< CLEANUP END
