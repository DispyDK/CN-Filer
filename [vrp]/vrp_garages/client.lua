--[[Proxy/Tunnel]]--

vRPgt = {}
Tunnel.bindInterface("vRP_garages",vRPgt)
Proxy.addInterface("vRP_garages",vRPgt)
vRP = Proxy.getInterface("vRP")
vRPsb = Proxy.getInterface("vrp_extended")

--[[Local/Global]]--

GVEHICLES = {}
local inrangeofgarage = false
local currentlocation = nil
local myplate = ""
local impounded = 0

local garages = {

 -- Garager
  {name="Garage", colour=3, id=357, marker=27, coords = {215.55436706543,-788.25372314453,29.872000732422}, hidden=false}, -- Centrum P-Plads
  {name="Garage", colour=3, id=357, marker=27, coords = {-334.685, 289.773, 84.905}, hidden=false}, -- Nordgaragen
  {name="Garage", colour=3, id=357, marker=27, coords = {126.434, 6610.04, 30.880}, hidden=false}, -- Paleto Bay P-Plads
  {name="Garage", colour=3, id=357, marker=27, coords = {-1692.0040283203,-938.9443359375,6.6783599853516}, hidden=false}, -- Strand P-Plads tæt på yachten
  {name="Garage", colour=3, id=357, marker=27, coords = {-2035.372, -470.555, 10.466}, hidden=false}, -- Strand P-Plads
  {name="Garage", colour=3, id=357, marker=27, coords = {-976.59875488281, -2702.88671875, 12.9}, hidden=false}, -- Lufthavn
  {name="Garage", colour=3, id=357, marker=27, coords = {291.60162353516,-336.40170288086,43.919876098633}, hidden=false}, -- Perker-garage
  {name="Garage", colour=3, id=357, marker=27, coords = {2054.6848144531,3179.9624023438,44.21898727417}, hidden=false}, --Ved siden af Yellow Jack
  {name="Garage", colour=3, id=357, marker=27, coords = {436.12869262695, -1021.3997192383, 27.8041456604}, hidden=true}, -- Garage PD
  {name="Garage", colour=3, id=357, marker=27, coords = {902.69830322266, -184.05155944824, 72.95}, hidden=true}, -- Taxa job
  {name="Garage", colour=3, id=357, marker=27, coords = {-576.91052246094, 5250.8061523438,  69.46715087891}, hidden=true}, -- Træhugger job
  {name="Garage", colour=3, id=357, marker=27, coords = {1862.4067382813, 2567.0131835938, 44.7}, hidden=true}, -- Fængsel
  {name="Garage", colour=3, id=357, marker=27, coords = {1866.0242919922, 3698.72265625,  32.68}, hidden=true}, -- PD i Sandy Shores
  {name="Garage", colour=3, id=357, marker=27, coords = {494.7096862793,-1966.8487548828,23.901721954346}, hidden=true},-- Minebilen
  {name="Garage", colour=3, id=357, marker=27, coords = {-1192.8804931641,-1490.8082275391,3.3796672821045}, hidden=false},-- Strand garage ved garagen
  {name="Garage", colour=3, id=357, marker=27, coords = {1547.1286621094,-2093.6647949219,76.256700134277}, hidden=true},--Skraldebil garage
  {name="Garage", colour=3, id=357, marker=27, coords = {-52.900573730469,-781.43963623047,44.236064910889}, hidden=true},-- Sikkerhedsvagt garage
  {name="Garage", colour=3, id=357, marker=27, coords = {1956.8421630859,3769.3901367188,32.203243255615,89.650514221191}, hidden=false},-- Tanken i Sandy
  {name="Garage", colour=3, id=357, marker=27, coords = {-103.9112,-607.6959, 35.0732}, hidden=true}, -- Ejendomsmælger
  {name="Garage", colour=3, id=357, marker=27, coords = {-335.58090209961,-757.57702636719,32.968517303467}}, -- Parkingshus
  
  -- Innovation auto
  {name="Garage", colour=3, id=357, marker=27, coords = {-180.00889587402,-1372.306640625,31.258615493774}, hidden=true}, -- Innovation auto
  {name="Garage", colour=3, id=357, marker=27, coords = {-187.30018615723,-1361.2644042969,31.258155822754}, hidden=true}, -- Innovation auto

  --Bilforhandler
  {name='Garage', colour=3, id=357, maker=37, coords = {-8.8112821578979,-1083.3936767578,26.681020736694}, hidden=true},

 -- Våbendealer / Drugdealer
  {name='Garage', colour=3, id=357, maker=37, coords = {-1909.703125,2046.2828369141,140.73764038086}, hidden=true}, -- Våbendealer garage hus
  {name="Garage", colour=3, id=357, marker=27, coords = {822.17193603516,-2143.9265136719,28.787622451782}, hidden=true}, -- Våbenbutik
  {name="Garage", colour=3, id=357, marker=27, coords = {891.583984375,-3238.5327148438,-99.283004760742}, hidden=true},-- Bunker garagae
  {name="Garage", colour=3, id=357, marker=27, coords = {3102.1782226563,-4734.2568359375,15.262621879578}, hidden=true},-- Drugdealer garage
  {name="Garage", colour=3, id=357, marker=27, coords = {-2326.9614257813,3252.7316894531,31.637629089355}, hidden=true}, -- Drugdealer garage 2
  {name="Garage", colour=3, id=357, marker=27, coords = {490.37786865234,-3353.2580566406,6.0699076652527}, hidden=true}, -- Drugdealer garage 3

}

