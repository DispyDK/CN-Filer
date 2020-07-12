--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 23-01-2019
-- Time: 14:48
-- Made for CiviliansNetwork
--

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local isEngineOn = Citizen.InvokeNative(0xAE31E7DF9B5B132E, GetVehiclePedIsIn(GetPlayerPed(-1)))
        if DoesEntityExist(veh) and not IsEntityDead(veh) then
            local model = GetEntityModel(veh)
            if IsControlJustPressed(1, 288) and not IsThisModelABoat(model) and not IsThisModelABicycle(model) then
                if isEngineOn then
                    TriggerEvent('pv:setCruiseSpeed')
                    TriggerEvent("pNotify:SetQueueMax", fart, 2)
                    TriggerEvent("pNotify:SendNotification",{text = "Fartpilot aktiveret/deaktiveret",type = "success",timeout = (3000),layout = "bottomCenter",queue = "fart",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer=true})
                end
            end
        end
    end
end)

local cruise = 0

AddEventHandler('pv:setCruiseSpeed', function()
    local isEngineOn = Citizen.InvokeNative(0xAE31E7DF9B5B132E, GetVehiclePedIsIn(GetPlayerPed(-1)))
    if cruise == 0 and IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        if GetEntitySpeedVector(GetVehiclePedIsIn(GetPlayerPed(-1), false), true)['y'] > 0 and isEngineOn then
            cruise = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false))
            local cruiseKm = math.floor(cruise * 3.6 + 0.5)
            local cruiseMph = math.floor(cruise * 2.23694 + 0.5)
            local isEngineOn = Citizen.InvokeNative(0xAE31E7DF9B5B132E, GetVehiclePedIsIn(GetPlayerPed(-1)))

            TriggerEvent("pNotify:SetQueueMax", fart, 2)
            TriggerEvent("pNotify:SendNotification",{text = "Fartpilot sat til: <color=lightblue>"..cruiseKm.."</color>",type = "success",timeout = (3000),layout = "bottomCenter",queue = "fart",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})


            Citizen.CreateThread(function()
                while cruise > 0 and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1) do
                    local cruiseVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                    local isEngineOn = Citizen.InvokeNative(0xAE31E7DF9B5B132E, GetVehiclePedIsIn(GetPlayerPed(-1)))
                    if IsVehicleOnAllWheels(cruiseVeh) and GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) > (cruise - 2.0) and isEngineOn then
                        SetVehicleForwardSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false), cruise)
                    else
                        cruise = 0
                        TriggerEvent("pNotify:SetQueueMax", fart, 2)
                        TriggerEvent("pNotify:SendNotification",{text = "Fartpilot deaktiveret",type = "success",timeout = (3000),layout = "bottomCenter",queue = "fart",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                        break
                    end
                    if IsControlPressed(1, 8) then
                        cruise = 0
                    end
                    if IsControlPressed(1, 32) then
                        cruise = 0
                        TriggerEvent('pv:setNewSpeed')
                    end
                    if cruise > 150 then
                        cruise = 0
                        break
                    end
                    Wait(200)
                end
                cruise = 0
            end)
        else
            cruise = 0
        end
    else
        if cruise > 0 then

        end
        cruise = 0
    end
end)

AddEventHandler('pv:setNewSpeed', function()
    Citizen.CreateThread(function()
        while IsControlPressed(1, 32) do
            Wait(1)
        end
        TriggerEvent('pv:setCruiseSpeed')
    end)
end)