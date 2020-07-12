local animations = {
	{ dictionary = "creatures@rottweiler@amb@sleep_in_kennel@", animation = "sleep_in_kennel", name = "Lay Down", },
	{ dictionary = "creatures@rottweiler@amb@world_dog_barking@idle_a", animation = "idle_a", name = "Bark", },
	{ dictionary = "creatures@rottweiler@amb@world_dog_sitting@base", animation = "base", name = "Sit", },
	{ dictionary = "creatures@rottweiler@amb@world_dog_sitting@idle_a", animation = "idle_a", name = "Itch", },
	{ dictionary = "creatures@rottweiler@indication@", animation = "indicate_high", name = "Draw Attention", },
	{ dictionary = "creatures@rottweiler@tricks@", animation = "beg_loop", name = "Tig", },
	{ dictionary = "creatures@rottweiler@tricks@", animation = "paw_right_loop", name = "Højre pote", },
	{ dictionary = "creatures@rottweiler@incar@", animation = "sit", name = "sid i bilen", },
}

local dogModels = {
	"a_c_shepherd", "a_c_rottweiler", "a_c_husky", "a_c_poodle", "a_c_pug", "a_c_westy", "a_c_retriever"
}

local emotePlaying = false

function isDog()
	local playerModel = GetEntityModel(GetPlayerPed(-1))
	for i=1, #dogModels, 1 do
		if GetHashKey(dogModels[i]) == playerModel then
			return true
		end
	end
	return false
end

function cancelEmote()
	ClearPedTasksImmediately(GetPlayerPed(-1))
	emotePlaying = false
end

function playAnimation(dictionary, animation)
	if emotePlaying then
		cancelEmote()
	end
	RequestAnimDict(dictionary)
	while not HasAnimDictLoaded(dictionary) do
		Wait(1)
	end
	TaskPlayAnim(GetPlayerPed(-1), dictionary, animation, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
	emotePlaying = true
end

Citizen.CreateThread(function()
	WarMenu.CreateMenu('dogmenu', 'Doggo')

	while true do
		Citizen.Wait(0)

		if WarMenu.IsMenuOpened('dogmenu') then
			for i=1, #animations, 1 do
				if WarMenu.Button(animations[i].name) then
					playAnimation(animations[i].dictionary, animations[i].animation)
				end
			end
			if WarMenu.Button('Exit') then
				WarMenu.CloseMenu()
			end

			WarMenu.Display()
		end
		if not WarMenu.IsMenuOpened('dogmenu') and IsControlJustReleased(0, 244) and isDog() then
			WarMenu.OpenMenu('dogmenu')
		end
		if emotePlaying then
            if (IsControlPressed(0, 32) or IsControlPressed(0, 33) or IsControlPressed(0, 34) or IsControlPressed(0, 35)) then
                cancelEmote()
            end
        end
	end
end)
