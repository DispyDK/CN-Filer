vRP = Proxy.getInterface("vRP")

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

RegisterNetEvent("dive:water")
AddEventHandler('dive:water', function()
	local ped = PlayerPedId()
	if IsEntityInWater(ped) then
		TriggerServerEvent('dive:gear')
	else
		TriggerEvent("pNotify:SendNotification",{text = "Du skal være i vandet før du kan tage dykker dragt på.",type = "success",timeout = (2000),layout = "centerLeft",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
	end
end)


RegisterNetEvent('cn:dykkerdragt') -- Tag dykkerdragt på
AddEventHandler('cn:dykkerdragt', function()
	local ped = PlayerPedId()
	if not vRP.isHandcuffed() then
		loadAnimDict("clothingtie")
		TaskPlayAnim(ped, "clothingtie", "try_tie_positive_a", 5.0, 5.0, -1, 48, 0, 0, 0, 0)
	end
		Citizen.Wait(3000)
	    SetPedComponentVariation(ped, 8, 0, 240, 0) -- undertrøje
		if(GetEntityModel(ped) == GetHashKey("mp_f_freemode_01")) then
	        SetPedComponentVariation(ped, 11, 251, 17, 2) -- dykkerdragt top på kvinde		        SetPedComponentVariation(ped, 11, 285, 17, 2) -- dykkerdragt top på kvinde
	        SetPedComponentVariation(ped, 8, 153, 0, 2) -- dykkertank kvinde		        SetPedComponentVariation(ped, 8, 187, 0, 2) -- dykkertank kvinde
	        SetPedComponentVariation(ped, 4, 97, 17, 2) -- dykkerdragt bund på kvinde		        SetPedComponentVariation(ped, 4, 131, 17, 2) -- dykkerdragt bund på kvinde
	        SetPedComponentVariation(ped, 6, 70, 17, 2) -- svømmefødder på kvinde		        SetPedComponentVariation(ped, 6, 104, 17, 2) -- svømmefødder på kvinde
	        SetPedComponentVariation(ped, 3, 18, 0, 2) -- arme på kvinde		        SetPedComponentVariation(ped, 3, 52, 0, 2) -- arme på kvinde
			SetPedPropIndex(GetPlayerPed(-1), 1, 28, 17, 2) -- dykkerbriller				SetPedPropIndex(GetPlayerPed(-1), 1, 62, 17, 2) -- dykkerbriller
	    else
	        SetPedComponentVariation(ped, 11, 243, 17, 2) -- dykkerdragt top på mand		        SetPedComponentVariation(ped, 11, 277, 0, 2) -- dykkerdragt top på mand
	        SetPedComponentVariation(ped, 8, 123, 0, 2) -- dykkertank mand		        SetPedComponentVariation(ped, 8, 123, 0, 2) -- dykkertank mand
	        SetPedComponentVariation(ped, 4, 94, 17, 2) -- dykkerdragt bund på mand		        SetPedComponentVariation(ped, 4, 128, 13, 2) -- dykkerdragt bund på mand
	        SetPedComponentVariation(ped, 6, 67, 17, 2) -- svømmefødder på mand		        SetPedComponentVariation(ped, 6, 101, 17, 2) -- svømmefødder på mand
	        SetPedComponentVariation(ped, 3, 17, 0, 2) -- arme på mand		        SetPedComponentVariation(ped, 3, 51, 0, 2) -- arme på mand
			SetPedPropIndex(GetPlayerPed(-1), 1, 26, 17, 2) -- dykkerbriller
	    end
	TriggerEvent("pNotify:SendNotification",{text = "Du tog dykkerdragten på.",type = "success",timeout = (2000),layout = "centerLeft",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
end)

dive = false

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(0)
		if dive == false then
			SetPedMaxTimeUnderwater(GetPlayerPed(-1),22.0)
		end
	end
end)
