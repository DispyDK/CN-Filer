

local blacklistedWeapon = false

Citizen.CreateThread(function()
	while true do
		Wait(1000)

		local playerPed = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		local speed = GetEntitySpeed(vehicle)
		local kmh = 3.6
		local disabledWeapons = {'WEAPON_REVOLVER', 'WEAPON_SNOWBALL', 'WEAPON_MACHINEPISTOL', 'WEAPON_MICROSMG', 'WEAPON_MOLOTOV', 'WEAPON_PUMPSHOTGUN', 'WEAPON_ASSAULTSHOTGUN', 'WEAPON_SAWNOFFSHOTGUN', 'WEAPON_APPISTOL', 'WEAPON_MINISMG', 'WEAPON_MICROSMG', 'WEAPON_PISTOL50'}
		local weapon = GetSelectedPedWeapon(playerPed)

		if weapon == GetHashKey("WEAPON_APPISTOL") or weapon == GetHashKey("WEAPON_MICROSMG") or weapon == GetHashKey("WEAPON_SNOWBALL") or weapon == GetHashKey("WEAPON_SAWNOFFSHOTGUN") or weapon == GetHashKey("WEAPON_MINISMG") or weapon == GetHashKey("WEAPON_MACHINEPISTOL") or weapon == GetHashKey("WEAPON_PISTOL50") or weapon == GetHashKey("WEAPON_REVOLVER")then
			SetPlayerCanDoDriveBy(PlayerId(),false)
			blacklistedWeapon = true
		else
			blacklistedWeapon = false
			if math.floor(speed*kmh) < 35 then
				SetPlayerCanDoDriveBy(PlayerId(),true)
			else
				SetPlayerCanDoDriveBy(PlayerId(),false)
			end
		end
		if GetVehicleClass(vehicle) == 12 and math.floor(speed*kmh) < 35 and blacklistedWeapon then
			SetPlayerCanDoDriveBy(PlayerId(),true)
		elseif blacklistedWeapon then
			SetPlayerCanDoDriveBy(PlayerId(),false)
		end
	end
end)