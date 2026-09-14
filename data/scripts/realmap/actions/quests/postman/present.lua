local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:remove(1)
	toPosition:sendMagicEffect(CONST_ME_POFF)
	player:say("You open the present.", TALKTYPE_MONSTER_SAY)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(2331)
realmapEvent1:register()
