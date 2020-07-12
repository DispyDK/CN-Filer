
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

local Tunnel = module("vrp", "lib/Tunnel")
vRPclient = Tunnel.getInterface("vRP","cn-logging")

local cfg = module("cn-logging", "config")

local logusers = {}

-- Giver depositOnLogin penge
AddEventHandler("vRP:playerSpawn",function(user_id,source,last_login)
    if user_id ~= nil then
        MySQL.Async.fetchAll("SELECT * FROM logging WHERE user_id = @user_id", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then
                MySQL.Async.fetchAll("SELECT wallet,bank,debt FROM vrp_user_moneys WHERE user_id = @user_id", {user_id = user_id}, function(money, affected)
                    local rolled = false
                    local wallet = 0
                    local bank = 0
                    if #money > 0 then
                        wallet = money[1].wallet
                        bank = money[1].bank
                    end
                    if bank ~= rows[1].bank or wallet ~= rows[1].wallet then
                       rolled = true
                    end
                    local fields = {}
                    if wallet ~= rows[1].wallet then
                        table.insert(fields, { name = "Wallet før:", value = rows[1].wallet, inline = true })
                        table.insert(fields, { name = "Wallet after:", value = wallet, inline = true })
                        table.insert(fields, { name = "Wallet forskel:", value = math.abs(rows[1].wallet-wallet), inline = true })
                    end
                    if bank ~= rows[1].bank then
                        table.insert(fields, { name = "Bank før:", value = rows[1].bank, inline = true })
                        table.insert(fields, { name = "Bank efter:", value = bank, inline = true })
                        table.insert(fields, { name = "Bank forskel:", value = math.abs(rows[1].bank-bank), inline = true })
                    end

                    -- INVENTORY CHECK

                    local data = vRP.getUserDataTable({user_id})
                    local inventory = data.inventory
                    local weapons = data.weapons

                    local beforeinv = json.decode(rows[1].inventory)

                    local oitems = ""
                    local nitems = ""

                    local beforeitems = ""
                    for k,v in pairs(beforeinv) do
                        beforeitems = beforeitems.."\n"..k.." ("..v.amount..")"
                        if not hasIndex(inventory, k) then
                            oitems = oitems.."\n"..k.." ("..v.amount..")"
                        elseif v.amount > inventory[k].amount then
                            oitems = oitems.."\n"..k.." ("..math.abs(v.amount - inventory[k].amount)..")"
                        elseif v.amount < inventory[k].amount then
                            nitems = nitems.."\n"..k.." ("..math.abs(v.amount - inventory[k].amount)..")"
                        end
                    end

                    local afteritems = ""
                    for k,v in pairs(inventory) do
                        afteritems = afteritems.."\n"..k.." ("..v.amount..")"
                        if not hasIndex(beforeinv, k) then
                            nitems = nitems.."\n"..k.." ("..v.amount..")"
                        end
                    end

                    if oitems ~= "" or nitems ~= "" then
                        if beforeitems == "" then
                            beforeitems = "Ingen"
                        end
                        if afteritems == "" then
                            afteritems = "Ingen"
                        end
                        table.insert(fields, { name = "Inventory før:", value = beforeitems })
                        table.insert(fields, { name = "Inventory efter:", value = afteritems })
                        if oitems ~= "" then table.insert(fields, { name = "Items mistet:", value = oitems }) end
                        if nitems ~= "" then table.insert(fields, { name = "Items fået:", value = nitems }) end
                        rolled = true
                    end

                    -- WEAPON CHECK

                    local beforeweapon = json.decode(rows[1].weapons)

                    local oweapons = ""
                    local nweapons = ""

                    local beforeweapons = ""
                    if beforeweapon then
                      for k,v in pairs(beforeweapon) do
                          beforeweapons = beforeweapons.."\n"..k.." ("..v.ammo..")"
                          if not hasIndex(weapons, k) then
                              oweapons = oweapons.."\n"..k.." ("..v.ammo..")"
                          elseif v.ammo > weapons[k].ammo then
                              oweapons = oweapons.."\n"..k.." ("..math.abs(v.ammo - weapons[k].ammo)..")"
                          elseif v.ammo < weapons[k].ammo then
                              nweapons = nweapons.."\n"..k.." ("..math.abs(v.ammo - weapons[k].ammo)..")"
                          end
                      end
                    end
                    local afterweapons = ""
                    for k,v in pairs(weapons) do
                        afterweapons = afterweapons.."\n"..k.." ("..v.ammo..")"
                        if not hasIndex(beforeweapon, k) then
                            nweapons = nweapons.."\n"..k.." ("..v.ammo..")"
                        end
                    end

                    if oweapons ~= "" or nweapons ~= "" then
                        if beforeweapons == "" then
                            beforeweapons = "Ingen"
                        end
                        if afterweapons == "" then
                            afterweapons = "Ingen"
                        end
                        table.insert(fields, { name = "Våben før:", value = beforeweapons })
                        table.insert(fields, { name = "Våben efter:", value = afterweapons })
                        if oweapons ~= "" then table.insert(fields, { name = "Våben mistet:", value = oweapons }) end
                        if nweapons ~= "" then table.insert(fields, { name = "Våben fået:", value = nweapons }) end
                        rolled = true
                    end
                    if rolled then
                        local ibweapons = rows[1].weapons
                        if ibweapons == "[]" then
                            ibweapons = "{}"
                        end

                        local iaweapons = json.encode(weapons)
                        if iaweapons == "[]" then
                            iaweapons = "{}"
                        end

                        local ibinventory = rows[1].inventory
                        if ibinventory == "[]" then
                            ibinventory = "{}"
                        end

                        local iainventory = json.encode(inventory)
                        if iainventory == "[]" then
                            iainventory = "{}"
                        end

                        -- MySQL.Async.fetchAll("INSERT INTO rollback(user_id, before_wallet, after_wallet, before_bank, after_bank, before_weapons, after_weapons, before_inventory, after_inventory) VALUES (@user_id,@before_wallet,@after_wallet,@before_bank,@after_bank,@before_weapons,@after_weapons,@before_inventory,@after_inventory)", {user_id = user_id, before_wallet = rows[1].wallet, after_wallet = wallet, before_bank = rows[1].bank, after_bank = bank, before_weapons = ibweapons, after_weapons = iaweapons, before_inventory = ibinventory, after_inventory = iainventory})

                        PerformHttpRequest('https://autisthook.com/api/webhooks/597827905338343444/7k6JvwsQ4qKring1pDrZSI5ypOJuVa5Lt9eS45uGU5bgD1anW19e3TtBLXDruOb3MmD4', function(err, text, headers) end, 'POST', json.encode(
                            {
                                username = "Server "..GetConvar("servernumber", "0"),
                                content = "Spiller: "..user_id.." har muligvis fået rollback",
                                embeds = {
                                    {
                                        color = 16769280,
                                        fields = fields
                                    }
                                }
                            }), { ['Content-Type'] = 'application/json' })
                    end
                    logusers[user_id] = true
                end)
            end
        end)
        Citizen.Wait(100)
        MySQL.Async.fetchAll("SELECT depositOnLogin FROM vrp_user_moneys WHERE user_id = @user_id", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then
                if rows[1].depositOnLogin > 0 then
                    vRP.giveBankMoney({user_id,tonumber(rows[1].depositOnLogin)})
                    MySQL.Async.fetchAll("UPDATE vrp_user_moneys SET depositOnLogin = @deposit WHERE user_id = @user_id", {user_id = user_id, deposit = 0})
                end
            end
        end)
    end
end)

