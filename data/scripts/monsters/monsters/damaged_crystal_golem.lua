local mtype = Game.createMonsterType("Damaged Crystal Golem")
local monster = {}

monster.name = "Damaged Crystal Golem"
monster.description = "a damaged crystal golem"

monster.raceId = 874
monster.bestiary = {
	race = "Construct",
	class = "Construct",
	toKill = 500,
	firstUnlock = 25,
	secondUnlock = 250,
	charmPoints = 15,
	stars = 2,
	occurrence = 1,
	locations = "Golem Workshop in Gnomebase Alpha",
}
monster.experience = 0
monster.race = "energy"
monster.maxHealth = 500
monster.health = 500
monster.speed = 180
monster.manaCost = 0
monster.corpse = 18466
monster.outfit = { lookType = 508 }
monster.runHealth = 500
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
    canPushCreatures = true,
}

mtype:register(monster)
