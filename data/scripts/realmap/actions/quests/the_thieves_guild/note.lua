local notePos = Position(32598, 32381, 10)

local function removeNote(position)
	local noteItem = Tile(position):getItemById(8700)
	if noteItem then
		noteItem:remove()
	end
end

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 12509 then
		return false
	end

	if player:getStorageValue(Storage.thievesGuild.Mission08) == 1 then
		player:removeItem(8701, 1)
		Game.createItem(8700, 1, notePos)
		player:setStorageValue(Storage.thievesGuild.Mission08, 2)
		addEvent(removeNote, 5 * 60 * 1000, notePos)
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(8701)
realmapEvent1:register()
