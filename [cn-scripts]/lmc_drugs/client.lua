local delay = 0
RegisterCommand("coke", function()
	if delay == 0 then
		num = math.random(1,67)
		TriggerServerEvent("lmc_drugs:sendSMS", "kokain_pure", num)
		delay = 5
	end
end)

RegisterCommand("amf", function()
	if delay == 0 then
		num = math.random(1,67)
		TriggerServerEvent("lmc_drugs:sendSMS", "lys_amfetamin_pure", num)
		delay = 5
	end
end)

RegisterCommand("heroin", function()
	if delay == 0 then
		num = math.random(1,67)
		TriggerServerEvent("lmc_drugs:sendSMS", "brun_heroin_pure", num)
		delay = 5
	end
end)

RegisterCommand("marok", function()
	if delay == 0 then
		num = math.random(1,67)
		TriggerServerEvent("lmc_drugs:sendSMS", "lys_marok_pure", num)
		delay = 5
	end
end)


sellPos = {
  [1] = {464.44256591797,-700.09240722656,27.52629470, item="", units=0, status=0},
	[2] = {1550.4854736328,6608.7607421875,2.6144409179, item="", units=0, status=0},
	[3] = {485.56011962891,-916.72863769531,26.01297569, item="", units=0, status=0},
	[4] = {467.29937744141,-1316.3297119141,28.98872947, item="", units=0, status=0},
	[5] = {447.53436279297,-1964.5037841797,22.71482086, item="", units=0, status=0},
	[6] = {-55.539794921875,-1785.0306396484,27.7742500, item="", units=0, status=0},
	[7] = {-1192.4396972656,-1587.2496337891,4.12110710, item="", units=0, status=0},
	[8] = {-1603.2236328125,-999.5615234375,7.335905551, item="", units=0, status=0},
	[9] = {-1844.1755371094,-1247.9580078125,8.36378288, item="", units=0, status=0},
	[10] = {-1791.5733642578,-683.17388916016,10.3893032, item="", units=0, status=0},
	[11] = {-1971.646484375,-470.96017456055,19.21573066, item="", units=0, status=0},
	[12] = {-2188.3251953125,-400.03576660156,13.0105943, item="", units=0, status=0},
	[13] = {-2954.5051269531,57.111885070801,11.35649967, item="", units=0, status=0},
	[14] = {-3100.123046875,212.26640319824,14.070201873, item="", units=0, status=0},
	[15] = {-3104.0534667969,398.79064941406,2.105947256, item="", units=0, status=0},
	[16] = {-3068.3403320313,627.29119873047,7.135061264, item="", units=0, status=0},
	[17] = {-3178.6806640625,1034.6522216797,20.61122131, item="", units=0, status=0},
	[18] = {-2786.5498046875,1433.1392822266,100.6763839, item="", units=0, status=0},
	[19] = {-740.71350097656,5594.4814453125,41.40260696, item="", units=0, status=0},
	[20] = {-404.45861816406,6318.2495117188,31.96555900, item="", units=0, status=0},
	[21] = {-7.723521232605,6597.8793945313,31.218471527, item="", units=0, status=0},
	[22] = {104.18673706055,6621.7241210938,31.578714370, item="", units=0, status=0},
	[23] = {438.25537109375,6462.8217773438,28.491521835, item="", units=0, status=0},
	[24] = {2195.9675292969,5603.2944335938,53.294742584, item="", units=0, status=0},
	[25] = {2440.2844238281,4969.7739257813,46.573604583, item="", units=0, status=0},
	[26] = {-1655.8957519531,22.528299331665,62.11301040, item="", units=0, status=0},
	[27] = {-1467.05859375,40.291790008545,53.7842292785, item="", units=0, status=0},
	[28] = {-1036.8015136719,-228.68072509766,38.8351211, item="", units=0, status=0},
	[29] = {-379.89831542969,-458.20532226563,30.6409702, item="", units=0, status=0},
	[30] = {-113.68807983398,-327.54415893555,35.1609382, item="", units=0, status=0},
	[31] = {-430.49349975586,289.83419799805,86.06254577, item="", units=0, status=0},
	[32] = {1671.7790527344,4976.6118164063,42.061950683, item="", units=0, status=0},
	[33] = {1299.6807861328,4222.6953125,33.656665802002, item="", units=0, status=0},
	[34] = {896.43292236328,3563.5017089844,33.535625457, item="", units=0, status=0},
	[35] = {1392.3732910156,3607.4597167969,38.689910888, item="", units=0, status=0},
	[36] = {1513.0495605469,3570.6145019531,38.485820770, item="", units=0, status=0},
	[37] = {1823.9503173828,3727.3376464844,33.726325988, item="", units=0, status=0},
	[38] = {1986.9584960938,3035.720703125,46.8054199218, item="", units=0, status=0},
	[39] = {2329.994140625,2572.17578125,46.426769256592, item="", units=0, status=0},
	[40] = {1526.8526611328,1704.3920898438,109.58792877, item="", units=0, status=0},
	[41] = {1021.9005737305,137.6261138916,84.7388458251, item="", units=0, status=0},
	[42] = {976.61022949219,-143.00497436523,73.98420715, item="", units=0, status=0},
	[43] = {1149.1010742188,-403.8268737793,71.210472106, item="", units=0, status=0},
	[44] = {1225.9520263672,-434.51141357422,67.34904479, item="", units=0, status=0},
	[45] = {1207.5056152344,-584.09796142578,68.56986236, item="", units=0, status=0},
	[46] = {1129.4205322266,-646.59088134766,56.57755661, item="", units=0, status=0},
	[47] = {1083.3848876953,-791.42742919922,58.01407241, item="", units=0, status=0},
	[48] = {910.03509521484,-1064.3156738281,37.49315261, item="", units=0, status=0},
	[49] = {726.95849609375,-1195.2373046875,24.03264617, item="", units=0, status=0},
	[50] = {945.46466064453,-1721.8590087891,30.40395927, item="", units=0, status=0},
	[51] = {964.41223144531,-1829.5637207031,35.81584548, item="", units=0, status=0},
	[52] = {832.6611328125,-2139.8708496094,29.195495605, item="", units=0, status=0},
	[53] = {807.45623779297,-2501.9697265625,28.16839599, item="", units=0, status=0},
	[54] = {696.22705078125,-2392.1254882813,26.37363243, item="", units=0, status=0},
	[55] = {828.35296630859,-3325.0583496094,5.648512840, item="", units=0, status=0},
	[56] = {1240.4852294922,-3002.8566894531,9.071624755, item="", units=0, status=0},
	[57] = {1011.9268188477,-2894.0932617188,11.01512718, item="", units=0, status=0},
	[58] = {-1353.7038574219,119.03240203857,55.99129104, item="", units=0, status=0},
	[59] = {-875.16033935547,38.201168060303,48.50840759, item="", units=0, status=0},
	[60] = {-837.08526611328,113.595703125,55.0352172851, item="", units=0, status=0},
	[61] = {-1049.8609619141,318.44924926758,66.54003143, item="", units=0, status=0},
	[62] = {-969.85998535156,537.04583740234,81.38457489, item="", units=0, status=0},
	[63] = {-1047.48046875,528.16540527344,84.3312530517, item="", units=0, status=0},
	[64] = {-1387.3149414063,343.13116455078,63.83570861, item="", units=0, status=0},
	[65] = {-1631.2694091797,272.11459350586,59.30511856, item="", units=0, status=0},
	[66] = {-1818.5284423828,324.96563720703,88.33213043, item="", units=0, status=0},
	[67] = {-1891.2962646484,258.17602539063,86.02091217, item="", units=0, status=0},
}


