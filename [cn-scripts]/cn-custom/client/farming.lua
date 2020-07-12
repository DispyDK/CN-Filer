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

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end



farms = {
	-- Kokain
	{178.89031982422,1224.572265625,230.42666015625, itemOut="cut_pasta", time=2.5, prop="", anim="random@domestic", text="Cut Kokain Pasta", dict="pickup_low", dist=2.0, min=1, max=25},
	{187.05725097656,1226.4437255859,230.42650756836, itemOut="pak_kokain", time=12, prop="", anim="random@domestic", text="Pak Kokain", dict="pickup_low", dist=2.0, min=1, max=4},
	-- Amfetamin
	{441.28253173828,6457.7397460938,35.864963531494, itemOut="cut_amfetamin", time=2.5, prop="", anim="random@domestic", text="Cut Ren Amfetamin", dict="pickup_low", dist=2.0, min=1, max=25},
	{424.29846191406,6472.478515625,35.873111724854, itemOut="pak_amfetamin", time=12, prop="", anim="random@domestic", text="Pak Amfetamin", dict="pickup_low", dist=2.0, min=1, max=4},
	-- Heroin
	{-739.24755859375,5583.78515625,36.709693908691, itemOut="cut_heroin", time=2.5, prop="", anim="random@domestic", text="Cut Heroin", dict="pickup_low", dist=2.0, min=1, max=25},
	{-743.57287597656,5594.9765625,41.654582977295, itemOut="pak_heroin", time=12, prop="", anim="random@domestic", text="Pak Heroin", dict="pickup_low", dist=2.0, min=1, max=4},
	-- Skunk
	{726.70733642578,4190.3881835938,40.709190368652, itemOut="cut_topskud", time=2.5, prop="", anim="random@domestic", text="Cut Topskud", dict="pickup_low", dist=2.0, min=1, max=25},
	{738.09899902344,4178.4584960938,40.927355957031, itemOut="pak_topskud", time=12, prop="", anim="random@domestic", text="Pak Topskud", dict="pickup_low", dist=2.0, min=1, max=4},

	--Radio salg
	{-1211.1749267578,-1461.6164550781,3.3299674987793, itemOut="dirty_money", time=6, prop="", anim="random@domestic", dict="pickup_low", text="sælge radio", dist=5, min=30, max=210},

	--Vindue farm
	{-1869.669921875,2175.55859375,113.19588470459, itemOut="vindruer", time=4, prop="", anim="random@domestic", text="Høst vindruer", dict="pickup_low", dist=5, min=60, max=420},

	--Fængsel Planke
	{1690.060546875,2555.7040917969,44.724865112305, itemOut="planke1", time=6, prop="", anim="random@domestic", text="Saml planke", dict="pickup_low", dist=1.2, min=1, max=1},
	{1695.8878173828,2556.4602050781,44.724865112305, itemIn="planke1", itemOut="planke2", time=6, prop="", anim="amb@prop_human_parking_meter@male@base", text="Skær planken", dict="base", dist=1.2, min=1, max=1},
	{1697.0881591797,2551.181640625,44.704865112305, itemIn="planke2", itemOut="planke3", time=6, prop="", anim="amb@world_human_hammering@male@base", text="Byg en træstol", dict="base", dist=1.2, min=1, max=1},
	{1689.601271972656,2551.7081054688,44.724865112305, itemIn="planke3", itemOut="money", time=6, prop="", anim="random@domestic", text="Pak stolen i kassen", dict="pickup_low", dist=1.2, min=1, max=1},

	--Miner mine 
	{2926.3229980469,2793.8664550781,39.657707214355, itemOut="kul", time=7, prop="prop_tool_pickaxe", anim="melee@large_wpn@streamed_core", text="Hak kul", dict="ground_attack_on_spot", dist=5, min=30, max=420},
	{2946.8620605469,2730.86328125,45.347545623779, itemOut="steel", time=8, prop="prop_tool_pickaxe", anim="melee@large_wpn@streamed_core", text="Hak stål", dict="ground_attack_on_spot", dist=5, min=30, max=420},
	{2977.6328125,2791.02734375,39.587665557861, itemOut="sulfur", time=6, prop="prop_tool_pickaxe", anim="melee@large_wpn@streamed_core", text="Hak svovl", dict="ground_attack_on_spot", dist=5, min=30, max=420},
	{2995.0314941406,2753.5418945313,42.086553497314, itemOut="aluminium", time=6, prop="prop_tool_pickaxe", anim="melee@large_wpn@streamed_core", text="Hak aluminium oxide", dict="ground_attack_on_spot", dist=5, min=30, max=420},
	{2946.2412109375,2819.3559570313,41.745914459229, itemOut="guldmalm", time=7, prop="prop_tool_pickaxe", anim="melee@large_wpn@streamed_core", text="Hak guldmalm", dict="ground_attack_on_spot", dist=5, min=30, max=420},

}

local isFarming = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if IsControlJustPressed(0, 74) then
			if isFarming then
				isFarming = false
			end
			print(isFarming)
		end
	end
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local player = GetPlayerPed(-1)
		local coords = GetEntityCoords(PlayerPedId(),true)
		for k,v in pairs(farms) do
			local x,y,z = table.unpack(v)


			if (Vdist(coords["x"], coords["y"], coords["z"], x,y,z) < v.dist) then
				if not isFarming then
				Draw3DText(x,y,(z+1.33), "Tryk ~g~H~w~ for at " .. v.text)
				if IsControlJustPressed(0, 74) then
        --  TriggerServerEvent("farming:farmItem", v.itemOut)
				Wait(100)
				isFarming = true
				loadAnimDict(v.anim)

				PlaceObjectOnGroundProperly(box)

				times = math.random(v.min,v.max)

				for i=1,times do
					local coords = GetEntityCoords(PlayerPedId(),true)
					if (Vdist(coords["x"], coords["y"], coords["z"], x,y,z) < v.dist) and isFarming then
						money = CreateObject(GetHashKey(v.prop), coords["x"], coords["y"], coords["z"], 0, 1, 1)
						AttachEntityToEntity(money, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, -0.05, -0.05, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0)
						TaskPlayAnim(GetPlayerPed(-1),v.anim,v.dict,10.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)


						Wait(1000 * v.time)
						DetachEntity(money)
						DeleteEntity(money)
						if isFarming then
							TriggerServerEvent("farming:donefarming", v.itemOut)
						end
					else
						if IsControlJustPressed(0, 74) then
							isFarming = false
						end
					end
				end

				--Wait(1000)

				isFarming = false

				end
				else
					isFarming = false
				end
			end
		end
	end
end)

RegisterNetEvent("farming:itemFarmed")
AddEventHandler("farming:itemFarmed", function(item)


end)
