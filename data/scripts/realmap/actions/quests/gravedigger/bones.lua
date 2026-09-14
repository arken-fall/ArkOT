local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4633 then
		return false
	end

	if player:getStorageValue(Storage.GravediggerOfDrefia.Mission17) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission19) < 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission19, 1)
		player:addItem(21406, 1)
		item:remove()
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(21407)
realmapEvent1:register()
