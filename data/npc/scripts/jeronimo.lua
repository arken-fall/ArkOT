 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
 
function onCreatureAppear(cid)    npcHandler:onCreatureAppear(cid)   end
function onCreatureDisappear(cid)   npcHandler:onCreatureDisappear(cid)   end
function onCreatureSay(cid, type, msg)   npcHandler:onCreatureSay(cid, type, msg)  end
function onThink()     npcHandler:onThink()     end
 
local items = {
          item1 = {21399, 13030}, -- item1 item que será pedido e que será dado na primeira troca
          item2 = {21399, 11144}, -- item2 item que será pedido e que será dado na segunda troca
		  item3 = {21399, 12544}, -- item3 item que será pedido e que será dado na segunda troca
		  item4 = {21399, 2361}, -- item3 item que será pedido e que será dado na segunda troca		  
		  item5 = {21399, 10511}, -- item3 item que será pedido e que será dado na segunda troca
		  item6 = {21399, 10513}, -- item3 item que será pedido e que será dado na segunda troca
		  item7 = {21399, 10515}, -- item3 item que será pedido e que será dado na segunda troca
		  item8 = {21399, 2798}, -- item3 item que será pedido e que será dado na segunda troca
		  item9 = {21399, 20620}, -- item3 item que será pedido e que será dado na segunda troca		  
		  item10 = {21399, 16105}, -- item3 item que será pedido e que será dado na segunda troca
		  item11 = {21399, 24809}, -- item3 item que será pedido e que será dado na segunda troca
		  item12 = {21399, 10455}, -- item3 item que será pedido e que será dado na segunda troca
		  item13 = {21399, 24777}, -- item3 item que será pedido e que será dado na segunda troca
		  item14 = {21399, 24317}, -- item3 item que será pedido e que será dado na segunda troca
		  item15 = {21399, 22396}, -- item3 item que será pedido e que será dado na segunda troca
		  item16 = {21399, 18411}, -- item3 item que será pedido e que será dado na segunda troca
		  item17 = {21399, 18409}, -- item3 item que será pedido e que será dado na segunda troca
		  item18 = {21399, 2400}, -- item3 item que será pedido e que será dado na segunda troca
		  item19 = {21399, 2431}, -- item3 item que será pedido e que será dado na segunda troca
		  item20 = {21399, 8928}, -- item3 item que será pedido e que será dado na segunda troca
		  item21 = {21399, 18453}, -- item3 item que será pedido e que será dado na segunda troca
		 -- item22 = {21399, 2358}, -- item3 item que será pedido e que será dado na segunda troca
		  item23 = {21399, 2160} -- item3 item que será pedido e que será dado na segunda troca
		 
}
local counts = {
          count1 = {15, 1}, -- count1 quantidade que será pedido e que será dado na primeira troca
          count2 = {10, 1}, -- count2 quantidade que será pedido e que será dado na segunda troca
		  count3 = {10, 1}, -- count3 quantidade que será pedido e que será dado na segunda troca
		  count4 = {8, 1}, -- count4 quantidade que será pedido e que será dado na segunda troca		  
		  count5 = {10, 1}, -- count4 quantidade que será pedido e que será dado na segunda troca
		  count6 = {10, 1}, -- count4 quantidade que será pedido e que será dado na segunda troca
		  count7 = {10, 1}, -- count4 quantidade que será pedido e que será dado na segunda troca
		  count8 = {10, 1}, -- count4 quantidade que será pedido e que será dado na segunda troca
		  count9 = {10, 1}, -- count4 quantidade que será pedido e que será dado na segunda troca		  
		  count10 = {10, 1}, -- count4 quantidade que será pedido e que será dado na segunda troca
		  count11 = {15, 1}, -- count4 quantidade que será pedido e que será dado na segunda troca
		  count12 = {7, 1}, -- count4 quantidade que será pedido e que será dado na segunda troca
		  count13 = {15, 1}, -- count4 quantidade que será pedido e que será dado na segunda troca
		  count14 = {15, 1}, -- count4 quantidade que será pedido e que será dado na segunda troca
		  count15 = {10, 1}, -- count4 quantidade que será pedido e que será dado na segunda troca
		  count16 = {5, 1}, -- count4 quantidade que será pedido e que será dado na segunda troca
		  count17 = {5, 1}, -- count4 quantidade que será pedido e que será dado na segunda troca
		  count18 = {5, 1}, -- count4 quantidade que será pedido e que será dado na segunda troca
		  count19 = {5, 1}, -- count4 quantidade que será pedido e que será dado na segunda troca
		  count20 = {5, 1}, -- count4 quantidade que será pedido e que será dado na segunda troca
		  count21 = {5, 1}, -- count4 quantidade que será pedido e que será dado na segunda troca
		--  count22 = {170, 1}, -- count4 quantidade que será pedido e que será dado na segunda troc
		  count23 = {1, 10} -- count4 quantidade que será pedido e que será dado na segunda troc
		 
}
 
