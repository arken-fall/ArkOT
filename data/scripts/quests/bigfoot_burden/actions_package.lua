local bigfootPackage = ItemEvent()
bigfootPackage:type("use")
function bigfootPackage.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(item.itemid - 1)
	return true
end

bigfootPackage:id(15802)
bigfootPackage:register()
