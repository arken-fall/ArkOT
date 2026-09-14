local mtype = Game.createMonsterType("Muglex Clan Assassin")
local monster = {}

monster.name = "Muglex Clan Assassin"
monster.description = "a muglex clan assassin"

monster.experience = 48
monster.race = "blood"
monster.maxHealth = 75
monster.health = 75
monster.speed = 140
monster.manaCost = 0
monster.corpse = 6002
monster.outfit = { lookType = 296 }
monster.changeTarget = {
    interval = 10000,
    chance = 0,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 15
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = true,
    illusionable = false,
    convinceable = false,
    pushable = true,
    canPushItems = false,
    canPushCreatures = false,
}
monster.attacks = {
    {
        name = "melee",
        attack = 15,
        skill = 10,
        interval = 2000,
    },
    {
        name = "drunk",
        interval = 2000,
        chance = 11,
        duration = 3000,
        shootEffect = CONST_ANI_POISON,
        effect = CONST_ME_POISONAREA,
    },
    {
        name = "physical",
        interval = 2000,
        chance = 9,
        range = 6,
        minDamage = -0,
        maxDamage = -30,
        shootEffect = CONST_ANI_THROWINGKNIFE,
    },
}
monster.defenses = {
    defense = 5,
    armor = 3,
    {
        name = "invisible",
        interval = 2000,
        chance = 11,
        duration = 3000,
        effect = CONST_ME_MAGIC_BLUE,
    },
    {
        name = "speed",
        interval = 2000,
        chance = 10,
        duration = 4000,
        speed = 145,
        effect = CONST_ME_MAGIC_RED,
    },
}
monster.loot = {
    {id = 2230, chance = 10760},
    {id = 2449, chance = 4890},
    {id = 2379, chance = 18090},
    {id = 2667, chance = 11000, maxCount = 2},
    {id = 2148, chance = 100000, maxCount = 18},
    {id = 2467, chance = 6460},
    {id = 2461, chance = 8070},
    {id = 2235, chance = 6850},
    {id = 2406, chance = 9780},
    {id = 2559, chance = 9540},
    {id = 1294, chance = 11980, maxCount = 3},
    {id = 2484, chance = 1710},
}

mtype:register(monster)