local impound = {
  {name="Konfiskeret køretøjer", colour=47, id=524, marker=27, coords = {405.23922729492,-1643.7677001953,28.201948318481}, hidden=false},
}


vehicles = {}
garageSelected = {x=nil, y=nil, z=nil, h=nil}
selectedPage = 0

lang_string = {
  menu1 = "Tryk ~g~E~s~ for at parkere",
  menu2 = "Hent køretøj",
  menu3 = "Luk",
  menu4 = "Biler",
  menu5 = "Valgmuligheder",
  menu6 = "Hent",
  menu7 = "Tilbage",
  menu8 = "Tryk ~g~E~s~ for at åbne garagen",
  konfiskeret = "Tryk ~g~E~s~ for liste af konfiskeret køretøjer",
  menu9 = "Sælg",
  menu10 = "Tryk ~g~E~s~ for at sælge køretøjet",
  menu11 = "Opdater Garagen",
  menu12 = "Næste",
  menu13 = "Skift navn",
  daybournekek = "Du kan ikke bruge garagen når du er i koma",
  state1 = "Ude",
  state2 = "Inde",
  text1 = "Området er overfyldt",
  text2 = "Køretøjet er ikke parkeret",
  text3 = "Køretøjer er ude",
  text4 = "Dette er ikke dit køretøj",
  text5 = "Køretøj parkeret",
  text6 = "Intet køretøj i nærheden",
  text7 = "Køretøj solgt",
  text8 = "Køretøj købt, god tur",
  text9 = "Du har ikke råd",
  text10 = "Køretøj opdateret"
}
--[[Functions]]--

