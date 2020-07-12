--# Written by koil
--# Web - nopixel.net
--# Twitch - twitch.tv/koil
--# Twitter - twitter.com/itskoil
--# Contact - koiltwitch@gmail.com
--# You can modify, do what you wish with it just dont claim it as your own. (not that its worthy)
-- ###################################



local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRPgf = {}
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_golf")
Tunnel.bindInterface("vrp_golf",vRPgf)

function vRPgf.payGolf()
  local source = source
  local user_id = vRP.getUserId({source})
  local player = vRP.getUserSource({user_id})
  if vRP.tryPayment({user_id, 1000}) then
	  TriggerClientEvent('chatMessage', source, "SERVER", {255, 0, 0}, "Du har betalt: ^2 1000 DKK.")
	  return true
  else
      TriggerClientEvent('chatMessage', source, "SERVER", {255, 0, 0}, "Du har ikke nok penge!")
	  return false
  end
end
