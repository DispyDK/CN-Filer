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



locations = {
	{2428.1220703125,3123.0,47.199810028076, itemIn="amfetamin", text="pakke", dist = 2.2},
	{135.8106842041,-1049.0809326172,28.151578903198, itemIn="kokain", text="pakke", dist = 2.2},
	{-2952.892578125,52.274784088135,10.581729888916, itemIn="skunk", text="pakke", dist = 2.2},
	{2194.4338378906,5598.7797851563,52.737319946289, itemIn="toerret_ketamin", text="pakke", dist = 2.2},
	{-742.02679443359,5595.0581054688,40.654579162598, itemIn="lsd", text="pakke", dist = 2.2},
	{1108.1062011719,241.41468811035,-46.840991973877, itemIn="dirty_money", text="veksle", dist = 2.2},
	{90.639221191406,-1987.6693115234,19.415191650391, itemIn="pak_heroin", text="udpakke", dist = 5.2}
}

local isPacking = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local player = GetPlayerPed(-1)
		local coords = GetEntityCoords(PlayerPedId(),true)
		for k,v in pairs(locations) do
			local x,y,z = table.unpack(v)

			if (Vdist(coords["x"], coords["y"], coords["z"], x,y,z) < v.dist) and not isPacking then
				Draw3DText(x,y,(z+1.33), "Tryk ~g~H~w~ for at "..v.text.." ~b~" .. v.itemIn)
				if IsControlJustPressed(0, 74) then
          TriggerServerEvent("packing:packItem", v.itemIn)

				end
			end
		end
	end
end)

RegisterNetEvent("packing:itemPacked")
AddEventHandler("packing:itemPacked", function(item)

	isPacking = true
local coords = GetEntityCoords(PlayerPedId(),true)
	loadAnimDict("random@domestic")
	box = CreateObject(GetHashKey("prop_paper_box_01"), coords["x"]-0.5, coords["y"]+0.5, coords["z"],  true,  true, true)

	PlaceObjectOnGroundProperly(box)


	for i=1,5 do
		money = CreateObject(GetHashKey("prop_meth_bag_01"), coords["x"], coords["y"], coords["z"], 0, 1, 1)
		AttachEntityToEntity(money, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, -0.05, -0.05, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0)
		TaskPlayAnim(GetPlayerPed(-1),"random@domestic","pickup_low",10.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)


		Wait(1000)
		DetachEntity(money)
		DeleteEntity(money)
		Wait(200)
	end

	Wait(1000)
	DeleteObject(box)
	TriggerServerEvent("packing:donePacking", item)
	isPacking = false
end)
