local mtype = Game.createMonsterType("Wasp")
local monster = {}

monster.name = "Wasp"
monster.description = "a wasp"

monster.raceId = 44
monster.bestiary = {
	race = "Vermin",
	class = "Vermin",
	toKill = 250,
	firstUnlock = 10,
	secondUnlock = 100,
	charmPoints = 5,
	stars = 1,
	occurrence = 0,
	locations = "South of Thais, west of Ab'Dendriel, northeastern Cormaya, Green Claw Swamp between Kazordoon and Venore, Wasp Tower in Rookgaard, Wasp Towers in Darashia, all over Tiquanda, and all over Vandura, roaming around Marapur.",
}
monster.experience = 24
monster.race = "venom"
monster.maxHealth = 35
monster.health = 35
monster.speed = 320
monster.manaCost = 280
monster.corpse = 5989
monster.outfit = { lookType = 44 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.flags = {
    summonable = true,
    attackable = true,
    hostile = true,
    illusionable = true,
    convinceable = false,
    pushable = true,
    canPushItems = false,
    canPushCreatures = false,
    canWalkOnEnergy = false,
    canWalkOnFire = false,
}
monster.attacks = {
    {
        name = "melee",
        interval = 2000,
        minDamage = 0,
        maxDamage = -20,
        -- NOTE: melee condition (poison=20); verify damage/duration
        condition = {
            type = CONDITION_POISON,
            interval = 20000,
        },
    },
}
monster.defenses = {
    defense = 4,
    armor = 4,
}
monster.elements = {
    {type = COMBAT_FIREDAMAGE, percent = -10},
}
monster.immunities = {
    {type = "earth", combat = true, condition = true},
}
monster.voices = {
    interval = 5000,
    chance = 10,
    {text = "Bssssss", yell = false},
}
monster.loot = {
    {
        id = "honeycomb",
        chance = 3000,
    },
}

mtype:register(monster)
