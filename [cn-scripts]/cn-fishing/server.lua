local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")


vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","cn-fishing")


RegisterServerEvent('fishing:reward')
AddEventHandler('fishing:reward', function(fish)

  local user_id = vRP.getUserId({source})
  local player = vRP.getUserSource({user_id})


local new_weight = vRP.getInventoryWeight({user_id})
if new_weight <= vRP.getInventoryMaxWeight({user_id}) then


	local r = math.random(1,100) -- between 1 and 100
	if (r <= 1) then
	    vRP.giveInventoryItem({user_id,"dirty_money",2500,true})
	elseif (r <= 10) then
	    vRP.giveInventoryItem({user_id,"fisk1",1,true})
	elseif (r <= 20) then
	    vRP.giveInventoryItem({user_id,"fisk2",1,true})
	elseif (r <= 30) then
	    vRP.giveInventoryItem({user_id,"fisk3",1,true})
	elseif (r <= 40) then
	    vRP.giveInventoryItem({user_id,"fisk4",1,true})
	elseif (r <= 50) then
	    vRP.giveInventoryItem({user_id,"fisk5",1,true})
	else
	    vRP.giveInventoryItem({user_id,"fisk6",1,true})
	end

else
	vRPclient.notify({player,"~r~Taske Fuld"})
end


end)

-- TEST