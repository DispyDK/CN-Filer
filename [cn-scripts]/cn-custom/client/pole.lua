vRP = Proxy.getInterface("vRP")

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


poles = {
	{104.19195556641,-1293.9932861328,29.258722305298,299.99526977539},
	{102.2046661377,-1290.6278076172,29.258718490601,303.16390991211},
	{112.60, -1286.76, 28.45, 265.902},
}


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local player = GetPlayerPed(-1)
		local coords = GetEntityCoords(PlayerPedId(),true)
		local heading = GetEntityHeading(player)
		for k,v in pairs(poles) do
			local x,y,z,h = table.unpack(v)

			if (Vdist(coords["x"], coords["y"], coords["z"], x,y,z) < 1.0) then
				DrawMarker(27, x,y,z+0.03-1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5001, 255, 25, 0, 200, 0, 0, 0, 50)
				Draw3DText(x,y,(z+0.03), "Tryk ~g~E~w~ for at pole danse")
				if IsControlPressed(0, 51) then
          			LoadDict('mini@strip_club@pole_dance@pole_dance1')

					SetEntityCoords(GetPlayerPed(-1), x,y,z-1, 1,0,0,1)
					SetEntityHeading(GetPlayerPed(-1), h)

           loadAnimDict( "mini@strip_club@pole_dance@pole_dance1" )
	loadAnimDict( "mini@strip_club@pole_dance@pole_dance2" )
	loadAnimDict( "mini@strip_club@pole_dance@pole_dance3" )
    loadAnimDict( "mini@strip_club@pole_dance@pole_enter" )

	TaskPlayAnim( PlayerPedId(), "mini@strip_club@pole_dance@pole_enter", "pd_enter", 1.0, -1.0, -1, 0, 1, 0, 0, 0)
	length = GetAnimDuration("mini@strip_club@pole_dance@pole_enter", "pd_enter")
	Citizen.Wait(length)

	TaskPlayAnim( PlayerPedId(), "mini@strip_club@pole_dance@pole_dance1", "pd_dance_01", 1.0, -1.0, -1, 0, 1, 0, 0, 0)
	length = GetAnimDuration("mini@strip_club@pole_dance@pole_dance1", "pd_dance_01")
	Citizen.Wait(length)

	TaskPlayAnim( PlayerPedId(), "mini@strip_club@pole_dance@pole_dance2", "pd_dance_02", 1.0, -1.0, -1, 0, 1, 0, 0, 0)
	length = GetAnimDuration("mini@strip_club@pole_dance@pole_dance2", "pd_dance_02")
	Citizen.Wait(length)

	TaskPlayAnim( PlayerPedId(), "mini@strip_club@pole_dance@pole_dance3", "pd_dance_03", 1.0, -1.0, -1, 0, 1, 0, 0, 0)
	length = GetAnimDuration("mini@strip_club@pole_dance@pole_dance3", "pd_dance_03")
	Citizen.Wait(length)
        end
			end
		end
	end
end)


LoadDict = function(Dict)
    while not HasAnimDictLoaded(Dict) do
        Wait(0)
        RequestAnimDict(Dict)
    end
end
