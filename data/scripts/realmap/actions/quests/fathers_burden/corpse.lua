local config = {
	[12545] = {itemId = 12506, storage = Storage.FathersBurdenQuest.Corpse.Scale, text = 'Glitterscale\'s scale.'},
	[12546] = {itemId = 12504, storage = Storage.FathersBurdenQuest.Corpse.Sinew, text = 'Heoni\'s sinew'}
}

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local corpse = config[item.itemid]
	if not corpse then
		return true
	end

	if player:getStorageValue(corpse.storage) == 1 then
		return false
	end

	player:addItem(corpse.itemId, 1)
	player:setStorageValue(corpse.storage, 1)
	player:say('You acquired ' .. corpse.text, TALKTYPE_MONSTER_SAY)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(12545, 12546)
realmapEvent1:register()
