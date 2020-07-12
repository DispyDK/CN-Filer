vRPsb = Proxy.getInterface("vrp_extended")
-- this module define some police tools and functions

local handcuffed = false
local striped = false
local BlockControls = false
local cop = false
local prevVar = ""

-- set player as cop (true or false)
function tvRP.setCop(flag)
  cop = flag
  SetPedAsCop(GetPlayerPed(-1),flag)
end

-- HANDCUFF

function tvRP.toggleHandcuff()
  handcuffed = not handcuffed
  if handcuffed then
    BlockControls = true
    tvRP.playAnim(true,{{"missminuteman_1ig_2","handsup_enter",1}},false)
    Wait(550)
    tvRP.playAnim(true,{{"mp_prison_break","handcuffed",1}},false)
    Wait(1400)
    tvRP.playAnim(true,{{"missmurder","idle",1}},true)
    if striped == false then
      local ped = PlayerPedId()
      TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 2, "handcuff", 0.4)
      Wait(500)
      if GetPedDrawableVariation(ped, 7) ~= 25 or GetPedDrawableVariation(ped, 7) ~= 44 then prevVar = GetPedDrawableVariation(ped, 7) else prevVar = "" end
      if GetEntityModel(ped) == GetHashKey("mp_f_freemode_01") then
        SetPedComponentVariation(ped, 7, 25, 0, 0)
      else
        SetPedComponentVariation(ped, 7, 44, 0, 0)
      end
    end
  else
    if striped == false then
      local ped = PlayerPedId()
      if prevVar ~= "" and prevVar ~= 25 and prevVar ~= 44 then
        SetPedComponentVariation(ped, 7, prevVar, 0, 0)
        prevVar = ""
      else
        SetPedComponentVariation(ped, 7, 0, 0, 0)
      end
    else
      striped = false
    end
    BlockControls = false
    tvRP.stopAnim(true)
    SetPedStealthMovement(GetPlayerPed(-1),false,"")
  end
end



function tvRP.setHandcuffed(flag)
  if handcuffed ~= flag then
    tvRP.toggleHandcuff()
  end
end

function tvRP.isHandcuffed()
  return handcuffed
end

function tvRP.canBeDragged()
  if handcuffed or tvRP.getHealth() == 100 then
    return true
  end
  return false
end

function tvRP.setStriped(flag)
  if striped ~= flag then
    striped = flag
    tvRP.toggleHandcuff()
  end
end

function tvRP.isStriped()
  return striped
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    if IsControlJustReleased(1,208) then
      if DoesEntityExist(GetPlayerPed(-1)) then
        if not tvRP.isInComa() and not tvRP.isHandcuffed() then
          if vRPsb.isPolice() or vRPsb.isSecurity() then
            if IsPedInAnyVehicle(PlayerPedId(), false) then
              TriggerEvent("pNotify:SendNotification",{text = "Du kan ikke give håndjern på fra et køretøj.",type = "error",timeout = (5000),layout = "centerLeft",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            else
              TriggerServerEvent('handcuff:cuffHim')
            end
          end
        end
      end
      Citizen.Wait(2000)
    end
  end
end)

function tvRP.spawnspikes()
  local ped = GetPlayerPed(-1)
  x, y, z = table.unpack(GetEntityCoords(ped, true))
  if DoesObjectOfTypeExistAtCoords(x, y, z, 1.0, GetHashKey("P_ld_stinger_s"), true) then
    spike = GetClosestObjectOfType(x, y, z, 1.0, GetHashKey("P_ld_stinger_s"), false, false, false)
    SetEntityAsMissionEntity(spike, true, true)
    DeleteObject(spike)
  else
    TriggerEvent('c_setSpike')
  end
end



function tvRP.getNearestVehiclePlate(radius)
  local x,y,z = tvRP.getPosition()
  local ped = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ped) then
    return GetVehicleNumberPlateText(GetVehiclePedIsIn(ped, true))
  else
    local veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, radius+0.0001, 0, 8192+4096+4+2+1)  -- boats, helicos
    if not IsEntityAVehicle(veh) then veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, radius+0.0001, 0, 4+2+1) end -- cars
    return GetVehicleNumberPlateText(veh)
  end
end

