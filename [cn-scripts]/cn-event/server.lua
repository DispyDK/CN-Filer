local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","cn-event")


RegisterServerEvent('event:start')
AddEventHandler('event:start', function()
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
		TriggerClientEvent('event:makeTheMarker', -1)
	end)

RegisterCommand('event', function(source, name)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	print(user_id)
	if (user_id == 107) then
		TriggerEvent('event:start', player)
	else
		print("Nænænæ det må du ikke! " .. user_id)
	end
end)
