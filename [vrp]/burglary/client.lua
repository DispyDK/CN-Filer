onMission = false

blips = {}
peds = {}
pickups = {}

lastDoor = 1
currentVan = nil
shouldDraw = false
missionVehicles = {
	"boxville",
	"boxville2",
	"boxville3",
	"boxville4"
}


local blipList = {}

CreateThread(function()
	if not HasStreamedTextureDictLoaded('timerbars') then
		RequestStreamedTextureDict('timerbars')
		while not HasStreamedTextureDictLoaded('timerbars') do
			Wait(0)
		end
	end

	-- load ipls
	RequestIpl("hei_hw1_blimp_interior_v_studio_lo_milo_")
	RequestIpl("hei_hw1_blimp_interior_v_apart_midspaz_milo_")

	while true do
		Wait(0)

		-- if pressed E in a vehicle and not onMission
		if IsControlJustPressed(0, 38) and not onMission and IsPedInAnyVehicle(PlayerPedId()) then
			local veh = GetVehiclePedIsIn(PlayerPedId(), false)

			if IsMissionVehicle(GetEntityModel(veh)) then
				local time = TimeToSeconds(GetClockTime())

				-- check time and cops online
				if time >= 0 and time <= TimeToSeconds(5, 30, 0) then
					onMission = true

					-- spawn blips
					for _,door in pairs(doors) do
						local blip = AddBlipForCoord(door.coords.x, door.coords.y, door.coords.z)
						SetBlipSprite(blip, 40)
						SetBlipColour(blip, 1)
						SetBlipScale(blip, 0.7)
						SetBlipAsShortRange(blip, true)

						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString("Hus Indbrud")
						EndTextCommandSetBlipName(blip)

						table.insert(blips, blip)
					end

					currentVan = VehToNet(veh)
					SetEntityAsMissionEntity(veh, false, false)

					UI.ShowMPMessage("Indbrud", "Find et ~r~hus ~s~at røve!", 3500)
				else
					UI.DisplayHelpText("Indbruds missioner, kan kun startes mellem 00:00 - 05:30!")
				end
			end
		end

	end
end)

CreateThread(function()
	while true do
		Wait(0)

		if onMission then
			-- maths to calculate time until daylight
			local hours, minutes, seconds = GetClockTime()
			local left = TimeToSeconds(5, 30, 0) - TimeToSeconds(hours, minutes, seconds)
			local time = SecondsToTime(left)

			-- draw info
			UI.DrawTimerBar("TING", #stolenItems, 2)
			UI.DrawTimerBar("DAGSLYS", AddLeadingZero(time.hours) .. ":" .. AddLeadingZero(time.minutes), 1)
		end
		local coords = GetEntityCoords(PlayerPedId())

		if onMission then
			for k,door in pairs(doors) do
				-- draw marker
				if Vdist(coords, door.coords.x, door.coords.y, door.coords.z) < 100 then
					DrawMarker(27, door.coords.x, door.coords.y, door.coords.z-0.95, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.0001, 204, 255, 0, 50, 0, 0, 0, 50)
				end

				-- can enter
				if Vdist(coords, door.coords.x, door.coords.y, door.coords.z) < 2 then
					UI.DrawText3D(door.coords.x, door.coords.y, door.coords.z, "[~g~E~s~] for at gå ind")

					if IsControlJustPressed(0, 38) then
						local house = houses[door.house]

						SetEntityCoords(PlayerPedId(), house.coords.x, house.coords.y, house.coords.z)
						SetEntityHeading(PlayerPedId(), house.coords.heading)

						lastDoor = k
						shouldDraw = true

						SpawnResidents(door.house)

						SpawnPickups(door.house, k)

						UI.ShowSubtitle("Du er nu inde i huset, husk nu du skal være stille. (snig dig)")
					end
				end
			end
		end

		-- check inside
		for _,house in pairs(houses) do
			--DrawBox(house.area[1], house.area[2], 255, 255, 255, 50)
			if IsEntityInArea(PlayerPedId(), house.area[1], house.area[2], 0, 0, 0) and shouldDraw then
				if onMission then
					UI.DrawNoiseBar(GetPlayerCurrentStealthNoise(PlayerId()), 3)
				end

				-- draw exit doors in houses (even if not in mission)
				DrawMarker(27, house.door, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.0001, 204, 255, 0, 50, 0, 0, 0, 50)

				if Vdist(coords, house.door) < 1 then
					local door = doors[lastDoor]

					SetEntityCoords(PlayerPedId(), door.coords.x, door.coords.y, door.coords.z)
					RemoveResidents()
					RemovePickups()

					shouldDraw = false

					-- play holding anim if holding something after teleported outside
					if isHolding then
						TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 1.0, 1.0, -1, 50, -1, 0, 0.0, 0, 0, 0)
					end
				end
			end
		end
		for k,v in pairs(blipList) do
				if v == 0 then
						RemoveBlip(k)
						blipList[k] = nil
				else
						blipList[k] = blipList[k]-1
				end
		end
	end
end)

