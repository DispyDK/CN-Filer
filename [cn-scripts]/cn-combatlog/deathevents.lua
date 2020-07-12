
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "sh_combatlogging")

Citizen.CreateThread(function()
    local isDead = false
    local hasBeenDead = false
	local diedAt

    while true do
        Wait(0)

        local player = PlayerId()

        if NetworkIsPlayerActive(player) then
            local ped = PlayerPedId()

            if IsPedFatallyInjured(ped) and not isDead then
                isDead = true
                if not diedAt then
                	diedAt = GetGameTimer()
                end

                local killer_2, killerweapon = NetworkGetEntityKillerOfPlayer(player)
                local killer = GetPedSourceOfDeath(ped)
                DeathCauseHash = GetPedCauseOfDeath(PlayerPedId())
                
                Weapon = DeathCauseHash
             
            
                if killer_2 ~= 0 and killer_2 ~= -1 then
                killer = killer_2
                end
				local killerentitytype = GetEntityType(killer)
				local killertype = -1
				local killerinvehicle = false
				local killervehiclename = ''
                local killervehicleseat = 0
				if killerentitytype == 1 then
					killertype = GetPedType(killer)
					if IsPedInAnyVehicle(killer, false) == 1 then
						killerinvehicle = true
						killervehiclename = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(killer)))
                        killervehicleseat = GetPedVehicleSeat(killer)
					else 
                        killerinvehicle = false
					end
				end

				local killerid = GetPlayerByEntityID(killer)
				if killer ~= ped and killerid ~= nil and NetworkIsPlayerActive(killerid) then 
                    killerid = GetPlayerServerId(killerid)
				else 
                    killerid = -1
				end

                if killer == ped then
                    TriggerEvent('baseevents:onPlayerDied', killertype, { (GetEntityCoords(ped)) })
                    TriggerServerEvent('baseevents:onPlayerDied', killertype, { (GetEntityCoords(ped)) })
                    hasBeenDead = true
                else
                    TriggerEvent('baseevents:onPlayerKilled', killerid, {killertype=killertype, weaponhash = killerweapon, killerinveh=killerinvehicle, killervehseat=killervehicleseat, killervehname=killervehiclename, killerpos={(GetEntityCoords(ped))}}, Weapon)
                    TriggerServerEvent('baseevents:onPlayerKilled', killerid, {killertype=killertype, weaponhash = killerweapon, killerinveh=killerinvehicle, killervehseat=killervehicleseat, killervehname=killervehiclename, killerpos={(GetEntityCoords(ped))}}, Weapon)
                    hasBeenDead = true
                end
            elseif not IsPedFatallyInjured(ped) then
                isDead = false
                diedAt = nil
            end

            if not hasBeenDead and diedAt ~= nil and diedAt > 0 then
                TriggerEvent('baseevents:onPlayerWasted', { (GetEntityCoords(ped)) })
                TriggerServerEvent('baseevents:onPlayerWasted', { (GetEntityCoords(ped)) })

                hasBeenDead = true
            elseif hasBeenDead and diedAt ~= nil and diedAt <= 0 then
                hasBeenDead = false
            end
        end
    end
end)

function GetPlayerByEntityID(id)
	for i=0,255 do
		if(NetworkIsPlayerActive(i) and GetPlayerPed(i) == id) then 
            return i end
	end
	return nil
end
