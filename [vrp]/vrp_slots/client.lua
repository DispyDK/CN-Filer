-- This resource was made by plesalex100#7387
-- Please respect it, don't repost it without my permission
-- This Resource started from: https://codepen.io/AdrianSandu/pen/MyBQYz


local open = false

local function drawHint(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
	if Cfg.blipsEnabled then
		for k,v in ipairs(Cfg.Pacanele)do
			local blip = AddBlipForCoord(v.x, v.y, v.z)
			SetBlipSprite(blip, 436)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, 1.0)
			SetBlipColour(blip, 49)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Pacanele")
			EndTextCommandSetBlipName(blip)
		end
	end
end)

Citizen.CreateThread(function ()
	SetNuiFocus(false, false)
	open = false

	local wTime = 500
	local x = 1
	while true do
		Citizen.Wait(wTime)
		langaAparat = false

		for i=1, #Cfg.Pacanele, 1 do
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Cfg.Pacanele[i].x, Cfg.Pacanele[i].y, Cfg.Pacanele[i].z, true) < 2  then
				x = i
				wTime = 0
				langaAparat = true
				drawHint('Tryk på ~INPUT_PICKUP~ for at bruge maskinen')
			elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Cfg.Pacanele[x].x, Cfg.Pacanele[x].y, Cfg.Pacanele[x].z, true) > 4 then
				wTime = 500
			end
		end
	end
end)

RegisterNetEvent("ples-slots:bagXLei")
AddEventHandler("ples-slots:bagXLei", function(lei)
	SetNuiFocus(true, true)
	open = true
	SendNUIMessage({
		showPacanele = "open",
		coinAmount = tonumber(lei)
	})
end)

RegisterNUICallback('exitWith', function(data, cb)
	cb('ok')
	SetNuiFocus(false, false)
	open = false
	TriggerServerEvent("ples-slots:aiCastigat", data.coinAmount)
end)

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(1)
		if open then
			DisableControlAction(0, 1, true) -- LookLeftRight
			DisableControlAction(0, 2, true) -- LookUpDown
			DisableControlAction(0, 24, true) -- Attack
			DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
		elseif IsControlJustReleased(0, 38) and langaAparat then
			TriggerServerEvent('ples-slots:catiLeiBagi')
		end
	end
end)
