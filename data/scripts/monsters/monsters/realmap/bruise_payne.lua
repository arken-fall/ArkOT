local mtype = Game.createMonsterType("Bruise Payne")
local monster = {}

monster.name = "Bruise Payne"
monster.description = "Bruise Payne"

monster.experience = 1000
monster.race = "blood"
monster.maxHealth = 1600
monster.health = 1600
monster.speed = 210
monster.manaCost = 0
monster.corpse = 9829
monster.outfit = { lookType = 307 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 300
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
        maxDamage = -240,
        interval = 2000,
        condition = { type = CONDITION_POISON, minDamage = -6, maxDamage = -6, interval = 4000 },
    },
    {
        name = "earth",
        interval = 2000,
        chance = 15,
        range = 7,
        minDamage = -70,
        maxDamage = -180,
        shootEffect = CONST_ANI_POISON,
    },
    {
        name = "drown",
        interval = 2000,
        chance = 15,
        minDamage = -130,
        maxDamage = -237,
        radius = 6,
        target = false,
        effect = CONST_ME_SOUND_WHITE,
    },
    {
        name = "mutated bat curse",
        interval = 2000,
        chance = 10,
    },
    {
        name = "poisoncondition",
        interval = 2000,
        chance = 15,
        minDamage = -12,
        maxDamage = -12,
        length = 4,
        spread = 3,
        target = false,
        effect = CONST_ME_POISONAREA,
    },
}
monster.defenses = {
    defense = 20,
    armor = 20,
    {
        name = "healing",
        interval = 2000,
        chance = 10,
        minDamage = 80,
        maxDamage = 95,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.elements = {
    {type = COMBAT_FIREDAMAGE, percent = -10},
}
monster.immunities = {
    {type = "death", combat = true, condition = true},
    {type = "earth", combat = true, condition = true},
    {type = "drown", combat = true, condition = true},
    {type = "invisible", condition = true},
}
monster.loot = {
    {id = 5894, chance = 100000, maxCount = 2},
    {id = 2167, chance = 100000},
    {id = 2148, chance = 100000, maxCount = 99},
    {id = 10579, chance = 100000},
    {id = 2150, chance = 100000, maxCount = 5},
    {id = 2800, chance = 100000},
    {id = 2529, chance = 92000},
    {id = 2144, chance = 85000, maxCount = 5},
    {id = 7386, chance = 25000},
    {id = 10016, chance = 16000},
}

mtype:register(monster)
