function onUpdateDatabase()
    print("> Updating database to version 2 : Modern client login (account_sessions + webservice compat)")

    -- Session keys issued by the login webservice. The webservice stores the
    -- SHA-256 of the key it hands the client; the game server only reads.
    db.query([[
        CREATE TABLE IF NOT EXISTS `account_sessions` (
            `id` varchar(191) NOT NULL PRIMARY KEY,
            `account_id` int NOT NULL,
            `ip` int UNSIGNED NOT NULL DEFAULT '0',
            `created` bigint NOT NULL DEFAULT '0',
            `expires` bigint NOT NULL DEFAULT '0',
            `character_name` varchar(255) DEFAULT NULL,
            FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
    ]])

    -- Columns the opentibiabr login webservice selects; the game server keeps
    -- using premium_ends_at as the authoritative premium source.
    local function columnExists(tableName, columnName)
        local query = string.format(
            "SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = '%s' AND COLUMN_NAME = '%s'",
            tableName, columnName
        )
        local queryResult = db.storeQuery(query)
        if queryResult then
            result.free(queryResult)
            return true
        end
        return false
    end

    if not columnExists("accounts", "premdays") then
        db.query("ALTER TABLE `accounts` ADD COLUMN `premdays` int NOT NULL DEFAULT '0'")
    end

    if not columnExists("accounts", "lastday") then
        db.query("ALTER TABLE `accounts` ADD COLUMN `lastday` int UNSIGNED NOT NULL DEFAULT '0'")
    end

    print("> Database update completed")
    return true
end
