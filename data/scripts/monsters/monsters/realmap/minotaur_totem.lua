local mtype = Game.createMonsterType("Minotaur Totem")
local monster = {}

monster.name = "Minotaur Totem"
monster.description = "a minotaur totem"

monster.experience = 0
monster.race = "undead"
monster.maxHealth = 5000
monster.health = 5000
monster.speed = 0
monster.manaCost = 0
monster.outfit = { lookTypeEx = 3802 }
monster.changeTarget = {
    interval = 5000,
    chance = 16,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 0
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = true,
    illusionable = false,
    convinceable = false,
    pushable = false,
    canPushItems = false,
    canPushCreatures = false,
    healthHidden = true,
}
monster.defenses = {
    defense = 30,
    armor = 30,
    {
        name = "healing",
        interval = 4000,
        chance = 15,
        minDamage = 10,
        maxDamage = 1000,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.immunities = {
    {type = "invisible", condition = true},
}

mtype:register(monster)
