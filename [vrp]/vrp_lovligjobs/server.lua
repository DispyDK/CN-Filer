local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_lovligjobs")

RegisterServerEvent("taxi")
AddEventHandler("taxi", function()
  local source = source
  local user_id = vRP.getUserId({source})

  if vRP.hasGroup({user_id, "user"}) then
	vRP.addUserGroup({user_id, "Taxi"})
	TriggerClientEvent("pNotify:SendNotification", source,{text = "Du blev ansat som Taxachauffør!", type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
  end
end)

RegisterServerEvent("miner")
AddEventHandler("miner", function()
  local source = source
  local user_id = vRP.getUserId({source})
  if vRP.hasGroup({user_id, "user"}) then
	vRP.addUserGroup({user_id, "Miner"})
  TriggerClientEvent("pNotify:SendNotification", source,{text = "Du blev ansat som Miner!", type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
  end
end)

RegisterServerEvent("skovhugger")
AddEventHandler("skovhugger", function()
  local source = source
  local user_id = vRP.getUserId({source})

  if vRP.hasGroup({user_id, "user"}) then
	vRP.addUserGroup({user_id, "Skovhugger"})
	TriggerClientEvent("pNotify:SendNotification", source,{text = "Du blev ansat som Skovhugger!", type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
  end
end)

RegisterServerEvent("skraldemand")
AddEventHandler("skraldemand", function()
  local source = source
  local user_id = vRP.getUserId({source})

  if vRP.hasGroup({user_id, "user"}) then
	vRP.addUserGroup({user_id, "Skraldemand"})
	TriggerClientEvent("pNotify:SendNotification", source,{text = "Du blev ansat som Skraldemand!", type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
  end
end)

RegisterServerEvent("farmer")
AddEventHandler("farmer", function()
  local source = source
  local user_id = vRP.getUserId({source})

  if vRP.hasGroup({user_id, "user"}) then
	vRP.addUserGroup({user_id, "Farmer"})
	TriggerClientEvent("pNotify:SendNotification", source,{text = "Du blev ansat som Farmer!", type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
  end
end)

RegisterServerEvent("lastbilchauffor")
AddEventHandler("lastbilchauffor", function()
  local source = source
  local user_id = vRP.getUserId({source})

  if vRP.hasGroup({user_id, "user"}) then
	vRP.addUserGroup({user_id, "Lastbilchauffør"})
	TriggerClientEvent("pNotify:SendNotification", source,{text = "Du blev ansat som Lastbilchauffør!", type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
  end
end)

RegisterServerEvent("arbejdslos")
AddEventHandler("arbejdslos", function()
  local source = source
  local user_id = vRP.getUserId({source})


  if vRP.hasGroup({user_id, "user"}) then
	vRP.addUserGroup({user_id, "Arbejdsløs"})
	TriggerClientEvent("pNotify:SendNotification", source,{text = "Du blevet fyret fra dit arbejde!", type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
  end
end)

RegisterServerEvent("pizzabud")
AddEventHandler("pizzabud", function()
  local source = source
  local user_id = vRP.getUserId({source})

  if vRP.hasGroup({user_id, "user"}) then
	vRP.addUserGroup({user_id, "Pizzabud"})
	TriggerClientEvent("pNotify:SendNotification", source,{text = "Du blev ansat som Pizzabud!", type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
  end
end)


RegisterCommand('streamon', function(source, name)
  local source = source
  local user_id = vRP.getUserId({source})
  vRP.addUserGroup({user_id, "streamer"})
  TriggerClientEvent("pNotify:SendNotification", source,{text = "Du aktiverede streamer mode", type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})

end)


RegisterCommand('streamoff', function(source, name)
  local source = source
  local user_id = vRP.getUserId({source})
  vRP.removeUserGroup({user_id, "streamer"})
  TriggerClientEvent("pNotify:SendNotification", source,{text = "Du deaktiverede streamer mode", type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})

end)




-- staff.chat
