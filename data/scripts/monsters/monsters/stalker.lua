local mtype = Game.createMonsterType("Stalker")
local monster = {}

monster.name = "Stalker"
monster.description = "a stalker"

monster.raceId = 72
monster.bestiary = {
	race = "Human",
	class = "Human",
	toKill = 500,
	firstUnlock = 25,
	secondUnlock = 250,
	charmPoints = 15,
	stars = 2,
	occurrence = 0,
	locations = "Triangle Tower, Drefia, Edron Hero Cave in the Warlock room, White Flower Temple, Ghostlands, Shadow Tomb, Ancient Ruins Tomb, Tarpit Tomb, Stone Tomb, Mountain Tomb, Peninsula Tomb, Oasis Tomb, Yalahar Trade Quarter and Isle of the Kings.",
}
monster.experience = 90
monster.race = "blood"
monster.maxHealth = 120
monster.health = 120
monster.speed = 260
monster.manaCost = 0
monster.corpse = 20511
monster.outfit = {
    lookType = 128,
    lookHead = 97,
    lookBody = 116,
    lookLegs = 95,
    lookFeet = 95,
}
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = true,
    illusionable = false,
    convinceable = false,
    pushable = false,
    canPushItems = true,
    canPushCreatures = false,
    canWalkOnEnergy = false,
    canWalkOnFire = false,
    canWalkOnPoison = false,
}
monster.attacks = {
    {
        name = "melee",
        interval = 2000,
        minDamage = 0,
        maxDamage = -70,
    },
    {
        name = "lifedrain",
        interval = 1000,
        chance = 15,
        range = 1,
        minDamage = -20,
        maxDamage = -30,
        effect = CONST_ME_MAGIC_RED,
    },
}
monster.defenses = {
    defense = 14,
    armor = 14,
    {
        name = "invisible",
        interval = 2000,
        chance = 30,
        duration = 15000,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.elements = {
    {type = COMBAT_DEATHDAMAGE, percent = 5},
    {type = COMBAT_PHYSICALDAMAGE, percent = -20},
    {type = COMBAT_HOLYDAMAGE, percent = -5},
}
monster.immunities = {
    {type = "invisible", condition = true},
    {type = "lifedrain", combat = true},
}
monster.loot = {
    {
        id = 2148,
        chance = 13123,
        maxCount = 8,
    },
    {
        id = 2410,
        chance = 11116,
        maxCount = 2,
    },
    {
        id = 2260,
        chance = 8811,
    },
    {
        id = 2511,
        chance = 5617,
    },
    {
        id = 2478,
        chance = 3531,
    },
    {
        id = 12430,
        chance = 1543,
    },
    {
        id = 2425,
        chance = 1198,
    },
    {
        id = 2412,
        chance = 519,
    },
}

mtype:register(monster)
