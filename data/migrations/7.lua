function onUpdateDatabase()
    print("> Updating database to version 8 : Ban issuer names (banned_by_name)")

    -- Bans store the issuer's name instead of relying on a foreign key to this
    -- world's `players`. The name is frozen at ban time; `banned_by` stays for
    -- compatibility. Dropping that foreign key also removes its ON DELETE
    -- CASCADE, which deleted every ban a GM issued when the GM's character was
    -- deleted -- a defect this migration removes on purpose.
    local banTables = { "account_bans", "account_ban_history" }

    local function tableType(tableName)
        local resultId = db.storeQuery(string.format(
            "SELECT `TABLE_TYPE` FROM `information_schema`.`TABLES` WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = '%s'",
            tableName
        ))
        if not resultId then
            return nil
        end

        local kind = result.getString(resultId, "TABLE_TYPE")
        result.free(resultId)
        return kind
    end

    local function columnExists(tableName, columnName)
        local resultId = db.storeQuery(string.format(
            "SELECT 1 FROM `information_schema`.`COLUMNS` WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = '%s' AND `COLUMN_NAME` = '%s'",
            tableName, columnName
        ))
        if resultId then
            result.free(resultId)
            return true
        end
        return false
    end

    -- Constraint names differ between installs, so they are looked up, never assumed.
    local function playersForeignKeys(tableName)
        local names = {}
        local resultId = db.storeQuery(string.format(
            "SELECT DISTINCT `CONSTRAINT_NAME` FROM `information_schema`.`KEY_COLUMN_USAGE` WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = '%s' AND `REFERENCED_TABLE_SCHEMA` = DATABASE() AND `REFERENCED_TABLE_NAME` = 'players'",
            tableName
        ))
        if resultId then
            repeat
                names[#names + 1] = result.getString(resultId, "CONSTRAINT_NAME")
            until not result.next(resultId)
            result.free(resultId)
        end
        return names
    end

    -- Classify every table before altering anything, so a stale view refuses the
    -- migration without leaving the other table half-migrated.
    local baseTables = {}
    for _, tableName in ipairs(banTables) do
        local kind = tableType(tableName)
        if kind == "BASE TABLE" then
            baseTables[#baseTables + 1] = tableName
        elseif kind == "VIEW" then
            -- A hoisted table is never altered by a world process (the server
            -- refuses it anyway: ERROR 1347). The auth base table already has the
            -- column; only the view's frozen column list is stale.
            if not columnExists(tableName, "banned_by_name") then
                print(string.format("  > `%s` is a view without `banned_by_name`: re-run section 3 of auth_schema.sql for this world, then restart", tableName))
                return false
            end
        else
            print(string.format("  > `%s` does not exist in this schema; cannot add `banned_by_name`", tableName))
            return false
        end
    end

    for _, tableName in ipairs(baseTables) do
        if not columnExists(tableName, "banned_by_name") then
            print(string.format("  > Adding banned_by_name column to %s", tableName))
            if not db.query(string.format(
                "ALTER TABLE `%s` ADD COLUMN `banned_by_name` varchar(255) NOT NULL DEFAULT '' AFTER `banned_by`",
                tableName
            )) then
                return false
            end
        end

        -- Guarded by the empty-name check, so re-running after a partial failure
        -- only fills rows that are still unnamed.
        if not db.query(string.format(
            "UPDATE `%s` AS `t` JOIN `players` AS `p` ON `p`.`id` = `t`.`banned_by` SET `t`.`banned_by_name` = `p`.`name` WHERE `t`.`banned_by_name` = ''",
            tableName
        )) then
            return false
        end

        for _, constraintName in ipairs(playersForeignKeys(tableName)) do
            print(string.format("  > Dropping foreign key %s (%s -> players)", constraintName, tableName))
            if not db.query(string.format(
                "ALTER TABLE `%s` DROP FOREIGN KEY `%s`",
                tableName, (constraintName:gsub("`", "``"))
            )) then
                return false
            end
        end
    end

    return true
end
