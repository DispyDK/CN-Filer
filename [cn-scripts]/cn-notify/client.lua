--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 26-01-2019
-- Time: 12:26
-- Made for CiviliansNetwork
--

RegisterNetEvent('cn_notify:notify')
AddEventHandler('cn_notify:notify', function(message)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    TriggerEvent('chatMessage', message)
end)

RegisterNetEvent('cn_notify:notifysound')
AddEventHandler('cn_notify:notifysound', function()
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
end)

local blips = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for k,v in pairs(blips) do
            if v.time > 0 then
                v.time = v.time-1
                blips[k] = {blip=v.blip,time=v.time}
            else
                RemoveBlip(v.blip)
                blips[k] = nil
            end
        end
    end
end)

RegisterNetEvent('cn_notify:notifyDispatch')
AddEventHandler('cn_notify:notifyDispatch', function(x,y,z,message,number)
    local blip = AddBlipForCoord(x+0.001,y+0.001,z+0.001)
    SetBlipSprite(blip, 304)
    SetBlipColour(blip, 67)
    SetBlipAlpha(blip, 250)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Alarm opkald: "..number)
    SetBlipScale(blip, 0.8)
    EndTextCommandSetBlipName(blip)

    table.insert(blips, {blip=blip, time=300})

    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    Wait(50)
    TriggerEvent('chatMessage', '^5^*[ALARMCENTRAL]', "^5^*[ALARMCENTRAL]", message)
end)