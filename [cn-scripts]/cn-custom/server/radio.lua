local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")


vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_revive")

RegisterCommand('radio', function(source, args)
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
      local ped = GetPlayerPed(source)
      frekvens = parseInt(args[1])
      if frekvens < 6 then frekvens = 0 end
      if vRP.hasInventoryItem({user_id, "radio"}) then
        local radio = frekvens
        TriggerClientEvent("joinRadio",player,radio,type,player)
      end
end)

RegisterCommand('leave', function(source, args)
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
      local ped = GetPlayerPed(source)
      frekvens = parseInt(args[1])
      if frekvens == 1 or frekvens == 2 then frekvens = 0 end
      if vRP.hasInventoryItem({user_id, "radio"}) then
        local radio = frekvens
        TriggerClientEvent("leaveRadio",player,radio,type,player)
      end
end)
