local mtype = Game.createMonsterType("Devourer")
local monster = {}

monster.name = "Devourer"
monster.description = "a devourer"

monster.experience = 1800
monster.race = "blood"
monster.maxHealth = 1900
monster.health = 1900
monster.speed = 200
monster.manaCost = 0
monster.corpse = 23484
monster.outfit = { lookType = 617 }
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
monster.attacks = {
    {
        name = "melee",
        minDamage = 0,
        maxDamage = -260,
        interval = 2000,
        condition = { type = CONDITION_POISON, minDamage = -18, maxDamage = -18, interval = 4000 },
    },
    {
        name = "earth",
        interval = 2000,
        chance = 15,
        range = 7,
        minDamage = 0,
        maxDamage = -150,
        shootEffect = CONST_ANI_POISON,
        effect = CONST_ME_GREEN_RINGS,
    },
    {
        name = "earth",
        interval = 2000,
        chance = 15,
        minDamage = 0,
        maxDamage = -150,
        length = 8,
        spread = 3,
        effect = CONST_ME_SMALLPLANTS,
    },
    {
        name = "earth",
        interval = 2000,
        chance = 15,
        minDamage = 0,
        maxDamage = -200,
        radius = 4,
        target = true,
        effect = CONST_ME_POISONAREA,
    },
    {
        name = "speed",
        interval = 2000,
        chance = 15,
        radius = 3,
        duration = 13000,
        speed = -200,
        target = false,
        effect = CONST_ME_POISONAREA,
    },
}
monster.defenses = {
    defense = 45,
    armor = 45,
    {
        name = "healing",
        interval = 2000,
        chance = 5,
        minDamage = 0,
        maxDamage = 135,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.elements = {
    {type = COMBAT_ENERGYDAMAGE, percent = -5},
    {type = COMBAT_ICEDAMAGE, percent = 20},
    {type = COMBAT_DEATHDAMAGE, percent = 20},
}
monster.immunities = {
    {type = "earth", combat = true, condition = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "*gulp*", yell = false},
    {text = "*Bruaarrr!*", yell = false},
    {text = "*omnnommm nomm*", yell = false},
}

mtype:register(monster)
