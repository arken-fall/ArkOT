local setting = {
	[8816] = Storage.Quest.U7_9.ThePitsOfInferno.ShortcutHubDoor,
	[8817] = Storage.Quest.U7_9.ThePitsOfInferno.ShortcutLeverDoor,
}

local shortcuts = ItemEvent()

function shortcuts.onStepOn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local storage = setting[item.actionid]
	if player:getStorageValue(storage) ~= 1 then
		player:setStorageValue(storage, 1)
	end
	return true
end

shortcuts:type("stepon")

for index, value in pairs(setting) do
	shortcuts:aid(index)
end

shortcuts:register()
