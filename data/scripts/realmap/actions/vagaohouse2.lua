local function onUse(cid, item, fromPosition, itemEx, toPosition)
local p = {x = 32559, y = 31852, z = 7} -- 32694, 31495, 11
if(getPlayerStorageValue(cid, 10050) < 1000) then
	doTeleportThing(cid,p)
	
	doSendMagicEffect(p,10)
	else doCreatureSay(cid, "Zzz Dont working.", TALKTYPE_ORANGE_1)
return true
end

end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(50246)
realmapEvent1:register()
