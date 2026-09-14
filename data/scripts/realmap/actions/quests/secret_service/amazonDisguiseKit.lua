local condition = Condition(CONDITION_OUTFIT)
condition:setTicks(20 * 1000) -- should be approximately 20 seconds
condition:setOutfit({lookType = 137, lookHead = 113, lookBody = 120, lookLegs = 114, lookFeet = 132}) -- amazon looktype

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:addCondition(condition)
	player:say('You disguise yourself as a beautiful amazon!', TALKTYPE_MONSTER_SAY)
	item:remove()
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(7700)
realmapEvent1:register()
