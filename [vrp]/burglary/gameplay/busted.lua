

CreateThread(function()
	while true do
		Wait(0)

		local door = doors[lastDoor].coords

		-- if time is up
		if TimeToSeconds(GetClockTime()) > TimeToSeconds(5, 30, 0) and onMission then
			-- if still in the house
			if GetCurrentHouse() then
				-- mission failed we'll get em next time
				UI.ShowMPMessage("~r~Indbrud fejlet", "Du forlod ikke huset før det blev morgen!", 3500)
				TriggerServerEvent("burglary:ended", true, true, lastDoor, GetStreet(door.x, door.y, door.z))
			else
				-- player made it before time
				TriggerServerEvent("burglary:ended", false)
			end

			ForceEndMission()
		end

		if onMission then
			if CanPedHearPlayer(PlayerId(), peds[1]) then
				ClearPedTasks(peds[1])
				PlayPain(peds[1], 7, 0)
				Wait(5000)
				UI.ShowMPMessage("~r~Indbrud fejlet", "Du vækkede en beboer!", 3500)
				TriggerServerEvent("burglary:ended", true, true, lastDoor, GetStreet(door.x, door.y, door.z))

				-- if resident is aggresive
				if HasPedGotWeapon(peds[1], GetHashKey("WEAPON_PISTOL"), false) then
					SetCurrentPedWeapon(peds[1], GetHashKey("WEAPON_PISTOL"), true)
					TaskShootAtEntity(peds[1], PlayerPedId(), -1, 2685983626)
				end
			end
		end

		if IsPedCuffed(PlayerPedId()) and onMission then
			UI.ShowMPMessage("~r~Indbrud fejlet", "Du blev arresteret.", 3500)
			TriggerServerEvent("burglary:ended", true, false)

			ForceEndMission()
		end

		-- cancel mission if player is dead
		if IsPedDeadOrDying(PlayerPedId()) then
			TriggerServerEvent("burglary:ended", true, false)

			ForceEndMission()
		end

		-- check if van is not destroyed
		--[[if IsEntityDead(currentVan) and onMission then
			UI.ShowMPMessage("~r~Burglary failed", "Your van got destroyed.", 3500)
			TriggerServerEvent("burglary:ended", true, false)

			ForceEndMission()
		end]]--
	end
end)

function ForceEndMission()
	if isHolding then
		DetachEntity(holdingProp)
	end

	-- lot of cleanup
	isHolding = false
	holdingProp = nil

	stolenItems = {}
	currentItem = {}

	-- reset anim
	ClearPedTasks(PlayerPedId())
	SetPedCanSwitchWeapon(PlayerPedId(), not isHolding)

	onMission = false
	SetVehicleAsNoLongerNeeded(NetToVeh(currentVan))

	RemoveBlips()
	RemovePickups()
end
