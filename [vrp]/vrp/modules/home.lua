
-- this module describe the home system (experimental, a lot can happen and not being handled)

local lang = vRP.lang
local cfg = module("cfg/homes")

-- sql


-- init
MySQL.ready(function ()
  MySQL.Async.execute([[
  CREATE TABLE IF NOT EXISTS vrp_user_homes(
    user_id INTEGER,
    home VARCHAR(255),
    number INTEGER,
    CONSTRAINT pk_user_homes PRIMARY KEY(user_id),
    CONSTRAINT fk_user_homes_users FOREIGN KEY(user_id) REFERENCES vrp_users(id) ON DELETE CASCADE,
    UNIQUE(home,number)
  );
  ]])
end)

-- api
local components = {}

-- CACHE
local userhomes = {}
local keyhomes = cfg.keyhomes

-- cbreturn user address (home and number) or nil
function vRP.getKeyHomes()
  return keyhomes
end

--[[AddEventHandler('onResourceStart', function(name)
  if name:lower() == GetCurrentResourceName():lower() then
    MySQL.query("vRP/get_all_owned_address", {}, function(rows,affected)
      if #rows > 0 then
        for k,v in pairs(rows) do
          for k2,v2 in pairs(v) do
            if k2 == "user_id" then
              print(v2.." er sat til")
              userhomes[v2] = v
            end
          end
        end
      end
    end)
  end
end)]]

