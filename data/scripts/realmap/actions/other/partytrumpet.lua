local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(13578)
	item:decay()
	player:say("TOOOOOOT!", TALKTYPE_MONSTER_SAY)
	fromPosition:sendMagicEffect(CONST_ME_SOUND_BLUE)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(6572)
realmapEvent1:register()
