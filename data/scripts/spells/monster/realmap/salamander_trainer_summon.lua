-- the salamander trainer calls its trained salamander, ported from the real-map pack
local combat = Combat()
combat:setImpactEffect(CONST_ME_SOUND_RED)
combat:setArea(createCombatArea(AREA_CROSS1X1))

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	if #creature:getSummons() < 1 then
		local salamander = Game.createMonster("Troll-Trained Salamander", creature:getPosition())
		if not salamander then
			return false
		end
		salamander:setMaster(creature)
	end
	return combat:execute(creature, variant)
end

spell:name("salamander trainer summon")
spell:words("##374")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