function hasIndex(tab,key)
    return tab[key] ~= nil
end

AddEventHandler("vRP:playerLeave",function(user_id, source)
    saveUser(user_id)
    logusers[user_id] = nil
end)
AddEventHandler("logging:saveUser",function(user_id)
    if logusers[user_id] ~= nil then
        saveUser(user_id)
    end
end)

function saveUser(user_id)
    if user_id ~= nil then
        local data = vRP.getUserDataTable({user_id});
        local inventory = json.encode(data.inventory)
        local weapons =  json.encode(data.weapons)
        if inventory == "[]" then
            inventory = "{}"
        end
        if weapons == "[]" then
            weapons = "{}"
        end
        local tmp = vRP.getUserTmpTable({user_id})
        MySQL.Async.fetchAll("SELECT * FROM logging WHERE user_id = @user_id", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then
                MySQL.Async.fetchAll("UPDATE logging SET wallet=@wallet,bank=@bank,weapons=@weapons,inventory=@inventory,time=CURRENT_TIMESTAMP() WHERE user_id = @user_id", {user_id = user_id, wallet = tmp.wallet, bank = tmp.bank, weapons = weapons, inventory = inventory})
            else
                MySQL.Async.fetchAll("INSERT INTO logging(user_id, wallet, bank, weapons, inventory) VALUES (@user_id,@wallet,@bank,@weapons,@inventory)", {user_id = user_id, wallet = tmp.wallet, bank = tmp.bank, weapons = weapons, inventory = inventory})
            end
        end)
    end
