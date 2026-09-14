-- the renegade knight's bleeding strike, ported from the real-map pack
local combat = Combat()
combat:setDamageType(Combat.DamageType.Physical)
combat:setImpactEffect(CONST_ME_EXPLOSIONHIT)
combat:setArea(createCombatArea(AREA_SQUARE1X1))

local condition = Condition(CONDITION_BLEEDING)
condition:setParameter(CONDITION_PARAM_DELAYED, 1)
condition:addDamage(3, 10000, -25)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("renegade knight")
spell:words("##400")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
