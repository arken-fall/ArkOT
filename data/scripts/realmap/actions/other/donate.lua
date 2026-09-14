local function onUse(cid, item, fromPosition, itemEx, toPosition)
if Player(cid) then
Item(item.uid):remove(1)
		 doPlayerSendTextMessage(cid,19,"Relogue para ativar seu outfit ou montaria.")
		 end
		return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(11101)
realmapEvent1:register()
