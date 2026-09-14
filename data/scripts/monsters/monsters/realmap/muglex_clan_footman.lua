local mtype = Game.createMonsterType("Muglex Clan Footman")
local monster = {}

monster.name = "Muglex Clan Footman"
monster.description = "a muglex clan footman"

monster.experience = 25
monster.race = "blood"
monster.maxHealth = 50
monster.health = 50
monster.speed = 120
monster.manaCost = 0
monster.corpse = 6002
monster.outfit = { lookType = 61 }
monster.changeTarget = {
    interval = 2000,
    chance = 0,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 15
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = true,
    illusionable = false,
    convinceable = false,
    pushable = true,
    canPushItems = false,
    canPushCreatures = false,
}
monster.attacks = {
    {
        name = "melee",
        attack = 10,
        skill = 10,
        interval = 2000,
    },
    {
        name = "physical",
        interval = 2000,
        chance = 8,
        range = 7,
        minDamage = -0,
        maxDamage = -22,
        shootEffect = CONST_ANI_SMALLSTONE,
    },
}
monster.defenses = {
    defense = 4,
    armor = 2,
}
monster.loot = {
    {id = 2230, chance = 1410},
    {id = 2449, chance = 9440},
    {id = 2379, chance = 17040},
    {id = 2667, chance = 159200, maxCount = 2},
    {id = 12495, chance = 1130},
    {id = 2148, chance = 100000, maxCount = 6},
    {id = 2467, chance = 6060},
    {id = 2461, chance = 2680},
    {id = 2235, chance = 850},
    {id = 2406, chance = 9720},
    {id = 2559, chance = 7750},
    {id = 1294, chance = 15210, maxCount = 1},
}

mtype:register(monster)
