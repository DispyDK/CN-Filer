local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local htmlEntities = module("vrp", "lib/htmlEntities")

vRPbm = {}
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_basic_menu")
BMclient = Tunnel.getInterface("vRP_basic_menu","vRP_basic_menu")
vRPbsC = Tunnel.getInterface("vRP_barbershop","vRP_basic_menu")
vRPanim = Tunnel.getInterface("cn-animation","vRP_basic_menu")
Tunnel.bindInterface("vrp_basic_menu",vRPbm)

local Lang = module("vrp", "lib/Lang")
local cfg = module("vrp", "cfg/base")
local lang = Lang.new(module("vrp", "cfg/lang/"..cfg.lang) or {})

-- LOG FUNCTION
function vRPbm.logInfoToFile(file,info)
    file = io.open(file, "a")
    if file then
        file:write(os.date("%c").." => "..info.."\n")
    end
    file:close()
end
-- MAKE CHOICES
--toggle service
local choice_service = {function(player,choice)
    local user_id = vRP.getUserId({player})
    local service = "onservice"
    if user_id ~= nil then
        if vRP.hasGroup({user_id,service}) then
            vRP.removeUserGroup({user_id,service})
            if vRP.hasMission({player}) then
                vRP.stopMission({player})
            end
            vRPclient.notify(player,{"~r~Gik af arbejde"})
        else
            vRP.addUserGroup({user_id,service})
            vRPclient.notify(player,{"~g~Gik på arbejde"})
        end
    end
end, "Gå af/på arbejde"}

-- teleport waypoint
local choice_tptowaypoint = {function(player,choice)
    TriggerClientEvent("TpToWaypoint", player)
end, "Teleporter til et waypoint."}

-- fix barbershop green hair for now
local ch_fixhair = {function(player,choice)
    local custom = {}
    local user_id = vRP.getUserId({player})
    vRP.getUData({user_id,"vRP:head:overlay",function(value)
        if value ~= nil then
            custom = json.decode(value)
            vRPbsC.setOverlay(player,{custom,true})
        end
    end})
end, "Fiks babershoppen for nu!"}

--toggle blips
local ch_blips = {function(player,choice)
    TriggerClientEvent("showBlips", player)
end, "Tændt blips."}

local spikes = {}
local ch_spikes = {function(player,choice)
    local user_id = vRP.getUserId({player})
    BMclient.isCloseToSpikes(player,{},function(closeby)
        if closeby and (spikes[player] or vRP.hasPermission({user_id,"admin.spikes"})) then
            BMclient.removeSpikes(player,{})
            spikes[player] = false
        elseif closeby and not spikes[player] and not vRP.hasPermission({user_id,"admin.spikes"}) then
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Du kan kun bære et sæt sømmåtter!", type = "warning", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
        elseif not closeby and spikes[player] and not vRP.hasPermission({user_id,"admin.spikes"}) then
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Du kan kun udstyre et sæt sømmåtte!", type = "warning", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
        elseif not closeby and (not spikes[player] or vRP.hasPermission({user_id,"admin.spikes"})) then
            BMclient.setSpikesOnGround(player,{})
            spikes[player] = true
        end
    end)
end, "Smidt sømmåtter."}

local ch_sprites = {function(player,choice)
    TriggerClientEvent("showSprites", player)
end, "Tændt sprites."}


local ch_deleteveh = {function(player,choice)
    BMclient.deleteVehicleInFrontOrInside(player,{10.0})
end, "Fjern den nærmeste bil."}

--client function
local ch_crun = {function(player,choice)
    vRP.prompt({player,"Funkrion:","",function(player,stringToRun)
        stringToRun = stringToRun or ""
        TriggerClientEvent("RunCode:RunStringLocally", player, stringToRun)
    end})
end, "Kør klient funktion."}

--server function
local ch_srun = {function(player,choice)
    vRP.prompt({player,"Funktion:","",function(player,stringToRun)
        stringToRun = stringToRun or ""
        TriggerEvent("RunCode:RunStringRemotelly", stringToRun)
    end})
end, "Kør server funktion."}

--police weapons // comment out the weapons if you dont want to give weapons.
local police_weapons = {}
police_weapons["Equip"] = {function(player,choice)
    vRPclient.giveWeapons(player,{{
                                      ["WEAPON_COMBATPISTOL"] = {ammo=200},
                                      ["WEAPON_PUMPSHOTGUN"] = {ammo=200},
                                      ["WEAPON_NIGHTSTICK"] = {ammo=200},
                                      ["WEAPON_STUNGUN"] = {ammo=200}
                                  }, true})
    BMclient.setArmour(player,{100,true})
end}

--store money
local choice_store_money = {function(player, choice)
    local user_id = vRP.getUserId({player})
    if user_id ~= nil then
        local amount = vRP.getMoney({user_id})
        if vRP.tryPayment({user_id, amount}) then -- unpack the money
            vRP.giveInventoryItem({user_id, "money", amount, true})
        end
    end
end, "Gem penge i din taske."}

--medkit storage
local emergency_medkit = {}
emergency_medkit["Take"] = {function(player,choice)
    local user_id = vRP.getUserId({player})
    vRP.giveInventoryItem({user_id,"medkit",25,true})
    vRP.giveInventoryItem({user_id,"pills",25,true})
end}

--heal me
local emergency_heal = {}
emergency_heal["Heal"] = {function(player,choice)
    local user_id = vRP.getUserId({player})
    vRPclient.setHealth(player,{1000})
end}

