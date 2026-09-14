local mtype = Game.createMonsterType("Clomp")
local monster = {}

monster.name = "Clomp"
monster.description = "a clomp"

monster.experience = 275
monster.race = "blood"
monster.maxHealth = 900
monster.health = 900
monster.speed = 240
monster.manaCost = 0
monster.corpse = 25398
monster.outfit = { lookType = 860 }
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
        minDamage = 40,
        maxDamage = -289,
        interval = 2000,
        condition = { type = CONDITION_FIRE, minDamage = -6, maxDamage = -6, interval = 9000 },
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
    {type = "invisible", condition = true},
}
monster.voices = {
    interval = 3000,
    chance = 20,
    {text = "Snort!", yell = false},
}
monster.loot = {
    {id = 2148, chance = 92000, maxCount = 130},
    {id = 24842, chance = 2200},
    {id = 5925, chance = 1200, maxCount = 2},
    {id = 11224, chance = 900},
    {id = 3973, chance = 400},
    {id = 7432, chance = 200},
}

mtype:register(monster)
