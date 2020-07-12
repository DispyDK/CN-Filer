--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 26-01-2019
-- Time: 12:26
-- Made for CiviliansNetwork
--

local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
local cfg = module("cn-notify", "cfg/config")
local notifypolice = 0

AddEventHandler('chatMessage', function(source, author, msg)
    local args = stringsplit(msg, ' ')
    if string.lower(args[1]) == "/r" then
        local user_id = vRP.getUserId({source})
        if vRP.hasPermission({user_id,cfg.notifyStaffGroup}) then
            args[2] = parseInt(args[2])
            local checkid = vRP.getUserSource({tonumber(args[2])})
            if checkid ~= nil then
                if args[3] ~= nil then
                    local smessage = ""
                    for k,v in pairs(args) do
                        if k > 2 then
                            smessage = smessage .. v .." "
                        end
                    end
                    sendToDiscord("STAFF REPLY CHAT", "**SVAR TIL "..args[2].." FRA "..tostring(user_id) .. "** - " ..author..": ^1" .. smessage)
                    TriggerClientEvent('chatMessage',checkid, "OOC ^7| ^1STAFF ^7| ^3SVAR TIL DIG ^7| " ..author..": ^1" ..  smessage)
                    TriggerClientEvent('cn_notify:notifysound',checkid)
                    local users = vRP.getUsers({})
                    for k,v in pairs(users) do
                        if v ~= nil then
                            if vRP.hasPermission({k,cfg.notifyStaffGroup}) then
                                TriggerClientEvent('chatMessage',v, "OOC ^7| ^1STAFF ^7| ^3SVAR TIL "..args[2].." ^7| " ..author..": ^1" ..  smessage)
                            end
                        end
                    end
                else
                    TriggerClientEvent("pNotify:SendNotification",source,{text = "Du skal skrive noget efter ID!", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                end
            else
                TriggerClientEvent("pNotify:SendNotification",source,{text = "ID "..args[2].." er ugyldigt eller ikke online.", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end
        CancelEvent()
    elseif string.lower(args[1]) == "/ooc" then
        local user_id = vRP.getUserId({source})
        if vRP.hasPermission({user_id,cfg.notifyStaffGroup}) then
            local smessage = ""
            for k,v in pairs(args) do
                if k > 1 then
                    smessage = smessage .. v .." "
                end
            end
            if smessage ~= "" then
                sendToDiscord("OOC CHAT", "**"..tostring(user_id) .. "** - " ..author..": ^1" .. smessage)
                TriggerClientEvent('chatMessage',-1, "OOC ^7| ^1STAFF ^7| " ..author..": ^1" ..  smessage)
            end
        end
        CancelEvent()
    elseif string.lower(args[1]) == "/pk" then
        local message = string.sub(msg, 5)
        if message ~= "" then
            local user_id = vRP.getUserId({source})
            sendToDiscord2("PK CHAT", "**"..tostring(user_id) .. "** - PK - " ..author..": ^1" .. message)
            TriggerClientEvent('chatMessage',-1, "^5PK ^7| ^3SPILLER: ^1" .. message)
        end
        CancelEvent()
    elseif string.lower(args[1]) == "/ck" then
        local message = string.sub(msg, 5)
        if message ~= "" then
            local user_id = vRP.getUserId({source})
            sendToDiscord2("CK CHAT", "**"..tostring(user_id) .. "** - CK - " ..author..": ^1" .. message)
            TriggerClientEvent('chatMessage',-1, "^8CK ^7| ^3SPILLER: ^1" .. message)
        end
        CancelEvent()
    end
end)

RegisterServerEvent('cn_message')
AddEventHandler('cn_message', function(source,author,message)

    local user_id = vRP.getUserId({source})
    local staff = false
    if vRP.hasPermission({user_id,"staff.chat"}) then
        staff = true
    else
        TriggerClientEvent('chatMessage', source, "OOC ^7| ^5MEDLEM ^7| "..user_id.." ^7| " ..author..": ^1" ..  message)
    end

    local users = vRP.getUsers({})
    for k,v in pairs(users) do
        if v ~= nil then
            if vRP.hasPermission({k,cfg.notifyStaffGroup}) then
                if staff then
                    TriggerClientEvent('chatMessage', v, "^1STAFFCHAT ^7| "..user_id.." ^7| " ..author..": ^1" ..  message)
                else
                    TriggerClientEvent('chatMessage', v, "HJÆLP ^7| ^5MEDLEM ^7| "..user_id.." ^7| " ..author..": ^1" ..  message)
                end
            end
        end
    end
end)

RegisterServerEvent('cn_notify:notifyStaff')
AddEventHandler('cn_notify:notifyStaff', function(player)
    local users = vRP.getUsers({})
    for k,v in pairs(users) do
        if v ~= nil then
            if vRP.hasPermission({k,cfg.notifyStaffGroup}) then
                TriggerClientEvent('cn_notify:notify', v, cfg.notifyCallTakenMsg:gsub("%%player",player))
            end
        end
    end
end)


RegisterServerEvent('cn_notify:notifyPolice')
AddEventHandler('cn_notify:notifyPolice', function(msg,withblip)
    local users = vRP.getUsers({})
    notifypolice = notifypolice+1
    for k,v in pairs(users) do
        if v ~= nil then
            if vRP.hasGroup({k,"Politi-Job"}) then
                if withblip ~= false then
                    local x,y,z = table.unpack(withblip)
                    TriggerClientEvent('cn_notify:notifyDispatch', v, x,y,z, msg:gsub("%%number",notifypolice),notifypolice)
                else
                    TriggerClientEvent('cn_notify:notify', v, cfg.notifyPolice..msg)
                end
            end
        end
    end
end)

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

function sendToDiscord(name, message)
    if message == nil or message == '' or message:sub(1, 1) == '/' then return FALSE end
    local server = GetConvar("servernumber", "0")
    if server == "1" then
			PerformHttpRequest('https://autisthook.com/api/webhooks/597822343045316619/WO-7_7LsEc82eIY2AgGfZBYS3gc0vRtJvZMuteaMLVVNfylzumFpmCFmAB1Dqq6ZZwlL', function(err, text, headers) end, 'POST', json.encode({username = GetPlayerName(source), content = message}), { ['Content-Type'] = 'application/json' })
		elseif server == "2" then
			PerformHttpRequest('https://autisthook.com/api/webhooks/597822496590528512/kbeq7T4FI2_sFaZJpcuympqR1z1SNEsb1O9V5DC9a7FF_g_ldnHnt1KrgO_HpPX0qt4a', function(err, text, headers) end, 'POST', json.encode({username = GetPlayerName(source), content = message}), { ['Content-Type'] = 'application/json' })
		elseif server == "3" then
			PerformHttpRequest('https://autisthook.com/api/webhooks/597822536184758272/GgAsXvdqucIamOg9LnwSt0r4iC4kzG_IIDg9FOuQdRQuxsvB8YuFuv1EfER2nlptfutY', function(err, text, headers) end, 'POST', json.encode({username = GetPlayerName(source), content = message}), { ['Content-Type'] = 'application/json' })
		elseif server == "4" then
			PerformHttpRequest('https://autisthook.com/api/webhooks/597822579054477324/PvJXmaZO7u_NPBnicIEXtzn6MvKAADyOzgZrDVTWvAKDGWCqn39ZUu1WyYDRb_okXha0', function(err, text, headers) end, 'POST', json.encode({username = GetPlayerName(source), content = message}), { ['Content-Type'] = 'application/json' })
		end
end

function sendToDiscord2(name, message)
    if message == nil or message == '' or message:sub(1, 1) == '/' then return FALSE end
    local server = GetConvar("servernumber", "0")
    if server == "1" then
			PerformHttpRequest('https://autisthook.com/api/webhooks/643528399469674521/NFHghIJdvYv7Pr6HxQB4VuAGnSlr0KBCoZUi-LdmXlViChuLZb4ZWCLdHE7duUdhx-yK', function(err, text, headers) end, 'POST', json.encode({username = GetPlayerName(source), content = message}), { ['Content-Type'] = 'application/json' })
	  end
end
