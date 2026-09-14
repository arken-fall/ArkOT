local mtype = Game.createMonsterType("Tibia Bug")
local monster = {}

monster.name = "Tibia Bug"
monster.description = "a tibia bug"

monster.experience = 50
monster.race = "venom"
monster.maxHealth = 270
monster.health = 270
monster.speed = 240
monster.manaCost = 250
monster.corpse = 5990
monster.outfit = { lookType = 45 }
monster.changeTarget = {
    interval = 2000,
    chance = 0,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 0
monster.flags = {
    summonable = true,
    attackable = true,
    hostile = true,
    illusionable = true,
    convinceable = true,
    pushable = true,
    canPushItems = false,
    canPushCreatures = false,
}
monster.attacks = {
    {
        name = "melee",
        attack = 20,
        skill = 43,
        interval = 1000,
    },
    {
        name = "energy",
        interval = 1000,
        chance = 13,
        minDamage = -5,
        maxDamage = -35,
        length = 4,
        spread = 0,
        effect = CONST_ME_ENERGYHIT,
    },
}
monster.defenses = {
    defense = 15,
    armor = 10,
    {
        name = "invisible",
        interval = 1000,
        chance = 17,
        duration = 2000,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.immunities = {
    {type = "energy", combat = true, condition = true},
    {type = "fire", combat = true, condition = true},
}
monster.maxSummons = 10
monster.summons = {
    {name = "tibia bug", interval = 1000, chance = 15, max = 10},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "My father was a year 2k bug.", yell = false},
    {text = "Psst, I'll make you rich.", yell = false},
    {text = "You are bugged ... by me!", yell = false},
}
monster.loot = {
    {id = 2148, chance = 100000, maxCount = 11},
    {id = 6570, chance = 5538},
    {id = 6571, chance = 1538},
}

mtype:register(monster)
