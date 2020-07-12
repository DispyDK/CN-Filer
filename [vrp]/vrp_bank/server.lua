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
vRPclient = Tunnel.getInterface("vRP","vRP_bank")

local banks = cfg.banks
local cooldown = 0
local robbers = {}

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
---------------------------------------------------------------------------------------------------EVENTS----------------------------------------------------------------------------------------------------
RegisterServerEvent('es_bank:toofar')
AddEventHandler('es_bank:toofar', function(robb)
	if(robbers[source])then
		TriggerClientEvent('es_bank:toofarlocal', source)
		robbers[source] = nil
		TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery was cancelled at: ^2" .. banks[robb].nameofbank)
		TriggerClientEvent('Clean',-1)
	end
end)

RegisterServerEvent('es_bank:playerdied')
AddEventHandler('es_bank:playerdied', function(robb)
	if(robbers[source])then
		TriggerClientEvent('es_bank:playerdiedlocal', source)
		robbers[source] = nil
		TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery was cancelled at: ^2" .. banks[robb].nameofbank)
		TriggerClientEvent('Clean',-1)
	end
end)

-- AddEventHandler('onResourceStart', function()
-- 	TriggerClientEvent("closedoors",-1)
-- end)

RegisterServerEvent('es_bank:rob')
AddEventHandler('es_bank:rob', function(robb)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	local cops = vRP.getUsersByPermission({cfg.permission})
	local antalbetjente = #cops

	if vRP.hasPermission({user_id,cfg.permission}) then
		vRPclient.notify(player,{"~r~Politiet kan ikke røve."})
	else
		local ncops = cfg.cops
		if banks[robb].mincops ~= nil then
			ncops = banks[robb].mincops
		end
		if #cops >= ncops then
			if banks[robb] then
				local bank = banks[robb]

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
							TriggerClientEvent('chatMessage', v, "Røveri: Alarmen i "..banks[robb].nameofbank.." er blevet udløst!")
						end
					end
				end
				--TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Robbery in progress at ^2" .. bank.nameofbank)
				TriggerClientEvent('chatMessage', player, 'SYSTEM', {255, 0, 0}, "Du har startet et røveri ved: ^2" .. bank.nameofbank .. "^0, kom ikke for langt væk fra dette punkt!")
				cooldown = 3600
				TriggerClientEvent('chatMessage', player, 'SYSTEM', {255, 0, 0}, "Beskyt stedet imens det bliver tømt ^1" ..bank.seconds.." ^sekunder og tingene er dine!")
				TriggerClientEvent('es_bank:currentlyrobbing', player, robb)
				banks[robb].lastrobbed = os.time()
				robbers[player] = robb
				local savedSource = player
				SetTimeout(cfg.seconds*1000, function()
					if(robbers[savedSource])then
						if(user_id)then
							TriggerClientEvent('es_bank:robberycomplete', savedSource, bank.reward)
							TriggerClientEvent('Clean',-1)
						end
					end
				end)
			end
		else
			vRPclient.notify(player,{"~r~ikke nok betjente i byen"})
		end
	end
end)



RegisterServerEvent('ir_force:kashtan')
AddEventHandler('ir_force:kashtan', function(thermiteID,model1,doorheading,door1, doorID)
	local xPlayer = vRP.getUserId({source})
	--vRP.tryGetInventoryItem(xPlayer,"thermite",1)
	TriggerClientEvent('ir_force:terkidan', -1, thermiteID,model1,doorheading,door1, doorID)
end)

RegisterServerEvent('grabbedCash')
AddEventHandler('grabbedCash', function(cash)
	local user_id = vRP.getUserId({source})
	vRP.giveInventoryItem({user_id,"dirty_money",cash,true})
end)

RegisterServerEvent('Goldencard')
AddEventHandler('Goldencard', function()
	local user_id = vRP.getUserId({source})
	vRP.giveInventoryItem({user_id,"goldencard",1,true})
end)

RegisterServerEvent('Silvercard')
AddEventHandler('Silvercard', function()
	local user_id = vRP.getUserId({source})
	vRP.giveInventoryItem({user_id,"silvercard",1,true})
end)

RegisterServerEvent('Nationalbanken')
AddEventHandler('Nationalbanken', function()
	local user_id = vRP.getUserId({source})
	vRP.giveInventoryItem({user_id,"nationalbankenplan",1,true})
end)

RegisterServerEvent('Skattekort1')
AddEventHandler('Skattekort1', function()
	local user_id = vRP.getUserId({source})
	vRP.giveInventoryItem({user_id,"skattekort1",1,true})
end)

RegisterServerEvent('Skattekort2')
AddEventHandler('Skattekort2', function()
	local user_id = vRP.getUserId({source})
	vRP.giveInventoryItem({user_id,"skattekort2",1,true})
end)

RegisterServerEvent('Nøgletilbil')
AddEventHandler('Nøgletilbil', function()
	local user_id = vRP.getUserId({source})
	vRP.giveInventoryItem({user_id,"key_car",1,true})
end)

RegisterServerEvent('Useitem')
AddEventHandler('Useitem', function(item)
	local user_id = vRP.getUserId({source})
	vRP.tryGetInventoryItem({user_id, item, 1, true})
end)

RegisterServerEvent('es_bank:getCooldown')
AddEventHandler('es_bank:getCooldown', function()
	TriggerClientEvent('es_bank:readCooldown', source, cooldown)
end)

RegisterNetEvent('vrp_bank:checkplans')
AddEventHandler('vrp_bank:checkplans', function()
	local player = source
	local user_id = vRP.getUserId({player})
	if vRP.hasInventoryItem({user_id, "nationalbankenplan", 1, false}) then
		TriggerClientEvent("plan",-1)
	end
end)

RegisterNetEvent('thermitebombcheck')
AddEventHandler('thermitebombcheck', function()
	local player = source
	local user_id = vRP.getUserId({player})
	if vRP.hasInventoryItem({user_id, "thermite", 1, false}) then
		TriggerClientEvent("thermiteok",-1)
	end
end)

------------------------------------------------------------FUNCTIONS----------------------------------------------------------------------------------------------------------
function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end
