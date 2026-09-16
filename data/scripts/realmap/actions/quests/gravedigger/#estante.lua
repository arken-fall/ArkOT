local function onUse(cid, item, fromPosition, itemEx, toPosition)

if(getPlayerStorageValue(cid, 157443) < 1) then
	setPlayerStorageValue(cid, 157443, 1)
	doPlayerAddItem(cid,21474,1)
	doCreatureSay(cid, "You have found a crumpled paper.", TALKTYPE_ORANGE_1)
	else 
		
	doCreatureSay(cid, "You've picked up here.", TALKTYPE_ORANGE_1)
return true
end

end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(4669)
realmapEvent1:register()
