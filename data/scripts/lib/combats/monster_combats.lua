-- Combat table definitions for monster spells.
-- Spells with setCallback keep that call in the spell file; base props come from here.
-- hirintror_skill_reducer and glooth_fairy_skill_reducer create dynamic combat arrays
-- and are excluded — their spell files remain self-contained.

-- Pre-built custom areas (inline definitions from original spell files)
local _waveTArea             = createCombatArea({{1, 1, 1}, {0, 1, 0}, {0, 3, 0}})
local _explosionWaveArea     = createCombatArea({{1, 1, 1}, {1, 1, 1}, {0, 1, 0}, {0, 3, 0}})
local _lloydWave1Area        = createCombatArea({
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 2, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
})
local _lloydWave2Area        = createCombatArea({
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 2, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
})
local _ferumbrasSoulfireArea = createCombatArea({
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
})
local _ferumbrasElectrifyArea = createCombatArea({
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 1, 1, 1, 1, 3, 1, 1, 1, 1, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
})
local _energyPulseArea = createCombatArea({
    {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
})
local _remorselessWaveArea = createCombatArea({
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
})
local _sourceOfCorruptionArea = createCombatArea({{0,0,0,0,0},{0,1,3,1,0},{0,0,0,0,0}})
local _freedSoulArea = createCombatArea({
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
})
local _frozenMinionWaveArea = createCombatArea({
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0},
})
local _aggressiveLavaBombArea = createCombatArea({
    {0, 1, 1, 1, 0},
    {1, 1, 1, 1, 1},
    {1, 1, 3, 1, 1},
    {1, 1, 1, 1, 1},
    {0, 1, 1, 1, 0},
})
local _emberBeastBeamArea = createCombatArea({{1},{1},{1},{1},{1},{3}})
local _emberBeastAreaArea = createCombatArea({{1,1,1},{1,3,1},{1,1,1}})

-- Pre-created conditions for combats that embed them
local _physicalExplosionCondition = Condition(Combat.DamageType.Physical) -- intentional: evaluates to 1
_physicalExplosionCondition:setParameter(CONDITION_PARAM_DELAYED, 1)
_physicalExplosionCondition:addDamage(3, 10000, -25)

local _ferumbrasSoulfireCondition = Condition(CONDITION_FIRE)
_ferumbrasSoulfireCondition:setParameter(CONDITION_PARAM_DELAYED, 1)
_ferumbrasSoulfireCondition:addDamage(50, 9000, -10)

local _pixieCondition = Condition(CONDITION_ATTRIBUTES)
_pixieCondition:setParameter(CONDITION_PARAM_TICKS, 6000)
_pixieCondition:setParameter(CONDITION_PARAM_SKILL_DISTANCEPERCENT, 30)
_pixieCondition:setParameter(CONDITION_PARAM_SKILL_SHIELDPERCENT, 30)
_pixieCondition:setParameter(CONDITION_PARAM_SKILL_MELEEPERCENT, 30)

local _hirintrorFreezeCondition = Condition(CONDITION_FREEZING)
_hirintrorFreezeCondition:setParameter(CONDITION_PARAM_DELAYED, 1)
_hirintrorFreezeCondition:addDamage(25, 8000, -8)

-- ported from Canary by harness/build_canary_monster_spells.py
local _bulltaurAvalancheArea = createCombatArea({
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 3, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0}
})

local _bulltaurewaveArea = createCombatArea({
    {0, 0, 0, 0, 0, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 3, 0, 0, 0}
})

local _bulltaurExplosionArea = createCombatArea({
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 1, 1, 3, 1, 1, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0}
})

local _fireringArea = createCombatArea({
    {0, 1, 1, 1, 0},
    {1, 0, 0, 0, 1},
    {1, 0, 2, 0, 1},
    {1, 0, 0, 0, 1},
    {0, 1, 1, 1, 0}
})

local _firexArea = createCombatArea({
    {1, 0, 1},
    {0, 2, 0},
    {1, 0, 1}
})

local _corymVanguardWaveArea = createCombatArea({
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0}
})

local _dreadRcircleArea = createCombatArea({
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 0, 0, 0, 1, 0},
    {1, 0, 0, 2, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {0, 1, 0, 0, 0, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
})

local _emeraldTortoiseLargeRingArea = createCombatArea({
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 0, 0, 0, 1, 1, 1},
    {1, 1, 1, 0, 3, 0, 1, 1, 1},
    {1, 1, 1, 0, 0, 0, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0}
})

local _emeraldTortoiseSmallExplosionArea = createCombatArea({
    {1, 1, 1},
    {1, 3, 1},
    {1, 1, 1}
})

local _emeraldTortoiseSmallRingArea = createCombatArea({
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 0, 1, 1, 0, 0},
    {0, 0, 1, 0, 3, 0, 1, 0, 0},
    {0, 0, 1, 1, 0, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0}
})

local _feroxaSummonArea = createCombatArea({
    {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0}
})

local _frazzlemawParalyzeArea = createCombatArea({
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 1, 1, 1, 1, 3, 1, 1, 1, 1, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
})

local _ghastlyDragonWaveArea = createCombatArea({
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0}
})

