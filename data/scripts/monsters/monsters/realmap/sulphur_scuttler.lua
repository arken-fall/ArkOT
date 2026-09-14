local mtype = Game.createMonsterType("Sulphur Scuttler")
local monster = {}

monster.name = "Sulphur Scuttler"
monster.description = "a sulphur scuttler"

monster.experience = 900
monster.race = "venom"
monster.maxHealth = 1300
monster.health = 1300
monster.speed = 200
monster.manaCost = 0
monster.corpse = 12527
monster.outfit = { lookType = 352 }
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
    canPushCreatures = false,
}
monster.attacks = {
    {
        name = "melee",
        minDamage = 0,
        maxDamage = -200,
        interval = 2000,
    },
    {
        name = "speed",
        interval = 2000,
        chance = 20,
        range = 7,
        duration = 10000,
        speed = -600,
        shootEffect = CONST_ANI_DEATH,
        effect = CONST_ME_MORTAREA,
    },
    {
        name = "earth",
        interval = 2000,
        chance = 5,
        minDamage = 0,
        maxDamage = -394,
        radius = 6,
        target = false,
        effect = CONST_ME_SMALLPLANTS,
    },
    {
        name = "manadrain",
        interval = 2000,
        chance = 10,
        minDamage = 0,
        maxDamage = -200,
        length = 6,
        spread = 0,
        effect = CONST_ME_HITBYPOISON,
    },
    {
        name = "poison",
        interval = 2000,
        chance = 15,
        minDamage = 0,
        maxDamage = -120,
        length = 8,
        spread = 3,
        effect = CONST_ME_YELLOW_RINGS,
    },
}
monster.defenses = {
    defense = 25,
    armor = 25,
}
monster.elements = {
    {type = COMBAT_FIREDAMAGE, percent = -10},
}
monster.immunities = {
    {type = "lifedrain", combat = true},
    {type = "death", combat = true, condition = true},
    {type = "earth", combat = true, condition = true},
    {type = "invisible", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "Chrrr!", yell = false},
}
monster.loot = {
    {id = 2152, chance = 98330, maxCount = 10},
    {id = 10557, chance = 50000},
    {id = 11222, chance = 75000},
    {id = 11232, chance = 96670},
    {id = 12659, chance = 100000},
    {id = 7589, chance = 71670},
    {id = 7588, chance = 75000},
    {id = 12658, chance = 100000},
    {id = 2149, chance = 65000, maxCount = 4},
    {id = 5904, chance = 81670},
    {id = 2165, chance = 46670},
    {id = 2171, chance = 20000},
}

mtype:register(monster)
