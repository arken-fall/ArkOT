local function onUse(player, item, fromPosition, itemEx, toPosition, isHotkey)

	if not player:isPzLocked() then
		player:setSex(player:getSex() == 1 and 0 or 1)
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, 'You successfully changed sex!')
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		item:remove(1)
		player:save()
		player:remove()
	end

	return true
end 

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(13030)
realmapEvent1:register()
