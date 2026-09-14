local mtype = Game.createMonsterType("Deaththrower")
local monster = {}

monster.name = "Deaththrower"
monster.description = "a deaththrower"

monster.experience = 0
monster.race = "undead"
monster.maxHealth = 100
monster.health = 100
monster.speed = 0
monster.manaCost = 0
monster.outfit = { lookTypeEx = 1551 }
monster.changeTarget = {
    interval = 5000,
    chance = 16,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 0
monster.flags = {
    summonable = false,
    attackable = false,
    hostile = true,
    illusionable = false,
    convinceable = false,
    pushable = false,
    canPushItems = false,
    canPushCreatures = false,
    healthHidden = true,
}
monster.attacks = {
    {
        name = "dark torturer skill reducer",
        interval = 2000,
        chance = 15,
        range = 6,
        target = false,
        shootEffect = CONST_ANI_SUDDENDEATH,
        effect = CONST_ME_POFF,
    },
}
monster.defenses = {
    defense = 1,
    armor = 1,
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
