local mtype = Game.createMonsterType("Demon Summoner")
local monster = {}

monster.name = "Demon Summoner"
monster.description = "bones"

monster.experience = 0
monster.race = "undead"
monster.maxHealth = 100
monster.health = 100
monster.speed = 0
monster.manaCost = 0
monster.outfit = { lookTypeEx = 460 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.targetDistance = 1
monster.staticAttackChance = 100
monster.runHealth = 0
monster.flags = {
    summonable = false,
    attackable = false,
    hostile = true,
    illusionable = false,
    convinceable = false,
    pushable = false,
    canPushItems = false,
    canPushCreatures = true,
    healthHidden = true,
}
monster.defenses = {
    defense = 0,
    armor = 0,
    {
        name = "healing",
        interval = 2000,
        chance = 30,
        minDamage = 0,
        maxDamage = 0,
        effect = CONST_ME_MORTAREA,
    },
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
monster.maxSummons = 1
monster.summons = {
    {name = "Demon", interval = 1000, chance = 100, max = 1},
}

mtype:register(monster)
