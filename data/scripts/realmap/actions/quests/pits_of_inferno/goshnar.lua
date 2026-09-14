local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 2023 then
		return false
	end

	if not Tile(toPosition):getItemById(2016, 2) then
		return true
	end

	toPosition.z = toPosition.z + 1
	player:teleportTo(toPosition)
	toPosition:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(2022)
realmapEvent1:register()
