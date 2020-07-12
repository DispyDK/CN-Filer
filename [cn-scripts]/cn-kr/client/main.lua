vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "cn-kr")

vRPex = Proxy.getInterface("vrp_extended")

function Draw3DText(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local px, py, pz = table.unpack(GetGameplayCamCoords())

	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x, _y)
	local factor = (string.len(text)) / 370
	DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 20,20,20,150)
end

local moneys = 0
local show = false

function openGui()
  if show == false then
    show = true
    SetNuiFocus(true, true)

    SendNUIMessage(
      {
        show = true
      }
    )
  end
end

function closeGui()
  show = false
  SetNuiFocus(false)
  SendNUIMessage({show = false})
end

local source = 2

RegisterNetEvent("cn-kr:openGui")
AddEventHandler("cn-kr:openGui", function(user_id)
	user_id = user_id
    openGui()
end)

RegisterNetEvent("cn-kr:updateEfterlysning")
AddEventHandler("cn-kr:updateEfterlysning",function(content)
	SendNUIMessage({
		efterlys = true,
		efterlysning = content
	})
end)


RegisterNetEvent("cn-kr:updatePersonregister")
AddEventHandler("cn-kr:updatePersonregister",function(content)
	SendNUIMessage({
		register = true,
		personregister = content
	})
end)

RegisterNetEvent("cn-kr:updateKoretojer")
AddEventHandler("cn-kr:updateKoretojer",function(content)
	SendNUIMessage({
		koretoj = true,
		koretojer = content
	})
end)

RegisterNetEvent("cn-kr:updateBoder")
AddEventHandler("cn-kr:updateBoder",function(content)
	SendNUIMessage({
		bode = true,
		boder = content
	})
end)

RegisterNetEvent("cn-kr:closeGui")
AddEventHandler("cn-kr:closeGui",function()
  closeGui()
end)


RegisterNUICallback(
  "close",
  function(data)
    closeGui()
  end
)



RegisterNUICallback("efterlysning", function(value)
	TriggerServerEvent("cn-kr:checkEfterlysning", value, player)
	TriggerServerEvent("cn-kr:checkPersonregister", value, player)
	TriggerServerEvent("cn-kr:checkKoretojer", value, player)
	TriggerServerEvent("cn-kr:checkBoder", value, player)
end)


RegisterNUICallback("frakend", function(value)
	TriggerServerEvent("cn-kr:frakend", value, player)
end)

RegisterNUICallback("givklip", function(value)
	TriggerServerEvent("cn-kr:givklip", value, player)
end)

RegisterNUICallback("bode", function(value)
	TriggerServerEvent("cn-kr:bode", value, player)
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
		local player = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(player, false)
    local coords = GetEntityCoords(player,true)
    if IsControlPressed(0, 168) and not show then
				local job = vRPex.getUser().job
				if string.match(job, "Politi") or string.match(job, "Rigspoliti") or string.match(job, "AKS") then
      		TriggerServerEvent("cn-kr:login")
				end
    end
  end
end)


AddEventHandler(
  "onResourceStop",
  function(resource)
    if resource == GetCurrentResourceName() then
      closeGui()
    end
  end
)
