local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- Wrath of the Emperor Mission02
	if target.itemid == 12322 then
		player:addItem(12285, 1)
		player:say("You dig out a handful of ordinary clay.", TALKTYPE_MONSTER_SAY)
	-- The Shattered Isles Parrot ring
	elseif target.itemid == 6094 then
		if player:getStorageValue(Storage.TheShatteredIsles.TheGovernorDaughter) == 1 then
			toPosition:sendMagicEffect(CONST_ME_POFF)
			Game.createItem(6093, 1, Position(32422, 32770, 1))
			player:say("You have found a ring.", TALKTYPE_MONSTER_SAY)
			player:setStorageValue(Storage.TheShatteredIsles.TheGovernorDaughter, 2)
		end
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(2549)
realmapEvent1:register()
