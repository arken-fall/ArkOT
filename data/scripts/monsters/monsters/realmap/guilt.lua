local mtype = Game.createMonsterType("Guilt")
local monster = {}

monster.name = "Guilt"
monster.description = "a guilt"

monster.experience = 100
monster.race = "undead"
monster.maxHealth = 28000
monster.health = 28000
monster.speed = 0
monster.manaCost = 0
monster.corpse = 22478
monster.outfit = { lookType = 583 }
monster.changeTarget = {
    interval = 4000,
    chance = 50,
}
monster.targetDistance = 4
monster.staticAttackChance = 80
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
        name = "energy",
        interval = 2000,
        chance = 15,
        minDamage = -100,
        maxDamage = -400,
        length = 8,
        spread = 0,
        target = true,
        effect = CONST_ME_YELLOWENERGY,
    },
    {
        name = "physical",
        interval = 2000,
        chance = 60,
        range = 8,
        minDamage = -300,
        maxDamage = -1000,
        radius = 1,
        target = true,
        shootEffect = CONST_ANI_LARGEROCK,
    },
}
monster.defenses = {
    defense = 70,
    armor = 70,
    {
        name = "healing",
        interval = 2000,
        chance = 30,
        minDamage = 550,
        maxDamage = 1100,
        effect = CONST_ME_MAGIC_BLUE,
    },
    {
        name = "speed",
        interval = 2000,
        chance = 15,
        duration = 5000,
        speed = 520,
        effect = CONST_ME_MAGIC_RED,
    },
}
monster.elements = {
    {type = COMBAT_PHYSICALDAMAGE, percent = 40},
    {type = COMBAT_DEATHDAMAGE, percent = 10},
    {type = COMBAT_FIREDAMAGE, percent = 35},
    {type = COMBAT_ENERGYDAMAGE, percent = 10},
    {type = COMBAT_ICEDAMAGE, percent = 30},
    {type = COMBAT_EARTHDAMAGE, percent = 10},
    {type = COMBAT_HOLYDAMAGE, percent = -5},
}
monster.immunities = {
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "BOW LOW!", yell = false},
    {text = "FEEL THE TRUE MEANING OF VANQUISH!", yell = false},
    {text = "HAHAHAHA DO YOU WANT TO AMUSE YOUR MASTER?", yell = false},
    {text = "NOW YOU WILL SURRENDER!", yell = false},
}

mtype:register(monster)
