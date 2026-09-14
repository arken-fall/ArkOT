local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local wallItem = Tile(33151, 32866, 8):getItemById(1100)
	if wallItem then
		wallItem:remove()
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	else
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(5632)
realmapEvent1:register()
