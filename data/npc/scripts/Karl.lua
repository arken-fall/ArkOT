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

	if msgcontains(msg, "barrel") then
		if player:getStorageValue(Storage.Quest.U8_1.SecretService.AVINMission03) == 2 then
			npcHandler:say("Do you bring me a barrel of beer??", cid)
			npcHandler.topic[playerId] = 1
		end
	elseif msgcontains(msg, "whisper beer") then
		if player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ReputationInSabrehaven) == 4 then
			npcHandler:say("Do you want to buy a bottle of our finest whisper beer for 80 gold?", cid)
			npcHandler.topic[playerId] = 2
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			if player:removeItem(404, 1) then
				player:setStorageValue(Storage.Quest.U8_1.SecretService.AVINMission03, 3)
				npcHandler:say("Three cheers for the noble |PLAYERNAME|.", cid)
			else
				npcHandler:say("You don't have any barrel of beer!", cid)
			end
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 2 then
			if player:getStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ReputationInSabrehaven) == 4 then
				if player:removeMoneyBank(80) then
					npcHandler:say("Here. Don't take it into the city though.", cid)
					player:setStorageValue(Storage.Quest.U7_8.TheShatteredIsles.ReputationInSabrehaven, 5)
					player:addItem(6106, 1)
					npcHandler.topic[playerId] = 0
				else
					npcHandler:say("You don't have enough money.", cid)
				end
			end
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Please come back, but don't tell others.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Please come back, but don't tell others.")
npcHandler:setMessage(MESSAGE_GREET, "Pshhhht! Not that loud ... but welcome.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "army" }, StdModule.say, { npcHandler = npcHandler, text = "Their army is the tool of opression. Hunting down every alcohol smuggler they can get." })
keywordHandler:addKeyword({ "women" }, StdModule.say, { npcHandler = npcHandler, text = "Their army is the tool of opression. Hunting down every alcohol smuggler they can get." })
keywordHandler:addKeyword({ "hard stuff" }, StdModule.say, { npcHandler = npcHandler, text = "Todd took all the money we could gather to buy us the best stuff on the whole continent." })
keywordHandler:addKeyword({ "headquarters" }, StdModule.say, { npcHandler = npcHandler, text = "Well it's more a hidden tavern, so to say." })
keywordHandler:addKeyword({ "hugo" }, StdModule.say, { npcHandler = npcHandler, text = "I think Todd mentioned a Hugo once." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am the responsible for our ... uhm ... resistance." })
keywordHandler:addKeyword({ "saloon" }, StdModule.say, { npcHandler = npcHandler, text = "I am the responsible for our ... uhm ... resistance." })
keywordHandler:addKeyword({ "welcome" }, StdModule.say, { npcHandler = npcHandler, text = "I am the responsible for our ... uhm ... resistance." })
keywordHandler:addKeyword({ "karl" }, StdModule.say, { npcHandler = npcHandler, text = "Who told you that???" })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "I'm sure if the king learns about our tragedy, he will support us with alcohol." })
keywordHandler:addKeyword({ "thais" }, StdModule.say, { npcHandler = npcHandler, text = "I'm sure if the king learns about our tragedy, he will support us with alcohol." })
keywordHandler:addKeyword({ "alcohol" }, StdModule.say, { npcHandler = npcHandler, text = "Those crazy women forbid us alcohol in the city! Imagine that!" })
keywordHandler:addKeyword({ "laws" }, StdModule.say, { npcHandler = npcHandler, text = "Those crazy women forbid us alcohol in the city! Imagine that!" })
keywordHandler:addKeyword({ "needs" }, StdModule.say, { npcHandler = npcHandler, text = "Those crazy women forbid us alcohol in the city! Imagine that!" })
keywordHandler:addKeyword({ "opression" }, StdModule.say, { npcHandler = npcHandler, text = "Those crazy women forbid us alcohol in the city! Imagine that!" })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I won't tell you my name." })
keywordHandler:addKeyword({ "news" }, StdModule.say, { npcHandler = npcHandler, text = "Some travelers from Edron told about a great treasure guarded by cruel demons in the dungeons there." })
keywordHandler:addKeyword({ "rumors" }, StdModule.say, { npcHandler = npcHandler, text = "Some travelers from Edron told about a great treasure guarded by cruel demons in the dungeons there." })
keywordHandler:addKeyword({ "eloise" }, StdModule.say, { npcHandler = npcHandler, text = "Well, shes not that bad ... but some of her laws are." })
keywordHandler:addKeyword({ "queen" }, StdModule.say, { npcHandler = npcHandler, text = "Well, shes not that bad ... but some of her laws are." })
keywordHandler:addKeyword({ "resistance" }, StdModule.say, { npcHandler = npcHandler, text = "We fight the opression of the males and male needs by the women. This is our secret headquarters." })
keywordHandler:addKeyword({ "smuggler" }, StdModule.say, { npcHandler = npcHandler, text = "We collected money and hired one of the best smuggler in the whole land. His name is Todd." })
keywordHandler:addKeyword({ "special" }, StdModule.say, { npcHandler = npcHandler, text = "Carlin is known for its evergreen plants which the local druids have grown." })
keywordHandler:addKeyword({ "tavern" }, StdModule.say, { npcHandler = npcHandler, text = "Our offers are limited but here a man can buy what a man needs." })
keywordHandler:addKeyword({ "tim" }, StdModule.say, { npcHandler = npcHandler, text = "Ah, Tim was such a ladies' man in his youth. He has broken many hearts and the women fainted on account of his kisses. Today they faint on account of his breath." })
keywordHandler:addKeyword({ "todd" }, StdModule.say, { npcHandler = npcHandler, text = "A true fighter for malehood. He will bring us all the hard stuff from Thais and even contact the king there to support us." })

npcHandler:addModule(FocusModule:new())