end

function saveAllUsers()
    local stoppedmsg = vRP.getServerStatus()
    local users = vRP.getUsers({})
    print(cfg.Prefix.." Vent venligst med at lukke serveren")
    for k,v in pairs(users) do
        if v ~= nil then
            DropPlayer(v,cfg.Prefix.." Serveren er igang med at "..stoppedmsg)
            print(cfg.Prefix.." "..k.." blev smidt ud")
            Wait(500)
        end
    end
    print(cfg.Prefix.." Udsmidning færdig, du kan nu lukke serveren!")
end


local Time = {}

function timer()

    Time.h = tonumber(os.date("%H", os.time() ))
    Time.m = tonumber(os.date("%M", os.time() ))
    Time.s = tonumber(os.date("%S", os.time() ))

    if Time.h == 05 and Time.m == 50 and Time.s == 00 then
        local reason = "Daglig restart"
        local type = ""
        print(cfg.Prefix.." "..type.." om 10 minutter, grundet ..string.lower(reason)")
        TriggerClientEvent("chatMessage", -1, "^4"..cfg.Prefix.." ^3Serveren "..string.lower(type).." om 10 minutter, grundet ".. string.lower(reason))
        SetTimeout(300000, function()
            print(cfg.Prefix.." "..type.." om 5 minutter, grundet ..string.lower(reason)")
            TriggerClientEvent("chatMessage", -1, "^4"..cfg.Prefix.." ^3Serveren "..string.lower(type).." om 5 minutter, grundet ".. string.lower(reason))
            SetTimeout(120000, function()
                TriggerClientEvent("chatMessage", -1, "^4"..cfg.Prefix.." ^3Serveren "..string.lower(type).." om 3 minutter, grundet" ..string.lower(reason))
                print(cfg.Prefix.." "..type.." om 3 minutter, grundet ".. string.lower(reason))
                SetTimeout(120000, function()
                    TriggerClientEvent("chatMessage", -1, "^4"..cfg.Prefix.." ^3Serveren "..string.lower(type).." om 1 minut, grundet" ..string.lower(reason))
                    print(cfg.Prefix.." "..type.." om 1 minutter, grundet ".. string.lower(reason))
                    SetTimeout(30000, function()
                        TriggerClientEvent("chatMessage", -1, "^4"..cfg.Prefix.." ^3Serveren "..string.lower(type).." om 30 sekunder, grundet" ..string.lower(reason))
                        print(cfg.Prefix.." "..type.." om 30 sekunder, grundet ".. string.lower(reason))
                        SetTimeout(30000, function()
                            print(cfg.Prefix.." Påbegynder udsmidning af spillere!")
                            saveAllUsers()
                        end)
                    end)
                end)
            end)
        end)
     elseif  Time.h == 14 and Time.m == 50 and Time.s == 00 then
        local reason = "Daglig restart"
        local type = ""
        print(cfg.Prefix.." "..type.." om 10 minutter, grundet ..string.lower(reason)")
        TriggerClientEvent("chatMessage", -1, "^4"..cfg.Prefix.." ^3Serveren "..string.lower(type).." om 10 minutter, grundet ".. string.lower(reason))
        SetTimeout(300000, function()
            print(cfg.Prefix.." "..type.." om 5 minutter, grundet ..string.lower(reason)")
            TriggerClientEvent("chatMessage", -1, "^4"..cfg.Prefix.." ^3Serveren "..string.lower(type).." om 5 minutter, grundet ".. string.lower(reason))
            SetTimeout(120000, function()
                TriggerClientEvent("chatMessage", -1, "^4"..cfg.Prefix.." ^3Serveren "..string.lower(type).." om 3 minutter, grundet" ..string.lower(reason))
                print(cfg.Prefix.." "..type.." om 3 minutter, grundet ".. string.lower(reason))
                SetTimeout(120000, function()
                    TriggerClientEvent("chatMessage", -1, "^4"..cfg.Prefix.." ^3Serveren "..string.lower(type).." om 1 minut, grundet" ..string.lower(reason))
                    print(cfg.Prefix.." "..type.." om 1 minutter, grundet ".. string.lower(reason))
                    SetTimeout(30000, function()
                        TriggerClientEvent("chatMessage", -1, "^4"..cfg.Prefix.." ^3Serveren "..string.lower(type).." om 30 sekunder, grundet" ..string.lower(reason))
                        print(cfg.Prefix.." "..type.." om 30 sekunder, grundet ".. string.lower(reason))
                        SetTimeout(30000, function()
                            print(cfg.Prefix.." Påbegynder udsmidning af spillere!")
                            saveAllUsers()
                        end)
                    end)
                end)
            end)
        end)
    end

