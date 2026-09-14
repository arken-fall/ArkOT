local config = {
	[7737] = {'orc warrior', 'pirate cutthroat', 'dworc voodoomaster', 'dwarf guard', 'minotaur mage', 'ogre shaman', 'ogre brute', 'rat'}, -- common
	[7739] = {'serpent spawn', 'demon', 'juggernaut', 'behemoth', 'ashmunrah', 'vexclaw', 'grimeleech', 'hellflayer', 'black sheep'}, -- uncommon
	[9076] = {'quara hydromancer', 'diabolic imp', 'banshee', 'frost giant', 'lich', 'vexclaw', 'grimeleech', 'hellflayer', 'ogre shaman', 'ogre brute', 'pig'} -- deluxe
}

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local monsterNames = config[item.itemid]
	if not monsterNames then
		return true
	end
    player:sendTextMessage(MESSAGE_STATUS_DEFAULT, 'You will stay 5 minutes transformed in a monster!')
	doSetMonsterOutfit(player, monsterNames[math.random(#monsterNames)], 300 * 1000)
	player:addAchievementProgress('Masquerader', 100)
	item:getPosition():sendMagicEffect(36)
	item:remove()
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(7737, 7739, 9076)
realmapEvent1:register()
