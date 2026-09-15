local combat = {}

for i = 40, 55 do
	combat[i] = Combat()
	combat[i]:setImpactEffect(CONST_ME_SOUND_WHITE)

	local condition = Condition(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_TICKS, 12000)
	condition:setParameter(CONDITION_PARAM_SKILL_MELEEPERCENT, i)
	condition:setParameter(CONDITION_PARAM_SKILL_DEFENSEPERCENT, i)

	local arr = {
		{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
		{ 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
		{ 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
		{ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
		{ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
		{ 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1 },
		{ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
		{ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
		{ 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
		{ 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
		{ 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
	}

	local area = createCombatArea(arr)
	combat[i]:setArea(area)
	combat[i]:addCondition(condition)
end

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat[math.random(40, 55)]:execute(creature, variant)
end

spell:name("tyrn skill reducer")
spell:words("###344")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
