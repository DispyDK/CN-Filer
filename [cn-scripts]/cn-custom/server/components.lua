--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 21-03-2019
-- Time: 17:35
-- Made for CiviliansNetwork
--

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")


vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_revive")

RegisterServerEvent('giveback')
AddEventHandler('giveback', function(item)
  local user_id = vRP.getUserId({source})
  vRP.giveInventoryItem({user_id, item, 1, true})

end)
