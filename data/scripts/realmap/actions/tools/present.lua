local function onUse(cid, item, fromPosition, itemEx, toPosition)
	if(item.itemid == 13158) then
		if(itemEx.itemid == 13159) then
			if(getPlayerStorageValue(cid, 41600) == 1) then
			doRemoveItem(item.uid, 1)
			doRemoveItem(itemEx.uid, 1)
			doPlayerAddItem(cid, 13160, 1)
		   end
	      end
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(13158)
realmapEvent1:register()