end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        timer()
    end
end)



AddEventHandler('rconCommand', function(commandName, args)
    if commandName == "safestop" then
        CancelEvent()
        if args[1] == "restart" or args[1] == "close" and args[2] then

          reason = ""
          Count = 0
          for Index, Value in pairs( args ) do
            Count = Count + 1
            if Count >= 2 then
              reason = reason .. " " .. args[Count]
            end
          end

            ExecuteCommand("sv_maxClients 1")
            local servername = cfg.ServerName:gsub("%%number", GetConvar("servernumber", 0))
            local type = ""
            if args[1] == "restart" then
                servername = servername:gsub("%%reason", cfg.Restart)
                type = "Genstarter"
                vRP.setServerStatus({cfg.Restart})
            elseif args[1] == "close" then
                servername = servername:gsub("%%reason", cfg.Close)
                type = "Lukker"
                vRP.setServerStatus({cfg.Close})
            end
            ExecuteCommand('sv_hostname "'..servername..'"')
            print(cfg.Prefix.." "..type.." om 10 minutter, grundet ..string.lower(reason)")
            TriggerClientEvent("chatMessage", -1, "^4"..cfg.Prefix.." ^3Serveren "..string.lower(type).." om 10 minutter, grundet ".. string.lower(reason))
            SetTimeout(300000, function()
                print(cfg.Prefix.." "..type.." om 5 minutter, grundet ..string.lower(reason)")
                TriggerClientEvent("chatMessage", -1, "^4"..cfg.Prefix.." ^3Serveren "..string.lower(type).." om 5 minutter, grundet ".. string.lower(reason))
                SetTimeout(120000, function()
                    TriggerClientEvent("chatMessage", -1, "^4"..cfg.Prefix.." ^3Serveren "..string.lower(type).." om 3 minutter, grundet" ..string.lower(reason))
                    print(cfg.Prefix.." "..type.." om 3 minutter, grundet ".. string.lower(reason))
                    SetTimeout(120000, function()
                        TriggerClientEvent("chatMessage", -1, "^4"..cfg.Prefix.." ^3Serveren "..string.lower(type).." om 1 minut, grundet" ..string.lower(reason))
                        print(cfg.Prefix.." "..type.." om 1 minutter, grundet ".. string.lower(reason))
                        SetTimeout(30000, function()
                            TriggerClientEvent("chatMessage", -1, "^4"..cfg.Prefix.." ^3Serveren "..string.lower(type).." om 30 sekunder, grundet" ..string.lower(reason))
                            print(cfg.Prefix.." "..type.." om 30 sekunder, grundet ".. string.lower(reason))
                            SetTimeout(30000, function()
                                print(cfg.Prefix.." Påbegynder udsmidning af spillere!")
                                saveAllUsers()
                            end)
                        end)
                    end)
                end)
            end)
        end
    end
end)
