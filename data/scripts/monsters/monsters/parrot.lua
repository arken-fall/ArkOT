local mtype = Game.createMonsterType("Parrot")
local monster = {}

monster.name = "Parrot"
monster.description = "a parrot"

monster.raceId = 217
monster.bestiary = {
	race = "Bird",
	class = "Bird",
	toKill = 250,
	firstUnlock = 10,
	secondUnlock = 100,
	charmPoints = 5,
	stars = 1,
	occurrence = 0,
	locations = "In the jungle of Tiquanda, Liberty Bay, the Shattered Isles, and as a house pet in Meriana.",
}
monster.experience = 0
monster.race = "blood"
monster.maxHealth = 25
monster.health = 25
monster.speed = 320
monster.manaCost = 250
monster.corpse = 6056
monster.outfit = { lookType = 217 }
monster.runHealth = 25
monster.changeTarget = {
    interval = 5000,
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
monster.attacks = {
    {
        name = "melee",
        interval = 2000,
        minDamage = 0,
        maxDamage = -5,
    },
}
monster.defenses = {
    defense = 2,
    armor = 2,
}
monster.voices = {
    interval = 5000,
    chance = 10,
    {text = "You advanshed, you advanshed!", yell = false},
    {text = "Neeewbiiieee!", yell = false},
    {text = "Screeech!", yell = false},
    {text = "Hunterrr ish PK!", yell = false},
    {text = "BR? PL? SWE?", yell = false},
    {text = "Hope you die and loooosh it!", yell = false},
    {text = "You powerrrrrrabuserrrrr!", yell = false},
    {text = "You are corrrrupt! Corrrrupt!", yell = false},
    {text = "Tarrrrp?", yell = false},
    {text = "Blesshhh my stake! Screeech!", yell = false},
    {text = "Leeave orrr hunted!!", yell = false},
    {text = "Shhtop whining! Rraaah!", yell = false},
    {text = "I'm heeerrre! Screeeech!", yell = false},
}

mtype:register(monster)
