local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_burglary")

local robbers = {}

local black_money = true

function insert(id, item)
    if not robbers[id] then
        robbers[id] = {}
    end

    table.insert(robbers[id], item)
end

-- events
RegisterNetEvent('burglary:collected')
AddEventHandler('burglary:collected', function (item, house)
	insert(source, { item = item, house = house })
end)

RegisterNetEvent('burglary:ended')
AddEventHandler('burglary:ended', function (failed, alert, door, street)
	if not failed then
		if robbers[source] then
			local sum = 0
			
			for _,v in pairs(robbers[source]) do
				-- get price from houses/pickups table
				local item = houses[v.house].pickups[v.item]
			
				if tonumber(item.value) ~= nil then
					sum = sum + item.value
				end
			end
			
			--print("[Burglary] " .. GetPlayerName(source) ..  " stjal " .. #robbers[source] .. "i alt ting som er værd DKK" .. sum)
			robbers[source] = nil
			
			-- tell the client how much money he made
			TriggerClientEvent("burglary:finished", source, sum)
			
			-- resources can listen for this event to give money using their own framework
			-- sum = amount of money
			-- source = source of player
			--TriggerEvent("burglary:money", sum, source)
		end
	else
		if alert then
			-- resources can listen for this event to for example alert cops
			-- house = houseid
			-- coords = door coordinates of house
			-- source = source of player failing
			local message = "^7^*En person begår indbrud ved " .. street .. "!"
			TriggerEvent("burglary:failed", doors[door].house, doors[door].coords, player, street, message)
		end
		
		--if robbers[source] then
		--	robbers[source] = nil
		--end
	end
end)

--RegisterNetEvent('burglary:money')
--AddEventHandler("burglary:money", function(sum, player)
--	local user_id = vRP.getUserId({player})
--
--	if black_money == true then
--		vRP.giveInventoryItem({user_id,"dirty_money", sum})
--	else
--		vRPclient.notify(player,{"~r~Fejl"})
--	end
--end)

RegisterNetEvent('burglary:failed')
AddEventHandler("burglary:failed", function(house, coords, player, street, message)

	local source = source
	local luser_id = vRP.getUserId({source})
	if vRP.hasGroup({luser_id, "Politi-Job"}) == false then
		local players = {}
		local users = vRP.getUsers({})
		for k,v in pairs(users) do
			local player = vRP.getUserSource({k})
			if player ~= nil then
				local user_id = vRP.getUserId({player})
				if vRP.hasGroup({user_id, "Politi-Job"}) then
					table.insert(players,player)
				end
			end
		end
		for k,v in pairs(players) do
			TriggerClientEvent('notifyDispatch1', v, coords, message)
		end
	end
end)

AddEventHandler('playerDropped', function (source, reason)
    if robbers[source] then
        robbers[source] = nil
    end
end)
RegisterNetEvent('burglary:getstolengoods')
AddEventHandler('burglary:getstolengoods', function ()
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		vRP.giveInventoryItem({user_id,"tyvegods",1,true})
	end
end)