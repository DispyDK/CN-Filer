local lang = vRP.lang
local cfg = module("cfg/inventory")

-- this module define the player inventory (lost after respawn, as wallet)

vRP.items = {}

-- define an inventory item (call this at server start) (parametric or plain text data)
-- idname: unique item name
-- name: display name or genfunction
-- description: item description (html) or genfunction
-- choices: menudata choices (see gui api) only as genfunction or nil
-- weight: weight or genfunction
--
-- genfunction are functions returning a correct value as: function(args) return value end
-- where args is a list of {base_idname,arg,arg,arg,...}
function vRP.defInventoryItem(idname,name,description,choices,weight)
  if weight == nil then
    weight = 0
  end

  local item = {name=name,description=description,choices=choices,weight=weight}
  vRP.items[idname] = item

  -- build give action
  item.ch_give = function(player,choice)
  end

  -- build trash action
  item.ch_trash = function(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
      -- prompt number
      vRP.prompt(player,lang.inventory.drop.prompt({vRP.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
        local amount = parseInt(amount)
        if vRP.tryGetInventoryItem(user_id,idname,amount,false) then
          TriggerClientEvent("pNotify:SetQueueMax", player, 2, 2)
          TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.inventory.drop.done({vRP.getItemName(idname),amount})}, type = "info", queue = "2",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
          vRPclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})




          TriggerClientEvent("3dme:remoteDisplay",player,"Smider "..vRP.getItemName(idname),3,5)
        else
          TriggerClientEvent("pNotify:SetQueueMax", player, 22, 2)
          TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.invalid_value()}, type = "info", queue = "22",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
      end)
    end
  end
end