local choice_sellhouse = {function(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    local usrList = ""
    vRPclient.getNearestPlayers(player,{5},function(nplayer)
      for k,v in pairs(nplayer) do
        usrList = usrList .. " | " .. "[" .. vRP.getUserId(k) .. "]" .. GetPlayerName(k)
      end
      if usrList ~= "" then
        vRP.prompt(player,"Nærmeste spiller(e): " .. usrList .. "","",function(player,nuser_id)
          if nuser_id ~= nil and nuser_id ~= "" then
            local target = vRP.getUserSource(tonumber(nuser_id))
            if target ~= nil then
              vRP.prompt(player,"Hvad hus ønsker du og sælge?","",function(player,house)
                if keyhomes[house] ~= nil then
                  vRP.prompt(player,"Hvad hus nummer?","",function(player,number)
                    number = parseInt(number)
                    if number > 0 then
                      if keyhomes[house][number] ~= nil then
                        MySQL.Async.fetchAll("SELECT * FROM vrp_user_homes WHERE home = @home and number = @number", {home=house,number=number}, function(rows, affected)
                          if #rows > 0 then
                            TriggerClientEvent("pNotify:SendNotification", player,{text = {"<b style='color: #DB4646'>"..house.." nr. "..number.."</b> er allerede købt af en anden"}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                          else
                            vRP.prompt(player,"Pris?","",function(player,price)
                              price = parseInt(price)
                              if price > 0 then
                                TriggerClientEvent("pNotify:SendNotification", player,{text = {"Afventer svar fra <b style='color: #4E9350'>"..nuser_id.."</b>"}, type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                vRP.request(target,"Bekræft køb af "..house.." nr. "..number.." for: "..format_thousands(price), 60, function(v,ok)
                                  if ok then -- take the call
                                    if vRP.tryFullPayment(tonumber(nuser_id),tonumber(price)) then
                                      vRP.getUserIdentity(tonumber(nuser_id), function(identity)
                                        local pp = math.floor(tonumber(price)/100*10)
                                        vRP.giveBankMoney(user_id,tonumber(pp))
                                        vRP.setUserAddress(nuser_id,house,number)
                                        TriggerClientEvent("pNotify:SendNotification", player,{text = {"<b style='color: #4E9350'>"..identity.firstname.." "..identity.name.."</b> har modtaget <b style='color: #4E9350'>"..house.."</b> for "..format_thousands(tonumber(price)).." DKK<br>Du modtog <b style='color: #4E9350'>"..format_thousands(tonumber(pp)).."</b> for handlen!"}, type = "success", queue = "global", timeout = 5000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                      end)
                                      local message = "**"..user_id.."** solgte **"..house.." nr. "..number.."** til **"..nuser_id.."** for **"..format_thousands(tonumber(price)).." DKK**"
                                      PerformHttpRequest('https://autisthook.com/api/webhooks/597829659413053482/7RbTQiIfEPb3F3lDBmDPAij8uZXz7kS4mtqTvSX4yOKKwqxkSClAA8Vtxp_A0wJj0Nud', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0") .." - Ejendomsmægler", content = message}), { ['Content-Type'] = 'application/json' })
                                      TriggerClientEvent("pNotify:SendNotification", target,{text = {"Tillykke med dit nye hus <b style='color: #4E9350'>"..house.." nr. "..number.."</b>!"}, type = "warning", queue = "global", timeout = 5000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                    else
                                      TriggerClientEvent("pNotify:SendNotification", player,{text = {"Personen har ikke nok penge"}, type = "warning", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                    end
                                  else
                                    TriggerClientEvent("pNotify:SendNotification", player,{text = {"<b style='color: #DB4646'>"..nuser_id.."</b> afslå købet af "..house.." nr."..number}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                  end
                                end)
                              else
                                TriggerClientEvent("pNotify:SendNotification", player,{text = {"Ugyldigt nummer"}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                              end
                            end)
                          end
                        end)
                      else
                        TriggerClientEvent("pNotify:SendNotification", player,{text = {"<b style='color: #DB4646'>"..number.."</b> findes ikke i <b style='color: #DB4646'>"..house.."</b>"}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                      end
                    else
                      TriggerClientEvent("pNotify:SendNotification", player,{text = {"Ugyldigt nummer"}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    end
                  end)
                else
                  TriggerClientEvent("pNotify:SendNotification", player,{text = {"<b style='color: #DB4646'>"..house.."</b> findes ikke"}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                end
              end)
            else
              TriggerClientEvent("pNotify:SendNotification", player,{text = {"Dette ID ser ud til ikke at eksistere"}, type = "warning", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
          else
            TriggerClientEvent("pNotify:SendNotification", player,{text = {"Intet ID valgt"}, type = "warning", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
          end
        end)
      else
        TriggerClientEvent("pNotify:SendNotification", player,{text = {"Ingen spiller i nærheden"}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
      end
    end)
  end
end, "Sælg hus til en af de nærmeste personer"}

vRP.registerMenuBuilder("main", function(add, data)
  local player = data.player

  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    local choices = {}
    if vRP.hasPermission(user_id,"realestate.onduty") then
      choices["Ejendomsmægler"] = {function(player,choice)
        vRP.buildMenu("realestate", {player = player}, function(menu)
          menu.name = "Ejendomsmægler"
          menu.css = {top="75px",header_color="rgba(255, 113, 0,0.75)" }

          menu["Sælg hus"] = choice_sellhouse

          vRP.openMenu(player,menu)
        end)
      end}
    end

    add(choices)
  end
end)

function vRP.getUserAddress(user_id, cbr)
  local task = Task(cbr)
  if userhomes[user_id] ~= nil then
    task({userhomes[user_id]})
    if keyhomes[userhomes[user_id].home] ~= nil then
      if keyhomes[userhomes[user_id].home][userhomes[user_id].number] ~= nil then
        local player = vRP.getUserSource(user_id)
      --  vRP.addComps("chest",user_id,keyhomes[userhomes[user_id].home].stype..userhomes[user_id].number,1,0,keyhomes[userhomes[user_id].home],keyhomes[userhomes[user_id].home][userhomes[user_id].number].chest[1],keyhomes[userhomes[user_id].home][userhomes[user_id].number].chest[2],keyhomes[userhomes[user_id].home][userhomes[user_id].number].chest[3],player,false)
        vRP.addComps("wardrobe",user_id,keyhomes[userhomes[user_id].home].stype..userhomes[user_id].number,1,0,keyhomes[userhomes[user_id].home],keyhomes[userhomes[user_id].home][userhomes[user_id].number].wardrobe[1],keyhomes[userhomes[user_id].home][userhomes[user_id].number].wardrobe[2],keyhomes[userhomes[user_id].home][userhomes[user_id].number].wardrobe[3],player,false)
        TriggerEvent('vrp_doors:owneddoor',user_id,userhomes[user_id].home,userhomes[user_id].number,true)
      end
    end
  else
    MySQL.Async.fetchAll("SELECT home, number FROM vrp_user_homes WHERE user_id = @user_id", {user_id = user_id}, function(rows,affected)
      if #rows > 0 then
        if keyhomes[rows[1].home] ~= nil then
          if keyhomes[rows[1].home][rows[1].number] ~= nil then
            local player = vRP.getUserSource(user_id)
          --  vRP.addComps("chest",user_id,keyhomes[rows[1].home].stype..rows[1].number,1,0,keyhomes[rows[1].home],keyhomes[rows[1].home][rows[1].number].chest[1],keyhomes[rows[1].home][rows[1].number].chest[2],keyhomes[rows[1].home][rows[1].number].chest[3],player,false)
            vRP.addComps("wardrobe",user_id,keyhomes[rows[1].home].stype..rows[1].number,1,0,keyhomes[rows[1].home],keyhomes[rows[1].home][rows[1].number].wardrobe[1],keyhomes[rows[1].home][rows[1].number].wardrobe[2],keyhomes[rows[1].home][rows[1].number].wardrobe[3],player,false)
            TriggerEvent('vrp_doors:owneddoor',user_id,rows[1].home,rows[1].number,true)
          end
        end
        userhomes[user_id] = rows[1]
        task({userhomes[user_id]})
      else
        task()
      end
    end)
  end
end

-- set user address
function vRP.setUserAddress(user_id,home,number)
  MySQL.Async.execute("REPLACE INTO vrp_user_homes(user_id,home,number) VALUES(@user_id,@home,@number)", {user_id = user_id, home = home, number = number})
  user_id = tonumber(user_id)
  if userhomes[user_id].home ~= nil and keyhomes[userhomes[user_id].home] ~= nil then
    if keyhomes[userhomes[user_id].home][userhomes[user_id].number] ~= nil then
      local player = vRP.getUserSource(user_id)
      --vRP.delComps("chest",user_id,keyhomes[userhomes[user_id].home].stype..userhomes[user_id].number,1,0,keyhomes[userhomes[user_id].home],keyhomes[userhomes[user_id].home][userhomes[user_id].number].chest[1],keyhomes[userhomes[user_id].home][userhomes[user_id].number].chest[2],keyhomes[userhomes[user_id].home][userhomes[user_id].number].chest[3],player,false)
      vRP.delComps("wardrobe",user_id,keyhomes[userhomes[user_id].home].stype..userhomes[user_id].number,1,0,keyhomes[userhomes[user_id].home],keyhomes[userhomes[user_id].home][userhomes[user_id].number].wardrobe[1],keyhomes[userhomes[user_id].home][userhomes[user_id].number].wardrobe[2],keyhomes[userhomes[user_id].home][userhomes[user_id].number].wardrobe[3],player,false)
      TriggerEvent('vrp_doors:owneddoor',user_id,userhomes[user_id].home,userhomes[user_id].number,false)
    end
  end
  userhomes[user_id] = {user_id = user_id, home = home, number = number}
  if keyhomes[home] ~= nil then
    if keyhomes[home][number] ~= nil then
      local player = vRP.getUserSource(user_id)
    --  vRP.addComps("chest",user_id,keyhomes[home].stype..number,1,0,keyhomes[home],keyhomes[home][number].chest[1],keyhomes[home][number].chest[2],keyhomes[home][number].chest[3],player,false)
      vRP.addComps("wardrobe",user_id,keyhomes[home].stype..number,1,0,keyhomes[home],keyhomes[home][number].wardrobe[1],keyhomes[home][number].wardrobe[2],keyhomes[home][number].wardrobe[3],player,false)
      TriggerEvent('vrp_doors:owneddoor',user_id,home,number,true)
    end
  end
end

-- remove user address
function vRP.removeUserAddress(user_id)
  MySQL.Async.execute("DELETE FROM vrp_user_homes WHERE user_id = @user_id", {user_id = user_id})
  if keyhomes[userhomes[user_id].home] ~= nil then
    if keyhomes[userhomes[user_id].home][userhomes[user_id].number] ~= nil then
      local player = vRP.getUserSource(user_id)
    --  vRP.delComps("chest",user_id,keyhomes[userhomes[user_id].home].stype..userhomes[user_id].number,1,0,keyhomes[userhomes[user_id].home],keyhomes[userhomes[user_id].home][userhomes[user_id].number].chest[1],keyhomes[userhomes[user_id].home][userhomes[user_id].number].chest[2],keyhomes[userhomes[user_id].home][userhomes[user_id].number].chest[3],player,false)
      vRP.delComps("wardrobe",user_id,keyhomes[userhomes[user_id].home].stype..userhomes[user_id].number,1,0,keyhomes[userhomes[user_id].home],keyhomes[userhomes[user_id].home][userhomes[user_id].number].wardrobe[1],keyhomes[userhomes[user_id].home][userhomes[user_id].number].wardrobe[2],keyhomes[userhomes[user_id].home][userhomes[user_id].number].wardrobe[3],player,false)
      TriggerEvent('vrp_doors:owneddoor',user_id,userhomes[user_id].home,userhomes[user_id].number,false)
    end
  end
  userhomes[user_id] = nil
end

-- cbreturn user_id or nil
function vRP.getUserByAddress(home,number,cbr)
  local task = Task(cbr)

  MySQL.Async.fetchAll("SELECT user_id FROM vrp_user_homes WHERE home = @home AND number = @number", {home = home, number = number}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].user_id})
    else
      task()
    end
  end)
end

-- find a free address number to buy
-- cbreturn number or nil if no numbers availables
function vRP.findFreeNumber(home,max,cbr)
  local task = Task(cbr)

  local i = 1
  local function search()
    vRP.getUserByAddress(home,i,function(user_id)
      if user_id == nil then -- found
        task({i})
      else -- not found
        i = i+1
        if i <= max then -- continue search
          search()
        else -- global not found
          task()
        end
      end
    end)
  end

  search()
end

-- define home component
-- name: unique component id
-- oncreate(owner_id, slot_type, slot_id, cid, config, x, y, z, player)
-- ondestroy(owner_id, slot_type, slot_id, cid, config, x, y, z, player)
function vRP.defHomeComponent(name, oncreate, ondestroy)
  components[name] = {oncreate,ondestroy}
end

-- SLOTS

-- used (or not) slots
local uslots = {}
for k,v in pairs(cfg.slot_types) do
  uslots[k] = {}
  for l,w in pairs(v) do
    uslots[k][l] = {used=false}
  end
end

-- return slot id or nil if no slot available
local function allocateSlot(stype)
  local slots = cfg.slot_types[stype]
  if slots then
    local _uslots = uslots[stype]
    -- search the first unused slot
    for k,v in pairs(slots) do
      if _uslots[k] and not _uslots[k].used then
        _uslots[k].used = true -- set as used
        return k  -- return slot id
      end
    end
  end

  return nil
end

-- free a slot
local function freeSlot(stype, id)
  local slots = cfg.slot_types[stype]
  if slots then
    uslots[stype][id] = {used = false} -- reset as unused
  end
end

-- get in use address slot (not very optimized yet)
-- return slot_type, slot_id or nil,nil
local function getAddressSlot(home_name,number)
  for k,v in pairs(uslots) do
    for l,w in pairs(v) do
      if w.home_name == home_name and tostring(w.home_number) == tostring(number) then
        return k,l
      end
    end
  end

  return nil,nil
end

-- builds

local function is_empty(table)
  for k,v in pairs(table) do
    return false
  end

  return true
end

-- leave slot
local function leave_slot(user_id,player,stype,sid) -- called when a player leave a slot
  --print(user_id.." forlod "..stype.." "..sid)
  local slot = uslots[stype][sid]
  local home = cfg.homes[slot.home_name]

  -- record if inside a home slot
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    tmp.home_stype = nil
    tmp.home_sid = nil
  end

  -- teleport to home entry point (outside)
  vRPclient.teleport(player, home.entry_point) -- already an array of params (x,y,z)

  -- uncount player
  slot.players[user_id] = nil

  -- destroy loaded components and special entry component
  for k,v in pairs(cfg.slot_types[stype][sid]) do
    local name,x,y,z = table.unpack(v)

    if name == "entry" then
      -- remove marker/area
      local nid = "vRP:home:slot"..stype..sid
      vRPclient.removeNamedMarker(player,{nid})
      vRP.removeArea(player,nid)
    else
      local component = components[v[1]]
      if component then
        -- ondestroy(owner_id, slot_type, slot_id, cid, config, x, y, z, player)
        component[2](slot.owner_id, stype, sid, k, v._config or {}, x, y, z, player)
      end
    end
  end

  if is_empty(slot.players) then -- free the slot
    --print("free slot "..stype.." "..sid)
    freeSlot(stype,sid)
  end
end

-- enter slot
local function enter_slot(user_id,player,stype,sid) -- called when a player enter a slot
  --print(user_id.." enter slot "..stype.." "..sid)
  local slot = uslots[stype][sid]
  local home = cfg.homes[slot.home_name]

  -- record inside a home slot
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    tmp.home_stype = stype
    tmp.home_sid = sid
  end

  -- count
  slot.players[user_id] = player

  -- build the slot entry menu
  local menu = {name=slot.home_name,css={top="75px",header_color="rgba(0,255,125,0.75)"}}
  menu[lang.home.slot.leave.title()] = {function(player,choice) -- add leave choice
    leave_slot(user_id,player,stype,sid)
  end}

  vRP.getUserAddress(user_id, function(address)
    -- check if owner
    if address ~= nil and address.home == slot.home_name and tostring(address.number) == slot.home_number then
      menu[lang.home.slot.ejectall.title()] = {function(player,choice) -- add eject all choice
        -- copy players before calling leave for each (iteration while removing)
        local copy = {}
        for k,v in pairs(slot.players) do
          copy[k] = v
        end

        for k,v in pairs(copy) do
          leave_slot(k,v,stype,sid)
        end
      end,lang.home.slot.ejectall.description()}
    end

    -- build the slot entry menu marker/area

    local function entry_enter(player,area)
      vRP.openMenu(player,menu)
    end

    local function entry_leave(player,area)
      vRP.closeMenu(player)
    end

    -- build components and special entry component
    for k,v in pairs(cfg.slot_types[stype][sid]) do
      local name,x,y,z = table.unpack(v)

      if name == "entry" then
        -- teleport to the slot entry point
        vRPclient.teleport(player, {x,y,z}) -- already an array of params (x,y,z)

        local nid = "vRP:home:slot"..stype..sid
        vRPclient.setNamedMarker(player,{nid,x,y,z-0.87,0.7,0.7,0.5,0,255,125,125,150})
        vRP.setArea(player,nid,x,y,z,1,1.5,entry_enter,entry_leave)
      else -- load regular component
        local component = components[v[1]]
        if component then
          -- oncreate(owner_id, slot_type, slot_id, cid, config, x, y, z, player)
          component[1](slot.owner_id, stype, sid, k, v._config or {}, x, y, z, player)
        end
      end
    end
  end)
end

-- access a home by address
-- cbreturn true on success
function vRP.accessHome(user_id, home, number, cbr)
  local task = Task(cbr)

  local _home = cfg.homes[home]
  local stype,slotid = getAddressSlot(home,number) -- get current address slot
  local player = vRP.getUserSource(user_id)

  vRP.getUserByAddress(home,number, function(owner_id)
    if _home ~= nil and player ~= nil then
      if stype == nil then -- allocate a new slot
        stype = _home.slot
        slotid = allocateSlot(_home.slot)

        if slotid ~= nil then -- allocated, set slot home infos
          local slot = uslots[stype][slotid]
          slot.home_name = home
          slot.home_number = number
          slot.owner_id = owner_id
          slot.players = {} -- map user_id => player
        end
      end

      if slotid ~= nil then -- slot available
        enter_slot(user_id,player,stype,slotid)
        task({true})
      end
    end
  end)
end

-- build the home entry menu
local function build_entry_menu(user_id, home_name)
  local home = cfg.homes[home_name]
  local menu = {name=home_name,css={top="75px",header_color="rgba(0,255,125,0.75)"}}

  -- intercom, used to enter in a home
  menu[lang.home.intercom.title()] = {function(player,choice)
    vRP.prompt(player, lang.home.intercom.prompt(), "", function(player,number)
      number = parseInt(number)
      vRP.getUserByAddress(home_name,number,function(huser_id)
        if huser_id ~= nil then
          if huser_id == user_id then
            vRP.accessHome(user_id, home_name, number, function(ok)
              if not ok then
                TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.home.intercom.not_available()}, type = "info", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
              end
            end)
          else
            local hplayer = vRP.getUserSource(huser_id)
            if hplayer ~= nil then
              vRP.prompt(player,lang.home.intercom.prompt_who(),"",function(player,who)
                TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.home.intercom.asked()}, type = "info", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
                vRP.request(hplayer, lang.home.intercom.request({who}), 30, function(hplayer,ok)
                  if ok then
                    vRP.accessHome(user_id, home_name, number)
                  else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.home.intercom.refused()}, type = "info", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                  end
                end)
              end)
            else
              TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.home.intercom.refused()}, type = "info", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
          end
        else
          TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.not_found()}, type = "info", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
      end)
    end)
  end,lang.home.intercom.description()}

  menu[lang.home.buy.title()] = {function(player,choice)
    vRP.getUserAddress(user_id, function(address)
      if address == nil then -- check if not already have a home
        vRP.findFreeNumber(home_name, home.max, function(number)
          if number ~= nil then
            if vRP.tryFullPayment(user_id, home.buy_price) then
              -- bought, set address
              vRP.setUserAddress(user_id, home_name, number)

              TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.home.buy.bought({number})}, type = "info", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            else
              TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.money.not_enough()}, type = "info", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
          else
            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.home.buy.full()}, type = "info", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
          end
        end)
      else
        TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.home.buy.have_home()}, type = "info", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
      end
    end)
  end, lang.home.buy.description({format_thousands(tonumber(home.buy_price))})}

  menu[lang.home.sell.title()] = {function(player,choice)
    vRP.getUserAddress(user_id, function(address)
      if address ~= nil and address.home == home_name then -- check if already have a home
        -- sold, give sell price, remove address
        vRP.giveBankMoney(user_id, home.sell_price)
        vRP.removeUserAddress(user_id)
        TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.home.sell.sold()}, type = "info", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
      else
        TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.home.sell.no_home()}, type = "info", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
      end
    end)
  end, lang.home.sell.description({format_thousands(tonumber(home.sell_price))})}

  return menu
end

-- build homes entry points
local function build_client_homes(source)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    for k,v in pairs(cfg.homes) do
      local x,y,z = table.unpack(v.entry_point)

      local function entry_enter(player,area)
        local user_id = vRP.getUserId(player)
        if user_id ~= nil and vRP.hasPermissions(user_id,v.permissions or {}) then
          vRP.openMenu(source,build_entry_menu(user_id, k))
        end
      end

      local function entry_leave(player,area)
        vRP.closeMenu(player)
      end

      if v.blip_hidden == true then
        vRPclient.addMarker(source,{x,y,z-0.87,0.7,0.7,0.5,0,255,125,125,150})
      else
        vRPclient.addBlip(source,{x,y,z,v.blipid,v.blipcolor,k})
        vRPclient.addMarker(source,{x,y,z-0.87,0.7,0.7,0.5,0,255,125,125,150})
      end

      vRP.setArea(source,"vRP:home"..k,x,y,z,1,1.5,entry_enter,entry_leave)
    end
  end
end

AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
  if first_spawn then -- first spawn, build homes
    build_client_homes(source)
    vRP.addComps("jobwardrobe",user_id,"pdwb",1,0,"Politi Omklædning",450.08996582031,-993.12475585938,30.689682006836,source,"politi")
    vRP.addComps("jobwardrobe",user_id,"pdsandy",1,0,"Politi Omklædning Sandy",1841.4801025391,3690.8615722656,34.276504516602,source,"politi")
    vRP.addComps("jobwardrobe",user_id,"emswb",1,0,"EMS Omklædning",301.49914550781,-598.71661376953,43.283992767334,source,"ems") -- mIDTBY
    vRP.addComps("jobwardrobe",user_id,"emswb2",1,0,"EMS Omklædning",-246.07678222656,6325.6069335938,32.436401367188,source,"ems")--paleto
    vRP.addComps("jobwardrobe",user_id,"mech1",1,0,"Mekaniker Omklædning",-345.04507446289,-123.16081237793,38.865660095215,source,"mekaniker")
    vRP.addComps("jobwardrobe",user_id,"mech2",1,0,"Mekaniker Omklædning",958.76165771484,-3005.3073730469,-39.639896392822,source,"mekaniker")
    vRP.addComps("jobwardrobe",user_id,"mech3",1,0,"Mekaniker Omklædning",-148.12060546875,157.34982299805,77.501502990723,source,"mekaniker")
    vRP.addComps("jobwardrobe",user_id,"mech4",1,0,"Mekaniker Omklædning",1772.56, 3320.35, 41.93,source,"mekaniker")
	vRP.addComps("jobwardrobe",user_id,"mech5",1,0,"Mekaniker Omklædning",956.77691650391, -966.31976318359, 39.50679397583,source,"mekaniker")
	vRP.addComps("jobwardrobe",user_id,"mech6",1,0,"Mekaniker Omklædning",549.74420166016,-174.45767211914,54.481353759766,source,"mekaniker")
    vRP.addComps("jobwardrobe",user_id,"kartelwb",1,0,"Drugkartel Omklædning",3071.900390625,-4698.0791015625,6.0772924423218,source,"drugdealer")
    vRP.addComps("jobwardrobe",user_id,"dommer",1,0,"Dommer Omklædning",253.75469970703,-449.24710083008,-22.817951202393,source,"dommer")
    vRP.addComps("jobwardrobe",user_id,"weapondealer",1,0,"Våbendealer Omklædning",900.04010009766,-3204.7368164063,-97.187889099121,source,"weapondealer")
    vRP.addComps("jobwardrobe",user_id,"ejendomsmaegler",1,0,"Ejendomsmægler Omklædning",-132.1937713623,-636.01336669922,168.82037353516,source,"ejendomsmaegler")
    vRP.addComps("jobwardrobe",user_id,"casino",1,0,"Casino Omklædning",1117.8421630859,251.68147277832,-45.840969085693,source,"casino")
    vRP.addComps("jobwardrobe",user_id,"mech7",1,0,"Mekaniker Omklædning",-231.7657623291,-1372.4923095703,31.258251190186,source,"mekaniker")
    vRP.addComps("jobwardrobe",user_id,"mech8",1,0,"Mekaniker Omklædning",-89.552192687988,-1826.9501953125,26.958646774292,source,"mekaniker")
  else -- death, leave home if inside one
    -- leave slot if inside one
    local tmp = vRP.getUserTmpTable(user_id)
    if tmp and tmp.home_stype then
      leave_slot(user_id, source, tmp.home_stype, tmp.home_sid)
    end
  end
end)

AddEventHandler("vRP:playerLeave",function(user_id, player)
  -- leave slot if inside one
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp and tmp.home_stype then
    leave_slot(user_id, player, tmp.home_stype, tmp.home_sid)
  end
end)

function format_thousands(v)
  local s = string.format("%d", math.floor(v))
  local pos = string.len(s) % 3
  if pos == 0 then pos = 3 end
  return string.sub(s, 1, pos)
          .. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end

local chest_enter

local function create_pleschest(owner_access, x, y, z, player, name, weight)
--  print(owner_access, x, y, z, player, name, weight)
	local namex = name or "chest"


  chest_enter = function(player, area)
		local user_id = vRP.getUserId(player)
		if user_id ~= nil then
			if vRP.hasInventoryItem(user_id, owner_access) then
				vRP.openChest(player, "static:"..owner_access..":"..namex, weight, nil, nil, nil)
			end
		end
	end

	local chest_leave = function(player,area)
		vRP.closeMenu({player})
	end

	local nid = "vRP:static-"..namex..":"..owner_access
--  print(player,nid,x,y,z,1,1.5,chest_enter,chest_leave)
	vRP.setArea(player,nid,x,y,z,1,1.5,chest_enter,chest_leave)
	vRPclient.addMarker(player,{x,y,z-0.87,0.7,0.7,0.5,0,255,125,125,150})
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
-- AddEventHandler("vRP:test123",function(source)
-- first_spawn = true
if first_spawn then
	for k, v in pairs(cfg.keyhomes) do
    for k2,v2 in pairs(v) do
      if k2 ~= "stype" and k2 ~= "weight" and k2 ~= "doorhash" then
        if v2.key then
        -- print(k .. k2 .. " - " .. v.weight)
        --print(v2.key, v2.chest[1], v2.chest[2], v2.chest[3], source, k..k2, v.weight)
       create_pleschest(v2.key, v2.chest[1], v2.chest[2], v2.chest[3], source, k..k2, v.weight)
        end

      else
        end
    end
		--TriggerClientEvent('chatMessage', -1, "Chest created: "..v[1]..", "..v[2]..", "..v[3]..", "..v[4]..", "..v[5]..".") -- debuging.
	end
end
end)


RegisterCommand('test1', function(source)
  TriggerEvent("vRP:test123", source)
end)

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end
