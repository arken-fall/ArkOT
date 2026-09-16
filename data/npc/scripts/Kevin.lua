local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local function getPlayerBones(creature)
	local player = Player(creature)
	return player:getItemCount(3115) + player:getItemCount(3116)
end

local function doPlayerRemoveBones(creature)
	local player = Player(creature)
	return player:removeItem(3115, player:getItemCount(3115)) and player:removeItem(3116, player:getItemCount(3116))
end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "mission") then
		if player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission01) < 1 then
			npcHandler:say("You are not a member of our guild yet! We have high standards for our members. To rise in our guild is a difficult but rewarding task. Are you interested in joining?", cid)
			npcHandler.topic[playerId] = 1
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission01) == 5 then
			npcHandler:say("So you have finally made it! I did not think that you would have it in you ... However: are you ready for another assignment?", cid)
			npcHandler.topic[playerId] = 8
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission02) == 2 then
			npcHandler:say("Excellent, you got it fixed! This will teach this mailbox a lesson indeed! Are you interested in another assignment?", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission02, 3)
			npcHandler.topic[playerId] = 9
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission03) == 2 then
			npcHandler:say("You truly got him? Quite impressive. You are a very promising candidate! I think I have another mission for you. Are you interested?", cid)
			npcHandler.topic[playerId] = 11
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission04) == 1 then
			npcHandler:say("Do you bring all bones for our officers' safety fund at once?", cid)
			npcHandler.topic[playerId] = 13
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission05) == 3 then
			npcHandler:say("Splendid, I knew we could trust you. I would like to ask for your help in another matter. Are you interested?", cid)
			npcHandler.topic[playerId] = 16
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission07) == 8 then
			npcHandler:say("Once more you have impressed me! Are you willing to do another job?", cid)
			npcHandler.topic[playerId] = 21
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission06) >= 1 and player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission06) < 10 then
			npcHandler:say("First you need to complete your current mission.", cid)
			npcHandler.topic[playerId] = 0
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission06) == 12 then
			npcHandler:say("Excellent! Another job well done! Would you accept another mission?", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission06, 13)
			npcHandler.topic[playerId] = 28
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission06) == 10 then
			npcHandler:say("Fine, fine. I think that should do it. Tell Hugo that we order those uniforms. The completed dress pattern will soon arrive in Venore. Report to me when you have talked to him.", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission06, 11)
			npcHandler.topic[playerId] = 0
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission08) == 2 then
			npcHandler:say("So Waldo is dead? This is grave news indeed. Did you recover his posthorn?", cid)
			npcHandler.topic[playerId] = 23
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission09) == 3 then
			npcHandler:say("You did it? I hope you did not catch a flu in the cold! Anyway, there's another mission for you. Are you interested?", cid)
			npcHandler.topic[playerId] = 26
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission10) == 2 then
			npcHandler:say("You have delivered that letter? You are a true postofficer. All over the land bards shallpraise your name. There are no missions for you left right now.", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission10, 3)
			npcHandler.topic[playerId] = 0
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission10) == 3 and player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Rank) == 5 then
			npcHandler:say("There are no missions for you left right now. You already have the title of Archpostman.", cid)
			npcHandler.topic[playerId] = 0
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission10) == 3 and player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Rank) == 4 then
			npcHandler:say("There are no missions for you left right now. But you are worthy indeed. Do you want to advance in our guild?", cid)
			npcHandler.topic[playerId] = 27
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission08) == 3 and player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Rank) == 3 then
			npcHandler:say("So are you ready for another mission?", cid)
			npcHandler.topic[playerId] = 28
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission08) == 3 and player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Rank) == 4 then
			npcHandler:say("So are you ready for another mission?", cid)
			npcHandler.topic[playerId] = 25
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Rank) == 4 or player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Rank) == 3 and player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission09) == 0 then
			npcHandler:say("So are you ready for another mission?", cid)
			npcHandler.topic[playerId] = 25
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission07) < 1 and player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission06) == 13 and player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Rank) == 3 then
			npcHandler:say("Excellent! Another job well done! Would you accept another mission?", cid)
			npcHandler.topic[playerId] = 19
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission07) >= 1 and player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission06) == 13 and player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Rank) == 2 then
			npcHandler:say("Excellent! Another job well done! Would you accept another mission?", cid)
			npcHandler.topic[playerId] = 28
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission04) == 2 and player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Rank) == 2 then
			npcHandler:say("You have made it! We have enough bones for the fund! You remind me of myself when I was young! Interested in another mission?", cid)
			npcHandler.topic[playerId] = 15
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission04) == 2 and player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Rank) == 1 then
			npcHandler:say("You have made it! We have enough bones for the fund! You remind me of myself when I was young! Interested in another mission?", cid)
			npcHandler.topic[playerId] = 28
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission03) == 3 and player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission04) == 0 then
			npcHandler:say("You truly got him? Quite impressive. You are a very promising candidate! I think I have another mission for you. Are you interested?", cid)
			npcHandler.topic[playerId] = 11
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Rank) == 1 and player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission03) == 3 then
			npcHandler:say("So are you ready for another mission?", cid)
			npcHandler.topic[playerId] = 11
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission02) == 3 and player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Rank) == 1 then
			npcHandler:say("So are you ready for another mission?", cid)
			npcHandler.topic[playerId] = 10
		end
	elseif msgcontains(msg, "dress pattern") then
		if player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission06) == 2 then
			npcHandler:say("Oh yes, where did we get that from ...? Let's see, first ask the great technomancer in Kazordoon for the technical details. Return here afterwards.", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission06, 3)
			npcHandler.topic[playerId] = 0
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission06) == 4 then
			npcHandler:say("The mail with Talphion's instructions just arived. I remember we asked Queen Eloise of Carlin for the perfect colours. Go there, ask her about the UNIFORMS and report back here.", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission06, 5)
			npcHandler.topic[playerId] = 0
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission06) == 6 then
			npcHandler:say("The queen has sent me the samples we needed. The next part is tricky. We need theuniforms to emanate some odor that dogs hate.The dog with the best 'taste' in that field is Noodles,the dog of King Tibianus. Do you understand so far?", cid)
			npcHandler.topic[playerId] = 18
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission06) == 10 then
			npcHandler:say("Fine, fine. I think that should do it. Tell Hugo that we order those uniforms. The completed dress pattern will soon arrive in Venore. Report to me when you have talked to him.", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission06, 11)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "advancement") then
		if player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission04) == 2 and player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Rank) == 1 then
			npcHandler:say("You are worthy indeed. Do you want to advance in our guild?", cid)
			npcHandler.topic[playerId] = 14
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission06) == 13 and player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Rank) == 2 then
			npcHandler:say("You are worthy indeed. Do you want to advance in our guild?", cid)
			npcHandler.topic[playerId] = 20
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission08) == 3 and player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Rank) == 3 then
			npcHandler:say("You are worthy indeed. Do you want to advance in our guild?", cid)
			npcHandler.topic[playerId] = 24
		elseif player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission10) == 3 and player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Rank) == 4 then
			npcHandler:say("You are worthy indeed. Do you want to advance in our guild?", cid)
			npcHandler.topic[playerId] = 27
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say("Hm, I might consider your proposal, but first you will have to prove your worth by doing some tasks for us. Are you willing to do that?", cid)
			npcHandler.topic[playerId] = 2
		elseif npcHandler.topic[playerId] == 2 then
			npcHandler:say("Excellent! Your first task will be quite simple. But you should better write my instructions down anyways. You can read and write?", cid)
			npcHandler.topic[playerId] = 3
		elseif npcHandler.topic[playerId] == 3 then
			npcHandler:say("So listen, you will check certain tours our members have to take to see if there is some trouble. First travel with Captain Bluebear's ship from Thais to Carlin, understood?", cid)
			npcHandler.topic[playerId] = 4
		elseif npcHandler.topic[playerId] == 4 then
			npcHandler:say("Excellent! Once you have done that you will travel with Uzon to Edron. You will find him in the Femor Hills. Understood?", cid)
			npcHandler.topic[playerId] = 5
		elseif npcHandler.topic[playerId] == 5 then
			npcHandler:say("Fine, fine! Next, travel with Captain Seahorse to the city of Venore. Understood?", cid)
			npcHandler.topic[playerId] = 6
		elseif npcHandler.topic[playerId] == 6 then
			npcHandler:say("Good! Finally, find the technomancer Brodrosch and travel with him to the Isle of Cormaya. After this passage report back to me here. Understood?", cid)
			npcHandler.topic[playerId] = 7
		elseif npcHandler.topic[playerId] == 7 then
			npcHandler:say("Ok, remember: the Tibian mail service puts trust in you! Don't fail and report back soon. Just tell me about your {mission}.", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission01, 1)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 8 then
			npcHandler:say("I am glad to hear that. One of our mailboxes was reported to be jammed. It is located on the so called 'mountain' on theisle Folda. Get a crowbar and fix the mailbox. Report about your mission when you have done so.", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission01, 6)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission02, 1)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 9 then
			npcHandler:say("For your noble deeds I grant you the title Assistant Postofficer. All Postofficers will charge you less money from now on. After every second mission ask me for an ADVANCEMENT. Your next task will be a bit more challenging. Do you feel ready for it?", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Rank, 1)
			npcHandler.topic[playerId] = 10
		elseif npcHandler.topic[playerId] == 10 then
			npcHandler:say("I need you to deliver a bill to the stage magician David Brassacres. He's hiding from his creditors somewhere in Venore. It's likely you will have to trick him somehow to reveal his identity. Report back when you delivered this bill.", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission03, 1)
			player:addItem(3216, 1)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 11 then
			npcHandler:say("Ok, listen: we have some serious trouble with agressive dogs lately. We have accumulated some bones as a sort of pacifier but we need more. Collect 20 bones like the one in my room to the left and report here.", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission03, 3)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission04, 1)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 13 then
			if getPlayerBones(cid) >= 20 then
				doPlayerRemoveBones(cid)
				npcHandler:say("You have collected all the 20 bones needed. Excellent! Now let's talk about further missions if you are interested.", cid)
				player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission04, 2)
				npcHandler.topic[playerId] = 0
			else
				npcHandler.topic[playerId] = 0
				npcHandler:say("You don't have it...", cid)
			end
		elseif npcHandler.topic[playerId] == 14 then
			npcHandler:say("I grant you the title of postman. You are now a full member of our guild. Here have your own officers hat and wear it with pride.", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Rank, 2)
			player:addItem(3576, 1)
			npcHandler.topic[playerId] = 15
		elseif npcHandler.topic[playerId] == 15 then
			npcHandler:say("Since I am convinced I can trust you, this time you must deliver a valuable present to Dermot on Fibula. Do NOT open it!!! You will find the present behind the door here on the lower right side of this room.", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission05, 1)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 16 then
			npcHandler:say("Ok. We need a new set of uniforms, and only the best will do for us. Please travel to Venore and negotiate with Hugo Chief acontract for new uniforms.", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission05, 4)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission06, 1)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 18 then
			npcHandler:say("Good. Go there and find out what taste he dislikes most: mouldy cheese, a piece of fur or abananaskin. Tell him to SNIFF, then the object. Show him the object and ask 'Do you like that?'.DONT let the guards know what you are doing.", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission06, 7)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 19 then
			npcHandler:say("Good, so listen. Hugo Chief informed me that he needs the measurements of our postofficers. Go and bring me the measurements of Ben, Lokur, Dove, Liane, Chrystal and Olrik.", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission07, 1)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 20 then
			npcHandler:say("From now on it shall be known that you are a grand postman. You are now a privilegedmember until the end of days. Most captains around the world have an agreement with our guild to transport our privileged members, like you, for less gold.", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Rank, 3)
			npcHandler.topic[playerId] = 19
		elseif npcHandler.topic[playerId] == 21 then
			npcHandler:say("Ok but your next assignment might be dangerous. Our Courier Waldo has been missing for a while. I must assume he is dead. Can you follow me so far?", cid)
			npcHandler.topic[playerId] = 22
		elseif npcHandler.topic[playerId] == 22 then
			npcHandler:say("Find out about his whereabouts and retrieve him or at least his posthorn. He was looking for a new underground passage that is rumoured to be found underneath the troll-infested Mountain east of Thais.", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission07, 9)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission08, 1)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 23 then
			if player:removeItem(3219, 1) then
				npcHandler:say("Thank you. We will honour this. Your next mission will be a very special one. Good thing you are a special person as well. Are you ready?", cid)
				player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission08, 3)
				player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission09, 0)
				npcHandler.topic[playerId] = 28
			end
		elseif npcHandler.topic[playerId] == 24 then
			npcHandler:say("From now on you are a grand postman for special operations. You are an honoured member of our guild and earned the privilege of your own post horn. Here, take it.", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Rank, 4)
			player:addItem(3252, 1)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 25 then
			npcHandler:say("So listen well. Behind the lower left door you will find a bag. The letters in the bag are for none other than Santa Claus! Deliver them to his house on the isle of Vega, {use} thebag on his mailbox and report back here.", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission09, 1)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 26 then
			npcHandler:say("Excellent. Here is a letter for you to deliver. Well, to be honest, no one else volunteered. It's a letter from the mother of Markwin, the king of Mintwallin. Deliver that letter to him, but note that you will not be welcome there.", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission09, 4)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission10, 1)
			player:addItem(3220, 1)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 27 then
			npcHandler:say("I grant you the title of Archpostman. You are a legend in our guild. As privilege of your newly aquired status you are allowed to make use of certain mailboxes in dangerous areas. Just look out for them and you'll see.", cid)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Rank, 5)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Door, 1)
			player:addAchievement("Archpostman")
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 28 then
			npcHandler:say("Your eagerness is a virtue, young one, but first let's talk about advancement", cid)
			npcHandler.topic[playerId] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
