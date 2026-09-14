local mtype = Game.createMonsterType("Bog Frog")
local monster = {}

monster.raceId = 738
monster.bestiary = {
	race = "Amphibic",
	class = "Amphibic",
	toKill = 250,
	firstUnlock = 10,
	secondUnlock = 100,
	charmPoints = 5,
	stars = 1,
	occurrence = 0,
	locations = "Shadowthorn in the bog god's temple, Drefia, around Lake Equivocolao when it's dirty.",
}

monster.name = "Bog Frog"
monster.experience = 0
monster.race = "blood"
monster.maxHealth = 25
monster.health = 25
monster.speed = 200
monster.manaCost = 305
monster.corpse = 6079
monster.outfit = { lookType = 412 }
monster.runHealth = 25
monster.changeTarget = {
    interval = 4000,
    chance = 0,
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
    canPushItems = false,
    canPushCreatures = false,
}

mtype:register(monster)
