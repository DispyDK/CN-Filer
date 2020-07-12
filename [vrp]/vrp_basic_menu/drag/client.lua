other = nil
drag = false
playerStillDragged = false

RegisterNetEvent("dr:drag")
AddEventHandler('dr:drag', function(pl)
    other = pl
    drag = not drag
end)

RegisterNetEvent("dr:undrag")
AddEventHandler('dr:undrag', function(pl)
    drag = false
end)

Citizen.CreateThread(function()
    while true do
        if drag and other ~= nil then
            local ped = GetPlayerPed(GetPlayerFromServerId(other))
            local myped = GetPlayerPed(-1)
            AttachEntityToEntity(myped, ped, 4103, 11816, 0.48, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            playerStillDragged = true
        else
            if(playerStillDragged) then
                DetachEntity(GetPlayerPed(-1), true, false)
                playerStillDragged = false
            end
        end
        Citizen.Wait(0)
    end
end)


RegisterNetEvent("dr:isdog")
AddEventHandler('dr:isdog', function(pl)
  if IsPedModel(nplayer,1126154828) then
    isdog = true
    return isdog
  else
    isdog = false
    return isdog
  end
end)


RegisterNetEvent("jail:getPos")
AddEventHandler('jail:getPos', function(pl)
  local player = GetPlayerPed(-1)
  if GetDistanceBetweenCoords(GetEntityCoords(player), 1712.2451171875,2594.7014160156,60.29500579834, true ) > 275.0 then
    local playerCoords = GetEntityCoords(player)
		SetEntityCoords(GetPlayerPed(-1), 1793.4390869141+0.0001, 2483+0.0001, -123+0.0001, 1,0,0,1)
        --TriggerServerEvent('cn_notify:notifyPolice', "Fængselsflugt: En person er flygtet fra fængslet!!",{playerCoords.x, playerCoords.y, playerCoords.z})
  end
end)
