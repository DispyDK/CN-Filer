vRPbf = {}

local biler = {
    ["SANCHEZ01"] = "sanchez",
    ["STINGERG"] = "stingergt",
    ["DILETTAN"] = "dilettante",
    ["COGCABRI"] = "cogcabrio",
    ["SCHAFTER"] = "schafter2",
    ["WASHINGT"] = "washington",
    ["CARBONIZ"] = "carbonizzare",
    ["FELTZER"] = "feltzer2",
    ["FURORE"] = "furoregt",
    ["RAPIDGT"] = "rapidgt2",
    ["KHAMEL"] = "khamelion",
    ["VERLIER"] = "verlierer2",
    ["TROPHY"] = "trophytruck",
    ["FAGGION"] = "faggio",
    ["BUCCANEE"] = "buccaneer",
    ["DOMINATO"] = "dominator",
    ["NITESHAD"] = "nightshade",
    ["TAILGATE"] = "tailgater",
	["COGNOSC"] = "cognoscenti",
	["BUFFALO02"] = "buffalo2",
	["REBEL02"] = "rebel2",
	["CAVCADE"] = "cavalcade",

}

local imports = {
    {name="import", colour=3, id=357, marker=27, coords = {-45.283210754395,-1083.0900878906,25.817651367188}, hidden=false}
}
local spawns = {
    {name="spawn", colour=3, id=357, marker=27, coords = {1216.2814941406,-2924.255859375,4.9260650253296}, hidden=false}
}

lang_string = {
    menu1 = "Tryk ~g~E~s~ for at stock",
    menu2 = "Tryk ~g~E~s~ for at spawn",
}
function LocalPed()
    return GetPlayerPed(-1)
end

function ply_drawTxt(text,font,centre,x,y,scale,r,g,b,a)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    SetTextCentre(centre)
    DrawText(x , y)
end

function DrawText3d(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 20,20,20,150)
end

function vRPbf.DespawnVehicle(caissei)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local model = GetEntityModel(veh, false)
    local vehicle = GetDisplayNameFromVehicleModel(model)
    local plate = GetVehicleNumberPlateText(veh)
    if plate == "666CN666" then
        DetachEntity(caissei, 1, 1)
        DeleteEntity(caissei)
        DeleteObject(caissei)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for _, import in pairs(imports) do
            local player = GetPlayerPed(-1)
            if GetDistanceBetweenCoords(import.coords[1], import.coords[2], import.coords[3], GetEntityCoords(LocalPed())) < 7 then
                DrawMarker(27, import.coords[1], import.coords[2], import.coords[3],0,0,0,0,0,0,3.0001,3.0001,3.0001, 0, 232, 255,200,0,0,0,50)
            end
            if GetDistanceBetweenCoords(import.coords[1], import.coords[2], import.coords[3], GetEntityCoords(LocalPed())) < 2 then
                if IsPedInAnyVehicle(player, false) then
                    DrawText3d(import.coords[1], import.coords[2], import.coords[3] + 1, lang_string.menu1)
                    if IsControlJustPressed(1, 51) then
                        local caissei = GetVehiclePedIsUsing(GetPlayerPed(-1))
                        local ped = PlayerPedId()
                        local veh = GetVehiclePedIsIn(ped, false)
                        local model = GetEntityModel(veh, false)
                        local vehicle = GetDisplayNameFromVehicleModel(model)
                        local plate = GetVehicleNumberPlateText(veh)
                        if plate == "666CN666" then
                            for key, value in pairs(biler) do
                                if key == vehicle then
                                    TriggerServerEvent("bilforhandler:getvehicle", value)
                                    vRPbf.DespawnVehicle(caissei)
                                end

                                --print(key, "=", value)
                            end
                            TriggerServerEvent("bilforhandler:getvehicle", vehicle)
                            vRPbf.DespawnVehicle(caissei)
                        else
                            TriggerEvent("pNotify:SendNotification",{text = "Det er den forkerte bil",type = "info",timeout = (2000),layout = "bottomRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                        end
                    end
                else
                    DrawText3d(import.coords[1], import.coords[2], import.coords[3] + 1, lang_string.menu1)
                    if IsControlJustPressed(1, 51) then
                            delay = 6000
                    end
                    end
            end
        end

        for _, spawn in pairs(spawns) do
            local player = GetPlayerPed(-1)
            if GetDistanceBetweenCoords(spawn.coords[1], spawn.coords[2], spawn.coords[3], GetEntityCoords(LocalPed())) < 7 then
                DrawMarker(27, spawn.coords[1], spawn.coords[2], spawn.coords[3],0,0,0,0,0,0,3.0001,3.0001,3.0001, 0, 232, 255,200,0,0,0,50)
            end
            if GetDistanceBetweenCoords(spawn.coords[1], spawn.coords[2], spawn.coords[3], GetEntityCoords(LocalPed())) < 2 then
                if IsPedInAnyVehicle(player, false) then
                    DrawText3d(spawn.coords[1], spawn.coords[2], spawn.coords[3] + 1, lang_string.menu2)
                    if IsControlJustPressed(1, 51) then
                        TriggerEvent("pNotify:SendNotification",{text = "Gå ud af din bil",type = "info",timeout = (2000),layout = "bottomRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    end
                else
                    DrawText3d(spawn.coords[1], spawn.coords[2], spawn.coords[3] + 1, lang_string.menu2)
                    if IsControlJustPressed(1, 51) then
                        TriggerServerEvent("bilforhandler:spawnvehicle", player)
                    end
                end
            end
        end

    end
end)

RegisterNetEvent('bilforhandler:spawnvehicle')
AddEventHandler('bilforhandler:spawnvehicle',function(car)
    -- load vehicle model
    local mhash = GetHashKey(car)

    local i = 0
    while not HasModelLoaded(mhash) and i < 10000 do
        RequestModel(mhash)
        Citizen.Wait(10)
        i = i+1
    end

    -- spawn car
    if HasModelLoaded(mhash) then
        local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
        local nveh = CreateVehicle(mhash, x,y,z+0.5, GetEntityHeading(GetPlayerPed(-1)), true, false) -- added player heading
        SetVehicleOnGroundProperly(nveh)
        SetEntityInvincible(nveh,false)
        SetPedIntoVehicle(GetPlayerPed(-1),nveh,-1) -- put player inside
        SetVehicleNumberPlateText(nveh, "666CN666")
        SetEntityAsMissionEntity(nveh, true, true) -- set as mission entity

        Citizen.CreateThread(function()
            Citizen.Wait(1000)
            TriggerEvent("advancedFuel:setEssence", 50, GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))), GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1)))))
        end)

        SetModelAsNoLongerNeeded(mhash)
        TriggerEvent("pNotify:SendNotification",{
            text = "Køretøj spawned.",
            type = "success",
            timeout = (1000),
            layout = "centerLeft",
            queue = "global",
            animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},
            killer = true
        })
    end
