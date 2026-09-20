-- RETIRED 2026-09-20: every id this script claimed is already claimed by a script
-- written for this map, which registers first and therefore wins. It has never
-- run here. Disabled by the leading '#', not deleted, so the 10.98 pack's
-- version of this furniture stays readable.
--
local blessings = {
	{id = 5, name = 'Wisdom of Solitude'},
	{id = 4, name = 'Spark of the Phoenix'},
	{id = 3, name = 'Fire of the Suns'},
	{id = 1, name = 'Spiritual Shielding'},
	{id = 2, name = 'Embrace of Tibia'},
	{id = 6, name = 'Twist of Fate'}
}

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local result, bless = 'Received blessings:'
	for i = 1, #blessings do
		bless = blessings[i]
		result = player:hasBlessing(bless.id) and result .. '\n' .. bless.name or result
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 20 > result:len() and 'No blessings received.' or result)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(6561, 12424)
realmapEvent1:register()
