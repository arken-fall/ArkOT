local mtype = Game.createMonsterType("Wolf")
local monster = {}

monster.name = "Wolf"
monster.description = "a wolf"

monster.raceId = 27
monster.bestiary = {
	race = "Mammal",
	class = "Mammal",
	toKill = 250,
	firstUnlock = 10,
	secondUnlock = 100,
	charmPoints = 5,
	stars = 1,
	occurrence = 0,
	locations = "In almost all grass areas in Tibia, also found in Rookgaard and Dawnport.",
}
monster.experience = 18
monster.race = "blood"
monster.maxHealth = 25
monster.health = 25
monster.speed = 164
monster.manaCost = 255
monster.corpse = 5968
monster.outfit = { lookType = 27 }
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
    hostile = true,
    illusionable = true,
    convinceable = true,
    pushable = true,
    canPushItems = false,
    canPushCreatures = false,
    canWalkOnEnergy = false,
    canWalkOnFire = false,
    canWalkOnPoison = false,
}
monster.attacks = {
    {
        name = "melee",
        interval = 2000,
        minDamage = 0,
        maxDamage = -17,
    },
}
monster.defenses = {
    defense = 1,
    armor = 1,
}
monster.elements = {
    {type = COMBAT_HOLYDAMAGE, percent = 30},
    {type = COMBAT_ICEDAMAGE, percent = -10},
    {type = COMBAT_DEATHDAMAGE, percent = -5},
}
monster.voices = {
    interval = 5000,
    chance = 10,
    {text = "Yoooohhuuuu!", yell = false},
    {text = "Grrrrrrr", yell = false},
}
monster.loot = {
    {
        id = "meat",
        chance = 70000,
        maxCount = 2,
    },
    {
        id = "wolf paw",
        chance = 1000,
    },
}

mtype:register(monster)
