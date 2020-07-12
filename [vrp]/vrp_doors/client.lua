--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 02-02-2019
-- Time: 19:17
-- Made for CiviliansNetwork
--
local LockHotkey = {0,38}
local BombHotkey = {0,246}
local doors = {}



-- Citizen.CreateThread(function()
--   while true do
--     users = vRPsb.getAmountOnline({"all"})
--     for k,v in pairs(users) do
--
--       TriggerEvent(source, doors)
--     end
--
--   end
-- end)

RegisterNetEvent('vrp_doors:load')
AddEventHandler('vrp_doors:load', function(list)
    doors = list
end)

RegisterNetEvent('vrp_doors:statusSend')
AddEventHandler('vrp_doors:statusSend', function(id,status)
    doors[id].locked = status
    if not status == true then
        if doors[id].heading then
            local heading = doors[id].heading
            local hash = doors[id].hash
            local coords = doors[id].coords
            setHeading(id, heading, hash, coords)
        end
    else
        if doors[id].heading2 then
            local heading2 = doors[id].heading2
            local hash = doors[id].hash
            local coords = doors[id].coords
            setHeading(id, heading2, hash, coords)
        end
    end
end)

function setHeading(id, heading, hash, coords)
  local doorEntity = GetClosestObjectOfType(coords[1],coords[2],coords[3], 5.0, hash, false)
  SetEntityRotation(doorEntity, 0, 0, heading, 2, 1)
end

-- RegisterCommand("break", function()
--     TriggerEvent("vrp_doors:getNearestDoor", nearestDoor)
-- end)



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

local nearestDoor
local currentPos
local prevPos
local canOpen = true

-- Citizen.CreateThread(function()
--   while true do
--     Citizen.Wait(100)
--     currentPos = GetEntityCoords(PlayerPedId(), true)
--     if currentPos == prevPos then
--       canOpen = true
--     else
--       canOpen = false
--     end
--     prevPos = currentPos
--     -- print(currentPos)
--     -- print(prevPos)
--   end
-- end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local coords = GetEntityCoords(PlayerPedId(),true)

        if canOpen then
          for k,v in pairs(doors) do
              local lradius = (v.range ~= nil and v.range or 2.0)
              if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.coords[1], v.coords[2], v.coords[3], true) <= lradius then
                  local closeDoor = GetClosestObjectOfType(v.coords[1], v.coords[2], v.coords[3], lradius + 20, v.hash, false, false, false)
                  if closeDoor ~= 0 then
                    nearestDoor = k
                      if v.locked then
                          -- DrawText3Ds(v.coords[1], v.coords[2], v.coords[3], "Tryk ~g~E~w~ for at låse op" .. k)
                          DrawText3Ds(v.coords[1], v.coords[2], v.coords[3], "Tryk ~g~E~w~ for at låse op")
                          if not v.boomAble then
                            --DrawText3Ds(v.coords[1], v.coords[2], v.coords[3]-0.2, "Tryk ~y~Y~w~ for at sprænge døren op" .. k)
                          end
                          local locked, heading = GetStateOfClosestDoorOfType(v.hash, v.coords[1], v.coords[2], v.coords[3], v.locked, 0)
                          if heading > -0.01 and heading < 0.01 then
                              FreezeEntityPosition(closeDoor, v.locked)
                          end
                      else
                          DrawText3Ds(v.coords[1], v.coords[2], v.coords[3], "Tryk ~r~E~w~ for at låse")

                          FreezeEntityPosition(closeDoor, v.locked)
                          if v.freeze == true then
                              FreezeEntityPosition(closeDoor, true)
                          end
                      end
                      if IsControlJustReleased(table.unpack(LockHotkey)) then
                          toggleClosestDoor()
                      end
                      if IsControlJustReleased(table.unpack(BombHotkey)) and v.locked and not v.boomAble then
                          bombClosestDoor(closeDoor)
                      end
                  end
              end
          end
        end
    end
end)



function toggleClosestDoor()
    local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
    for k,v in pairs(doors) do
        if v.close ~= nil then
            local door1 = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.coords[1], v.coords[2], v.coords[3], true )
            local lradius = (v.range ~= nil and v.range or 2.0)
            if door1 < lradius then
                if door1 < GetDistanceBetweenCoords(x,y,z,doors[v.close].coords[1], doors[v.close].coords[2], doors[v.close].coords[3],true) then
                    TriggerServerEvent("vrp_doors:status", k, not v.locked)
                else
                    TriggerServerEvent("vrp_doors:status", v.close, not doors[v.close].locked)
                end
                break
            end
        else
            local lradius = (v.range ~= nil and v.range or 2.0)
            if GetDistanceBetweenCoords(x,y,z,v.coords[1], v.coords[2], v.coords[3],true) <= lradius then
                TriggerServerEvent("vrp_doors:status", k, not v.locked)
            end
        end
    end
end

