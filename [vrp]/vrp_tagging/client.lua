

local playerPed = GetPlayerPed(-1)
pos = {
    {-192.04113769531,-892.42639160156,29.345109939575}
}
local delay = 0
Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(1)
        if delay > 0 then
            delay = delay-1
        else
            for i = 1, #pos do
                poss = pos[i]
                DrawMarker(1, poss[1], poss[2], poss[3], 0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.0, 0, 157, 0, 0--[[Alpha]], 0, 0, 2, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), poss[1], poss[2], poss[3], true ) > 1300.0 then
                    TriggerServerEvent("vrp_tagging:check")
                    delay = 1000 -- 10 sekunder
                end
                end
            end
        end
end)


RegisterNetEvent("vrp_tagging:alarm")
AddEventHandler("vrp_tagging:alarm", function(trigger)
    local player = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(player)
    if trigger then
        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "tagging", 0.3)
        TriggerServerEvent('cn_notify:notifyPolice', "Fodlænke: %number Overtrådt perimeter!",{playerCoords.x, playerCoords.y, playerCoords.z})
    end
end)