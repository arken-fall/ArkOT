local mtype = Game.createMonsterType("Shard Of Corruption")
local monster = {}

monster.name = "Shard Of Corruption"
monster.description = "a shard of corruption"

monster.experience = 5
monster.race = "undead"
monster.maxHealth = 600
monster.health = 600
monster.speed = 180
monster.manaCost = 590
monster.corpse = 6005
monster.outfit = { lookType = 67 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
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
    pushable = false,
    canPushItems = true,
    canPushCreatures = true,
}
monster.attacks = {
    {
        name = "melee",
        minDamage = 0,
        maxDamage = -150,
        interval = 2000,
    },
    {
        name = "earth",
        interval = 2000,
        chance = 10,
        range = 7,
        minDamage = 0,
        maxDamage = -115,
        target = true,
        shootEffect = CONST_ANI_SMALLEARTH,
        effect = CONST_ME_GREEN_RINGS,
    },
}
monster.defenses = {
    defense = 20,
    armor = 20,
}
monster.elements = {
    {type = COMBAT_PHYSICALDAMAGE, percent = 60},
    {type = COMBAT_FIREDAMAGE, percent = 30},
    {type = COMBAT_ENERGYDAMAGE, percent = 25},
    {type = COMBAT_ICEDAMAGE, percent = -15},
}
monster.immunities = {
    {type = "paralyze", condition = true},
    {type = "drown", combat = true, condition = true},
    {type = "earth", combat = true, condition = true},
}

mtype:register(monster)