function bombClosestDoor(closeDoor)
    local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
    for k,v in pairs(doors) do
        if v.close ~= nil then
            local door1 = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.coords[1], v.coords[2], v.coords[3], true )
            local lradius = (v.range ~= nil and v.range or 2.0)
            if door1 < lradius then
              -- TriggerServerEvent("vrp_doors:status", v.close, not doors[v.close].locked)
              -- print("Booooom1")
              -- TriggerServerEvent("cn-emotes:effects",coords,"core","exp_grd_plane_sp",{default={0.0, 0.0, -0.1, -90.0, 0.0, 20.0,11816},female={0.0, 0.0, -0.55, 0.0, 0.0, 20.0,11816}},"entity",5000)
            end
        else
            local lradius = (v.range ~= nil and v.range or 2.0)
            if GetDistanceBetweenCoords(x,y,z,v.coords[1], v.coords[2], v.coords[3],true) <= lradius then

                TriggerServerEvent("vrp_breakin:checkC4", k, v.coords, closeDoor)
            end
        end
    end
end

local doorsLoaded = false

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(100)
    if not doorsLoaded then
      TriggerServerEvent("qwheqwihqeoiq")
      doorsLoaded = true
    end
  end
end)

local blockeddoors = {
    --Michael house
    {hash = -1686014385, coords = {-816.29418945313,178.31407165527,72.222496032715}},
    {hash = 159994461, coords = {-816.29418945313,178.31407165527,72.222496032715}},
    {hash = -607040053, coords = {-1150.2520751953,-1521.5427246094,10.632718086243}},
    {hash = -1278729253, coords = {119.36336517334,563.58813476563,183.96928405762}},
    {hash = -1516927114, coords = {345.88305664063,440.28274536133,148.0906829834}},
    --Hudilihud
    {hash = 736699661, coords = {1397.1640625,1164.0338134766,114.33365631104}},
}

Citizen.CreateThread( function()
    while true do
        Citizen.Wait(2000)
        for k,v in pairs(blockeddoors) do
            if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.coords[1],v.coords[2],v.coords[3], true) < 5 then
                local closeDoor = GetClosestObjectOfType(v.coords[1],v.coords[2],v.coords[3], 1.0, v.hash, false, false, false)
                FreezeEntityPosition(closeDoor, true)
            end
        end
    end
end)


local function CreateNamedRenderTargetForModel(name, model)
	local handle = 0

	if not IsNamedRendertargetRegistered(name) then
		RegisterNamedRendertarget(name, 0) -- TODO wuts bool?
	end

	if not IsNamedRendertargetLinked(model) then
		LinkNamedRendertarget(model)
	end

	if IsNamedRendertargetRegistered(name) then
		handle = GetNamedRendertargetRenderId(name)
	end

	return handle
end


local function LoadScaleForm(scaleform)
	local scaleform = RequestScaleformMovie(scaleform)
	if scaleform ~= 0 then
		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(0)
		end
	end
	return scaleform
end


function CreateObj (model, coords, cb, ...)
	local entity = nil
	RequestModel(model)
	while not HasModelLoaded(model) do Citizen.Wait(0) end
	SetModelAsNoLongerNeeded(model)
	entity = CreateObject(model, 3666.661, 4994.047, 85.07503, true, true, true)
	if cb ~= nil then cb(entity, ...) end
	return entity
end


local BLIMP = {}

BLIMP.model = 1575467428

BLIMP.scaleform_name = "blimp_text"
BLIMP.scaleform = nil

BLIMP.rendertarget_name = "blimp_text"
BLIMP.rendertarget = nil

function BLIMP.SetScrollSpeed(scrollSpeed)
	PushScaleformMovieFunction(BLIMP.scaleform, "SET_SCROLL_SPEED")
	PushScaleformMovieFunctionParameterFloat(scrollSpeed + 0.0)
	PopScaleformMovieFunctionVoid()
end

function BLIMP.SetColour (colour)
	PushScaleformMovieFunction(BLIMP.scaleform, "SET_COLOUR")
	PushScaleformMovieFunctionParameterInt(colour)
	PopScaleformMovieFunctionVoid()
end; BLIMP.SetColor = BLIMP.SetColour

function BLIMP.SetMessage(message)
	PushScaleformMovieFunction(BLIMP.scaleform, "SET_MESSAGE")
	PushScaleformMovieFunctionParameterString(message)
	PopScaleformMovieFunctionVoid()
end

function BLIMP.RenderMessage ()
	SetTextRenderId(BLIMP.rendertarget)
		Set_2dLayer(4)
		Citizen.InvokeNative(0xC6372ECD45D73BCD, 1)
		Citizen.InvokeNative(0x40332D115A898AF5, BLIMP.scaleform, 1)
		DrawScaleformMovie(BLIMP.scaleform, 0.0, -0.08, 1.0, 1.7, 255, 255, 255, 255, 0)
	SetTextRenderId(GetDefaultScriptRendertargetRenderId())
end

Citizen.CreateThread(function ()
	-- Create blimp by player
	local ob = CreateObj(BLIMP.model, GetEntityCoords(GetPlayerPed(-1)))

	BLIMP.scaleform = LoadScaleForm(BLIMP.scaleform_name)
	BLIMP.rendertarget = CreateNamedRenderTargetForModel(BLIMP.rendertarget_name, BLIMP.model)
	BLIMP.SetMessage("STEM PÅ LASSE RAHM CHRISTENSEN SOM BORGMESTER")
	BLIMP.SetColor(1)
	BLIMP.SetScrollSpeed(1.0)

	print('BLIMP scaleform handle:' .. BLIMP.scaleform)
	print('BLIMP rendertarget handle:' .. BLIMP.rendertarget)

	while true do
		BLIMP.RenderMessage()
		Citizen.Wait(100)
	end
end)
