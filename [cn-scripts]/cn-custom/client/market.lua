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



citem = {
  {33.779388427734,-1344.9344482422,28.497041702271, item="kølemontre"},--Alkohol køleskab
  {28.50368309021,-1342.6209716797,28.497041702271, item="snacks"},--Snacks køleskab
  {27.537406921387,-1345.2484130859,28.497041702271, item="læskedrikke"},--Læskedrikke køleskab
  {31.014709472656,-1346.9964599609,28.497041702271, item="donuts"},--Donuts køleskab
  {24.03652381897,-1347.8591308594,28.497062683105, item="spiritus"},--Spiritus køleskab
  {26.440685272217,-1342.9815673828,28.497018814087, item="slushice"},--Slush ice køleskab
  {24.480875015259,-1342.4230957031,28.497018814087, item="kaffe"},--Kaffe køleskab
  {26.512239456177,-1348.3780517578,28.497018814087, item="frugt"},--Frugt køleskab
  {28.776546478271,-1345.2052001953,28.497049331665, item="snacks"},--Snacks køleskab
  {25.647529602051,-1346.4527587891,28.497045516968, item="tyggegummi"},--Tyggegummi køleskab
}


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local player = GetPlayerPed(-1)
		local coords = GetEntityCoords(PlayerPedId(),true)
		for k,v in pairs(citem) do
			local x,y,z = table.unpack(v)

			if (Vdist(coords["x"], coords["y"], coords["z"], x,y,z) < 1.2) then
				Draw3DText(x,y,(z+1.33), "Tryk ~g~H~w~ for at tage noget fra ~b~" .. v.item)
				if IsControlJustPressed(0, 74) then
					print(v.item)

          loadAnimDict("mp_common")
          TaskPlayAnim(GetPlayerPed(-1),"mp_common","givetake1_a",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
          TriggerServerEvent("gumpher:openChest", v.item)

				end
			end
		end
	end
end)