function vRPgt.spawnGarageVehicle(vtype, name, vehicle_plate, vehicle_colorprimary, vehicle_colorsecondary, vehicle_pearlescentcolor, vehicle_wheelcolor, vehicle_plateindex, vehicle_neoncolor1, vehicle_neoncolor2, vehicle_neoncolor3, vehicle_windowtint, vehicle_wheeltype, vehicle_mods0, vehicle_mods1, vehicle_mods2, vehicle_mods3, vehicle_mods4, vehicle_mods5, vehicle_mods6, vehicle_mods7, vehicle_mods8, vehicle_mods9, vehicle_mods10, vehicle_mods11, vehicle_mods12, vehicle_mods13, vehicle_mods14, vehicle_mods15, vehicle_mods16, vehicle_turbo, vehicle_tiresmoke, vehicle_xenon, vehicle_mods23, vehicle_mods24, vehicle_neon0, vehicle_neon1, vehicle_neon2, vehicle_neon3, vehicle_bulletproof, vehicle_smokecolor1, vehicle_smokecolor2, vehicle_smokecolor3, vehicle_modvariation, fuel, damage) -- vtype is the vehicle type (one vehicle per type allowed at the same time)
  myplate = vehicle_plate
  local vehicle = vehicles[vtype]
  if vehicle and not IsVehicleDriveable(vehicle[3]) then -- precheck if vehicle is undriveable
    -- despawn vehicle
    SetVehicleHasBeenOwnedByPlayer(vehicle[3],false)
    Citizen.InvokeNative(0xAD738C3085FE7E11, vehicle[3], false, true) -- set not as mission entity
    SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle[3]))
    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle[3]))


    TriggerEvent("vrp_garages:setVehicle", vtype, nil)
  end

  vehicle = vehicles[vtype]
  if vehicle == nil then
    -- load vehicle model
    local mhash = GetHashKey(name)
    TriggerServerEvent("vrp_extended:collectvehicles",mhash,name)
    local i = 0
    while not HasModelLoaded(mhash) do
      RequestModel(mhash)
      Citizen.Wait(10)
      -- i = i+1
    end

    -- spawn car
    if HasModelLoaded(mhash) then
      local x,y,z = vRP.getPosition({})
      -- FreezeEntityPosition(GetPlayerPed(-1),true)
      TriggerEvent("pNotify:SendNotification",{text = "Dit køretøj er ved at blive gjort klar",type = "info",timeout = (5000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
      Wait(5000)
      -- FreezeEntityPosition(GetPlayerPed(-1),false)

      local x2,y2,z2 = vRP.getPosition({})
      local dist = GetDistanceBetweenCoords(x,y,z,x2,y2,z2, true)
      if dist > 2 or IsPedBeingStunned(GetPlayerPed(-1)) or IsPedRagdoll(PlayerPedId()) then
        TriggerEvent("pNotify:SendNotification",{text = "Du gik for langt væk og køretøjet blev derfor i garagen",type = "info",timeout = (5000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        return
      end
      local nveh = CreateVehicle(mhash, x,y,z+0.5, GetEntityHeading(GetPlayerPed(-1)), true, false) -- added player heading
      SetVehicleOnGroundProperly(nveh)
      SetVehRadioStation(nveh, "OFF")
      SetEntityInvincible(nveh,false)
      SetPedIntoVehicle(GetPlayerPed(-1),nveh,-1) -- put player inside
      if vRPsb.getUser().job == "Våbendealer" then
        vRP.changeNummerPlate(5)
      else
        SetVehicleNumberPlateText(nveh, "P " .. vRP.getRegistrationNumber({}))
      end
      --Citizen.InvokeNative(0xAD738C3085FE7E11, nveh, true, true) -- set as mission entity
      SetVehicleHasBeenOwnedByPlayer(nveh,true)

      local nid = NetworkGetNetworkIdFromEntity(nveh)
      SetNetworkIdCanMigrate(nid,true)

      TriggerEvent("vrp_garages:setVehicle", vtype, {vtype,name,nveh})

      SetModelAsNoLongerNeeded(mhash)



      --grabbing customization
      local plate = plate
      local primarycolor = tonumber(vehicle_colorprimary)
      local secondarycolor = tonumber(vehicle_colorsecondary)
      local pearlescentcolor = vehicle_pearlescentcolor
      local wheelcolor = vehicle_wheelcolor
      local plateindex = tonumber(vehicle_plateindex)
      local neoncolor = {vehicle_neoncolor1,vehicle_neoncolor2,vehicle_neoncolor3}
      local windowtint = vehicle_windowtint
      local wheeltype = tonumber(vehicle_wheeltype)
      local mods0 = tonumber(vehicle_mods0)
      local mods1 = tonumber(vehicle_mods1)
      local mods2 = tonumber(vehicle_mods2)
      local mods3 = tonumber(vehicle_mods3)
      local mods4 = tonumber(vehicle_mods4)
      local mods5 = tonumber(vehicle_mods5)
      local mods6 = tonumber(vehicle_mods6)
      local mods7 = tonumber(vehicle_mods7)
      local mods8 = tonumber(vehicle_mods8)
      local mods9 = tonumber(vehicle_mods9)
      local mods10 = tonumber(vehicle_mods10)
      local mods11 = tonumber(vehicle_mods11)
      local mods12 = tonumber(vehicle_mods12)
      local mods13 = tonumber(vehicle_mods13)
      local mods14 = tonumber(vehicle_mods14)
      local mods15 = tonumber(vehicle_mods15)
      local mods16 = tonumber(vehicle_mods16)
      local turbo = vehicle_turbo
      local tiresmoke = vehicle_tiresmoke
      local xenon = vehicle_xenon
      local mods23 = tonumber(vehicle_mods23)
      local mods24 = tonumber(vehicle_mods24)
      local neon0 = vehicle_neon0
      local neon1 = vehicle_neon1
      local neon2 = vehicle_neon2
      local neon3 = vehicle_neon3
      local bulletproof = vehicle_bulletproof
      local smokecolor1 = vehicle_smokecolor1
      local smokecolor2 = vehicle_smokecolor2
      local smokecolor3 = vehicle_smokecolor3
      local variation = vehicle_modvariation

      local fuel = tonumber(fuel)
      local damage = tonumber(damage)

      --setting customization
      SetVehicleColours(nveh, primarycolor, secondarycolor)
      SetVehicleExtraColours(nveh, tonumber(pearlescentcolor), tonumber(wheelcolor))
      SetVehicleNumberPlateTextIndex(nveh,plateindex)
      SetVehicleNeonLightsColour(nveh,tonumber(neoncolor[1]),tonumber(neoncolor[2]),tonumber(neoncolor[3]))
      SetVehicleTyreSmokeColor(nveh,tonumber(smokecolor1),tonumber(smokecolor2),tonumber(smokecolor3))
      SetVehicleModKit(nveh,0)
      SetVehicleMod(nveh, 0, mods0)
      SetVehicleMod(nveh, 1, mods1)
      SetVehicleMod(nveh, 2, mods2)
      SetVehicleMod(nveh, 3, mods3)
      SetVehicleMod(nveh, 4, mods4)
      SetVehicleMod(nveh, 5, mods5)
      SetVehicleMod(nveh, 6, mods6)
      SetVehicleMod(nveh, 7, mods7)
      SetVehicleMod(nveh, 8, mods8)
      SetVehicleMod(nveh, 9, mods9)
      SetVehicleMod(nveh, 10, mods10)
      SetVehicleMod(nveh, 11, mods11)
      SetVehicleMod(nveh, 12, mods12)
      SetVehicleMod(nveh, 13, mods13)
      SetVehicleMod(nveh, 14, mods14)
      SetVehicleMod(nveh, 15, mods15)
      SetVehicleMod(nveh, 16, mods16)

      SetVehicleFuelLevel(nveh, fuel)
      SetVehicleEngineHealth(nveh, damage)

      if turbo == "on" then
        ToggleVehicleMod(nveh, 18, true)
      else
        ToggleVehicleMod(nveh, 18, false)
      end
      if tiresmoke == "on" then
        ToggleVehicleMod(nveh, 20, true)
      else
        ToggleVehicleMod(nveh, 20, false)
      end
      if xenon == "on" then
        ToggleVehicleMod(nveh, 22, true)
      else
        ToggleVehicleMod(nveh, 22, false)
      end
      SetVehicleWheelType(nveh, tonumber(wheeltype))
      SetVehicleMod(nveh, 23, mods23)
      SetVehicleMod(nveh, 24, mods24)
      if neon0 == "on" then
        SetVehicleNeonLightEnabled(nveh,0, true)
      else
        SetVehicleNeonLightEnabled(nveh,0, false)
      end
      if neon1 == "on" then
        SetVehicleNeonLightEnabled(nveh,1, true)
      else
        SetVehicleNeonLightEnabled(nveh,1, false)
      end
      if neon2 == "on" then
        SetVehicleNeonLightEnabled(nveh,2, true)
      else
        SetVehicleNeonLightEnabled(nveh,2, false)
      end
      if neon3 == "on" then
        SetVehicleNeonLightEnabled(nveh,3, true)
      else
        SetVehicleNeonLightEnabled(nveh,3, false)
      end
      if bulletproof == "on" then
        SetVehicleTyresCanBurst(nveh, false)
      else
        SetVehicleTyresCanBurst(nveh, true)
      end
      --if variation == "on" then
      --  SetVehicleModVariation(nveh,23)
      --else
      --  SetVehicleModVariation(nveh,23, false)
      --end
      SetVehicleWindowTint(nveh,tonumber(windowtint))

      local playerVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
      local VehicleModel = GetEntityModel(playerVeh)
      local model =  GetDisplayNameFromVehicleModel(VehicleModel)

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

      if (biler[model]) then
      	model = biler[model]
      end

      TriggerServerEvent("LSC:applyModifications",model,playerVeh)

      SetVehicleMod(nveh, 11, mods11)
      SetVehicleMod(nveh, 12, mods12)
      SetVehicleMod(nveh, 13, mods13)
      if turbo == "on" then
        ToggleVehicleMod(nveh, 18, true)
      else
        ToggleVehicleMod(nveh, 18, false)
      end


    end
  else
    local cartype = ""
    if vtype == "car" then
      cartype = "bil"
    elseif vtype == "bike" then
      cartype = "motorcykel"
    elseif vtype == "citybike" then
      cartype = "cykel"
    end
    TriggerEvent("pNotify:SendNotification",{text = "Du kan kun have én <b style='color:#B22222'>"..cartype.."</b> ude",type = "info",timeout = (2000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
  end
end

function vRPgt.spawnBoughtVehicle(vtype, name)
  local vehicle = vehicles[vtype]
  if vehicle then -- precheck if vehicle is undriveable
    -- despawn vehicle
    SetVehicleHasBeenOwnedByPlayer(vehicle[3],false)
    SetEntityAsMissionEntity(vehicle[3], false, true) -- set not as mission entity
    SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle[3]))
    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle[3]))
    TriggerEvent("vrp_garages:setVehicle", vtype, nil)
  end

  vehicle = vehicles[vtype]
  if vehicle == nil then
    -- load vehicle model
    local mhash = GetHashKey(name)

    local i = 0
    while not HasModelLoaded(mhash) and i < 10000 do
      RequestModel(mhash)
      Citizen.Wait(10)
      i = i+1
    end

    -- spawn car
    if HasModelLoaded(mhash) then
      local x,y,z = vRP.getPosition({})
      local nveh = CreateVehicle(mhash, x,y,z+0.5, GetEntityHeading(GetPlayerPed(-1)), true, false) -- added player heading
      SetVehicleOnGroundProperly(nveh)
      SetVehRadioStation(nveh, "OFF")
      SetEntityInvincible(nveh,false)
      SetPedIntoVehicle(GetPlayerPed(-1),nveh,-1) -- put player inside
      SetVehicleNumberPlateText(nveh, "P " .. vRP.getRegistrationNumber({}))
      Citizen.InvokeNative(0xAD738C3085FE7E11, nveh, true, true) -- set as mission entity
      SetVehicleHasBeenOwnedByPlayer(nveh,true)

      local nid = NetworkGetNetworkIdFromEntity(nveh)
      SetNetworkIdCanMigrate(nid,true)

      TriggerEvent("vrp_garages:setVehicle", vtype, {vtype,name,nveh})



      SetModelAsNoLongerNeeded(mhash)
    end
  else
    if vtype == "car" then
      local cartype = "bil"
    elseif vtype == "bike" then
      local cartype = "motorcykel"
    elseif vtype == "citybike" then
      local cartype = "cykel"
    end
    TriggerEvent("pNotify:SendNotification",{text = "Du kan kun have én <b style='color:#B22222'>"..cartype.."</b> ude",type = "info",timeout = (2000),layout = "bottomRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
  end
end

function vRPgt.despawnGarageVehicle(caissei)

  -- remove vehicle
  SetVehicleHasBeenOwnedByPlayer(caissei,false)
  Citizen.InvokeNative(0xAD738C3085FE7E11, caissei, false, true) -- set not as mission entity
  SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(caissei))
  Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(caissei))
  DetachEntity(caissei, 1, 1)
  DeleteEntity(caissei)
  DeleteObject(caissei)
  local vtype = "car"
  if IsThisModelABike(GetEntityModel(caissei)) and not IsThisModelABicycle(GetEntityModel(caissei)) then
    vtype = "bike"
  end
  if IsThisModelAQuadbike(GetEntityModel(caissei)) then
    vtype = "bike"
  end
  if IsThisModelABicycle(GetEntityModel(caissei)) then
    vtype = "citybike"
  end
  TriggerEvent("vrp_garages:setVehicle", vtype, nil)

  TriggerEvent("pNotify:SendNotification",{text = "Køretøj <b style='color:#4E9350'>parkeret</b>",type = "success",timeout = (3000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
end

function MenuGarage()
  ped = GetPlayerPed(-1)
  selectedPage = 0
  MenuTitle = "Garage"
  ClearMenu()
  Menu.addButton(lang_string.menu2,"ListVehicle",selectedPage)
  Menu.addButton(lang_string.menu3,"CloseMenu",nil)
  Menu.addButton(lang_string.menu11,"CloseMenu",nil)
end

function MenuImpoundGarage()
  ped = GetPlayerPed(-1)
  selectedPage = 0
  MenuTitle = "Konfiskeret"
  ClearMenu()
  Menu.addButton("Liste af køretøjer","ListImpoundedVehicle",selectedPage)
  Menu.addButton(lang_string.menu3,"CloseMenu",nil)
end

function StoreVehicle()
  Citizen.CreateThread(function()
    local caissei = GetVehiclePedIsUsing(GetPlayerPed(-1))
    SetEntityAsMissionEntity(caissei, true, true)
    local plate = GetVehicleNumberPlateText(caissei)
    local vtype = "car"
    if IsThisModelABike(GetEntityModel(caissei)) and not IsThisModelABicycle(GetEntityModel(caissei)) then
      vtype = "bike"
    end
    if IsThisModelAQuadbike(GetEntityModel(caissei)) then
      vtype = "bike"
    end
    if IsThisModelABicycle(GetEntityModel(caissei)) then
      vtype = "citybike"
    end
    if DoesEntityExist(caissei) then
      if plate:upper() == myplate:upper() or myplate == "" or vRPsb.getUser().job == "Våbendealer" then
        local fuel = GetVehicleFuelLevel(caissei)
        local damage = GetVehicleEngineHealth(caissei)
        local vehicle = vehicles[vtype]
        vRPgt.despawnGarageVehicle(caissei)
        if vehicle ~= nil then
          TriggerServerEvent("ply_garages:CheckForVeh", plate, vehicle[2],fuel,damage)
        end
      else
        TriggerEvent("pNotify:SendNotification",{text = "Du kan kun parkere dit eget køretøj!",type = "error",timeout = (2000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
      end
    else
      TriggerEvent("pNotify:SendNotification",{text = "Du skal sidde i køretøjet!",type = "error",timeout = (2000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
  end)
  CloseMenu()
end

function ListVehicle(page)
  ped = GetPlayerPed(-1)
  selectedPage = page
  MenuTitle = lang_string.menu4
  ClearMenu()
  local count = 0
  for ind, value in pairs(GVEHICLES) do
    if ((count >= (page*10)) and (count < ((page*10)+10))) then
      if value.vehicle_impound == 0 then
        Menu.addButton(firstToUpper(tostring(value.vehicle_name)), "OptionVehicle", tostring(value.vehicle_model))
      end
    end
    count = count + 1
  end
  Menu.addButton(lang_string.menu12,"ListVehicle",page+1)
  if page == 0 then
    Menu.addButton(lang_string.menu7,"MenuGarage",nil)
  else
    Menu.addButton(lang_string.menu7,"ListVehicle",page-1)
  end
end

function ListImpoundedVehicle(page)
  ped = GetPlayerPed(-1)
  selectedPage = page
  MenuTitle = lang_string.menu4
  ClearMenu()
  local count = 0
  for ind, value in pairs(GVEHICLES) do
    if ((count >= (page*10)) and (count < ((page*10)+10))) then
      if value.vehicle_impound == 1 then
        Menu.addButton(firstToUpper(tostring(value.vehicle_model)), "OptionImpoundVehicle", {vehid=tostring(value.vehicle_model),reason=tostring(value.vehicle_impound_reason)})
      end
    end
    count = count + 1
  end
  Menu.addButton(lang_string.menu12,"ListImpoundedVehicle",page+1)
  if page == 0 then
    Menu.addButton(lang_string.menu7,"MenuImpoundGarage",nil)
  else
    Menu.addButton(lang_string.menu7,"ListImpoundedVehicle",page-1)
  end
end

function OptionVehicle(vehID)
  local vehID = vehID
  MenuTitle = "Valg"
  ClearMenu()
  Menu.addButton(lang_string.menu6, "SpawnVehicle", vehID)
  Menu.addButton(lang_string.menu13, "ChangeName", vehID)
  Menu.addButton(lang_string.menu7, "ListVehicle", selectedPage)
end

local impoundreason = ""
function OptionImpoundVehicle(data)
  MenuTitle = "KØB "..data.vehid.." FRI"
  impoundreason = data.reason
  ClearMenu()
  Menu.addButton("Betal "..format_thousand(cfggarage.PayFreePrice), "PayVehicle", data.vehid)
  Menu.addButton("Annuller", "ListImpoundedVehicle", selectedPage)
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    if Menu.hidden == false and impoundreason ~= "" then
      DrawRect(0.5, 0.94, 0.3, 0.10, 0,0,0,200)
      ply_drawTxt("Beslaglag årsag:",4,1,0.5,0.896,0.6,255,255,255,255)
      ply_drawTxt(impoundreason,4,1,0.5,0.94,0.5,255,255,255,255)
    else
      if impoundreason ~= "" then
        impoundreason=""
      end
    end
  end
end)


function PayVehicle(vehID)
  TriggerServerEvent('ply_garages:impoundvehfree', vehID)
  CloseMenu()
end

function SpawnVehicle(vehID)
  TriggerServerEvent('ply_garages:CheckForSpawnVeh', vehID)
  CloseMenu()
end

function ChangeName(vehID)
  TriggerServerEvent('ply_garages:ChangeSpawnVeh', vehID)
  CloseMenu()
end

function drawNotification(text)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(text)
  DrawNotification(false, false)
end

function CloseMenu()
  Menu.hidden = true
end

function LocalPed()
  return GetPlayerPed(-1)
end

function IsPlayerInRangeOfGarage()
  return inrangeofgarage
end

function Chat(debugg)
  TriggerEvent('chatMessage', '', { 0, 0x99, 255 }, tostring(debugg))
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

--[[Citizen]]--
local delay = 0
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if delay > 0 then delay = delay-1 end
    local player = GetPlayerPed(-1)
    local isInVeh = IsPedInAnyVehicle(player, false)
    local entityCoords = GetEntityCoords(player)
    for _, garage in pairs(garages) do
      if GetDistanceBetweenCoords(garage.coords[1], garage.coords[2], garage.coords[3], entityCoords) < 7 then
        DrawMarker(27, garage.coords[1], garage.coords[2], garage.coords[3],0,0,0,0,0,0,3.0001,3.0001,3.0001, 0, 232, 255,200,0,0,0,50)
      end
      if GetDistanceBetweenCoords(garage.coords[1], garage.coords[2], garage.coords[3], entityCoords) < 2 then

          if isInVeh then
            DrawText3d(garage.coords[1], garage.coords[2], garage.coords[3] + 1, lang_string.menu1)
            if IsControlJustPressed(1, 51) then
              StoreVehicle()
            end
          else
            DrawText3d(garage.coords[1], garage.coords[2], garage.coords[3] + 1, lang_string.menu8)
            if IsControlJustPressed(1, 51) then
              garageSelected.x = garage.coords[1]
              garageSelected.y = garage.coords[2]
              garageSelected.z = garage.coords[3]
              MenuGarage()
              Menu.hidden = not Menu.hidden
              if delay == 0 then
                delay = 6000
                TriggerServerEvent("ply_garages:CheckGarageForVeh")
              end
            end
          end
          Menu.renderGUI()

      end
    end

    if IsControlJustPressed(1, 177) then
      CloseMenu()
    end

    for _, impound in pairs(impound) do
      if GetDistanceBetweenCoords(impound.coords[1], impound.coords[2], impound.coords[3], entityCoords) < 7 then
        DrawMarker(27, impound.coords[1], impound.coords[2], impound.coords[3],0,0,0,0,0,0,3.0001,3.0001,3.0001, 0, 232, 255,200,0,0,0,50)
      end
      if GetDistanceBetweenCoords(impound.coords[1], impound.coords[2], impound.coords[3], entityCoords) < 2 then
          if IsPedInAnyVehicle(player, false) then
            DrawText3d(impound.coords[1], impound.coords[2], impound.coords[3] + 1, lang_string.menu1)
            if IsControlJustPressed(1, 51) then
              StoreVehicle()
            end
          else
            DrawText3d(impound.coords[1], impound.coords[2], impound.coords[3] + 1, lang_string.konfiskeret)
            if IsControlJustPressed(1, 51) then
              garageSelected.x = impound.coords[1]
              garageSelected.y = impound.coords[2]
              garageSelected.z = impound.coords[3]
              MenuImpoundGarage()
              Menu.hidden = not Menu.hidden
              if delay == 0 then
                delay = 6000
                TriggerServerEvent("ply_garages:CheckGarageForVeh")
              end
            end
          end
          Menu.renderGUI()
      end
    end
  end
end)

Citizen.CreateThread(function()
for _, item in pairs(garages) do
  if not item.hidden then
    item.blip = AddBlipForCoord(item.coords[1], item.coords[2], item.coords[3])
    SetBlipSprite(item.blip, item.id)
    SetBlipAsShortRange(item.blip, true)
    SetBlipColour(item.blip, item.colour)
    SetBlipScale(item.blip, 0.8)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(item.name)
    EndTextCommandSetBlipName(item.blip)
  end
end
for _, item in pairs(impound) do
  if not item.hidden then
    item.blip = AddBlipForCoord(item.coords[1], item.coords[2], item.coords[3])
    SetBlipSprite(item.blip, item.id)
    SetBlipAsShortRange(item.blip, true)
    SetBlipColour(item.blip, item.colour)
    SetBlipScale(item.blip, 0.8)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(item.name)
    EndTextCommandSetBlipName(item.blip)
  end
end
  while true do
    local near = false
    Citizen.Wait(0)

    local player = GetPlayerPed(-1)
    local isInVeh = IsPedInAnyVehicle(player, false)
    local entityCoords = GetEntityCoords(player)

    for _, garage in pairs(garages) do
      if (GetDistanceBetweenCoords(garage.coords[1], garage.coords[2], garage.coords[3], entityCoords) < 3 and near ~= true) then
        near = true
      end
    end
    for _, impound in pairs(impound) do
      if (GetDistanceBetweenCoords(impound.coords[1], impound.coords[2], impound.coords[3], entityCoords) < 3 and near ~= true) then
        near = true
      end
    end
    if near == false then
      Menu.hidden = true
    end
  end
end)




--[[Events]]--

RegisterNetEvent('vrp_garages:setVehicle')
AddEventHandler('vrp_garages:setVehicle', function(vtype, vehicle)
  vehicles[vtype] = vehicle
end)

RegisterNetEvent('ply_garages:addAptGarage')
AddEventHandler('ply_garages:addAptGarage', function(gx,gy,gz,gh)
  local alreadyExists = false
  for _, garage in pairs(garages) do
    if garage.coords[1] == gx and garage.coords[2] == gy then
      alreadyExists = true
    end
  end
  if not alreadyExists then
    table.insert(garages, #garages + 1, {name="Lejligheds garage", colour=3, id=357, x=gx, y=gy, z=gz, h=gh})
  end
end)

RegisterNetEvent('ply_garages:getVehicles')
AddEventHandler("ply_garages:getVehicles", function(THEVEHICLES)
  impounded = 0
  for k,v in pairs(THEVEHICLES) do
    if v.vehicle_impound == 1 then
      impounded = impounded+1
    end
  end
  Menu.updateImpounded(impounded)
  GVEHICLES = {}
  GVEHICLES = THEVEHICLES
end)


function vRPgt.reOwnVehicle(vtype, name, plate, veh)
  myplate = plate
  local vehicle = vehicles[vtype]


  vehicle = vehicles[vtype]
    -- load vehicle model
    local mhash = GetHashKey(name)

      local nveh = veh
      SetVehRadioStation(nveh, "OFF")
      SetEntityInvincible(nveh,false)

      SetVehicleHasBeenOwnedByPlayer(nveh,true)

      local nid = NetworkGetNetworkIdFromEntity(nveh)
      SetNetworkIdCanMigrate(nid,true)

      TriggerEvent("vrp_garages:setVehicle", vtype, {vtype,name,nveh})

      SetModelAsNoLongerNeeded(mhash)


end


--Få nøgler tilbage
RegisterNetEvent('ply_garages:getKeys')
AddEventHandler('ply_garages:getKeys', function(plate)
  local veh = getNearestVehicle(5)
  plate2 = GetVehicleNumberPlateText(veh)
  model = GetEntityModel(veh, false)
  name = GetDisplayNameFromVehicleModel(model)
  vtype = "default"
  if (plate == plate2) then
    vehicles[vtype] = name
    local mhash = veh
    vRPgt.reOwnVehicle(vtype, name, plate, veh)
  end
end)

function getNearestVehicle(radius)

  local x,y,z = vRP.getPosition({})
  local ped = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ped) then
    return GetVehiclePedIsIn(ped, true)
  else
    local veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, radius+0.0001, 0, 8192+4096+4+2+1)  -- boats, helicos
    if not IsEntityAVehicle(veh) then veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, radius+0.0001, 0, 4+2+1) end -- cars
    return veh
  end
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

function firstToUpper(str)
  return (str:gsub("^%l", string.upper))
end

function format_thousand(v)
  local s = string.format("%d", math.floor(v))
  local pos = string.len(s) % 3
  if pos == 0 then pos = 3 end
  return string.sub(s, 1, pos)
          .. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end
