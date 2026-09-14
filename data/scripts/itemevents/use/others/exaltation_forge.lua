-- the exaltation forge: using it opens the forge window
local exaltationForge = ItemEvent()

exaltationForge.onUse = function(player, item, fromPosition, target, toPosition, isHotkey)
	player:openForge()
	return true
end

exaltationForge:id(39497, 39498, 39499)
exaltationForge:register()
