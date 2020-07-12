vRP = Proxy.getInterface("vRP")

----------------
-- E  D  I  T --
----------------

local StartFishing_KEY = 107 -- NUM-6
local Caught_KEY = 201 -- ENTER
local End_KEY = 177 -- BACKSPACE
local SuccessLimit = 0.09 -- Maxim 0.1 (high value, low success chances)
local AnimationSpeed = 0.0015
local ShowChatMSG = true -- or false

----------------
-- C  O  D  E --
----------------

-- V A R S
local IsFishing = false
local CFish = false
local BarAnimation = 0
local Faketimer = 0
local RunCodeOnly1Time = true
local PosX = 0.5
local PosY = 0.1
local TimerAnimation = 0.1

local pos1 = GetDistanceBetweenCoords(1965.3392333984,3984.4694824219,30.93748664856, GetEntityCoords(playerPed)) < 35
local pos2 = GetDistanceBetweenCoords(1101.3391113281,-156.93460083008,53.780330657959, GetEntityCoords(playerPed)) < 35


-- T H R E A D
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(1, StartFishing_KEY) then
			if not IsPedInAnyVehicle(GetPed(), false) then
				if not IsPedSwimming(GetPed()) then
					local playerPed = GetPlayerPed(-1)
					if IsEntityInWater(GetPed()) and
					   GetDistanceBetweenCoords(1965.3392333984,3984.4694824219,30.93748664856, GetEntityCoords(playerPed)) < 35
					then
						IsFishing = true
						--if ShowChatMSG then Chat(msg[1]) end
						RunCodeOnly1Time = true
						BarAnimation = 0
					elseif IsEntityInWater(GetPed()) and
					   GetDistanceBetweenCoords(1101.3391113281,-156.93460083008,53.780330657959, GetEntityCoords(playerPed)) < 70
					then
						IsFishing = true
						--if ShowChatMSG then Chat(msg[1]) end
						RunCodeOnly1Time = true
						BarAnimation = 0
					else
						if ShowChatMSG then Chat('^1'..msg[6]) end
					end
				end
			end
		end
		while IsFishing do
			local time = 4*3000
			TaskStandStill(GetPed(), time+7000)
			FishRod = AttachEntityToPed('prop_fishing_rod_01',60309, 0,0,0, 0,0,0)
			PlayAnim(GetPed(),'amb@world_human_stand_fishing@base','base',4,3000)
			Citizen.Wait(time)
			CFish = true
			IsFishing = false
		end
		while CFish do
			Citizen.Wait(1)
			FishGUI(true)
			if RunCodeOnly1Time then
				Faketimer = 1
				PlayAnim(GetPed(),'amb@world_human_stand_fishing@idle_a','idle_c',1,0) -- 10sec
				RunCodeOnly1Time = false
			end
			if TimerAnimation <= 0 then
				CFish = false
				TimerAnimation = 0.1
				StopAnimTask(GetPed(), 'amb@world_human_stand_fishing@idle_a','idle_c',2.0)
				Citizen.Wait(200)
				DeleteEntity(FishRod)
				if ShowChatMSG then Chat('^1'..msg[2]) end

			end
			if IsControlJustPressed(1, Caught_KEY) then
				if BarAnimation >= SuccessLimit then
					CFish = false
					TimerAnimation = 0.1
					if ShowChatMSG then Chat('^2'..msg[3]) end
					TriggerServerEvent('fishing:reward')
					StopAnimTask(GetPed(), 'amb@world_human_stand_fishing@idle_a','idle_c',2.0)
					Citizen.Wait(200)
					DeleteEntity(FishRod)
					Citizen.Wait(300)
					IsFishing = true
				else
					CFish = false
					TimerAnimation = 0.1
					StopAnimTask(GetPed(), 'amb@world_human_stand_fishing@idle_a','idle_c',2.0)
					Citizen.Wait(200)
					DeleteEntity(FishRod)
					Citizen.Wait(300)
					IsFishing = true
					if ShowChatMSG then Chat('^1'..msg[4]) end
				end
			end
			if IsControlJustPressed(1, End_KEY) then
				CFish = false
				TimerAnimation = 0.1
				StopAnimTask(GetPed(), 'amb@world_human_stand_fishing@idle_a','idle_c',2.0)
				Citizen.Wait(200)
				DeleteEntity(FishRod)
				IsFishing = false
			end
		end
	end
end)
Citizen.CreateThread(function() -- Thread for  timer
	while true do
		Citizen.Wait(1000)
		Faketimer = Faketimer + 1
	end
end)

-- F  U  N  C  T  I  O  N  S
function GetCar() return GetVehiclePedIsIn(GetPlayerPed(-1),false) end
function GetPed() return GetPlayerPed(-1) end
function text(x,y,scale,text)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(255,255,255,255)
    SetTextDropShadow(0,0,0,0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end
function FishGUI(bool)
	if not bool then return end
	DrawRect(PosX,PosY+0.005,TimerAnimation,0.005,255,255,0,255)
	DrawRect(PosX,PosY,0.1,0.01,0,0,0,255)
	TimerAnimation = TimerAnimation - 0.0001025
	if BarAnimation >= SuccessLimit then
		DrawRect(PosX,PosY,BarAnimation,0.01,102,255,102,150)
	else
		DrawRect(PosX,PosY,BarAnimation,0.01,255,51,51,150)
	end
	if BarAnimation <= 0 then
		up = true
	end
	if BarAnimation >= PosY then
		up = false
	end
	if not up then
		BarAnimation = BarAnimation - AnimationSpeed
	else
		BarAnimation = BarAnimation + AnimationSpeed
	end
	text(0.4,0.05,0.35, msg[5])
end
function PlayAnim(ped,base,sub,nr,time)
	Citizen.CreateThread(function()
		RequestAnimDict(base)
		while not HasAnimDictLoaded(base) do
			Citizen.Wait(1)
		end
		if IsEntityPlayingAnim(ped, base, sub, 3) then
			ClearPedSecondaryTask(ped)
		else
			for i = 1,nr do
				TaskPlayAnim(ped, base, sub, 8.0, -8, -1, 16, 0, 0, 0, 0)
				Citizen.Wait(time)
			end
		end
	end)
end
function AttachEntityToPed(prop,bone_ID,x,y,z,RotX,RotY,RotZ)
	BoneID = GetPedBoneIndex(GetPed(), bone_ID)
	obj = CreateObject(GetHashKey(prop),  1729.73,  6403.90,  34.56,  true,  true,  true)
	vX,vY,vZ = table.unpack(GetEntityCoords(GetPed()))
	xRot, yRot, zRot = table.unpack(GetEntityRotation(GetPed(),2))
	AttachEntityToEntity(obj,  GetPed(),  BoneID, x,y,z, RotX,RotY,RotZ,  false, false, false, false, 2, true)
	return obj
end
function Chat(text)
	TriggerEvent("chatMessage", 'CN', { 255,255,0}, text)
end
