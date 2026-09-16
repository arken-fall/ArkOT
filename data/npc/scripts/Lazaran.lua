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

	local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier
	local UnnaturalSelection = Storage.Quest.U8_54.UnnaturalSelection

	if msgcontains(msg, "mission") then
		if npcHandler.topic[playerId] == 0 and player:getStorageValue(TheNewFrontier.Questline) == 8 then
			npcHandler:say("Me people wanting {peace}. No war with others. No war with {little men}. We few. We weak. Need {help}. We not wanting make {war}. No hurt.", cid)
			npcHandler.topic[playerId] = 10
		elseif npcHandler.topic[playerId] == 12 then
			if player:getStorageValue(TheNewFrontier.Mission03) == 3 and player:getStorageValue(UnnaturalSelection.Questline) < 0 then
				npcHandler:say({
					"Big problem we have! Skull of first leader gone. He ancestor of whole tribe but died long ago in war. We have keep his skull on our sacred place. ...",
					"Then one night, green men came with wolves... and one of wolves took skull and ran off chewing on it! We need back - many wisdom and power is in skull. Maybe they took to north fortress. But can be hard getting in. You try get our holy skull back?",
				}, cid)
				npcHandler.topic[playerId] = 1
			end
		elseif player:getStorageValue(UnnaturalSelection.Questline) == 1 then
			npcHandler:say("Oh! You found holy skull? In bone pile you found?! Thank Pandor you brought! Me can have it back?", cid)
			npcHandler.topic[playerId] = 2
		elseif player:getStorageValue(UnnaturalSelection.Questline) == 2 then
			npcHandler:say({
				"You brought back skull of first leader. Hero of tribe! But we more missions to do. ...",
				"Me and Ulala talk about land outside. We wanting to see more of land! Land over big water! But us no can leave tribe. No can cross water. Only way is skull of first leader. ...",
				"What holy skull sees, tribe sees. That we believe. Can you bring holy skull over big water and show places?",
			}, cid)
			npcHandler.topic[playerId] = 3
		elseif player:getStorageValue(UnnaturalSelection.Questline) == 3 then
			npcHandler:say("You say you was to where sun is hot and burning? And where trees grow as high as mountain? And where Fasuon cries white tears? Me can't wait to see!! Can have holy skull back?", cid)
			npcHandler.topic[playerId] = 4
		elseif player:getStorageValue(UnnaturalSelection.Questline) == 4 then
			npcHandler:say("We been weak for too long! We prepare for great hunt. But still need many doings! You can help us?", cid)
			npcHandler.topic[playerId] = 5
		elseif player:getStorageValue(UnnaturalSelection.Questline) == 13 then
			npcHandler:say({
				"You well did! Great hunt is under best signs now. We prepare weapons and paint faces and then go! ...",
				"No no, you no need to help us. But can prepare afterparty! Little men sent us stuff some time ago. Was strange water in there. Brown and stinky! But when we tried all tribe became veeeeeeery happy. ...",
				"Now brown water is gone and we sad! Can you bring POT of brown water for party after great hunt? Just bring to me and me trade for shiny treasure.",
			}, cid)
			player:setStorageValue(UnnaturalSelection.Questline, 14)
			player:setStorageValue(UnnaturalSelection.Mission06, 2) -- Questlog, Unnatural Selection Quest "Mission 6: Firewater Burn"
			npcHandler.topic[playerId] = 0
		elseif player:getStorageValue(UnnaturalSelection.Questline) == 14 then
			npcHandler:say("You bring us big pot of strange water from little men?", cid)
			npcHandler.topic[playerId] = 6
		end
	elseif msgcontains(msg, "peace") then
		if npcHandler.topic[playerId] == 10 and player:getStorageValue(TheNewFrontier.Questline) == 8 then
			npcHandler:say("Me people wanting peace. No war with others. No war with little men.", cid)
			player:setStorageValue(TheNewFrontier.Questline, 9)
			player:setStorageValue(TheNewFrontier.Mission03, 2) -- Questlog, The New Frontier Quest "Mission 03: Strangers in the Night"
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "help") then
		npcHandler:say("You mean you want help us?", cid)
		npcHandler.topic[playerId] = 11
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say("You hero of our tribe if bring back holy skull!", cid)
			player:setStorageValue(UnnaturalSelection.Questline, 1)
			player:setStorageValue(UnnaturalSelection.Mission01, 1) -- Questlog, Unnatural Selection Quest "Mission 1: Skulled"
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 2 then
			if player:removeItem(10159, 1) then
				npcHandler:say("Me thank you much! All wisdom safe again now.", cid)
				player:setStorageValue(UnnaturalSelection.Questline, 2)
				player:setStorageValue(UnnaturalSelection.Mission01, 3) -- Questlog, Unnatural Selection Quest "Mission 1: Skulled"
				npcHandler.topic[playerId] = 0
			else
				npcHandler:say("You do not have it!", cid)
				npcHandler.topic[playerId] = 0
			end
		elseif npcHandler.topic[playerId] == 3 then
			npcHandler:say("Here take holy skull. You bring where you think is good. See as much as possible! See where other people live!", cid)
			player:addItem(10159, 1)
			player:setStorageValue(UnnaturalSelection.Questline, 3)
			player:setStorageValue(UnnaturalSelection.Mission02, 1) -- Questlog, Unnatural Selection Quest "Mission 2: All Around the World"
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 4 then
			if player:getStorageValue(UnnaturalSelection.Mission02) == 12 and player:getItemCount(10159) >= 1 then
				npcHandler:say("We make big ritual soon and learn much about world outside. Me thank you many times for teaching us world. Very wise and adventurous you are!", cid)
				player:removeItem(10159, 1)
				player:setStorageValue(UnnaturalSelection.Questline, 4)
				player:setStorageValue(UnnaturalSelection.Mission02, 13) -- Questlog, Unnatural Selection Quest "Mission 2: All Around the World"
				npcHandler.topic[playerId] = 0
			else
				npcHandler:say("The skull have not seen all yet!", cid)
				npcHandler.topic[playerId] = 0
			end
		elseif npcHandler.topic[playerId] == 5 then
			npcHandler:say("We need to calm and make happy gods. Best go to Ulala. She is priest of us and can tell what needs doing.", cid)
			player:setStorageValue(UnnaturalSelection.Questline, 5)
			player:setStorageValue(UnnaturalSelection.Mission03, 1) -- Questlog, Unnatural Selection Quest "Mission 3: Dance Dance Evolution"
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 6 then
			if player:removeItem(3465, 1, 3) then
				npcHandler:say("We make big ritual soon and learn much about world outside. Me thank you many times for teaching us world. Very wise and adventurous you are!", cid)
				player:addItem(10198, 1)
				player:setStorageValue(UnnaturalSelection.Questline, 15)
				player:setStorageValue(UnnaturalSelection.Mission06, 3) -- Questlog, Unnatural Selection Quest "Mission 6: Firewater Burn"
				npcHandler.topic[playerId] = 0
			else
				npcHandler:say("You do not have the brown strange water!", cid)
				npcHandler.topic[playerId] = 0
			end
		elseif npcHandler.topic[playerId] == 11 then
			npcHandler:say("Me have many small task, but also big {mission}. You say what want.", cid)
			npcHandler.topic[playerId] = 12
		end
	elseif msgcontains(msg, "war") then
		npcHandler:say("Many mighty monster rule land. We fight. We lose. We flee to mountain to hide.", cid)
	elseif msgcontains(msg, "little men") then
		npcHandler:say("We come and see little men. They like us, only very little. They having good weapon and armor, like the greens.", cid)
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Me greet. You no enemy of tribe.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
