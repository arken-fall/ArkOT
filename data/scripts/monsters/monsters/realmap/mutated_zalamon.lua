local mtype = Game.createMonsterType("Mutated Zalamon")
local monster = {}

monster.name = "Mutated Zalamon"
monster.description = "Mutated Zalamon"

monster.experience = 10000
monster.race = "venom"
monster.maxHealth = 155000
monster.health = 155000
monster.speed = 238
monster.manaCost = 0
monster.corpse = 12385
monster.outfit = { lookType = 356 }
monster.changeTarget = {
    interval = 2000,
    chance = 10,
}
monster.staticAttackChance = 90
monster.targetDistance = 1
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
monster.attacks = {
    {
        name = "melee",
        minDamage = 0,
        maxDamage = -400,
        interval = 2000,
    },
    {
        name = "poison",
        interval = 2000,
        chance = 15,
        range = 7,
        minDamage = 0,
        maxDamage = -815,
        shootEffect = CONST_ANI_POISON,
        effect = CONST_ME_POISONAREA,
    },
    {
        name = "poison",
        interval = 2000,
        chance = 10,
        minDamage = -100,
        maxDamage = -300,
        radius = 4,
        target = true,
        shootEffect = CONST_ANI_POISON,
        effect = CONST_ME_POISONAREA,
    },
    {
        name = "speed",
        interval = 4000,
        chance = 20,
        range = 7,
        duration = 12000,
        speed = -350,
        target = true,
        shootEffect = CONST_ANI_POISON,
    },
}
monster.defenses = {
    defense = 65,
    armor = 70,
    {
        name = "healing",
        interval = 2000,
        chance = 9,
        minDamage = 20,
        maxDamage = 560,
        effect = CONST_ME_MAGIC_BLUE,
    },
    {
        name = "outfit",
        interval = 2000,
        chance = 10,
        duration = 10000,
        monster = "Lizard Snakecharmer",
        effect = CONST_ME_ENERGYHIT,
    },
    {
        name = "outfit",
        interval = 2000,
        chance = 10,
        duration = 10000,
        monster = "Lizard Abomination",
        effect = CONST_ME_ENERGYHIT,
    },
    {
        name = "outfit",
        interval = 2000,
        chance = 10,
        duration = 10000,
        monster = "Serpent Spawn",
        effect = CONST_ME_ENERGYHIT,
    },
    {
        name = "outfit",
        interval = 2000,
        chance = 10,
        duration = 10000,
        monster = "Draken Abomination",
        effect = CONST_ME_ENERGYHIT,
    },
    {
        name = "outfit",
        interval = 2000,
        chance = 10,
        duration = 10000,
        monster = "Mutated Zalamon",
        effect = CONST_ME_ENERGYHIT,
    },
}
monster.elements = {
    {type = COMBAT_FIREDAMAGE, percent = -10},
    {type = COMBAT_ENERGYDAMAGE, percent = -10},
    {type = COMBAT_PHYSICALDAMAGE, percent = 5},
    {type = COMBAT_ICEDAMAGE, percent = 10},
}
monster.immunities = {
    {type = "earth", combat = true, condition = true},
    {type = "invisible", condition = true},
    {type = "paralyze", condition = true},
}

mtype:register(monster)
