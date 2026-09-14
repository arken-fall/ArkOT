local mtype = Game.createMonsterType("Cobra")
local monster = {}

monster.raceId = 81
monster.bestiary = {
	race = "Reptile",
	class = "Reptile",
	toKill = 500,
	firstUnlock = 25,
	secondUnlock = 250,
	charmPoints = 15,
	stars = 2,
	occurrence = 0,
	locations = "Ankrahmun Library Tomb, Tarpit Tomb, Mountain Tomb, Peninsula Tomb, Darama, Tiquanda, Drefia, Forbidden Lands, Arena Quarter, Lion's Rock.",
}

monster.name = "Cobra"
monster.experience = 30
monster.race = "blood"
monster.maxHealth = 65
monster.health = 65
monster.speed = 120
monster.manaCost = 275
monster.corpse = 3007
monster.outfit = { lookType = 81 }
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
        maxDamage = 0,
        -- NOTE: melee condition (poison=100); verify damage/duration
        condition = {
            type = CONDITION_POISON,
            interval = 100000,
        },
    },
    {
        name = "poisoncondition",
        interval = 2000,
        chance = 15,
        range = 7,
        minDamage = -20,
        maxDamage = -40,
    },
}
monster.defenses = {
    defense = 1,
    armor = 1,
}
monster.elements = {
    {type = COMBAT_FIREDAMAGE, percent = -10},
}
monster.immunities = {
    {type = "drunk", condition = true},
    {type = "earth", combat = true, condition = true},
}
monster.voices = {
    interval = 5000,
    chance = 10,
    {text = "Zzzzzz", yell = false},
    {text = "Fsssss", yell = false},
}
monster.loot = {
    {
        id = "cobra tongue",
        chance = 5000,
    },
}

mtype:register(monster)
