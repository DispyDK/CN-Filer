local ready = false
AddEventHandler("playerSpawned",function() -- delay state recording
    Citizen.CreateThread(function()
        Citizen.Wait(30000)
        ready = true
    end)
end)


if HasPedGotWeaponComponent(GetPlayerPed(-1), "WEAPON_VINTAGEPISTOL", "COMPONENT_AT_PI_SUPP") then
  TriggerServerEvent('giveback', 'silencer|WEAPON_VINTAGEPISTOL')
  RemoveWeaponComponentFromPed(GetPlayerPed(-1), "WEAPON_VINTAGEPISTOL", "COMPONENT_AT_PI_SUPP")
end
if HasPedGotWeaponComponent(GetPlayerPed(-1), "WEAPON_PISTOL_MK2", "COMPONENT_AT_PI_SUPP_02") then
  TriggerServerEvent('giveback', 'silencer|WEAPON_PISTOL_MK2')
  RemoveWeaponComponentFromPed(GetPlayerPed(-1), "WEAPON_PISTOL_MK2", "COMPONENT_AT_PI_SUPP_02")
end
if HasPedGotWeaponComponent(GetPlayerPed(-1), "WEAPON_PISTOL", "COMPONENT_AT_PI_SUPP_02") then
  TriggerServerEvent('giveback', 'silencer|WEAPON_PISTOL')
  RemoveWeaponComponentFromPed(GetPlayerPed(-1), "WEAPON_PISTOL", "COMPONENT_AT_PI_SUPP_02")
end

local silencers = {
  {weapon = "WEAPON_VINTAGEPISTOL", comp = "COMPONENT_AT_PI_SUPP"},
  {weapon = "WEAPON_PISTOL_MK2", comp = "COMPONENT_AT_PI_SUPP_02"},
  {weapon = "WEAPON_PISTOL", comp = "COMPONENT_AT_PI_SUPP_02"},
}


Citizen.CreateThread(function()
    while true do
        local player = GetPlayerPed(-1)
        local coords = GetEntityCoords(player)
        Citizen.Wait(1)
        local hasSilencer = false
        if IsPedShooting(player) and not HasPedGotWeapon(player, "WEAPON_SNOWBALL", false) and not HasPedGotWeapon(player, "WEAPON_BALL", false) then
            if CheckDistance(true) then
              for k, v in pairs(silencers) do
                if HasPedGotWeaponComponent(GetPlayerPed(-1), v.weapon, v.comp) then
                  hasSilencer = true
                end
              end
              if not hasSilencer then
                local message = "^7^*En person affyrer skud ved " .. GetStreetName(coords) .. "!"
                NotifyPeople(message,coords,true)
              end
            end
            Citizen.Wait(30000)
        end
    end
end)

local notify = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local player = GetPlayerPed(-1)
        local health = GetEntityHealth(player)
        if health <= 100 and ready then
            local coords = GetEntityCoords(player)
            if notify == false and CheckDistance(false) then
                local message = "^7^*En person er tæt på at dø her! | " .. GetStreetName(coords) .. " !"
                NotifyPeople(message,coords,false)
            end
            notify = true
        else
           notify = false
        end
    end
end)


local blipList = {}
RegisterNetEvent('notifyDispatch')
AddEventHandler('notifyDispatch', function(x,y,z,message,panic)
    local blip = AddBlipForCoord(x+0.001,y+0.001,z+0.001)
    SetBlipSprite(blip, 304)
    SetBlipColour(blip, 67)
    SetBlipAlpha(blip, 250)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Alarmcentralen")
    SetBlipScale(blip, 0.8)
    EndTextCommandSetBlipName(blip)

    blipList[blip] = 30000

    --Citizen.Trace("x:" .. x .. " y:" .. y .. " z:" .. z)
    if panic then
      TriggerEvent('chatMessage', '^2[NØDSITUATION]', "^2[NØDSITUATION]", ""..message)
      for i=1,10 do
        PlaySound(-1, "Out_Of_Bounds_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0, 0, 1)
        Wait(1000)
      end
    else
      PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
      TriggerEvent('chatMessage', '^3[Alarmcentralen]', "^3[Alarmcentralen]", message)
    end
end)



Citizen.CreateThread(function()
    while true do
        for k,v in pairs(blipList) do
            if v == 0 then
                RemoveBlip(k)
                blipList[k] = nil
            else
                blipList[k] = blipList[k]-1
            end
        end
        Citizen.Wait(1)
    end
end)

local pedtypes = {0,1,2,20,6,4,5,26}
function canPedBeUsed(ped)
    if ped == nil then
        return false
    end
    if ped == GetPlayerPed(-1) then
        return false
    end
    if not DoesEntityExist(ped) then
        return false
    end
    if GetVehiclePedIsUsing(ped) ~= 0 then
        return false
    end
    for a = 0, 256 do
        if GetPlayerPed(a) == ped then
            return false
        end
    end
    for k,v in pairs(pedtypes) do
        if GetPedType(ped) == v then
            return true
        end
    end
    return false
end

function CheckDistance(alert)
    local pedCoords = GetEntityCoords(PlayerPedId())
    for ped in EnumeratePeds() do
        if GetEntityHealth(ped) ~= 0 then
            local distanceCheck = GetDistanceBetweenCoords(pedCoords, GetEntityCoords(ped), true)
            if distanceCheck <= 350.0  then
                if canPedBeUsed(ped) then
                    if alert then
                        if GetPedAlertness(ped) >= 1 then
                            return true
                        end
                    else
                        return true
                    end
                end
            end
        end
    end
    return false
end

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
        TriggerServerEvent('dispatchpolice', pos.x, pos.y, pos.z, message)
    else
        TriggerServerEvent('dispatch', pos.x, pos.y, pos.z, message)
    end
end
