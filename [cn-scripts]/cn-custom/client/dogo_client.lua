Citizen.CreateThread(function()
	while true do Citizen.Wait(5)
		if IsControlJustPressed(1, 44) and IsPedModel(GetPlayerPed(-1),1126154828) then
		local ped = GetPlayerPed(-1)
		termal = not termal
			if termal then -- set
				SetSeethrough(ped,true)
			else -- unset
				SetSeethrough(false)
			end
		end
		if IsPedModel(GetPlayerPed(-1),1126154828) or IsPedModel(GetPlayerPed(-1),351016938) then
			RestorePlayerStamina(PlayerId(-1), 1.0)
		end
	end
end)
