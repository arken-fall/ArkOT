local statues = {
	[18488] = SKILL_SWORD,
	[18489] = SKILL_AXE,
	[18490] = SKILL_CLUB,
	[18491] = SKILL_DISTANCE,
	[18492] = SKILL_MAGLEVEL
}

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local skill = statues[item:getId()]
	if not player:isPremium() then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, Game.getReturnMessage(RETURNVALUE_YOUNEEDPREMIUMACCOUNT))
		return true
	end

	if player:isPzLocked() then
		return false
	end

	player:setOfflineTrainingSkill(skill)
	player:remove()
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(18488, 18489, 18490, 18491, 18492)
realmapEvent1:register()
