-- RETIRED 2026-09-20: every id this script claimed is already claimed by a script
-- written for this map, which registers first and therefore wins. It has never
-- run here. Disabled by the leading '#', not deleted, so the 10.98 pack's
-- version of this furniture stays readable.
--
local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local dicePosition = item:getPosition()
	local value = math.random(6)
	local isInGhostMode = player:isInGhostMode()

	dicePosition:sendMagicEffect(CONST_ME_CRAPS, isInGhostMode and player)

	local spectators = Game.getSpectators(dicePosition, false, true, 3, 3)
	for i = 1, #spectators do
		player:say(player:getName() .. " rolled a " .. value .. ".", TALKTYPE_MONSTER_SAY, isInGhostMode, spectators[i], dicePosition)
	end

	item:transform(5791 + value)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(5792, 5793, 5794, 5795, 5796, 5797)
realmapEvent1:register()
