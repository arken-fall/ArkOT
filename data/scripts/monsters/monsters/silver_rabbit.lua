local mtype = Game.createMonsterType("Silver Rabbit")
local monster = {}

monster.name = "Silver Rabbit"
monster.description = "a silver rabbit"

monster.raceId = 327
monster.bestiary = {
	race = "Mammal",
	class = "Mammal",
	toKill = 250,
	firstUnlock = 10,
	secondUnlock = 100,
	charmPoints = 5,
	stars = 1,
	occurrence = 0,
	locations = "A lot of places on the Ice Islands and one on Rookgaard (unreachable).",
}
monster.experience = 0
monster.race = "blood"
monster.maxHealth = 15
monster.health = 15
monster.speed = 184
monster.manaCost = 220
monster.corpse = 7338
monster.outfit = { lookType = 262 }
monster.runHealth = 15
monster.changeTarget = {
    interval = 4000,
    chance = 0,
}
monster.targetDistance = 1
monster.staticAttackChance = 70
monster.flags = {
    summonable = true,
    attackable = true,
    hostile = true,
    illusionable = true,
    convinceable = true,
    pushable = false,
    canPushItems = false,
    canWalkOnEnergy = false,
    canWalkOnFire = false,
    canWalkOnPoison = false,
}
monster.defenses = {
    defense = 1,
    armor = 1,
}
monster.loot = {
    {
        id = "meat",
        chance = 85000,
        maxCount = 2,
    },
    {
        id = "silky fur",
        chance = 30000,
    },
    {
        id = 2684,
        chance = 10000,
    },
}

mtype:register(monster)
