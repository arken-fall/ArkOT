local mtype = Game.createMonsterType("Depowered Minotaur")
local monster = {}

monster.name = "Depowered Minotaur"
monster.description = "a depowered minotaur"

monster.experience = 1100
monster.race = "blood"
monster.maxHealth = 1500
monster.health = 1500
monster.speed = 170
monster.manaCost = 0
monster.corpse = 5969
monster.outfit = { lookType = 25 }
monster.changeTarget = {
    interval = 4000,
    chance = 0,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 0
monster.flags = {
    summonable = true,
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
        maxDamage = -245,
        interval = 2000,
    },
}
monster.defenses = {
    defense = 15,
    armor = 15,
}
monster.elements = {
    {type = COMBAT_FIREDAMAGE, percent = 20},
    {type = COMBAT_HOLYDAMAGE, percent = 10},
}
monster.immunities = {
    {type = "invisible", condition = true},
}
monster.loot = {
    {id = 2148, chance = 100000, maxCount = 100},
    {id = 2152, chance = 67000, maxCount = 4},
    {id = 2147, chance = 67000},
    {id = 7588, chance = 67000, maxCount = 2},
    {id = 2666, chance = 34000, maxCount = 3},
    {id = 2145, chance = 34000},
}

mtype:register(monster)
