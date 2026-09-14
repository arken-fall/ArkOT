local function onUse(cid, item, fromPosition, itemEx, toPosition)
	if(item.itemid == 13281) then

		doCreatureSay(cid, "You do not need to click on the chest, if have a reward, this goes for your backpack automatically.", TALKTYPE_ORANGE_1)
		
		
	
	end
	
	return true
	
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(37412)
realmapEvent1:register()
