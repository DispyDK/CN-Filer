-- RADIO ANIMATIONS --

local policebikes = {
    -1787016839,
    -1274421506
}


local holstered = true
local weapons = {
	"WEAPON_COMBATPISTOL",
	"WEAPON_PISTOL_MK2",
	"WEAPON_GRENADELAUNCHER",
	"WEAPON_SMG",
	"WEAPON_PUMPSHOTGUN",
	"WEAPON_STUNGUN",
	"WEAPON_CARBINERIFLE",
	"WEAPON_KNIFE",
	"WEAPON_BAT",
	"WEAPON_CROWBAR",
	"WEAPON_KNUCKLE",
	"WEAPON_WRENCH",
	"WEAPON_SWITCHBLADE",
	"WEAPON_BATTLEAXE",
	"WEAPON_GOLFCLUB",
	"WEAPON_HAMMER",
	"WEAPON_MACHETE",
	"WEAPON_FLASHLIGHT",
	"WEAPON_NIGHTSTICK",
	"WEAPON_MICROSMG",
	"WEAPON_GUSENBERG",
	"WEAPON_MACHINEPISTOL",
	"WEAPON_MINISMG",
	"WEAPON_SAWNOFFSHOTGUN",
	"WEAPON_MOLOTOV",
}

cfg = {}

cfg.WeaponList = {
    453432689, --WEAPON_PISTOL
    -1716589765, --WEAPON_PISTOL50
    -771403250, --WEAPON_HEAVYPISTOL
    -1076751822, --WEAPON_SNSPISTOL
    584646201, --WEAPON_APPISTOL
}

cfg.PedAbleToWalkWhileSwapping = true
cfg.UnarmedHash = -1569615261
IsCloseToLastVehicle = false


function DisableActions(ped)
  DisableControlAction(1, 140, true)
  DisableControlAction(1, 141, true)
  DisableControlAction(1, 142, true)
  DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
  DisablePlayerFiring(ped, true) -- Disable weapon firing
end

function isPoliceMC(key)
    for k,v in pairs(policebikes) do
        if v == key then
            return true
        end
    end
    return false
end
function loadAnimDict( dict )
    RequestAnimDict( dict )
    while not HasAnimDictLoaded(dict)  do
        Citizen.Wait( 5 )
    end
