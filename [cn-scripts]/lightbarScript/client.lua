local carSpawned = false
local newVeh = nil
local inLightbarMenu = false
local lightBool = false
local sirenBool = false
local oldSirenBool = false
local controlsDisabled = false
local xCoord = 0
local yCoord = 0
local zCoord = 0
local xrot = 0.0
local yrot = 0.0
local zrot = 0.0
local snd_pwrcall = {}
local airHornSirenID = nil
local sirenTone = "VEHICLES_HORNS_SIREN_1"
local vehPlateBoolSavedData = nil
local isPlateCar = false
local isAirhornKeyPressed = false
local deleteVehicleLightbars = {}





Citizen.CreateThread(function()
	
    while true do
      Citizen.Wait(1)
      if inLightbarMenu then
        printControlsText()
      end
        local player = GetPlayerPed(-1)
        if (IsControlJustReleased(1, 29)) then -- B - TÆND ELS-LYS
         toggleLights()
         end
         if (IsControlJustReleased(1, 254)) then -- Left shift - TÆND SIRENE
          sirenTone = "VEHICLES_HORNS_SIREN_1" -- sets siren to default siren
         toggleSiren()
         end
         if (IsControlJustReleased(1, 210)) then -- Left control - SKIFT TONE
          changeSirenTone()
          end
          if IsControlJustPressed(1, 184) and not isAirhornKeyPressed then
            playAirHorn(true)
            isAirhornKeyPressed = true
            if sirenBool then
              oldSirenBool = sirenBool
              toggleSiren()
            end
          end
          if IsControlJustReleased(1, 184) then
            playAirHorn(false)
            isAirhornKeyPressed = false
            if oldSirenBool then
              toggleSiren()
              oldSirenBool = false
            end
          end
          if isPlateCar then DisableControlAction(0,86,true) end -- Disables Veh horn
    end
  end)

function printControlsText()
                SetTextFont(0)
                SetTextProportional(1)
                SetTextScale(0.0, 0.4)
                SetTextColour(128, 128, 255, 255)
                SetTextDropshadow(0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 255)
                SetTextDropShadow()
                SetTextOutline()
                SetTextEntry("STRING")
                AddTextComponentString("Brug piletaster for at rykke lygterne.")
                DrawText(0.25, 0.9)
                -- 
                SetTextFont(0)
                SetTextProportional(1)
                SetTextScale(0.0, 0.4)
                SetTextColour(128, 128, 255, 255)
                SetTextDropshadow(0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 255)
                SetTextDropShadow()
                SetTextOutline()
                SetTextEntry("STRING")
                AddTextComponentString("'PgUp/PgDn': Højde. -- 'Insert': Vend på hovedet -- 'Delete': 90° rotation.")
                DrawText(0.25, 0.93)
				--
				SetTextFont(0)
                SetTextProportional(1)
                SetTextScale(0.0, 0.4)
                SetTextColour(128, 128, 255, 255)
                SetTextDropshadow(0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 255)
                SetTextDropShadow()
                SetTextOutline()
                SetTextEntry("STRING")
                AddTextComponentString("'SPACE' for at gemme. -- 'Backspace' for at annullere.")
                DrawText(0.25, 0.96)
end
  


function toggleLights()
  local player = GetPlayerPed(-1)
  TriggerServerEvent("toggleLights2", GetVehicleNumberPlateText(GetVehiclePedIsIn(player, false)))
  if sirenBool == true then
  TriggerServerEvent("ToggleSound1Server", GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false)))
  end
end

function changeSirenTone()
  local currPlate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
  if not(vehPlateBoolSavedData == currPlate) then
      TriggerServerEvent("returnLightBarVehiclePlates")
      while true do
          if(vehPlateBoolSavedData == GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))) then
              break
          end
          if not(currPlate == GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))) then
              return
          end
          Citizen.Wait(10)
      end
  end
if isPlateCar then
  if sirenTone == "VEHICLES_HORNS_SIREN_1" then
    sirenTone = "VEHICLES_HORNS_SIREN_2"
    toggleSiren()
    toggleSiren()
  elseif sirenTone == "VEHICLES_HORNS_SIREN_2" then
    sirenTone = "VEHICLES_HORNS_POLICE_WARNING"
    toggleSiren()
    toggleSiren()
  else
    sirenTone = "VEHICLES_HORNS_SIREN_1"
    toggleSiren()
    toggleSiren()
  end
end
end

RegisterNetEvent('openLightbarMenu')
AddEventHandler('openLightbarMenu', function(lightbarModel)
  lightMenu(lightbarModel)
end)

