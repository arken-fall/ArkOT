local mtype = Game.createMonsterType("Flame Of Omrafir")
local monster = {}

monster.name = "Flame Of Omrafir"
monster.description = "a flame of omrafir"

monster.experience = 5
monster.race = "fire"
monster.maxHealth = 800
monster.health = 800
monster.speed = 200
monster.manaCost = 0
monster.corpse = 8964
monster.outfit = { lookType = 49 }
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
    canPushCreatures = false,
}
monster.attacks = {
    {
        name = "melee",
        minDamage = 0,
        maxDamage = -100,
        interval = 2000,
    },
    {
        name = "fire",
        interval = 2000,
        chance = 20,
        range = 7,
        minDamage = -45,
        maxDamage = -160,
        radius = 2,
        target = true,
        shootEffect = CONST_ANI_FIRE,
        effect = CONST_ME_FIREAREA,
    },
    {
        name = "firefield",
        interval = 2000,
        chance = 25,
        range = 7,
        radius = 1,
        target = true,
        shootEffect = CONST_ANI_FIRE,
    },
}
monster.defenses = {
    defense = 15,
    armor = 15,
}
monster.elements = {
    {type = COMBAT_ICEDAMAGE, percent = -25},
}
monster.immunities = {
    {type = "death", combat = true, condition = true},
    {type = "fire", combat = true, condition = true},
    {type = "lifedrain", combat = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}

mtype:register(monster)
