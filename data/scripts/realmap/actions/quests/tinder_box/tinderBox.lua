-- <action itemid="22728" script="tinderBox.lua" />

local config = {
	item = 22728,
	target = 22727,
	reward = 22726,
}

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)

	if item.itemid == config.item and target.itemid == config.target then
		item:remove(1)
		target:remove(1)
		player:addItem(config.reward, 1)
	end
	
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(22728)
realmapEvent1:register()
