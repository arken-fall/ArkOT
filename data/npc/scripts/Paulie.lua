local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()		npcHandler:onThink()		end

local voices = {
	{text = 'Don\'t forget to deposit your money here in the Global Bank before you head out for adventure.'}
}
npcHandler:addModule(VoiceModule:new(voices))

local count = {}

local function greetCallback(cid)
	local playerId = cid:getId()
	local player = Player(cid)
	-- Mission 8: The Rookie Guard Quest
	if player:getStorageValue(Storage.Quest.U9_1.TheRookieGuard.Mission08) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Welcome |PLAYERNAME|! Special newcomer offer, today only! Deposit some money - or {deposit ALL} of your money! - and get 50 gold for free!")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Yes? What may I do for you, |PLAYERNAME|? Bank business, perhaps?")
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	local player = Player(cid)
	local playerId = cid

	if not npcHandler:isFocused(cid) then
		return false
	end

	--Help
	if msgcontains(msg, "bank account") then
		npcHandler:say({
			"Every Adventurer has one. \z
					The big advantage is that you can access your money in every branch of the World Bank! ...",
			"Would you like to know more about the {basic} functions of your bank account, the {advanced} functions, \z
					or are you already bored, perhaps?",
		}, cid, 10)
		npcHandler.topic[playerId] = 0
		return true
		--Balance
	elseif msgcontains(msg, "balance") then
		npcHandler.topic[playerId] = 0
		if player:getBankBalance() >= 100000000 then
			npcHandler:say("I think you must be one of the richest inhabitants in the world! \z
				Your account balance is " .. player:getBankBalance() .. " gold.", cid)
			return true
		elseif player:getBankBalance() >= 10000000 then
			npcHandler:say("You have made ten millions and it still grows! Your account balance is \z
				" .. player:getBankBalance() .. " gold.", cid)
			return true
		elseif player:getBankBalance() >= 1000000 then
			npcHandler:say("Wow, you have reached the magic number of a million gp!!! \z
				Your account balance is " .. player:getBankBalance() .. " gold!", cid)
			return true
		elseif player:getBankBalance() >= 100000 then
			npcHandler:say("You certainly have made a pretty penny. Your account balance is \z
				" .. player:getBankBalance() .. " gold.", cid)
			return true
		else
			npcHandler:say("Your account balance is " .. player:getBankBalance() .. " gold.", cid)
			return true
		end
		--Deposit
	elseif msgcontains(msg, "deposit") then
		count[playerId] = player:getMoney()
		if count[playerId] < 1 then
			npcHandler:say("You do not have enough gold.", cid)
			npcHandler.topic[playerId] = 0
			return false
		elseif not isValidMoney(count[playerId]) then
			npcHandler:say("Sorry, but you can't deposit that much.", cid)
			npcHandler.topic[playerId] = 0
			return false
		end
		if msgcontains(msg, "all") then
			count[playerId] = player:getMoney()
			npcHandler:say("Would you really like to deposit " .. count[playerId] .. " gold?", cid)
			npcHandler.topic[playerId] = 2
			return true
		else
			if string.match(msg, "%d+") then
				count[playerId] = getMoneyCount(msg)
				if count[playerId] < 1 then
					npcHandler:say("You do not have enough gold.", cid)
					npcHandler.topic[playerId] = 0
					return false
				end
				npcHandler:say("Would you really like to deposit " .. count[playerId] .. " gold?", cid)
				npcHandler.topic[playerId] = 2
				return true
			else
				npcHandler:say("Please tell me how much gold it is you would like to deposit.", cid)
				npcHandler.topic[playerId] = 1
				return true
			end
		end
	elseif npcHandler.topic[playerId] == 1 then
		count[playerId] = getMoneyCount(msg)
		if isValidMoney(count[playerId]) then
			npcHandler:say("Would you really like to deposit " .. count[playerId] .. " gold?", cid)
			npcHandler.topic[playerId] = 2
			return true
		else
			npcHandler:say("You do not have enough gold.", cid)
			npcHandler.topic[playerId] = 0
			return true
		end
	elseif npcHandler.topic[playerId] == 2 then
		if msgcontains(msg, "yes") then
			if player:getStorageValue(Storage.Quest.U9_1.TheRookieGuard.Mission08) == 1 then
				player:depositMoney(count[playerId])
				Bank.credit(player, 50)
				npcHandler:say("Alright, we have added the amount of " .. count[playerId] .. " +50 gold to your {balance} - that is the money you deposited plus a bonus of 50 gold. \z
				Thank you! You can withdraw your money anytime.", cid)
				player:setStorageValue(Storage.Quest.U9_1.TheRookieGuard.Mission08, 2)
				npcHandler.topic[playerId] = 0
				return false
			end
			if player:depositMoney(count[playerId]) then
				npcHandler:say("Alright, we have added the amount of " .. count[playerId] .. " gold to your {balance}. \z
				You can {withdraw} your money anytime you want to.", cid)
			else
				npcHandler:say("You do not have enough gold.", cid)
			end
		elseif msgcontains(msg, "no") then
			npcHandler:say("As you wish. Is there something else I can do for you?", cid)
		end
		npcHandler.topic[playerId] = 0
		return true
		--Withdraw
	elseif msgcontains(msg, "withdraw") then
		if string.match(msg, "%d+") then
			count[playerId] = getMoneyCount(msg)
			if isValidMoney(count[playerId]) then
				npcHandler:say("Are you sure you wish to withdraw " .. count[playerId] .. " gold from your bank account?", cid)
				npcHandler.topic[playerId] = 7
			else
				npcHandler:say("There is not enough gold on your account.", cid)
				npcHandler.topic[playerId] = 0
			end
			return true
		else
			npcHandler:say("Please tell me how much gold you would like to withdraw.", cid)
			npcHandler.topic[playerId] = 6
			return true
		end
	elseif npcHandler.topic[playerId] == 6 then
		count[playerId] = getMoneyCount(msg)
		if isValidMoney(count[playerId]) then
			npcHandler:say("Are you sure you wish to withdraw " .. count[playerId] .. " gold from your bank account?", cid)
			npcHandler.topic[playerId] = 7
		else
			npcHandler:say("There is not enough gold on your account.", cid)
			npcHandler.topic[playerId] = 0
		end
		return true
	elseif npcHandler.topic[playerId] == 7 then
		if msgcontains(msg, "yes") then
			if player:getFreeCapacity() >= getMoneyWeight(count[playerId]) then
				if not player:withdrawMoney(count[playerId]) then
					npcHandler:say("There is not enough gold on your account.", cid)
				else
					npcHandler:say("Here you are, " .. count[playerId] .. " gold. \z
						Please let me know if there is something else I can do for you.", cid)
				end
			else
				npcHandler:say(
					"Whoah, hold on, you have no room in your inventory to carry all those coins. \z
					I don't want you to drop it on the floor, maybe come back with a cart!", cid
				)
			end
			npcHandler.topic[playerId] = 0
		elseif msgcontains(msg, "no") then
			npcHandler:say("The customer is king! Come back anytime you want to if you wish to {withdraw} your money.", cid)
			npcHandler.topic[playerId] = 0
		end
		return true
		--Money exchange
	elseif msgcontains(msg, "change gold") then
		npcHandler:say("How many platinum coins would you like to get?", cid)
		npcHandler.topic[playerId] = 14
	elseif npcHandler.topic[playerId] == 14 then
		if getMoneyCount(msg) < 1 then
			npcHandler:say("Sorry, you do not have enough gold coins.", cid)
			npcHandler.topic[playerId] = 0
		else
			count[playerId] = getMoneyCount(msg)
			npcHandler:say("So you would like me to change " .. count[playerId] * 100 .. " of your gold \z
				coins into " .. count[playerId] .. " platinum coins?", cid)
			npcHandler.topic[playerId] = 15
		end
	elseif npcHandler.topic[playerId] == 15 then
		if msgcontains(msg, "yes") then
			if player:removeItem(3031, count[playerId] * 100) then
				player:addItem(3035, count[playerId])
				npcHandler:say("Here you are.", cid)
			else
				npcHandler:say("Sorry, you do not have enough gold coins.", cid)
			end
		else
			npcHandler:say("Well, can I help you with something else?", cid)
		end
		npcHandler.topic[playerId] = 0
	elseif msgcontains(msg, "change platinum") then
		npcHandler:say("Would you like to change your platinum coins into gold or crystal?", cid)
		npcHandler.topic[playerId] = 16
	elseif npcHandler.topic[playerId] == 16 then
		if msgcontains(msg, "gold") then
			npcHandler:say("How many platinum coins would you like to change into gold?", cid)
			npcHandler.topic[playerId] = 17
		elseif msgcontains(msg, "crystal") then
			npcHandler:say("How many crystal coins would you like to get?", cid)
			npcHandler.topic[playerId] = 19
		else
			npcHandler:say("Well, can I help you with something else?", cid)
			npcHandler.topic[playerId] = 0
		end
	elseif npcHandler.topic[playerId] == 17 then
		if getMoneyCount(msg) < 1 then
			npcHandler:say("Sorry, you do not have enough platinum coins.", cid)
			npcHandler.topic[playerId] = 0
		else
			count[playerId] = getMoneyCount(msg)
			npcHandler:say("So you would like me to change " .. count[playerId] .. " of your platinum \z
				coins into " .. count[playerId] * 100 .. " gold coins for you?", cid)
			npcHandler.topic[playerId] = 18
		end
	elseif npcHandler.topic[playerId] == 18 then
		if msgcontains(msg, "yes") then
			if player:removeItem(3035, count[playerId]) then
				player:addItem(3031, count[playerId] * 100)
				npcHandler:say("Here you are.", cid)
			else
				npcHandler:say("Sorry, you do not have enough platinum coins.", cid)
			end
		else
			npcHandler:say("Well, can I help you with something else?", cid)
		end
		npcHandler.topic[playerId] = 0
	elseif npcHandler.topic[playerId] == 19 then
		if getMoneyCount(msg) < 1 then
			npcHandler:say("Sorry, you do not have enough platinum coins.", cid)
			npcHandler.topic[playerId] = 0
		else
			count[playerId] = getMoneyCount(msg)
			npcHandler:say("So you would like me to change " .. count[playerId] * 100 .. " of your platinum coins \z
				into " .. count[playerId] .. " crystal coins for you?", cid)
			npcHandler.topic[playerId] = 20
		end
	elseif npcHandler.topic[playerId] == 20 then
		if msgcontains(msg, "yes") then
			if player:removeItem(3035, count[playerId] * 100) then
				player:addItem(3043, count[playerId])
				npcHandler:say("Here you are.", cid)
			else
				npcHandler:say("Sorry, you do not have enough platinum coins.", cid)
			end
		else
			npcHandler:say("Well, can I help you with something else?", cid)
		end
		npcHandler.topic[playerId] = 0
	elseif msgcontains(msg, "change crystal") then
		npcHandler:say("How many crystal coins would you like to change into platinum?", cid)
		npcHandler.topic[playerId] = 21
	elseif npcHandler.topic[playerId] == 21 then
		if getMoneyCount(msg) < 1 then
			npcHandler:say("Sorry, you do not have enough crystal coins.", cid)
			npcHandler.topic[playerId] = 0
		else
			count[playerId] = getMoneyCount(msg)
			npcHandler:say("So you would like me to change " .. count[playerId] .. " of your crystal coins \z
				into " .. count[playerId] * 100 .. " platinum coins for you?", cid)
			npcHandler.topic[playerId] = 22
		end
	elseif npcHandler.topic[playerId] == 22 then
		if msgcontains(msg, "yes") then
			if player:removeItem(3043, count[playerId]) then
				player:addItem(3035, count[playerId] * 100)
				npcHandler:say("Here you are.", cid)
			else
				npcHandler:say("Sorry, you do not have enough crystal coins.", cid)
			end
		else
			npcHandler:say("Well, can I help you with something else?", cid)
		end
		npcHandler.topic[playerId] = 0
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setMessage(MESSAGE_FAREWELL, "Have a nice day.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Have a nice day.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
