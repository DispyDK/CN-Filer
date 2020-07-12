--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 18-02-2019
-- Time: 01:50
-- Made for CiviliansNetwork
--
function tvRP.getArmour()
    return GetPedArmour(GetPlayerPed(-1))
end

function tvRP.setArmour(armour,vest)
    local player = GetPlayerPed(-1)
    if vest then
        if(GetEntityModel(player) == GetHashKey("mp_m_freemode_01")) then
--		          SetPedComponentVariation(player, 9, 26, 9, 2)  --Bulletproof Vest Mand
        else
            if(GetEntityModel(player) == GetHashKey("mp_f_freemode_01")) then
--                SetPedComponentVariation(player, 9, 26, 9, 2)  --Bulletproof Vest Kvinde
            end
        end
    end
    local n = math.floor(armour)
    SetPedArmour(player,n)
end

function tvRP.setsArmour(armour,vest)
    local player = GetPlayerPed(-1)
    local n = math.floor(armour)
    SetPedArmour(player,n)
end

local state_ready = false
AddEventHandler("playerSpawned",function() -- delay state recording
    state_ready = false
    Citizen.CreateThread(function()
        Citizen.Wait(30000)
        state_ready = true
    end)
end)

local lastarmor = 0
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        if lastarmor ~= tvRP.getArmour() then
            lastarmor = tvRP.getArmour()
            TriggerServerEvent("vrp_doven_loesning_setarmor", lastarmor)
        end
        if IsPlayerPlaying(PlayerId()) and state_ready then
            if tvRP.getArmour() == 0 then
                if(GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01")) or (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01")) then
                  --  SetPedComponentVariation(GetPlayerPed(-1), 9, 0, 1, 2)
                end
            end
        end
    end
end)
