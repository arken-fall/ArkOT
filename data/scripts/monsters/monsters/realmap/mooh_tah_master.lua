local mtype = Game.createMonsterType("Mooh'Tah Master")
local monster = {}

monster.name = "Mooh'Tah Master"
monster.description = "Mooh'Tah Master"

monster.experience = 0
monster.race = "blood"
monster.maxHealth = 185
monster.health = 185
monster.speed = 250
monster.manaCost = 0
monster.corpse = 23462
monster.outfit = { lookType = 611 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 0
monster.flags = {
    summonable = false,
    attackable = false,
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
        maxDamage = -400,
        interval = 2000,
    },
    {
        name = "energy beam",
        interval = 2000,
        chance = 10,
        range = 1,
        minDamage = 0,
        maxDamage = -500,
    },
    {
        name = "berserk",
        interval = 2000,
        chance = 10,
        range = 1,
        minDamage = 0,
        maxDamage = -100,
    },
}
monster.defenses = {
    defense = 20,
    armor = 20,
}
monster.immunities = {
    {type = "physical", combat = true},
    {type = "energy", combat = true, condition = true},
    {type = "fire", combat = true, condition = true},
    {type = "poison", combat = true, condition = true},
    {type = "ice", combat = true, condition = true},
    {type = "holy", combat = true, condition = true},
    {type = "death", combat = true, condition = true},
    {type = "lifedrain", combat = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "Kirll Karrrl!", yell = false},
    {text = "Kaplar!", yell = false},
}

mtype:register(monster)