RegisterNetEvent('lmc_drugs:changeStatus')
AddEventHandler('lmc_drugs:changeStatus', function(num, units, item, status)
	print("Nummer: "..num)
	num = num
	sellPos[num].status = status
		print("Units: "..units)
	sellPos[num].units = units
	print("Status: " .. sellPos[num].status)
	sellPos[num].item = item
	print("Item: " .. sellPos[num].item)
end)

local isSelling = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local player = GetPlayerPed(-1)
		local coords = GetEntityCoords(PlayerPedId(),true)
		if num then
	    x,y,z = table.unpack(sellPos[num])
			if (Vdist(coords["x"], coords["y"], coords["z"], x,y,z) < 3) and sellPos[num].status == 1 then

				Draw3DText(x,y,(z+0.33), "Tryk ~g~H~w~ for at sælge")
				if IsControlJustPressed(0, 74) then
				--  TriggerServerEvent("farming:farmItem", v.itemOut)
				Wait(100)
				isSelling = true


				times = sellPos[num].units

				for i=1,times do
					local coords = GetEntityCoords(PlayerPedId(),true)
					if (Vdist(coords["x"], coords["y"], coords["z"], x,y,z) < 4) and isSelling then

						Wait(1000 * 1)

						if isSelling then
							TriggerServerEvent("lmc_drugs:sell", sellPos[num].item)
						end
					else
						if IsControlJustPressed(0, 74) then
							isSelling = false
						end
					end
				end
				TriggerServerEvent("lmc_drugs:doneSelling", num)
				--Wait(1000)

				isSelling = false

				end

			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000*60)
		if delay >= 1 then
			delay = delay - 1
			--print(delay)
		end
	end
end)

function Draw3DText(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local px, py, pz = table.unpack(GetGameplayCamCoords())

	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x, _y)
	local factor = (string.len(text)) / 370
	DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 20,20,20,150)
end
