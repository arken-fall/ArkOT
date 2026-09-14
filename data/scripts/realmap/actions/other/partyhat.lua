local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local slot = player:getSlotItem(CONST_SLOT_HEAD)
	if slot and item.uid == slot.uid then
		player:addAchievementProgress('Party Animal', 200)
		player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
		return true
	end

	return false
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(6578)
realmapEvent1:register()
