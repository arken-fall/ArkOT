local mtype = Game.createMonsterType("Husky")
local monster = {}

monster.name = "Husky"
monster.description = "a husky"

monster.raceId = 325
monster.bestiary = {
	race = "Mammal",
	class = "Mammal",
	toKill = 25,
	firstUnlock = 5,
	secondUnlock = 10,
	charmPoints = 1,
	stars = 0,
	occurrence = 1,
	locations = "Svargrond and Nibelor.",
}
monster.experience = 0
monster.race = "blood"
monster.maxHealth = 140
monster.health = 140
monster.speed = 250
monster.manaCost = 420
monster.corpse = 7316
monster.outfit = { lookType = 258 }
monster.changeTarget = {
    interval = 4000,
    chance = 0,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.flags = {
    summonable = true,
    attackable = true,
    hostile = false,
    illusionable = true,
    convinceable = true,
    pushable = true,
    canPushItems = false,
    canPushCreatures = false,
    canWalkOnEnergy = false,
    canWalkOnFire = false,
    canWalkOnPoison = false,
}
monster.defenses = {
    defense = 5,
    armor = 5,
}
monster.voices = {
    interval = 5000,
    chance = 10,
    {text = "Yoooohuuuu!", yell = false},
    {text = "Grrrrrrr", yell = false},
    {text = "Ruff, ruff!", yell = false},
}

mtype:register(monster)