RegisterNetEvent('clientToggleLights')
AddEventHandler('clientToggleLights', function(lightsArray, lightsStatus, hostVehiclePointer)
  Citizen.CreateThread(function()
    for k,v in pairs(lightsArray) do 
      NetworkRequestControlOfNetworkId(v) 
      while not NetworkHasControlOfNetworkId(v) do
        Citizen.Wait(0)
      end
      local test1 = NetToVeh(v)
      lightBool = lightsStatus
      SetVehicleSiren(test1, not lightsStatus)
	  end
  end)
end)

function toggleSiren()
  if lightBool == false then
    TriggerServerEvent("ToggleSound1Server", GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false)))
  end
end

function spawnLightbar(lightbarModel)
  print("Got to spawn")
  local player = GetPlayerPed(-1)
  local vehiclehash1 = GetHashKey(lightbarModel)
  RequestModel(vehiclehash1)
  Citizen.CreateThread(function() 
      while not HasModelLoaded(vehiclehash1) do
          Citizen.Wait(100)
      end
      local coords = GetEntityCoords(player)
      newVeh = CreateVehicle(vehiclehash1, coords.x, coords.y, coords.z, GetEntityHeading(PlayerPedId()), true, 0)
      SetEntityCollision(newVeh, false, false)
      SetVehicleDoorsLocked(newVeh, 2)
      SetEntityAsMissionEntity(newVeh, true, true)
  end)
end

function lightMenu(lightbarModel)
local weaponHash = GetHashKey("WEAPON_COMBATPISTOL") -- police gun if statment 
	if HasPedGotWeapon(GetPlayerPed(-1), weaponHash, false) then

		if not inLightbarMenu then
		inLightbarMenu = true
		local player = GetPlayerPed(-1)
		spawnLightbar(lightbarModel)
		controlsDisabled = true
		disableControls()
		AttachEntityToEntity(newVeh, GetVehiclePedIsIn(player, false), 0, 0, 0, 0, 0.0, 0.0, 0.0, true, true, true, true, 0, true)
		while true do
		Citizen.Wait(10)
		--resetOffSets()
		moveObj(newVeh)
		if (IsControlJustReleased(1, 22)) then -- attatch obj and close
			TriggerServerEvent("addLightbar", GetVehicleNumberPlateText(GetVehiclePedIsIn(player, false)), VehToNet(newVeh), GetVehiclePedIsIn(player, false))
			inLightbarMenu = false
			newVeh=nil
			controlsDisabled = false
			if(vehPlateBoolSavedData == GetVehicleNumberPlateText(GetVehiclePedIsIn(player, false))) then
			isPlateCar = true
        end
        break
      end  
      if (IsControlJustReleased(1, 177)) then -- close menu
        inLightbarMenu = false
        DeleteVehicle(newVeh)
        newVeh = nil
        controlsDisabled = false
        break
		end
      end  
	end
  end
end

function moveObj(veh)
  local player = GetPlayerPed(-1)
  local MOVEMENT_CONSTANT = 0.01
  local vehOffset = GetOffsetFromEntityInWorldCoords(newVeh, 0.0, 1.3, 0.0)

  if (IsControlJustReleased(1, 121)) then -- rotate 180 upside down
    yrot = yrot + 180.0
    print("yrot = " .. yrot)
    DetachEntity(newVeh, 0, 0)
    AttachEntityToEntity(newVeh, GetVehiclePedIsIn(player, false), 0, xCoord, yCoord, zCoord, xrot, yrot, zrot, true, true, true, true, 0, true)
   end  
   if (IsControlJustReleased(1, 178)) then -- rotate 180 
    zrot = zrot + 180
    DetachEntity(newVeh, 0, 0)
    AttachEntityToEntity(newVeh, GetVehiclePedIsIn(player, false), 0, xCoord, yCoord, zCoord, xrot, yrot, zrot, true, true, true, true, 0, true)
   end  
  if (IsControlPressed(1, 190)) then -- move forward
    xCoord = xCoord + MOVEMENT_CONSTANT
    DetachEntity(newVeh, 0, 0)
    AttachEntityToEntity(newVeh, GetVehiclePedIsIn(player, false), 0, xCoord, yCoord, zCoord, xrot, yrot, zrot, true, true, true, true, 0, true)
   end       
   if (IsControlPressed(1, 189)) then -- move backwards
    xCoord = xCoord - MOVEMENT_CONSTANT
    DetachEntity(newVeh, 0, 0)
    AttachEntityToEntity(newVeh, GetVehiclePedIsIn(player, false), 0, xCoord, yCoord, zCoord, xrot, yrot, zrot, true, true, true, true, 0, true)
   end        
   if (IsControlPressed(1, 27)) then -- move right
    yCoord = yCoord + MOVEMENT_CONSTANT
    DetachEntity(newVeh, 0, 0)
    AttachEntityToEntity(newVeh, GetVehiclePedIsIn(player, false), 0, xCoord, yCoord, zCoord, xrot, yrot, zrot, true, true, true, true, 0, true)
   end       
   if (IsControlPressed(1, 187)) then -- move left
    yCoord = yCoord - MOVEMENT_CONSTANT
    DetachEntity(newVeh, 0, 0)
    AttachEntityToEntity(newVeh, GetVehiclePedIsIn(player, false), 0, xCoord, yCoord, zCoord, xrot, yrot, zrot, true, true, true, true, 0, true)
   end     
   if (IsControlPressed(1, 208)) then -- move up
    zCoord = zCoord + MOVEMENT_CONSTANT
    DetachEntity(newVeh, 0, 0)
    AttachEntityToEntity(newVeh, GetVehiclePedIsIn(player, false), 0, xCoord, yCoord, zCoord, xrot, yrot, zrot, true, true, true, true, 0, true)
   end      
   if (IsControlPressed(1, 207)) then -- move down
    zCoord = zCoord - MOVEMENT_CONSTANT
    DetachEntity(newVeh, 0, 0)
    AttachEntityToEntity(newVeh, GetVehiclePedIsIn(player, false), 0, xCoord, yCoord, zCoord, xrot, yrot, zrot, true, true, true, true, 0, true)
   end
   if (IsControlJustReleased(1, 209)) then -- rotate 90
    zrot = zrot + 90
    DetachEntity(newVeh, 0, 0)
    AttachEntityToEntity(newVeh, GetVehiclePedIsIn(player, false), 0, xCoord, yCoord, zCoord, xrot, yrot, zrot, true, true, true, true, 0, true)
   end  
