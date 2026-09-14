local mtype = Game.createMonsterType("Horse")
local monster = {}

monster.name = "Horse"
monster.description = "a horse"

monster.raceId = 750
monster.bestiary = {
	race = "Mammal",
	class = "Mammal",
	toKill = 250,
	firstUnlock = 10,
	secondUnlock = 100,
	charmPoints = 5,
	stars = 1,
	occurrence = 1,
	locations = "South-east, east and north-east of Thais depending on the Horse Station World Change; one near Roswitha in Rathleton.",
}
monster.experience = 0
monster.race = "blood"
monster.maxHealth = 75
monster.health = 75
monster.speed = 190
monster.manaCost = 0
monster.outfit = { lookType = 436 }
monster.runHealth = 75
monster.changeTarget = {
    interval = 4000,
    chance = 20,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = false,
    illusionable = false,
    convinceable = false,
    pushable = true,
    canPushItems = false,
    canPushCreatures = false,
    canWalkOnEnergy = false,
    canWalkOnFire = false,
    canWalkOnPoison = false,
}
monster.voices = {
    interval = 5000,
    chance = 10,
    {text = "Weeeeheeeeeee", yell = false},
    {text = "*snort*", yell = false},
    {text = "*Weeeeheeeeaaa*", yell = false},
}

mtype:register(monster)
