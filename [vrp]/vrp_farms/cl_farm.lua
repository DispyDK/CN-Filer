vRP = Proxy.getInterface("vRP")

local trash = false
local playingEmote = false
local place = {}

function DrawText3Ds(x,y,z,text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35,0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255,255,255,215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125,0.015+ factor,0.03,41,11,41,68)
end

RegisterNetEvent('vrp_farms:loaddata')
AddEventHandler('vrp_farms:loaddata',function(itemtr)
    trash = true
    emotedic = itemtr.emote
    farmName = itemtr.name
    place = {x=itemtr.x,y=itemtr.y,z=itemtr.z,radius=itemtr.radius}
end)
RegisterNetEvent('vrp_farms:leave')
AddEventHandler('vrp_farms:leave',function(itemtr)
    trash = false
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local playerpos = GetEntityCoords(ped)
        if trash then
            if IsControlJustPressed(0,38) then
                playingEmote = true
                TaskStartScenarioInPlace(GetPlayerPed(-1),emotedic,0,true)
            elseif IsControlJustPressed(0,311) then
                playingEmote = false
                ClearPedTasks(ped)
            end

            if playingEmote ~= false and Vdist(playerpos["x"], playerpos["y"], playerpos["z"], place.x, place.y, place.z) > place.radius then
                playingEmote = false
                ClearPedTasks(ped)
            end

            if not playingEmote and farmName ~= nil then
                DrawText3Ds(place.x,place.y-0.5,place.z,"Tryk ~g~E~s~ for at ~r~".." "..farmName)
            elseif playingEmote then
                DrawText3Ds(place.x,place.y-0.5,place.z,"Tryk ~g~K~s~ for at stoppe ~r~")
            end
        else
            if playingEmote ~= false then
                if place.x == nil or Vdist(playerpos["x"], playerpos["y"], playerpos["z"], place.x, place.y, place.z) > place.radius then
                    playingEmote = false
                    ClearPedTasks(ped)
                end
            end
        end
    end
end)
