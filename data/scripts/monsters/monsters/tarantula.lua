local mtype = Game.createMonsterType("Tarantula")
local monster = {}

monster.name = "Tarantula"
monster.description = "a tarantula"

monster.raceId = 219
monster.bestiary = {
	race = "Vermin",
	class = "Vermin",
	toKill = 500,
	firstUnlock = 25,
	secondUnlock = 250,
	charmPoints = 15,
	stars = 2,
	occurrence = 0,
	locations = "Tiquanda Tarantula Caves, Spider Caves, Trapwood ground level and underground, in 2 small caves South of Thais, Dark Cathedral, single spawn on top of Crocodile den north of Port Hope, Plains of Havoc, underground Liberty Bay, Nargor Undead Cave and other constituents of the Shattered Isles, Green Claw Swamp, first floor up in the big building in the Cemetery Quarter, Robson Isle, Vengoth. After the summer update of 2876, tarantulas can be seen on the beginner's island of Rookgaard.",
}
monster.experience = 120
monster.race = "venom"
monster.maxHealth = 225
monster.health = 225
monster.speed = 214
monster.manaCost = 485
monster.corpse = 6060
monster.outfit = { lookType = 219 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.flags = {
    summonable = true,
    attackable = true,
    hostile = true,
    illusionable = true,
    convinceable = true,
    pushable = false,
    canPushItems = true,
    canPushCreatures = false,
    canWalkOnEnergy = false,
    canWalkOnFire = false,
}
monster.attacks = {
    {
        name = "melee",
        interval = 2000,
        minDamage = 0,
        maxDamage = -90,
        -- NOTE: melee condition (poison=40); verify damage/duration
        condition = {
            type = CONDITION_POISON,
            interval = 40000,
        },
    },
    {
        name = "earth",
        interval = 2000,
        chance = 10,
        range = 1,
        radius = 1,
        target = true,
        shootEffect = CONST_ANI_POISON,
        effect = CONST_ME_CARNIPHILA,
    },
}
monster.defenses = {
    defense = 20,
    armor = 20,
    {
        name = "speed",
        interval = 2000,
        chance = 15,
        speed = 220,
        duration = 5000,
        effect = CONST_ME_MAGIC_RED,
    },
}
monster.elements = {
    {type = COMBAT_ENERGYDAMAGE, percent = 10},
    {type = COMBAT_FIREDAMAGE, percent = -15},
    {type = COMBAT_ICEDAMAGE, percent = -10},
}
monster.immunities = {
    {type = "earth", combat = true, condition = true},
    {type = "outfit", condition = true},
    {type = "drunk", condition = true},
}
monster.loot = {
    {
        id = 2148,
        chance = 79114,
        maxCount = 40,
    },
    {
        id = 11198,
        chance = 9960,
    },
    {
        id = 8859,
        chance = 4844,
    },
    {
        id = 2478,
        chance = 3021,
    },
    {
        id = 2510,
        chance = 1966,
    },
    {
        id = 3351,
        chance = 925,
    },
    {
        id = 2169,
        chance = 112,
    },
}

mtype:register(monster)