end
--Police
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = GetPlayerPed(-1)
        if not IsEntityInWater(ped) then
            local weaponHash = GetHashKey("WEAPON_COMBATPISTOL")
            if DoesEntityExist( ped ) and not IsEntityDead( ped ) and HasPedGotWeapon(ped, weaponHash, false) then
                if not IsPauseMenuActive() then
                  if IsControlPressed(1, 19) and IsControlJustReleased(0, 243) then
                      local coords = GetEntityCoords(ped)
                      local message = "^7^*Panikknap er blevet udløst! | " .. GetStreetName(coords) .. " !"
                      NotifyPeople(message,coords,false)
                  end
                    if IsControlJustReleased( 0, 19 ) then
                        ClearPedSecondaryTask(ped)
                    end
                end
            end
        end
        local ped = GetPlayerPed(-1)
        if not IsEntityInWater(ped) then
            local weaponHash = GetHashKey("WEAPON_DIGISCANNER")
            if DoesEntityExist( ped ) and not IsEntityDead( ped ) and HasPedGotWeapon(ped, weaponHash, false) then
                if not IsPauseMenuActive() then
                    if IsControlPressed(1, 19) and IsControlJustReleased(0, 243) then
                      local coords = GetEntityCoords(ped)
                      local message = "^7^*Panikknap er blevet udløst! | " .. GetStreetName(coords) .. " !"
                      NotifyPeople(message,coords,false)
                  end

                    if IsControlJustReleased( 0, 19 ) then
                        ClearPedSecondaryTask(ped)
                    end
                end
            end
        end
        local ped = PlayerPedId()
        if not IsEntityInWater(ped) then
            local weaponHash = GetHashKey("WEAPON_COMBATPISTOL")
            if DoesEntityExist( ped ) and not IsEntityDead( ped ) and not IsPedInAnyVehicle(PlayerPedId(), true) and HasPedGotWeapon(ped, weaponHash, false) then
                DisableControlAction( 0, 20, true ) -- INPUT_MULTIPLAYER_INFO (Z)
                if not IsPauseMenuActive() then
                    loadAnimDict( "reaction@intimidation@cop@unarmed" )
                    if IsDisabledControlJustReleased( 0, 20 ) then -- INPUT_MULTIPLAYER_INFO (Z)
                        ClearPedTasks(ped)
                        SetEnableHandcuffs(ped, false)
                        SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
                    else
                        if IsDisabledControlJustPressed( 0, 20 ) and HasPedGotWeapon(ped, weaponHash, false) then -- INPUT_MULTIPLAYER_INFO (Z)
                            --delProps(ped)
                            SetEnableHandcuffs(ped, true)
                            SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
                            TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "intro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
                        end
                        if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "reaction@intimidation@cop@unarmed", "intro", 3) then
                            DisableActions(ped)
                        end
                    end
                end
            end
        end
		local ped = PlayerPedId()
		-- if DoesEntityExist( ped ) and not IsEntityDead( ped ) and not IsPedInAnyVehicle(PlayerPedId(), true) then
		-- 	loadAnimDict( "rcmjosh4" )
		-- 	loadAnimDict( "weapons@pistol@" )
		-- 	if CheckWeapon(ped) then
		-- 		if holstered then
		-- 			TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
		-- 			Citizen.Wait(1000)
		-- 			ClearPedTasks(ped)
		-- 			holstered = false
		-- 		end
		-- 	elseif not CheckWeapon(ped) then
		-- 		if not holstered then
		-- 			TaskPlayAnim(ped, "weapons@pistol@", "aim_2_holster", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
		-- 			Citizen.Wait(1000)
		-- 			ClearPedTasks(ped)
		-- 			holstered = true
		-- 		end
		-- 	end
		-- end
	end

    local animDict = 'reaction@intimidation@1h'
    local animIntroName = 'intro'
    local animOutroName = 'outro'
    local animFlag = 0

    RequestAnimDict(animDict)

    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(100)
    end

    local lastWeapon = nil

    while true do
        Citizen.Wait(0)
        if not IsPedInAnyVehicle(PlayerPedId(), true) then
            local vehicle   = GetPlayersLastVehicle()
            local vehcoords = GetEntityCoords(vehicle)
            local mycoords  = GetEntityCoords(PlayerPedId())
            local distance  = GetDistanceBetweenCoords(vehcoords.x, vehcoords.y, vehcoords.z, mycoords.x, mycoords.y, mycoords.z)
            if distance < 1 then
                IsCloseToLastVehicle = true
            else
                IsCloseToLastVehicle = false
            end
            if IsCloseToLastVehicle == false then
                if cfg.PedAbleToWalkWhileSwapping then
                    animFlag = 48
                else
                    animFlag = 0
                end

                for i=1, #cfg.WeaponList do
                    if lastWeapon ~= nil and lastWeapon ~= cfg.WeaponList[i] and GetSelectedPedWeapon(GetPlayerPed(-1)) == cfg.WeaponList[i] then
                        SetCurrentPedWeapon(GetPlayerPed(-1), cfg.UnarmedHash, true)
                        TaskPlayAnim(GetPlayerPed(-1), animDict, animIntroName, 8.0, -8.0, 2700, animFlag, 0.0, false, false, false)
                        BlockControls = true
                        Citizen.Wait(1000)
                        SetCurrentPedWeapon(GetPlayerPed(-1), cfg.WeaponList[i], true)
                        Citizen.Wait(1500)
                        BlockControls = false
                    end

                    if lastWeapon ~= nil and lastWeapon == cfg.WeaponList[i] and GetSelectedPedWeapon(GetPlayerPed(-1)) == cfg.UnarmedHash then
                        SetCurrentPedWeapon(GetPlayerPed(-1), cfg.WeaponList[i], true)
                        TaskPlayAnim(GetPlayerPed(-1), animDict, animOutroName, 8.0, -8.0, 2100, animFlag, 0.0, false, false, false)
                        BlockControls = true
                        Citizen.Wait(1000)
                        SetCurrentPedWeapon(GetPlayerPed(-1), cfg.UnarmedHash, true)
                        Citizen.Wait(1500)
                        BlockControls = false
                    end
                end
            end
            lastWeapon = GetSelectedPedWeapon(GetPlayerPed(-1))
        end
        if BlockControls == true then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
            DisableControlAction(0, 21, true)
            DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
            DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
        end
    end
end)

function GetStreetName(playerPos)
    local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, playerPos.x, playerPos.y, playerPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)

    if s2 == 0 then
        return street1
    elseif s2 ~= 0 then
        return street1 .. " - " .. street2
    end
end


function NotifyPeople(message, pos, bool)
    if bool then
        -- TriggerServerEvent('dispatchpolice', pos.x, pos.y, pos.z, message)
    else
        TriggerServerEvent('dispatch', pos.x, pos.y, pos.z, message, true)
            -- TriggerServerEvent('dispatch', pos.x, pos.y, pos.z, message)
    end
end

function CheckWeapon(ped)
	for i = 1, #weapons do
		if GetHashKey(weapons[i]) == GetSelectedPedWeapon(ped) then
			return true
		end
	end
	return false
end
