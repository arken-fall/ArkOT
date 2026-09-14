local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not isInArray({1786, 1787, 1788, 1789, 1790, 1791, 1792, 1793, 9911}, target.itemid) then
		return false
	end

	item:remove(1)
	toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
	player:say("You burned the alchemist formula.", TALKTYPE_MONSTER_SAY)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(9733)
realmapEvent1:register()
