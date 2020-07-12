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

--[[BASE]]--
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_dmvschool")

--[[LANG]]--
local Lang = module("vrp", "lib/Lang")
local cfg = module("vrp", "cfg/base")
local lang = Lang.new(module("vrp", "cfg/lang/"..cfg.lang) or {})

--[[SQL]]--

-- init
-- MySQL.query("vRP/dmv_column")

--[[DMV Test]]--

RegisterServerEvent("dmv:success")
AddEventHandler("dmv:success", function()
    local user_id = vRP.getUserId({source})
    vRP.setLicense({user_id,1})
end)

RegisterServerEvent("dmv:ttcharge")
AddEventHandler("dmv:ttcharge", function()
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
    if vRP.tryPayment({user_id,5000}) then
        TriggerClientEvent('dmv:startttest',player)
    else
        TriggerClientEvent("pNotify:SendNotification", player,{text = "Ikke nok penge!", type = "warning", queue = "global", timeout = 3000, layout = "bottomCenter",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
    end
end)

RegisterServerEvent("dmv:ptcharge")
AddEventHandler("dmv:ptcharge", function()
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
    if vRP.tryPayment({user_id,5000}) then
        TriggerClientEvent('dmv:startptest',player)
    else
        TriggerClientEvent("pNotify:SendNotification", player,{text = "Ikke nok penge!", type = "warning", queue = "global", timeout = 3000, layout = "bottomCenter",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
    end
end)

--[[ ***** SPAWN CHECK ***** ]]
AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    if user_id then
        vRP.getDriverLicense({user_id, function(license)
            if license == 1 then
                TriggerClientEvent('dmv:CheckLicStatus',source)
            end
        end})
    end
end)
