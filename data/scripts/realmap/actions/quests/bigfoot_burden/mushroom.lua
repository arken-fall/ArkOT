local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local spore = Game.createItem(math.random(18221, 18224), 1, toPosition)
	if spore then
		spore:decay()
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(18220)
realmapEvent1:register()
