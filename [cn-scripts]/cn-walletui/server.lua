------------------------------------
--   Credit for Kalu / Kashnars   --
------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","walletui")

bankBalance = function()
	local user_id = vRP.getUserId({source})
    return vRP.getBankMoney({user_id})
end

walletBalance = function()
	local user_id = vRP.getUserId({source})
    return vRP.getMoney({user_id})
end

debt = function()
	local user_id = vRP.getUserId({source})
    return vRP.getDebt({user_id})
end

RegisterServerEvent('cn-walletui:getMoneys')
AddEventHandler('cn-walletui:getMoneys', function()
	local _source = source
	local user_id = vRP.getUserId({_source})

	if user_id ~= nil then
		local wallet = walletBalance(user_id)
		local bank = bankBalance(user_id)
		local debt = debt(user_id)

	    TriggerClientEvent("cn-walletui:setValues", _source, wallet, bank, debt)
	end
end)