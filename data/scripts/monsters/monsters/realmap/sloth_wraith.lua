local mtype = Game.createMonsterType("Sloth Wraith")
local monster = {}

monster.name = "Sloth Wraith"
monster.description = "a sloth wraith"

monster.experience = 0
monster.race = "undead"
monster.maxHealth = 100
monster.health = 100
monster.speed = 230
monster.manaCost = 0
monster.corpse = 6316
monster.outfit = { lookType = 233 }
monster.changeTarget = {
    interval = 4000,
    chance = 15,
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
    canPushItems = true,
    canPushCreatures = false,
}
monster.attacks = {
    {
        name = "speed",
        interval = 2000,
        chance = 50,
        range = 7,
        duration = 3000,
        speed = -300,
        target = true,
        shootEffect = CONST_ANI_SUDDENDEATH,
        effect = CONST_ME_MORTAREA,
    },
}
monster.defenses = {
    defense = 10,
    armor = 10,
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
