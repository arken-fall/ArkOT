local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 12505 then
		return false
	end

	if player:getStorageValue(Storage.thievesGuild.Mission06) == 2 then
		player:removeItem(8762, 1)
		player:say('In your haste you break the key while slipping in.', TALKTYPE_MONSTER_SAY)
		player:teleportTo(Position(32359, 32788, 6))
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(8762)
realmapEvent1:register()
