-- RETIRED 2026-09-20: every id this script claimed is already claimed by a script
-- written for this map, which registers first and therefore wins. It has never
-- run here. Disabled by the leading '#', not deleted, so the 10.98 pack's
-- version of this furniture stays readable.
--
local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local hasOutfit = player:getStorageValue(Storage.OutfitQuest.Afflicted.Outfit) == 1

	-- Plgue Mask
	if item.itemid == 13925 then
		if not hasOutfit then
			return false
		end

		if player:getStorageValue(Storage.OutfitQuest.Afflicted.AddonPlagueMask) == 1 then
			return false
		end

		player:addOutfitAddon(430, 2)
		player:addOutfitAddon(431, 2)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:setStorageValue(Storage.OutfitQuest.Afflicted.AddonPlagueMask, 1)
		player:say('You gained a plague mask for your outfit.', TALKTYPE_MONSTER_SAY, false, player)
		item:remove()

	-- Plague Bell
	elseif item.itemid == 13926 then
		if not hasOutfit then
			return false
		end

		if player:getStorageValue(Storage.OutfitQuest.Afflicted.AddonPlagueBell) == 1 then
			return false
		end

		player:addOutfitAddon(430, 1)
		player:addOutfitAddon(431, 1)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:setStorageValue(Storage.OutfitQuest.Afflicted.AddonPlagueBell, 1)
		player:say('You gained a plague bell for your outfit.', TALKTYPE_MONSTER_SAY, false, player)
		item:remove()

	-- Outfit
	else
		if hasOutfit then
			return false
		end

		for id = 13540, 13545 do
			if player:getItemCount(id) < 1 then
				return false
			end
		end

		for id = 13540, 13545 do
			player:removeItem(id, 1)
		end

		player:addOutfit(430)
		player:addOutfit(431)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:setStorageValue(Storage.OutfitQuest.Afflicted.Outfit, 1)
		player:say('You have restored an outfit.', TALKTYPE_MONSTER_SAY, false, player)
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(13540, 13541, 13542, 13543, 13544, 13545, 13925, 13926)
realmapEvent1:register()
