local mtype = Game.createMonsterType("Fish")
local monster = {}

monster.name = "Fish"
monster.description = "a fish"

monster.raceId = 784
monster.bestiary = {
	race = "Aquatic",
	class = "Aquatic",
	toKill = 250,
	firstUnlock = 10,
	secondUnlock = 100,
	charmPoints = 5,
	stars = 1,
	occurrence = 0,
	locations = "Fiehonja.",
}
monster.experience = 0
monster.race = "undead"
monster.maxHealth = 25
monster.health = 25
monster.speed = 180
monster.manaCost = 0
monster.corpse = 2667
monster.outfit = { lookType = 455 }
monster.runHealth = 25
monster.changeTarget = {
    interval = 4000,
    chance = 0,
}
monster.targetDistance = 1
monster.staticAttackChance = 100
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = true,
    illusionable = false,
    convinceable = false,
    pushable = true,
    canPushItems = false,
    canPushCreatures = true,
    canWalkOnEnergy = false,
}
monster.defenses = {
    defense = 5,
    armor = 5,
}
monster.immunities = {
    {type = "fire", combat = true, condition = true},
    {type = "earth", combat = true, condition = true},
    {type = "invisible", condition = true},
    {type = "drown", combat = true, condition = true},
}
monster.voices = {
    interval = 5000,
    chance = 10,
    {text = "Blib!", yell = false},
    {text = "Blub!", yell = false},
}

mtype:register(monster)
