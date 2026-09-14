local mtype = Game.createMonsterType("Crimson Frog")
local monster = {}

monster.name = "Crimson Frog"
monster.description = "a crimson frog"

monster.raceId = 270
monster.bestiary = {
	race = "Amphibic",
	class = "Amphibic",
	toKill = 500,
	firstUnlock = 25,
	secondUnlock = 250,
	charmPoints = 15,
	stars = 2,
	occurrence = 0,
	locations = "Meriana, Laguna Islands, and other Shattered Isles.",
}
monster.experience = 20
monster.race = "blood"
monster.maxHealth = 60
monster.health = 60
monster.speed = 200
monster.manaCost = 305
monster.corpse = 6079
monster.outfit = {
    lookType = 226,
    lookHead = 94,
    lookBody = 78,
    lookLegs = 77,
    lookFeet = 112,
}
monster.changeTarget = {
    interval = 4000,
    chance = 0,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.flags = {
    summonable = true,
    attackable = true,
    hostile = true,
    illusionable = false,
    convinceable = false,
    pushable = false,
    canPushItems = false,
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
        maxDamage = -24,
    },
}
monster.defenses = {
    defense = 5,
    armor = 5,
}
monster.elements = {
    {type = COMBAT_ICEDAMAGE, percent = 10},
    {type = COMBAT_FIREDAMAGE, percent = -10},
}
monster.voices = {
    interval = 5000,
    chance = 10,
    {text = "Ribbit!", yell = false},
    {text = "Ribbit! Ribbit!", yell = false},
}
monster.loot = {
    {
        id = "gold coin",
        chance = 74000,
        maxCount = 11,
    },
    {
        id = "worm",
        chance = 9000,
    },
}

mtype:register(monster)
