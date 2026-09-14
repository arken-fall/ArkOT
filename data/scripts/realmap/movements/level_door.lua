local function onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	if creature:getLevel() < item.actionid - 1000 then
		creature:sendTextMessage(MESSAGE_INFO_DESCR, "Only the worthy may pass.")
		creature:teleportTo(fromPosition, true)
		return false
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("stepon")
realmapEvent1.onStepOn = onStepIn
realmapEvent1:id(1228, 1230, 1246, 1248, 1260, 1262, 3541, 3550, 5104, 5113, 5122, 5131, 5293, 5295, 6207, 6209, 6264, 6266, 6897, 6906, 7039, 7048, 8556, 8558, 9180, 9182, 9282, 9284, 10283, 10285, 10474, 10483, 10781, 10790, 12096, 12103, 12196, 12205, 19846, 19855, 19986, 19995, 20279, 20288)
realmapEvent1:register()
