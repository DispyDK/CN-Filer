
RegisterNetEvent('cn-arrest:getarrested')
AddEventHandler('cn-arrest:getarrested', function(playerheading, playercoords, playerlocation)
    playerPed = GetPlayerPed(-1)
    local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
    SetEntityCoords(GetPlayerPed(-1), x, y, z)
    SetEntityHeading(GetPlayerPed(-1), playerheading)
    Wait(250)
    loadanimdict('mp_arrest_paired')
    TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
    Wait(3760)
    cuffed = true
    loadanimdict('mp_arresting')
    TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
end)

RegisterNetEvent('cn-arrest:doarrested')
AddEventHandler('cn-arrest:doarrested', function()
    Wait(250)
    loadanimdict('mp_arrest_paired')
    TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
    Wait(3000)

end)

RegisterNetEvent('cn-arrest:douncuffing')
AddEventHandler('cn-arrest:douncuffing', function()
    Wait(250)
    loadanimdict('mp_arresting')
    TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
    Wait(5500)
    ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('cn-arrest:getuncuffed')
AddEventHandler('cn-arrest:getuncuffed', function(playerheading, playercoords, playerlocation)
    local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
    SetEntityCoords(GetPlayerPed(-1), x, y, z)
    SetEntityHeading(GetPlayerPed(-1), playerheading)
    Wait(250)
    loadanimdict('mp_arresting')
    TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
    Wait(5500)
    cuffed = false
    ClearPedTasks(GetPlayerPed(-1))
end)

RegisterCommand('cuff', function()
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        vRPclient.getNearestPlayer(source,{10},function(target)
            local nuser_id = vRP.getUserId(target)
            if nuser_id ~= nil then
                playerheading = GetEntityHeading(GetPlayerPed(-1))
                playerlocation = GetEntityForwardVector(PlayerPedId())
                playerCoords = GetEntityCoords(GetPlayerPed(-1))
                --local target_id = GetPlayerServerId(target)
                if distance <= 2.0 then
                    TriggerServerEvent('cn-arrest:requestarrest', target, playerheading, playerCoords, playerlocation)
                end
            end
        end)
    end
end)

RegisterCommand('uncuff', function()
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        vRPclient.getNearestPlayer(source,{10},function(target)
            local nuser_id = vRP.getUserId(target)
            if nuser_id ~= nil then
                playerheading = GetEntityHeading(GetPlayerPed(-1))
                playerlocation = GetEntityForwardVector(PlayerPedId())
                playerCoords = GetEntityCoords(GetPlayerPed(-1))
                --local target_id = GetPlayerServerId(target)
                    TriggerServerEvent('cn-arrest:requestrelease', target, playerheading, playerCoords, playerlocation)
            end
        end)
    end
end)
