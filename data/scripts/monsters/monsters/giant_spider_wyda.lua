local mtype = Game.createMonsterType("Giant Spider")
local monster = {}

monster.name = "Giant Spider"
monster.description = "a giant spider"

monster.raceId = 38
monster.bestiary = {
	race = "Vermin",
	class = "Vermin",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 0,
	locations = "Plains of Havoc, Point of no Return in Outlaw Camp, Ghostlands, Hellgate, Mintwallin Secret Laboratory, Mad Mage Room deep below Ancient Temple, Mount Sternum Undead Cave, Green Claw Swamp, Maze of Lost Souls, Crusader Helmet Quest in the Dwarf Mines, Mushroom Gardens, west Drillworm Caves, Edron Hero Cave, Edron Orc Cave, on a hill near Drefia, on a hill north-west of Ankrahmun (inaccessible), Forbidden Lands, Deeper Banuta, Malada, Ramoa, Arena and Zoo Quarter, second floor up of Cemetery Quarter, beneath Fenrock, Vengoth Castle, Vandura Mountain, in a cave in Robson Isle, Chyllfroest, Spider Caves, second floor of Krailos Spider Lair, Caverna Exanima.",
}
monster.experience = 12
monster.race = "venom"
monster.maxHealth = 20
monster.health = 20
monster.speed = 152
monster.manaCost = 0
monster.corpse = 5977
monster.outfit = { lookType = 38 }
monster.runHealth = 6
monster.changeTarget = {
    interval = 2000,
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
        maxDamage = -9,
    },
}
monster.defenses = {
    defense = 2,
    armor = 2,
}
monster.elements = {
    {type = COMBAT_FIREDAMAGE, percent = -20},
}
monster.loot = {
    {
        id = "gold coin",
        chance = 65000,
        maxCount = 5,
    },
    {
        id = "spider fangs",
        chance = 950,
    },
}

mtype:register(monster)
