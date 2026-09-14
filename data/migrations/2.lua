function onUpdateDatabase()
    print("> Updating database to version 3 : Bestiary kills and charm runes")

    db.query([[
        CREATE TABLE IF NOT EXISTS `player_bestiary` (
            `player_id` int NOT NULL,
            `race_id` smallint UNSIGNED NOT NULL,
            `kills` int UNSIGNED NOT NULL DEFAULT '0',
            PRIMARY KEY (`player_id`, `race_id`),
            FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
        ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3
    ]])

    db.query([[
        CREATE TABLE IF NOT EXISTS `player_charms` (
            `player_id` int NOT NULL,
            `charm_id` tinyint UNSIGNED NOT NULL,
            `tier` tinyint UNSIGNED NOT NULL DEFAULT '1',
            `race_id` smallint UNSIGNED NOT NULL DEFAULT '0',
            PRIMARY KEY (`player_id`, `charm_id`),
            FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
        ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3
    ]])

    local columns = db.storeQuery("SELECT `COLUMN_NAME` FROM `information_schema`.`COLUMNS` WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = 'players' AND `COLUMN_NAME` = 'charm_points'")
    if not columns then
        db.query("ALTER TABLE `players` ADD COLUMN `charm_points` int UNSIGNED NOT NULL DEFAULT '0'")
    else
        result.free(columns)
    end

    return true
end
