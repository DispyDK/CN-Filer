vRP = Proxy.getInterface("vRP")
vRPex = Proxy.getInterface("vrp_extended")

local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

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

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 20, 20, 20, 150)
end

local doctorped = ""
RegisterNetEvent("vrp_hospital:place")
AddEventHandler("vrp_hospital:place", function()
    RequestModel(GetHashKey("s_m_m_doctor_01"))
    while not HasModelLoaded(GetHashKey("s_m_m_doctor_01")) do
        Wait(1)
    end
    doctorped =  CreatePed(4, 0xd47303ac, 308.40240478516,-595.62115478516,42.291896820068,63.091526031494, false, true)
    doctorped2 =  CreatePed(4, 0xd47303ac, 1824.4866943359,3678.5712890625,33.272716522217,260.37103271484, false, true)
    SetEntityHeading(doctorped, 26.38)
    FreezeEntityPosition(doctorped, true)
    SetEntityInvincible(doctorped, true)
    SetBlockingOfNonTemporaryEvents(doctorped, true)
    SetEntityHeading(doctorped2, 260.37)
    FreezeEntityPosition(doctorped2, true)
    SetEntityInvincible(doctorped2, true)
    SetBlockingOfNonTemporaryEvents(doctorped2, true)
end)

local list = {}
local usedbeds = {}

local beds = {
    1631638868,
    2117668672,
    -1091386327,
	-1519439119,
	-289946279
}

local z = 0

local checkedin = 0 -- sæt til false

local inbed = false

local pause = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if pause ~= 0 then if pause > 0 then pause = pause-1 end end
        if checkedin == 0 then
            local coords = GetEntityCoords(PlayerPedId(),true)
            if (Vdist(coords["x"], coords["y"], coords["z"], 306.74044799805,-594.91333007813,42.283988952637) < 1.2) then
                if pause == 0 then
                    DrawMarker(27, 306.74044799805,-594.91333007813,42.283988952637, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5001, 83, 255, 87, 200, 0, 0, 0, 50)
                    DrawText3Ds(306.74044799805,-594.91333007813,42.283988952637,"Tryk ~g~E ~w~for tjekke ind")
                    if IsControlJustReleased(1, Keys["E"]) then
                        pause = 16000
                        loadAnimDict("mp_common")
                        TaskPlayAnim(PlayerPedId(), "mp_common", "givetake1_a", 8.0, 8.0, -1, 1, 0, false, false, false)
                        TaskPlayAnim(doctorped, "mp_common", "givetake2_a", 8.0, 8.0, -1, 1, 0, false, false, false)
                        Citizen.Wait(2500)
                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "tjeksyge", 0.5)
                        ClearPedTasks(PlayerPedId())
                        TaskStartScenarioInPlace(doctorped, "WORLD_HUMAN_CLIPBOARD")
                        Citizen.Wait(10000)
                        ClearPedTasks(doctorped)
                        if vRPex.getAmountOnline({"ems"}) > 0 then
                            TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "ringertilkollega", 0.5)
                            Citizen.Wait(3000)
                            TaskStartScenarioInPlace(doctorped, "WORLD_HUMAN_STAND_MOBILE")
                            Citizen.Wait(7500)
                            ClearPedTasks(doctorped)
                            TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "kollegapaavej", 0.5)
                            TriggerServerEvent('dispatchems', coords["x"], coords["y"], coords["z"], "Der står en og mangler hjælp ved sygehuset!")
							checkedin = 18000
                        else
                            TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "tjekketindsyge", 0.5)
                            checkedin = 18000
                        end
                    end
                end
            end
        else
            if inbed == false then
                if checkedin > 0 then
                    checkedin = checkedin-1
                end
            end
        end
    end
end)