end

function resetOffSets()
  xCoord = 0
  yCoord = 0
  zCoord = 0
  xrot = 0
  yrot = 0
  zrot = 0
end

function disableControls()
  Citizen.CreateThread(function()
    while controlsDisabled do
      Citizen.Wait(0)
          DisableControlAction(0,21,true) -- disable sprint
          DisableControlAction(0,24,true) -- disable attack
          DisableControlAction(0,25,true) -- disable aim
          DisableControlAction(0,47,true) -- disable weapon
          DisableControlAction(0,58,true) -- disable weapon
          DisableControlAction(0,263,true) -- disable melee
          DisableControlAction(0,264,true) -- disable melee
          DisableControlAction(0,257,true) -- disable melee
          DisableControlAction(0,140,true) -- disable melee
          DisableControlAction(0,141,true) -- disable melee
          DisableControlAction(0,142,true) -- disable melee
          DisableControlAction(0,143,true) -- disable melee
          DisableControlAction(0,75,true) -- disable exit vehicle
          DisableControlAction(27,75,true) -- disable exit vehicle
          DisableControlAction(0,32,true) -- move (w)
          DisableControlAction(0,34,true) -- move (a)
          DisableControlAction(0,33,true) -- move (s)
          DisableControlAction(0,35,true) -- move (d)
          DisableControlAction(0,71,true) -- move (d)
          DisableControlAction(0,72,true) -- move (d)
    end
  end)
end


RegisterNetEvent("sound1Client")
AddEventHandler("sound1Client", function(sender, toggle)
	local player_s = GetPlayerFromServerId(sender)
	local ped_s = GetPlayerPed(player_s)
	if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
			if IsPedInAnyVehicle(ped_s, false) then
				local veh = GetVehiclePedIsUsing(ped_s)
				TogPowercallStateForVeh(veh, toggle)
			end
	end
end)

function TogPowercallStateForVeh(veh, toggle)
	if DoesEntityExist(veh) and not IsEntityDead(veh) then
		if toggle == true then
			if snd_pwrcall[veh] == nil then
        snd_pwrcall[veh] = GetSoundId()
          PlaySoundFromEntity(snd_pwrcall[veh], sirenTone, veh, 0, 0, 0)
          sirenBool = true
			end
		else
      if snd_pwrcall[veh] ~= nil then
        --sirenToneNumber = 1
				StopSound(snd_pwrcall[veh])
				ReleaseSoundId(snd_pwrcall[veh])
        snd_pwrcall[veh] = nil
        sirenBool = false
			end
		end
	end
end


function playAirHorn(bool)
  local tempVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
  local currPlate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
  if not(vehPlateBoolSavedData == currPlate) then
      TriggerServerEvent("returnLightBarVehiclePlates")
      while true do
          if(vehPlateBoolSavedData == GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))) then
              break
          end
          if not(currPlate == GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))) then
              return
          end
          Citizen.Wait(10)
      end
  end
  if not(tempVeh == nil) and isPlateCar and vehPlateBoolSavedData == currPlate then
      if bool then
          airHornSirenID = GetSoundId()
          PlaySoundFromEntity(airHornSirenID, "SIRENS_AIRHORN", tempVeh, 0, 0, 0)
      end
      if not bool then
          StopSound(airHornSirenID)
          ReleaseSoundId(airHornSirenIDs)
          airHornSirenID = nil
      end
  end
