--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 17-11-2018
-- Time: 13:23
-- Made for CiviliansNetwork
--

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","cn-animation")

AddEventHandler('chatMessage', function(source, name, msg)
    -------------------------------------------------------------------------------------------------
    --                               ↓ Kommandoer fra "Andet.lua" ↓                                --
    -------------------------------------------------------------------------------------------------
    local args = stringsplit(msg, ' ')
    if string.lower(args[1]) == "/eo" or string.lower(args[1]) == "/emoteo" then
        if args[2] ~= nil then
            TriggerClientEvent("cn-animation:start", source, args[2])
        else
            TriggerClientEvent("cn-animation:showEmotes", source)
        end
        CancelEvent()
    elseif string.lower(args[1]) == "/18" then
        TriggerClientEvent("cn-animation:showEmotes18", source)
        CancelEvent()
    elseif string.lower(args[1]) == "/emoteso" then
        TriggerClientEvent("cn-animation:showEmotes", source)
        CancelEvent()
    elseif msg == "/k" or msg == "/overgiv" or msg == "/arrest" then
        TriggerClientEvent("cn-animation:start", source, "giveop")
        CancelEvent()
    elseif string.lower(args[1]) == "/ansigt" or string.lower(args[1]) == "/face" or string.lower(args[1]) == "/humør" then
        if args[2] ~= nil then
            TriggerClientEvent("cn-animation:face", source, args[2])
        else
            TriggerClientEvent("cn-animation:showFaces", source)
        end
        CancelEvent()
    elseif string.lower(args[1]) == "/ansigter" or string.lower(args[1]) == "/faces" then
        TriggerClientEvent("cn-animation:showFaces", source)
        CancelEvent()
    elseif msg == "/paraply" or msg == "/unicorn" or msg == "/pizza" or msg == "/stok" or msg == "/kuffert" or msg == "/bor" or msg == "/box" or msg == "/mobil" or msg == "/ringer" or msg == "/pengepose" or msg == "/værktøjskasse" or msg == "/pose" then
        local user_id = vRP.getUserId({source})
        if msg == "/paraply" then
            animWithItem(user_id,{"paraply"},"en paraply", "paraply", source)
        elseif msg == "/pizza" then
            animWithItem(user_id,{"pizza"},"en pizza", "pizza", source)
        elseif msg == "/unicorn" then
            animWithItem(user_id,{"unicorn"},"en unicorn", "unicorn", source)
        elseif msg == "/pengepose" then
            animWithItem(user_id,{"pengepose"},"en posepenge", "pengepose", source)
        elseif msg == "/stok" then
            animWithItem(user_id,{"stok"},"en stok", "stok", source)
        elseif msg == "/kuffert" then
            animWithItem(user_id,{"kuffert"},"en kuffert", "kuffert", source)
        elseif msg == "/pose" then
            animWithItem(user_id,{"pose"},"en pose", "pose", source)
        elseif msg == "/værktøjskasse" then
            animWithItem(user_id,{"kuffert"},"en værktøjskasse", "værktøjskasse", source)
        elseif msg == "/pengepose" then
            animWithItem(user_id,{"pengepose"},"en pose penge", "pengepose", source)
        elseif msg == "/box" then
            animWithItem(user_id,{"box"},"en kasse", "boxlift", source)
        elseif msg == "/mobil" or msg == "/telefon" or msg == "/phone" then
            animWithItem(user_id,{"samsung","oneplus","iphone"},"en telefon", "mobil", source)
        elseif msg == "/ringer" then
            animWithItem(user_id,{"samsung","oneplus","iphone"},"en telefon", "ringer", source)
        end
        CancelEvent()
    end
end)

RegisterServerEvent('cn-emotes:particles')
AddEventHandler('cn-emotes:particles', function(ped,dict,par,settings,type,stoptime)
    TriggerClientEvent('cn-emotes:startparticles',-1,ped,dict,par,settings,type,stoptime)
end)

RegisterServerEvent('cn-emotes:effects')
AddEventHandler('cn-emotes:effects', function(ped,dict,par,settings,type,stoptime)
    TriggerClientEvent('cn-emotes:starteffects',-1,ped,dict,par,settings,type,stoptime)
end)
-----------------------------------------------------------------------------------
-- User_id giver sig selv
-- Item skal være et table, og items der skal bruges skal bare smide i et table.
-- Itemname er f.eks. "en mobil" eller "et nyhedskamera"
-- Anim er key i array under animations i client
-- Source giver sig selv
-----------------------------------------------------------------------------------
function animWithItem(user_id, item, itemname, anim, source)
    local hasItem = false
    for k,v in pairs(item) do
        if vRP.hasInventoryItem({user_id,v}) then
            hasItem = true
        end
    end
    if hasItem then
        TriggerClientEvent("cn-animation:startWithItem", source, anim)
    else
        TriggerClientEvent("pNotify:SendNotification", source,{text = "Du mangler "..itemname, type = "error", queue = "global", timeout = 2000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
