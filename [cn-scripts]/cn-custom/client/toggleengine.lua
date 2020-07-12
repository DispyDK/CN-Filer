RegisterCommand("køretøj", function()
	local playerped = PlayerPedId()
		local coordA = GetEntityCoords(playerped, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
		local veh = getVehicleInDirection(coordA, coordB)
    toggleEngine(false, veh)
end)

function toggleEngine(bool, veh)
--    local veh = GetVehiclePedIsIn(GetPlayerPed(-1),false)
    if veh ~= 0 then
        vehicleenginestatus = not vehicleenginestatus
        if vehicleenginestatus == true then
            SetVehicleEngineOn(veh, true, true)
            TriggerEvent('chatMessage', 'MOTOR', {0, 255, 0}, "Motor tændt!")
        else
            SetVehicleEngineOn(veh, false)
            TriggerEvent('chatMessage', 'MOTOR', {255, 0, 0}, "Motor slukket!")
        end
    else
        TriggerEvent('chatMessage', 'MOTOR', {255, 0, 0}, "Du skal sidde i et køretøj!")
    end
    if bool == nil then moteur() end
end

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end
