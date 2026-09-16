local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local ThreatenedDreams = Storage.Quest.U11_40.ThreatenedDreams
local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "mission") then
		if player:getStorageValue(ThreatenedDreams.Mission02[1]) < 1 then
			npcHandler:say("Some annoying nightmarish creatures rove about in the tunnels underneath this island. They are threatening the members of my court and devastate the flora and fauna. They also threaten the natural balance. Would you go and fight them for me?", cid)
			npcHandler.topic[playerId] = 1
		elseif player:getStorageValue(ThreatenedDreams.Mission02[1]) >= 1 and player:getStorageValue(ThreatenedDreams.Mission02[1]) <= 2 then
			npcHandler:say("Have you defeated the nightmare monsters?", cid)
			npcHandler.topic[playerId] = 2
		elseif player:getStorageValue(ThreatenedDreams.Mission02[1]) >= 3 and player:getStorageValue(ThreatenedDreams.Mission02[1]) <= 4 then
			npcHandler:say("Have you found the moon mirror and freed the captured fairies?", cid)
			npcHandler.topic[playerId] = 4
		elseif player:getStorageValue(ThreatenedDreams.Mission02[1]) == 5 and player:getStorageValue(ThreatenedDreams.Mission03[1]) == 4 then
			npcHandler:say("Have you already found the starlight vial and the sun catcher?", cid)
			npcHandler.topic[playerId] = 6
		elseif player:getStorageValue(ThreatenedDreams.Mission02[1]) == 6 then
			npcHandler:say("Could you already gather the three lights?", cid)
			npcHandler.topic[playerId] = 7
		elseif player:getStorageValue(ThreatenedDreams.Mission02[1]) == 7 then
			npcHandler:say("Have you repaired the magical barrier? Is Feyrist safe?", cid)
			npcHandler.topic[playerId] = 8
		else
			npcHandler:say("Thank you again, mortal being! The fae will be forever grateful.", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[playerId] == 1 then
			npcHandler:say("I knew you would be willing to help us. Kill two hundred of them as well as the terrible demon Kroazur who's leading them. That should bring some relief for the fae.", cid)
			player:setStorageValue(ThreatenedDreams.Mission02[1], 1)
			player:setStorageValue(ThreatenedDreams.Mission02.KroazurAccess, 1)
			player:setStorageValue(ThreatenedDreams.Mission02.EnfeebledCount, 0)
			player:setStorageValue(ThreatenedDreams.Mission02.FrazzlemawsCount, 0)
			player:setStorageValue(ThreatenedDreams.QuestLine, 2)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 2 then
			local enfeebledKills = player:getStorageValue(ThreatenedDreams.Mission02.EnfeebledCount)
			local frazzlemawsKills = player:getStorageValue(ThreatenedDreams.Mission02.FrazzlemawsCount)
			local kroazurKill = player:getStorageValue(ThreatenedDreams.Mission02.KroazurKill)
			if player:getStorageValue(ThreatenedDreams.Mission02[1]) == 1 and kroazurKill >= 1 and (enfeebledKills + frazzlemawsKills) >= 200 then
				npcHandler:say("Thank you! You rendered a great favour to the fae courts and Feyrist alike. Would you help us with another problem?", cid)
				npcHandler.topic[playerId] = 3
				player:setStorageValue(ThreatenedDreams.Mission02[1], 2)
			elseif player:getStorageValue(ThreatenedDreams.Mission02[1]) == 2 then
				npcHandler:say("You rendered a great favour to the fae courts and Feyrist alike. Would you help us with another problem?", cid)
				npcHandler.topic[playerId] = 3
			else
				npcHandler:say("You have to kill two hundred of nightmare creatures and the terrible demon Kroazur who's leading them. That should bring some relief for the fae.", cid)
				npcHandler.topic[playerId] = 0
			end
		elseif npcHandler.topic[playerId] == 3 then
			npcHandler:say({
				"Some of our siblings are tainted by the destructive energies that threaten Feyrist. They are darker now, more aggressive, twisted ... I'm sure you already met them. ...",
				"They are living in tunnels and caves but at night they surface, even attacking their own siblings. They kidnapped some fairies, holding them prisoner in their mouldy dens. ...",
				"And as if this wasn't enough they stole an ancient and precious artefact, the moon mirror. Please seek out the tainted fae, retrieve the artefact and free the captured fairies. ...",
				"You may discover the entrance to the tainted caves somewhere in the deep forest. The tainted fae like to hide their treasures in hollow logs or trumps, so have a closer look at them.",
			}, cid)
			player:setStorageValue(ThreatenedDreams.Mission02[1], 3)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 4 then
			if player:getStorageValue(ThreatenedDreams.Mission02.FairiesCounter) == 5 and player:getStorageValue(ThreatenedDreams.Mission02.DarkMoonMirror) == 1 then
				npcHandler:say("Thank you, mortal being! Please keep the mirror. I think you may need it soon, because there is another problem. Would you help us again?", cid)
				npcHandler.topic[playerId] = 5
				player:setStorageValue(ThreatenedDreams.Mission02[1], 4)
			elseif player:getStorageValue(ThreatenedDreams.Mission02[1]) == 4 then
				npcHandler:say("Please keep the mirror. I think you may need it soon, because there is another problem. Would you help us again?", cid)
				npcHandler.topic[playerId] = 5
			else
				npcHandler:say("Please seek out the tainted fae, retrieve the artefact and free the captured fairies.", cid)
				npcHandler.topic[playerId] = 0
			end
		elseif npcHandler.topic[playerId] == 5 then
			npcHandler:say({
				"You have to find three vessels that are able to hold three different types of light: starlight, sunlight and moon rays. You have already found the moon mirror but we also need the starlight vial and the sun catcher. ...",
				"Ask the mermaid Aurita for the starlight vial and the faun Taegen for the sun catcher.",
			}, cid)
			player:setStorageValue(ThreatenedDreams.Mission02[1], 5)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 6 then
			npcHandler:say({
				"Very good, mortal being! Now you have to catch the respective light and store it in the corresponding vessel. You can gather moon rays by night but this will only work on one special sacred glade on Feyrist. ...",
				"You can find this glade in the deep forest, east of our village. The starlight must also be gathered by night. There is a rock plateau high in the mountains at the border to Roshamuul where you can catch the starlight in the vial. ...",
				"You will recognise the place by the elemental energy shrine there. You have to gather the sunlight by day, of course. There is a beach in the north of Feyrist, shaped like a snake's head. There you may gather Suon's light with the sun catcher.",
			}, cid)
			player:setStorageValue(ThreatenedDreams.Mission02[1], 6)
			npcHandler.topic[playerId] = 0
		elseif npcHandler.topic[playerId] == 7 then
			if player:getItemCount(25734) >= 1 and player:getItemCount(25732) >= 1 and player:getItemCount(25730) >= 1 then
				npcHandler:say({
					"That's wonderful! Now you will be able to repair the magical barrier. You have to strengthen the arcane sources that power this mystic shield. There are three different arcane sources: the moon sculptures, the dream bird trees and the sun mosaics. ...",
					"There are five of each of them and you have to find them all to repair the barrier. Spread the gathered moon rays on the moon sculptures. Pour out the starlight over the dream bird trees and let the sunlight shine on the mosaics. ...",
					"If you charge all fifteen arcane sources with the respective light, Feyrist's protection will be ensured again.",
				}, cid)
				player:setStorageValue(ThreatenedDreams.Mission02[1], 7)
				npcHandler.topic[playerId] = 0
			else
				npcHandler:say("You have to catch the respective lights and store it in the corresponding vessel.", cid)
				npcHandler.topic[playerId] = 0
			end
		elseif npcHandler.topic[playerId] == 8 then
			if player:getStorageValue(ThreatenedDreams.Mission02.ChargedMoonMirror) == 0 and player:getStorageValue(ThreatenedDreams.Mission02.ChargedStarlightVial) == 0 and player:getStorageValue(ThreatenedDreams.Mission02.ChargedSunCatcher) == 0 then
				npcHandler:say("Thank you, mortal being! The fae will be forever grateful. Take this blossom bag as a little thank-you gift. Such blossoms grow on our trees just once in a decade, so they are quite rare.", cid)
				player:addItem(25780, 1)
				player:setStorageValue(ThreatenedDreams.Mission02[1], 8)
				npcHandler.topic[playerId] = 0
			else
				npcHandler:say("If you charge all fifteen arcane sources with the respective light, Feyrist's protection will be ensured again.", cid)
				npcHandler.topic[playerId] = 0
			end
		end
	elseif msgcontains(msg, "no") then
		npcHandler:say("Then not.", cid)
		npcHandler.topic[playerId] = 0
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Nature's blessings! Welcome to the land of dreams.")
npcHandler:setMessage(MESSAGE_FAREWELL, "May your path always be even.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "May your path always be even.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
