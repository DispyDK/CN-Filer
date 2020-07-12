
-- define some basic home components
local lang = vRP.lang
local sanitizes = module("cfg/sanitizes")

-- CHEST

local function chest_create(owner_id, stype, sid, cid, config, x, y, z, player)
  local chest_enter = function(player,area)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil and user_id == owner_id or config.shared ~= nil then
      vRP.openChest(player, "u"..owner_id.."home", config.weight or 200,nil,nil,nil)
    end
  end

  local chest_leave = function(player,area)
    vRP.closeMenu(player)
  end

  local nid = "vRP:home:slot"..stype..sid..":chest"
  vRPclient.setNamedMarker(player,{nid,x,y,z-1,0.7,0.7,0.5,0,255,125,125,150})
  vRP.setArea(player,nid,x,y,z,1,1.5,chest_enter,chest_leave)
  if config.shared ~= nil and config.shared.loc ~= nil then
    local chest_enter_shared = function(player,area)
      if config.shared.code ~= nil then
        vRP.prompt(player, "Skriv adgangskode:", "", function(player, code)
          if code == config.shared.code then
            vRP.openChest(player, config.shared.name, config.shared.weight or 200,nil,nil,nil)
          else
          --  TriggerClientEvent("pNotify:SendNotification", player,{text = "Forkert adgangskode", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
          end
        end)
      else
        vRP.openChest(player, config.shared.home, config.weight or 200,nil,nil,nil)
      end
    end
    nid = "vRP:home:slot"..stype..sid..":sharedchest"
    vRP.setArea(player,nid,config.shared.loc[1],config.shared.loc[2],config.shared.loc[3],1,1.5,chest_enter_shared,chest_leave)
    vRPclient.setNamedMarker(player,{nid,config.shared.loc[1],config.shared.loc[2],config.shared.loc[3]-1,0.7,0.7,0.5,0,255,125,125,150})
  end
end

local function chest_destroy(owner_id, stype, sid, cid, config, x, y, z, player)
  local nid = "vRP:home:slot"..stype..sid..":chest"
  vRPclient.removeNamedMarker(player,{nid})
  vRP.removeArea(player,nid)
  if config.shared ~= nil and config.shared.loc ~= nil then
    local nid = "vRP:home:slot"..stype..sid..":sharedchest"
    vRPclient.removeNamedMarker(player,{nid})
    vRP.removeArea(player,nid)
  end
end

vRP.defHomeComponent("chest", chest_create, chest_destroy)

-- WARDROBE

local function wardrobe_create(owner_id, stype, sid, cid, config, x, y, z, player)
  local wardrobe_enter = nil
  wardrobe_enter = function(player,area)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil and user_id == owner_id or config.shared ~= nil then
      -- notify player if wearing a uniform
      local data = vRP.getUserDataTable(user_id)

      -- build menu
      local menu = {name=lang.home.wardrobe.title(),css={top = "75px", header_color="rgba(0,255,125,0.75)"}}

      -- load sets
      vRP.getUData(user_id, "vRP:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
          sets = {}
        end

        -- save
        menu[lang.home.wardrobe.save.title()] = {function(player, choice)
          vRP.prompt(player, lang.home.wardrobe.save.prompt(), "", function(player, setname)
            setname = sanitizeString(setname, sanitizes.text[1], sanitizes.text[2])
            if string.len(setname) > 0 then
              -- save custom
              vRPclient.getCustomization(player,{},function(custom)
                sets[setname] = custom
                -- save to db
                vRP.setUData(user_id,"vRP:home:wardrobe",json.encode(sets))
                -- actualize menu
                wardrobe_enter(player, area)
              end)
            else
              TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.invalid_value()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
          end)
        end}

        local menu2 = {name=lang.home.wardrobe.title(),css={top = "75px", header_color="rgba(0,255,125,0.75)"} }
        local choosen = ""

        local choose_set = function(player,choice)
          choosen = choice
          vRP.openMenu(player,menu2)
        end
        -- sets
        for k,v in pairs(sets) do
          menu[k] = {choose_set}
        end

        menu2["> Tag outfit på"] = {function(player, choice)
          local custom = sets[choosen]
          if custom ~= nil then
            vRPclient.getHealth(player,{},function(health)
          --  local armor = GetPedArmour(player)
              TriggerEvent("vRP:cloakroom:update", player)
              vRPclient.playAnim(player,{false,{{"clothingshirt","try_shirt_negative_a"}},false})
              vRPclient.setCustomization(player,{custom})
              SetTimeout(500,function()
                vRPclient.setHealth(player,{health})
              --  vRPclient.setsArmour(player,{tonumber(armor),true})
                vRP.getUData(user_id,"vRP:tattoos",function(value)
                  local tattoos = json.decode(value)
                  if tattoos ~= nil then
                    for k,v in pairs(tattoos) do
                      vRPclient.drawMyTattoo(player,{k,v})
                    end
                  end
                end)
              end)
            end)
          end
          vRP.closeMenu(player)
        end}
        menu2["Skift outfitnavn"] = {function(player, choice)
          local custom = sets[choosen]
          if custom ~= nil then
            vRP.prompt(player, "Nye outfit navn? (Imellem 1 og 20)", choosen, function(player, name)
              name = sanitizeString(name, sanitizes.text[1], sanitizes.text[2])
              if string.len(name) >= 1 and string.len(name) <= 20 then
                for k,v in pairs(sets) do
                  if k == choosen then
                    sets[name] = sets[k]
                    sets[k] = nil
                    vRP.setUData(user_id,"vRP:home:wardrobe",json.encode(sets))
                  end
                end
              else
                TriggerClientEvent("pNotify:SendNotification",player,{text = "Navnet skal være imellem 1 og 20 bogstaver!", type = "error", timeout = (3000),layout = "centerLeft"})
              end
              wardrobe_enter(player, area)
            end)
          end
        end}
        menu2["Slet outfit"] = {function(player, choice)
            for k,v in pairs(sets) do
              if k == choosen then
                sets[k] = nil
                vRP.setUData(user_id,"vRP:home:wardrobe",json.encode(sets))
              end
            end
            wardrobe_enter(player, area)
        end}
        -- open the menu
        vRP.openMenu(player,menu)
      end)
    end
  end

  local wardrobe_leave = function(player,area)
    vRP.closeMenu(player)
  end

  local nid = "vRP:home:slot"..stype..sid..":wardrobe"
  vRPclient.setNamedMarker(player,{nid,x,y,z-0.87,0.7,0.7,0.5,0,255,125,125,150})
  vRP.setArea(player,nid,x,y,z,1,1.5,wardrobe_enter,wardrobe_leave)
end

local function wardrobe_destroy(owner_id, stype, sid, cid, config, x, y, z, player)
  local nid = "vRP:home:slot"..stype..sid..":wardrobe"
  vRPclient.removeNamedMarker(player,{nid})
  vRP.removeArea(player,nid)
end

vRP.defHomeComponent("wardrobe", wardrobe_create, wardrobe_destroy)

-- GAMETABLE

local function gametable_create(owner_id, stype, sid, cid, config, x, y, z, player)
  local gametable_enter = function(player,area)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil and user_id == owner_id then
      -- build menu
      local menu = {name=lang.home.gametable.title(),css={top = "75px", header_color="rgba(0,255,125,0.75)"}}

      -- launch bet
      menu[lang.home.gametable.bet.title()] = {function(player, choice)
        vRP.prompt(player, lang.home.gametable.bet.prompt(), "", function(player, amount)
          amount = parseInt(amount)
          if amount > 0 then
            if vRP.tryFullPayment(user_id,amount) then
              TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.home.gametable.bet.started()}, type = "info", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
              -- init bet total and players (add by default the bet launcher)
              local bet_total = amount
              local bet_players = {}
              local bet_opened = true
              table.insert(bet_players, player)

              local close_bet = function()
                if bet_opened then
                  bet_opened = false
                  -- select winner
                  local wplayer = bet_players[math.random(1,#bet_players)]
                  local wuser_id = vRP.getUserId(wplayer)
                  if wuser_id ~= nil then
                    vRP.giveBankMoney(wuser_id, bet_total)
                    TriggerClientEvent("pNotify:SendNotification", wplayer,{text = {lang.money.received({bet_total})}, type = "success", queue = "global", timeout = 3000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    vRPclient.playAnim(wplayer,{true,{{"mp_player_introck","mp_player_int_rock",1}},false})
                  end
                end
              end

              -- send bet request to all nearest players
              vRPclient.getNearestPlayers(player,{7},function(players)
                local pcount = 0
                for k,v in pairs(players) do
                  pcount = pcount+1
                  local nplayer = parseInt(k)
                  local nuser_id = vRP.getUserId(nplayer)
                  if nuser_id ~= nil then -- request
                    vRP.request(nplayer,lang.home.gametable.bet.request({amount}), 30, function(nplayer, ok)
                      if ok and bet_opened then
                        if vRP.tryFullPayment(nuser_id,amount) then -- register player bet
                          bet_total = bet_total+amount
                          table.insert(bet_players, nplayer)
                          TriggerClientEvent("pNotify:SendNotification", nplayer,{text = {lang.money.paid({amount})}, type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                        else
                          TriggerClientEvent("pNotify:SendNotification", nplayer,{text = {lang.money.not_enough()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                        end
                      end

                      pcount = pcount-1
                      if pcount == 0 then -- autoclose bet, everyone is ok
                        close_bet()
                      end
                    end)
                  end
                end

                -- bet timeout
                SetTimeout(32000, close_bet)
              end)
            else
              TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.money.not_enough()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
          else
            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.invalid_value()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
          end
        end)
      end,lang.home.gametable.bet.description()}

      -- open the menu
      vRP.openMenu(player,menu)
    end
  end

  local gametable_leave = function(player,area)
    vRP.closeMenu(player)
  end

  local nid = "vRP:home:slot"..stype..sid..":gametable"
  vRPclient.setNamedMarker(player,{nid,x,y,z-0.87,0.7,0.7,0.5,0,255,125,125,150})
  vRP.setArea(player,nid,x,y,z,1,1.5,gametable_enter,gametable_leave)
end

local function gametable_destroy(owner_id, stype, sid, cid, config, x, y, z, player)
  local nid = "vRP:home:slot"..stype..sid..":gametable"
  vRPclient.removeNamedMarker(player,{nid})
  vRP.removeArea(player,nid)
end

vRP.defHomeComponent("gametable", gametable_create, gametable_destroy)

-- ITEM TRANSFORMERS

-- item transformers are global to all players, so we need a counter to know when to create/destroy them
local itemtrs = {}

local function itemtr_create(owner_id, stype, sid, cid, config, x, y, z, player)
  local nid = "home:slot"..stype..sid..":itemtr"..cid
  if itemtrs[nid] == nil then
    itemtrs[nid] = 1

    -- simple copy
    local itemtr = {}
    for k,v in pairs(config) do
      itemtr[k] = v
    end

    itemtr.x = x
    itemtr.y = y
    itemtr.z = z

    vRP.setItemTransformer(nid, itemtr)
  else
    itemtrs[nid] = itemtrs[nid]+1
  end
end

local function itemtr_destroy(owner_id, stype, sid, cid, config, x, y, z, player)
  local nid = "home:slot"..stype..sid..":itemtr"..cid
  if itemtrs[nid] ~= nil then
    itemtrs[nid] = itemtrs[nid]-1
    if itemtrs[nid] == 0 then
      itemtrs[nid] = nil
      vRP.removeItemTransformer(nid)
    end
  end
end

vRP.defHomeComponent("itemtr", itemtr_create, itemtr_destroy)

local function jobwardrobe_create(owner_id, stype, sid, cid, config, x, y, z, player,job)
    local jobwardrobe_enter = nil
    jobwardrobe_enter = function(player,area)
        local user_id = vRP.getUserId(player)
        if vRP.hasPermission(user_id,job..".wardrobe") then
            if user_id ~= nil and user_id == owner_id or config.shared ~= nil then
                -- notify player if wearing a uniform
                local data = vRP.getUserDataTable(user_id)

                -- build menu
                local menu = {name=job.." omklædning",css={top = "75px", header_color="rgba(0,255,125,0.75)"}}

                -- load sets
                vRP.getUData(user_id, "vRP:"..job..":wardrobe", function(data)
                    local sets = json.decode(data)
                    if sets == nil then
                        sets = {}
                    end

                    -- save
                    menu[lang.home.wardrobe.save.title()] = {function(player, choice)
                        vRP.prompt(player, lang.home.wardrobe.save.prompt(), "", function(player, setname)
                            setname = sanitizeString(setname, sanitizes.text[1], sanitizes.text[2])
                            if string.len(setname) > 0 then
                                -- save custom
                                vRPclient.getCustomization(player,{},function(custom)
                                    sets[setname] = custom
                                    -- save to db
                                    vRP.setUData(user_id,"vRP:"..job..":wardrobe",json.encode(sets))
                                    -- actualize menu
                                    jobwardrobe_enter(player, area)
                                end)
                            else
                                TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.invalid_value()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                            end
                        end)
                    end}

                    local menu2 = {name=lang.home.wardrobe.title(),css={top = "75px", header_color="rgba(0,255,125,0.75)"} }
                    local choosen = ""

                    local choose_set = function(player,choice)
                        choosen = choice
                        vRP.openMenu(player,menu2)
                    end
                    -- sets
                    for k,v in pairs(sets) do
                        menu[k] = {choose_set}
                    end

                    menu2["> Tag outfit på"] = {function(player, choice)
                        local custom = sets[choosen]
                        if custom ~= nil then
                            vRPclient.getHealth(player,{},function(health)
                          --  local armor = GetPedArmour(player)
                                TriggerEvent("vRP:cloakroom:update", player)
                                vRPclient.playAnim(player,{false,{{"clothingshirt","try_shirt_negative_a"}},false})
                                vRPclient.setCustomization(player,{custom})
                                SetTimeout(500,function()
                                    vRPclient.setHealth(player,{health})
                                  --  vRPclient.setsArmour(player,{tonumber(armor),true})
                                    vRP.getUData(user_id,"vRP:tattoos",function(value)
                                        local tattoos = json.decode(value)
                                        if tattoos ~= nil then
                                            for k,v in pairs(tattoos) do
                                                vRPclient.drawMyTattoo(player,{k,v})
                                            end
                                        end
                                    end)
                                end)
                            end)
                        end

                        vRP.closeMenu(player)
                    end}
                    menu2["Skift outfitnavn"] = {function(player, choice)
                        local custom = sets[choosen]
                        if custom ~= nil then
                            vRP.prompt(player, "Nye outfit navn? (Imellem 1 og 20)", choosen, function(player, name)
                                name = sanitizeString(name, sanitizes.text[1], sanitizes.text[2])
                                if string.len(name) >= 1 and string.len(name) <= 20 then
                                    for k,v in pairs(sets) do
                                        if k == choosen then
                                            sets[name] = sets[k]
                                            sets[k] = nil
                                            vRP.setUData(user_id,"vRP:"..job..":wardrobe",json.encode(sets))
                                        end
                                    end
                                else
                                    TriggerClientEvent("pNotify:SendNotification",player,{text = "Navnet skal være imellem 1 og 20 bogstaver!", type = "error", timeout = (3000),layout = "centerLeft"})
                                end
                                jobwardrobe_enter(player, area)
                            end)
                        end
                    end}
                    menu2["Slet outfit"] = {function(player, choice)
                        for k,v in pairs(sets) do
                            if k == choosen then
                                sets[k] = nil
                                vRP.setUData(user_id,"vRP:"..job..":wardrobe",json.encode(sets))
                            end
                        end
                        jobwardrobe_enter(player, area)
                    end}
                    -- open the menu
                    vRP.openMenu(player,menu)
                end)
            end
        end
    end

    local jobwardrobe_leave = function(player,area)
        vRP.closeMenu(player)
    end

    local nid = "vRP:home:slot"..stype..sid..":"..job.."wardrobe"
    vRPclient.setNamedMarker(player,{nid,x,y,z-0.87,0.7,0.7,0.5,0,255,125,125,150})
    vRP.setArea(player,nid,x,y,z,1,1.5,jobwardrobe_enter,jobwardrobe_leave)
end

local function jobwardrobe_destroy(owner_id, stype, sid, cid, config, x, y, z, player,job)
    local nid = "vRP:home:slot"..stype..sid..":"..job.."wardrobe"
    vRPclient.removeNamedMarker(player,{nid})
    vRP.removeArea(player,nid)
end

function vRP.addComps(type,owner_id, stype, sid, cid, config, x, y, z, player,job)
    if type == "chest" then
        chest_create(owner_id, stype, sid, cid, config, x, y, z, player)
    elseif type == "wardrobe" then
        wardrobe_create(owner_id, stype, sid, cid, config, x, y, z, player)
    elseif type == "jobwardrobe" then
        jobwardrobe_create(owner_id, stype, sid, cid, config, x, y, z, player,job)
    end
end

function vRP.delComps(type,owner_id, stype, sid, cid, config, x, y, z, player,job)
    if type == "chest" then
        chest_destroy(owner_id, stype, sid, cid, config, x, y, z, player)
    elseif type == "wardrobe" then
        wardrobe_destroy(owner_id, stype, sid, cid, config, x, y, z, player)
    elseif type == "jobwardrobe" then
        jobwardrobe_destroy(owner_id, stype, sid, cid, config, x, y, z, player,job)
    end
end
