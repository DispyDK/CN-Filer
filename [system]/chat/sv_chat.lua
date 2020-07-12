local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_chatroles")

RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')

AddEventHandler('_chat:messageEntered', function(author, color, message)
    if not message or not author then
        return
    end

    TriggerEvent('chatMessage', source, author, message)

    if not WasEventCanceled() then
        TriggerEvent("cn_message",source,author,message)
    end

    print(author .. ': ' .. message)
end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)

    TriggerEvent('chatMessage', source, name, '/' .. command)

    if not WasEventCanceled() then
        local user_id = vRP.getUserId({source})
        local player = vRP.getUserSource({user_id})
        if vRP.hasPermission({user_id,"player.phone"}) then
            TriggerClientEvent('chatMessage', player, "^2Denne ^1["..command.."]^2 er ikke tilgængelig se tilgængelige kommandoer ved at trykke DEL")
        else
            --TriggerClientEvent('chatMessage', -1, "^1[OOC]^0 " .. name .. " - [ID - "..user_id.."] ", { 128, 128, 128 }, '/' .. command)
        end
    end

    CancelEvent()
end)

-- player join messages
-- AddEventHandler('playerConnecting', function()
-- TriggerClientEvent('chatMessage', -1, '', { 255, 255, 255 }, '^2* ' .. GetPlayerName(source) .. ' joined.')
-- end)

-- AddEventHandler('playerDropped', function(reason)
-- TriggerClientEvent('chatMessage', -1, '', { 255, 255, 255 }, '^2* ' .. GetPlayerName(source) ..' left (' .. reason .. ')')
-- end)

RegisterCommand('say', function(source, args, rawCommand)
    TriggerClientEvent('chatMessage', -1, (source == 0) and 'SERVER' or GetPlayerName(source), { 255, 255, 255 }, rawCommand:sub(5))
end)

AddEventHandler('chatMessage', function(source, name, message)
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
end)
