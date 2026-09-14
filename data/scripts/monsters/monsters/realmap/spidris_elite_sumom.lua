local mtype = Game.createMonsterType("Spidris Elite")
local monster = {}

monster.name = "Spidris Elite"
monster.description = "a spidris elite"

monster.experience = 100
monster.race = "venom"
monster.maxHealth = 3700
monster.health = 3700
monster.speed = 260
monster.manaCost = 0
monster.corpse = 15296
monster.outfit = { lookType = 457 }
monster.changeTarget = {
    interval = 4000,
    chance = 0,
}
monster.targetDistance = 0
monster.runHealth = 0
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = true,
    illusionable = false,
    convinceable = false,
    pushable = true,
    canPushItems = true,
    canPushCreatures = true,
}
monster.attacks = {
    {
        name = "melee",
        attack = 82,
        skill = 75,
        interval = 2000,
    },
}
monster.defenses = {
    defense = 30,
    armor = 30,
}
monster.elements = {
    {type = COMBAT_HOLYDAMAGE, percent = -10},
}
monster.immunities = {
    {type = "earth", combat = true, condition = true},
    {type = "invisible", condition = true},
}

mtype:register(monster)
