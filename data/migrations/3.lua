function onUpdateDatabase()
    print("> Updating database to version 4 : Prey slots and wildcards")

    db.query([[
        CREATE TABLE IF NOT EXISTS `player_prey` (
            `player_id` int NOT NULL,
            `slot` tinyint UNSIGNED NOT NULL,
            `state` tinyint UNSIGNED NOT NULL DEFAULT '0',
            `race_id` smallint UNSIGNED NOT NULL DEFAULT '0',
            `option` tinyint UNSIGNED NOT NULL DEFAULT '0',
            `bonus_type` tinyint UNSIGNED NOT NULL DEFAULT '4',
            `bonus_rarity` tinyint UNSIGNED NOT NULL DEFAULT '1',
            `bonus_percentage` smallint UNSIGNED NOT NULL DEFAULT '0',
            `bonus_time` smallint UNSIGNED NOT NULL DEFAULT '0',
            `free_reroll` bigint NOT NULL DEFAULT '0',
            `monster_list` varchar(255) NOT NULL DEFAULT '',
            PRIMARY KEY (`player_id`, `slot`),
            FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
        ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3
    ]])

    local columns = db.storeQuery("SELECT `COLUMN_NAME` FROM `information_schema`.`COLUMNS` WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = 'players' AND `COLUMN_NAME` = 'prey_wildcards'")
    if not columns then
        db.query("ALTER TABLE `players` ADD COLUMN `prey_wildcards` int UNSIGNED NOT NULL DEFAULT '0'")
    else
        result.free(columns)
    end

    return true
end