-- (experimental, based on experimental getNearestVehicle)
function tvRP.putInNearestVehicleAsPassenger(radius)
  local veh = tvRP.getNearestVehicle(radius)
  local playerped = PlayerPedId()
	local coordA = GetEntityCoords(playerped, 1)
	local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
	local veh = getVehicleInDirection(coordA, coordB)
  print("Veh:"..veh)
  if IsEntityAVehicle(veh) then
    max = (GetVehicleMaxNumberOfPassengers(veh) > 3) and 3 or GetVehicleMaxNumberOfPassengers(veh)
    print("Maks:"..max)
    while max > -1 do
      if IsVehicleSeatFree(veh,max) then
        SetPedIntoVehicle(GetPlayerPed(-1),veh,max)
        print(max.." er ledig")
        TriggerEvent("cn-carhud:belt",true)
        return true
      else
        print(max.." er ikke ledig")
      end
      max = max-1
    end
  end
  return false
end

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

function tvRP.putInNetVehicleAsPassenger(net_veh)
  local veh = NetworkGetEntityFromNetworkId(net_veh)
  if IsEntityAVehicle(veh) then
    for i=1,GetVehicleMaxNumberOfPassengers(veh) do
      if IsVehicleSeatFree(veh,i) then
        DetachEntity(GetPlayerPed(-1), true, false)
        SetPedIntoVehicle(GetPlayerPed(-1),veh,i)
        beltOn = true
        return true
      end
    end
  end
end

function tvRP.putInVehiclePositionAsPassenger(x,y,z)
  local veh = tvRP.getVehicleAtPosition(x,y,z)
  if IsEntityAVehicle(veh) then
    for i=1,GetVehicleMaxNumberOfPassengers(veh) do
      if IsVehicleSeatFree(veh,i) then
        DetachEntity(GetPlayerPed(-1), true, false)
        SetPedIntoVehicle(GetPlayerPed(-1),veh,i)
        beltOn = true
        return true
      end
    end
  end
end

-- keep handcuffed animation
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(15000)
    if handcuffed then
      tvRP.playAnim(true,{{"mp_arresting","idle",1}},true)
    end
  end
end)

-- force stealth movement while handcuffed (prevent use of fist and slow the player)
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if handcuffed then
      --SetPedStealthMovement(GetPlayerPed(-1),true,"")
      DisableControlAction(0,21,true) -- disable sprint (SHIFT)
      DisableControlAction(0,22,true) -- disable jump (SPACE)
      DisableControlAction(0,23,true) -- disable enter vehicle (F)
      DisableControlAction(0,24,true) -- disable attack (LEFTCLICK)
      DisableControlAction(0,25,true) -- disable aim (RIGHTCLICK)
      DisableControlAction(0,29,true) -- disable point (B)
      DisableControlAction(0,47,true) -- disable weapon
      DisableControlAction(0,58,true) -- disable weapon
      DisableControlAction(0,73,true) -- disable handsup (X)
      DisableControlAction(0,75,true) -- disable exit vehicle (F)
      DisableControlAction(27,75,true) -- disable exit vehicle (F)
      DisableControlAction(0,140,true) -- disable melee
      DisableControlAction(0,141,true) -- disable melee
      DisableControlAction(0,142,true) -- disable melee
      DisableControlAction(0,143,true) -- disable melee
      DisableControlAction(0,257,true) -- disable melee
      DisableControlAction(0,263,true) -- disable melee
      DisableControlAction(0,264,true) -- disable melee
      DisableControlAction(0,311,true) -- disable seatbelt (K)
      DisableControlAction(0,323,true) -- disable handsup2 (X)
      DisableControlAction(0,244,true) -- disable flipoff (M)
    end
    if BlockControls == true then
      DisableControlAction(1, 140, true)
      DisableControlAction(1, 141, true)
      DisableControlAction(1, 142, true)
      DisableControlAction(0, 21, true)
      DisableControlAction(0, 23, true)
      DisableControlAction(0, 49, true)
      DisableControlAction(1, 37, true)
    end
  end
end)

-- JAIL

local jail = nil

-- jail the player in a no-top no-bottom cylinder
function tvRP.jail(x,y,z,radius)
  tvRP.teleport(x,y,z) -- teleport to center
  jail = {x+0.0001,y+0.0001,z+0.0001,radius+0.0001}
end

-- unjail the player
function tvRP.unjail()
  jail = nil
end

function tvRP.isJailed()
  return jail ~= nil
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(5)
    if jail then
      local x,y,z = tvRP.getPosition()

      local dx = x-jail[1]
      local dy = y-jail[2]
      local dist = math.sqrt(dx*dx+dy*dy)

      if dist >= jail[4] then
        local ped = GetPlayerPed(-1)
        SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001) -- stop player

        -- normalize + push to the edge + add origin
        dx = dx/dist*jail[4]+jail[1]
        dy = dy/dist*jail[4]+jail[2]

        -- teleport player at the edge
        SetEntityCoordsNoOffset(ped,dx,dy,z,true,true,true)
      end
    end
  end
end)

-- WANTED

-- wanted level sync
local wanted_level = 0
