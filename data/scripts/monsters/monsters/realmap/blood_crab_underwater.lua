local mtype = Game.createMonsterType("Blood Crab")
local monster = {}

monster.name = "Blood Crab"
monster.description = "a blood crab"

monster.experience = 180
monster.race = "undead"
monster.maxHealth = 320
monster.health = 320
monster.speed = 250
monster.manaCost = 505
monster.corpse = 6075
monster.outfit = { lookType = 200 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.staticAttackChance = 90
monster.targetDistance = 1
monster.runHealth = 0
monster.flags = {
    summonable = true,
    attackable = true,
    hostile = true,
    illusionable = false,
    convinceable = false,
    pushable = false,
    canPushItems = true,
    canPushCreatures = false,
    canWalkOnEnergy = false,
    canWalkOnFire = false,
}
monster.attacks = {
    {
        name = "melee",
        minDamage = 0,
        maxDamage = -113,
        interval = 2000,
    },
}
monster.defenses = {
    defense = 20,
    armor = 20,
}
monster.elements = {
    {type = COMBAT_PHYSICALDAMAGE, percent = 20},
    {type = COMBAT_FIREDAMAGE, percent = -10},
    {type = COMBAT_ENERGYDAMAGE, percent = -5},
}
monster.immunities = {
    {type = "ice", combat = true, condition = true},
    {type = "earth", combat = true, condition = true},
    {type = "drown", combat = true, condition = true},
}
monster.loot = {
    {id = "white pearl", chance = 480},
    {id = "gold coin", chance = 90000, maxCount = 20},
    {id = "chain armor", chance = 5555},
    {id = "brass legs", chance = 2170},
    {id = 2667, chance = 13000},
    {id = "bloody pincers", chance = 6260},
}

mtype:register(monster)
