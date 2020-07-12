local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")


RegisterServerEvent('bilforhandler:getvehicle')
AddEventHandler('bilforhandler:getvehicle', function(vehicle)
    local user_id = vRP.getUserId({source})
    MySQL.Async.fetchAll("SELECT stock FROM bilforhandler WHERE vehicle = @vehicle", {vehicle = vehicle}, function(rows, affected)
        if #rows > 0 then
            for k,v in pairs(rows) do
                --print(v.stock)
                if v.stock < 5 then
                    MySQL.Async.execute("UPDATE bilforhandler SET stock = (stock+1) WHERE vehicle = @vehicle", {vehicle = vehicle})
                    vRP.giveBankMoney({user_id,10000, true})
                    TriggerClientEvent("pNotify:SendNotification", user_id,{text = "10000 DKK blev overført til din konto",type = "info",timeout = (2000),layout = "bottomRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                else
                    TriggerClientEvent("pNotify:SendNotification", user_id,{text = "Blev ikke added <b>STOCK</b> = 5",type = "info",timeout = (2000),layout = "bottomRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                end
            end
        end
    end)
end)


RegisterServerEvent('bilforhandler:spawnvehicle')
AddEventHandler('bilforhandler:spawnvehicle', function(player)
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
    if vRP.hasGroup({user_id,"Bilforhandler"}) or vRP.hasGroup({user_id,"Bilforhandler Chef"}) then
        vRP.prompt({player,"Bilen's modelnavn f.eks. police3:","",function(player,veh)
            if veh ~= "" then
                TriggerClientEvent("bilforhandler:spawnvehicle",player,veh)
            end
        end})
    end
end)


RegisterServerEvent('bilforhandler:spawncarvehicle')
AddEventHandler('bilforhandler:spawncarvehicle', function(player)
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
    if vRP.hasGroup({user_id,"Bilforhandler"}) or vRP.hasGroup({user_id,"Bilforhandler Chef"}) then
        vRP.prompt({player,"Bilen's modelnavn f.eks. police3:","",function(player,veh)
        print("Test")
            if veh ~= "" then
              print(veh)
              MySQL.Async.fetchAll("SELECT stock FROM bilforhandler WHERE vehicle = @vehicle", {vehicle = veh}, function(rows, affected)
                  if #rows > 0 then
                    print("rows")
                      for k,v in pairs(rows) do
                          print(v.stock)
                          if v.stock ~= 0 then
                              TriggerClientEvent("bilforhandler:spawncarvehicle",player,veh)
                          else
                              TriggerClientEvent("pNotify:SendNotification", player, {text = "Bilen er ikke på lager",type = "info",timeout = (2000),layout = "bottomRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                          end
                      end
                  end
              end)
            end
        end})
    end
end)