-- give action
function ch_give(idname, player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    -- get nearest player
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
      if nplayer ~= nil then
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id ~= nil then
          -- prompt number
          vRP.prompt(player,lang.inventory.give.prompt({vRP.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
            local amount = parseInt(amount)
            -- weight check
            local new_weight = vRP.getInventoryWeight(nuser_id)+vRP.getItemWeight(idname)*amount
            if new_weight <= vRP.getInventoryMaxWeight(nuser_id) then
              if vRP.tryGetInventoryItem(user_id,idname,amount,true) then
                vRP.giveInventoryItem(nuser_id,idname,amount,true)
                vRPclient.playAnim(player,{true,{{"mp_common","givetake1_a",1}},false})
                vRPclient.playAnim(nplayer,{true,{{"mp_common","givetake2_a",1}},false})

                if amount > 0 then
                  TriggerClientEvent("3dme:remoteDisplay",player,"Giver "..vRP.getItemName(idname),3,5)
                end
                if string.starts(idname, "wbody") or string.starts(idname, "wammo") then
                  if vRP.hasPermission(user_id,"weapons.dealer") == false then
                    vRP.getUserIdentity(user_id, function(identity1)
                      vRP.getUserIdentity(nuser_id, function(identity2)
                        if identity1 and identity2 then
                          local fornavn1 = identity1.firstname
                          local efternavn1 = identity1.name
                          local fornavn2 = identity2.firstname
                          local efternavn2 = identity2.name
                          local dato = os.date("**%d-%m-%Y** kl. **%X**")
                          PerformHttpRequest('https://autisthook.com/api/webhooks/597921721734922280/1cAq6KK9mB7zN0HEnGTdClK9D0Ocmeg7oLA15KCX2sQgqGdiEcwfPnDbxDWBq4JU84wR', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0"), content = "**"..fornavn1.." "..efternavn1.." ("..user_id..")** gav **"..fornavn2.." "..efternavn2.." ("..nuser_id..") "..amount.." stk. "..vRP.getItemName(idname).."** - ("..dato..")"}), { ['Content-Type'] = 'application/json' })
                        end
                      end)
                    end)
                  end
                end

              else
                TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.invalid_value()}, type = "error", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
              end
            else
              TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.inventory.full()}, type = "warning", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
          end)
        else
          TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "error", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
      else
        TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "error", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
      end
    end)
  end
end

--trash action
function ch_trash(idname, player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRP.getUserIdentity(user_id, function(identity)
      if identity then
        vRP.prompt(player,lang.inventory.drop.prompt({vRP.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
          local amount = parseInt(amount)
          if vRP.tryGetInventoryItem(user_id,idname,amount,false) then
            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.inventory.drop.done({vRP.getItemName(idname),amount})}, type = "warning", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            vRPclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
            TriggerEvent("cn-itemdrop:drop", player, idname, amount)
            local dato = os.date("**%d-%m-%Y** kl. **%X**")

          end
        end)
      end
    end)
  end
end

function vRP.computeItemName(item,args)
  if type(item.name) == "string" then return item.name
  else return item.name(args) end
end

function vRP.computeItemDescription(item,args)
  if type(item.description) == "string" then return item.description
  else return item.description(args) end
end

function vRP.computeItemChoices(item,args)
  if item.choices ~= nil then
    return item.choices(args)
  else
    return {}
  end
end

function vRP.computeItemWeight(item,args)
  if type(item.weight) == "number" then return item.weight
  else return item.weight(args) end
end


function vRP.parseItem(idname)
  return splitString(idname,"|")
end

-- return name, description, weight
function vRP.getItemDefinition(idname)
  local args = vRP.parseItem(idname)
  local item = vRP.items[args[1]]
  if item ~= nil then
    return vRP.computeItemName(item,args), vRP.computeItemDescription(item,args), vRP.computeItemWeight(item,args)
  end

  return nil,nil,nil
end

function vRP.getItemName(idname)
  local args = vRP.parseItem(idname)
  local item = vRP.items[args[1]]
  if item ~= nil then return vRP.computeItemName(item,args) end
  return args[1]
end

function vRP.getItemDescription(idname)
  local args = vRP.parseItem(idname)
  local item = vRP.items[args[1]]
  if item ~= nil then return vRP.computeItemDescription(item,args) end
  return ""
end

function vRP.getItemChoices(idname)
  local args = vRP.parseItem(idname)
  local item = vRP.items[args[1]]
  local choices = {}
  if item ~= nil then
    -- compute choices
    local cchoices = vRP.computeItemChoices(item,args)
    if cchoices then -- copy computed choices
      for k,v in pairs(cchoices) do
        choices[k] = v
      end
    end

    -- add give/trash choices
    choices[lang.inventory.give.title()] = {function(player,choice) ch_give(idname, player, choice) end, lang.inventory.give.description()}
    choices[lang.inventory.drop.title()] = {function(player, choice) ch_trash(idname, player, choice) end, lang.inventory.drop.description()}
  end

  return choices
end

function vRP.getItemWeight(idname)
  local args = vRP.parseItem(idname)
  local item = vRP.items[args[1]]
  if item ~= nil then return vRP.computeItemWeight(item,args) end
  return 0
end

-- compute weight of a list of items (in inventory/chest format)
function vRP.computeItemsWeight(items)
  local weight = 0

  for k,v in pairs(items) do
    local iweight = vRP.getItemWeight(k)
    weight = weight+iweight*v.amount
  end

  return weight
end

-- add item to a connected user inventory
function vRP.giveInventoryItem(user_id,idname,amount,notify)
  if notify == nil then notify = true end -- notify by default

  local data = vRP.getUserDataTable(user_id)
  if data and amount > 0 then
    local entry = data.inventory[idname]
    if entry then -- add to entry
      entry.amount = entry.amount+amount
    else -- new entry
      data.inventory[idname] = {amount=amount}
    end
    vRPex.updateInventory({user_id,data.inventory,vRP.getInventoryWeight(user_id)})
    -- notify
    if notify then
      local player = vRP.getUserSource(user_id)
      if player ~= nil then
        TriggerClientEvent("pNotify:SetQueueMax", player, 3, 2)
        TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.inventory.give.received({vRP.getItemName(idname),amount})}, type = "info", queue = "3",timeout = 2000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
      end
    end
  end
end

-- try to get item from a connected user inventory
function vRP.tryGetInventoryItem(user_id,idname,amount,notify)
  if notify == nil then notify = true end -- notify by default

  local data = vRP.getUserDataTable(user_id)
  if data and amount > 0 then
    local entry = data.inventory[idname]
    if entry and entry.amount >= amount then -- add to entry
      entry.amount = entry.amount-amount

      -- remove entry if <= 0
      if entry.amount <= 0 then
        data.inventory[idname] = nil
      end
      vRPex.updateInventory({user_id,data.inventory,vRP.getInventoryWeight(user_id)})
      -- notify
      if notify then
        local player = vRP.getUserSource(user_id)
        if player ~= nil then
          TriggerClientEvent("pNotify:SetQueueMax", player, 4, 1)
          TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.inventory.give.given({vRP.getItemName(idname),amount})}, type = "info", queue = "4",timeout = 2000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
      end

      return true
    else
      -- notify
      if notify then
        local player = vRP.getUserSource(user_id)
        if player ~= nil then
          local entry_amount = 0
          if entry then entry_amount = entry.amount end
          TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.inventory.missing({vRP.getItemName(idname),amount-entry_amount})}, type = "info", queue = "global",timeout = 2000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
      end
    end
  end

  return false
