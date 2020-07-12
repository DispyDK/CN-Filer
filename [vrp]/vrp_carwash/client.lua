local vehicleWashStation = {
	{name="Bilvasken", colour=0, id=100, x=24.4143, y=-1392.0250, z=29.3344, hidden = false, circle = false},
	{name="Bilvasken", colour=0, id=100, x=169.3915, y=-1716.8355, z=28.341666030884, hidden = false, circle = true},
	{name="Bilvasken", colour=0, id=100, x=-72.1866, y=6429.6069, z=31.4442, hidden = false, circle = false},
	{name="Bilvasken", colour=0, id=100, x=-699.7122, y=-932.9292, z=19.0180, hidden = false, circle = false},
	{name="Bilvasken", colour=0, id=100, x=14.290225982666, y=-1821.1237792969, z=25.032810211182, hidden = false, circle = false},
	{name="Bilvasken", colour=0, id=100, x=-143.2784576416, y=153.79658508301, z=77.501487731934, hidden = false, circle = false},
	{name="Bilvasken", colour=0, id=100, x=-49.408885955811, y=-1075.0541992188, z=26.836103439331, hidden = false, circle = false},
	{name="Bilvasken", colour=0, id=0, x=434.04025268555, y=-997.18225097656, z=25.76198387146, hidden = false, circle = false},
	{name="Bilvasken", colour=0, id=100, x=2005.4361572266,y= 3798.3041992188,z= 31.689037322998, hidden = false, circle = false},
}
Citizen.CreateThread(function()
	Citizen.Wait(0)
	for _, item in pairs(vehicleWashStation) do
		if not item.hidden then
			item.blip = AddBlipForCoord(item.x, item.y, item.z)
			SetBlipSprite(item.blip, item.id)
			SetBlipColour(item.blip, item.colour)
			SetBlipAsShortRange(item.blip, true)
			SetBlipScale(item.blip, 0.8)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(item.name)
			EndTextCommandSetBlipName(item.blip)
			end
		end
	return
end)

local Rotation = 0
Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(10)
		if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
			for i = 1, #vehicleWashStation do
				item2 = vehicleWashStation[i]
				Rotation = Rotation - 0.5
				if Rotation <= 0 then
					Rotation = 360
				end
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), item2.x, item2.y, item2.z, true ) < 15 then
					if item2.circle == true then
						--DrawMarker(27, item2.x, item2.y, item2.z, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.0, 0, 157, 0, 155, 0, 0, 200, 0, 0, 0, 50)
						DrawMarker(27,item2.x, item2.y, item2.z,0,0,0,0,0,0, 5.0, 5.0, 2.0,0, 157, 0,200,0,0,0,50)
					else
						DrawMarker(36, item2.x, item2.y, item2.z, 0, 0, 0, 0, 0, Rotation, 5.0, 5.0, 2.0, 0, 157, 0, 155, 0, 0, 2, 0, 0, 0, 0)
					end
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), item2.x, item2.y, item2.z, true ) < 5 then
					DrawText3Ds(item2.x, item2.y, item2.z + 0.9, "Tryk [~g~E~s~] for at vaske dit køretøj!")
					if IsControlJustPressed(1, 38) then
						TriggerServerEvent('carwash:checkmoney', GetVehicleDirtLevel(GetVehiclePedIsIn(GetPlayerPed(-1),false)))
					    end
					end
				end
			end
		end
	end
end)

RegisterNetEvent('carwash:success')
AddEventHandler('carwash:success', function()
	SetVehicleDirtLevel(GetVehiclePedIsIn(GetPlayerPed(-1),false), 0.0)
	SetVehicleUndriveable(GetVehiclePedIsIn(GetPlayerPed(-1),false), false)
	TriggerEvent("pNotify:SendNotification", {text = "Betalte 1000 DKK", type = "info", queue = "global", timeout = 5000, layout = "bottomCenter",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
end)

RegisterNetEvent('carwash:notenough')
AddEventHandler('carwash:notenough', function()
	TriggerEvent("pNotify:SendNotification", {text = "Ikke nok penge!", type = "warning", queue = "global", timeout = 5000, layout = "bottomCenter",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
end)

RegisterNetEvent('carwash:alreadyclean')
AddEventHandler('carwash:alreadyclean', function()
	TriggerEvent("pNotify:SendNotification", {text = "Du behøves ikke at vaske køretøjet flere gange!", type = "warning", queue = "global", timeout = 5000, layout = "bottomCenter",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
end)

DrawText3Ds = function(x,y,z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())

	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end