function creatureSayCallback(cid, type, msg)
          if(not npcHandler:isFocused(cid)) then
                    return false
          end
          local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

          if  msgcontains(msg, 'remover skull') then
                    if getPlayerItemCount(cid, items.item2[1]) >= counts.count2[1] then
                              doPlayerRemoveItem(cid, items.item2[1], counts.count2[1])
                              doPlayerAddItem(cid, items.item2[2], counts.count2[2])
                              selfSay('You just swap '.. counts.count2[1] ..' '.. getItemName(items.item2[1]) ..' for '.. counts.count2[2] ..' '.. getItemName(items.item2[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count2[1] ..' '.. getItemName(items.item2[1]) ..'.', cid)
                    end
					
					elseif msgcontains(msg, 'refill stamina') then
                    if getPlayerItemCount(cid, items.item3[1]) >= counts.count3[1] then
                              doPlayerRemoveItem(cid, items.item3[1], counts.count3[1])
                              doPlayerAddItem(cid, items.item3[2], counts.count3[2])
                              selfSay('You just swap '.. counts.count3[1] ..' '.. getItemName(items.item3[1]) ..' for '.. counts.count3[2] ..' '.. getItemName(items.item3[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count3[1] ..' '.. getItemName(items.item3[1]) ..'.', cid)
                    end
					
					elseif msgcontains(msg, 'frozen starlight') then
                    if getPlayerItemCount(cid, items.item4[1]) >= counts.count4[1] then
                              doPlayerRemoveItem(cid, items.item4[1], counts.count4[1])
                              doPlayerAddItem(cid, items.item4[2], counts.count4[2])
                              selfSay('You just swap '.. counts.count4[1] ..' '.. getItemName(items.item4[1]) ..' for '.. counts.count4[2] ..' '.. getItemName(items.item4[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count4[1] ..' '.. getItemName(items.item4[1]) ..'.', cid)
                    end
					
					elseif msgcontains(msg, 'sneaky stabber of eliteness') then
                    if getPlayerItemCount(cid, items.item5[1]) >= counts.count5[1] then
                              doPlayerRemoveItem(cid, items.item5[1], counts.count5[1])
                              doPlayerAddItem(cid, items.item5[2], counts.count5[2])
                              selfSay('You just swap '.. counts.count5[1] ..' '.. getItemName(items.item5[1]) ..' for '.. counts.count5[2] ..' '.. getItemName(items.item5[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count5[1] ..' '.. getItemName(items.item5[1]) ..'.', cid)
                    end
					
					elseif msgcontains(msg, 'squeezing gear of girlpower') then
                    if getPlayerItemCount(cid, items.item6[1]) >= counts.count6[1] then
                              doPlayerRemoveItem(cid, items.item6[1], counts.count6[1])
                              doPlayerAddItem(cid, items.item6[2], counts.count6[2])
                              selfSay('You just swap '.. counts.count6[1] ..' '.. getItemName(items.item6[1]) ..' for '.. counts.count6[2] ..' '.. getItemName(items.item6[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count6[1] ..' '.. getItemName(items.item6[1]) ..'.', cid)
                    end
					
					elseif msgcontains(msg, 'whacking driller of fate') then
                    if getPlayerItemCount(cid, items.item7[1]) >= counts.count7[1] then
                              doPlayerRemoveItem(cid, items.item7[1], counts.count7[1])
                              doPlayerAddItem(cid, items.item7[2], counts.count7[2])
                              selfSay('You just swap '.. counts.count7[1] ..' '.. getItemName(items.item7[1]) ..' for '.. counts.count7[2] ..' '.. getItemName(items.item7[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count7[1] ..' '.. getItemName(items.item7[1]) ..'.', cid)
                    end
					
					elseif msgcontains(msg, 'blood herb') then
                    if getPlayerItemCount(cid, items.item8[1]) >= counts.count8[1] then
                              doPlayerRemoveItem(cid, items.item8[1], counts.count8[1])
                              doPlayerAddItem(cid, items.item8[2], counts.count8[2])
                              selfSay('You just swap '.. counts.count8[1] ..' '.. getItemName(items.item8[1]) ..' for '.. counts.count8[2] ..' '.. getItemName(items.item8[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count8[1] ..' '.. getItemName(items.item8[1]) ..'.', cid)
                    end
					
					elseif msgcontains(msg, 'zaoan chess box') then
                    if getPlayerItemCount(cid, items.item9[1]) >= counts.count9[1] then
                              doPlayerRemoveItem(cid, items.item9[1], counts.count9[1])
                              doPlayerAddItem(cid, items.item9[2], counts.count9[2])
                              selfSay('You just swap '.. counts.count9[1] ..' '.. getItemName(items.item9[1]) ..' for '.. counts.count9[2] ..' '.. getItemName(items.item9[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count9[1] ..' '.. getItemName(items.item9[1]) ..'.', cid)
                    end
					
					-- Dolls 
					elseif msgcontains(msg, 'medusa skull') then
                    if getPlayerItemCount(cid, items.item10[1]) >= counts.count10[1] then
                              doPlayerRemoveItem(cid, items.item10[1], counts.count10[1])
                              doPlayerAddItem(cid, items.item10[2], counts.count10[2])
                              selfSay('You just swap '.. counts.count10[1] ..' '.. getItemName(items.item10[1]) ..' for '.. counts.count10[2] ..' '.. getItemName(items.item10[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count10[1] ..' '.. getItemName(items.item10[1]) ..'.', cid)
                    end
					
					elseif msgcontains(msg, 'dark wizards crown') then
                    if getPlayerItemCount(cid, items.item11[1]) >= counts.count11[1] then
                              doPlayerRemoveItem(cid, items.item11[1], counts.count11[1])
                              doPlayerAddItem(cid, items.item11[2], counts.count11[2])
                              selfSay('You just swap '.. counts.count11[1] ..' '.. getItemName(items.item11[1]) ..' for '.. counts.count11[2] ..' '.. getItemName(items.item11[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count11[1] ..' '.. getItemName(items.item11[1]) ..'.', cid)
                    end
					
					elseif msgcontains(msg, 'pigeon trophy') then
                    if getPlayerItemCount(cid, items.item12[1]) >= counts.count12[1] then
                              doPlayerRemoveItem(cid, items.item12[1], counts.count12[1])
                              doPlayerAddItem(cid, items.item12[2], counts.count12[2])
                              selfSay('You just swap '.. counts.count12[1] ..' '.. getItemName(items.item12[1]) ..' for '.. counts.count12[2] ..' '.. getItemName(items.item12[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count12[1] ..' '.. getItemName(items.item12[1]) ..'.', cid)
                    end
					
					elseif msgcontains(msg, 'little adventurer doll') then
                    if getPlayerItemCount(cid, items.item13[1]) >= counts.count13[1] then
                              doPlayerRemoveItem(cid, items.item13[1], counts.count13[1])
                              doPlayerAddItem(cid, items.item13[2], counts.count13[2])
                              selfSay('You just swap '.. counts.count13[1] ..' '.. getItemName(items.item13[1]) ..' for '.. counts.count13[2] ..' '.. getItemName(items.item13[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count13[1] ..' '.. getItemName(items.item13[1]) ..'.', cid)
                    end
					
					elseif msgcontains(msg, 'midnight panther doll') then
                    if getPlayerItemCount(cid, items.item14[1]) >= counts.count14[1] then
                              doPlayerRemoveItem(cid, items.item14[1], counts.count14[1])
                              doPlayerAddItem(cid, items.item14[2], counts.count14[2])
                              selfSay('You just swap '.. counts.count14[1] ..' '.. getItemName(items.item14[1]) ..' for '.. counts.count14[2] ..' '.. getItemName(items.item14[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count14[1] ..' '.. getItemName(items.item14[1]) ..'.', cid)
                    end
					
					-- cluster
					elseif msgcontains(msg, 'cluster of solace') then
                    if getPlayerItemCount(cid, items.item15[1]) >= counts.count15[1] then
                              doPlayerRemoveItem(cid, items.item15[1], counts.count15[1])
                              doPlayerAddItem(cid, items.item15[2], counts.count15[2])
                              selfSay('You just swap '.. counts.count15[1] ..' '.. getItemName(items.item15[1]) ..' for '.. counts.count15[2] ..' '.. getItemName(items.item15[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count15[1] ..' '.. getItemName(items.item15[1]) ..'.', cid)
                    end
					-- cluster end
					
					-- muck
					elseif msgcontains(msg, 'muck rod') then
                    if getPlayerItemCount(cid, items.item16[1]) >= counts.count16[1] then
                              doPlayerRemoveItem(cid, items.item16[1], counts.count16[1])
                              doPlayerAddItem(cid, items.item16[2], counts.count16[2])
                              selfSay('You just swap '.. counts.count16[1] ..' '.. getItemName(items.item16[1]) ..' for '.. counts.count16[2] ..' '.. getItemName(items.item16[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count16[1] ..' '.. getItemName(items.item16[1]) ..'.', cid)
                    end
					-- muck end
					
					-- Wand of Everblazing
					elseif msgcontains(msg, 'wand of everblazing') then
                    if getPlayerItemCount(cid, items.item17[1]) >= counts.count17[1] then
                              doPlayerRemoveItem(cid, items.item17[1], counts.count17[1])
                              doPlayerAddItem(cid, items.item17[2], counts.count17[2])
                              selfSay('You just swap '.. counts.count17[1] ..' '.. getItemName(items.item17[1]) ..' for '.. counts.count17[2] ..' '.. getItemName(items.item17[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count17[1] ..' '.. getItemName(items.item17[1]) ..'.', cid)
                    end
					-- Wand of Everblazing end
					
					-- sov
					elseif msgcontains(msg, 'magic sword') then
                    if getPlayerItemCount(cid, items.item18[1]) >= counts.count18[1] then
                              doPlayerRemoveItem(cid, items.item18[1], counts.count18[1])
                              doPlayerAddItem(cid, items.item18[2], counts.count18[2])
                              selfSay('You just swap '.. counts.count18[1] ..' '.. getItemName(items.item18[1]) ..' for '.. counts.count18[2] ..' '.. getItemName(items.item18[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count18[1] ..' '.. getItemName(items.item18[1]) ..'.', cid)
                    end
					-- sov
					
					-- sca
					elseif msgcontains(msg, 'stonecutter axe') then
                    if getPlayerItemCount(cid, items.item19[1]) >= counts.count19[1] then
                              doPlayerRemoveItem(cid, items.item19[1], counts.count19[1])
                              doPlayerAddItem(cid, items.item19[2], counts.count19[2])
                              selfSay('You just swap '.. counts.count19[1] ..' '.. getItemName(items.item19[1]) ..' for '.. counts.count19[2] ..' '.. getItemName(items.item19[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count19[1] ..' '.. getItemName(items.item19[1]) ..'.', cid)
                    end
					-- sca
					
					-- obt
					elseif msgcontains(msg, 'obsidian truncheon') then
                    if getPlayerItemCount(cid, items.item20[1]) >= counts.count20[1] then
                              doPlayerRemoveItem(cid, items.item20[1], counts.count20[1])
                              doPlayerAddItem(cid, items.item20[2], counts.count20[2])
                              selfSay('You just swap '.. counts.count20[1] ..' '.. getItemName(items.item20[1]) ..' for '.. counts.count20[2] ..' '.. getItemName(items.item20[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count20[1] ..' '.. getItemName(items.item20[1]) ..'.', cid)
                    end
					-- obt
					
					-- xbow
					elseif msgcontains(msg, 'crystal crossbow') then
                    if getPlayerItemCount(cid, items.item21[1]) >= counts.count21[1] then
                              doPlayerRemoveItem(cid, items.item21[1], counts.count21[1])
                              doPlayerAddItem(cid, items.item21[2], counts.count21[2])
                              selfSay('You just swap '.. counts.count21[1] ..' '.. getItemName(items.item21[1]) ..' for '.. counts.count21[2] ..' '.. getItemName(items.item21[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count21[1] ..' '.. getItemName(items.item21[1]) ..'.', cid)
                    end
					-- xbow
					
					--[[
					elseif msgcontains(msg, 'viking boots') then
                    if getPlayerItemCount(cid, items.item22[1]) >= counts.count22[1] then
                              doPlayerRemoveItem(cid, items.item22[1], counts.count22[1])
                              doPlayerAddItem(cid, items.item22[2], counts.count22[2])
                              selfSay('You just swap '.. counts.count22[1] ..' '.. getItemName(items.item22[1]) ..' for '.. counts.count22[2] ..' '.. getItemName(items.item22[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count22[1] ..' '.. getItemName(items.item22[1]) ..'.', cid)
                    end
					]]-- viking
					
					-- crystal
					elseif msgcontains(msg, 'crystal coins') then
                    if getPlayerItemCount(cid, items.item23[1]) >= counts.count23[1] then
                              doPlayerRemoveItem(cid, items.item23[1], counts.count23[1])
                              doPlayerAddItem(cid, items.item23[2], counts.count23[2])
                              selfSay('You just swap '.. counts.count23[1] ..' '.. getItemName(items.item23[1]) ..' for '.. counts.count23[2] ..' '.. getItemName(items.item23[2]) ..'.', cid)
                    else
                              selfSay('You need '.. counts.count23[1] ..' '.. getItemName(items.item23[1]) ..' to exchange for 100k.', cid)
                    end
					-- crystal
					
					
					
          end
		  
          return TRUE
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())