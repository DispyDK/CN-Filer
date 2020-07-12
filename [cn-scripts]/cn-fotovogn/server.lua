--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 26-03-2019
-- Time: 20:27
-- Made for CiviliansNetwork
--

local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

local defaultcars = {
    {coords={-453.00729370117,-144.88781738281,37.048791503906,27.267488479614},data={coords={-447.58268432617,-167.10437304688,37.951671600342},turned=true,limit=1,radius=11}},
    {coords={343.28149414063,-741.33166503906,28.22426376343,341.26953125},data={coords={331.45116577149,-757.36636962891,29.007123947144},turned=true,limit=1,radius=9}},
    {coords={583.68109130859,-1038.8240966797,35.892339324951,276.79147338867},data={coords={554.07803955077,-1036.7507324219,36.787731170654},turned=true,limit=1,radius=11}},
    {coords={1159.4560546875, 603.40740966797, 97.600476074219, 143.62663269043},data={coords={1177.5625,620.3178100586,98.553421020508},turned=true,limit=2,radius=5.6}},
    {coords={2419.0642089844, 3944.5319824219, 35.251952362061, 315.15115356445},data={coords={2400.0688476563,3930.5173339844,36.051647186279},turned=true,limit=2,radius=5.6}},
    {coords={-196.72119140625, 6163.0190429688, 30.325545883179, 314.62280273438},data={coords={-218.1734375,6149.668359375,31.141002655029},turned=true,limit=2,radius=5.4}},
    {coords={1667.8442382813, 1360.7210693359, 86.216006469727, 169.68803405762},data={coords={1678.24375,1386.5290039063,87.018951416016},turned=true,limit=3,radius=14}},
    {coords={2234.185546875, 2738.4643554688, 44.230134735107, 297.9485168457},data={coords={2206.203125,2731.8860839844,45.053623199463},turned=true,limit=3,radius=20}},
    {coords={200.58743286133,-1200.1745605469,28.311098098755,186.02015686035},data={coords={200.58743286133,-1200.1745605469,28.311098098755},turned=true,limit=1,radius=20}},
    {coords={-935.44476318359,-128.04243469238,36.582981109619,111.04354095459},data={coords={-935.44476318359,-128.04243469238,37.582981109619},turned=true,limit=1,radius=20}},
    {coords={70.362060546875,-1470.3063964844,28.291217803955,136.88423156738},data={coords={70.362060546875,-1470.3063964844,29.291217803955},turned=true,limit=1,radius=20}},
    {coords={135.08082580566,-876.84899902344,29.521627426147,156.07460021973},data={coords={135.08082580566,-876.84899902344,30.521627426147},turned=true,limit=1,radius=20}},
    {coords={315.03137207031,-449.70141601563,42.743858337402,333.19036865234},data={coords={315.03137207031,-449.70141601563,42.743858337402},turned=true,limit=1,radius=30}},
    {coords={2051.384765625,3083.9714355469,45.526050567627,54.760330200195},data={coords={2051.384765625,3083.9714355469,46.526050567627},turned=true,limit=2,radius=20}},
    {coords={1696.5319824219,1355.1005859375,86.181861877441,349.45379638672},data={coords={1696.5319824219,1355.1005859375,87.181861877441},turned=true,limit=3,radius=20}},
    {coords={925.63671875,244.59147644043,78.591857910156,137.0739440918},data={coords={925.63671875,244.59147644043,79.591857910156},turned=true,limit=3,radius=20}},
    {coords={318.40472412109,-732.58630371094,28.231838226318,158.76626586914},data={coords={318.40472412109,-732.58630371094,29.231838226318},turned=true,limit=1,radius=9}},
}
local fotovogne = {

}

local basiccost = 2500

RegisterServerEvent('cn-fotovogn:betal')
AddEventHandler('cn-fotovogn:betal', function(speed,limit,veh)
	local source = source
	local user_id = vRP.getUserId({source})
	local percent = speed/limit
	local tax = basiccost * percent
    if percent > 1.3 then
        tax = tax*1.5
    end
    tax = math.floor(tax)
    local payment = vRP.tryBankPaymentOrDebt({user_id,tax})
	if payment ~= false then
		if payment == "paid" then
			TriggerClientEvent("pNotify:SendNotification", source,{text = "<b style='color:#ED2939'>Fotovogn</b><br /><br />Du kørte " .. speed .. "km/t hvor du må køre "..limit.." km/t <br /><b style='color:#26ff26'>Bøde</b>: " .. tax .." DKK", type = "error", queue = "fart", timeout = 8000, layout = "centerRight",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
      --sendMessage(tax, speed, limit, payment, user_id)
		else
			TriggerClientEvent("pNotify:SendNotification", source,{text = "<b style='color:#ED2939'>Fotovogn</b><br /><br />Du kørte " .. speed .. "km/t hvor du må køre "..limit.." km/t <br /><b style='color:#26ff26'>Bøde</b>: " .. tax .." DKK".."<br>Nuværende gæld: <b style='color: #DB4646'>"..format_thousands(payment).." DKK</b>", type = "error", queue = "fart", timeout = 8000, layout = "centerRight",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
      --sendMessage(tax, speed, limit, payment, user_id)
    end

    TriggerClientEvent("levelup",source, tax, speed)
    local source = source
    local user_id = vRP.getUserId({source})
    TriggerEvent("gcPhone:allUpdate", user_id,source)
    end
    if veh ~= false then
        TriggerClientEvent("cn-fotovogn:sendalert",-1,veh,tax,speed)
    end
end)

function sendMessage(tax, speed, limit, payment, user_id)
vRP.getUserIdentity({user_id, function(identity)
local n = identity.phone
local k = vRP.getUserSource({user_id})
local amount = tonumber(amount)
if payment == "paid" then
  kaka = ""
else
  kaka = "Nuværende gæld: " .. payment .. " DKK"
end
TriggerEvent('gcPhone:_internalAddMessage', 'Civilians Politi', n, 'SMS fra Politiet: Du fik en bøde på '..tax..' DKK, for at køre '..speed..' km/t i en '..limit..'-zone! '.. kaka, 0, function (smsMess)
TriggerClientEvent("gcPhone:receiveMessage", tonumber(k), smsMess)
end)
end})
end

RegisterServerEvent('cn-fotovogn:sendvogn')
AddEventHandler('cn-fotovogn:sendvogn', function(veh,list)
	fotovogne[veh] = list
	TriggerClientEvent("cn-fotovogn:sendvogn",-1,fotovogne)
end)

RegisterServerEvent('cn-fotovogn:removevogn')
AddEventHandler('cn-fotovogn:removevogn', function(veh)
    fotovogne[veh] = nil
    TriggerClientEvent("cn-fotovogn:sendvogn",-1,fotovogne)
end)

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	if first_spawn then
        TriggerClientEvent('cn-fotovogn:createdefault', source, defaultcars,fotovogne)
	end
end)

function format_thousands(v)
    local s = string.format("%d", math.floor(v))
    local pos = string.len(s) % 3
    if pos == 0 then pos = 3 end
    return string.sub(s, 1, pos)
            .. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end


RegisterCommand('fotovogn', function(source)
  TriggerClientEvent('cn-fotovogn:createdefault', source, defaultcars,fotovogne)
end)