local _girtabliluPoisonWaveArea = createCombatArea({
    {1, 1, 1},
    {1, 1, 1},
    {0, 1, 0},
    {0, 3, 0}
})

local _gorerillaLargeRingArea = createCombatArea({
    {0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 1, 0, 0, 0, 1, 1, 0},
    {0, 1, 1, 0, 3, 0, 1, 1, 0},
    {0, 1, 1, 0, 0, 0, 1, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0}
})

local _hauntedTreelingParalyzeArea = createCombatArea({
    {1},
    {1},
    {1},
    {1},
    {1},
    {3}
})

local _headpeckerExplosionArea = createCombatArea({
    {1, 1, 1},
    {1, 3, 1},
    {1, 1, 1}
})

local _iceGolemParalyzeArea = createCombatArea({
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0}
})

local _iksyapunacwaveArea = createCombatArea({
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 3, 0, 0, 0}
})

local _katexDeathtArea = createCombatArea({
    {1, 1, 1},
    {0, 1, 0},
    {0, 3, 0}
})

local _lavafungusRingArea = createCombatArea({
    {0, 1, 1, 1, 0},
    {1, 0, 0, 0, 1},
    {1, 0, 2, 0, 1},
    {1, 0, 0, 0, 1},
    {0, 1, 1, 1, 0}
})

local _lavafungusXWaveArea = createCombatArea({
    {1, 0, 1},
    {0, 2, 0},
    {1, 0, 1}
})

local _lloydWaveArea = createCombatArea({
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 2, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
})

local _lloydWave2Area = createCombatArea({
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 2, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
})

local _lloydWave3Area = createCombatArea({
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 2, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
})

local _mantosaurusRingArea = createCombatArea({
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
    {0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0},
    {0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {1, 1, 0, 0, 0, 3, 0, 0, 0, 1, 1},
    {0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
    {0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0},
    {0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0}
})

local _medusaParalyzeArea = createCombatArea({
    {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0}
})

local _earthBeammyArea = createCombatArea({
    {1},
    {0},
    {1},
    {0},
    {1},
    {0},
    {3}
})

local _mercurialMenaceRingArea = createCombatArea({
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 0, 1, 1, 1},
    {1, 1, 0, 3, 0, 1, 1},
    {1, 1, 1, 0, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
})

local _mitmahseekwaveArea = createCombatArea({
    {0, 0, 0, 0, 0, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 3, 0, 0, 0}
})

local _omrafirWaveArea = createCombatArea({
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0}
})

local _outburstExplodeArea = createCombatArea({
    {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0}
})

local _targetfireringArea = createCombatArea({
    {1, 0, 1},
    {0, 2, 0},
    {1, 0, 1}
})

local _quaracrossdeathArea = createCombatArea({
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
    {1, 1, 1, 2, 1, 1, 1},
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0}
})

local _quarasmokedeathArea = createCombatArea({
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
})

local _quaraseamonsterArea = createCombatArea({
    {1, 0, 1},
    {0, 0, 0},
    {0, 1, 0},
    {0, 2, 0}
})

local _quarawatersplashArea = createCombatArea({
    {0, 0, 1, 0},
    {1, 0, 2, 0},
    {0, 0, 0, 1},
    {0, 1, 0, 0}
})

local _rotthligexploArea = createCombatArea({
    {0, 0, 0, 0, 0},
    {0, 1, 1, 1, 0},
    {0, 1, 3, 1, 0},
    {0, 1, 1, 1, 0},
    {0, 0, 0, 0, 0}
})

local _rotthligulusArea = createCombatArea({
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0},
    {0, 0, 1, 1, 0, 0, 3, 0, 0, 1, 1, 0, 0},
    {0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
})

local _rotthligholyulusArea = createCombatArea({
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0},
    {0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0},
    {0, 1, 1, 1, 0, 0, 3, 0, 0, 1, 1, 1, 0},
    {0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0},
    {0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
})

local _sabretoothWaveArea = createCombatArea({
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 0, 1, 1, 3, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
})

local _lleechWavetArea = createCombatArea({
    {1, 1, 1},
    {0, 1, 0},
    {0, 3, 0}
})

local _energyWavetArea = createCombatArea({
    {1, 1, 1},
    {0, 1, 0},
    {0, 1, 0},
    {0, 1, 0},
    {0, 3, 0}
})

local _theWelterParalyzeArea = createCombatArea({
    {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0}
})

local _tyrnElectrifyArea = createCombatArea({
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0}
})

local _unchainedFireExplosionArea = createCombatArea({
    {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0}
})

local _undertakerSquareExplosionArea = createCombatArea({
    {1, 1, 1},
    {1, 3, 1},
    {1, 1, 1}
})

local _urmahlulluringArea = createCombatArea({
    {0, 1, 1, 1, 0},
    {1, 0, 0, 0, 1},
    {1, 0, 2, 0, 1},
    {1, 0, 0, 0, 1},
    {0, 1, 1, 1, 0}
})

local _wardenRingArea = createCombatArea({
    {0, 1, 1, 1, 0},
    {1, 0, 0, 0, 1},
    {1, 0, 2, 0, 1},
    {1, 0, 0, 0, 1},
    {0, 1, 1, 1, 0}
})