end

function vRP.hasInventoryItem(user_id, idname)
  local count = vRP.getInventoryItemAmount(user_id, idname)
  return count > 0
end

-- get user inventory amount of item
function vRP.getInventoryItemAmount(user_id,idname)
  local data = vRP.getUserDataTable(user_id)
  if data and data.inventory then
    local entry = data.inventory[idname]
    if entry then
      return entry.amount
    end
  end

  return 0
end

function vRP.getInventory(user_id)
  local data = vRP.getUserDataTable(user_id)
  if data then
    return data.inventory
  end
end

-- return user inventory total weight
function vRP.getInventoryWeight(user_id)
  local data = vRP.getUserDataTable(user_id)
  if data and data.inventory then
    return vRP.computeItemsWeight(data.inventory)
  end

  return 0
end

-- return maximum weight of the user inventory
function vRP.getInventoryMaxWeight(user_id)
  return math.floor(vRP.expToLevel(vRP.getExp(user_id, "physical", "strength")))*cfg.inventory_weight_per_strength
end

-- clear connected user inventory
function vRP.clearInventory(user_id,give)
  local data = vRP.getUserDataTable(user_id)
  if data then
    data.inventory = {}
    vRPex.updateInventory({user_id,data.inventory,vRP.getInventoryWeight(user_id)})
    if give then
      vRP.giveInventoryItem(user_id,"water",1,false)
      vRP.giveInventoryItem(user_id,"sandwich",1,false)
    end
  end
end

-- INVENTORY MENU

-- open player inventory
function vRP.openInventory(source)
  local user_id = vRP.getUserId(source)

  if user_id ~= nil then
    local data = vRP.getUserDataTable(user_id)
    if data then
      -- build inventory menu
      local menudata = {name=lang.inventory.title(),css={top="75px",header_color="rgba(100, 0, 0,0.75)"}}
      -- add inventory info
      local weight = vRP.getInventoryWeight(user_id)
      local max_weight = vRP.getInventoryMaxWeight(user_id)
      local hue = math.floor(math.max(125*(1-weight/max_weight), 0))
      menudata["<div class=\"dprogressbar\" data-value=\""..string.format("%.2f",weight/max_weight).."\" data-color=\"hsl("..hue..",100%,50%)\" data-bgcolor=\"hsl("..hue..",100%,25%)\" style=\"height: 12px; border: 3px solid black;\"></div>"] = {function()end, lang.inventory.info_weight({string.format("%.2f",weight),max_weight})}
      local kitems = {}

      -- choose callback, nested menu, create the item menu
      local choose = function(player,choice)
        if string.sub(choice,1,1) ~= "@" then -- ignore info choices
          local choices = vRP.getItemChoices(kitems[choice])
          -- build item menu
          local submenudata = {name=choice,css={top="75px",header_color="rgba(100,0,0,0.75)"}}

          -- add computed choices
          for k,v in pairs(choices) do
            submenudata[k] = v
          end

          -- nest menu
          submenudata.onclose = function()
            vRP.openInventory(source) -- reopen inventory when submenu closed
          end

          -- open menu
          vRP.openMenu(source,submenudata)
        end
      end

      -- add each item to the menu
      for k,v in pairs(data.inventory) do
        local name,description,weight = vRP.getItemDefinition(k)
        if name ~= nil then
          kitems[name] = k -- reference item by display name
          menudata[name] = {choose,lang.inventory.iteminfo({v.amount,description,string.format("%.2f",weight)})}
        end
      end

      -- open menu
      vRP.openMenu(source,menudata)
    end
  end
