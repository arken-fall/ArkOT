local function onUse(player, item, fromPosition, target, toPosition, isHotkey)

	if player:getStorageValue(Storage.thievesGuild.Mission06) == 3 then
		player:say('You slip through the door', TALKTYPE_MONSTER_SAY)
		player:teleportTo(Position(32359, 32786, 6))
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(12505)
realmapEvent1:register()
