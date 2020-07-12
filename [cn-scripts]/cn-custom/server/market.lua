
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")


vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_revive")

RegisterServerEvent("gumpher:openChest")
AddEventHandler("gumpher:openChest", function(item)
  print(item)
  vRP.openChest({source, "gumpher:"..item, 60, nil, nil, nil})
end)
