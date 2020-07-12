-- api
function tvRP.varyHealth(variation)
    local ped = GetPlayerPed(-1)
    local n = math.floor(GetEntityHealth(ped)+variation)
    SetEntityHealth(ped,n)
end

local drunk = false
local isDrunk = false
local promille = 0
function tvRP.setDrunk(bool,lpromille)
    if bool then
        if lpromille ~= nil then
            promille = tonumber(lpromille)
        end
        if isDrunk == false then
            drunk = true
        end
    end
    isDrunk = bool
end

local isReady = false
Citizen.CreateThread(function()
    while true do
        if isReady == false then
            Citizen.Wait(30000)
            isReady = true
            -- set movement
        end
        Citizen.Wait(1)
        if isDrunk and promille ~= nil then
            if promille > 2.0 then
                if GetScreenEffectIsActive("DrugsDrivingIn") == false then
                    tvRP.playScreenEffect("DrugsDrivingIn",-1)
                end
                playChipset("MOVE_M@DRUNK@VERYDRUNK")
            elseif promille > 1.5 then
                playChipset("MOVE_M@DRUNK@MODERATEDRUNK")
            else
                playChipset("MOVE_M@DRUNK@SLIGHTLYDRUNK")
            end
            if promille < 2.0 then
                if GetScreenEffectIsActive("DrugsDrivingIn") then
                    tvRP.stopScreenEffect("DrugsDrivingIn")
                end
            end
            if IsGameplayCamShaking() == false then
                ShakeGameplayCam("DRUNK_SHAKE", 1.0)
            end
        elseif isDrunk == false and drunk then
            drunk = false
            StopGameplayCamShaking( true )
            ResetPedMovementClipset(PlayerPedId(),0.0)
            if GetScreenEffectIsActive("DrugsDrivingIn") then
                tvRP.stopScreenEffect("DrugsDrivingIn")
            end
        end
    end
end)

function playChipset(chipset)
    RequestAnimSet(chipset)
    while not HasAnimSetLoaded(chipset) do
        Citizen.Wait(10)
    end
    SetPedMovementClipset(GetPlayerPed(-1), chipset, true)
end

function tvRP.getHealth()
    return GetEntityHealth(GetPlayerPed(-1))
end

function tvRP.setHealth(health)
    local n = math.floor(health)
    SetEntityHealth(GetPlayerPed(-1),n)
end

function tvRP.setFriendlyFire(flag)
    NetworkSetFriendlyFireOption(flag)
    SetCanAttackFriendly(GetPlayerPed(-1), flag, flag)
end

function tvRP.setPolice(flag)
    local player = PlayerId()
    SetPoliceIgnorePlayer(player, not flag)
    SetDispatchCopsForPlayer(player, flag)
end

-- impact thirst and hunger when the player is running (every 5 seconds)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)

        if IsPlayerPlaying(PlayerId()) then
            local ped = GetPlayerPed(-1)

            -- variations for one minute
            local vthirst = 0
            local vhunger = 0

            -- on foot, increase thirst/hunger in function of velocity
            if IsPedOnFoot(ped) and not tvRP.isNoclip() then
                local factor = math.min(tvRP.getSpeed(),10)

                vthirst = vthirst+1*factor
                vhunger = vhunger+0.5*factor
            end

            -- in melee combat, increase
            if IsPedInMeleeCombat(ped) then
                vthirst = vthirst+10
                vhunger = vhunger+5
            end

            -- injured, hurt, increase
            if IsPedHurt(ped) or IsPedInjured(ped) then
                vthirst = vthirst+2
                vhunger = vhunger+1
            end

            -- do variation
            if vthirst ~= 0 then
                vRPserver.varyThirst({vthirst/12.0})
            end

            if vhunger ~= 0 then
                vRPserver.varyHunger({vhunger/12.0})
            end
        end
    end
end)

-- COMA SYSTEM

local in_coma = false
local coma_left = cfg.coma_duration*60

Citizen.CreateThread(function() -- coma thread
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)

        local health = GetEntityHealth(ped)
        if health <= cfg.coma_threshold and coma_left > 0 then
            if not in_coma then -- go to coma state
                if IsEntityDead(ped) then -- if dead, resurrect
                    local x,y,z = tvRP.getPosition()
                      NetworkResurrectLocalPlayer(x, y, z, true, true, false)
                    Citizen.Wait(0)
                end

                -- coma state
                in_coma = true
                vRPserver.updateHealth({cfg.coma_threshold}) -- force health update
                SetEntityHealth(ped, cfg.coma_threshold)
                SetEntityInvincible(ped,true)
                tvRP.playScreenEffect(cfg.coma_effect,-1)
                tvRP.ejectVehicle()
                tvRP.setRagdoll(true)
            else -- in coma
                -- maintain life
                if health < cfg.coma_threshold then
                    SetEntityHealth(ped, cfg.coma_threshold)
                end
            end

            local minutes = math.floor(coma_left/60)
            if minutes > 0 then
                local seconds = math.floor(coma_left - (minutes*60))
                ply_drawTxt("Du kan genopstå om ~r~"..minutes.." ~w~minutter og ~r~"..seconds.." ~w~sekunder",4,1,0.5,0.95,0.6,255,255,255,255)
            else
                ply_drawTxt("Du kan genopstå om ~r~"..coma_left.." ~w~sekunder",4,1,0.5,0.95,0.6,255,255,255,255)
            end
            DisableControlAction(0, 24, true) -- attack
            DisableControlAction(0, 25, true) -- aim
            DisableControlAction(0, 37, true) -- weapon wheel
            DisableControlAction(0, 44, true) -- cover
            DisableControlAction(0, 45, true) -- reload
            DisableControlAction(0, 140, true) -- light attack
            DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
        else
            if in_coma then -- get out of coma state
                if health > cfg.coma_threshold then
                  ply_drawTxt("Tryk ~g~F7~w~ for at genopstå",4,1,0.5,0.95,0.6,255,255,255,255)
                else
                  ply_drawTxt("Tryk ~g~F7~w~ for at respawne helt",4,1,0.5,0.95,0.6,255,255,255,255)
                end
                if IsControlJustReleased(1, 168) then
                    in_coma = false
                    SetEntityInvincible(ped,false)
                    tvRP.setRagdoll(false)
                    tvRP.stopScreenEffect(cfg.coma_effect)
                    if health <= cfg.coma_threshold then
                        if coma_left <= 0 then -- get out of coma by death
                            SetEntityHealth(ped, 0)
                            DoScreenFadeOut(500)
                        end
                    else
                        coma_left = 0
                        ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.200)
                        vRPserver.updateHealth({health})
                    end
                    SetTimeout(5000, function()  -- able to be in coma again after coma death after 5 seconds
                        coma_left = cfg.coma_duration*60
                    end)
                else
                    if health < cfg.coma_threshold then
                        SetEntityHealth(ped, cfg.coma_threshold)
                    end
                end
            end
        end
    end
end)

function tvRP.isInComa()
    return in_coma
end

-- kill the player if in coma
function tvRP.killComa()
    if in_coma then
        coma_left = 0
    end
end

Citizen.CreateThread(function() -- coma decrease thread
    while true do
        Citizen.Wait(1000)
        if in_coma then
            coma_left = coma_left-1
        end
    end
end)

Citizen.CreateThread(function() -- disable health regen, conflicts with coma system
    while true do
        Citizen.Wait(100)
        -- prevent health regen
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0)
    end
end)



function ply_drawTxt(text,font,centre,x,y,scale,r,g,b,a)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(centre)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x , y)
end
