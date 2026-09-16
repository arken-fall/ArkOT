local gnomeOrdnance = ItemEvent()

function gnomeOrdnance.onStepOn(creature, position, fromPosition, toPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Ordnance) == 1 then
		player:setStorageValue(Storage.Quest.U11_50.DangerousDepths.Gnomes.Ordnance, 2)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You started an escort, get everyone to safety!")
	end
	return true
end

gnomeOrdnance:type("stepon")
gnomeOrdnance:aid(57241)
gnomeOrdnance:register()
