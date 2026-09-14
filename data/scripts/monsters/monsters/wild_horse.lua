local mtype = Game.createMonsterType("Wild Horse")
local monster = {}

monster.name = "Wild Horse"
monster.description = "a wild horse"

monster.raceId = 730
monster.bestiary = {
	race = "Mammal",
	class = "Mammal",
	toKill = 5,
	firstUnlock = 2,
	secondUnlock = 3,
	charmPoints = 10,
	stars = 1,
	occurrence = 3,
	locations = "Near the Thais Troll Cave entrance during the Horse Station World Change.",
}
monster.experience = 0
monster.race = "blood"
monster.maxHealth = 75
monster.health = 75
monster.speed = 248
monster.manaCost = 0
monster.outfit = { lookType = 393 }
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
monster.defenses = {
    defense = 2,
    armor = 2,
}
monster.voices = {
    interval = 5000,
    chance = 10,
    {text = "Weeeeheeeeeee", yell = false},
    {text = "*snort*", yell = false},
    {text = "*Weeeeheeeeaaa*", yell = false},
}

mtype:register(monster)