--Tjek ind Sandy
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if pause ~= 0 then if pause > 0 then pause = pause-1 end end
        if checkedin == 0 then
            local coords = GetEntityCoords(PlayerPedId(),true)
            if (Vdist(coords["x"], coords["y"], coords["z"], 1826.4080810547,3678.1420898438,33.27271270752) < 1.2) then
                if pause == 0 then
                    DrawMarker(27, 1826.4080810547,3678.1420898438,33.27271270752, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5001, 83, 255, 87, 200, 0, 0, 0, 50)
                    DrawText3Ds(1826.4080810547,3678.1420898438,33.27271270752,"Tryk ~g~E ~w~for tjekke ind")
                    if IsControlJustReleased(1, Keys["E"]) then
                        pause = 16000
                        loadAnimDict("mp_common")
                        TaskPlayAnim(PlayerPedId(), "mp_common", "givetake1_a", 8.0, 8.0, -1, 1, 0, false, false, false)
                        TaskPlayAnim(doctorped, "mp_common", "givetake2_a", 8.0, 8.0, -1, 1, 0, false, false, false)
                        Citizen.Wait(2500)
                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "tjeksyge", 0.5)
                        ClearPedTasks(PlayerPedId())
                        TaskStartScenarioInPlace(doctorped, "WORLD_HUMAN_CLIPBOARD")
                        Citizen.Wait(10000)
                        ClearPedTasks(doctorped)
                        if vRPex.getAmountOnline({"ems"}) > 0 then
                            TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "ringertilkollega", 0.5)
                            Citizen.Wait(3000)
                            TaskStartScenarioInPlace(doctorped, "WORLD_HUMAN_STAND_MOBILE")
                            Citizen.Wait(7500)
                            ClearPedTasks(doctorped)
                            TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "kollegapaavej", 0.5)
                            TriggerServerEvent('dispatchems', coords["x"], coords["y"], coords["z"], "Der står en og mangler hjælp ved sygehuset!")
							checkedin = 18000
                        else
                            TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "tjekketindsyge", 0.5)
                            checkedin = 18000
                        end
                    end
                end
            end
        else
            if inbed == false then
                if checkedin > 0 then
                    checkedin = checkedin-1
                end
            end
        end
    end
end)



-- // OPTIMIZE PAIR!
local ObjectAr = {}
local currObject = 0

-- // BASIC
local InUse = false
local IsTextInUse = false
local PlyLastPos = 0

-- // ANIMATION
local Anim = 'sit'
local AnimScroll = 0

-- // WHEN YOU ARE OUT OF RANGE, IT DOSENT TICK EVERY MS!
local canSleep = false

CreateThread(function()
    while true do
        Wait(1000)
        if (InUse == false) and (canSleep == true) then
            plyCoords = GetEntityCoords(PlayerPedId(), 0)
            for k, v in pairs(Config.objects.locations) do
                local oObject = GetClosestObjectOfType(plyCoords.x, plyCoords.y, plyCoords.z, 1.0, GetHashKey(v.object), 0, 0, 0)
                if (oObject ~= 0) then
                    local oObjectCoords = GetEntityCoords(oObject)
                    local ObjectDistance = #(vector3(oObjectCoords) - plyCoords)
                    if (ObjectDistance < 2) then
                        if (oObject ~= currObject) then
                            currObject = oObject
                            local oObjectExists = DoesEntityExist(oObject)
                            ObjectAr = {
                                fObject = oObject,
                                fObjectCoords = oObjectCoords,
                                fObjectcX = v.verticalOffsetX,
                                fObjectcY = v.verticalOffsetY,
                                fObjectcZ = v.verticalOffsetZ,
                                fObjectDir = v.direction,
                                fObjectIsBed = v.bed
                            }
                        end
                    end
                end
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        canSleep = true
        if ObjectAr.fObject ~= nil then
            ply = PlayerPedId()
            plyCoords = GetEntityCoords(ply, 0)
            ObjectCoords = ObjectAr.ObjectCoords
            local ObjectDistance = #(vector3(ObjectAr.fObjectCoords) - plyCoords)
            if (ObjectDistance < 1.8 and not InUse) then
                if (ObjectAr.fObjectIsBed) == true then

                    --[[ ARROW RIGHT ]]
                    if IsControlJustPressed(0, 175) then -- right
                        if (AnimScroll ~= 2) then
                            AnimScroll = AnimScroll + 1
                        end
                        if AnimScroll == 1 then
                            Anim = "ryggen"
                        elseif AnimScroll == 2 then
                            Anim = "maven"
                        end
                    end

                    --[[ ARROW LEFT ]]
                    if IsControlJustPressed(0, 174) then -- left
                        if (AnimScroll ~= 0) then
                            AnimScroll = AnimScroll - 1
                        end
                        if AnimScroll == 1 then
                            Anim = "ryggen"
                        elseif AnimScroll == 0 then
                            Anim = "sid"
                        end
                    end

                    if (Anim == 'sid') then

                        -- // Sorry for this shitty space solution :joy: <br> dont work with the buttons ;(
                        DisplayHelpText(Config.Text.SitOnBed .. '                               ' .. Config.Text.SwitchBetween, 1)

                    else
                        -- // Sorry for this shitty space solution :joy: <br> dont work with the buttons ;(
                        DisplayHelpText(Config.Text.LieOnBed .. ' ' .. Anim .. '                          ' .. Config.Text.SwitchBetween, 1)
                    end
                    if IsControlJustPressed(0, Config.objects.ButtonToLayOnBed) then
                        TriggerServerEvent('ChairBedSystem:Server:Enter', ObjectAr, ObjectAr.fObjectCoords)
                        inbed = true
                    end
                else
                    DisplayHelpText(Config.Text.SitOnChair, 1)
                    if IsControlJustPressed(0, Config.objects.ButtonToSitOnChair) then
                        TriggerServerEvent('ChairBedSystem:Server:Enter', ObjectAr, ObjectAr.fObjectCoords)
                    end
                end
            end

            if (inUse) then
                DisplayHelpText(Config.Text.Standup, 0)
                if IsControlJustPressed(0, Config.objects.ButtonToStandUp) then
                    inUse = false
                    TriggerServerEvent('ChairBedSystem:Server:Leave', ObjectAr.fObjectCoords)
                    ClearPedTasksImmediately(ply)
                    FreezeEntityPosition(ply, false)
                    inbed = false


                    local x, y, z = table.unpack(PlyLastPos)
                    if GetDistanceBetweenCoords(x, y, z, plyCoords) < 10 then
                        SetEntityCoords(ply, PlyLastPos)
                    end
                end
            end
        end
        if canSleep then
            Citizen.Wait(1000)
        end
    end
end)

