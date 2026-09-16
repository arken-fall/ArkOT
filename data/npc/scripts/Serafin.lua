local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local BloodBrothers = Storage.Quest.U8_4.BloodBrothers
local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if msg == "cookie" then
		if player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Mission02) == 1 and player:getItemCount(8199) > 0 and player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Cookies.Serafin) < 0 then
			npcHandler:say("Oh, no I don't sell cookies. Or, do you mean you'd like to give me one?", cid)
			npcHandler.topic[playerId] = 1
		else
			npcHandler:say("It'd be better for you to leave now.", cid)
		end
	elseif msg == "yes" then
		if npcHandler.topic[playerId] == 1 and player:removeItem(8199, 1) then -- garlic cookie
			npcHandler:say("COUGH?! What kind of a mean trick is that? Get out of my shop!", cid)
			player:setStorageValue(Storage.Quest.U8_4.BloodBrothers.Cookies.Serafin, 1)
			npcHandler.topic[playerId] = 0
		end
	end
end
--Basic
keywordHandler:addKeyword({ "alori mort" }, StdModule.say, { npcHandler = npcHandler, text = "There's something about these words which makes me feel awkward. Or maybe it's you who causes that feeling. You better get lost." }, function(player)
	return player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Mission03) == 1
end)

npcHandler:setMessage(MESSAGE_GREET, "Welcome to my fruit and vegetable store, |PLAYERNAME|! Ask me for a {trade} if you'd like to see my wares.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
