vRP = Proxy.getInterface("vRP")

vRPsb = {}
Tunnel.bindInterface("vrp_ui",vRPsb)
Proxy.addInterface("vrp_ui",vRPsb)

local key = 212 -- https://wiki.fivem.net/wiki/Controls
local voice = 0

local cfg = {
	{
		distance = 2.0001,
		text = "Hvisker"
	},
	{
		distance = 45.0001,
		text = "Råber"
	},
	{
		distance = 12.0001,
		text = "Normal"
	},
}
local health = -1
local hunger = -1
local thirst = -1
local showUI = true

function vRPsb.setUIBar(type,amount)
	if type == "health" then health = amount
	elseif type == "hunger" then hunger = 100-math.floor(math.abs(amount))
	elseif type == "thirst" then thirst = 100-math.floor(math.abs(amount))
	end
end

function vRPsb.showUI(bool)
	showUI = bool
end


function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(2, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end


function drawRct(x,y,width,height,r,g,b,a)
   DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end


-- Citizen.CreateThread(function()
--  	while true do
--  		Citizen.Wait(0)
--  		if IsControlJustPressed(1, key) then
--  			voice = voice + 1
-- 			if voice > 3 then voice = 1 end
-- 			NetworkSetTalkerProximity(cfg[voice].distance)
-- 			TriggerEvent("pNotify:SendNotification",{text = "Talerækkevide: <b style='color: #4E9350'>"..cfg[voice].text.."</b>",
-- 				type = "info",timeout = 4000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer=true})
-- 		end
--  	end
-- end)

local height = 0.011
local bar1 = 0.970
local bar2 = 0.9835
local talebaroffset = 0.0862
Citizen.CreateThread(function()
 	while true do
 		Citizen.Wait(0)
		if showUI then
			drawRct(0.0135, 0.96695, 0.1440,0.030,32,32,34,255)
			if IsPedInAnyVehicle(PlayerPedId(), false) then
				drawRct(0.11,bar1-0.001, 0.046,height+0.001,100,100,100,255)
				if NetworkIsPlayerTalking(PlayerId()) then
					if voice == 1 then
						drawRct(0.11,bar1-0.001, 0.046,height+0.001,255, 93, 69,255)
					elseif voice == 2 then
						drawRct(0.11,bar1-0.001, 0.015333,height+0.001,255, 93, 69,255)
					else
						drawRct(0.11,bar1-0.001, 0.030333,height+0.001,255, 93, 69,255)
					end
				else
					if voice == 1 then
						drawRct(0.11,bar1-0.001, 0.046,height+0.001,234, 234, 234,255)
					elseif voice == 2 then
						drawRct(0.11,bar1-0.001, 0.015333,height+0.001,234, 234, 234,255)
					else
						drawRct(0.11,bar1-0.001, 0.030333,height+0.001,234, 234, 234,255)
					end
				end

				local vdamage = GetVehicleEngineHealth(GetVehiclePedIsIn(PlayerPedId(),false))
				drawRct(0.0625,bar1-0.001, 0.046,height+0.001,98, 161, 117, 255)
				drawRct(0.0625,bar1-0.001, (0.000046 * tonumber(vdamage)),height+0.001,98, 255, 117, 255)
				drawTxt(0.0980,bar1-0.00420, 0.0350,0.01,0.24, math.floor(vdamage) , 255, 255, 255, 255)
				health = GetEntityHealth(GetPlayerPed(-1)) - 100
				if health ~= -1 then
					drawRct(0.015,bar1-0.001, 0.046,height+0.001,0, 120, 0,255)
					if health == 0 then
						drawTxt(0.0510,bar1-0.00420, 0.046,0.01,0.24, "Død" , 255, 255, 255, 255)
					end
					drawRct(0.015,bar1-0.001, (0.00046 * health),height+0.001,0, 195, 0,255)
					drawTxt(0.0510,bar1-0.00420, 0.0350,0.01,0.24, math.floor(health) , 255, 255, 255, 255)
				end
			else
				local armor = GetPedArmour(PlayerPedId())
				local talebarwidth = 0.07
				local healthtxt = 0.0650
				if armor > 0 then
					drawRct(0.0625,bar1-0.001, 0.046,height+0.001,63, 159, 104,255)
					drawRct(0.0625,bar1-0.001, (0.00046 * armor),height+0.001,63, 240, 104,255)
					drawTxt(0.1,bar1-0.00420, 0.0350,0.01,0.24, math.floor(armor) , 255, 255, 255, 255)
					talebaroffset = 0.11
					talebarwidth = 0.046
					healthtxt = healthtxt/1.40
				else
					talebaroffset = 0.0862
				end
				drawRct(talebaroffset,bar1-0.001, talebarwidth,height+0.001,100,100,100,255)
				-- if NetworkIsPlayerTalking(PlayerId()) then
				-- 	if voice == 1 then
				-- 		drawRct(talebaroffset,bar1-0.001, talebarwidth,height+0.001,255, 93, 69,255)
				-- 	elseif voice == 2 then
				-- 		drawRct(talebaroffset,bar1-0.001, talebarwidth/3,height+0.001,255, 93, 69,255)
				-- 	else
				-- 		drawRct(talebaroffset,bar1-0.001, talebarwidth/1.5,height+0.001,255, 93, 69,255)
				-- 	end
				-- else
				-- 	if voice == 1 then
				-- 		drawRct(talebaroffset,bar1-0.001, talebarwidth,height+0.001,234, 234, 234,255)
				-- 	elseif voice == 2 then
				-- 		drawRct(talebaroffset,bar1-0.001, talebarwidth/3,height+0.001,234, 234, 234,255)
				-- 	else
				-- 		drawRct(talebaroffset,bar1-0.001, talebarwidth/1.5,height+0.001,234, 234, 234,255)
				-- 	end
				-- end
				health = GetEntityHealth(GetPlayerPed(-1)) - 100
				if health ~= -1 then
					drawRct(0.015,bar1-0.001, talebarwidth,height+0.001,0, 120, 0,255)
					if health == 0 then
						drawTxt(healthtxt,bar1-0.00420, talebarwidth/2,0.01,0.24, "Død" , 255, 255, 255, 255)
					end
					drawRct(0.015,bar1-0.001, ((talebarwidth/100) * health),height+0.001,0, 195, 0,255)
					drawTxt(healthtxt,bar1-0.00420, talebarwidth/2,0.01,0.24, math.floor(health) , 255, 255, 255, 255)
				end
			end
			drawRct(0.015,bar2, 0.046,height,255, 104, 0,255)
			if hunger ~= -1 then
				drawRct(0.015,bar2, (0.00046 * hunger),height,255, 152, 0,255)
				if hunger < 25 then
					drawTxt(0.0545,bar2-0.00420, 0.046,0.01,0.24, "Sulter" , 255, 255, 255, 255)
				end
			end
			drawRct(0.0625,bar2, 0.046,height,0, 103, 251,255)
			if thirst ~= -1 then
				drawRct(0.0625,bar2, (0.00046 * thirst),height,0, 160, 251,255)
				if thirst < 25 then
					drawTxt(0.1000,bar2-0.00420, 0.046,0.01,0.24, "Tørster" , 255, 255, 255, 255)
				end
			end
			drawRct(0.11,bar2, 0.046,height,255, 159, 0,255)
		end
 	end
end)



--Retning + vejnavn
x = 0.985
y = 0.948
border_r = 80
border_g = 190
border_b = 255
border_a = 220

dir_r = 255
dir_g = 255
dir_b = 255
dir_a = 255

curr_street_r = 80
curr_street_g = 190
curr_street_b = 255
curr_street_a = 220

str_around_r = 255
str_around_g = 255
str_around_b = 255
str_around_a = 255

town_r = 255
town_g = 255
town_b = 255
town_a = 255

checkForVehicle = true


function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
	if not HideHud then
		SetTextFont(4)
		SetTextProportional(0)
		SetTextScale(scale, scale)
		SetTextColour(r, g, b, a)
		SetTextDropShadow(0, 0, 0, 0,255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(x - width/2, y - height/2 + 0.005)
	end
end

function drawTxt2(x,y ,width,height,scale, text, r,g,b,a)
	if not HideHud then
		SetTextFont(6)
		SetTextProportional(0)
		SetTextScale(scale, scale)
		SetTextColour(r, g, b, a)
		SetTextDropShadow(0, 0, 0, 0,255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(x - width/2, y - height/2 + 0.005)
	end
end

local directions = { [0] = 'N', [45] = 'NV', [90] = 'V', [135] = 'SV', [180] = 'S', [225] = 'SØ', [270] = 'Ø', [315] = 'NØ', [360] = 'N', }
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		local ped = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(ped, false)
		local directions = { [0] = 'N', [45] = 'NV', [90] = 'V', [135] = 'SV', [180] = 'S', [225] = 'SØ', [270] = 'Ø', [315] = 'NØ', [360] = 'N', }

		local pos = GetEntityCoords(PlayerPedId())
		local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
		local current_zone = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))

		for k,v in pairs(directions)do
			direction = GetEntityHeading(PlayerPedId())
			if(math.abs(direction - k) < 22.5)then
				direction = v
				break
			end
		end

		if (checkForVehicle == false) then
			if GetStreetNameFromHashKey(var1) and GetNameOfZone(pos.x, pos.y, pos.z) then
				if GetStreetNameFromHashKey(var1) then
					if direction == 'N' then
							drawTxt(x-0.335, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
							drawTxt(x-0.306, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
							drawTxt(x-0.315, y+0.42, 1.0,1.0,1.0, direction, dir_r, dir_g, dir_b, dir_a)
						if GetStreetNameFromHashKey(var2) == "" then
							drawTxt2(x-0.285, y+0.45, 1.0,1.0,0.45, current_zone, town_r, town_g, town_b, town_a)
						else
							drawTxt2(x-0.285, y+0.45, 1.0,1.0,0.45, GetStreetNameFromHashKey(var2) .. ", " .. GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z)), str_around_r, str_around_g, str_around_b, str_around_a)
						end
							drawTxt2(x-0.285, y+0.42, 1.0,1.0,0.55, GetStreetNameFromHashKey(var1), curr_street_r, curr_street_g, curr_street_b, curr_street_a)
					elseif direction == 'NØ' then
							drawTxt(x-0.335, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
							drawTxt(x-0.298, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
							drawTxt(x-0.315, y+0.42, 1.0,1.0,1.0, direction, dir_r, dir_g, dir_b, dir_a)
						if GetStreetNameFromHashKey(var2) == "" then
							drawTxt2(x-0.277, y+0.45, 1.0,1.0,0.45, current_zone, town_r, town_g, town_b, town_a)
						else
							drawTxt2(x-0.277, y+0.45, 1.0,1.0,0.45, GetStreetNameFromHashKey(var2) .. ", " .. GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z)), str_around_r, str_around_g, str_around_b, str_around_a)
						end
						drawTxt2(x-0.277, y+0.42, 1.0,1.0,0.55, GetStreetNameFromHashKey(var1),curr_street_r, curr_street_g, curr_street_b, curr_street_a)
					elseif direction == 'Ø' then
							drawTxt(x-0.335, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
							drawTxt(x-0.309, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
							drawTxt(x-0.315, y+0.42, 1.0,1.0,1.0, direction, dir_r, dir_g, dir_b, dir_a)
						if GetStreetNameFromHashKey(var2) == "" then
							drawTxt2(x-0.288, y+0.45, 1.0,1.0,0.45, current_zone, town_r, town_g, town_b, town_a)
						else
							drawTxt2(x-0.288, y+0.45, 1.0,1.0,0.45, GetStreetNameFromHashKey(var2) .. ", " .. GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z)), str_around_r, str_around_g, str_around_b, str_around_a)
						end
						drawTxt2(x-0.288, y+0.42, 1.0,1.0,0.55, GetStreetNameFromHashKey(var1), curr_street_r, curr_street_g, curr_street_b, curr_street_a)
					elseif direction == 'SØ' then
							drawTxt(x-0.335, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
							drawTxt(x-0.298, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
							drawTxt(x-0.315, y+0.42, 1.0,1.0,1.0, direction, dir_r, dir_g, dir_b, dir_a)
						if GetStreetNameFromHashKey(var2) == "" then
							drawTxt2(x-0.275, y+0.45, 1.0,1.0,0.45, current_zone, town_r, town_g, town_b, town_a)
						else
							drawTxt2(x-0.275, y+0.45, 1.0,1.0,0.45, GetStreetNameFromHashKey(var2) .. ", " .. GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z)), str_around_r, str_around_g, str_around_b, str_around_a)
						end
							drawTxt2(x-0.275, y+0.42, 1.0,1.0,0.55, GetStreetNameFromHashKey(var1), curr_street_r, curr_street_g, curr_street_b, curr_street_a)
					elseif direction == 'S' then
							drawTxt(x-0.335, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
							drawTxt(x-0.307, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
							drawTxt(x-0.315, y+0.42, 1.0,1.0,1.0, direction, dir_r, dir_g, dir_b, dir_a)
						if GetStreetNameFromHashKey(var2) == "" then
							drawTxt2(x-0.285, y+0.45, 1.0,1.0,0.45, current_zone, town_r, town_g, town_b, town_a)
						else
							drawTxt2(x-0.285, y+0.45, 1.0,1.0,0.45, GetStreetNameFromHashKey(var2) .. ", " .. GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z)), str_around_r, str_around_g, str_around_b, str_around_a)
						end
							drawTxt2(x-0.285, y+0.42, 1.0,1.0,0.55, GetStreetNameFromHashKey(var1), curr_street_r, curr_street_g, curr_street_b, curr_street_a)
					elseif direction == 'SV' then
							drawTxt(x-0.335, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
							drawTxt(x-0.292, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
							drawTxt(x-0.315, y+0.42, 1.0,1.0,1.0, direction, dir_r, dir_g, dir_b, dir_a)
						if GetStreetNameFromHashKey(var2) == "" then
							drawTxt2(x-0.270, y+0.45, 1.0,1.0,0.45, current_zone, town_r, town_g, town_b, town_a)
						else
							drawTxt2(x-0.270, y+0.45, 1.0,1.0,0.45, GetStreetNameFromHashKey(var2) .. ", " .. GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z)), str_around_r, str_around_g, str_around_b, str_around_a)
						end
							drawTxt2(x-0.270, y+0.42, 1.0,1.0,0.55, GetStreetNameFromHashKey(var1), curr_street_r, curr_street_g, curr_street_b, curr_street_a)
					elseif direction == 'V' then
							drawTxt(x-0.335, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
							drawTxt(x-0.303, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
							drawTxt(x-0.315, y+0.42, 1.0,1.0,1.0, direction, dir_r, dir_g, dir_b, dir_a)
						if GetStreetNameFromHashKey(var2) == "" then
							drawTxt2(x-0.280, y+0.45, 1.0,1.0,0.45, current_zone, town_r, town_g, town_b, town_a)
						else
							drawTxt2(x-0.280, y+0.45, 1.0,1.0,0.45, GetStreetNameFromHashKey(var2) .. ", " .. GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z)), str_around_r, str_around_g, str_around_b, str_around_a)
						end
							drawTxt2(x-0.280, y+0.42, 1.0,1.0,0.55, GetStreetNameFromHashKey(var1), curr_street_r, curr_street_g, curr_street_b, curr_street_a)
					elseif direction == 'NV' then
							drawTxt(x-0.335, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
							drawTxt(x-0.290, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
							drawTxt(x-0.315, y+0.42, 1.0,1.0,1.0, direction, dir_r, dir_g, dir_b, dir_a)
						if GetStreetNameFromHashKey(var2) == "" then
							drawTxt2(x-0.266, y+0.45, 1.0,1.0,0.45, current_zone, town_r, town_g, town_b, town_a)
						else
							drawTxt2(x-0.266, y+0.45, 1.0,1.0,0.45, GetStreetNameFromHashKey(var2) .. ", " .. GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z)), str_around_r, str_around_g, str_around_b, str_around_a)
						end
							drawTxt2(x-0.266, y+0.42, 1.0,1.0,0.55, GetStreetNameFromHashKey(var1), curr_street_r, curr_street_g, curr_street_b, curr_street_a)
					end
				end
			end
		else
			if (vehicle ~= 0) then
				if GetStreetNameFromHashKey(var1) and GetNameOfZone(pos.x, pos.y, pos.z) then
					if GetStreetNameFromHashKey(var1) then
						if direction == 'N' then
								drawTxt(x-0.335, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
								drawTxt(x-0.306, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
								drawTxt(x-0.315, y+0.42, 1.0,1.0,1.0, direction, dir_r, dir_g, dir_b, dir_a)
							if GetStreetNameFromHashKey(var2) == "" then
								drawTxt2(x-0.285, y+0.45, 1.0,1.0,0.45, current_zone, town_r, town_g, town_b, town_a)
							else
								drawTxt2(x-0.285, y+0.45, 1.0,1.0,0.45, GetStreetNameFromHashKey(var2) .. ", " .. GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z)), str_around_r, str_around_g, str_around_b, str_around_a)
							end
								drawTxt2(x-0.285, y+0.42, 1.0,1.0,0.55, GetStreetNameFromHashKey(var1), curr_street_r, curr_street_g, curr_street_b, curr_street_a)
						elseif direction == 'NØ' then
								drawTxt(x-0.335, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
								drawTxt(x-0.298, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
								drawTxt(x-0.315, y+0.42, 1.0,1.0,1.0, direction, dir_r, dir_g, dir_b, dir_a)
							if GetStreetNameFromHashKey(var2) == "" then
								drawTxt2(x-0.277, y+0.45, 1.0,1.0,0.45, current_zone, town_r, town_g, town_b, town_a)
							else
								drawTxt2(x-0.277, y+0.45, 1.0,1.0,0.45, GetStreetNameFromHashKey(var2) .. ", " .. GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z)), str_around_r, str_around_g, str_around_b, str_around_a)
							end
							drawTxt2(x-0.277, y+0.42, 1.0,1.0,0.55, GetStreetNameFromHashKey(var1),curr_street_r, curr_street_g, curr_street_b, curr_street_a)
						elseif direction == 'Ø' then
								drawTxt(x-0.335, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
								drawTxt(x-0.309, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
								drawTxt(x-0.315, y+0.42, 1.0,1.0,1.0, direction, dir_r, dir_g, dir_b, dir_a)
							if GetStreetNameFromHashKey(var2) == "" then
								drawTxt2(x-0.288, y+0.45, 1.0,1.0,0.45, current_zone, town_r, town_g, town_b, town_a)
							else
								drawTxt2(x-0.288, y+0.45, 1.0,1.0,0.45, GetStreetNameFromHashKey(var2) .. ", " .. GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z)), str_around_r, str_around_g, str_around_b, str_around_a)
							end
							drawTxt2(x-0.288, y+0.42, 1.0,1.0,0.55, GetStreetNameFromHashKey(var1), curr_street_r, curr_street_g, curr_street_b, curr_street_a)
						elseif direction == 'SØ' then
								drawTxt(x-0.335, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
								drawTxt(x-0.298, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
								drawTxt(x-0.315, y+0.42, 1.0,1.0,1.0, direction, dir_r, dir_g, dir_b, dir_a)
							if GetStreetNameFromHashKey(var2) == "" then
								drawTxt2(x-0.275, y+0.45, 1.0,1.0,0.45, current_zone, town_r, town_g, town_b, town_a)
							else
								drawTxt2(x-0.275, y+0.45, 1.0,1.0,0.45, GetStreetNameFromHashKey(var2) .. ", " .. GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z)), str_around_r, str_around_g, str_around_b, str_around_a)
							end
								drawTxt2(x-0.275, y+0.42, 1.0,1.0,0.55, GetStreetNameFromHashKey(var1), curr_street_r, curr_street_g, curr_street_b, curr_street_a)
						elseif direction == 'S' then
								drawTxt(x-0.335, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
								drawTxt(x-0.307, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
								drawTxt(x-0.315, y+0.42, 1.0,1.0,1.0, direction, dir_r, dir_g, dir_b, dir_a)
							if GetStreetNameFromHashKey(var2) == "" then
								drawTxt2(x-0.285, y+0.45, 1.0,1.0,0.45, current_zone, town_r, town_g, town_b, town_a)
							else
								drawTxt2(x-0.285, y+0.45, 1.0,1.0,0.45, GetStreetNameFromHashKey(var2) .. ", " .. GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z)), str_around_r, str_around_g, str_around_b, str_around_a)
							end
								drawTxt2(x-0.285, y+0.42, 1.0,1.0,0.55, GetStreetNameFromHashKey(var1), curr_street_r, curr_street_g, curr_street_b, curr_street_a)
						elseif direction == 'SV' then
								drawTxt(x-0.335, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
								drawTxt(x-0.292, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
								drawTxt(x-0.315, y+0.42, 1.0,1.0,1.0, direction, dir_r, dir_g, dir_b, dir_a)
							if GetStreetNameFromHashKey(var2) == "" then
								drawTxt2(x-0.270, y+0.45, 1.0,1.0,0.45, current_zone, town_r, town_g, town_b, town_a)
							else
								drawTxt2(x-0.270, y+0.45, 1.0,1.0,0.45, GetStreetNameFromHashKey(var2) .. ", " .. GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z)), str_around_r, str_around_g, str_around_b, str_around_a)
							end
								drawTxt2(x-0.270, y+0.42, 1.0,1.0,0.55, GetStreetNameFromHashKey(var1), curr_street_r, curr_street_g, curr_street_b, curr_street_a)
						elseif direction == 'V' then
								drawTxt(x-0.335, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
								drawTxt(x-0.303, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
								drawTxt(x-0.315, y+0.42, 1.0,1.0,1.0, direction, dir_r, dir_g, dir_b, dir_a)
							if GetStreetNameFromHashKey(var2) == "" then
								drawTxt2(x-0.280, y+0.45, 1.0,1.0,0.45, current_zone, town_r, town_g, town_b, town_a)
							else
								drawTxt2(x-0.280, y+0.45, 1.0,1.0,0.45, GetStreetNameFromHashKey(var2) .. ", " .. GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z)), str_around_r, str_around_g, str_around_b, str_around_a)
							end
								drawTxt2(x-0.280, y+0.42, 1.0,1.0,0.55, GetStreetNameFromHashKey(var1), curr_street_r, curr_street_g, curr_street_b, curr_street_a)
						elseif direction == 'NV' then
								drawTxt(x-0.335, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
								drawTxt(x-0.290, y+0.66, 1.0,1.5,1.4, " | ", border_r, border_g, border_b, border_a)
								drawTxt(x-0.315, y+0.42, 1.0,1.0,1.0, direction, dir_r, dir_g, dir_b, dir_a)
							if GetStreetNameFromHashKey(var2) == "" then
								drawTxt2(x-0.266, y+0.45, 1.0,1.0,0.45, current_zone, town_r, town_g, town_b, town_a)
							else
								drawTxt2(x-0.266, y+0.45, 1.0,1.0,0.45, GetStreetNameFromHashKey(var2) .. ", " .. GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z)), str_around_r, str_around_g, str_around_b, str_around_a)
							end
								drawTxt2(x-0.266, y+0.42, 1.0,1.0,0.55, GetStreetNameFromHashKey(var1), curr_street_r, curr_street_g, curr_street_b, curr_street_a)
						end
					end
				end
			end
		end
	end
end)
