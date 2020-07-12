--[[
    FiveM Scripts
    Copyright C 2018  Sighmir

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    at your option any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_holdup")

local stores = cfg.holdups
local cooldown = 0
local robbers = {}

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

Citizen.CreateThread(function()
	local time = os.time()
	while true do
		Citizen.Wait(1000)
		if cooldown < 1  then
		else
			cooldown = cooldown - 1
		end
	end
end)

RegisterServerEvent('es_holdup:toofar')
AddEventHandler('es_holdup:toofar', function(robb)
	if(robbers[source])then
		TriggerClientEvent('es_holdup:toofarlocal', source)
		robbers[source] = nil
		TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery was cancelled at: ^2" .. stores[robb].nameofstore)
	end
end)

RegisterServerEvent('es_holdup:playerdied')
AddEventHandler('es_holdup:playerdied', function(robb)
	if(robbers[source])then
		TriggerClientEvent('es_holdup:playerdiedlocal', source)
		robbers[source] = nil
		TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery was cancelled at: ^2" .. stores[robb].nameofstore)
	end
end)

RegisterServerEvent('es_holdup:rob')
AddEventHandler('es_holdup:rob', function(robb)
  local user_id = vRP.getUserId({source})
  local player = vRP.getUserSource({user_id})
  local cops = vRP.getUsersByPermission({cfg.permission})
  if vRP.hasPermission({user_id,cfg.permission}) then
    vRPclient.notify(player,{"~r~Politiet kan ikke røve."})
  else
    local ncops = cfg.cops
		if stores[robb].mincops ~= nil then
			ncops = stores[robb].mincops
		end
		if #cops >= ncops then
			if stores[robb] then
				local store = stores[robb]

		  if (cooldown > 1) then
					TriggerClientEvent('chatMessage', player, 'ROBBERY', {255, 0, 0}, "Dette sted er for nyligt blevet røvet, venligst vent: ^2" .. cooldown .. "^0 sekunder.")
					return
				end
				local player1 = GetPlayerPed(-1)
				local playerCoords = GetEntityCoords(player1)
				local users = vRP.getUsers({})
				for k,v in pairs(users) do
					if v ~= nil then
						if vRP.hasGroup({k,"Politi-Job"}) or vRP.hasGroup({k,"EMS-Job"}) or vRP.hasGroup({k,"Journalist-Job"}) then
							TriggerClientEvent('chatMessage', v, "Røveri: Alarmen i "..stores[robb].nameofstore.." er blevet udløst!")
						end
					end
				end
		  --TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery in progress at ^2" .. store.nameofstore)
		  TriggerClientEvent('chatMessage', player, 'SYSTEM', {255, 0, 0}, "Du har startet et røveri ved: ^2" .. store.nameofstore .. "^0, kom ikke for langt væk fra dette punkt!")
		  cooldown = 1800
		  TriggerClientEvent('chatMessage', player, 'SYSTEM', {255, 0, 0}, "Beskyt stedet imens det bliver tømt")
		  TriggerClientEvent('es_holdup:currentlyrobbing', player, robb)
		  stores[robb].lastrobbed = os.time()
		  robbers[player] = robb
		  local savedSource = player
		  SetTimeout(cfg.seconds*1000, function()
			  if(robbers[savedSource])then
				  if(user_id)then
					  local redbulls = math.random(2,5)
					  local kebabs = math.random(2,5)
					  local smoeger = math.random(2,5)
					  vRP.giveInventoryItem({user_id,"redgull",redbulls,true})
					  vRP.giveInventoryItem({user_id,"kebab",kebabs,true})
					  vRP.giveInventoryItem({user_id,"cigaretpakke",smoeger,true})
					  vRP.giveInventoryItem({user_id,"dirty_money",store.reward,true})

					  --TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery is over at: ^2" .. store.nameofstore .. "^0!")
					  TriggerClientEvent('es_holdup:robberycomplete', savedSource, store.reward)
				  end
			  end
		  end)
	  end
    else
      vRPclient.notify(player,{"~r~ikke nok betjente i byen"})
    end
  end
end)
