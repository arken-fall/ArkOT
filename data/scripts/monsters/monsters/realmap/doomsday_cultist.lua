local mtype = Game.createMonsterType("Doomsday Cultist")
local monster = {}

monster.name = "Doomsday Cultist"
monster.description = "a doomsday cultist"

monster.experience = 100
monster.race = "blood"
monster.maxHealth = 125
monster.health = 125
monster.speed = 215
monster.manaCost = 0
monster.corpse = 20383
monster.outfit = { lookType = 194, lookHead = 95, lookBody = 95, lookLegs = 95, lookFeet = 95 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.staticAttackChance = 90
monster.targetDistance = 4
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
        maxDamage = -90,
        interval = 2000,
    },
    {
        name = "lifedrain",
        interval = 2000,
        chance = 20,
        range = 7,
        minDamage = -50,
        maxDamage = -100,
        target = true,
        shootEffect = CONST_ANI_POISON,
        effect = CONST_ME_POISONAREA,
    },
}
monster.defenses = {
    defense = 20,
    armor = 20,
}
monster.elements = {
    {type = COMBAT_HOLYDAMAGE, percent = 30},
    {type = COMBAT_EARTHDAMAGE, percent = 40},
    {type = COMBAT_ICEDAMAGE, percent = 20},
    {type = COMBAT_FIREDAMAGE, percent = 20},
    {type = COMBAT_ENERGYDAMAGE, percent = -5},
}
monster.immunities = {
    {type = "invisible", condition = true},
    {type = "death", combat = true, condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "Fear the night without an end!", yell = false},
    {text = "An age of darkness is at hand!", yell = false},
}
monster.loot = {
    {id = 10531, chance = 1000},
}

mtype:register(monster)
