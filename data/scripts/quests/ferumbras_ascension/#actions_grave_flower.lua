-- DISABLED 2026-09-20: this script claims item 22873, which on this map is
-- a candle, not a grave flower. It is a Canary id that the quest port did not
-- remap, so the script has never run: itemevents/use/others/transforms.lua claims
-- the same id first and is correct for this map.
--
-- Re-enable it by removing the '#' once the id it should be watching is known.
--
local function revertItem(position, itemId, transformId)
	local item = Tile(position):getItemById(itemId)
	if item then
		item:transform(transformId)
	end
end

local ferumbrasAscendantGraveFlower = ItemEvent()

ferumbrasAscendantGraveFlower:type("use")
function ferumbrasAscendantGraveFlower.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(22874)
	player:addItem(3661, 1)
	addEvent(revertItem, 2 * 60 * 1000, toPosition, 25530, 25529)
	return true
end

ferumbrasAscendantGraveFlower:id(22873)
ferumbrasAscendantGraveFlower:register()
