local function onUse(cid, item, itemEx)
if(getPlayerStorageValue(cid, 932119) < 1) then

doPlayerAddItem(cid, 11402, 1)
setPlayerStorageValue(cid, 932119, 1)
doSendMagicEffect(tilepos1,45)
	doCreatureSay(cid, "You succesfully took a Daram Island reward!", TALKTYPE_ORANGE_1) 
	else 

	doSendMagicEffect(p,10)	
	doCreatureSay(cid, "You already took Daram's reward.", TALKTYPE_ORANGE_1)
return true
end

end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(9010)
realmapEvent1:register()
