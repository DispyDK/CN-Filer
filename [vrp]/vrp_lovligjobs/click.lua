vRP = Proxy.getInterface("vRP")

local menuEnabled = false

RegisterNetEvent("ToggleActionmenu")
AddEventHandler("ToggleActionmenu", function()
	ToggleActionMenu()
end)

function ToggleActionMenu()
	Citizen.Trace("tutorial launch")
	menuEnabled = not menuEnabled
	if ( menuEnabled ) then
		SetNuiFocus( true, true )
		SendNUIMessage({
			showPlayerMenu = true
		})
	else
		SetNuiFocus( false )
		SendNUIMessage({
			showPlayerMenu = false
		})
	end
end

function killTutorialMenu()
	SetNuiFocus( false )
	SendNUIMessage({
		showPlayerMenu = false
	})
	menuEnabled = false

end


RegisterNUICallback('close', function(data, cb)
	ToggleActionMenu()
	cb('ok')
end)

function DrawText3Ds(x,y,z, text)
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

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(1)
		DrawMarker(27, -266.821,-960.292,31.223-1.0001,0,0,0,0,0,0,1.0001,1.0001,1.0001, 0, 232, 255,200,0,0,0,50)
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -266.821,-960.292,31.223, true ) < 3.0 then
			DrawText3Ds(-266.821,-960.292,31.223,"Tryk ~g~E~s~ for at snakke med jobcenteret!")
			if (IsControlJustReleased(1, 51)) then
				SetNuiFocus( true, true )
				SendNUIMessage({
					showPlayerMenu = true
				})
			end
		end
	end
end)

RegisterNUICallback('taxi', function(data, cb)
	killTutorialMenu()
	TriggerServerEvent("taxi")
	cb('ok')
end)

RegisterNUICallback('miner', function(data, cb)
	killTutorialMenu()
	TriggerServerEvent("miner")
	cb('ok')
end)

RegisterNUICallback('skovhugger', function(data, cb)
	killTutorialMenu()
	TriggerServerEvent("skovhugger")
	cb('ok')
end)

RegisterNUICallback('farmer', function(data, cb)
	killTutorialMenu()
	TriggerServerEvent("farmer")
	cb('ok')
end)

RegisterNUICallback('lastbilchauffor', function(data, cb)
	killTutorialMenu()
	TriggerServerEvent("lastbilchauffor")
	cb('ok')
end)

RegisterNUICallback('skraldemand', function(data, cb)
	killTutorialMenu()
	TriggerServerEvent("skraldemand")
	cb('ok')
end)

RegisterNUICallback('arbejdslos', function(data, cb)
	killTutorialMenu()
	TriggerServerEvent("arbejdslos")
	cb('ok')
end)

RegisterNUICallback('pizzabud', function(data, cb)
	killTutorialMenu()
	TriggerServerEvent("pizzabud")
	cb('ok')
end)

RegisterNUICallback('closeButton', function(data, cb)
	killTutorialMenu()
	cb('ok')
end)
