local First = vector3(0.0, 0.0, 0.0)
local Second = vector3(5.0, 5.0, 5.0)

local Vehicle = {Coords = nil, Vehicle = nil, Dimension = nil, IsInFront = false, Distance = nil}
Citizen.CreateThread(function()
    Citizen.Wait(200)
    while true do
        local ped = PlayerPedId()
        local posped = GetEntityCoords(GetPlayerPed(-1))
        local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 20.0, 0.0)
        local rayHandle = CastRayPointToPoint(posped.x, posped.y, posped.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, ped, 0)
        local a, b, c, d, closestVehicle = GetRaycastResult(rayHandle)
        local Distance = GetDistanceBetweenCoords(c.x, c.y, c.z, posped.x, posped.y, posped.z, false);

        local vehicleCoords = GetEntityCoords(closestVehicle)
        local dimension = GetModelDimensions(GetEntityModel(closestVehicle), First, Second)
        if Distance < 6.0  and not IsPedInAnyVehicle(ped, false) then
            Vehicle.Coords = vehicleCoords
            Vehicle.Dimensions = dimension
            Vehicle.Vehicle = closestVehicle
            Vehicle.Distance = Distance
            if GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle), GetEntityCoords(ped), true) > GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle) * -1, GetEntityCoords(ped), true) then
                Vehicle.IsInFront = false
            else
                Vehicle.IsInFront = true
            end
        else
            Vehicle = {Coords = nil, Vehicle = nil, Dimensions = nil, IsInFront = false, Distance = nil}
        end
        Citizen.Wait(500)
    end
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

local angle = 0.0
local anglemax = 40.0
local anglemin = -40.0
local rotangle = 1.0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        local vehModel = GetEntityModel(Vehicle.Vehicle)
        if Vehicle.Vehicle ~= nil then
            
            if IsThisModelACar(vehModel) and IsVehicleSeatFree(Vehicle.Vehicle, -1) and GetVehicleEngineHealth(Vehicle.Vehicle) <= 200 then
                drawTxt3D(Vehicle.Coords.x, Vehicle.Coords.y, Vehicle.Coords.z + 0.3,'[~g~SHIFT~w~] + [~g~E~w~] For at skubbe køretøjet')
            end
            if IsControlPressed(0, 21) and IsVehicleSeatFree(Vehicle.Vehicle, -1) and not IsEntityAttachedToEntity(ped, Vehicle.Vehicle) and IsControlJustPressed(0, 38)  and GetVehicleEngineHealth(Vehicle.Vehicle) <= 200 then
                NetworkRequestControlOfEntity(Vehicle.Vehicle)
                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                if Vehicle.IsInFront then
                    AttachEntityToEntity(ped, Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y * -1 + 0.1 , Vehicle.Dimensions.z + 1.0, 0.0, 0.0, 180.0, 0.0, false, false, true, false, true)
                else
                    AttachEntityToEntity(ped, Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y - 0.3, Vehicle.Dimensions.z  + 1.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, true)
                end
                loadAnimDict('missfinale_c2ig_11')
                TaskPlayAnim(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, 0, 0, 0)
                Citizen.Wait(200)
                    while true do
                        Citizen.Wait(5)
                        local tangle = GetVehicleSteeringAngle(Vehicle.Vehicle)
                        if IsDisabledControlPressed(0, 34) then -- A
                            TaskVehicleTempAction(ped, currentVehicle, 11, 1000)
                            if angle < anglemax then
                                angle = angle + rotangle
                                SetVehicleSteeringAngle(Vehicle.Vehicle, angle)
                            end
                        end

                        if IsDisabledControlPressed(0, 9) then -- D
                            TaskVehicleTempAction(ped, currentVehicle, 10, 1000)
                            if angle > anglemin then
                                angle = angle - rotangle
                                SetVehicleSteeringAngle(Vehicle.Vehicle, angle)
                            end
                            SetVehicleSteeringAngle(Vehicle.Vehicle, angle)
                        end

                        if IsDisabledControlPressed(0, 32) then -- W
                            if angle > 0.0 then
                                angle = angle - rotangle
                                SetVehicleSteeringAngle(Vehicle.Vehicle, angle)
                            elseif angle < 0.0 then
                                angle = angle + rotangle
                                SetVehicleSteeringAngle(Vehicle.Vehicle, angle)
                            end
                        end

                        if Vehicle.IsInFront then
                            SetVehicleForwardSpeed(Vehicle.Vehicle, -1.0)
                        else
                            SetVehicleForwardSpeed(Vehicle.Vehicle, 1.0)
                        end

                        if HasEntityCollidedWithAnything(Vehicle.Vehicle) then
                            SetVehicleOnGroundProperly(Vehicle.Vehicle)
                        end

                        if not IsDisabledControlPressed(0, 38) then -- E
                            DetachEntity(ped, false, false)
                            StopAnimTask(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0)
                            FreezeEntityPosition(ped, false)
                        break
                    end                   
                end
            end
        end
    end
end)

drawTxt3D = function(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.40, 0.40)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 125)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)

    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end