CreateThread(function()
	while Config.Healing ~= 0 do
		Wait(Config.Healing*1000)
		if inUse == true then
			if ObjectAr.fObjectIsBed == true then
				local ply = PlayerPedId()
        if inbed and checkedin > 0 then
          local health = GetEntityHealth(PlayerPedId())
          if health <= 199 then
            if vRPex.getAmountOnline({"ems"}) > 0 then
              SetEntityHealth(PlayerPedId(),health+1)
            else
              SetEntityHealth(PlayerPedId(),health+2)
            end
          end
        end
			end
		end
	end
end)

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(16000)
--         if inbed and checkedin > 0 then
--             local health = GetEntityHealth(PlayerPedId())
--             if health <= 199 then
--                 SetEntityHealth(PlayerPedId(),health+1)
--             end
--         end
--     end
-- end)

RegisterNetEvent('ChairBedSystem:Client:Animation')
AddEventHandler('ChairBedSystem:Client:Animation', function(v, objectcoords)
    local object = v.fObject
    local vertx = v.fObjectcX
    local verty = v.fObjectcY
    local vertz = v.fObjectcZ
    local dir = v.fObjectDir
    local isBed = v.fObjectIsBed
    local objectcoords = v.fObjectCoords

    local ped = PlayerPedId()
    PlyLastPos = GetEntityCoords(ped)
    FreezeEntityPosition(object, true)
    FreezeEntityPosition(ped, true)
    inUse = true
    if isBed == false then
        if Config.objects.SitAnimation.dict ~= nil then
            SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
            SetEntityHeading(ped, GetEntityHeading(object) - 180.0)
            local dict = Config.objects.SitAnimation.dict
            local anim = Config.objects.SitAnimation.anim

            AnimLoadDict(dict, anim, ped)
        else
            TaskStartScenarioAtPosition(ped, Config.objects.SitAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + dir, 0, true, true)
        end
    else
        if Anim == 'ryggen' then
            if Config.objects.BedBackAnimation.dict ~= nil then
                SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
                SetEntityHeading(ped, GetEntityHeading(object) - 180.0)
                local dict = Config.objects.BedBackAnimation.dict
                local anim = Config.objects.BedBackAnimation.anim

                Animation(dict, anim, ped)
            else
                TaskStartScenarioAtPosition(ped, Config.objects.BedBackAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + dir, 0, true, true
            )
            end
        elseif Anim == 'maven' then
            if Config.objects.BedStomachAnimation.dict ~= nil then
                SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
                SetEntityHeading(ped, GetEntityHeading(object) - 180.0)
                local dict = Config.objects.BedStomachAnimation.dict
                local anim = Config.objects.BedStomachAnimation.anim

                Animation(dict, anim, ped)
            else
                TaskStartScenarioAtPosition(ped, Config.objects.BedStomachAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + dir, 0, true, true)
            end
        elseif Anim == 'sid' then
            if Config.objects.BedSitAnimation.dict ~= nil then
                SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
                SetEntityHeading(ped, GetEntityHeading(object) - 180.0)
                local dict = Config.objects.BedSitAnimation.dict
                local anim = Config.objects.BedSitAnimation.anim

                Animation(dict, anim, ped)
            else
                TaskStartScenarioAtPosition(ped, Config.objects.BedSitAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + 180.0, 0, true, true)
            end
        end
    end
end)

