local items = {}

-- Cigaret pakke Menu
local pakkeryge_choices = {}
pakkeryge_choices["> Tag cigaretter"] = {function(player,choice)
    local user_id = vRP.getUserId(player)

    if user_id ~= nil then
        if vRP.tryGetInventoryItem(user_id,"cigaretpakke",1) then
            vRP.giveInventoryItem(user_id,"cigaret",20,true)
            vRP.closeMenu(player)
        end
    end
end}

-- Cigaret Menu
local ryge_choices = {}
ryge_choices["> Ryg cigaret"] = {function(player,choice)
    local user_id = vRP.getUserId(player)

    if user_id ~= nil then
        if vRP.tryGetInventoryItem(user_id,"cigaret",1) then
            vRPclient.playAnim(player,{false,{task="WORLD_HUMAN_SMOKING"},false})
            vRP.closeMenu(player)
        end
    end
end}
-- joint Menu
local function play_lighter(player)
    local seq2 = {
        {"bar_1_rcm_p2-1","cs_mich1_lighter_sparks-1",1},
        {"bar_1_rcm_p2-2","cs_mich1_lighter_sparks-2",1},
        {"bar_1_rcm_p2-3","cs_mich1_lighter_sparks-3",1},
        {"bar_1_rcm_p2-0","cs_mich1_lighter_flame-0",1},
        {"bar_1_rcm_p2-5","cs_mich1_lighter_flame-5",1},
        {"bar_1_rcm_p2-10","cs_mich1_lighter_flame-10",1},
    }

    vRPclient.playAnim(player,{true,seq2,false})
end

local rist_choices = {}
rist_choices[">Rist cigaret"] = {function(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        if vRP.tryGetInventoryItem(user_id,"cigaret", 1) and vRP.tryGetInventoryItem(user_id,"lighter", 1)  then
                play_lighter(player)
            vRP.giveInventoryItem(user_id,"ristetcigaret",1)
            vRP.closeMenu(player)
        end
    end
end}
local rul_choices = {}
rul_choices[">Rul joint"] = {function(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        if vRP.tryGetInventoryItem(user_id,"paper", 1) and vRP.tryGetInventoryItem(user_id,"ristetcigaret", 1) and vRP.tryGetInventoryItem(user_id,"skunk", 1) then
            TriggerClientEvent("cn-animation:start", player, "farm")
            vRP.giveInventoryItem(user_id,"joint",1)
            vRP.closeMenu(player)
        end
    end
end}

-- Hammer Menu
local hammer_choices = {}
hammer_choices["> Brug hammer"] = {function(player,choice)
    local user_id = vRP.getUserId(player)

    if user_id ~= nil then
        if vRP.tryGetInventoryItem(user_id,"hammer",1) then
            vRPclient.playAnim(player,{false,{task="WORLD_HUMAN_HAMMERING"},false})
            vRP.closeMenu(player)
        end
    end
end}

-- Kamera Menu
local kamera_choices = {}
kamera_choices["> Brug kamera"] = {function(player,choice)
    local user_id = vRP.getUserId(player)

    if user_id ~= nil then
        if vRP.tryGetInventoryItem(user_id,"kamera",1) then
            vRPclient.playAnim(player,{false,{task="WORLD_HUMAN_PAPARAZZI"},false})
            vRP.closeMenu(player)
        end
    end
end}

-- Fiskestang Menu
local fiske_choices = {}
fiske_choices["> Brug fiskestang"] = {function(player,choice)
    local user_id = vRP.getUserId(player)

    if user_id ~= nil then
        if vRP.tryGetInventoryItem(user_id,"fiskestang",1) then
            vRPclient.playAnim(player,{false,{task="WORLD_HUMAN_STAND_FISHING"},false})
            vRP.closeMenu(player)
        end
    end
end}

-- Guitar Menu
local guitar_choices = {}
guitar_choices["> Brug guitar"] = {function(player,choice)
    local user_id = vRP.getUserId(player)

    if user_id ~= nil then
        if vRP.tryGetInventoryItem(user_id,"guitar",1) then
            vRPclient.playAnim(player,{false,{task="WORLD_HUMAN_MUSICIAN"},false})
            vRP.closeMenu(player)
        end
    end
end}

-- Kort Menu
local kort_choices = {}
kort_choices["> Brug kort"] = {function(player,choice)
    local user_id = vRP.getUserId(player)

    if user_id ~= nil then
        if vRP.tryGetInventoryItem(user_id,"kort",1) then
            vRPclient.playAnim(player,{false,{task="WORLD_HUMAN_TOURIST_MAP"},false})
            vRP.closeMenu(player)
        end
    end
end}

-- Øl Menu
local ol_choices = {}
ol_choices["> Drik øl"] = {function(player,choice)
    local user_id = vRP.getUserId(player)

    if user_id ~= nil then
        if vRP.tryGetInventoryItem(user_id,"ol",1) then
            vRPclient.playAnim(player,{false,{task="WORLD_HUMAN_PARTYING"},false})
            vRP.closeMenu(player)
        end
    end
end}

-- hotwings box Menu
local hotwingsb_choices = {}
hotwingsb_choices["> Åben boksen"] = {function(player,choice)
    local user_id = vRP.getUserId(player)

    if user_id ~= nil then
        if vRP.tryGetInventoryItem(user_id, "hotwingsb", 1) then
            vRP.giveInventoryItem(user_id, "hotwings", 14, true)
            vRP.closeMenu(player)
        end
    end
end}

items["cigaret"] = {"Cigaret", "En vanedannende cigaret", function(args) return ryge_choices end, 0.01}
items["lighter"] = {"Lighter", "Rist en cigaret", function(args) return rist_choices end, 0.01}
items["paper"] = {"Paper", "Rul en joint", function(args) return rul_choices end, 0.01}
items["cigaretpakke"] = {"Pakke Rød Pall Mall", "En vanedannende cigaretter", function(args) return pakkeryge_choices end, 0.21}
items["hammer"] = {"Hammer", "En håndværker hammer. Til fx. Tømrearbejde.", function(args) return hammer_choices end, 0.4}
items["kamera"] = {"Kamera", "Et godt kamera der tager gode billeder.", function(args) return kamera_choices end, 0.2}
items["fiskestang"] = {"Fiskestang", "En fiskestang til at fiske med.", function(args) return fiske_choices end, 1,2}
items["guitar"] = {"Guitar", "En guitar, giver du koncert?", function(args) return guitar_choices end, 1}
items["kort"] = {"Kort", "Kan du ikke finde vej?", function(args) return kort_choices end, 0.1}
items["ol"] = {"Øl", "En kold øl", function(args) return ol_choices end, 0.25}

-- The Diner
items["hotwingsb"] = {"Hotwings Box","Box med 14 stk", function(args) return hotwingsb_choices end, 0.70}

return items