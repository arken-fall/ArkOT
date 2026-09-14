local MusicEffect = {
	
	[3957] = CONST_ME_SOUND_YELLOW, --Cornucopia
	
}

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	
	item:getPosition():sendMagicEffect(MusicEffect[item.itemid])
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(3957)
realmapEvent1:register()
