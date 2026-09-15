function onUpdateDatabase()
    print("> Updating database to version 7 : Store coins and history")

    local columns = db.storeQuery("SELECT `COLUMN_NAME` FROM `information_schema`.`COLUMNS` WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = 'accounts' AND `COLUMN_NAME` = 'coins'")
    if not columns then
        db.query("ALTER TABLE `accounts` ADD COLUMN `coins` int UNSIGNED NOT NULL DEFAULT '0'")
        db.query("ALTER TABLE `accounts` ADD COLUMN `coins_transferable` int UNSIGNED NOT NULL DEFAULT '0'")
    else
        result.free(columns)
    end

    db.query([[
        CREATE TABLE IF NOT EXISTS `store_history` (
            `id` int NOT NULL AUTO_INCREMENT,
            `account_id` int NOT NULL,
            `mode` tinyint UNSIGNED NOT NULL DEFAULT '0',
            `amount` int NOT NULL DEFAULT '0',
            `coin_type` tinyint UNSIGNED NOT NULL DEFAULT '0',
            `description` varchar(255) NOT NULL DEFAULT '',
            `created` bigint NOT NULL DEFAULT '0',
            PRIMARY KEY (`id`),
            INDEX `account_id` (`account_id`),
            FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE
        ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3
    ]])

    return true
end
