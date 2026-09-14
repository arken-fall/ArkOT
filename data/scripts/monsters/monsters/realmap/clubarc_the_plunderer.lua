local mtype = Game.createMonsterType("Clubarc The Plunderer")
local monster = {}

monster.name = "Clubarc The Plunderer"
monster.description = "Clubarc The Plunderer"

monster.experience = 400
monster.race = "blood"
monster.maxHealth = 400
monster.health = 400
monster.speed = 210
monster.manaCost = 0
monster.corpse = 11254
monster.outfit = { lookType = 342 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.targetDistance = 4
monster.staticAttackChance = 90
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
        maxDamage = -130,
        interval = 2000,
    },
    {
        name = "physical",
        interval = 2000,
        chance = 50,
        range = 7,
        minDamage = 0,
        maxDamage = -85,
        shootEffect = CONST_ANI_ONYXARROW,
    },
    {
        name = "poisoncondition",
        interval = 2000,
        chance = 11,
        minDamage = -8,
        maxDamage = -8,
        effect = CONST_ME_POISONAREA,
    },
}
monster.defenses = {
    defense = 25,
    armor = 25,
    {
        name = "speed",
        interval = 2000,
        chance = 15,
        duration = 5000,
        speed = 350,
        effect = CONST_ME_MAGIC_RED,
    },
}
monster.elements = {
    {type = COMBAT_HOLYDAMAGE, percent = 2},
    {type = COMBAT_EARTHDAMAGE, percent = -2},
}
monster.immunities = {
    {type = "invisible", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "Orc arga Huummmak!", yell = false},
}
monster.loot = {
    {id = 2148, chance = 58000, maxCount = 78},
    {id = 2666, chance = 24600},
    {id = 2428, chance = 21000},
    {id = 11324, chance = 13000},
    {id = 11338, chance = 6000},
    {id = 2456, chance = 4600},
    {id = 8857, chance = 3070},
    {id = 11113, chance = 1500},
}

mtype:register(monster)