--loot corpse
local choice_loot = {function(player,choice)
     local user_id = vRP.getUserId({player})
    if user_id ~= nil then
        vRPclient.getNearestPlayer(player,{2},function(nplayer)
            local nuser_id = vRP.getUserId({nplayer})
            if nuser_id ~= nil then
                if vRP.hasGroup({nuser_id,"Politi-Job"}) == false then
                    vRPclient.isInComa(nplayer,{}, function(in_coma)
                        if in_coma then
                            local revive_seq = {
                                {"amb@medic@standing@kneel@enter","enter",1},
                                {"amb@medic@standing@kneel@idle_a","idle_a",1},
                                {"amb@medic@standing@kneel@exit","exit",1}
                            }
                            vRPclient.playAnim(player,{false,revive_seq,false}) -- anim
                            SetTimeout(15000, function()
                                local ndata = vRP.getUserDataTable({nuser_id})
                                local fields = {}
                                if ndata ~= nil then
                                    if ndata.inventory ~= nil then -- gives inventory items
                                        vRP.clearInventory({nuser_id,false})
                                        local items = ""
                                        for k,v in pairs(ndata.inventory) do
                                            vRP.giveInventoryItem({user_id,k,v.amount,true})
                                            items = items.."\n"..k.." ("..v.amount..")"
                                        end
                                        table.insert(fields, { name = "Inventory:", value = items })
                                    end

                                    local nmoney = vRP.getMoney({nuser_id})
                                    if nmoney > 0 then
                                        if vRP.tryPayment({nuser_id,nmoney}) then
                                            vRP.giveMoney({user_id,nmoney})
                                            table.insert(fields, { name = "Penge:", value = nmoney})
                                        end
                                    end

                                    vRPclient.getWeapons(nplayer,{},function(weapons)
                                        vRPclient.giveWeapons(nplayer,{{},true})
                                        local vitems = ""
                                        for k,v in pairs(weapons) do
                                            -- convert weapons to parametric weapon items
                                            vRP.giveInventoryItem({user_id, "wbody|"..k, 1, true})
                                            vitems = vitems.."\nwbody|"..k.." (1)"
                                            if v.ammo > 0 then
                                                vitems = vitems.."\nwammo|"..k.." ("..v.ammo..")"
                                                vRP.giveInventoryItem({user_id, "wammo|"..k, v.ammo, true})
                                            end
                                        end
                                        if vitems ~= "" then table.insert(fields, { name = "Equiped:", value = vitems }) end
                                        PerformHttpRequest('https://autisthook.com/api/webhooks/597827059938623656/iLX9eifkM5iZrYz4QsEPbaRqJbhhw4MHBq389nXNaBb7FAzu_-Onsh8j7l_e4jBPS9Pm', function(err, text, headers) end, 'POST', json.encode(
                                                {
                                                    username = "Server "..GetConvar("servernumber", "0").." - Loot",
                                                    content = "**".. tostring(user_id).. "** har lige lootet **".. tostring(nuser_id) .. "**",
                                                    embeds = {
                                                        {
                                                            color = 16769280,
                                                            fields = fields
                                                        }
                                                    }
                                                }), { ['Content-Type'] = 'application/json' })
                                    end)
                                end
                            end)
                            vRPclient.stopAnim(player,{false})
                        else
                            TriggerClientEvent("pNotify:SendNotification", player,{text = "Ikke i koma!", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                        end
                    end)
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = "Du kan ikke loote en betjent!", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                end
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = "Ingen spiller nær dig", type = "info", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
            end
        end)
    end
end,"Røv den nærmeste!"}
-- STRIPS
vRP.defInventoryItem({"strip","Strips","Bruges til og binde folk",
                      function(args)
                          local choices = {}
                          choices["> Brug"] = {function(player,choice)
                              local user_id = vRP.getUserId({player})
                              if user_id ~= nil then
                                  vRPclient.getNearestPlayer(player,{1},function(nplayer)
                                      local nuser_id = vRP.getUserId({nplayer})
                                      if nuser_id ~= nil then
                                          if vRP.tryGetInventoryItem({user_id, "strip", 1, true}) then
                                              TriggerClientEvent('3dme:triggerDisplay', -1, "Binder hænder sammen", player)
                                              TriggerClientEvent("emote:startWithoutNotify", player, "høst")
                                              Wait(5000)
                                              vRPclient.setStriped(nplayer,{true})
                                              TriggerClientEvent("emote:stop", player)
                                          end
                                      else
                                          TriggerClientEvent("pNotify:SendNotification", player,{text = "Ingen personer nær dig", type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                      end
                                  end)
                                  vRP.closeMenu({player})
                              end
                          end,"Bind den nærmeste person"}

                          return choices
                      end, 0.05
})

local choice_remove_strips = {function(player,choice)
    local user_id = vRP.getUserId({player})
    vRPclient.getNearestPlayer(player,{2},function(nplayer)
        if nplayer ~= nil then
            vRPclient.isStriped(nplayer,{},function(striped)
                if striped then
                    TriggerClientEvent("cn-animation:start", player, "farm")
                    TriggerClientEvent('3dme:triggerDisplay', -1, "Fjerner strips", player)
                    Wait(10000)
                    vRPanim.getCurrentAnim(player,{},function(anim)
                        if anim == "farm" then
                            TriggerClientEvent("cn-animation:stopAnim", player)
                            vRPclient.setStriped(nplayer,{false})
                        else
                            TriggerClientEvent("pNotify:SendNotification", player,{text = "Du afbrud handling!", type = "error", queue = "global", timeout = 3000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                        end
                    end)
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = "Personen er ikke bundet!", type = "error", queue = "global", timeout = 3000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                end
            end)
        end
    end)
end,"Fjern strips fra nærmeste person" }

-- hack player
local ch_hack = {function(player,choice)
    -- get nearest player
    local user_id = vRP.getUserId({player})
    if user_id ~= nil then
        vRPclient.getNearestPlayer(player,{25},function(nplayer)
            if nplayer ~= nil then
                local nuser_id = vRP.getUserId({nplayer})
                if nuser_id ~= nil then
                    -- prompt number
                    local nbank = vRP.getBankMoney({nuser_id})
                    local amount = math.floor(nbank*0.01)
                    local nvalue = nbank - amount
                    if math.random(1,100) == 1 then
                        vRP.setBankMoney({nuser_id,nvalue})
                        vRPclient.notify(nplayer,{"Hacked ~r~".. amount .."DKK."})
                        vRP.giveInventoryItem({user_id,"dirty_money",amount,true})
                    else
                        vRPclient.notify(nplayer,{"~g~Hacking forsøg mislykkedes."})
                        vRPclient.notify(player,{"~r~Hacking forsøg mislykkedes."})
                    end
                else
                    vRPclient.notify(player,{lang.common.no_player_near()})
                end
            else
                vRPclient.notify(player,{lang.common.no_player_near()})
            end
        end)
    end
end,"Hack den nærmeste spilelr."}

-- mug player
local ch_mug = {function(player,choice)
    -- get nearest player
    local user_id = vRP.getUserId({player})
    if user_id ~= nil then
        vRPclient.getNearestPlayer(player,{10},function(nplayer)
            if nplayer ~= nil then
                local nuser_id = vRP.getUserId({nplayer})
                if nuser_id ~= nil then
                    -- prompt number
                    local nmoney = vRP.getMoney({nuser_id})
                    local amount = nmoney
                    if math.random(1,3) == 1 then
                        if vRP.tryPayment({nuser_id,amount}) then
                            vRPclient.notify(nplayer,{"Overfaldte ~r~"..amount.."DKK."})
                            vRP.giveInventoryItem({user_id,"dirty_money",amount,true})
                        else
                            vRPclient.notify(player,{lang.money.not_enough()})
                        end
                    else
                        vRPclient.notify(nplayer,{"~g~Overfald fejlet."})
                        vRPclient.notify(player,{"~r~Overfald fejlet."})
                    end
                else
                    vRPclient.notify(player,{lang.common.no_player_near()})
                end
            else
                vRPclient.notify(player,{lang.common.no_player_near()})
            end
        end)
    end
end, "Overfald den nærmeste spiller."}

-- drag player
local ch_drag = {function(player,choice)
    -- get nearest player
    local user_id = vRP.getUserId({player})
    if user_id ~= nil then
        vRPclient.getNearestPlayer(player,{10},function(nplayer)
            if nplayer ~= nil then
                local nuser_id = vRP.getUserId({nplayer})
                if nuser_id ~= nil then
                    vRPclient.canBeDragged(nplayer,{},function(handcuffed)
                        if handcuffed then
                            TriggerClientEvent("dr:drag", nplayer, player)
                        else
                            TriggerClientEvent("pNotify:SendNotification", player,{text = "Spilleren er ikke i håndjern.", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                        end
                    end)
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = "Ingen spiller nær dig", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                end
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = "Ingen spiller nær dig", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
            end
        end)
    end
end, "Løft den nærmeste spiller."}



-- drag dog
local ch_drag_dog = {function(player,choice)
    -- get nearest player
    local user_id = vRP.getUserId({player})
    if user_id ~= nil then
        vRPclient.getNearestPlayer(player,{10},function(nplayer)
            if nplayer ~= nil then
                local nuser_id = vRP.getUserId({nplayer})
                if nuser_id ~= nil then
                        if TriggerClientEvent("dr:isdog", nplayer) then
                            TriggerClientEvent("dr:drag", nplayer, player)
                        else
                            TriggerClientEvent("pNotify:SendNotification", player,{text = "Dette er ikke en hund...", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                        end
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = "Ingen hund nær dig", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                end
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = "Ingen hund nær dig", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
            end
        end)
    end
end, "Løft den nærmeste hund."}

-- Kropsvisiter spiller menu
local choice_user_check = {function(player,choice)
    vRPclient.getNearestPlayer(player,{5},function(nplayer)
        local nuser_id = vRP.getUserId({nplayer})
        if nuser_id ~= nil then
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Anmoder...", type = "info", queue = "global", timeout = 3000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
            vRP.request({nplayer,"Vil du visiteres?",30,function(nplayer,ok)
                if ok then
                    vRPclient.getWeapons(nplayer,{},function(weapons)
                        -- prepare display data (money, items, weapons)
                        local money = vRP.getMoney({nuser_id})
                        local items = ""
                        local data = vRP.getUserDataTable({nuser_id})
                        if data and data.inventory then
                            for k,v in pairs(data.inventory) do
                                local item_name = vRP.getItemName({k})
                                if item_name then
                                    items = items.."<br />"..item_name.." ("..v.amount..")"
                                end
                            end
                        end

                        local weapons_info = ""
                        for k,v in pairs(weapons) do
                            weapons_info = weapons_info.."<br />"..k.." ("..v.ammo..")"
                        end

                        vRPclient.setDiv(player,{"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info})})
                        -- request to hide div
                        vRP.request({player, "Luk vindue", 1000, function(player,ok)
                            vRPclient.removeDiv(player,{"police_check"})
                        end})
                    end)
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = "Anmodning nægtet!", type = "error", queue = "global", timeout = 3000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                end
            end})
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Ingen spiller nær dig", type = "error", queue = "global", timeout = 3000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
        end
    end)
end, "Visitere nærmeste person"}

-- player store weapons
local store_weapons_cd = {}
function storeWeaponsCooldown()
    for user_id,cd in pairs(store_weapons_cd) do
        if cd > 0 then
            store_weapons_cd[user_id] = cd - 1
        end
    end
    SetTimeout(1000,function()
        storeWeaponsCooldown()
    end)
end
storeWeaponsCooldown()

local choice_store_weapons = {function(player, choice)
            local user_id = vRP.getUserId({player})
            if (store_weapons_cd[user_id] == nil or store_weapons_cd[user_id] == 0) and user_id ~= nil then
                store_weapons_cd[user_id] = 5
                local fields = {}
              --  TriggerClientEvent('savecomponents', player)

                vRP.getUData({user_id, "vRP:attachments", function(rdata)
                    if rdata ~= nil and rdata ~= "" then
                        local ldata = json.decode(rdata)
                        if ldata == nil then
                            ldata = {}
                        end
                        for k,v in pairs(ldata) do

                          vRP.giveInventoryItem({user_id, v.item, 1, true})

                          local message = "ID: **"..user_id.." ".."**gemmer**".." 1 ".."**Stk**".." "..v.item.." ".."**attachmen**"
                          PerformHttpRequest('https://autisthook.com/api/webhooks/709548429830914096/QlHgdzK_74hXccPJmaHNwc2eXAmVV5cEyJnKsFCw5mgPsB_OcDFor7qjSZd0LolX5E-0', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0") .." - Equip ", content = message}), { ['Content-Type'] = 'application/json' })

                            --content = content.."<tr><td>"..v.reason.."</td><td>"..v.by.."</td><td>"..v.time.."</td></tr>"
                        end
                        vRP.removeUData({user_id,"vRP:attachments"})

                    else
                        --TriggerClientEvent("pNotify:SendNotification", player,{text = {"<b style='color: #DB4646'>"..reg.."</b> er ikke efterlyst"}, type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    end
                end})

                vRPclient.getWeapons(player,{},function(weapons)
                    vRPclient.giveWeapons(player,{{},true})
                    local vitems = ""
                    for k,v in pairs(weapons) do
                        -- convert weapons to parametric weapon items
                        vRP.giveInventoryItem({user_id, "wbody|"..k, 1, true})
                        vitems = vitems.."\nwbody|"..k.." (1)"
                        if v.ammo > 0 then
                            vitems = vitems.."\nwammo|"..k.." ("..v.ammo..")"
                            vRP.giveInventoryItem({user_id, "wammo|"..k, v.ammo, true})
                        end
                    end
                    if vitems ~= "" then table.insert(fields, { name = "Gemte items:", value = vitems }) end
                    PerformHttpRequest('https://autisthook.com/api/webhooks/663073434477133824/CaBjToZ84D5THD2z_kKgDMlSDA5DmBZUxC4werL-DonVtH6izHqWVtxeSO-r0O4qyw4-', function(err, text, headers) end, 'POST', json.encode(
                            {
                                username = "Server "..GetConvar("servernumber", "0").." - Gem våben",
                                content = "**".. tostring(user_id).. "** Har Lige Gemt **",
                                embeds = {
                                    {
                                        color = 16769280,
                                        fields = fields
                                    }
                                }
                            }), { ['Content-Type'] = 'application/json' })
                end)
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = "Dine våben er allerede gemt!", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
            end
end, lang.police.menu.store_weapons.description()}

-- armor item
vRP.defInventoryItem({"body_armor","Body Armor","Gem vest.",
                      function(args)
                          local choices = {}

                          choices["Equip"] = {function(player,choice)
                              local user_id = vRP.getUserId({player})
                              if user_id ~= nil then
                                      if vRP.tryGetInventoryItem({user_id, "body_armor", 1, true}) then
                                          BMclient.setArmour(player,{100,true})
                                          vRP.closeMenu({player})
                                      end
                              end
                          end}

                          return choices
                      end,
                      30.00})

-- store armor
local choice_store_armor = {function(player, choice)
    local user_id = vRP.getUserId({player})
    if user_id ~= nil then
        BMclient.getArmour(player,{},function(armour)
            if armour > 95 then
                local amount = 1
                local new_weight = vRP.getInventoryWeight({user_id})+ vRP.getItemWeight({"body_armor"})*amount
                if new_weight <= vRP.getInventoryMaxWeight({user_id}) then
                    vRP.giveInventoryItem({user_id, "body_armor", 1, true})
                    -- clear armor
                    BMclient.setArmour(player,{0,false})
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = "Din taske er fuld", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})

                end

            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = "Smadret veste kan ikke opbevares!", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
            end
        end)
    end
end, "Gem armor i din taske."}

local unjailed = {}
function jail_clock(target_id,timer)
    local target = vRP.getUserSource({tonumber(target_id)})
    local users = vRP.getUsers({})
    local online = false
    for k,v in pairs(users) do
        if tonumber(k) == tonumber(target_id) then
            online = true
        end
    end
    if online then
        if timer>0 then
            TriggerClientEvent("pNotify:SendNotification", target,{text = "Tid tilbage: " .. timer .. " minut(ter).", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
            vRP.setUData({tonumber(target_id),"vRP:jail:time",json.encode(timer)})
            TriggerClientEvent("jail:getPos", target)
            SetTimeout(60*1000, function()
                for k,v in pairs(unjailed) do -- check if player has been unjailed by cop or admin
                    if v == tonumber(target_id) then
                        unjailed[v] = nil
                        timer = 0
                    end
                end
                vRP.setHunger({tonumber(target_id), 0})
                vRP.setThirst({tonumber(target_id), 0})
                local custom = {}
                vRP.getUData({target_id,"vRP:jail:time",function(value)
                        custom = json.decode(value)
                            custom = custom - 1
                                jail_clock(tonumber(target_id),tonumber(custom))
                end})
            end)
        else
            BMclient.loadFreeze(target,{false,true,true})
            SetTimeout(15000,function()
                BMclient.loadFreeze(target,{false,false,false})
            end)

            vRPclient.teleport(target,{1846.2209472656,2585.8195800781,45.672046661377}) -- teleport to outside jail
            vRPclient.setHandcuffed(target,{false})
            TriggerClientEvent("pNotify:SendNotification", target,{text = "Du er sat fri", type = "info", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
            vRP.setUData({tonumber(target_id),"vRP:jail:time",json.encode(-1)})
        end
    end
end

-- dynamic jail
local ch_jail = {function(player,choice)
    vRPclient.getNearestPlayers(player,{15},function(nplayers)
        local user_list = ""
        for k,v in pairs(nplayers) do
            user_list = user_list .. "[" .. vRP.getUserId({k}) .. "]" .. GetPlayerName(k) .. " | "
        end
        if user_list ~= "" then
            vRP.prompt({player,"Spillere i nærheden:" .. user_list,"",function(player,target_id)
                if target_id ~= nil and target_id ~= "" then
                    vRP.prompt({player,"Fængsels tid i minutter:","1",function(player,jail_time)
                        if jail_time ~= nil and jail_time ~= "" then
                            local target = vRP.getUserSource({tonumber(target_id)})
                            if target ~= nil then
                                if tonumber(jail_time) >2000 then
                                    jail_time = 2000
                                end
                                if tonumber(jail_time) < 1 then
                                    jail_time = 1
                                end

                                vRPclient.isHandcuffed(target,{}, function(handcuffed)
                                    if handcuffed then
                                        BMclient.loadFreeze(target,{false,true,true})
                                        SetTimeout(15000,function()
                                            BMclient.loadFreeze(target,{false,false,false})
                                        end)
                                        vRPclient.teleport(target,{1793.4390869141,2483.0700683594,-122.69432067871}) -- teleport to inside jail
                                        vRPclient.setHandcuffed(target,{false})
                                        TriggerClientEvent("pNotify:SendNotification", target,{text = "Du er blevet sendt til fængsel", type = "info", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}, sounds = { sources = {"jail.ogg"}, volume = 0.5, conditions = {"docVisible"}}})
                                        TriggerClientEvent("pNotify:SendNotification", player,{text = "Du sendte en spiller til fængsel", type = "info", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                                        vRP.setHunger({tonumber(target_id),0})
                                        vRP.setThirst({tonumber(target_id),0})
                                        jail_clock(tonumber(target_id),tonumber(jail_time))
                                        local user_id = vRP.getUserId({player})
                                        PerformHttpRequest('https://autisthook.com/api/webhooks/597827247533064204/AnbAxWgaFEW6xexgAlqpL80vXHA-pWHmzz5tgWOVsho4degtCMZZJtfttAG7qJ_9DAfl', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0").." - Fængsel", content = "**"..user_id .. "** fængslet **"..target_id.."** i **" .. jail_time .. " minut(ter)**"}), { ['Content-Type'] = 'application/json' })
                                    else
                                    TriggerClientEvent("pNotify:SendNotification", player,{text = "Spilleren ikke i håndjern.", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                                    end
                                end)
                            else
                                TriggerClientEvent("pNotify:SendNotification", player,{text = "Det id virker ugyldigt", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                            end
                        else
                            TriggerClientEvent("pNotify:SendNotification", player,{text = "Fængselstiden kan ikke være tom", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                        end
                    end})
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = "Ingen spiller ID valgt", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                end
            end})
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Ingen spiller i nærheden", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
        end
    end)
end,"Send en nærgående spiller til fængsel."}

-- dynamic unjail
local ch_unjail = {function(player,choice)
    vRP.prompt({player,"Spiller ID:","",function(player,target_id)
        if target_id ~= nil and target_id ~= "" then
            vRP.getUData({tonumber(target_id),"vRP:jail:time",function(value)
                if value ~= nil then
                    custom = json.decode(value)
                    if custom ~= nil then
                        local user_id = vRP.getUserId({player})
                        if tonumber(custom) > 0 or vRP.hasPermission({user_id,"admin.easy_unjail"}) then
                            local target = vRP.getUserSource({tonumber(target_id)})
                            if target ~= nil then
                                unjailed[target] = tonumber(target_id)
                                TriggerClientEvent("pNotify:SendNotification", player,{text = "Mål vil blive frigivet snart", type = "info", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                                TriggerClientEvent("pNotify:SendNotification", target,{text = "Nogen sank din dom", type = "info", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})

                                PerformHttpRequest('https://autisthook.com/api/webhooks/597827247533064204/AnbAxWgaFEW6xexgAlqpL80vXHA-pWHmzz5tgWOVsho4degtCMZZJtfttAG7qJ_9DAfl', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0").." - Befriet", content = "**"..user_id .. "** befriet **"..target_id.."** fra sin dom på **" .. custom .. " minut(ter)**"}), { ['Content-Type'] = 'application/json' })
                            else
                                TriggerClientEvent("pNotify:SendNotification", player,{text = "Det id virker ugyldigt", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                            end
                        else
                            TriggerClientEvent("pNotify:SendNotification", player,{text = "Mål er ikke fængslet", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                        end
                    end
                end
            end})
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Ingen spiller ID valgt", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
        end
    end})
end,"Frigør en fængslet spiller."}

-- (server) called when a logged player spawn to check for vRP:jail in user_data
AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    local target = vRP.getUserSource({user_id})
    SetTimeout(35000,function()
        local custom = {}
        vRP.getUData({user_id,"vRP:jail:time",function(value)
            if value ~= nil then
                custom = json.decode(value)
                if custom ~= nil then
                    if tonumber(custom) > 0 then
                        BMclient.loadFreeze(target,{false,true,true})
                        SetTimeout(15000,function()
                            BMclient.loadFreeze(target,{false,false,false})
                        end)
                        vRPclient.teleport(target,{1797.9329833984,2482.7121582031,-122.69287872314}) -- teleport inside jail
                        vRPclient.notify(target,{"~r~Færdiggør din dom."})
                        vRP.setHunger({tonumber(user_id),0})
                        vRP.setThirst({tonumber(user_id),0})
                        jail_clock(tonumber(user_id),tonumber(custom))
                    end
                end
            end
        end})
    end)
end)

-- dynamic fine
local ch_fine = {function(player,choice)
    vRPclient.getNearestPlayers(player,{5},function(nplayers)
        local user_list = ""
        for k,v in pairs(nplayers) do
            user_list = user_list .. "[" .. vRP.getUserId({k}) .. "]" .. GetPlayerName(k) .. " | "
        end
        if user_list ~= "" then
            vRP.prompt({player,"Spillere i nærheden: " .. user_list,"",function(player,target_id)
                if target_id ~= nil and target_id ~= "" then
                    vRP.prompt({player,"Bøde værdi:","",function(player,fine)
                        if fine ~= nil and fine ~= "" then
                            vRP.prompt({player,"Bøde grund:","",function(player,reason)
                                if reason ~= nil and reason ~= "" then
                                    local target = vRP.getUserSource({tonumber(target_id)})
                                    if target ~= nil then
                                        if tonumber(fine) > 10000000 then
                                            fine = 10000000
                                        end
                                        if tonumber(fine) < 100 then
                                            fine = 100
                                        end
                                        local payment = vRP.tryBankPaymentOrDebt({tonumber(target_id), tonumber(fine)})
                                        if payment ~= false then
                                            vRP.insertPoliceRecord({tonumber(target_id), lang.police.menu.fine.record({reason,fine})})
                                            TriggerClientEvent("pNotify:SendNotification", player,{text = "Du gav en bøde på "..fine.." DKK for: "..reason, type = "info", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                                            if payment == "paid" then
                                              --local text = "Du modtog en bøde på "..fine.." DKK for: "..reason
                                              --sendMessage(text, target_id)
                                                TriggerClientEvent("pNotify:SendNotification", target,{text = "Du modtog en bøde på "..fine.." DKK for: "..reason, type = "info", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                                            else
                                              --local text = "Du modtog en bøde på "..fine.." DKK for: "..reason.."\nNuværende gæld: "..format_thousands(payment).." DKK"
                                              --sendMessage(text, target_id)
                                                TriggerClientEvent("pNotify:SendNotification", target,{text = "Du modtog en bøde på "..fine.." DKK for: "..reason.."<br>Nuværende gæld: <b style='color: #DB4646'>"..format_thousands(payment).." DKK</b>", type = "info", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                                            end
                                            local user_id = vRP.getUserId({player})
                                            PerformHttpRequest('https://autisthook.com/api/webhooks/597827394182840321/Tu8Bjs9zoTYxUmMgxPeRLZxyr1PvPCCQ-VB1WFPz7TnhLL5OyiOFhMqGkgNY6mG3Bi2o', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0").." - Bøde", content = "**"..user_id .. "** har givet en bøde til **"..target_id.."** på **" .. fine .. "** med grunden: ".. reason}), { ['Content-Type'] = 'application/json' })
                                            vRP.closeMenu({player})
                                        else
                                            TriggerClientEvent("pNotify:SendNotification", player,{text = "Ikke nok penge!", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                                        end
                                    else
                                        TriggerClientEvent("pNotify:SendNotification", player,{text = "Det id virker ugyldigt", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                                    end
                                else
                                    TriggerClientEvent("pNotify:SendNotification", player,{text = "Du kan ikke bøde uden grund", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                                end
                            end})
                        else
                            TriggerClientEvent("pNotify:SendNotification", player,{text = "Din bøde skal have en værdi", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                        end
                    end})
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = "Ingen spiller ID valgt", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                end
            end})
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Ingen spiller i nærheden", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
        end
    end)

end,"Bøder en nærgående spiller."}

-- improved handcuff
local ch_handcuff = {function(player,choice)
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
        local nuser_id = vRP.getUserId({nplayer})
        if nuser_id ~= nil then
            vRPclient.Handcuffon(nplayer,{})
            local user_id = vRP.getUserId({player})
            vRP.closeMenu({nplayer})
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Ingen spiller i nærhedn!", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
        end
    end)
end,lang.police.menu.handcuff.description()}

-- admin god mode
local gods = {}
function task_god()
    SetTimeout(10000, task_god)

    for k,v in pairs(gods) do
        vRP.setHunger({v, 0})
        vRP.setThirst({v, 0})

        local player = vRP.getUserSource({v})
        if player ~= nil then
            vRPclient.setHealth(player, {2000})
        end
    end
end
task_god()

local ch_godmode = {function(player,choice)
    local user_id = vRP.getUserId({player})
    if user_id ~= nil then
        if gods[player] then
            gods[player] = nil
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Evigt liv slået fra", type = "info", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
        else
            gods[player] = user_id
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Evigt liv aktiveret", type = "info", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
        end
    end
end, "Tænder evigt liv."}

local player_lists = {}
local ch_userlist = {function(player,choice)
    local user_id = vRP.getUserId({player})
    if user_id ~= nil then
        if player_lists[player] then -- hide
            player_lists[player] = nil
            vRPclient.removeDiv(player,{"user_list"})
        else -- show
            local content = "<span class=\"id\">ID</span><span class=\"pseudo\">STEAM NAVN</span><span class=\"name\">KARAKTER NAVN</span><span class=\"job\">ARBEJDE</span>"
            local count = 0
            local users = vRP.getUsers({})
            for k,v in pairs(users) do
                count = count+1
                local source = vRP.getUserSource({k})
                vRP.getUserIdentity({k, function(identity)
                    if source ~= nil then
                        content = content.."<br /><span class=\"id\">"..k.."</span><span class=\"pseudo\">"..vRP.getPlayerName({source}).."</span>"
                        if identity then
                            content = content.."<span class=\"name\">"..htmlEntities.encode(identity.firstname).." "..htmlEntities.encode(identity.name).."</span><span class=\"job\">"..vRP.getUserGroupByType({k,"job"}).."</span>"
                        end
                    end

                    -- check end
                    count = count-1
                    if count == 0 then
                        player_lists[player] = true
                        local css = [[
              .div_user_list{
                margin: auto;
				text-align: left;
                padding: 8px;
                width: 650px;
                margin-top: 100px;
                background: rgba(50,50,50,0.0);
                color: white;
                font-weight: bold;
                font-size: 1.1em;
              }
              .div_user_list span{
				display: inline-block;
				text-align: center;
              }
              .div_user_list .id{
                color: rgb(255, 255, 255);
                width: 45px;
              }
              .div_user_list .pseudo{
                color: rgb(66, 244, 107);
                width: 145px;
              }
              .div_user_list .name{
                color: rgb(92, 170, 249);
                width: 295px;
              }
			  .div_user_list .job{
                color: rgb(247, 193, 93);
                width: 145px;
			  }
            ]]
                        vRPclient.setDiv(player,{"user_list", css, content})
                    end
                end})
            end
        end
    end
end, "Viser spillerlisten."}

function vRPbm.chargePhoneNumber(user_id,phone)
    local player = vRP.getUserSource({user_id})
    local directory_name = vRP.getPhoneDirectoryName({user_id, phone})
    if directory_name == "unknown" then
        directory_name = phone
    end
    vRP.prompt({player,"Beløb, der skal opkræves "..directory_name..":","0",function(player,charge)
        if charge ~= nil and charge ~= "" and tonumber(charge)>0 then
            vRP.getUserByPhone({phone, function(target_id)
                if target_id~=nil then
                    if charge ~= nil and charge ~= "" then
                        local target = vRP.getUserSource({target_id})
                        if target ~= nil then
                            vRP.getUserIdentity({user_id, function(identity)
                                local my_directory_name = vRP.getPhoneDirectoryName({target_id, identity.phone})
                                if my_directory_name == "unknown" then
                                    my_directory_name = identity.phone
                                end
                                local text = "~b~" .. my_directory_name .. "~w~ kræver ~r~DKK" .. charge
                                vRP.request({target,text,600,function(req_player,ok)
                                    if ok then
                                        local target_bank = vRP.getBankMoney({target_id}) - tonumber(charge)
                                        local my_bank = vRP.getBankMoney({user_id}) + tonumber(charge)
                                        if target_bank>0 then
                                            vRP.setBankMoney({user_id,my_bank})
                                            vRP.setBankMoney({target_id,target_bank})
                                            TriggerClientEvent("pNotify:SendNotification", player,{text = "Mobilregning - Du blev betalt "..charge.. " DKK af: "..directory_name, type = "info", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                                            TriggerClientEvent("pNotify:SendNotification", target,{text = ""..my_directory_name.." har modtaget "..charge.." DKK", type = "info", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                                            --vRPbm.logInfoToFile("mchargeLog.txt",user_id .. " mobile charged "..target_id.." the amount of " .. charge .. ", user bank post-payment for "..user_id.." equals $"..my_bank.." and for "..user_id.." equals $"..target_bank)
                                            vRP.closeMenu({player})
                                        else
                                            TriggerClientEvent("pNotify:SendNotification", target,{text = "Ikke nok penge", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                                            TriggerClientEvent("pNotify:SendNotification", player,{text = ""..directory_name.." forsøgte at betale men kunne ikke!", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                                        end
                                    else
                                        TriggerClientEvent("pNotify:SendNotification", player,{text = ""..directory_name.." nægtede at betale!", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                                    end
                                end})
                            end})
                        else
                            TriggerClientEvent("pNotify:SendNotification", player,{text = "Du kan ikke skrive regninger til offline spillere", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                        end
                    else
                        TriggerClientEvent("pNotify:SendNotification", player,{text = "Din regning skal have en værdi", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                    end
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = "Det telefonnummer synes ugyldigt", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                end
            end})
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Værdien skal være større end 0.", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
        end
    end})
end

function vRPbm.payPhoneNumber(user_id,phone)
    local player = vRP.getUserSource({user_id})
    local directory_name = vRP.getPhoneDirectoryName({user_id, phone})
    if directory_name == "unknown" then
        directory_name = phone
    end
    vRP.prompt({player,"Beløb, der skal sendes til "..directory_name..":","0",function(player,transfer)
        if transfer ~= nil and transfer ~= "" and tonumber(transfer)>0 then
            vRP.getUserByPhone({phone, function(target_id)
                local my_bank = vRP.getBankMoney({user_id}) - tonumber(transfer)
                if target_id~=nil then
                    if my_bank >= 0 then
                        local target = vRP.getUserSource({target_id})
                        if target ~= nil then
                            vRP.setBankMoney({user_id,my_bank})
                            TriggerClientEvent("pNotify:SendNotification", player,{text = "Mobilepay - Du overførte "..transfer.." DKK til: "..directory_name, type = "info", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}, sounds = { sources = {"mobilepay.ogg"}, volume = 0.6, conditions = {"docVisible"}}})
                            local target_bank = vRP.getBankMoney({target_id}) + tonumber(transfer)
                            vRP.setBankMoney({target_id,target_bank})
                            local dname = "[ ID: ".. tostring(user_id).. " ] - MobilePay | Send"
                            local dmessage = "ID: **".. tostring(user_id).. "** har lige sendt  **".. tostring(transfer) .."**DKK tiL ID: **".. tostring(target_id) .."**"
                            PerformHttpRequest('https://autisthook.com/api/webhooks/597827518757863435/IZmSW2YYNi1Sqfds3Uh64b7HhGK9BXvCGy75pte8ZZvIMzMt1NzcuycCMiKOTKn-8y5R', function(err, text, headers) end, 'POST', json.encode({username = dname, content = dmessage}), { ['Content-Type'] = 'application/json' })
                            vRP.getUserIdentity({user_id, function(identity)
                                local my_directory_name = vRP.getPhoneDirectoryName({target_id, identity.phone})
                                if my_directory_name == "unknown" then
                                    my_directory_name = identity.phone
                                end
                                TriggerClientEvent("pNotify:SendNotification", target,{text = "MobilePay - Du modtog: "..transfer.." DKK fra: "..my_directory_name, type = "info", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}, sounds = { sources = {"modtaget.ogg"}, volume = 0.5, conditions = {"docVisible"}}})
                            end})
                            vRP.closeMenu({player})
                        else
                            TriggerClientEvent("pNotify:SendNotification", player,{text = "MobilePay - Du kan ikke foretage betalinger til offline spillere!", type = "warning", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                        end
                    else
                        TriggerClientEvent("pNotify:SendNotification", player,{text = "Ikke nok penge", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                    end
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = "MobilePay - Det telefonnummer synes ugyldigt.", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                end
            end})
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = "MobilePay - Værdien skal være større end 0.", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
        end
    end})
end

-- mobilepay
local ch_mobilepay = {function(player,choice)
    local user_id = vRP.getUserId({player})
    local menu = {}
    menu.name = lang.phone.directory.title()
    menu.css = {top = "75px", header_color = "rgba(0,0,255,0.75)"}
    menu.onclose = function(player) vRP.openMainMenu({player}) end -- nest menu
    menu[">Skriv telefonnummer"] = {
        -- payment function
        function(player,choice)
            vRP.prompt({player,"Telefonnummer:","00 00 00 00",function(player,phone)
                if phone ~= nil and phone ~= "" then
                    vRPbm.payPhoneNumber(user_id,phone)
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = "MobilePay - Du skal ciffer et telefonnummer.", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                end
            end})
        end,"Indtast telefonnummeret manuelt."}
    local directory = vRP.getPhoneDirectory({user_id})
    for k,v in pairs(directory) do
        menu[k] = {
            -- payment function
            function(player,choice)
                vRPbm.payPhoneNumber(user_id,v)
            end
        ,v} -- number as description
    end
    vRP.openMenu({player, menu})
end,"Overfør penge via din telefon."}

-- mobilecharge
local ch_mobilecharge = {function(player,choice)
    local user_id = vRP.getUserId({player})
    local menu = {}
    menu.name = lang.phone.directory.title()
    menu.css = {top = "75px", header_color = "rgba(0,0,255,0.75)"}
    menu.onclose = function(player) vRP.openMainMenu({player}) end -- nest menu
    menu[">Skriv telefonnummer"] = {
        -- payment function
        function(player,choice)
            vRP.prompt({player,"Telefonnummer:","00 00 00 00",function(player,phone)
                if phone ~= nil and phone ~= "" then
                    vRPbm.chargePhoneNumber(user_id,phone)
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = "MobilePay - Du skal ciffer et telefonnummer.", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                end
            end})
        end,"Indtast telefonnummeret manuelt."}
    local directory = vRP.getPhoneDirectory({user_id})
    for k,v in pairs(directory) do
        menu[k] = {
            -- payment function
            function(player,choice)
                vRPbm.chargePhoneNumber(user_id,v)
            end
        ,v} -- number as description
    end
    vRP.openMenu({player, menu})
end,"Opkræv penge via din telefon."}

-- spawn vehicle
local ch_spawnveh = {function(player,choice)
    vRP.prompt({player,"Køretøjs model:","",function(player,model)
        if model ~= nil and model ~= "" then
            BMclient.spawnVehicle(player,{model})
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Du skal skrive et køretøjsmodel", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
        end
    end})
end,"Spawn en køretøjsmodel."}

-- lockpick vehicle
local ch_lockpickveh = {function(player,choice)
    BMclient.lockpickVehicle(player,{20,true}) -- 20s to lockpick, allow to carjack unlocked vehicles (has to be true for NoCarJack Compatibility)
end,"Røv nærmeste køretøj."}

-- dynamic freeze
local ch_freeze = {function(player,choice)
    local user_id = vRP.getUserId({player})
    if vRP.hasPermission({user_id,"admin.bm_freeze"}) then
        vRP.prompt({player,"Spiller ID:","",function(player,target_id)
            if target_id ~= nil and target_id ~= "" then
                local target = vRP.getUserSource({tonumber(target_id)})
                if target ~= nil then
                    TriggerClientEvent("pNotify:SendNotification", player,{text = "Du frøs/un-frøs en spiller.", type = "info", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                    BMclient.loadFreeze(target,{true,true,true})
                    local dname = "Server "..GetConvar("servernumber", "0").."- Freeze"
                    local dmessage = "**".. tostring(user_id).. "** har lige frosset **".. tostring(target_id) .. "**"
                    PerformHttpRequest('https://autisthook.com/api/webhooks/597827662928674817/vGwjue5-Q4JNaeEIlTod3cqmFfSHCBBwKoPY_h21nsIg_AMAftD30Pq70TAE1ibGoZSO', function(err, text, headers) end, 'POST', json.encode({username = dname, content = dmessage}), { ['Content-Type'] = 'application/json' })
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = "Det id virker ugyldigt", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                end
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = "Ingen spiller ID valgt", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
            end
        end})
    else
        vRPclient.getNearestPlayer(player,{10},function(nplayer)
            local nuser_id = vRP.getUserId({nplayer})
            if nuser_id ~= nil then
                TriggerClientEvent("pNotify:SendNotification", player,{text = "Du frøs/un-frøs en spiller.", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                BMclient.loadFreeze(nplayer,{true,false,false})
            else
                vRPclient.notify(player,{lang.common.no_player_near()})
            end
        end)
    end
end,"Fryser en spiller."}

local ch_putinveh = {function(player,choice)
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
        local nuser_id = vRP.getUserId({nplayer})
        if nuser_id ~= nil then
            vRPclient.canBeDragged(nplayer,{}, function(handcuffed)  -- check handcuffed
                if handcuffed then
                    vRPclient.putInNearestVehicleAsPassenger(nplayer, {5})
                    TriggerClientEvent("dr:undrag", nplayer)
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.police.not_handcuffed()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                end
            end)
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end)
end,lang.police.menu.putinveh.description() }

--local ch_pose = {function(player,choice)
--    vRPclient.getNearestPlayer(player,{2},function(nplayer)
--        local nuser_id = vRP.getUserId({nplayer})
--        if nuser_id ~= nil then
--            if vRP.tryGetInventoryItem({user_id,"pose",1,true}) then
--                TriggerClientEvent('pose_on', nplayer)
--            end
--        else
--            TriggerClientEvent("pNotify:SendNotification", player,{text = {"Ingen spiller i nærheden"}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
--        end
--    end)
--end}

local ch_getoutveh = {function(player,choice)
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
        local nuser_id = vRP.getUserId({nplayer})
        if nuser_id ~= nil then
            vRPclient.canBeDragged(nplayer,{}, function(handcuffed)  -- check handcuffed
                if handcuffed then
                    vRPclient.ejectVehicle(nplayer, {})
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.police.not_handcuffed()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                end
            end)
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end)
end,lang.police.menu.getoutveh.description() }

local ch_fjernpose = {function(player,choice)
    vRPclient.getNearestPlayer(player,{1},function(nplayer)
        local nuser_id = vRP.getUserId({nplayer})
        if nuser_id ~= nil then
            TriggerClientEvent('pose_off', nplayer)
            TriggerClientEvent("pNotify:SendNotification", player,{text = {"Fjerner posen fra den nærmeste person"}, type = "info", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end)
end,}

vRP.defInventoryItem({"repairkit","Værktøjs kasse","Bruges til at reparere køretøjer",
                      function(args)
                          local choices = {}

                          choices["> Reparer køretøj"] = {function(player,choice)
                              local user_id = vRP.getUserId({player})
                              local mechlvl = math.floor(vRP.expToLevel({vRP.getExp({user_id,"science","mechanic"})}))
                              if mechlvl > 0 then
                                  vRPclient.getNearestVehicleHealth(player,{3},function(vehicle)
                                      if vehicle.veh ~= 0 and vehicle.health < 200 then
                                          if vRP.tryGetInventoryItem({user_id,"repairkit",1,true}) then
                                              TriggerClientEvent("3dme:remoteDisplay",player,"Reparer køretøj",3,(180/mechlvl),180)
                                              vRPclient.playAnim(player,{false,{task="WORLD_HUMAN_VEHICLE_MECHANIC"},false})
                                              SetTimeout((180000/mechlvl), function()
                                                  vRPclient.stopAnim(player,{false})
                                                  vRPclient.lowfixNearestVehicle(player,{vehicle.veh})
                                              end)
                                          end
                                      elseif vehicle.veh == 0 then
                                          TriggerClientEvent("pNotify:SendNotification", player,{text = {"Kunne ikke finde noget køretøj"}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                      elseif vehicle.health >= 200 then
                                          TriggerClientEvent("pNotify:SendNotification", player,{text = {"Køretøjet kan ikke repareres"}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                      end
                                  end)
                              else
                                  TriggerClientEvent("pNotify:SendNotification", player,{text = {"Du skal have lært og lave køretøjer først!"}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                              end
                          end,"Reparer nærmeste køretøj"}

                          return choices
                      end, 5.00
})

-- lockpicking item
vRP.defInventoryItem({"lockpicking_kit","Bil Kit","Bliver brugt til at røve biler.", -- add it for sale to vrp/cfg/markets.lua if you want to use it
                      function(args)
                          local choices = {}

                          choices["Lockpick"] = {function(player,choice)
                              local user_id = vRP.getUserId({player})
                              if user_id ~= nil then
                                  if vRP.tryGetInventoryItem({user_id, "lockpicking_kit", 1, true}) then
                                      BMclient.lockpickVehicle(player,{20,true}) -- 20s to lockpick, allow to carjack unlocked vehicles (has to be true for NoCarJack Compatibility)
                                      vRP.closeMenu({player})
                                  end
                              end
                          end,"Røv den nærmeste bil."}

                          return choices
                      end,
                      5.00})




-- ADD STATIC MENU CHOICES // STATIC MENUS NEED TO BE ADDED AT vRP/cfg/gui.lua
vRP.addStaticMenuChoices({"police_weapons", police_weapons}) -- police gear
vRP.addStaticMenuChoices({"emergency_medkit", emergency_medkit}) -- pills and medkits
vRP.addStaticMenuChoices({"emergency_heal", emergency_heal}) -- heal button


---- Kys en person
local choice_kiss = {function(player,choice)
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id ~= nil then
            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.police.menu.kiss.asked()}, type = "info", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            vRP.request(nplayer,lang.police.menu.kiss.request(),15,function(nplayer,ok)
                if ok then
                  vRPclient.playAnim(player, {true, {{"mp_ped_interaction", "kisses_guy_a", 1}}, false})
                  vRPclient.playAnim(player, {true, {{"mp_ped_interaction", "kisses_guy_b", 1}}, false})
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.request_refused()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                end
            end)
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end)
end, lang.police.menu.kiss.description()}


-- REMEMBER TO ADD THE PERMISSIONS FOR WHAT YOU WANT TO USE
-- CREATES PLAYER SUBMENU AND ADD CHOICES
local ch_player_menu = {function(player,choice)
    local user_id = vRP.getUserId({player})
    local menu = {}
    menu.name = "Funktioner"
    menu.css = {top = "75px", header_color = "rgba(0,0,255,0.75)"}
    menu.onclose = function(player) vRP.openMainMenu({player}) end -- nest menu

    if vRP.hasPermission({user_id,"player.store_money"}) then
        menu["GEM PENGE"] = choice_store_money -- transforms money in wallet to money in inventory to be stored in houses and cars
    end

    if vRP.hasPermission({user_id,"player.loot"}) then
        menu["LOOT"] = choice_loot_items -- take the items of nearest player in coma
    end

    if vRP.hasPermission({user_id,"player.fix_haircut"}) then
        menu["FIX HÅR"] = ch_fixhair -- just a work around for barbershop green hair bug while I am busy
    end

    if vRP.hasPermission({user_id,"player.userlist"}) then
        menu["User List"] = ch_userlist -- a user list for players with vRP ids, player name and identity names only.
    end

    if vRP.hasPermission({user_id,"player.store_weapons"}) then
        menu["GEM VÅBEN"] = choice_store_weapons -- store player weapons, like police store weapons from vrp
    end

    -- if vRP.hasPermission({user_id,"player.store_armor"}) then
    --     menu["GEM RUSTNING"] = choice_store_armor -- store player armor
    -- end

    if vRP.hasPermission({user_id,"player.check"}) then
        menu["KROPSVISITER"] = choice_user_check -- checks nearest player inventory, like police check from vrp
    end

    if vRP.hasPermission({user_id,"player.strip"}) then
        menu["LØFT/TAG FAT I"] = ch_drag
        menu["FJERN POSE"] = ch_fjernpose
        menu["FJERN STRIPS"] = choice_remove_strips
        menu["GEM PENGE"] = choice_store_money -- transforms money in wallet to money in inventory to be stored in houses and cars
        -- menu["Bed om kys"] = choice_kiss
        menu[lang.police.menu.putinveh.title()] = ch_putinveh
        menu[lang.police.menu.getoutveh.title()] = ch_getoutveh
    end

    vRP.openMenu({player, menu})
end}

-- REGISTER MAIN MENU CHOICES
vRP.registerMenuBuilder({"main", function(add, data)
    local user_id = vRP.getUserId({data.player})
    if user_id ~= nil then
        local choices = {}

        if vRP.hasPermission({user_id,"player.player_menu"}) then
            choices["FUNKTIONER"] = ch_player_menu -- opens player submenu
        end

        if vRP.hasPermission({user_id,"mugger.mug"}) then
            choices["OVERFALD"] = ch_mug -- steal nearest player wallet
        end

        if vRP.hasPermission({user_id,"hacker.hack"}) then
            choices["HACK"] = ch_hack --  1 in 100 chance of stealing 1% of nearest player bank
        end

        if vRP.hasPermission({user_id,"toggle.service"}) then
            --choices["Missioner fra/til"] = choice_service -- toggle the receiving of missions
            choices[lang.mission.cancel.title()] = {function(player,choice)
                vRP.stopMission({player})
            end}
        end

        add(choices)
    end
end})

-- RESGISTER ADMIN MENU CHOICES
vRP.registerMenuBuilder({"admin", function(add, data)
    local user_id = vRP.getUserId({data.player})
    if user_id ~= nil then
        local choices = {}

        if vRP.hasPermission({user_id,"admin.deleteveh"}) then
            choices["@DeleteVeh"] = ch_deleteveh -- Delete nearest vehicle (Fixed pull request https://github.com/Sighmir/vrp_basic_menu/pull/11/files/419405349ca0ad2a215df90cfcf656e7aa0f5e9c from benjatw)
        end

        if vRP.hasPermission({user_id,"admin.spawnveh"}) then
            choices["@SpawnVeh"] = ch_spawnveh -- Spawn a vehicle model
        end

        if vRP.hasPermission({user_id,"admin.godmode"}) then
            choices["@Godmode"] = ch_godmode -- Toggles admin godmode (Disable the default admin.god permission to use this!)
        end

        if vRP.hasPermission({user_id,"player.blips"}) then
            choices["@Blips"] = ch_blips -- turn on map blips and sprites
        end

        if vRP.hasPermission({user_id,"player.sprites"}) then
            choices["@Sprites"] = ch_sprites -- turn on only name sprites
        end

        if vRP.hasPermission({user_id,"admin.crun"}) then
            choices["@Crun"] = ch_crun -- run any client command, any GTA V client native http://www.dev-c.com/nativedb/
        end

        if vRP.hasPermission({user_id,"admin.srun"}) then
            choices["@Srun"] = ch_srun -- run any server command, any GTA V server native http://www.dev-c.com/nativedb/
        end

        if vRP.hasPermission({user_id,"player.tptowaypoint"}) then
            choices["@TpToWaypoint"] = choice_tptowaypoint -- teleport user to map blip
        end

        if vRP.hasPermission({user_id,"admin.easy_unjail"}) then
            choices["@UnJail"] = ch_unjail -- Un jails chosen player if he is jailed (Use admin.easy_unjail as permission to have this in admin menu working in non jailed players)
        end

        if vRP.hasPermission({user_id,"admin.spikes"}) then
            choices["@Spikes"] = ch_spikes -- Toggle spikes
        end

        if vRP.hasPermission({user_id,"admin.bm_freeze"}) then
            choices["@Freeze"] = ch_freeze -- Toggle freeze
        end

        add(choices)
    end
end})

-- REGISTER POLICE MENU CHOICES
vRP.registerMenuBuilder({"police", function(add, data)
    local user_id = vRP.getUserId({data.player})
    if user_id ~= nil then
        local choices = {}

        if vRP.hasPermission({user_id,"police.store_money"}) then
            choices["GEM PENGE"] = choice_store_money -- transforms money in wallet to money in inventory to be stored in houses and cars
        end

        if vRP.hasPermission({user_id,"police.easy_jail"}) then
            choices["FÆNGSEL"] = ch_jail -- Send a nearby handcuffed player to jail with prompt for choice and user_list
        end

        if vRP.hasPermission({user_id,"police.easy_unjail"}) then
            choices["LØSLAD"] = ch_unjail -- Un jails chosen player if he is jailed (Use admin.easy_unjail as permission to have this in admin menu working in non jailed players)
        end

        if vRP.hasPermission({user_id,"police.easy_fine"}) then
            choices["BØDE"] = ch_fine -- Fines closeby player
        end

        if vRP.hasPermission({user_id,"police.easy_cuff"}) then
            choices["HÅNDJERN"] = ch_handcuff -- Toggle cuffs AND CLOSE MENU for nearby player
        end

        if vRP.hasPermission({user_id,"police.drag"}) then
            choices["LØFT/TAG FAT I"] = ch_drag -- Drags closest handcuffed player
        end

        if vRP.hasPermission({user_id,"police.drag"}) then
            choices["LØFT/SLIP HUND"] = ch_drag_dog -- Drags closest handcuffed player
        end
        if vRP.hasPermission({user_id,"police.bm_freeze"}) then
            choices["FRYS"] = ch_freeze -- Toggle freeze
        end

        add(choices)
    end
end})

-- REGISTER PHONE MENU CHOICES
-- TO USE THIS FUNCTION YOU NEED TO HAVE THE ORIGINAL vRP UPDATED TO THE LASTEST VERSION
vRP.registerMenuBuilder({"phone", function(add) -- phone menu is created on server start, so it has no permissions.
    local choices = {} -- Comment the choices you want to disable by adding -- in front of them.

    choices["MOBILEPAY"] = ch_mobilepay -- transfer money through phone
    choices["MOBILEPAY - OPKRÆV"] = ch_mobilecharge -- charge money through phone

    add(choices)
end})

function format_thousands(v)
    local s = string.format("%d", math.floor(v))
    local pos = string.len(s) % 3
    if pos == 0 then pos = 3 end
    return string.sub(s, 1, pos)
            .. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end
