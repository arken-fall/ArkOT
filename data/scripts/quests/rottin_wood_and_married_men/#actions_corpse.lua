-- DISABLED 2026-09-20: this script claims item 12189, which on this map is
-- a closed door, not a corpse. It is a Canary id that the quest port did not
-- remap, so the script has never run: doors/normal_doors.lua claims
-- the same id first and is correct for this map.
--
-- Re-enable it by removing the '#' once the id it should be watching is known.
--
local rottinWoodCorpse = ItemEvent()
rottinWoodCorpse:type("use")
function rottinWoodCorpse.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 12189 then
		local storageRottinWoodAndMariedCorpse = player:getStorageValue(Storage.Quest.U8_7.RottinWoodAndTheMarriedMen.Corpse)
		if player:getStorageValue(Storage.Quest.U8_7.RottinWoodAndTheMarriedMen.Mission03) == 5 and storageRottinWoodAndMariedCorpse < 4 then
			player:say("You take no more gold than you actually need and release the merchant who makes away the very second you remove the ropes.", TALKTYPE_MONSTER_SAY)
			player:setStorageValue(Storage.Quest.U8_7.RottinWoodAndTheMarriedMen.Corpse, storageRottinWoodAndMariedCorpse + 1)
			item:remove(1)
		end
	end

	return true
end

rottinWoodCorpse:id(12189)
rottinWoodCorpse:register()
