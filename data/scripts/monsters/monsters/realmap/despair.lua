local mtype = Game.createMonsterType("Despair")
local monster = {}

monster.name = "Despair"
monster.description = "a despair"

monster.experience = 10
monster.race = "blood"
monster.maxHealth = 20000
monster.health = 20000
monster.speed = 0
monster.manaCost = 0
monster.corpse = 0
monster.outfit = { lookTypeEx = 22444 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.targetDistance = 3
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
    canPushCreatures = false,
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

mtype:register(monster)
