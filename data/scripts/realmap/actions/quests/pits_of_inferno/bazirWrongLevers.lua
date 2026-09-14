local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1945 then
		player:teleportTo(Position(32806, 32328, 15))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		item:transform(1946)
 	end
 	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:uid(50095, 50096, 50097, 50098, 50099, 50100, 50101, 50102, 50103, 50104)
realmapEvent1:register()
