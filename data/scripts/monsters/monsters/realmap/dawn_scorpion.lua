local mtype = Game.createMonsterType("Dawn Scorpion")
local monster = {}

monster.name = "Dawn Scorpion"
monster.description = "a dawn scorpion"

monster.experience = 45
monster.race = "venom"
monster.maxHealth = 65
monster.health = 65
monster.speed = 150
monster.manaCost = 310
monster.corpse = 5988
monster.outfit = { lookType = 43 }
monster.changeTarget = {
    interval = 2000,
    chance = 10,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 5
monster.flags = {
    summonable = true,
    attackable = true,
    hostile = true,
    illusionable = true,
    convinceable = false,
    pushable = true,
    canPushItems = false,
    canPushCreatures = false,
}
monster.attacks = {
    {
        name = "melee",
        attack = 20,
        skill = 20,
        interval = 2000,
        condition = { type = CONDITION_POISON, minDamage = -40, maxDamage = -40, interval = 4000 },
    },
    {
        name = "poison",
        interval = 2000,
        chance = 10,
        range = 1,
        minDamage = -10,
        maxDamage = -20,
        shootEffect = CONST_ANI_POISON,
        effect = CONST_ME_POISONAREA,
    },
}
monster.defenses = {
    defense = 5,
    armor = 11,
}
monster.loot = {
    {id = 2148, chance = 100000, maxCount = 4},
    {id = 10568, chance = 2170},
}

mtype:register(monster)
