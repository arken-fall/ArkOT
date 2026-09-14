function onUpdateDatabase()
    print("> Updating database to version 6 : Wheel of destiny")

    db.query([[
        CREATE TABLE IF NOT EXISTS `player_wheel_slots` (
            `player_id` int NOT NULL,
            `slot` tinyint UNSIGNED NOT NULL,
            `points` smallint UNSIGNED NOT NULL DEFAULT '0',
            PRIMARY KEY (`player_id`, `slot`),
            FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
        ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3
    ]])

    db.query([[
        CREATE TABLE IF NOT EXISTS `player_wheel_gems` (
            `player_id` int NOT NULL,
            `gem_id` int UNSIGNED NOT NULL,
            `locked` tinyint UNSIGNED NOT NULL DEFAULT '0',
            `domain` tinyint UNSIGNED NOT NULL DEFAULT '0',
            `quality` tinyint UNSIGNED NOT NULL DEFAULT '0',
            `first_modifier` tinyint UNSIGNED NOT NULL DEFAULT '0',
            `second_modifier` tinyint UNSIGNED NOT NULL DEFAULT '0',
            `supreme_modifier` tinyint UNSIGNED NOT NULL DEFAULT '0',
            `vessel` tinyint UNSIGNED NOT NULL DEFAULT '255',
            PRIMARY KEY (`player_id`, `gem_id`),
            FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
        ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3
    ]])

    db.query([[
        CREATE TABLE IF NOT EXISTS `player_wheel_grades` (
            `player_id` int NOT NULL,
            `type` tinyint UNSIGNED NOT NULL DEFAULT '0',
            `position` tinyint UNSIGNED NOT NULL DEFAULT '0',
            `grade` tinyint UNSIGNED NOT NULL DEFAULT '0',
            PRIMARY KEY (`player_id`, `type`, `position`),
            FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
        ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3
    ]])

    db.query([[
        CREATE TABLE IF NOT EXISTS `player_wheel_scrolls` (
            `player_id` int NOT NULL,
            `item_id` smallint UNSIGNED NOT NULL,
            PRIMARY KEY (`player_id`, `item_id`),
            FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
        ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3
    ]])

    return true
end
