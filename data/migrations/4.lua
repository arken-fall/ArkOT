function onUpdateDatabase()
    print("> Updating database to version 5 : Exaltation forge")

    db.query([[
        CREATE TABLE IF NOT EXISTS `forge_history` (
            `id` int NOT NULL AUTO_INCREMENT,
            `player_id` int NOT NULL,
            `action` tinyint UNSIGNED NOT NULL DEFAULT '0',
            `description` varchar(255) NOT NULL DEFAULT '',
            `success` tinyint UNSIGNED NOT NULL DEFAULT '0',
            `bonus` tinyint UNSIGNED NOT NULL DEFAULT '0',
            `created` bigint NOT NULL DEFAULT '0',
            PRIMARY KEY (`id`),
            INDEX `player_id` (`player_id`),
            FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
        ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3
    ]])

    local columns = db.storeQuery("SELECT `COLUMN_NAME` FROM `information_schema`.`COLUMNS` WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = 'players' AND `COLUMN_NAME` = 'forge_dust'")
    if not columns then
        db.query("ALTER TABLE `players` ADD COLUMN `forge_dust` int UNSIGNED NOT NULL DEFAULT '0'")
        db.query("ALTER TABLE `players` ADD COLUMN `forge_dust_level` smallint UNSIGNED NOT NULL DEFAULT '100'")
    else
        result.free(columns)
    end

    return true
end
