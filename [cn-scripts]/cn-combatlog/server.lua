local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
--MySQL = module("vrp_mysql", "MySQL")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "sh_combatlogging")

RegisterServerEvent('baseevents:onPlayerDied')
RegisterServerEvent('baseevents:onPlayerKilled')
RegisterServerEvent('baseevents:onPlayerWasted')

AddEventHandler('baseevents:onPlayerKilled', function(killedBy, data, Weapon)
	local victim = source
	local user_id = vRP.getUserId({victim})
	local player = vRP.getUserSource({user_id})
	local killerx_id = vRP.getUserId({killedBy})
		if killerx_id ~= nil then
			PerformHttpRequest('https://autisthook.com/api/webhooks/667780856546459669/Z8Z5jbe1RaLxpUzpWwmJcqxTRB1daza75-gHExb5f20L7Ft1_NOehpKShTMyPlKFJiD-', function(err, text, headers) end, 'POST', json.encode({username = "Kill", content = "```\n"..killerx_id.." dræbte "..user_id.." med HASHID: "..Weapon.."\n (**"..os.date("%H:%M:%S %d/%m/%Y") .. "```"}), { ['Content-Type'] = 'application/json' })
		end
end)

AddEventHandler('baseevents:onPlayerDied', function(killedBy, pos)
	local victim = source
	local user_id = vRP.getUserId({victim})
	local player = vRP.getUserSource({user_id})
	PerformHttpRequest('https://autisthook.com/api/webhooks/667780856546459669/Z8Z5jbe1RaLxpUzpWwmJcqxTRB1daza75-gHExb5f20L7Ft1_NOehpKShTMyPlKFJiD-', function(err, text, headers) end, 'POST', json.encode({username = "Kill", content = "```\nOffer ID: "..user_id.." \nBegik selvmord? (**"..os.date("%H:%M:%S %d/%m/%Y") .. "```"}), { ['Content-Type'] = 'application/json' })
end)