end

-- init inventory
AddEventHandler("vRP:playerJoin", function(user_id,source,name,last_login)
  local data = vRP.getUserDataTable(user_id)
  if data.inventory == nil then
    data.inventory = {}
  end
end)


-- add open inventory to main menu
local choices = {}
--choices[lang.inventory.title()] = {function(player, choice) vRP.openInventory(player) end, lang.inventory.description()}

vRP.registerMenuBuilder("main", function(add, data)
  add(choices)
end)

-- CHEST SYSTEM

local chests = {}

-- build a menu from a list of items and bind a callback(idname)
local function build_itemlist_menu(name, items, cb)
  local menu = {name=name, css={top="75px",header_color="rgba(100,0,0,0.75)"}}

  local kitems = {}

  -- choice callback
  local choose = function(player,choice)
    local idname = kitems[choice]
    if idname then
      cb(idname)
    end
  end

  -- add each item to the menu
  for k,v in pairs(items) do
    local name,description,weight = vRP.getItemDefinition(k)
    if name ~= nil then
      kitems[name] = k -- reference item by display name
      menu[name] = {choose,lang.inventory.iteminfo({v.amount,description,string.format("%.2f", weight)})}
    end
  end

  return menu
end

function string.starts(String,Start)
  return string.sub(String,1,string.len(Start))==Start
end

-- open a chest by name
-- cb_close(): called when the chest is closed (optional)
-- cb_in(idname, amount): called when an item is added (optional)
-- cb_out(idname, amount): called when an item is taken (optional)

local notok = false

