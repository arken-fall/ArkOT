local combat = {}

for i = 130, 150 do
	combat[i] = Combat()
	combat[i]:setImpactEffect(CONST_ME_MAGIC_RED)

	local condition = Condition(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_TICKS, 6000)
	condition:setParameter(CONDITION_PARAM_SKILL_DEFENSEPERCENT, i)

	local arr = {
		{ 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0 },
		{ 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0 },
		{ 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
		{ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
		{ 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1 },
		{ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0 },
		{ 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
		{ 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0 },
		{ 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0 },
		{ 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 },
	}

	local area = createCombatArea(arr)
	combat[i]:setArea(area)
	combat[i]:addCondition(condition)
end

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat[math.random(130, 150)]:execute(creature, variant)
end

spell:name("Cults of Tibia Armor Buff")
spell:words("#####456")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:needDirection(true)
spell:register()
