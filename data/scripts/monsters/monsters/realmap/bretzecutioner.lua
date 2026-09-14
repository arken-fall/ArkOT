local mtype = Game.createMonsterType("Bretzecutioner")
local monster = {}

monster.name = "Bretzecutioner"
monster.description = "Bretzecutioner"

monster.experience = 3700
monster.race = "undead"
monster.maxHealth = 5600
monster.health = 5600
monster.speed = 270
monster.manaCost = 0
monster.corpse = 6320
monster.outfit = { lookType = 236 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.targetDistance = 1
monster.staticAttackChance = 70
monster.runHealth = 0
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = true,
    illusionable = false,
    convinceable = false,
    pushable = false,
    canPushItems = true,
    canPushCreatures = true,
}
monster.attacks = {
    {
        name = "melee",
        minDamage = 0,
        maxDamage = -514,
        interval = 2000,
    },
    {
        name = "physical",
        interval = 2000,
        chance = 15,
        range = 7,
        minDamage = 0,
        maxDamage = -200,
        shootEffect = CONST_ANI_LARGEROCK,
    },
}
monster.defenses = {
    defense = 30,
    armor = 30,
    {
        name = "speed",
        interval = 2000,
        chance = 15,
        duration = 5000,
        speed = 420,
        effect = CONST_ME_MAGIC_RED,
    },
}
monster.elements = {
    {type = COMBAT_PHYSICALDAMAGE, percent = 25},
    {type = COMBAT_DEATHDAMAGE, percent = 20},
    {type = COMBAT_FIREDAMAGE, percent = 30},
    {type = COMBAT_EARTHDAMAGE, percent = 20},
    {type = COMBAT_HOLYDAMAGE, percent = -3},
    {type = COMBAT_ICEDAMAGE, percent = -15},
}
monster.immunities = {
    {type = "energy", combat = true, condition = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "COME HERE AND DIE!", yell = false},
    {text = "Destructiooooon!", yell = false},
    {text = "It's a good day to destroy!", yell = false},
}
monster.loot = {
    {id = 2148, chance = 100000, maxCount = 1},
    {id = 2148, chance = 100000, maxCount = 98},
    {id = 2666, chance = 100000},
    {id = 6500, chance = 64000},
    {id = 7368, chance = 100000, maxCount = 10},
    {id = 2489, chance = 68000},
    {id = 2150, chance = 28000, maxCount = 5},
    {id = 2146, chance = 40000, maxCount = 5},
    {id = 2145, chance = 32000, maxCount = 5},
    {id = 11215, chance = 100000},
    {id = 7452, chance = 32000},
    {id = 2152, chance = 100000, maxCount = 8},
    {id = 2393, chance = 24000},
    {id = 7591, chance = 44000, maxCount = 3},
    {id = 7590, chance = 44000, maxCount = 3},
    {id = 8472, chance = 44000, maxCount = 3},
    {id = 7632, chance = 48000},
    {id = 7633, chance = 48000},
    {id = 2645, chance = 4000},
    {id = 7427, chance = 24000},
    {id = 7419, chance = 12000},
    {id = 2125, chance = 24000},
    {id = 2521, chance = 16000},
    {id = 6300, chance = 100000},
    {id = 5741, chance = 4000},
}

mtype:register(monster)