function vRP.openChest(source, name, max_weight, cb_close, cb_in, cb_out)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    local data = vRP.getUserDataTable(user_id)
    if data.inventory ~= nil then
      if not chests[name] then
        local close_count = 0 -- used to know when the chest is closed (unlocked)

        -- load chest
        local chest = {max_weight = max_weight,source = source}
        chests[name] = chest
        vRP.getSData("chest:"..name, function(cdata)
          chest.items = json.decode(cdata) or {} -- load items

          -- open menu
          local menu = {name=lang.inventory.chest.title(), css={top="75px",header_color="rgba(100,0,0,0.75)"}}
          -- take
          local cb_take = function(idname)
            print(name)
            if (string.match(name, "veh")) then
              vRPclient.getNearestOwnedVehicle(source,{7},function(ok,vtype,name)
                if ok then
                  print("ok")
                else
                  print("ik ok")
                  notok = true
                  return false
                end
              end)
            end
            local citem = chest.items[idname]
            vRP.prompt(source, lang.inventory.chest.take.prompt({citem.amount}), "", function(player, amount)
              amount = parseInt(amount)
              if amount >= 0 and amount <= citem.amount and not notok then
                -- take item

                -- weight check
                local new_weight = vRP.getInventoryWeight(user_id)+vRP.getItemWeight(idname)*amount
                if new_weight <= vRP.getInventoryMaxWeight(user_id) then
                  vRP.giveInventoryItem(user_id, idname, amount, true)
                  citem.amount = citem.amount-amount

                  if citem.amount <= 0 then
                    chest.items[idname] = nil -- remove item entry
                  end


                  if string.match(name, "veh_") then
                    if amount > 0 then
                      TriggerClientEvent("3dme:remoteDisplay",source,"Tager noget ud af baggagerummet",3,5)
                    end
                  end
                      vRP.getUserIdentity(user_id, function(identity)
                        if identity then
                          local fornavn = identity.firstname
                          local efternavn = identity.name
                          local dato = os.date("**%d-%m-%Y** kl. **%X**")
                          if amount > 0 then
                            PerformHttpRequest('https://autisthook.com/api/webhooks/597921721734922280/1cAq6KK9mB7zN0HEnGTdClK9D0Ocmeg7oLA15KCX2sQgqGdiEcwfPnDbxDWBq4JU84wR', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0"), content = "**"..fornavn.." "..efternavn.." ("..user_id..")** tog **"..amount.." stk. "..vRP.getItemName(idname).."** fra køretøjet: **"..name.."** - ("..dato..")"}), { ['Content-Type'] = 'application/json' })
                          end
                        end
                      end)

                  if string.starts(name, "static:police.menu:Politi lager") then
                      vRP.getUserIdentity(user_id, function(identity)
                        if identity then
                          local fornavn = identity.firstname
                          local efternavn = identity.name
                          local dato = os.date("**%d-%m-%Y** kl. **%X**")
                          if amount > 0 then
                            PerformHttpRequest('https://autisthook.com/api/webhooks/628521113420562462/z6J1ll2mXOac0XupVFgiSVaeoz0z0yut7ipCf1d7fekBDx5IbQzuNODrZLDl9WCJHGZ_', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0"), content = "**"..fornavn.." "..efternavn.." ("..user_id..")** tog **"..amount.." stk. "..vRP.getItemName(idname).."** fra: **"..name.."** - ("..dato..")"}), { ['Content-Type'] = 'application/json' })
                          end
                        end
                      end)
                  end
                  if string.starts(name, "static:police.menu:Politi lager sandyPD") then
                    vRP.getUserIdentity(user_id, function(identity)
                      if identity then
                        local fornavn = identity.firstname
                        local efternavn = identity.name
                        local dato = os.date("**%d-%m-%Y** kl. **%X**")
                        if amount > 0 then
                          PerformHttpRequest('https://autisthook.com/api/webhooks/628521113420562462/z6J1ll2mXOac0XupVFgiSVaeoz0z0yut7ipCf1d7fekBDx5IbQzuNODrZLDl9WCJHGZ_', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0"), content = "**"..fornavn.." "..efternavn.." ("..user_id..")** tog **"..amount.." stk. "..vRP.getItemName(idname).."** fra: **"..name.."** - ("..dato..")"}), { ['Content-Type'] = 'application/json' })
                        end
                      end
                    end)
                  end
                  if string.starts(name, "static:drugdealer.menu:Drugdealer lager") then
                    vRP.getUserIdentity(user_id, function(identity)
                      if identity then
                        local fornavn = identity.firstname
                        local efternavn = identity.name
                        local dato = os.date("**%d-%m-%Y** kl. **%X**")
                        if amount > 0 then
                          PerformHttpRequest('https://autisthook.com/api/webhooks/706515415529947167/y7lLiT8WQtjwBOz4n4i-CKJVAmClouo9NkqyjEohHC49KNGeMFf3rZuViBP90Pz3H1e_', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0"), content = "**"..fornavn.." "..efternavn.." ("..user_id..")** tog **"..amount.." stk. "..vRP.getItemName(idname).."** fra: **"..name.."** - ("..dato..")"}), { ['Content-Type'] = 'application/json' })
                        end
                      end
                    end)
                  end
                  if string.starts(name, "static:druglord.adgang:Druglord lager") then
                    vRP.getUserIdentity(user_id, function(identity)
                      if identity then
                        local fornavn = identity.firstname
                        local efternavn = identity.name
                        local dato = os.date("**%d-%m-%Y** kl. **%X**")
                        if amount > 0 then
                          PerformHttpRequest('https://autisthook.com/api/webhooks/706515321980321872/Uy4-5yyFyvS-yB3vK1RpxBsGJkmcrpWFHgAUQiOC8W2XGvHNoXkgd9hPggd9Agp4eiuj', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0"), content = "**"..fornavn.." "..efternavn.." ("..user_id..")** tog **"..amount.." stk. "..vRP.getItemName(idname).."** fra: **"..name.."** - ("..dato..")"}), { ['Content-Type'] = 'application/json' })
                        end
                      end
                    end)
                  end
                  if string.starts(name, "bunker") then
                    vRP.getUserIdentity(user_id, function(identity)
                      if identity then
                        local fornavn = identity.firstname
                        local efternavn = identity.name
                        local dato = os.date("**%d-%m-%Y** kl. **%X**")
                        if amount > 0 then
                          PerformHttpRequest('https://autisthook.com/api/webhooks/666749997727088676/BfN-SI9Lv4oiudnN0GI0CSYq4Xt2bUYdiAD2bs75pIOtUuljvu_W5m9dXq-1Ilr326Ar', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0"), content = "**"..fornavn.." "..efternavn.." ("..user_id..")** tog **"..amount.." stk. "..vRP.getItemName(idname).."** fra: **"..name.."** - ("..dato..")"}), { ['Content-Type'] = 'application/json' })
                        end
                      end
                    end)
                  end

                  if cb_out then cb_out(idname,amount) end

                  -- actualize by closing
                  vRP.closeMenu(player)
                else
                  TriggerClientEvent("pNotify:SendNotification", source,{text = {lang.inventory.full()}, type = "warning", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                end
              else
                TriggerClientEvent("pNotify:SendNotification", source,{text = {lang.common.invalid_value()}, type = "error", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                notok = false
              end
            end)
          end

          local ch_take = function(player, choice)
            local submenu = build_itemlist_menu(lang.inventory.chest.take.title(), chest.items, cb_take)
            -- add weight info
            local weight = vRP.computeItemsWeight(chest.items)
            local hue = math.floor(math.max(125*(1-weight/max_weight), 0))
            submenu["<div class=\"dprogressbar\" data-value=\""..string.format("%.2f",weight/max_weight).."\" data-color=\"hsl("..hue..",100%,50%)\" data-bgcolor=\"hsl("..hue..",100%,25%)\" style=\"height: 12px; border: 3px solid black;\"></div>"] = {function()end, lang.inventory.info_weight({string.format("%.2f",weight),max_weight})}

            submenu.onclose = function()
              close_count = close_count-1
              vRP.openMenu(player, menu)
            end
            close_count = close_count+1
            vRP.openMenu(player, submenu)
          end


          -- put
          local cb_put = function(idname)
            vRP.prompt(source, lang.inventory.chest.put.prompt({vRP.getInventoryItemAmount(user_id, idname)}), "", function(player, amount)
              amount = parseInt(amount)

              if (string.match(name, "veh")) then
                vRPclient.getNearestOwnedVehicle(source,{7},function(ok,vtype,name)
                  if ok then
                    print("ok")
                  else
                    print("ik ok")
                    notok = true
                    return false
                  end
                end)
              end

              -- weight check
              local new_weight = vRP.computeItemsWeight(chest.items)+vRP.getItemWeight(idname)*amount
              if new_weight <= max_weight and not notok then
                if amount >= 0 and vRP.tryGetInventoryItem(user_id, idname, amount, true) then
                  local citem = chest.items[idname]
                  local newamount = 0
                  if citem ~= nil then
                    citem.amount = citem.amount+amount
                    newamount = citem.amount
                  else -- create item entry
                    chest.items[idname] = {amount=amount }
                    newamount = amount
                  end

                  if string.match(name, "veh_") then
                    if amount > 0 then
                      TriggerClientEvent("3dme:remoteDisplay",source,"Lægger noget i baggagerummet",3,5)
                    end
                  end
                    if vRP.hasPermission(user_id,"weapons.dealer") == false then
                      vRP.getUserIdentity(user_id, function(identity)
                        if identity then
                          local fornavn = identity.firstname
                          local efternavn = identity.name
                          local dato = os.date("**%d-%m-%Y** kl. **%X**")
                          if amount > 0 then
                            PerformHttpRequest('https://autisthook.com/api/webhooks/597921721734922280/1cAq6KK9mB7zN0HEnGTdClK9D0Ocmeg7oLA15KCX2sQgqGdiEcwfPnDbxDWBq4JU84wR', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0"), content = "**"..fornavn.." "..efternavn.." ("..user_id..")** lagde **"..amount.." stk. "..vRP.getItemName(idname).."** i køretøjet: **"..name.."** - ("..dato..")"}), { ['Content-Type'] = 'application/json' })
                          end
                        end
                      end)
                  end

                  if string.starts(name, "bunker") then
                    vRP.getUserIdentity(user_id, function(identity)
                      if identity then
                        local fornavn = identity.firstname
                        local efternavn = identity.name
                        local dato = os.date("**%d-%m-%Y** kl. **%X**")
                        if amount > 0 then
                          PerformHttpRequest('https://autisthook.com/api/webhooks/666749997727088676/BfN-SI9Lv4oiudnN0GI0CSYq4Xt2bUYdiAD2bs75pIOtUuljvu_W5m9dXq-1Ilr326Ar', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0"), content = "**"..fornavn.." "..efternavn.." ("..user_id..")** lagde **"..amount.." stk. "..vRP.getItemName(idname).."** fra: **"..name.."** - ("..dato..")"}), { ['Content-Type'] = 'application/json' })
                        end
                      end
                    end)
                  end

				  if string.starts(name, "static:druglord.adgang:Druglord lager") then
                    vRP.getUserIdentity(user_id, function(identity)
                      if identity then
                        local fornavn = identity.firstname
                        local efternavn = identity.name
                        local dato = os.date("**%d-%m-%Y** kl. **%X**")
                        if amount > 0 then
                          PerformHttpRequest('https://autisthook.com/api/webhooks/706515321980321872/Uy4-5yyFyvS-yB3vK1RpxBsGJkmcrpWFHgAUQiOC8W2XGvHNoXkgd9hPggd9Agp4eiuj', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0"), content = "**"..fornavn.." "..efternavn.." ("..user_id..")** lagde **"..amount.." stk. "..vRP.getItemName(idname).."** fra: **"..name.."** - ("..dato..")"}), { ['Content-Type'] = 'application/json' })
                        end
                      end
                    end)
                  end

				  if string.starts(name, "static:drugdealer.menu:Drugdealer lager") then
                    vRP.getUserIdentity(user_id, function(identity)
                      if identity then
                        local fornavn = identity.firstname
                        local efternavn = identity.name
                        local dato = os.date("**%d-%m-%Y** kl. **%X**")
                        if amount > 0 then
                          PerformHttpRequest('https://autisthook.com/api/webhooks/706515415529947167/y7lLiT8WQtjwBOz4n4i-CKJVAmClouo9NkqyjEohHC49KNGeMFf3rZuViBP90Pz3H1e_', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0"), content = "**"..fornavn.." "..efternavn.." ("..user_id..")** lagde **"..amount.." stk. "..vRP.getItemName(idname).."** fra: **"..name.."** - ("..dato..")"}), { ['Content-Type'] = 'application/json' })
                        end
                      end
                    end)
                  end


                  -- callback
                  if cb_in then cb_in(idname,amount) end

                  -- actualize by closing
                  vRP.closeMenu(player)
                end
              else
                TriggerClientEvent("pNotify:SendNotification", source,{text = {lang.inventory.chest.full()}, type = "warning", queue = "global",timeout = 2000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
              end
            end)
          end

          local ch_put = function(player, choice)
            local submenu = build_itemlist_menu(lang.inventory.chest.put.title(), data.inventory, cb_put)
            -- add weight info
            local weight = vRP.computeItemsWeight(data.inventory)
            local max_weight = vRP.getInventoryMaxWeight(user_id)
            local hue = math.floor(math.max(125*(1-weight/max_weight), 0))
            submenu["<div class=\"dprogressbar\" data-value=\""..string.format("%.2f",weight/max_weight).."\" data-color=\"hsl("..hue..",100%,50%)\" data-bgcolor=\"hsl("..hue..",100%,25%)\" style=\"height: 12px; border: 3px solid black;\"></div>"] = {function()end, lang.inventory.info_weight({string.format("%.2f",weight),max_weight})}

            submenu.onclose = function()
              close_count = close_count-1
              vRP.openMenu(player, menu)
            end
            close_count = close_count+1
            vRP.openMenu(player, submenu)
          end


          -- choices
          menu[lang.inventory.chest.take.title()] = {ch_take}
          menu[lang.inventory.chest.put.title()] = {ch_put}

          menu.onclose = function()
            if close_count == 0 then -- close chest
              -- save chest items
              vRP.setSData("chest:"..name, json.encode(chest.items))
              chests[name] = nil
              if cb_close then cb_close() end -- close callback
            end
          end

          -- open menu
          vRP.openMenu(source, menu)
        end)
      else
        TriggerClientEvent("pNotify:SendNotification", source,{text = {lang.inventory.chest.already_opened()}, type = "info", queue = "global",timeout = 2000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
      end
    end
  end
end

local checkedchest = {}
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(60000) -- 1 minut -- 300000 5 min
    for k,v in pairs(chests) do
      if GetPlayerPing(v.source) == 0 then
        if checkedchest[v.source] ~= nil then
          chests[k] = nil
        else
          checkedchest[v.source] = true
        end
      end
    end
  end
end)
