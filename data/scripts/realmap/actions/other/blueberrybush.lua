local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(2786)
	item:decay()
	Game.createItem(2677, 3, fromPosition)

	player:addAchievementProgress('Bluebarian', 500)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(2785)
realmapEvent1:register()
