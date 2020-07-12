vRPpm = {}
Tunnel.bindInterface("vrp_barrier",vRPpm)
Proxy.addInterface("vrp_barrier",vRPpm)
PMserver = Tunnel.getInterface("vrp_barrier","vrp_barrier")
vRPserver = Tunnel.getInterface("vRP","vrp_barrier")
vRP = Proxy.getInterface("vRP")

function vRPpm.setConeOnGround()
    local ped = GetPlayerPed(-1)
    x, y, z = table.unpack(GetEntityCoords(ped, true))
	h = GetEntityHeading(ped)
	ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(ped, -1.0, 1.0, -1.65))
	cone = GetHashKey("prop_mp_cone_02")

    RequestModel(cone)
    while not HasModelLoaded(cone) do
      Citizen.Wait(1)
    end

    local object = CreateObject(cone, ox, oy, oz, true, true, false)
    PlaceObjectOnGroundProperly(object)
    FreezeEntityPosition(object,true)
	SetEntityHeading(object, h+90)
end

function vRPpm.setBarrierOnGround()
    local ped = GetPlayerPed(-1)
    x, y, z = table.unpack(GetEntityCoords(ped, true))
	h = GetEntityHeading(ped)
	ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(ped, -1.0, 1.0, -1.65))
	barrier = GetHashKey("prop_mp_barrier_02b")

    RequestModel(barrier)
    while not HasModelLoaded(barrier) do
      Citizen.Wait(1)
    end

    local object = CreateObject(barrier, ox, oy, oz, true, true, false)
    PlaceObjectOnGroundProperly(object)
	SetEntityHeading(object, h+90)
end

function vRPpm.setBarrierWorkOnGround()
    local ped = GetPlayerPed(-1)
    x, y, z = table.unpack(GetEntityCoords(ped, true))
	h = GetEntityHeading(ped)
	ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(ped, -1.0, 1.0, -1.65))
	barrier2 = GetHashKey("prop_barrier_work05")

    RequestModel(barrier2)
    while not HasModelLoaded(barrier2) do
      Citizen.Wait(1)
    end

    local object = CreateObject(barrier2, ox, oy, oz, true, true, false)
    PlaceObjectOnGroundProperly(object)
    FreezeEntityPosition(object,true)
	SetEntityHeading(object, h+90)
end

function vRPpm.isCloseToCone()
    local ped = GetPlayerPed(-1)
    x, y, z = table.unpack(GetEntityCoords(ped, true))
	ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, -2.0))
    if DoesObjectOfTypeExistAtCoords(ox, oy, oz, 0.9, GetHashKey("prop_mp_cone_02"), true) then
	  return true
	else 
	  return false
	end
end

function vRPpm.isCloseToBarrier()
    local ped = GetPlayerPed(-1)
    x, y, z = table.unpack(GetEntityCoords(ped, true))
	ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, -2.0))
    if DoesObjectOfTypeExistAtCoords(ox, oy, oz, 0.9, GetHashKey("prop_mp_barrier_02b"), true) then
	  return true
	else 
	  return false
	end
end

function vRPpm.isCloseToBarrier2()
    local ped = GetPlayerPed(-1)
    x, y, z = table.unpack(GetEntityCoords(ped, true))
	ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, -2.0))
    if DoesObjectOfTypeExistAtCoords(ox, oy, oz, 0.9, GetHashKey("prop_barrier_work05"), true) then
	  return true
	else 
	  return false
	end
end

function vRPpm.removeCone()
    local ped = GetPlayerPed(-1)
    x, y, z = table.unpack(GetEntityCoords(ped, true))
	ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(ped, -1.0, 1.0, -1.65))
    if DoesObjectOfTypeExistAtCoords(ox, oy, oz, 0.9, GetHashKey("prop_mp_cone_02"), true) then
        spike = GetClosestObjectOfType(ox, oy, oz, 0.9, GetHashKey("prop_mp_cone_02"), false, false, false)
        SetEntityAsMissionEntity(spike, true, true)
        DeleteObject(spike)
	end
end

function vRPpm.removeBarrier()
    local ped = GetPlayerPed(-1)
    x, y, z = table.unpack(GetEntityCoords(ped, true))
	ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(ped, -1.0, 1.0, -1.65))
    if DoesObjectOfTypeExistAtCoords(ox, oy, oz, 0.9, GetHashKey("prop_mp_barrier_02b"), true) then
        spike = GetClosestObjectOfType(ox, oy, oz, 0.9, GetHashKey("prop_mp_barrier_02b"), false, false, false)
        SetEntityAsMissionEntity(spike, true, true)
        DeleteObject(spike)
	end
end

function vRPpm.removeBarrier2()
    local ped = GetPlayerPed(-1)
    x, y, z = table.unpack(GetEntityCoords(ped, true))
	ox, oy, oz = table.unpack(GetOffsetFromEntityInWorldCoords(ped, -1.0, 1.0, -1.65))
    if DoesObjectOfTypeExistAtCoords(ox, oy, oz, 0.9, GetHashKey("prop_barrier_work05"), true) then
        spike = GetClosestObjectOfType(ox, oy, oz, 0.9, GetHashKey("prop_barrier_work05"), false, false, false)
        SetEntityAsMissionEntity(spike, true, true)
        DeleteObject(spike)
	end
end