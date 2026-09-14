local mtype = Game.createMonsterType("Abyssal Calamary")
local monster = {}

monster.name = "Abyssal Calamary"
monster.description = "an abyssal calamary"

monster.experience = 200
monster.race = "blood"
monster.maxHealth = 300
monster.health = 300
monster.speed = 200
monster.manaCost = 0
monster.corpse = 15280
monster.outfit = { lookType = 451 }
monster.changeTarget = {
    interval = 2000,
    chance = 5,
}
monster.staticAttackChance = 90
monster.targetDistance = 1
monster.runHealth = 75
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = true,
    illusionable = true,
    convinceable = false,
    pushable = false,
    canPushItems = false,
    canPushCreatures = false,
}
monster.attacks = {
    {
        name = "melee",
        attack = 30,
        skill = 20,
        interval = 2000,
    },
    {
        name = "drunk",
        interval = 2000,
        chance = 13,
        range = 7,
        duration = 2000,
        target = true,
        shootEffect = CONST_ANI_EXPLOSION,
        effect = CONST_ME_STUN,
    },
}
monster.defenses = {
    defense = 20,
    armor = 12,
    {
        name = "speed",
        interval = 2000,
        chance = 12,
        duration = 5000,
        speed = 600,
        effect = CONST_ME_POFF,
    },
}
monster.elements = {
    {type = COMBAT_ENERGYDAMAGE, percent = -5},
    {type = COMBAT_PHYSICALDAMAGE, percent = -5},
}
monster.immunities = {
    {type = "fire", combat = true, condition = true},
    {type = "earth", combat = true, condition = true},
    {type = "drown", combat = true, condition = true},
    {type = "invisible", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 5,
    {text = "Bubble!", yell = false},
    {text = "Bobble!", yell = false},
}
monster.loot = {
    {id = 2144, chance = 1720, maxCount = 1},
    {id = 2667, chance = 7470, maxCount = 1},
    {id = 2670, chance = 6320, maxCount = 5},
    {id = 2150, chance = 1720, maxCount = 2},
    {id = 2146, chance = 2270, maxCount = 3},
}

mtype:register(monster)