function DisplayHelpText(text, sound)
    canSleep = false
    AddTextEntry('label', text)
    BeginTextCommandDisplayHelp('label')
    DisplayHelpTextFromStringLabel(0, 0, sound, -1)
    EndTextCommandDisplayText(0.5, 0.5)
end


-- local laybed = 0
-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(1)
--         local coords = GetEntityCoords(PlayerPedId(),true)
--         for k,v in pairs(beds) do
--             local bed = GetClosestObjectOfType(coords["x"], coords["y"], coords["z"], 1.0, v, false, false, false)
--             if bed ~= 0 then
-- 				if v == -1519439119 or v == -289946279 then
-- 					z = 0.55
-- 				end
--                 local bcoords = GetEntityCoords(bed, true)
--                 if inbed == false then
--                     if usedbeds[math.floor(bcoords["x"])] == nil then
--                         DrawText3Ds(bcoords["x"],bcoords["y"],bcoords["z"]+0.75,"Tryk ~g~E ~w~for at lægge dig")
--                         if IsControlJustReleased(1, Keys["E"]) then
--                             FreezeEntityPosition(PlayerPedId(),true)
--                             TaskStartScenarioAtPosition(PlayerPedId(), "WORLD_HUMAN_SUNBATHE_BACK", bcoords["x"],bcoords["y"],bcoords["z"]+1.40+z, GetEntityHeading(bed), 0, true,true)
--                             TriggerServerEvent("cn-hospital:sendstatus",math.floor(bcoords["x"]),true)
--                             inbed = true
--                             laybed = bed
--                         end
--                     end
--                 end
--             end
--         end
--     end
-- end)
--
--
-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(16000)
--         if inbed and checkedin > 0 then
--             local health = GetEntityHealth(PlayerPedId())
--             if health <= 199 then
--                 SetEntityHealth(PlayerPedId(),health+1)
--             end
--         end
--     end
-- end)
-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(1)
--         if inbed then
--             ply_drawTxt("Tryk ~r~Y~w~ for at gå ud af sengen",4,1,0.5,0.95,0.6,255,255,255,255)
--             if IsControlJustReleased(1, Keys["Y"]) then
--                 local bcoords = GetEntityCoords(laybed)
--                 SetEntityCoordsNoOffset(PlayerPedId(),bcoords["x"]-1.2,bcoords["y"],bcoords["z"],0,0,1)
--                 FreezeEntityPosition(PlayerPedId(),false)
--                 SetEntityHeading(PlayerPedId(),GetEntityHeading(laybed)-180)
--                 TriggerServerEvent("cn-hospital:sendstatus",math.floor(bcoords["x"]),false)
--                 inbed = false
--                 laybed = 0
--             end
--         end
--     end
-- end)

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

RegisterNetEvent('cn-hospital:load')
AddEventHandler('cn-hospital:load', function(list)
    usedbeds = list
end)

RegisterNetEvent('cn-hospital:status')
AddEventHandler('cn-hospital:status', function(key,bed)
    usedbeds[key] = bed
end)
