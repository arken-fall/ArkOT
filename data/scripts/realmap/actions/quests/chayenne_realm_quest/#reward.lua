local function onUse(cid, item, fromPosition, itemEx, toPosition)
	if getPlayerStorageValue(cid, 72648) < 1 then
		local bp = doPlayerAddItem(cid, 5949, 1)
		doAddContainerItem(bp, 18511, 1)
		doAddContainerItem(bp, 2745, 1)
		doAddContainerItem(bp, 9948, 1)
		doAddContainerItem(bp, 2144, 1)
		doAddContainerItem(bp, 5882, 1)
		doAddContainerItem(bp, 5791, 1)
		doAddContainerItem(bp, 2114, 1)
		doAddContainerItem(bp, 6570, 1)
		setPlayerStorageValue(cid, 72648, 1)
		doPlayerSendTextMessage(cid, 19, "You have found a beach backpack.")
	else
		doPlayerSendTextMessage(cid, 19, "You already got your reward.")
	end
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(55023)
realmapEvent1:register()
