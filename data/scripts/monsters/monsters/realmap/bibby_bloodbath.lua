local mtype = Game.createMonsterType("Bibby Bloodbath")
local monster = {}

monster.name = "Bibby Bloodbath"
monster.description = "Bibby Bloodbath"

monster.experience = 1500
monster.race = "blood"
monster.maxHealth = 1200
monster.health = 1200
monster.speed = 240
monster.manaCost = 0
monster.corpse = 6008
monster.outfit = { lookType = 2 }
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
        maxDamage = -200,
        interval = 2000,
    },
    {
        name = "physical",
        interval = 2000,
        chance = 20,
        minDamage = 0,
        maxDamage = -200,
        length = 5,
        spread = 3,
        effect = CONST_ME_BLOCKHIT,
    },
    {
        name = "speed",
        interval = 2000,
        chance = 15,
        radius = 3,
        duration = 30000,
        speed = -300,
        target = false,
        effect = CONST_ME_BLOCKHIT,
    },
}
monster.defenses = {
    defense = 35,
    armor = 35,
    {
        name = "invisible",
        interval = 2000,
        chance = 15,
        duration = 3000,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.elements = {
    {type = COMBAT_EARTHDAMAGE, percent = -2},
}
monster.immunities = {
    {type = "invisible", condition = true},
    {type = "fire", combat = true, condition = true},
    {type = "ice", combat = true, condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "Don't run, you'll just lose precious fat.", yell = false},
    {text = "Hex hex!", yell = false},
}
monster.loot = {
    {id = 2148, chance = 100000, maxCount = 100},
    {id = 2152, chance = 100000, maxCount = 10},
    {id = 2428, chance = 33000},
    {id = 2399, chance = 22000, maxCount = 18},
    {id = 2377, chance = 22000},
    {id = 2489, chance = 14000},
    {id = 7620, chance = 13000, maxCount = 3},
    {id = 2666, chance = 10000, maxCount = 2},
    {id = 7618, chance = 9000, maxCount = 3},
    {id = 2667, chance = 7500},
    {id = 2647, chance = 7500},
    {id = 2165, chance = 5700},
    {id = 7890, chance = 4000},
    {id = 7412, chance = 1600},
    {id = 2393, chance = 1600},
    {id = 7395, chance = 1600},
    {id = 2497, chance = 830},
}

mtype:register(monster)
