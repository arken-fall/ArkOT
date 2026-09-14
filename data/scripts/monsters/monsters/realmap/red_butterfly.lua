local mtype = Game.createMonsterType("Red Butterfly")
local monster = {}

monster.name = "Red Butterfly"
monster.description = "a red butterfly"

monster.raceId = 227
monster.bestiary = {
	race = "Vermin",
	class = "Vermin",
	toKill = 25,
	firstUnlock = 5,
	secondUnlock = 10,
	charmPoints = 1,
	stars = 0,
	occurrence = 0,
	locations = "Ab'Dendriel, Ab'Dendriel Surroundings, Carlin, Cormaya, Edron Surroundings, Feyrist Meadows, Fibula, Fields of Glory, Green Claw Swamp, Issavi, Kazordoon Surroundings, Meriana, Outlaw Camp, Port Hope Surroundings, Stonehome, Thais Surroundings, Venore Southern Swamp, Venore Surroundings.",
}
monster.experience = 0
monster.race = "venom"
monster.maxHealth = 2
monster.health = 2
monster.speed = 320
monster.manaCost = 0
monster.corpse = 4992
monster.outfit = { lookType = 228 }
monster.runHealth = 2
monster.changeTarget = {
    interval = 5000,
    chance = 20,
}
monster.targetDistance = 6
monster.staticAttackChance = 90
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = false,
    illusionable = false,
    convinceable = false,
    pushable = false,
    canPushItems = false,
    canPushCreatures = false,
    canWalkOnEnergy = false,
    canWalkOnFire = false,
    canWalkOnPoison = false,
}

mtype:register(monster)
