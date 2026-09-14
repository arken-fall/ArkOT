local mtype = Game.createMonsterType("Northern Pike")
local monster = {}

monster.name = "Northern Pike"
monster.description = "a northern pike"

monster.raceId = 783
monster.bestiary = {
	race = "Aquatic",
	class = "Aquatic",
	toKill = 25,
	firstUnlock = 5,
	secondUnlock = 10,
	charmPoints = 1,
	stars = 0,
	occurrence = 1,
	locations = "Fiehonja.",
}
monster.experience = 0
monster.race = "blood"
monster.maxHealth = 95
monster.health = 95
monster.speed = 210
monster.manaCost = 0
monster.outfit = { lookType = 454 }
monster.runHealth = 95
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
    illusionable = true,
    convinceable = false,
    pushable = false,
    canPushItems = false,
    canPushCreatures = false,
    canWalkOnEnergy = false,
}
monster.defenses = {
    defense = 9,
    armor = 9,
}
monster.elements = {
    {type = COMBAT_PHYSICALDAMAGE, percent = -5},
    {type = COMBAT_ENERGYDAMAGE, percent = -5},
}
monster.immunities = {
    {type = "earth", combat = true, condition = true},
    {type = "fire", combat = true, condition = true},
    {type = "invisible", condition = true},
    {type = "drown", combat = true, condition = true},
}
monster.voices = {
    interval = 5000,
    chance = 10,
    {text = "Blub!", yell = false},
}

mtype:register(monster)
