local mtype = Game.createMonsterType("Tiger")
local monster = {}

monster.name = "Tiger"
monster.description = "a tiger"

monster.raceId = 125
monster.bestiary = {
	race = "Mammal",
	class = "Mammal",
	toKill = 500,
	firstUnlock = 25,
	secondUnlock = 250,
	charmPoints = 15,
	stars = 2,
	occurrence = 0,
	locations = "Tiquanda, Meriana, Arena and Zoo Quarter. Three unreachable ones are found in the Rookgaard Academy, below Ankrahmun (during the Nomads Land Quest), and on Charles's ship.",
}
monster.experience = 40
monster.race = "blood"
monster.maxHealth = 75
monster.health = 75
monster.speed = 200
monster.manaCost = 420
monster.corpse = 6051
monster.outfit = { lookType = 125 }
monster.changeTarget = {
    interval = 4000,
    chance = 0,
}
monster.targetDistance = 1
monster.staticAttackChance = 70
monster.flags = {
    summonable = true,
    attackable = true,
    hostile = true,
    illusionable = true,
    convinceable = true,
    pushable = false,
    canPushItems = true,
    canPushCreatures = true,
    canWalkOnEnergy = false,
    canWalkOnFire = false,
    canWalkOnPoison = false,
}
monster.attacks = {
    {
        name = "melee",
        interval = 2000,
        minDamage = 0,
        maxDamage = -40,
    },
}
monster.defenses = {
    defense = 5,
    armor = 5,
    {
        name = "speed",
        interval = 2000,
        chance = 15,
        speed = 220,
        duration = 5000,
        effect = CONST_ME_MAGIC_RED,
    },
}
monster.elements = {
    {type = COMBAT_DEATHDAMAGE, percent = -10},
    {type = COMBAT_ICEDAMAGE, percent = -10},
}
monster.loot = {
    {
        id = "meat",
        chance = 35190,
        maxCount = 4,
    },
    {
        id = "striped fur",
        chance = 10830,
    },
}

mtype:register(monster)
