local mtype = Game.createMonsterType("Glooth Fairy")
local monster = {}

monster.name = "Glooth Fairy"
monster.description = "a glooth fairy"

monster.experience = 150
monster.race = "blood"
monster.maxHealth = 260
monster.health = 260
monster.speed = 200
monster.manaCost = 490
monster.corpse = 5962
monster.outfit = { lookType = 600 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 0
monster.flags = {
    summonable = true,
    attackable = true,
    hostile = true,
    illusionable = true,
    convinceable = true,
    pushable = false,
    canPushItems = true,
    canPushCreatures = true,
}
monster.attacks = {
    {
        name = "melee",
        attack = 30,
        skill = 60,
        interval = 2000,
    },
}
monster.defenses = {
    defense = 20,
    armor = 20,
}
monster.elements = {
    {type = COMBAT_ENERGYDAMAGE, percent = 25},
    {type = COMBAT_HOLYDAMAGE, percent = 20},
    {type = COMBAT_EARTHDAMAGE, percent = -10},
    {type = COMBAT_DEATHDAMAGE, percent = -10},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "Il lorstok human!", yell = false},
    {text = "Toks utat.", yell = false},
    {text = "Human, uh whil dyh!", yell = false},
    {text = "Youh ah trak!", yell = false},
    {text = "Let da mashing begin!", yell = false},
}
monster.loot = {
    {id = 2148, chance = 82000, maxCount = 47},
    {id = 7618, chance = 210},
    {id = 2666, chance = 30070},
    {id = 2510, chance = 2500},
    {id = 2406, chance = 8000},
    {id = 2513, chance = 1400},
    {id = 2129, chance = 190},
    {id = 2381, chance = 1003},
    {id = 2490, chance = 220},
    {id = 2209, chance = 90},
    {id = 7398, chance = 80},
    {id = 10574, chance = 4930},
}

mtype:register(monster)
