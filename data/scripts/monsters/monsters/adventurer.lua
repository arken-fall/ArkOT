local mtype = Game.createMonsterType("Adventurer")
local monster = {}

monster.name = "Adventurer"
monster.description = "an adventurer"

monster.raceId = 922
monster.bestiary = {
	race = "Human",
	class = "Human",
	toKill = 500,
	firstUnlock = 25,
	secondUnlock = 250,
	charmPoints = 15,
	stars = 2,
	occurrence = 0,
	locations = "Venore swamp.",
}
monster.experience = 0
monster.race = "blood"
monster.maxHealth = 65
monster.health = 65
monster.speed = 106
monster.manaCost = 0
monster.corpse = 20315
monster.outfit = {
    lookType = 129,
    lookHead = 93,
    lookBody = 15,
    lookLegs = 72,
    lookFeet = 80,
    lookAddons = 0,
}
monster.runHealth = 65
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = false,
    illusionable = false,
    convinceable = false,
    pushable = false,
    canPushItems = true,
    canPushCreatures = false,
    canWalkOnEnergy = false,
    canWalkOnFire = false,
    canWalkOnPoison = false,
}

mtype:register(monster)
