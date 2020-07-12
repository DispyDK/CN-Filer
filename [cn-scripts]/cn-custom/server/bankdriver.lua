local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","bankdriver")

RegisterServerEvent("IsAcop")
AddEventHandler("IsAcop", function()
	local users = vRP.getUsers()
	for k,v in pairs (users) do
		if k then
			if vRP.hasPermission({k,"police.mission"}) then
				TriggerClientEvent("Cop",v)
			end
		end
	end
end)

