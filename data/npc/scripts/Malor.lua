local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function releasePlayer(npc, creature)
	if not Player(creature) then
		return
	end

	npcHandler:removeInteraction(npc, creature)
	npcHandler:resetNpc(npc, creature)
end

local function endConversationWithDelay(npcHandler, npc, creature)
	addEvent(function()
		npcHandler:unGreet(npc, creature)
	end, 1000)
end

local function greetCallback(npc, cid, msg)
	local player = Player(cid)
	local playerId = cid

	if not msgcontains(msg, "djanni'hah") and player:getStorageValue(Storage.Quest.U7_4.DjinnWar.Faction.Greeting) < 0 then
		npcHandler:say("Shove off, little one! Humans are not welcome here, |PLAYERNAME|!", cid)
		endConversationWithDelay(npcHandler, cid)
		return false
	end

	if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.MaridFaction.Start) == 1 then
		npcHandler:say({
			"Hahahaha! ...",
			"|PLAYERNAME|, that almost sounded like the word of greeting. Humans - cute they are!",
		}, cid)
		endConversationWithDelay(npcHandler, cid)
		return false
	end

	npcHandler:say("Greetings, human |PLAYERNAME|. My patience with your kind is limited, so speak quickly and choose your words well.", cid)
	npcHandler:setInteraction(npc, cid)

	return true
end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	local missionProgress = player:getStorageValue(Storage.Quest.U7_4.DjinnWar.EfreetFaction.Mission03)
	if msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.Quest.U7_4.DjinnWar.EfreetFaction.Mission02) == 3 then
			if missionProgress < 1 then
				npcHandler:say({
					"I guess this is the first time I entrust a human with a mission. And such an important mission, too. But well, we live in hard times, and I am a bit short of adequate staff. ...",
					"Besides, Baa'leal told me you have distinguished yourself well in previous missions, so I think you might be the right person for the job. ...",
					"But think carefully, human, for this mission will bring you close to certain death. Are you prepared to embark on this mission?",
				}, cid)
				npcHandler.topic[playerId] = 1
			elseif missionProgress == 1 then
				npcHandler:say("You haven't finished your final mission yet. Shall I explain it again to you?", cid)
				npcHandler.topic[playerId] = 1
			elseif missionProgress == 2 then
				npcHandler:say("Have you found Fa'hradin's lamp and placed it in Malor's personal chambers?", cid)
				npcHandler.topic[playerId] = 2
			else
				npcHandler:say("There's no mission left for you, friend of the Efreet. However, I have a {task} for you.", cid)
			end
		else
			npcHandler:say({
				"So you would like to fight for us. Hmm. ...",
				"You show true courage, human, but I will not accept your offer at this point of time.",
			}, cid)
		end
	elseif npcHandler.topic[playerId] == 1 then
		if msgcontains(msg, "yes") then
			npcHandler:say({
				"Well, listen. We are trying to acquire the ultimate weapon to defeat Gabel: Fa'hradin's lamp! ...",
				"At the moment it is still in the possession of that good old friend of mine, the Orc King, who kindly released me from it. ...",
				"However, for some reason he is not as friendly as he used to be. You better watch out, human, because I don't think you will get the lamp without a fight. ...",
				"Once you have found the lamp you must enter Ashta'daramai again. Sneak into Gabel's personal chambers and exchange his sleeping lamp with Fa'hradin's lamp! ...",
				"If you succeed, the war could be over one night later!",
			}, cid)
			player:setStorageValue(Storage.Quest.U7_4.DjinnWar.EfreetFaction.Mission03, 1)
		elseif msgcontains(msg, "no") then
			npcHandler:say("Your choice.", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif npcHandler.topic[playerId] == 2 then
		if msgcontains(msg, "yes") then
			npcHandler:say({
				"Well well, human. So you really have made it - you have smuggled the modified lamp into Gabel's bedroom! ...",
				"I never thought I would say this to a human, but I must confess I am impressed. ...",
				"Perhaps I have underestimated you and your kind after all. ...",
				"I guess I will take this as a lesson to keep in mind when I meet you on the battlefield. ...",
				"But that's in the future. For now, I will confine myself to give you the permission to trade with my people whenever you want to. ...",
				"Farewell, human!",
			}, cid)
			player:setStorageValue(Storage.Quest.U7_4.DjinnWar.EfreetFaction.Mission03, 3)
			player:setStorageValue(Storage.Quest.U7_4.DjinnWar.EfreetFaction.DoorToMaridTerritory, 1)
			player:addAchievement("Efreet Ally")
			addEvent(function()
				releasePlayer(npc, cid)
			end, 1000)
		elseif msgcontains(msg, "no") then
			npcHandler:say("Just do it!", cid)
		end
		npcHandler.topic[playerId] = 0
	elseif msgcontains(msg, "task") and player:getStorageValue(Storage.Quest.U7_4.DjinnWar.EfreetFaction.Mission03) == 3 then
		if player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.BlueDjinnTask) < 0 or player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.BlueDjinnTask) == 3 then
			npcHandler:say("There are still blue djinns everywhere! We can't let a single one of them live. I guess a start would be for you to kill 500 blue djinns and Marid. Will you assist us?", cid)
			npcHandler.topic[playerId] = 3
		elseif player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.BlueDjinnTask) == 0 then
			if player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.BlueDjinnCount) >= 500 then
				npcHandler:say({
					"Well well, human. Not bad. I'm not surprised, since you have done acceptably well in the past. So I suppose I can ask you for another thing. ...",
					"Seek out Fahim the Wise. A name which is utter mockery, since he's one of the stupidest Marid I've ever seen. He hides somewhere in Yalahar, probably afraid to come anywhere near Mal'ouquah. ...",
					"I suggest you teach that joke of a djinn a lesson he won't forget.",
				}, cid)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.FahimCount, 0)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.BlueDjinnTask, 1)
			else
				npcHandler:say("Come back when you kill 500 blue djinns and Marid.", cid)
			end
		elseif player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.BlueDjinnTask) == 2 then
			npcHandler:say({
				"You've met Fahim the Wise? That's good. I'm pretty sure it was easy to give him a nice beating. ...",
				"If you should feel like killing blue djinns in our service again, just talk to me about that task.",
			}, cid)
			player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.BlueDjinnTask, 3)
			player:addExperience(10000, true)
			player:addMoney(5000)
		end
	elseif msgcontains(msg, "yes") and npcHandler.topic[playerId] == 3 then
		npcHandler:say("Good, then show those pathetic Marid what you're made of.", cid)
		player:setStorageValue(JOIN_STOR, 1)
		player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.BlueDjinnCount, 0)
		player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.BlueDjinnCount, 0)
		player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.MaridCount, 0)
		player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.BlueDjinnTask, 0)
	end
	return true
end

-- keywordHandler:addCustomGreetKeyword({ "djanni'hah" }, greetCallback, { npcHandler = npcHandler })

npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell, human. When I have taken my rightful place I shall remember those who served me well. Even if they are only humans.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Farewell, human.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:addModule(FocusModule:new())
