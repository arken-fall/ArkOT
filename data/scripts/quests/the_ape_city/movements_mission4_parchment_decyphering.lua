local mission4ParchmentDecyphering = ItemEvent()

function mission4ParchmentDecyphering.onStepOn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.Quest.U7_6.TheApeCity.Questline) == 7 and player:getStorageValue(Storage.Quest.U7_6.TheApeCity.ParchmentDecyphering) ~= 1 then
		player:setStorageValue(Storage.Quest.U7_6.TheApeCity.ParchmentDecyphering, 1)
	end

	player:say("!-! -O- I_I (/( --I Morgathla", TALKTYPE_MONSTER_SAY)
	return true
end

mission4ParchmentDecyphering:type("stepon")
mission4ParchmentDecyphering:aid(12124)
mission4ParchmentDecyphering:register()
