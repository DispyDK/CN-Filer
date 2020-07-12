BlacklistedWeapons = { -- Weapons that are detected
	"WEAPON_MARKSMANPISTOL",
	--"WEAPON_MACHINEPISTOL", (Tec 9)
	"WEAPON_COMBATPDW",
	"WEAPON_ASSAULTSMG",
	"WEAPON_MG",
	"WEAPON_COMBATMG",
	-- "WEAPON_ASSAULTRIFLE",
	"WEAPON_ADVANCEDRIFLE",
	"WEAPON_SPECIALCARBINE",
	"WEAPON_BULLPUPRIFLE",
	"WEAPON_HEAVYSHOTGUN",
	-- "WEAPON_BULLPUPSHOTGUN", (Beanbag Shotgun)
	"WEAPON_ASSAULTSHOTGUN",
	"WEAPON_DBSHOTGUN",
	"WEAPON_MUSKET",
	"WEAPON_HEAVYSNIPER",
	"WEAPON_MARKSMANRIFLE",
	"WEAPON_FIREWORK",
	"WEAPON_MINIGUN",
	--"WEAPON_GRENADELAUNCHER",
	"WEAPON_COMPACTLAUNCHER",
	"WEAPON_RPG",
	"WEAPON_STINGER",
	"WEAPON_HOMINGLAUNCHER",
	"WEAPON_PROXMINE",
	"WEAPON_STICKYBOMB",
	"WEAPON_GRENADE",
	"WEAPON_GARBAGEBAG"
}

BlacklistedVehicles = { -- Vehicles that are detected
	"rhino",
	"jet",
	"hyrda",
	"cargoplane",
	"buzzard",
	"lazer",
	"strikeforce",
	-- Ikke farlige
	"alphaz1",
	"blimp",
	"blimp2",
--	"avenger",
	"besra",
--	"cuban800",
	"duster",
	"howard",
	"starling",
	"luxor2",
	"mammatus",
	"miljet",
	"mogul",
--	"nimbus",
	"nokota",
--	"pyro",
	"bombushka",
	"rogue",
	"seabreeze",
	"shamal",
--	"tula",
	"molotok",
	"velum",
	"velum2",
	"vestra",
	"volatol",
	-- Motorcykel pis
	"oppressor",
	"oppressor2",
	-- Klam pis
	"thruster",
	-- Helis
	"akula",
	"annihilator",
	"cargobob",
--	"cargobob2",
	"cargobob3",
	"cargobob4",
	"hunter",
	"frogger",
	"frogger2",
	"maverick",
	"savage",
--	"seasparrow",
	"skylift",
	"supervolito2",
	"swift",
--	"swift2",
	"valkyrie",
	"valkyrie2",
	"volatus",
	"deluxo",
	"apc",
	"barrage",
	"barracks",
	"chernobog",
	"scarab",
	"scarab2",
	"scarab3",
	"halftrack",
	"khanjali",
}

CageObjs = {

}


