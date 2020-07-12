local crouched = false
local blackouted = false
local crouch = false
Citizen.CreateThread( function()
    while true do
        Citizen.Wait( 5 )
        local ped = GetPlayerPed( -1 )
        if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
            DisableControlAction( 0, 36, true ) -- INPUT_DUCK

            if ( not IsPauseMenuActive() ) then
                if ( crouch ) then
                  crouch = false
                    RequestAnimSet( "move_ped_crouched" )
                    while ( not HasAnimSetLoaded( "move_ped_crouched" ) ) do
                        Citizen.Wait( 100 )
                    end
                    if ( crouched == true ) then
                        ResetPedMovementClipset( ped, 0 )
                        crouched = false
                    elseif ( crouched == false ) then
                        SetPedMovementClipset( ped, "move_ped_crouched", 0.55 )
                        crouched = true
                    end
                end
            end
        end
    end
end)





local currentHealth = GetEntityHealth(GetPlayerPed(-1))
local lockHealth = GetEntityHealth(GetPlayerPed(-1))
local hunger = 0
local thirst = 0
local pauseHealth = false


Citizen.CreateThread(function()
	while true do
			if blackouted and crouched then
				DisableControlAction(0, 23, true)
			end

		local playerPed = GetPlayerPed(-1)
		local health = GetEntityHealth(GetPlayerPed(-1))
		Citizen.Wait(100)
		if health <= 140 and health >= 121 and not crouched and not blackouted then
			RequestAnimSet("move_injured_generic")

      		while not HasAnimSetLoaded("move_injured_generic") do
        		Citizen.Wait(0)
      		end

      		SetPedMovementClipset(playerPed, "move_injured_generic", true)

		elseif health <= 120 and health >= 111 and not crouched and not blackouted then
			RequestAnimSet("move_heist_lester")

      		while not HasAnimSetLoaded("move_heist_lester") do
        		Citizen.Wait(0)
      		end

      		SetPedMovementClipset(playerPed, "move_heist_lester", true)

		elseif health <= 110 and health >= 101 and not crouched and not blackouted then
			RequestAnimSet("MOVE_M@DRUNK@MODERATEDRUNK_HEAD_UP")
			StartScreenEffect("DeathFailMPDark", 500, 0)

      		while not HasAnimSetLoaded("MOVE_M@DRUNK@MODERATEDRUNK_HEAD_UP") do
        		Citizen.Wait(0)
      		end

      		SetPedMovementClipset(playerPed, "MOVE_M@DRUNK@MODERATEDRUNK_HEAD_UP", true)

		elseif health <= 200  and health >= 161 and not crouched and not blackouted then

		end
	end
end)


RegisterCommand('+crouched', function()
    crouch = true
end, false)
RegisterCommand('-crouched', function()
    crouch = false
end, false)

RegisterKeyMapping('+crouched', 'Crouch', 'keyboard', 'e')
