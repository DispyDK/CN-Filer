
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")


vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_revive")

local items = {
	{itemIn="amfetamin", itemOut="amfetaminkasse", unitsIn=250, unitsOut=1},
	{itemIn="kokain", itemOut="kokainkasse", unitsIn=500, unitsOut=1},
	{itemIn="toerret_ketamin", itemOut="ketaminkasse", unitsIn=500, unitsOut=1},
  {itemIn="lsd", itemOut="lsdkasse", unitsIn=500, unitsOut=1},
  {itemIn="skunk", itemOut="skunkkasse", unitsIn=500, unitsOut=1},
  {itemIn="pak_heroin", itemOut="brun_heroin_pure", unitsIn=1, unitsOut=240},
  {itemIn="dirty_money", itemOut="money", unitsIn=500000, unitsOut=480000, perm="casinomanager.adgang"},
}

RegisterServerEvent("packing:packItem")
AddEventHandler("packing:packItem", function(item)
  print(item)
  local user_id = vRP.getUserId({source})
  for k,v in pairs(items) do
    if (item == v.itemIn) then
			if v.perm then
				print(vRP.hasPermission({user_id,v.perm}))
				if vRP.hasPermission({user_id,v.perm}) then
					if vRP.hasInventoryItem({user_id,v.itemIn,v.unitsIn}) == true then
	          TriggerClientEvent("packing:itemPacked", source, v.itemIn)
	        else
	          TriggerClientEvent("pNotify:SendNotification", source,{text = "Du har intet der kan pakkes!", type = "error", queue = "global", timeout = 2000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
	        end
				else
					return false
				end
			else
        if vRP.hasInventoryItem({user_id,v.itemIn,v.unitsIn}) == true then
          TriggerClientEvent("packing:itemPacked", source, v.itemIn)
        else
          TriggerClientEvent("pNotify:SendNotification", source,{text = "Du har intet der kan pakkes!", type = "error", queue = "global", timeout = 2000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
        end
			end
    end
  end

end)

RegisterServerEvent("packing:donePacking")
AddEventHandler("packing:donePacking", function(item)
  print(item)
  local user_id = vRP.getUserId({source})
  for k,v in pairs(items) do
    if (item == v.itemIn) then
      print("Kan se " .. v.itemIn)
      print(v.unitsIn)
        if vRP.tryGetInventoryItem({user_id,v.itemIn,v.unitsIn}) == true then
          vRP.giveInventoryItem({user_id,v.itemOut,v.unitsOut,true})
        else
          TriggerClientEvent("pNotify:SendNotification", source,{text = "Du har intet der kan pakkes!", type = "error", queue = "global", timeout = 2000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
        end
    end
  end

end)
