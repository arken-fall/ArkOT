local function onUse(cid, item, fromPosition, itemEx, toPosition)
local p = {x = 33672, y = 31884, z = 5} -- where to tp to 33672, 31884, 5
if(getPlayerStorageValue(cid, 10050) < 18) then
	doTeleportThing(cid,p)
	setPlayerStorageValue(cid, 10050, 18)
	doSendMagicEffect(p,10)
	doCreatureSay(cid, "Congratulations, you have completed the quest, report your mission to the NPC to win the outfit.", TALKTYPE_ORANGE_1)
	else 
	doTeleportThing(cid,p)
	doSendMagicEffect(p,10)	
	doCreatureSay(cid, "You've been teleported.", TALKTYPE_ORANGE_1)
return true
end

end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(19074)
realmapEvent1:register()
