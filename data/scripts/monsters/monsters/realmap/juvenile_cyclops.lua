local mtype = Game.createMonsterType("Juvenile Cyclops")
local monster = {}

monster.name = "Juvenile Cyclops"
monster.description = "a juvenile cyclops"

monster.experience = 130
monster.race = "blood"
monster.maxHealth = 260
monster.health = 260
monster.speed = 190
monster.manaCost = 490
monster.corpse = 5962
monster.outfit = { lookType = 22 }
monster.changeTarget = {
    interval = 2000,
    chance = 5,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 0
monster.flags = {
    summonable = true,
    attackable = true,
    hostile = true,
    illusionable = true,
    convinceable = false,
    pushable = false,
    canPushItems = true,
    canPushCreatures = true,
}
monster.attacks = {
    {
        name = "melee",
        attack = 30,
        skill = 20,
        interval = 2000,
    },
    {
        name = "physical",
        interval = 2000,
        chance = 10,
        range = 7,
        minDamage = -0,
        maxDamage = -20,
        shootEffect = CONST_ANI_LARGEROCK,
    },
}
monster.defenses = {
    defense = 22,
    armor = 6,
}
monster.loot = {
    {id = 2464, chance = 10810},
    {id = 2458, chance = 12160},
    {id = 10574, chance = 4050},
    {id = 2148, chance = 100000, maxCount = 25},
    {id = 2388, chance = 9460},
    {id = 2398, chance = 18920},
    {id = 2666, chance = 30070, maxCount = 1},
    {id = 2510, chance = 1350},
    {id = 2468, chance = 9460},
    {id = 2376, chance = 21620},
    {id = 2129, chance = 1350},
}

mtype:register(monster)
