local mtype = Game.createMonsterType("Dog")
local monster = {}

monster.name = "Dog"
monster.description = "a dog"

monster.raceId = 32
monster.bestiary = {
	race = "Mammal",
	class = "Mammal",
	toKill = 25,
	firstUnlock = 5,
	secondUnlock = 10,
	charmPoints = 1,
	stars = 0,
	occurrence = 0,
	locations = "Isle of the Kings, North of the Thais temple, Lubos house, west of Carlin (with sheep), Edron north of castle and one south towards Ivory Towers, Liberty Bay (Silverhand Manor), Mintwallin central park and on the way to the old Mintwallin area, Factory Quarter (Yalahar).",
}
monster.experience = 0
monster.race = "blood"
monster.maxHealth = 20
monster.health = 20
monster.speed = 124
monster.manaCost = 220
monster.corpse = 5971
monster.outfit = { lookType = 32 }
monster.runHealth = 8
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
    defense = 1,
    armor = 1,
}
monster.voices = {
    interval = 5000,
    chance = 10,
    {text = "Wuff wuff", yell = false},
}

mtype:register(monster)
