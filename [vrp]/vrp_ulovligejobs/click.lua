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

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)
		DrawMarker(27, 374.70080566406,797.68481445313,187.4210144043-1.0001,0,0,0,0,0,0,1.0001,1.0001,1.0001, 0, 232, 255,200,0,0,0,50)
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 374.70080566406,797.68481445313,187.3210144043, true ) < 1 then
			DrawText3Ds(374.70080566406,797.68481445313,187.4210144043,"Tryk ~g~E~s~ for at snakke med mig!")
			if (IsControlJustReleased(1, 51)) then
				SetNuiFocus( true, true )
				SendNUIMessage({
					showPlayerMenu = true
				})
			end
		end
	end
end)

RegisterNUICallback('producent', function(data, cb)
	TriggerServerEvent("producent")
	killTutorialMenu()
	cb('ok')
end)
RegisterNUICallback('kemiker', function(data, cb)
	TriggerServerEvent("kemiker")
	killTutorialMenu()
	cb('ok')
end)
RegisterNUICallback('pusher', function(data, cb)
	TriggerServerEvent("pusher")
	killTutorialMenu()
	cb('ok')
end)

RegisterNUICallback('indbrudstyv', function(data, cb)
	TriggerServerEvent("indbrudstyv")
	killTutorialMenu()
	cb('ok')
end)

RegisterNUICallback('closeButton', function(data, cb)
	killTutorialMenu()
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
