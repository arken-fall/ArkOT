local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 8012 then
		return false
	end

	if player:getStorageValue(Storage.ChildrenoftheRevolution.Questline) == 10 then
		player:setStorageValue(Storage.ChildrenoftheRevolution.Questline, 11)
		player:setStorageValue(Storage.ChildrenoftheRevolution.Mission03, 2) --Questlog, Children of the Revolution "Mission 3: Zee Killing Fieldzz"
		item:remove()
		player:say("The rice has been poisoned. This will weaken the Emperor's army significantly. Return and tell Zalamon about your success.", TALKTYPE_MONSTER_SAY)
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(10760)
realmapEvent1:register()
