local mtype = Game.createMonsterType("Training Monk")
local monster = {}

monster.name = "Training Monk"
monster.description = "a training monk"

monster.experience = 0
monster.race = "blood"
monster.maxHealth = 200000
monster.health = 200000
monster.speed = 0
monster.manaCost = 0
monster.corpse = 22567
monster.outfit = { lookType = 57 }
monster.changeTarget = {
    interval = 60000,
    chance = 0,
}
monster.targetDistance = 1
monster.staticAttackChance = 50
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
}
monster.attacks = {
    {
        name = "melee",
        attack = -1,
        skill = 0,
        interval = 2000,
    },
}
monster.defenses = {
    defense = 0,
    armor = 0,
    {
        name = "healing",
        interval = 2000,
        chance = 80,
        minDamage = 10000,
        maxDamage = 20000,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.immunities = {
    {type = "invisible", condition = true},
}

mtype:register(monster)
