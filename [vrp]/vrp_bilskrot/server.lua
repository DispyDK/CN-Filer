local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_bilskrot")

local scrapprices = {
	{id = 0, price = 2500}, --compacts
	{id = 1, price = 2500}, --sedans
	{id = 2, price = 2500}, --SUV's
	{id = 3, price = 2500}, --coupes
	{id = 4, price = 2500}, --muscle
	{id = 5, price = 2500}, --sport classic
	{id = 6, price = 2500}, --sport
	{id = 7, price = 2500}, --super
	{id = 8, price = 2500}, --motorcycle
	{id = 9, price = 2500}, --offroad
	{id = 10, price = 2500}, --industrial
	{id = 11, price = 2500}, --utility
	{id = 12, price = 2500}, --vans
	{id = 13, price = 2500}, --bicycles
	{id = 14, price = 2500}, --boats
	{id = 15, price = 2500}, --helicopter
	{id = 16, price = 2500}, --plane
	{id = 17, price = 2500}, --service
	{id = 18, price = 2500}, --emergency
	{id = 19, price = 2500}, --military
	{id = 20, price = 2500} --commercial
}



-- GROUPS
-- WHO HAVE ACCESS TO SCRAP VEHICLES
local groups = {"Mekaniker-Job","Mekaniker Civilians","Mekaniker Domingo", "Mekaniker Chef"};



RegisterServerEvent("scrap:getVehPrice")
AddEventHandler("scrap:getVehPrice", function(class)
	for k, price in pairs(scrapprices) do
		if class == price.id then
			vehPrice = price.price
			TriggerClientEvent("setVehPrice", -1, vehPrice)
		end
	end
end)

RegisterServerEvent("scrap:SellVehicle")
AddEventHandler("scrap:SellVehicle", function(vehPrice)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
    vRP.giveBankMoney({user_id,vehPrice})
end)

RegisterServerEvent('scrap:Mechanic')
AddEventHandler('scrap:Mechanic', function(triggerevent)
	local source = source
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
    for k,v in ipairs(groups) do
		if vRP.hasGroup({user_id,v}) then
      		TriggerClientEvent(triggerevent, source)
    	else
     		TriggerClientEvent("pNotify:SendNotification", player,{text = "Du er ikke en mekaniker, du kan ikke sælge biler her!", type = "error", queue = "global", timeout = 2000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
     	end
    end
end)
