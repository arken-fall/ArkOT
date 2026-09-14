local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 5114 then
		return true
	end

	if player:getStorageValue(Storage.TheInquisition.Questline) == 18 then
		player:teleportTo(toPosition, true)
		item:transform(5115)
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(1004)
realmapEvent1:register()
