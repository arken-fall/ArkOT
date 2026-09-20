-- RETIRED 2026-09-20: every id this script claimed is already claimed by a script
-- written for this map, which registers first and therefore wins. It has never
-- run here. Disabled by the leading '#', not deleted, so the 10.98 pack's
-- version of this furniture stays readable.
--
local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 1 or target.type ~= THING_TYPE_PLAYER then
		return false
	end

	local text = ""
	if math.random(100) <= 5 then
		text = "You concentrate on your victim and hit the needle in the doll."
		player:addAchievement("Dark Voodoo Priest")
		toPosition:sendMagicEffect(CONST_ME_DRAWBLOOD, player)
	else
		text = "You concentrate on your victim, hit the needle in the doll.......but nothing happens."
	end

	player:say(text, TALKTYPE_MONSTER_SAY, false, player)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(3955)
realmapEvent1:register()
