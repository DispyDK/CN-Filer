--[[
    FiveM Scripts
    Copyright C 2018  Sighmir

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    at your option any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

local robbing = false
local bank = ""
local secondsRemaining = 0
local banks = cfg.banks
local trolleyData = {}
local hackdoor1 = 0
local plans = false
local thermiteok = false
incircle = false
incircle1 = false
incircle2 = false
incircle3 = false
incircle5 = false
candrill = false
local objectslist = {
	269934519,
}

--RegisterCommand("head", function()
--	TriggerServerEvent("vrp_doors:changeStatus", 395, false)
--end)


---------------------------------------------------------------------------------------------------EVENTS---------------------------------------------------------------------------------------------------
RegisterNetEvent('plan')
AddEventHandler('plan', function()
		plans = true
end)

RegisterNetEvent('thermiteok')
AddEventHandler('thermiteok', function()
	thermiteok = true
end)

RegisterNetEvent('es_bank:currentlyrobbing')
AddEventHandler('es_bank:currentlyrobbing', function(robb)
	robbing = true
	bank = robb
	secondsRemaining = cfg.seconds
end)

RegisterNetEvent('es_bank:toofarlocal')
AddEventHandler('es_bank:toofarlocal', function(robb)
	robbing = false
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Røveriet blev aflyst")
	robbingName = ""
	secondsRemaining = 0
	incircle = false
end)

RegisterNetEvent('es_bank:playerdiedlocal')
AddEventHandler('es_bank:playerdiedlocal', function(robb)
	robbing = false
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Røveriet blev aflyst, du døde!.")
	robbingName = ""
	secondsRemaining = 0
	incircle = false
end)


RegisterNetEvent('es_bank:robberycomplete')
AddEventHandler('es_bank:robberycomplete', function()
	robbing = false
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Røveriet gennemført")
	bank = ""
	secondsRemaining = 0
	incircle = false
end)
RegisterNetEvent('Clean')
AddEventHandler('Clean', function()
	DespawnTrolleys()
	TriggerServerEvent("vrp_doors:changeStatus", 381, true)
	TriggerServerEvent("vrp_doors:changeStatus", 382, true)
	TriggerServerEvent("vrp_doors:changeStatus", 383, true)
	TriggerServerEvent("vrp_doors:changeStatus", 384, true)
	TriggerServerEvent("vrp_doors:changeStatus", 385, true)
	TriggerServerEvent("vrp_doors:changeStatus", 386, true)
	TriggerServerEvent("vrp_doors:changeStatus", 387, true)
	TriggerServerEvent("vrp_doors:changeStatus", 388, true)
	TriggerServerEvent("vrp_doors:changeStatus", 389, true)
	TriggerServerEvent("vrp_doors:changeStatus", 390, true)
	TriggerServerEvent("vrp_doors:changeStatus", 391, true)
	TriggerServerEvent("vrp_doors:changeStatus", 392, true)
	TriggerServerEvent("vrp_doors:changeStatus", 393, true)
	TriggerServerEvent("vrp_doors:changeStatus", 394, true)
	TriggerServerEvent("vrp_doors:changeStatus", 395, true)
	--SetEntityRotation(961976194, 0, 0, 0.0, 2, 1)
end)

local thermited = 0
RegisterNetEvent("ir_force:terkidan")
AddEventHandler("ir_force:terkidan",function(thermiteID,model1,doorheading,door1, doorID)
	thermited = model1
	terkidan(thermiteID,model1,doorheading,door1, doorID)
end)

---------------------------------------------------------------------------------------------------THREADS----------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		if robbing then
			Citizen.Wait(1000)
			if(secondsRemaining > 0)then
				secondsRemaining = secondsRemaining - 1
			end
		end

		Citizen.Wait(0)
	end
end)

if cfg.blips then -- blip settings
  Citizen.CreateThread(function()
	for k,v in pairs(banks)do
		local ve = v.position

		local blip = AddBlipForCoord(ve.x, ve.y, ve.z)
		SetBlipSprite(blip, 278)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Robbable Bank")
		EndTextCommandSetBlipName(blip)
	end
  end)
end



Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1), true)


		for k,v in pairs(banks)do
			local pos2 = v.position
			local drill = v.drill

			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 80.0)then
				if not robbing then
					DrawMarker(23, v.position.x, v.position.y, v.position.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)

					if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 2)then
						if (incircle == false) then
							bank_DisplayHelpText("Tryk ~INPUT_CONTEXT~ for at røve ~b~" .. v.nameofbank .. "~w~ ")
						end
						incircle = true
						if(IsControlJustReleased(1, 51))then
							if (k == "Danmarks Nationalbank") == false then
							local test = true
							RegisterNetEvent('es_bank:readCooldown')
							AddEventHandler('es_bank:readCooldown', function(cooldown)
								if (cooldown < 1 or cooldown == 3600 and test ) then
									test = false
								end
							end)
								TriggerServerEvent('es_bank:rob', k)
								SpawnTrolleys(v.trolleys)
								local cooldown = TriggerServerEvent('es_bank:getCooldown')
							else
								TriggerServerEvent("vrp_bank:checkplans")
								Wait(1000)
								if plans then
									TriggerServerEvent("Useitem", "nationalbankenplan" )
									local test = true
									RegisterNetEvent('es_bank:readCooldown')
									AddEventHandler('es_bank:readCooldown', function(cooldown)
										if (cooldown < 1 or cooldown == 3600 and test ) then
											test = false
										end
									end)
									TriggerServerEvent('es_bank:rob', k)
									SpawnTrolleys(v.trolleys)
									local cooldown = TriggerServerEvent('es_bank:getCooldown')
									plans = false
								else
									TriggerEvent("pNotify:SendNotification",{text = "Du mangler en plan!",type = "info",timeout = (2000),layout = "bottomRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
								end
							end
						end
					elseif(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 2)then
						incircle = false
					end
				end
			end
			if robbing then
				local terminal = v.terminal
				local terminal2 = v.terminal2
				local door1 = v.door1
				local pos3 = GetEntityCoords(GetPlayerPed(-1), true)
				if(Vdist(pos3.x, pos3.y, pos3.z, terminal) < 1.0)then

					DrawMarker(23, terminal - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)

					if(Vdist(pos3.x, pos3.y, pos3.z, terminal) < 1)then
						if (incircle1 == false) then
							bank_DisplayHelpText("Tryk ~INPUT_CONTEXT~ for at Hack ~b~"..v.nameofbank.. "~w~")
						end
						incircle1 = true
						if(IsControlJustReleased(1, 51))then
							hackdoor1 = v.door2ID
							TriggerEvent("mhacking:show")
							TriggerEvent("mhacking:start",7,15,mycb)
						end
					elseif(Vdist(pos3.x, pos3.y, pos3.z, terminal) > 1)then
						incircle1 = false
					end
				end

				if(Vdist(pos3.x, pos3.y, pos3.z, terminal2) < 1.0)then

					DrawMarker(23, v.terminal2.x, v.terminal2.y, v.terminal2.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)

					if(Vdist(pos3.x, pos3.y, pos3.z, terminal2) < 1)then
						if (incircle2 == false) then
							bank_DisplayHelpText("Tryk ~INPUT_CONTEXT~ for at Hack ~b~"..v.nameofbank.. "~w~")
						end
						incircle2 = true
						if(IsControlJustReleased(1, 51))then
							TriggerEvent("mhacking:show")
							TriggerEvent("mhacking:start",7,15, mycb2)
						end
					elseif(Vdist(pos3.x, pos3.y, pos3.z, terminal2) > 1)then
						incircle2 = false
					end
				end
				bank_drawTxt(0.66, 1.44, 1.0,1.0,0.4, "Røveri igang: ~r~" .. secondsRemaining .. "~w~ sekunder tilbage", 255, 255, 255, 255)

				local pos2 = banks[bank].position
				local ped = GetPlayerPed(-1)

				if IsEntityDead(ped) then
					TriggerServerEvent('es_bank:playerdied', bank)
				elseif (Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 50)then
					TriggerServerEvent('es_bank:toofar', bank)
				end
				if(Vdist(pos.x, pos.y, pos.z, drill) < 1.0)then

					DrawMarker(23, v.drill.x, v.drill.y, v.drill.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)

					if(Vdist(pos.x, pos.y, pos.z, drill) < 1)then
						if (incircle3 == false) then
							bank_DisplayHelpText("Tryk ~INPUT_CONTEXT~ for at åbne den bankboxe ~b~~w~ Du er måske heldig!")
						end
						incircle3 = true
						if(IsControlJustReleased(1, 51))then
							DrillAnimation()
							if candrill == true then
								if k == "Danmarks Nationalbank" then
									local number = math.random(1, 100)
									if number <= 5 then
										TriggerServerEvent('Goldencard')
									else
										TriggerServerEvent("Silvercard")
									end
								else
									local number = math.random(1, 100)
									if number <= 30 then
										TriggerServerEvent('Nationalbanken')
									end
									--if number >= 90 then
									--	TriggerServerEvent('Skattekort1')
									--end
									--if number <= 80 and number >= 89 then
									--	TriggerServerEvent('Skattekort2')
									--
									--end
									--if number <= 70 and number >= 79 then
									--	TriggerServerEvent('Nøgletilbil')
									--end
									if number >= 31 and number <= 100 then
										TriggerServerEvent('Silvercard')
									end
								end
								candrill = false
							end
						end
					elseif(Vdist(pos.x, pos.y, pos.z, drill) > 1)then
						incircle3 = false
					end
				end
				--if IsNeardoor(v.model1) then
				--	bank_DisplayHelpText("Tryk på ~INPUT_CONTEXT~ for at placere en thermite bombe ~b~~w~ Skynd dig!")
				--	if(IsControlJustReleased(1, 51))then
				--		TriggerServerEvent("thermitebombcheck")
				--		Wait(500)
				--		if thermiteok then
				--			thermite(v.door1, v.model1, v.doorheading, v.door1ID)
				--			thermiteok = false
				--		else
				--			TriggerEvent("pNotify:SendNotification",{text = "Du mangler en bombe!",type = "info",timeout = (2000),layout = "bottomRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
				--		end
				--	end
				--end

				if(Vdist(pos3.x, pos3.y, pos3.z, door1) < 2.0)then

					DrawMarker(23, v.door1.x, v.door1.y, v.door1.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)

					if(Vdist(pos3.x, pos3.y, pos3.z, door1) < 2)then
						if (incircle5 == false) then
							bank_DisplayHelpText("Tryk på ~INPUT_CONTEXT~ for at placere en thermite bombe ~b~~w~ Skynd dig!")
						end
						incircle5 = true
						if(IsControlJustReleased(1, 51))then
							TriggerServerEvent("thermitebombcheck")
							Wait(500)
							if thermiteok then
								thermite(v.door1, v.model1, v.doorheading, v.door1ID)
								thermiteok = false
							else
								TriggerEvent("pNotify:SendNotification",{text = "Du mangler en bombe!",type = "info",timeout = (2000),layout = "bottomRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
							end
						elseif(Vdist(pos3.x, pos3.y, pos3.z, door1) > 2)then
							incircle5 = false
						end
					end
				end
			end
		end
		if IsNearTrolly() then
			bank_DisplayHelpText("Tryk på ~INPUT_CONTEXT~ for at tage pengene i tasken ~b~~w~ tag så meget du kan!")
			if(IsControlJustReleased(1, 51))then
				GrabCash()
			end
		end
		Citizen.Wait(0)
	end
end)



---------------------------------------------------------------------------------------------------FUNCTIONS----------------------------------------------------------------------------------------------------
SpawnTrolleys = function(trolleys)
	local bankTrolleys = trolleys


	for trolley, values in pairs(bankTrolleys) do
		if not HasModelLoaded(values.model) then
			RequestModel(
					GetHashKey("hei_prop_hei_cash_trolly_01")
			)
		end

		local trolleyObject = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), values["pos"], true)
		SetEntityRotation(trolleyObject, 0.0, 0.0, values["heading"])

		PlaceObjectOnGroundProperly(trolleyObject)
		SetEntityAsMissionEntity(trolleyObject, true, true)

		trolleyData[trolley] = {
			["net"] = ObjToNet(trolleyObject),
			["money"] = values.cash
		}

		SetModelAsNoLongerNeeded(GetHashKey("hei_prop_hei_cash_trolly_01"))
	end

	return trolleyData
end

DespawnTrolleys = function()
	local player = GetPlayerPed(-1)
	local pos = GetEntityCoords(player)

	local handle, object = FindFirstObject()
	local success


	if has_value(objectslist, GetEntityModel(object)) then
		RemoveObject(object)
	end
	repeat
		success, object = FindNextObject(handle)

		if has_value(objectslist, GetEntityModel(object)) then
			RemoveObject(object)
		end
	until not success

	EndFindObject(handle)
end

function DrawText3Ds(x,y,z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())

	SetTextScale(0.32, 0.32)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end

function RemoveObject(object)
	SetEntityAsMissionEntity(object,  false,  true)
	DeleteObject(object)
end

function has_value (tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end

	return false
end

function DrillAnimation()
	local playerPed = GetPlayerPed(-1)
	TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
	FreezeEntityPosition(playerPed,true)
	Wait(60000)
	FreezeEntityPosition(playerPed,false)
	candrill = true
end

terkidan = function(thermiteID,model1,doorheading,door1, doorID)
	Citizen.CreateThread(function()
		local thermiteFlash = NetworkGetEntityFromNetworkId(thermiteID)
		RequestNamedPtfxAsset("scr_ornate_heist")
		while not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
			Citizen.Wait(100)
		end
		SetPtfxAssetNextCall("scr_ornate_heist")
		StartParticleFxLoopedOnEntity("scr_heist_ornate_thermal_burn",thermiteFlash,0,1.0,0,0,0,0,1.0,false,false,false)
		StartParticleFxLoopedOnEntity("scr_heist_ornate_thermal_sparks",thermiteFlash,0,1.0,0,0,0,0,1.0,false,false,false)
		StartParticleFxLoopedOnEntity("scr_heist_ornate_thermal_glow",thermiteFlash,0,1.0,0,0,0,0,1.0,false,false,false)
		StartParticleFxLoopedOnEntity("sp_fbi_fire_trail_smoke",thermiteFlash,0,1.0,0,0,0,0,1.0,false,false,false)
		Citizen.Wait(30000)
		DeleteEntity(thermiteFlash)
		TriggerServerEvent("vrp_doors:changeStatus", doorID, false)
		TriggerServerEvent('ir_force:bazsho', door1, model1)
	end)
end

thermite = function(door1, model1, doorheading, doorID)
	Citizen.CreateThread(function()
		local player = GetPlayerPed(-1)
		local coords = GetEntityCoords(player)
			local doorEntity = GetClosestObjectOfType(door1, 5.0, model1, false)
			if Vdist(coords, door1, true) <= 2.5 then
				SetEntityCoords(player, door1)
				SetEntityHeading(player, doorheading)
				RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
				while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") do
					Wait(50)
				end
				RequestModel("hei_prop_heist_thermite")
				while not HasModelLoaded("hei_prop_heist_thermite") do
					Wait(50)
				end
				local thermite = CreateObject(GetHashKey("hei_prop_heist_thermite"), GetEntityCoords(player),  true,  true, true)
				AttachEntityToEntity(thermite, player, GetPedBoneIndex(GetPlayerPed(-1), 28422), 0, 0, 0, 0, 0, 175.0, true, true, false, true, 1, true)
				TaskPlayAnim(player,"anim@heists@ornate_bank@thermal_charge","thermal_charge", 0.8, 0.0, -1,0, 0, 0, 0, 0)
				blockKeys = true
				Citizen.Wait(5000)
				DetachEntity(thermite)
				FreezeEntityPosition(thermite,true)
				blockKeys = false
				TriggerServerEvent('ir_force:kashtan', NetworkGetNetworkIdFromEntity(thermite),model1, door1, doorheading, doorID)
				Citizen.Wait(30000)
				ClearPedTasksImmediately(player)
				TriggerServerEvent("Useitem", "thermite" )
			end
	end)
end

function mycb(success, timeremaining)
	if success then
		print('Success with '..timeremaining..'s remaining.')
		TriggerServerEvent("vrp_doors:changeStatus", hackdoor1, false)
		TriggerEvent('mhacking:hide')
	else
		print('Failure')
		TriggerEvent('mhacking:hide')
	end
end

function mycb2(success, timeremaining)
	if success then
		print('Success with '..timeremaining..'s remaining.')
		TriggerServerEvent("vrp_doors:changeStatus", 383, false)
		TriggerEvent('mhacking:hide')
	else
		print('Failure')
		TriggerEvent('mhacking:hide')
	end
end

function IsNearTrolly()
	local ply = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(ply, 0)
	local trolley = GetClosestObjectOfType( plyCoords["x"], plyCoords["y"], plyCoords["z"], 5.0, GetHashKey("hei_prop_hei_cash_trolly_01"), false)
	local plyCoords2 = GetEntityCoords(trolley, 0)
		local distance = GetDistanceBetweenCoords(plyCoords2["x"], plyCoords2["y"], plyCoords2["z"],  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
		if(distance <= 1.5) then
			return true
		end
end







--function IsNeardoor(model1)
--	local ply = GetPlayerPed(-1)
--	local plyCoords = GetEntityCoords(ply, 0)
--	local door = GetClosestObjectOfType( plyCoords["x"], plyCoords["y"], plyCoords["z"], 5.0, model1, false)
--	local plyCoords2 = GetEntityCoords(door, 0)
--	local distance = GetDistanceBetweenCoords(plyCoords2["x"], plyCoords2["y"], plyCoords2["z"],  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
--	if(distance <= 1.5) then
--		return true
--	end
--end




GrabCash = function()
	local ped = GetPlayerPed(-1)

	loadAnimDict('anim@heists@ornate_bank@grab_cash_heels')
	TaskPlayAnim(PlayerPedId(), "anim@heists@ornate_bank@grab_cash_heels", "grab", 8.0, -8.0, -1, 1, 0, false, false, false)

	Citizen.Wait(7500)

	ClearPedTasks(PlayerPedId())

	local cashRecieved = math.random(5000, 7000)

	TriggerServerEvent("grabbedCash", cashRecieved)
end




function loadAnimDict(dict)
	Citizen.CreateThread(function()
		while (not HasAnimDictLoaded(dict)) do
			RequestAnimDict(dict)

			Citizen.Wait(1)
		end
	end)
end

function bank_DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function bank_drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	if(outline)then
		SetTextOutline()
	end
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

