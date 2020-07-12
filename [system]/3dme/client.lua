vRPex = Proxy.getInterface("vrp_extended")
local color = {r = 232, g = 138, b = 14, alpha = 255} -- Color of the text
local font = 4 -- Font of the text
local nbrDisplaying = 1
local time = 5

RegisterCommand('me', function(source, args)
    local text = ''
    for i = 1,#args do
        if text == '' then
            text = args[i]
        else
            text = text .. ' ' .. args[i]
        end
    end
    TriggerServerEvent('3dme:shareDisplay', text, vRPex.getUser().userid, vRPex.getUser().name, 10,false,10)
end)

RegisterCommand('mig', function(source, args)
    local text = ''
    for i = 1,#args do
        if text == '' then
            text = args[i]
        else
            text = text .. ' ' .. args[i]
        end
    end
    TriggerServerEvent('3dme:shareDisplay', text, vRPex.getUser().userid, vRPex.getUser().name, 10,false,10)
end)

RegisterNetEvent('3dme:remoteDisplay')
AddEventHandler('3dme:remoteDisplay', function(text,radius)
    TriggerServerEvent('3dme:shareDisplay', text, vRPex.getUser().userid, vRPex.getUser().name,radius,true,tonumber(time))
end)

RegisterNetEvent('3dme:triggerDisplay')
AddEventHandler('3dme:triggerDisplay', function(text, source, radius)
    local offset = (nbrDisplaying * 0.14)
    Display(GetPlayerFromServerId(source), text, offset,radius,tonumber(time)*1000)
end)

function Display(mePlayer, text, offset,radius,time)
    local displaying = true
    Citizen.CreateThread(function()
        Wait(time)
        displaying = false
    end)
    Citizen.CreateThread(function()
        nbrDisplaying = nbrDisplaying + 1
        while displaying do
            Wait(0)
            local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
            local coords = GetEntityCoords(PlayerPedId(), false)
            local dist = GetDistanceBetweenCoords(coordsMe['x'], coordsMe['y'], coordsMe['z'], coords['x'], coords['y'], coords['z'], true)
            if dist < 3 then
                DrawText3D(coordsMe['x'], coordsMe['y'], coordsMe['z']+offset, text)
            end
        end
        nbrDisplaying = nbrDisplaying - 1
    end)
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)

    text = string.gsub(text, "^.", string.upper)

    if onScreen then
        SetTextScale(0.40, 0.40)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 270
        DrawRect(_x,_y+0.0150, 0.035+ factor, 0.04, 0, 0, 0, 80)
    end
end
