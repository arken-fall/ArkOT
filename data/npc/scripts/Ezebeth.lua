local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission01) == -1 then
			npcHandler:say("Well, there is little where we need help beyond the normal tasks you can do for the city. However, there is one thing out of the ordinary where some {assistance} would be appreciated.", cid)
			npcHandler.topic[playerId] = 1
		else
			npcHandler:say("You already asked for a mission, go to the next.", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "assistance") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say("It's nothing really important, so no one has yet found the time to look it up. It concerns the town's beggars that have started to behave {strange} lately.", cid)
			npcHandler.topic[playerId] = 2
		end
	elseif msgcontains(msg, "strange") then
		if npcHandler.topic[playerId] == 2 then
			npcHandler:say("They usually know better than to show up in the streets and harass our citizens, but lately they've grown more bold or desperate or whatever. I ask you to investigate what they are up to. If necessary, you may scare them away a bit.", cid)
			player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Mission01, 1) -- Mission 1 start
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "outfit") then
		if player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Mission18) == 1 and player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Outfit) < 1 then
			npcHandler:say("Nice work, take your outfit.", cid)
			player:addOutfit(610, 0)
			player:addOutfit(618, 0)
			player:setStorageValue(Storage.Quest.U10_50.DarkTrails.Outfit, 1)
			npcHandler.topic[playerId] = 0
		else
			npcHandler:say("You already have the outfit.", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "addon") then
		if player:getStorageValue(Storage.Quest.U10_50.DarkTrails.Outfit) == 1 then
			if player:getStorageValue(Storage.Quest.U10_50.OramondQuest.VotingPoints) >= 6 and player:getStorageValue(Storage.Quest.U10_50.GloothEngineerOutfits.Addon2) < 1 then
				npcHandler:say("Receive the second addon.", cid)
				player:addOutfit(610, 2)
				player:addOutfit(618, 2)
				player:setStorageValue(Storage.Quest.U10_50.GloothEngineerOutfits.Addon2, 1)
				npcHandler.topic[playerId] = 0
			elseif player:getStorageValue(Storage.Quest.U10_50.OramondQuest.VotingPoints) >= 3 and player:getStorageValue(Storage.Quest.U10_50.GloothEngineerOutfits.Addon1) < 1 then
				npcHandler:say("Receive the first addon.", cid)
				player:addOutfit(610, 1)
				player:addOutfit(618, 1)
				player:setStorageValue(Storage.Quest.U10_50.GloothEngineerOutfits.Addon1, 1)
				npcHandler.topic[playerId] = 0
			else
				npcHandler:say({
					"We provide addons to people dedicated to our city. So the first addon is granted to someone who has voted for each of the available shortcuts and each dungeon at least once. ...",
					"The second addon is granted to someone who has voted for each bossfight at least once.",
				}, cid)
				npcHandler.topic[playerId] = 0
			end
		end
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hello! I guess you are here for a {mission}.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