Citizen.CreateThread(function()
	while true do
		Wait(30000)
		TriggerServerEvent("anticheese:timer")
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(60000)
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		local posx,posy,posz = table.unpack(GetEntityCoords(ped,true))
		local still = IsPedStill(ped)
		local vel = GetEntitySpeed(ped)
		local ped = PlayerPedId()
		local veh = IsPedInAnyVehicle(ped, true)
		local speed = GetEntitySpeed(ped)
		local para = GetPedParachuteState(ped)
		local flyveh = IsPedInFlyingVehicle(ped)
		local rag = IsPedRagdoll(ped)
		local fall = IsPedFalling(ped)
		local parafall = IsPedInParachuteFreeFall(ped)
		Wait(3000) -- wait 3 seconds and check again

		local more = speed - 9.0 -- avarage running speed is 7.06 so just incase someone runs a bit faster it wont trigger

		local rounds = tonumber(string.format("%.2f", speed))
		local roundm = tonumber(string.format("%.2f", more))


		newx,newy,newz = table.unpack(GetEntityCoords(ped,true))
		newPed = PlayerPedId() -- make sure the peds are still the same, otherwise the player probably respawned
		if GetDistanceBetweenCoords(posx,posy,posz, newx,newy,newz) > 200 and still == IsPedStill(ped) and vel == GetEntitySpeed(ped) and ped == newPed then
			TriggerServerEvent("AntiCheese:NoclipFlag", GetDistanceBetweenCoords(posx,posy,posz, newx,newy,newz))
		end

		if speed > 15.0 and not veh and (para == -1 or para == 0) and not flyveh and not fall and not parafall and not rag then
			--dont activate this, its broken!
			--TriggerServerEvent("AntiCheese:SpeedFlag", rounds, roundm) -- send alert along with the rounded speed and how much faster they are
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		ResetEntityAlpha(PlayerPedId())
		local fallin = IsPedFalling(PlayerPedId())
		local ragg = IsPedRagdoll(PlayerPedId())
		local parac = GetPedParachuteState(PlayerPedId())
		if parac >= 0 or ragg or fallin then
			SetEntityMaxSpeed(PlayerPedId(), 80.0)
		else
			SetEntityMaxSpeed(PlayerPedId(), 7.1) -- Counters fast running/swimming by setting max entity speed.
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)
		local weapon = theWeapon
		local blacklistedweapons = {}
		for _,theWeapon in ipairs(BlacklistedWeapons) do
			Wait(1)
			if HasPedGotWeapon(PlayerPedId(),GetHashKey(theWeapon),false) == 1 then
				table.insert(blacklistedweapons, theWeapon)
			end
		end
		if #blacklistedweapons > 0 then
			TriggerServerEvent("AntiCheese:WeaponFlag", blacklistedweapons )
		end
	end
end)

function ReqAndDelete(object, detach)
	if DoesEntityExist(object) then
		NetworkRequestControlOfEntity(object)
		while not NetworkHasControlOfEntity(object) do
			Citizen.Wait(1)
		end
		if detach then
			DetachEntity(object, 0, false)
		end
		SetEntityCollision(object, false, false)
		SetEntityAlpha(object, 0.0, true)
		SetEntityAsMissionEntity(object, true, true)
		SetEntityAsNoLongerNeeded(object)
		DeleteEntity(object)
	end
end
--
-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(500)
-- 		local ped = PlayerPedId()
-- 		local handle, object = FindFirstObject()
-- 		local finished = false
-- 		repeat
-- 			Wait(1)
-- 			if IsEntityAttached(object) and DoesEntityExist(object) then
-- 				-- if GetEntityModel(object) == GetHashKey("prop_acc_guitar_01") then
-- 				-- 	ReqAndDelete(object, true)
-- 				-- end
-- 			end
-- 			for i=1,#CageObjs do
-- 				if GetEntityModel(object) == GetHashKey(CageObjs[i]) then
-- 					ReqAndDelete(object, false)
-- 				end
-- 			end
-- 			finished, object = FindNextObject(handle)
-- 		until not finished
-- 		EndFindObject(handle)
-- 	end
-- end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedJumping(PlayerPedId()) then
			local jumplength = 0
			repeat
				Wait(0)
				jumplength=jumplength+1
				local isStillJumping = IsPedJumping(PlayerPedId())
			until not isStillJumping
			if jumplength > 250 then
				TriggerServerEvent("AntiCheese:JumpFlag", jumplength )
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(30000)
		local playerPed = GetPlayerPed(-1)
		Wait(1)
		if playerPed then
			modelfunc(GetVehiclePedIsIn(playerPed, false))
			for _, carModel in ipairs(BlacklistedVehicles) do
				modelfunc(GetClosestVehicle(x, y, z, 100.0, GetHashKey(carModel), 70))
			end
		end
	end
end)

function modelfunc(car)
	if car then
		carModel = GetEntityModel(car)
		carName = GetDisplayNameFromVehicleModel(carModel)

		if isCarBlacklisted(carModel) then
			TriggerServerEvent("AntiCheese:VehicleFlag", carName )
			_DeleteEntity(car)
		end
	end
end

function isCarBlacklisted(model)
	for _, carModel in pairs(BlacklistedVehicles) do
		if model == GetHashKey(carModel) then
			return true
		end
	end
	return false
end

function _DeleteEntity(entity)
	Citizen.InvokeNative(0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized(entity))
end
