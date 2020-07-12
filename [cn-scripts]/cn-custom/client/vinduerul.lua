--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 12-04-2019
-- Time: 13:04
-- Made for CiviliansNetwork
--

local frontwindowup = true
local backwindowup = true

RegisterNetEvent("rollcarwindows")
AddEventHandler('rollcarwindows', function(veh,bool,front)
    veh = NetToVeh(veh)
    local firstwindow = 2
    local secondwindow = 3
    if front then
        firstwindow = 0
        secondwindow = 1
    end
    if (bool) then
        RollDownWindow(veh,firstwindow)
        RollDownWindow(veh,secondwindow)
    else
        RollUpWindow(veh, firstwindow)
        RollUpWindow(veh, secondwindow)
    end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(10)
      if IsControlJustPressed(1, 208) and not IsThisModelABoat(model) and not IsThisModelABicycle(model) then
        if IsPedInAnyVehicle(PlayerPedId(),false) then
            local playerCar = GetVehiclePedIsIn(PlayerPedId(),false)
            if (GetPedInVehicleSeat( playerCar,-1) == PlayerPedId()) then
                TriggerServerEvent("rollcarwindows",VehToNet(playerCar),frontwindowup,true)
                frontwindowup = not frontwindowup
            end
        end
      end
      if IsControlJustPressed(1, 207) and not IsThisModelABoat(model) and not IsThisModelABicycle(model) then
        if IsPedInAnyVehicle(PlayerPedId(),false) then
            local playerCar = GetVehiclePedIsIn(PlayerPedId(),false)
            if (GetPedInVehicleSeat( playerCar,-1) == PlayerPedId()) then
                TriggerServerEvent("rollcarwindows",VehToNet(playerCar),backwindowup,false)
                backwindowup = not backwindowup
            end
        end
  end
end
end)

RegisterCommand("rul", function()
    if IsPedInAnyVehicle(PlayerPedId(),false) then
        local playerCar = GetVehiclePedIsIn(PlayerPedId(),false)
        if (GetPedInVehicleSeat( playerCar,-1) == PlayerPedId()) then
            TriggerServerEvent("rollcarwindows",VehToNet(playerCar),frontwindowup,true)
            frontwindowup = not frontwindowup
        end
    end
end)
RegisterCommand("rulbag", function()
    if IsPedInAnyVehicle(PlayerPedId(),false) then
        local playerCar = GetVehiclePedIsIn(PlayerPedId(),false)
        if (GetPedInVehicleSeat( playerCar,-1) == PlayerPedId()) then
            TriggerServerEvent("rollcarwindows",VehToNet(playerCar),backwindowup,false)
            backwindowup = not backwindowup
        end
    end
end)
