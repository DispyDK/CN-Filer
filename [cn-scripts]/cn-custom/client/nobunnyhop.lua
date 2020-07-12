
local ragdoll_chance = 0.65 

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local ped = PlayerPedId()
		if IsPedOnFoot(ped) and not IsPedSwimming(ped) and IsPedRunning(ped) and not IsPedClimbing(ped) and IsPedJumping(ped) and not IsPedRagdoll(ped) then
			local chance_result = math.random()
			if chance_result < ragdoll_chance then 
				Citizen.Wait(600)
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08) 
				SetPedToRagdoll(ped, 5000, 1, 2)
			else
				Citizen.Wait(2000)
			end
		end
	end
end)