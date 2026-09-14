local config = {
	[11258] = {blessId = 4, text = 'The Spark of the Phoenix'},
	[11259] = {blessId = 2, text = 'The Embrace of Tibia'},
	[11260] = {blessId = 1, text = 'The Spiritual Shielding'},
	[11261] = {blessId = 3, text = 'The Fire of the Suns'},
	[11262] = {blessId = 5, text = 'The Wisdom of Solitude'}
}

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local useItem = config[item.itemid]
	if not useItem then
		return true
	end

	if player:hasBlessing(useItem.blessId) then
		player:say('You already possess this blessing.', TALKTYPE_MONSTER_SAY)
		return true
	end

	player:addBlessing(useItem.blessId)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, useItem.text .. ' protects you.')
	player:getPosition():sendMagicEffect(CONST_ME_LOSEENERGY)
	item:remove(1)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(11258, 11259, 11260, 11261, 11262)
realmapEvent1:register()
