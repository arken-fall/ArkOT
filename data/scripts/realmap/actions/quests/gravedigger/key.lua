local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4639 then
		return false
	end

	if player:getStorageValue(Storage.GravediggerOfDrefia.Mission31) == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '<swoosh> <oomph> <cough, cough>')
		item:remove(1)
		Tile(Position(33071, 32442, 11)):getItemById(9624):transform(9625)
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(21482)
realmapEvent1:register()
