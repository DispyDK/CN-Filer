eventStatus = false

radius = 150


local time = 5

RegisterNetEvent("event:makeTheMarker")
AddEventHandler('event:makeTheMarker', function()
	eventStatus = true
	time = 5
end)


Citizen.CreateThread(function()
	while true do
	Citizen.Wait(0)
		if eventStatus and time > 0 then
				Citizen.CreateThread(function()
    local scaleform = RequestScaleformMovie("mp_big_message_freemode")
	    while not HasScaleformMovieLoaded(scaleform) do
	        Citizen.Wait(0)
	    end

		    BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
		    PushScaleformMovieMethodParameterString(time)
		    PushScaleformMovieMethodParameterString("Battle Royale om "..time.. " sekunder!")
		    PushScaleformMovieMethodParameterInt(5)
		    EndScaleformMovieMethod()

    		while eventStatus do
        	Citizen.Wait(0)
        	DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
					FreezeEntityPosition(GetPlayerPed(-1),true)
    		end
			end)
		elseif time <= 0 then
			eventStatus = false
			FreezeEntityPosition(GetPlayerPed(-1),false)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if eventStatus then
			time = time - 1
				StartScreenEffect("DeathFailMPDark", 1500, 0)
		end
	end
end)