end)


function Draw3DText(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local px, py, pz = table.unpack(GetGameplayCamCoords())

	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x, _y)
	local factor = (string.len(text)) / 370
	DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 20,20,20,150)
end

cords = {
	{-48.136604309082,-1074.3829345703,25.804383850098},--midtby
}


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local player = GetPlayerPed(-1)
		local coords = GetEntityCoords(PlayerPedId(),true)
		for k,v in pairs(cords) do
			local x,y,z = table.unpack(v)

			if (Vdist(coords["x"], coords["y"], coords["z"], x,y,z) < 4.2) then
				DrawMarker(27, x,y,z+0.03, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5001, 255, 25, 0, 200, 0, 0, 0, 50)
				Draw3DText(x,y,(z+1.03), "Tryk ~g~H~w~ for at spawne en bil")
				if IsControlJustPressed(0, 74) then
				--	print("test")
          TriggerServerEvent("bilforhandler:spawncarvehicle", player)

				end
			end
		end
	end
end)

RegisterNetEvent('bilforhandler:spawncarvehicle')
AddEventHandler('bilforhandler:spawncarvehicle',function(car)
    -- load vehicle model
    local mhash = GetHashKey(car)

    local i = 0
    while not HasModelLoaded(mhash) and i < 10000 do
        RequestModel(mhash)
        Citizen.Wait(10)
        i = i+1
    end

    -- spawn car
    if HasModelLoaded(mhash) then
        local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
        local nveh = CreateVehicle(mhash, x,y,z+0.5, GetEntityHeading(GetPlayerPed(-1)), true, false) -- added player heading
        SetVehicleOnGroundProperly(nveh)
        SetEntityInvincible(nveh,false)
        SetPedIntoVehicle(GetPlayerPed(-1),nveh,-1) -- put player inside
        SetVehicleNumberPlateText(nveh, "CN BILER")
        SetEntityAsMissionEntity(nveh, true, true) -- set as mission entity

        Citizen.CreateThread(function()
            Citizen.Wait(1000)
            TriggerEvent("advancedFuel:setEssence", 50, GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))), GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1)))))
        end)

        SetModelAsNoLongerNeeded(mhash)
        TriggerEvent("pNotify:SendNotification",{
            text = "Køretøj spawned.",
            type = "success",
            timeout = (1000),
            layout = "centerLeft",
            queue = "global",
            animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},
            killer = true
        })
    end
end)


RegisterCommand("bilinfo", function()
    TriggerEvent("bilforhandler:bilinfo")
end,false)

RegisterNetEvent('bilforhandler:bilinfo')
AddEventHandler('bilforhandler:bilinfo',function(car)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local model = GetEntityModel(veh, false)
    local vehicle = GetDisplayNameFromVehicleModel(model)
    TriggerEvent("pNotify:SendNotification",{text = vehicle,type = "info",timeout = (10000),layout = "bottomRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
end)