end


RegisterNetEvent("sendLightBarVehiclePlates")
AddEventHandler("sendLightBarVehiclePlates", function(platesArr)
  local player = GetPlayerPed(-1)
  local currPlate = GetVehicleNumberPlateText(GetVehiclePedIsIn(player, false))
  for k,v in pairs(platesArr) do 
    if currPlate == v then
      vehPlateBoolSavedData = currPlate
      isPlateCar = true
      return
		end
  end
  vehPlateBoolSavedData = currPlate
  isPlateCar = false
end)

function deleteArray()
  for k,v in pairs(deleteVehicleLightbars) do 
    DeleteVehicle(NetToVeh(v))
  end
end

RegisterNetEvent("deleteLightbarVehicle")
AddEventHandler("deleteLightbarVehicle", function(mainVehPlate)
  TriggerServerEvent("returnLightbarsForMainVeh", mainVehPlate)
end)

RegisterNetEvent("updateLightbarArray")
AddEventHandler("updateLightbarArray", function(plates)
  deleteVehicleLightbars = plates
  if sirenBool then
    toggleLights()
  end
  deleteArray()
  isPlateCar = false
  lightBool = false
  sirenBool = false
end)

RegisterNetEvent("centerLightbarMenu")
AddEventHandler("centerLightbarMenu", function()
  xCoord = 0
  yCoord = 0
  zCoord = 0
  xrot = 0
  yrot = 0
  zrot = 0
end)




stationGarage = {

    {x=-454.10150146484, y=6003.1455078125, z=31.340526580811, r=10}, -- Paleto Bay PD
    {x=1869.2178955078, y=3691.611328125, z=33.666393280029, r=10}, -- Sandy PD
	{x=433.93328857422, y=-1009.5791625977, z=28.245471954346, r=10}, -- midtby PD
}


   
_menuPool = MenuPool.New()
mainMenu = NativeUI.CreateMenu("Lygter", "")
_menuPool:Add(mainMenu)
_menuPool:RefreshIndex()
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        if IsControlJustPressed(1, 167) then -- F2

        				--if exports.policejob:getIsInService() then 

            for i = 1, #stationGarage do
            ply = GetPlayerPed(-1)
            plyCoords = GetEntityCoords(ply, 0)
            local distance = GetDistanceBetweenCoords(stationGarage[i].x, stationGarage[i].y, stationGarage[i].z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
            if(distance < stationGarage[i].r) then 
            mainMenu:Clear()               
            lightbarMenu(mainMenu)
            _menuPool:RefreshIndex()
            mainMenu:Visible(not mainMenu:Visible())
        end
    end
--end
     end
    end
end)

function lightbarMenu(menu)
    lightbarIndex = 1

    local item1 = NativeUI.CreateItem("2x Lygte (Rød/blå)", "")
    mainMenu:AddItem(item1)
    local item2 = NativeUI.CreateItem("3x Lygte (Blå)", "")
    mainMenu:AddItem(item2)
    local item3 = NativeUI.CreateItem("3x Lygte (Rød)", "")
    mainMenu:AddItem(item3)
    local item4 = NativeUI.CreateItem("Kugle (Blå)", "")
    mainMenu:AddItem(item4)
    local item5 = NativeUI.CreateItem("Fjern alle lygter ", "")
    mainMenu:AddItem(item5)
    local item6 = NativeUI.CreateItem("Centre lygte ", "")
    mainMenu:AddItem(item6)

    mainMenu.OnIndexChange= function(menu, newindex)
        print("Old index: " .. lightbarIndex)
        lightbarIndex = newindex
        print("New index: " .. lightbarIndex)
    end

    mainMenu.OnItemSelect = function (sender, item, index)
        if lightbarIndex == 1 then
            TriggerEvent("openLightbarMenu", "lightbarTwoSticks")
        elseif lightbarIndex == 2 then
            TriggerEvent("openLightbarMenu", "longLightbar")
        elseif lightbarIndex == 3 then
            TriggerEvent("openLightbarMenu", "longLightbarRed")
        elseif lightbarIndex == 4 then
            TriggerEvent("openLightbarMenu", "fbiold")
        elseif lightbarIndex == 5 then
          TriggerEvent("deleteLightbarVehicle", GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false)))
        elseif lightbarIndex == 6 then
          TriggerEvent("centerLightbarMenu")
        end
    end
end
lightbarMenu(mainMenu)

