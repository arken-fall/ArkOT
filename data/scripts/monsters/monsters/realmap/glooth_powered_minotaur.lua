local mtype = Game.createMonsterType("Glooth Powered Minotaur")
local monster = {}

monster.name = "Glooth Powered Minotaur"
monster.description = "a glooth powered minotaur"

monster.experience = 2600
monster.race = "blood"
monster.maxHealth = 3200
monster.health = 3200
monster.speed = 200
monster.manaCost = 0
monster.corpse = 5962
monster.outfit = { lookType = 607 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.targetDistance = 1
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
        maxDamage = -290,
        interval = 2000,
    },
    {
        name = "physical",
        interval = 2000,
        chance = 15,
        minDamage = 0,
        maxDamage = -200,
        radius = 3,
        effect = CONST_ME_HITAREA,
    },
    {
        name = "lifedrain",
        interval = 2000,
        chance = 15,
        range = 7,
        minDamage = -100,
        maxDamage = -225,
        radius = 4,
        target = true,
        effect = CONST_ME_MAGIC_RED,
    },
}
monster.defenses = {
    defense = 45,
    armor = 40,
    {
        name = "healing",
        interval = 4000,
        chance = 15,
        minDamage = 50,
        maxDamage = 145,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.elements = {
    {type = COMBAT_EARTHDAMAGE, percent = 1},
    {type = COMBAT_FIREDAMAGE, percent = 1},
    {type = COMBAT_HOLYDAMAGE, percent = 90},
}
monster.immunities = {
    {type = "earth", combat = true, condition = true},
    {type = "invisible", condition = true},
    {type = "paralyze", condition = true},
}

mtype:register(monster)
