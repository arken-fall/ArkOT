local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 4861 then
		return false
	end

	if player:getStorageValue(Storage.TheApeCity.Questline) ~= 17
			or player:getStorageValue(Storage.TheApeCity.SnakeDestroyer) == 1 then
		return false
	end

	player:setStorageValue(Storage.TheApeCity.SnakeDestroyer, 1)
	item:remove()
	target:transform(4862)
	target:decay()
	toPosition:sendMagicEffect(CONST_ME_FIREAREA)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(4846)
realmapEvent1:register()
