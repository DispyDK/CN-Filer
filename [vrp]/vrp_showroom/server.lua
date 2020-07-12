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
z
    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_showroom")
Gclient = Tunnel.getInterface("vRP_garages","vRP_showroom")

local cfg = module("vrp_showroom","cfg/config")
local vehgarage = cfg.showgarage

-- SHOWROOM
RegisterServerEvent('veh_SR:CheckMoneyForVeh')
AddEventHandler('veh_SR:CheckMoneyForVeh', function(vehicle, name, price ,veh_type)
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
    MySQL.Async.fetchAll("SELECT vehicle FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle", {user_id = user_id, vehicle = vehicle}, function(pvehicle, affected)
        vRP.prompt({player,"Er du sikker på, at du vil købe dette køretøj? (godkend/afvis)","",function(player,answer)
            if string.lower(answer) == "godkend" then
                if #pvehicle > 0 then
                    TriggerClientEvent("pNotify:SendNotification", player,{text = "Du ejer allerede dette køretøj!", type = "warning", queue = "global", timeout = 3000, layout = "centerRight",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                else
                    for i=1, #vehgarage.vehicles do
                        if vehgarage.vehicles[i].model == vehicle and vehgarage.vehicles[i].name == name and vehgarage.vehicles[i].costs == price then
                            if price > 5000 then
                                if vRP.tryFullPayment({user_id,price}) then
                                    vRP.getUserIdentity({user_id, function(identity)
                                        MySQL.Async.fetchAll("INSERT IGNORE INTO vrp_user_vehicles(user_id,vehicle,vehicle_plate,veh_type,vehicle_name) VALUES(@user_id,@vehicle,@vehicle_plate,@veh_type,@vehicle_name)", {user_id = user_id, vehicle = vehicle, vehicle_name = name, vehicle_plate = "P "..identity.registration, veh_type = veh_type})
                                    end})

                                    TriggerClientEvent('veh_SR:CloseMenu', player, vehicle, veh_type)
                                    TriggerClientEvent("pNotify:SendNotification", player,{text = "Betalte "..format_thousand(price).." DKK", type = "info", queue = "global", timeout = 3000, layout = "centerRight",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                                    PerformHttpRequest('https://autisthook.com/api/webhooks/597825475825631232/OBjO-wKMdyLio02wihUckBkY-i1c8gRSZFkc_35UZniNp53NmO89IjC_3SI9Pldg9Mhx', function(err, text, headers) end, 'POST', json.encode({username = "Server "..GetConvar("servernumber", "0").." - Showroom", content = "**"..user_id.."** har lige købt en **"..vehicle.."** for: **"..format_thousand(price).."**"}), { ['Content-Type'] = 'application/json' })
                                else
                                    TriggerClientEvent("pNotify:SendNotification", player,{text = "Ikke nok penge!", type = "warning", queue = "global", timeout = 3000, layout = "centerRight",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                                end
                            end
                        end
                    end
                end
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = "Betalingen afbrudt, da du ikke godkendte.", type = "error", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end})
    end)
end)

function format_thousand(v)
    local s = string.format("%d", math.floor(v))
    local pos = string.len(s) % 3
    if pos == 0 then pos = 3 end
    return string.sub(s, 1, pos)
            .. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end
