local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
 
function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end
function onPlayerEndTrade(cid)              npcHandler:onPlayerEndTrade(cid)            end
function onPlayerCloseChannel(cid)          npcHandler:onPlayerCloseChannel(cid)        end
 
function creatureSayCallback(cid, type, msg)
    if(not npcHandler:isFocused(cid)) then
        return false
    end
 
    local talkUser = cid
    local p = Player(cid)
    local heal = false
    local hp = p:getHealth()
   
    if msgcontains(msg, "heal") then
        if getCreatureCondition(cid, CONDITION_FIRE) then
            selfSay("You are burning. I will help you.", cid)
            doRemoveCondition(cid, CONDITION_FIRE)
            heal = true
        elseif getCreatureCondition(cid, CONDITION_POISON) then
            selfSay("You are poisoned. I will cure you.", cid)
            doRemoveCondition(cid, CONDITION_POISON)
            heal = true
        elseif getCreatureCondition(cid, CONDITION_ENERGY) then
            selfSay("You are electrificed. I will help you.", cid)
            doRemoveCondition(cid, CONDITION_ENERGY)
            heal = true
        elseif getCreatureCondition(cid, CONDITION_PARALYZE) then
            selfSay("You are paralyzed. I will cure you.", cid)
            doRemoveCondition(cid, CONDITION_PARALYZE)
            heal = true
        elseif getCreatureCondition(cid, CONDITION_DROWN) then
            selfSay("You are drowing. I will help you.", cid)
            doRemoveCondition(cid, CONDITION_DROWN)
            heal = true
        elseif getCreatureCondition(cid, CONDITION_FREEZING) then
            selfSay("You are cold! I will help you.", cid)
            doRemoveCondition(cid, CONDITION_FREEZING)
            heal = true
        elseif getCreatureCondition(cid, CONDITION_BLEEDING) then
            selfSay("You are bleeding! I will help you.", cid)
            doRemoveCondition(cid, CONDITION_BLEEDING)
            heal = true
        elseif getCreatureCondition(cid, CONDITION_DAZZLED) then
            selfSay("You are dazzled! Do not mess with holy creatures anymore!", cid)
            doRemoveCondition(cid, CONDITION_DAZZLED)
            heal = true
        elseif getCreatureCondition(cid, CONDITION_CURSED) then
            selfSay("You are cursed! I will remove it.", cid)
            doRemoveCondition(cid, CONDITION_CURSED)
            heal = true
        elseif hp < 65 then
            selfSay("You are looking really bad. Let me heal your wounds.", cid)
            p:addHealth(65 - hp)
            heal = true
        elseif hp < 2000 then
            selfSay("I did my best to fix your wounds.", cid)
            p:addHealth(2000 - hp)
            heal = true
        end
       
        if heal then
            p:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
        else
            local msgheal = {
                "You aren't looking really bad, " .. getCreatureName(cid) .. ". I only help in cases of real emergencies. Raise your health simply by eating {food}.",
                "Seriously? It's just a scratch",
                "Don't be a child. You don't need any help with your health.",
                "I'm not an expert. If you need help find a medic.",
                "Don't even waste my time, I have bigger problems than your scratched armor."
            }
            selfSay("" .. msgheal[math.random(1, #msgheal)] .. "", cid)
        end
    return true
    end
   
    if msgcontains(msg, "yes") and talkState[talkUser] > 90 and talkState[talkUser] < 96 then
        if getPlayerBlessing(cid, talkState[talkUser] - 90) then
            selfSay("You already have this blessing!", cid)
        else
            b_price = (4000 + ((math.min(130, getPlayerLevel(cid)) - 30) * 200))
            if b_price < 4000 then b_price = 4000 end
           
            if doPlayerRemoveMoney(cid, b_price) then
                selfSay("You have been blessed by one of the five gods!", cid)
                doPlayerAddBlessing(cid, talkState[talkUser] - 90)
                doSendMagicEffect(getThingPos(cid), CONST_ME_MAGIC_BLUE)
            else
                selfSay("I'm sorry. We need money to keep this temple up.", cid)
            end
        end
        talkState[talkUser] = 0
        return true
    end
   
    if msgcontains(msg, "yes") and talkState[talkUser] == 96 then
        havebless = {}
       
        for i = 1, 5 do
            if(getPlayerBlessing(cid, i)) then
                table.insert(havebless,i)
            end
        end
       
        if #havebless == 5 then
            selfSay('You already have all available blessings.',cid)
            talkState[talkUser] = 0
            return true
        end
       
        b_price = (4000 + ((math.min(130, getPlayerLevel(cid)) - 30) * 200))
        if b_price < 4000 then b_price = 4000 end
        b_price = ((5 - #havebless) * b_price)
       
        if doPlayerRemoveMoney(cid, b_price) then
            selfSay("You have been blessed by the five gods!", cid)
            for i = 1, 5 do doPlayerAddBlessing(cid, i) end
            doSendMagicEffect(getThingPos(cid), CONST_ME_MAGIC_BLUE)
        else
            selfSay("I'm sorry. We need money to keep this temple up.", cid)
        end
           
        talkState[talkUser] = 0
        return true
    end
   
    if msgcontains(msg, "blessings") then
        havebless = {}
        b_price = (4000 + ((math.min(130, getPlayerLevel(cid)) - 30) * 200))
        if b_price < 4000 then b_price = 4000 end
       
        for i = 1, 5 do
            if(getPlayerBlessing(cid, i)) then
                table.insert(havebless,i)
            end
        end
       
        b_price = ((5 - #havebless) * b_price)
       
        if b_price == 0 then
            selfSay('You already have all available blessings.',cid)
            talkState[talkUser] = 0
            return true
        end
       
        selfSay('Do you want to receive all blessings for ' .. b_price .. ' gold?',cid)
        talkState[talkUser] = 96
        return true
    end
   
    local blesskeywords = {'wisdom', 'spark', 'fire', 'spiritual', 'embrace'}
    local blessnames = {'Wisdom of Solitude', 'Spark of The Phoenix', 'Fire of Two Suns', 'Spiritual Shielding', 'The Embrace'}
    for i = 1, #blesskeywords do
        if msgcontains(msg, blesskeywords[i]) then
       
            b_price = (4000 + ((math.min(130, getPlayerLevel(cid)) - 30) * 200))
            if b_price < 4000 then b_price = 4000 end
           
            selfSay('Do you want me to grant you ' .. blessnames[i] .. ' blessing for ' .. b_price .. ' gold?',cid)
            talkState[talkUser] = 90 + i
            return true
        end
    end
   
    return true
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())