function SpawnPickups(house, door)
	for k,pickup in pairs(houses[house].pickups) do
		if not IsAlreadyStolen(door, k) then
			-- spawn prop
			RequestModel(pickup.model)

			while not HasModelLoaded(pickup.model) do
				Wait(0)
			end

			local prop = CreateObject(GetHashKey(pickup.model), pickup.coord, false, false, false)
			SetEntityHeading(prop, pickup.rotation)

			-- create blip
			local blip = AddBlipForCoord(pickup.coord)
			SetBlipColour(blip, 2)
			SetBlipScale(blip, 0.7)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(pickup.model)
			EndTextCommandSetBlipName(blip)

			table.insert(pickups, {
				blip = blip,
				prop = prop,
				item = { house = house, id = k, door = door }
			})
		end
	end
end

RegisterNetEvent("burglary:finished")
AddEventHandler("burglary:finished", function(sum)
	UI.ShowMPMessage("~g~Indbrud færdigt", "Du skal nu sælge dit stjålne gods", 3500)
end)

function RemovePickups()
	for k,pickup in pairs(pickups) do
		RemoveBlip(pickup.blip)

		SetObjectAsNoLongerNeeded(pickup.prop)
		DeleteObject(pickup.prop)
	end

	pickups = {}
end

function SpawnResidents(house)
	for _,resident in pairs(residents) do
		if resident.house == house then
			RequestModel(resident.model)

			while not HasModelLoaded(resident.model) do
				Wait(0)
			end

			local ped = CreatePed(4, resident.model, resident.coord, resident.rotation, false, false)
			table.insert(peds, ped)

			-- animation
			RequestAnimDict(resident.animation.dict)

			while not HasAnimDictLoaded(resident.animation.dict) do
				Wait(0)
			end

			if resident.aggressive then
				GiveWeaponToPed(ped, GetHashKey("WEAPON_PISTOL"), 255, true, false)
			end

			TaskPlayAnimAdvanced(ped, resident.animation.dict, resident.animation.anim, resident.coord, 0.0, 0.0, resident.rotation, 8.0, 1.0, -1, 1, 1.0, true, true)
			SetFacialIdleAnimOverride(ped, "mood_sleeping_1", 0)

			SetPedHearingRange(ped, 3.0)
			SetPedSeeingRange(ped, 0.0)
			SetPedAlertness(ped, 0)
		end
	end
end

RegisterNetEvent('notifyDispatch1')
AddEventHandler('notifyDispatch1', function(coords,message)

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z, 75.0)
    SetBlipSprite(blip, 304)
    SetBlipColour(blip, 67)
    SetBlipAlpha(blip, 250)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Alarmcentralen")
    SetBlipScale(blip, 0.8)
    EndTextCommandSetBlipName(blip)

    blipList[blip] = 30000

    --Citizen.Trace("x:" .. x .. " y:" .. y .. " z:" .. z)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    TriggerEvent('chatMessage', '^3[Alarmcentralen]', "^3[Alarmcentralen]", message)
end)


function RemoveResidents()
	for k,ped in pairs(peds) do
		SetPedAsNoLongerNeeded(ped)
		DeletePed(ped)
	end

	peds = {}
end

function IsAlreadyStolen(door, id)
	for _,v in pairs(stolenItems) do
		if v.door == door and v.id == id then
			return true
		end
	end

	return false
end

function GetCurrentHouse()
	for index,house in pairs(houses) do
		if IsEntityInArea(PlayerPedId(), house.area[1], house.area[2], 0, 0, 0) then
			return true, index
		end
	end

	return false, index
end

function RemoveBlips()
	for _,blip in pairs(blips) do
		RemoveBlip(blip)
	end

	blips = {}
end

function IsMissionVehicle(model)
	for _,v in pairs(missionVehicles) do
		if model == GetHashKey(v) then
			return true
		end
	end

	return false
end
