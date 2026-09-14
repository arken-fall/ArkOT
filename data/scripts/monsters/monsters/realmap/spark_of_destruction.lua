local mtype = Game.createMonsterType("Spark of Destruction")
local monster = {}

monster.name = "Spark of Destruction"
monster.description = "a spark of destruction"

monster.experience = 3000
monster.race = "energy"
monster.maxHealth = 3900
monster.health = 3900
monster.speed = 380
monster.manaCost = 0
monster.outfit = { lookType = 879 }
monster.changeTarget = {
    interval = 4000,
    chance = 15,
}
monster.staticAttackChance = 85
monster.targetDistance = 1
monster.runHealth = 0
monster.light = { level = 0, color = 0 }
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = true,
    illusionable = true,
    convinceable = false,
    pushable = false,
    canPushItems = true,
}
monster.attacks = {
    {
        name = "melee",
        attack = 180,
        skill = 60,
        interval = 2000,
    },
    {
        name = "energy",
        interval = 2000,
        chance = 10,
        range = 7,
        minDamage = -170,
        maxDamage = -415,
        radius = 2,
        target = true,
        shootEffect = CONST_ANI_ENERGY,
        effect = CONST_ME_ENERGYHIT,
    },
    {
        name = "energy strike",
        interval = 2000,
        chance = 30,
        range = 1,
        minDamage = -210,
        maxDamage = -300,
    },
    {
        name = "energy",
        interval = 2000,
        chance = 15,
        range = 7,
        minDamage = -175,
        maxDamage = -205,
        target = true,
        shootEffect = CONST_ANI_ENERGYBALL,
        effect = CONST_ME_ENERGYHIT,
    },
    {
        name = "massive energy elemental electrify",
        interval = 2000,
        chance = 20,
        effect = CONST_ME_BLOCKHIT,
    },
}
monster.defenses = {
    defense = 20,
    armor = 20,
    {
        name = "healing",
        interval = 2000,
        chance = 5,
        minDamage = 190,
        maxDamage = 250,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.elements = {
    {type = COMBAT_HOLYDAMAGE, percent = -5},
    {type = COMBAT_DEATHDAMAGE, percent = 1},
    {type = COMBAT_EARTHDAMAGE, percent = -5},
}
monster.immunities = {
    {type = "energy", combat = true, condition = true},
    {type = "invisible", condition = true},
    {type = "paralyze", condition = true},
}

mtype:register(monster)
