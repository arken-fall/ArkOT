local mtype = Game.createMonsterType("Hyaena")
local monster = {}

monster.name = "Hyaena"
monster.description = "a hyaena"

monster.raceId = 94
monster.bestiary = {
	race = "Mammal",
	class = "Mammal",
	toKill = 500,
	firstUnlock = 25,
	secondUnlock = 250,
	charmPoints = 15,
	stars = 2,
	occurrence = 0,
	locations = "Desert areas like those around Ankrahmun and Darashia.",
}
monster.experience = 20
monster.race = "blood"
monster.maxHealth = 60
monster.health = 60
monster.speed = 196
monster.manaCost = 275
monster.corpse = 6026
monster.outfit = { lookType = 94 }
monster.runHealth = 30
monster.changeTarget = {
    interval = 5000,
    chance = 0,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.flags = {
    summonable = true,
    attackable = true,
    hostile = true,
    illusionable = true,
    convinceable = true,
    pushable = true,
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
        maxDamage = -20,
    },
}
monster.defenses = {
    defense = 1,
    armor = 1,
}
monster.voices = {
    interval = 5000,
    chance = 10,
    {text = "Grrrrrr", yell = false},
    {text = "Hou hou hou!", yell = false},
}
monster.loot = {
    {
        id = "worm",
        chance = 50130,
        maxCount = 3,
    },
    {
        id = "meat",
        chance = 30860,
        maxCount = 2,
    },
}

mtype:register(monster)