local _wardenXArea = createCombatArea({
    {1, 0, 1},
    {0, 2, 0},
    {1, 0, 1}
})

local _werecrocodileFireRingArea = createCombatArea({
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0},
    {1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1},
    {1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1},
    {1, 1, 0, 0, 0, 0, 3, 0, 0, 0, 0, 1, 1},
    {1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1},
    {1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1},
    {0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0}
})

local _werelionWaveArea = createCombatArea({
    {0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0}
})

local _whitePaleParalyzeArea = createCombatArea({
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0}
})

local _whitePaleSummonArea = createCombatArea({
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 1, 1, 1, 1, 3, 1, 1, 1, 1, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
})

local _wyrmWaveArea = createCombatArea({
    {0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0}
})

MonsterCombats = {

    -- Elemental damage-over-time spells (use getTargets + addDamageCondition in spell file)
    GhastlyDragonCurse = {
        damageType     = Combat.DamageType.Death,
        impactEffect   = CONST_ME_SMALLCLOUDS,
        distanceEffect = CONST_ANI_DEATH,
    },

    DjinnElectrify = {
        damageType     = Combat.DamageType.Energy,
        impactEffect   = CONST_ME_ENERGYHIT,
        distanceEffect = CONST_ANI_ENERGY,
    },

    DrakenAbominationCurse = {
        damageType     = Combat.DamageType.Death,
        impactEffect   = CONST_ME_SMALLCLOUDS,
        distanceEffect = CONST_ANI_DEATH,
    },

    LancerBeetleCurse = {
        damageType     = Combat.DamageType.Death,
        impactEffect   = CONST_ME_SMALLCLOUDS,
        distanceEffect = CONST_ANI_DEATH,
    },

    BlightwalkerCurse = {
        damageType   = Combat.DamageType.Death,
        impactEffect = CONST_ME_SMALLCLOUDS,
        area         = createCombatArea(AREA_CIRCLE6X6),
    },

    ChokingFearDrown = {
        damageType   = Combat.DamageType.Drown,
        impactEffect = CONST_ME_BUBBLES,
        area         = createCombatArea(AREA_CIRCLE6X6),
    },

    CliffStriderElectrify = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_ENERGYHIT,
    },

    DeathBlobCurse = {
        damageType     = Combat.DamageType.Death,
        impactEffect   = CONST_ME_SMALLCLOUDS,
        distanceEffect = CONST_ANI_DEATH,
    },

    DjinnCancelInvisibility = {
        area = createCombatArea(AREA_CIRCLE3X3),
    },

    EnergyElementalElectrify = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_BLOCKHIT,
        area         = createCombatArea(AREA_CIRCLE3X3),
    },

    HellspawnSoulfire = {
        damageType     = Combat.DamageType.Fire,
        impactEffect   = CONST_ME_HITBYFIRE,
        distanceEffect = CONST_ANI_FIRE,
    },

    HellfireFighterSoulfire = {
        damageType   = Combat.DamageType.Fire,
        impactEffect = CONST_ME_FIREATTACK,
        area         = createCombatArea(AREA_CIRCLE6X6),
    },

    LavaGolemSoulfire = {
        damageType   = Combat.DamageType.Fire,
        impactEffect = CONST_ME_EXPLOSIONHIT,
        area         = createCombatArea(AREA_CIRCLE2X2),
    },

    LizardMagistratusCurse = {
        damageType     = Combat.DamageType.Death,
        impactEffect   = CONST_ME_SMALLCLOUDS,
        distanceEffect = CONST_ANI_DEATH,
    },

    MagmaCrawlerSoulfire = {
        damageType   = Combat.DamageType.Fire,
        impactEffect = CONST_ME_EXPLOSIONHIT,
        area         = createCombatArea(AREA_CIRCLE2X2),
    },

    MassiveEnergyElementalElectrify = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_BLOCKHIT,
        area         = createCombatArea(AREA_CIRCLE3X3),
    },

    MassiveFireElementalSoulfire = {
        damageType   = Combat.DamageType.Fire,
        impactEffect = CONST_ME_MAGIC_RED,
        area         = createCombatArea(AREA_CIRCLE6X6),
    },

    MonsterSoulfire = {
        damageType     = Combat.DamageType.Fire,
        impactEffect   = CONST_ME_FIREAREA,
        distanceEffect = CONST_ANI_FIRE,
    },

    MutatedBatCurse = {
        damageType     = Combat.DamageType.Death,
        impactEffect   = CONST_ME_SMALLCLOUDS,
        distanceEffect = CONST_ANI_DEATH,
        area           = createCombatArea(AREA_SQUAREWAVE7),
    },

    PhanstamDrown = {
        damageType   = Combat.DamageType.Drown,
        impactEffect = CONST_ME_MAGIC_BLUE,
        area         = createCombatArea(AREA_SQUAREWAVE7),
    },

    QuaraConstrictorElectrify = {
        damageType     = Combat.DamageType.Energy,
        impactEffect   = CONST_ME_ENERGYHIT,
        distanceEffect = CONST_ANI_ENERGY,
    },

    QuaraConstrictorFreeze = {
        damageType   = Combat.DamageType.Ice,
        impactEffect = CONST_ME_GREEN_RINGS,
        area         = createCombatArea(AREA_SQUARE1X1),
    },

    SeaSerpentDrown = {
        damageType   = Combat.DamageType.Drown,
        impactEffect = CONST_ME_WATERSPLASH,
        area         = createCombatArea(AREA_SQUARE1X1),
    },

    SouleaterDrown = {
        damageType   = Combat.DamageType.Drown,
        impactEffect = CONST_ME_MORTAREA,
        area         = createCombatArea(AREA_CIRCLE2X2),
    },

    SpectreDrown = {
        damageType   = Combat.DamageType.Drown,
        impactEffect = CONST_ME_MAGIC_GREEN,
        area         = createCombatArea(AREA_CIRCLE3X3),
    },

    UndeadDragonCurse = {
        damageType     = Combat.DamageType.Death,
        impactEffect   = CONST_ME_SMALLCLOUDS,
        distanceEffect = CONST_ANI_DEATH,
        area           = createCombatArea(AREA_SQUAREWAVE7),
    },

    VulcongraSoulfire = {
        damageType   = Combat.DamageType.Fire,
        impactEffect = CONST_ME_HITBYFIRE,
        area         = createCombatArea(AREA_SQUARE1X1),
    },

    WarGolemElectrify = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_ENERGYHIT,
    },

    YoungSeaSerpentDrown = {
        damageType   = Combat.DamageType.Drown,
        impactEffect = CONST_ME_WATERSPLASH,
        area         = createCombatArea(AREA_SQUARE1X1),
    },

    -- Custom-area attacks
    WaveT = {
        damageType   = Combat.DamageType.Earth,
        impactEffect = CONST_ME_GREEN_RINGS,
        area         = _waveTArea,
    },

    ExplosionWave = {
        damageType   = Combat.DamageType.Physical,
        impactEffect = CONST_ME_EXPLOSIONHIT,
        area         = _explosionWaveArea,
    },

    LloydWave1 = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_PURPLECHAIN,
        area         = _lloydWave1Area,
    },

    LloydWave2 = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_PURPLECHAIN,
        area         = _lloydWave2Area,
    },

    EnergyPulseExplosion = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_ENERGYAREA,
        area         = _energyPulseArea,
    },

    FerumbrasSoulfire = {
        damageType     = Combat.DamageType.Fire,
        impactEffect   = CONST_ME_FIREAREA,
        distanceEffect = CONST_ANI_FIRE,
        area           = _ferumbrasSoulfireArea,
        condition      = _ferumbrasSoulfireCondition,
    },

    FerumbrasElectrify = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_ENERGYHIT,
        area         = _ferumbrasElectrifyArea,
    },

    -- Spells with setCallback — base props only; callback wired in spell file
    RemorselessWave = {
        damageType   = Combat.DamageType.Death,
        impactEffect = CONST_ME_BLACKSMOKE,
        area         = _remorselessWaveArea,
    },

    SourceOfCorruptionWave = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_PURPLEENERGY,
        area         = _sourceOfCorruptionArea,
    },

    FreedSoulSpell = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_PURPLEENERGY,
        area         = _freedSoulArea,
    },

    FrozenMinionWave = {
        impactEffect = CONST_ME_POFF,
        aggressive   = false,
        area         = _frozenMinionWaveArea,
    },

    FrozenMinionBeam = {
        impactEffect = CONST_ME_POFF,
        aggressive   = false,
        area         = createCombatArea(AREA_BEAM7),
    },

    FrozenMinionHeal = {
        impactEffect = CONST_ME_MAGIC_BLUE,
        aggressive   = false,
        area         = createCombatArea(AREA_CIRCLE2X2),
    },

    IcicleHeal = {
        impactEffect = CONST_ME_MAGIC_BLUE,
        aggressive   = false,
        area         = createCombatArea(AREA_CIRCLE3X3),
    },

    HealMonsters = {
        impactEffect = CONST_ME_MAGIC_BLUE,
        aggressive   = false,
        area         = createCombatArea(AREA_CIRCLE3X3),
    },

    HealMonsters9x9 = {
        impactEffect = CONST_ME_MAGIC_BLUE,
        aggressive   = false,
        area         = createCombatArea(AREA_CIRCLE6X6),
    },

    AggressiveLavaBomb = {
        damageType   = Combat.DamageType.Fire,
        impactEffect = CONST_ME_HITBYFIRE,
        area         = _aggressiveLavaBombArea,
    },

    EmberBeastBeam = {
        damageType   = Combat.DamageType.Fire,
        impactEffect = CONST_ME_EXPLOSIONHIT,
        area         = _emberBeastBeamArea,
    },

    EmberBeastArea = {
        damageType   = Combat.DamageType.Fire,
        impactEffect = CONST_ME_EXPLOSIONHIT,
        area         = _emberBeastAreaArea,
    },

    -- Combat with embedded condition
    PhysicalExplosion = {
        damageType   = Combat.DamageType.Physical,
        impactEffect = 6,
        area         = createCombatArea(AREA_SQUARE1X1),
        condition    = _physicalExplosionCondition,
    },

    -- Summon challenge (setCallback in spell file)
    SummonChallenge = {
        impactEffect = CONST_ME_MAGIC_BLUE,
        area         = createCombatArea(AREA_CIRCLE2X2),
    },

    -- Hirintror freeze (embedded condition)
    HirintrorFreeze = {
        impactEffect = CONST_ME_ICETORNADO,
        area         = createCombatArea({
            {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
            {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
            {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
            {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
            {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
            {1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1},
            {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
            {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
            {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
            {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
            {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
        }),
        condition    = _hirintrorFreezeCondition,
    },

    -- Pixie (embedded CONDITION_ATTRIBUTES)
    PixieSkillReducer = {
        impactEffect = CONST_ME_FAEEXPLOSION,
        area         = createCombatArea(AREA_CIRCLE2X2),
        condition    = _pixieCondition,
    },

    -- Skill reducers — only visual/area props; parameter tables stay in spell files
    BarbarianBrutetamerSkillReducer = {
        distanceEffect = CONST_ANI_SNOWBALL,
        impactEffect   = CONST_ME_POFF,
    },

    BetrayedWraithSkillReducer = {
        impactEffect = CONST_ME_YELLOW_RINGS,
        area         = createCombatArea(AREA_SQUAREWAVE5),
    },

    CliffStriderSkillReducer = {
        impactEffect = CONST_ME_MAGIC_RED,
        area         = createCombatArea(AREA_CIRCLE2X2),
    },

    DarkTorturerSkillReducer = {
        impactEffect = CONST_ME_SOUND_PURPLE,
        area         = createCombatArea(AREA_SQUAREWAVE6),
    },

    DeeplingSpellsingerSkillReducer = {
        impactEffect   = CONST_ME_STUN,
        distanceEffect = CONST_ANI_EXPLOSION,
        area           = createCombatArea(AREA_BEAM1),
    },

    DemonOutcastSkillReducer = {
        distanceEffect = CONST_ANI_FLASHARROW,
        area           = createCombatArea(AREA_BEAM1),
    },

    DiabolicImpSkillReducer = {
        distanceEffect = CONST_ANI_ENERGY,
        area           = createCombatArea(AREA_BEAM1),
    },

    DipthrahSkillReducer = {
        impactEffect = CONST_ME_HOLYAREA,
        area         = createCombatArea(AREA_CIRCLE3X3),
    },

    EnslavedDwarfSkillReducer1 = {
        impactEffect = CONST_ME_MAGIC_RED,
        area         = createCombatArea(AREA_CIRCLE2X2),
    },

    EnslavedDwarfSkillReducer2 = {
        impactEffect = CONST_ME_HITAREA,
        area         = createCombatArea(AREA_CROSS1X1),
    },

    FeversleepSkillReducer = {
        impactEffect = CONST_ME_STUN,
        area         = createCombatArea(AREA_CIRCLE6X6),
    },

    ForestFurySkillReducer = {
        impactEffect   = CONST_ME_MAGIC_BLUE,
        distanceEffect = CONST_ANI_LARGEROCK,
        area           = createCombatArea(AREA_CIRCLE2X2),
    },

    FurySkillReducer = {
        impactEffect = CONST_ME_SOUND_YELLOW,
        area         = createCombatArea(AREA_CIRCLE3X3),
    },

    IceGolemSkillReducer = {
        impactEffect = CONST_ME_HITAREA,
        area         = createCombatArea(AREA_SQUARE1X1),
    },

    PirateCorsairSkillReducer = {
        impactEffect = CONST_ME_SOUND_PURPLE,
        area         = createCombatArea(AREA_BEAM1),
    },

    ShockHeadSkillReducer1 = {
        impactEffect   = CONST_ME_GROUNDSHAKER,
        distanceEffect = CONST_ANI_EXPLOSION,
        area           = createCombatArea(AREA_CIRCLE2X2),
    },

    ShockHeadSkillReducer2 = {
        impactEffect = CONST_ME_STUN,
        area         = createCombatArea(AREA_CIRCLE6X6),
    },

    SilencerSkillReducer = {
        impactEffect   = CONST_ME_ENERGYHIT,
        distanceEffect = CONST_ANI_ENERGY,
        area           = createCombatArea(AREA_CIRCLE2X2),
    },

    StamporSkillReducer = {
        impactEffect   = CONST_ME_SMALLPLANTS,
        distanceEffect = CONST_ANI_SMALLEARTH,
        area           = createCombatArea(AREA_BEAM1),
    },

    WarlockSkillReducer = {
        impactEffect   = CONST_ME_ICEAREA,
        distanceEffect = CONST_ANI_ICE,
        area           = createCombatArea(AREA_BEAM1),
    },

    WarGolemSkillReducer = {
        impactEffect = CONST_ME_STUN,
        area         = createCombatArea(AREA_BEAM8),
    },

    WerewolfSkillReducer = {
        impactEffect = CONST_ME_DRAWBLOOD,
        area         = createCombatArea(AREA_BEAM1),
    },

    -- ported from Canary by harness/build_canary_monster_spells.py
    AftershockWave = {
        damageType   = Combat.DamageType.Physical,
        impactEffect = CONST_ME_TELEPORT,
        area         = createCombatArea(AREA_WAVE11),
    },

    AnomalyWave = {
        damageType   = Combat.DamageType.Physical,
        impactEffect = CONST_ME_ENERGYAREA,
        area         = createCombatArea(AREA_WAVE12),
    },

    Arachnophobicawavedice = {
        damageType   = Combat.DamageType.Water,
        impactEffect = CONST_ME_CRAPS,
    },

    Arachnophobicawaveenergy = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_ENERGYAREA,
    },

    BigDeathWave = {
        damageType   = Combat.DamageType.Death,
        impactEffect = CONST_ME_MORTAREA,
        area         = createCombatArea(AREA_WAVE11),
    },

    BigLifedrainWave = {
        damageType   = Combat.DamageType.LifeDrain,
        impactEffect = CONST_ME_MAGIC_RED,
        area         = createCombatArea(AREA_WAVE11),
    },

    BlastRing = {
        damageType   = Combat.DamageType.Fire,
        impactEffect = CONST_ME_YELLOWSMOKE,
        area         = createCombatArea(AREA_RING1_BURST3),
    },

    BoulderRing = {
        damageType   = Combat.DamageType.Earth,
        impactEffect = CONST_ME_STONE_STORM,
        area         = createCombatArea(AREA_RING1_BURST3),
    },

    BreachBroodReducer = {
        impactEffect   = CONST_ME_MAGIC_RED,
        distanceEffect = CONST_ANI_BURSTARROW,
        area           = createCombatArea(AREA_SQUARE1X1),
    },

    BulltaurAvalanche = {
        damageType   = Combat.DamageType.Ice,
        impactEffect = CONST_ME_ICEAREA,
        area         = _bulltaurAvalancheArea,
    },

    Bulltaurewave = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_PURPLEENERGY,
        area         = _bulltaurewaveArea,
    },

    BulltaurExplosion = {
        damageType   = Combat.DamageType.Holy,
        impactEffect = CONST_ME_HOLYDAMAGE,
        area         = _bulltaurExplosionArea,
    },

    Firering = {
        damageType   = Combat.DamageType.Fire,
        impactEffect = CONST_ME_FIREATTACK,
        area         = _fireringArea,
    },

    Firex = {
        damageType   = Combat.DamageType.Fire,
        impactEffect = CONST_ME_FIREATTACK,
        area         = _firexArea,
    },

    ChargedEnergyElementalElectrify = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_BLOCKHIT,
        area         = createCombatArea(AREA_CIRCLE3X3),
    },

    CorymVanguardWave = {
        damageType   = Combat.DamageType.Earth,
        impactEffect = CONST_ME_GREEN_RINGS,
        area         = _corymVanguardWaveArea,
    },

    DeathBeam = {
        damageType   = Combat.DamageType.Death,
        impactEffect = CONST_ME_MORTAREA,
        area         = createCombatArea(AREA_BEAM7),
    },

    DemonParalyze = {
        impactEffect   = CONST_ME_SMALLCLOUDS,
        distanceEffect = CONST_ANI_SUDDENDEATH,
    },

    DestructionSummon = {
        impactEffect = CONST_ME_NONE,
        area         = createCombatArea(AREA_CIRCLE2X2),
    },

    DevourerDeathWave = {
        damageType   = Combat.DamageType.Death,
        impactEffect = CONST_ME_MORTAREA,
    },

    DreadIntruderWave = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_PURPLEENERGY,
        area         = createCombatArea(AREA_SQUAREWAVE6),
    },

    DreadRcircle = {
        damageType   = Combat.DamageType.LifeDrain,
        impactEffect = CONST_ME_DRAWBLOOD,
        area         = _dreadRcircleArea,
    },

    EmeraldTortoiseLargeRing = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_BLUE_ENERGY_SPARK,
        area         = _emeraldTortoiseLargeRingArea,
    },

    EmeraldTortoiseSmallExplosion = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_BLUE_ENERGY_SPARK,
        area         = _emeraldTortoiseSmallExplosionArea,
    },

    EmeraldTortoiseSmallRing = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_BLUE_ENERGY_SPARK,
        area         = _emeraldTortoiseSmallRingArea,
    },

    EnergyRing = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_ENERGYHIT,
        area         = createCombatArea(AREA_RING1_BURST3),
    },

    FeroxaSummon = {
        impactEffect = CONST_ME_TELEPORT,
        area         = _feroxaSummonArea,
    },

    FrazzlemawParalyze = {
        impactEffect = CONST_ME_MAGIC_RED,
        area         = _frazzlemawParalyzeArea,
    },

    GhastlyDragonParalyze = {
        impactEffect = CONST_ME_BATS,
    },

    GhastlyDragonWave = {
        damageType   = Combat.DamageType.Death,
        impactEffect = CONST_ME_LOSEENERGY,
        area         = _ghastlyDragonWaveArea,
    },

    GirtabliluPoisonWave = {
        damageType   = Combat.DamageType.Earth,
        impactEffect = CONST_ME_HITBYPOISON,
        area         = _girtabliluPoisonWaveArea,
    },

    GorerillaLargeRing = {
        damageType   = Combat.DamageType.Physical,
        impactEffect = CONST_ME_EXPLOSIONAREA,
        area         = _gorerillaLargeRingArea,
    },

    HauntedTreelingParalyze = {
        impactEffect = CONST_ME_SMALLPLANTS,
        area         = _hauntedTreelingParalyzeArea,
    },

    HeadpeckerExplosion = {
        damageType   = Combat.DamageType.Earth,
        impactEffect = CONST_ME_HITBYPOISON,
        area         = _headpeckerExplosionArea,
    },

    HirintrorSummon = {
        impactEffect = CONST_ME_NONE,
        area         = createCombatArea(AREA_CIRCLE3X3),
    },

    IceGolemParalyze = {
        impactEffect = CONST_ME_ICEAREA,
        area         = _iceGolemParalyzeArea,
    },

    Iksyapunacwave = {
        damageType   = Combat.DamageType.Physical,
        impactEffect = CONST_ME_GROUNDSHAKER,
        area         = _iksyapunacwaveArea,
    },

    KatexDeatht = {
        damageType   = Combat.DamageType.Death,
        impactEffect = CONST_ME_MORTAREA,
        area         = _katexDeathtArea,
    },

    LavafungusRing = {
        damageType   = Combat.DamageType.Fire,
        impactEffect = CONST_ME_EXPLOSIONHIT,
        area         = _lavafungusRingArea,
    },

    LavafungusXWave = {
        damageType   = Combat.DamageType.Fire,
        impactEffect = CONST_ME_EXPLOSIONHIT,
        area         = _lavafungusXWaveArea,
    },

    LloydWave = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = 179,
        area         = _lloydWaveArea,
    },

    LloydWave2 = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = 179,
        area         = _lloydWave2Area,
    },

    LloydWave3 = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = 179,
        area         = _lloydWave3Area,
    },

    Makarawatersplash = {
        damageType   = Combat.DamageType.Ice,
        impactEffect = CONST_ME_WATERSPLASH,
    },

    MantosaurusRing = {
        damageType   = Combat.DamageType.Earth,
        impactEffect = CONST_ME_HITBYPOISON,
        area         = _mantosaurusRingArea,
    },

    MedusaParalyze = {
        impactEffect   = CONST_ME_POFF,
        distanceEffect = CONST_ANI_EARTH,
        area           = _medusaParalyzeArea,
    },

    EarthBeammy = {
        damageType   = Combat.DamageType.Earth,
        impactEffect = CONST_ME_SMALLPLANTS,
        area         = _earthBeammyArea,
    },

    ManaLeechmy = {
        damageType   = Combat.DamageType.ManaDrain,
        impactEffect = CONST_ME_HITBYPOISON,
        area         = createCombatArea(AREA_CIRCLE1X1),
    },

    MercurialMenaceRing = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_PURPLESMOKE,
        area         = _mercurialMenaceRingArea,
    },

    Mitmahseekwave = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_PURPLESMOKE,
        area         = _mitmahseekwaveArea,
    },

    MutatedRatParalyze = {
        impactEffect   = CONST_ME_POISONAREA,
        distanceEffect = CONST_ANI_POISON,
    },

    Nagadeathattack = {
        damageType     = Combat.DamageType.Death,
        impactEffect   = CONST_ME_MORTAREA,
        distanceEffect = CONST_ANI_DEATH,
    },

    Nagadeath = {
        damageType   = Combat.DamageType.Death,
        impactEffect = CONST_ME_MORTAREA,
    },

    NighthunterWave = {
        damageType   = Combat.DamageType.Earth,
        impactEffect = CONST_ME_HITBYPOISON,
        area         = createCombatArea(AREA_WAVE),
    },

    NightstalkerParalyze = {
        impactEffect   = CONST_ME_SLEEP,
        distanceEffect = CONST_ANI_SUDDENDEATH,
    },

    NoxiousRipptorWave = {
        damageType   = Combat.DamageType.Earth,
        impactEffect = CONST_ME_HITBYPOISON,
        area         = createCombatArea(AREA_WAVE),
    },

    OmrafirSummon = {
        impactEffect = CONST_ME_NONE,
        area         = createCombatArea(AREA_CIRCLE3X3),
    },

    OmrafirWave = {
        damageType   = Combat.DamageType.Fire,
        impactEffect = CONST_ME_EXPLOSIONHIT,
        area         = _omrafirWaveArea,
    },

    OutburstExplode = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_PURPLEENERGY,
        area         = _outburstExplodeArea,
    },

    Targetfirering = {
        damageType   = Combat.DamageType.Fire,
        impactEffect = CONST_ME_EXPLOSIONHIT,
        area         = _targetfireringArea,
    },

    Quaracrossdeath = {
        damageType   = Combat.DamageType.LifeDrain,
        impactEffect = CONST_ME_MORTAREA,
        area         = _quaracrossdeathArea,
    },

    Quarasmokedeath = {
        damageType   = Combat.DamageType.Death,
        impactEffect = CONST_ME_BLACKSMOKE,
        area         = _quarasmokedeathArea,
    },

    Quararaidershoot = {
        damageType     = Combat.DamageType.Death,
        impactEffect   = CONST_ME_MORTAREA,
        distanceEffect = CONST_ANI_SNOWBALL,
        area           = createCombatArea(AREA_CIRCLE1X1),
    },

    Quaraseamonster = {
        damageType   = Combat.DamageType.Ice,
        impactEffect = CONST_ME_WATERCREATURE,
        area         = _quaraseamonsterArea,
    },

    Quarawatersplash = {
        damageType   = Combat.DamageType.Ice,
        impactEffect = CONST_ME_WATERSPLASH,
        area         = _quarawatersplashArea,
    },

    RealityReaverWave = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_ENERGYHIT,
        area         = createCombatArea(AREA_SQUAREWAVE7),
    },

    RotElementalParalyze = {
        impactEffect = CONST_ME_SOUND_GREEN,
        area         = createCombatArea(AREA_CIRCLE2X2),
    },

    Rotthligexplo = {
        damageType   = Combat.DamageType.Physical,
        impactEffect = CONST_ME_EXPLOSIONAREA,
        area         = _rotthligexploArea,
    },

    Rotthligulus = {
        damageType   = Combat.DamageType.Physical,
        impactEffect = CONST_ME_BLOCKHIT,
        area         = _rotthligulusArea,
    },

    Rotthligholyulus = {
        damageType   = Combat.DamageType.Holy,
        impactEffect = CONST_ME_HOLYAREA,
        area         = _rotthligholyulusArea,
    },

    SabretoothWave = {
        damageType   = Combat.DamageType.Fire,
        impactEffect = CONST_ME_HITBYFIRE,
        area         = _sabretoothWaveArea,
    },

    SaplingExplode = {
        damageType   = Combat.DamageType.Fire,
        impactEffect = CONST_ME_FIREAREA,
        area         = createCombatArea(AREA_CIRCLE3X3),
    },

    ShlorgParalyze = {
        impactEffect   = CONST_ME_SMALLPLANTS,
        distanceEffect = CONST_ANI_POISON,
        area           = createCombatArea(AREA_SQUARE1X1),
    },

    LleechWavet = {
        damageType   = Combat.DamageType.LifeDrain,
        impactEffect = CONST_ME_DRAWBLOOD,
        area         = _lleechWavetArea,
    },

    SulphurSpouterWave = {
        damageType   = Combat.DamageType.Death,
        impactEffect = CONST_ME_MORTAREA,
        area         = createCombatArea(AREA_WAVE),
    },

    TenebrisSummon = {
        impactEffect = CONST_ME_MAGIC_RED,
    },

    EnergyWavet = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_ENERGYHIT,
        area         = _energyWavetArea,
    },

    TheWelterParalyze = {
        impactEffect = CONST_ME_MAGIC_GREEN,
        area         = _theWelterParalyzeArea,
    },

    ThornSummon = {
        impactEffect = CONST_ME_MAGIC_RED,
    },

    ThunderstormRing = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_BIGCLOUDS,
        area         = createCombatArea(AREA_RING1_BURST3),
    },

    TyrnElectrify = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_SMOKE,
        area         = _tyrnElectrifyArea,
    },

    UnchainedFireExplosion = {
        damageType   = Combat.DamageType.Fire,
        impactEffect = CONST_ME_MAGIC_RED,
        area         = _unchainedFireExplosionArea,
    },

    UndertakerSquareExplosion = {
        damageType   = Combat.DamageType.Earth,
        impactEffect = CONST_ME_HITBYPOISON,
        area         = _undertakerSquareExplosionArea,
    },

    Urmahlulluring = {
        damageType   = Combat.DamageType.Fire,
        impactEffect = CONST_ME_FIREAREA,
        area         = _urmahlulluringArea,
    },

    WardenRing = {
        damageType   = Combat.DamageType.Earth,
        impactEffect = CONST_ME_GROUNDSHAKER,
        area         = _wardenRingArea,
    },

    WardenX = {
        damageType   = Combat.DamageType.Earth,
        impactEffect = CONST_ME_GROUNDSHAKER,
        area         = _wardenXArea,
    },

    WerecrocodileFireRing = {
        damageType   = Combat.DamageType.Fire,
        impactEffect = CONST_ME_HITBYFIRE,
        area         = _werecrocodileFireRingArea,
    },

    WerelionWave = {
        damageType   = Combat.DamageType.Physical,
        impactEffect = CONST_ME_HITAREA,
        area         = _werelionWaveArea,
    },

    WhitePaleParalyze = {
        impactEffect = CONST_ME_HITAREA,
        area         = _whitePaleParalyzeArea,
    },

    WhitePaleSummon = {
        impactEffect = CONST_ME_GROUNDSHAKER,
        area         = _whitePaleSummonArea,
    },

    WhiteShadeParalyze = {
        impactEffect = CONST_ME_HITAREA,
        area         = createCombatArea(AREA_CIRCLE2X2),
    },

    WyrmWave = {
        damageType   = Combat.DamageType.Energy,
        impactEffect = CONST_ME_PURPLEENERGY,
        area         = _wyrmWaveArea,
    },
}
