-- The five promotion scrolls: each one read adds points to the wheel of destiny.
local scrolls = ItemEvent()

function scrolls.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player:unlockWheelScroll(item:getId()) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have already studied this scroll.")
		return true
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have studied the scroll and gained wheel of destiny points.")
	item:remove(1)
	return true
end

scrolls:type("use")
for _, appearance in ipairs({ 43946, 43947, 43948, 43949, 43950 }) do
	local itemId = Game.getItemIdByClientId(appearance)
	if itemId and itemId > 0 then
		scrolls:id(itemId)
	end
end
scrolls:register()
