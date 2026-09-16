local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier
local AnUneasyAlliance = Storage.Quest.U8_54.AnUneasyAlliance
local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "mission") then
		if player:getStorageValue(TheNewFrontier.Questline) == 16 then
			npcHandler:say("You come here to ask us to spare your people? This land has no tolerance for the weak, we have it neither. If you want us to consider you as useful for us, you'll have to prove it in a {test} of strength and courage. ", cid)
			npcHandler.topic[playerId] = 1
		elseif player:getStorageValue(TheNewFrontier.Questline) == 18 then
			npcHandler:say({
				"We have seen that you can fight and survive. Yet, it will also need cleverness and courage to survive in these lands. We might see later if you've got what it takes. ...",
				"However, I stand to my word - our hordes will spare your insignificant piece of rock for now. Time will tell if you are worthy living next to us. ...",
				"Still, it will take years until we might consider you as an ally, but this is a start at least.",
			}, cid)
			player:setStorageValue(TheNewFrontier.Questline, 19)
			player:setStorageValue(TheNewFrontier.Mission06, 4) --Questlog, The New Frontier Quest "Mission 06: Days Of Doom"
		elseif player:getStorageValue(TheNewFrontier.Mission06) >= 5 and player:getStorageValue(AnUneasyAlliance.Questline) < 1 then --An Uneasy Alliance Quest
			npcHandler:say({
				"So you still think you can be of any use for us? Words are cheap and easy. Admittedly, you've passed our first test but even some resilient beast might have accomplished that. ...",
				"Your actions will tell if you are only yelping for attention like a puppy or if you have the teeth of a wolf. ...",
				"A first tiny step was taken. You survived the test and ensured the survival of your allies for a while. Now it is time to make the next step. ...",
				"So listen human: Our rule over the orcs is not unchallenged. Of course now and then someone shows up who thinks he can defeat us. Usually these fights end fast and bloody in the ring. ...",
				"Right now, some coward from our midst, who is too afraid to face us in single combat, has gathered a group of followers, hoping more will follow and change sides. ...",
				"With your help, his defeat will not only be deadly but also humiliating and so discourage others to follow his example. ...",
				"You will seek out this rebel commander in his hideout and kill him. We will show them that not even a Mooh'Tah master is needed to get rid of such wannabe leaders but that a mere human can handle them. ...",
				"Find him in the mountain north-west of here and kill him. If you find any loot, you can keep it.",
			}, cid)
			player:setStorageValue(AnUneasyAlliance.Questline, 1)
			player:setStorageValue(AnUneasyAlliance.QuestDoor, 0)
		elseif player:getStorageValue(AnUneasyAlliance.Questline) == 1 and player:getStorageValue(AnUneasyAlliance.QuestDoor) == 1 then
			npcHandler:say("With the death of their leader, the rebels return to our camps one by one, deeply humiliated. It might be a wise decision to let a useful tool like you continue to exist.", cid)
			player:setStorageValue(AnUneasyAlliance.Questline, 2)
		elseif player:getStorageValue(AnUneasyAlliance.Questline) == 2 then
			npcHandler:say({
				"We are aware that the lizards use magic to spy on us. In the Dragonblaze Mountains north of here, there is a tower which can only be entered through one of their underground fortresses. ...",
				"In this tower, there must be some accessory used for magical scrying. Some pond, a crystal ball, or a mirror maybe - it has to be something shiny. ...",
				"Usually we would send one of our youngsters on such a mission, but we are few and there is little new blood in our ranks. ...",
				"We can't send a Mooh'Tah master on such a trivial assignment, neither can we use orcs for an infiltration mission. ...",
				"This is your chance to show us your potential. Infiltrate this tower and destroy their scrying device. Once you have blinded our enemy, we might respect you somewhat more.",
			}, cid)
			player:setStorageValue(AnUneasyAlliance.Questline, 3)
		elseif player:getStorageValue(AnUneasyAlliance.Questline) == 4 then
			npcHandler:say({
				"Finally, our enemy's vision is obscured. Now we can move in for some more daring raids until they replace their scrying device. You have proven yourself brave and useful so far. With that, you bought your allies some more days to live. ...",
				"Here is a reward. It's a strange tome that we've found in the lizard ruins. Maybe it is of some value for you or your allies.",
			}, cid)
			player:setStorageValue(AnUneasyAlliance.Questline, 5)
			player:addItem(10217)
		end
	elseif msgcontains(msg, "test") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say({
				"First we will test your strength and endurance. You'll have to face one of the most experienced Mooh'Tah masters. As you don't stand a chance to beat such an opponent, your test will be simply to survive. ...",
				"Face him in a battle and survive for two minutes. If you do, we will be willing to assume that your are prepared for the life in these lands. Enter the ring of battle, close to my quarter. Return to me after you have passed this test.",
			}, cid)
			npcHandler.topic[playerId] = 0
			player:setStorageValue(TheNewFrontier.Questline, 17)
			player:setStorageValue(TheNewFrontier.Mission06, 2) --Questlog, The New Frontier Quest "Mission 06: Days Of Doom"
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Be greeted blank skin.")

npcHandler:addModule(FocusModule:new())
