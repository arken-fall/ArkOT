local mtype = Game.createMonsterType("Football")
local monster = {}

monster.name = "Football"
monster.description = "a football"

monster.experience = 5
monster.race = "undead"
monster.maxHealth = 100
monster.health = 100
monster.speed = 200
monster.manaCost = 0
monster.outfit = { lookTypeEx = 2109 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
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
    canPushItems = true,
    canPushCreatures = true,
}
monster.defenses = {
    defense = 20,
    armor = 20,
}
monster.immunities = {
    {type = "physical", combat = true},
    {type = "energy", combat = true, condition = true},
    {type = "fire", combat = true, condition = true},
    {type = "poison", combat = true, condition = true},
    {type = "ice", combat = true, condition = true},
    {type = "holy", combat = true, condition = true},
    {type = "death", combat = true, condition = true},
    {type = "lifedrain", combat = true},
    {type = "paralyze", condition = true},
    {type = "drown", combat = true, condition = true},
    {type = "invisible", condition = true},
}

mtype:register(monster)
