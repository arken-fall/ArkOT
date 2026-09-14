local condition = Condition(CONDITION_OUTFIT)
condition:setTicks(10000)
condition:setOutfit({lookType = 65})

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:addCondition(condition)
	player:say('You are now disguised as a mummy for 10 seconds. Hurry up and scare the caliph!', TALKTYPE_MONSTER_SAY)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(7502)
realmapEvent1:register()
