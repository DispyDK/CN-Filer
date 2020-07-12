local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_ulovligejobs")

--MySQL.createCommand("vRP/get_reset_criminal_job","SELECT * FROM vrp_users WHERE id = @user_id")
--MySQL.createCommand("vRP/set_reset_criminal_job","UPDATE vrp_users SET reset_criminal_job = @time WHERE id = @user_id")

RegisterServerEvent("producent")
AddEventHandler("producent", function()
  local source = source
  local user_id = vRP.getUserId({source})

  if vRP.hasGroup({user_id, "user"}) then
    MySQL.Async.fetchAll("SELECT * FROM vrp_users WHERE id = @user_id", {user_id = user_id}, function(rows, affected)
      local userData = rows[1]
      if user_id ~= nil then
        if userData and os.time() >= userData.reset_criminal_job + (((24*60) * 60)*7) then
          vRP.addUserGroup({user_id, "Producent"})
          TriggerClientEvent("pNotify:SendNotification", source,{text = "Du har skiftet dit job om til ".."producent".."", type = "error", queue = "global", timeout = 3000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
          if userData.last_criminal_job == "Producent" then

          else
            MySQL.Async.execute("UPDATE vrp_users SET reset_criminal_job = @time WHERE id = @user_id", {user_id = user_id, time = os.time()})
            MySQL.Async.execute("UPDATE vrp_users SET last_criminal_job = @job WHERE id = @user_id", {user_id = user_id, job = "Producent"})
          end
        elseif userData.last_criminal_job == "Producent" then
          vRP.addUserGroup({user_id, "Producent"})
          TriggerClientEvent("pNotify:SendNotification", source,{text = "Du har skiftet dit job om til ".."producent".."", type = "error", queue = "global", timeout = 3000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        else
          TriggerClientEvent("pNotify:SendNotification", source,{text = "Det er desværre ikke 7 dage siden sidste jobskifte.", type = "error", queue = "global", timeout = 3000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
      end
    end)
  end
end)
RegisterServerEvent("kemiker")
AddEventHandler("kemiker", function()
  local source = source
  local user_id = vRP.getUserId({source})

  if vRP.hasGroup({user_id, "user"}) then
    MySQL.Async.fetchAll("SELECT * FROM vrp_users WHERE id = @user_id", {user_id = user_id}, function(rows, affected)
      local userData = rows[1]
      if user_id ~= nil then
        if userData and os.time() >= userData.reset_criminal_job + (((24*60) * 60)*7) then
          vRP.addUserGroup({user_id, "Kemiker"})
          TriggerClientEvent("pNotify:SendNotification", source,{text = "Du har skiftet dit job om til ".."Kemiker".."", type = "error", queue = "global", timeout = 3000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
          if userData.last_criminal_job == "Kemiker" then
          else
            MySQL.Async.execute("UPDATE vrp_users SET reset_criminal_job = @time WHERE id = @user_id", {user_id = user_id, time = os.time()})
            MySQL.Async.execute("UPDATE vrp_users SET last_criminal_job = @job WHERE id = @user_id", {user_id = user_id, job = "Kemiker"})
          end
        elseif userData.last_criminal_job == "Kemiker" then
          vRP.addUserGroup({user_id, "Kemiker"})
          TriggerClientEvent("pNotify:SendNotification", source,{text = "Du har skiftet dit job om til ".."Kemiker".."", type = "error", queue = "global", timeout = 3000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        else
          TriggerClientEvent("pNotify:SendNotification", source,{text = "Det er desværre ikke 7 dage siden sidste jobskifte.", type = "error", queue = "global", timeout = 3000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
      end
    end)
  end
end)
RegisterServerEvent("pusher")
AddEventHandler("pusher", function()
  local source = source
  local user_id = vRP.getUserId({source})

  if vRP.hasGroup({user_id, "user"}) then
    MySQL.Async.fetchAll("SELECT * FROM vrp_users WHERE id = @user_id", {user_id = user_id}, function(rows, affected)
      local userData = rows[1]
      if user_id ~= nil then
        if userData and os.time() >= userData.reset_criminal_job + (((24*60) * 60)*7) then
          vRP.addUserGroup({user_id, "Pusher"})
          TriggerClientEvent("pNotify:SendNotification", source,{text = "Du har skiftet dit job om til ".."Pusher".."", type = "error", queue = "global", timeout = 3000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
          if userData.last_criminal_job == "Pusher" then
          else
            MySQL.Async.execute("UPDATE vrp_users SET reset_criminal_job = @time WHERE id = @user_id", {user_id = user_id, time = os.time()})
            MySQL.Async.execute("UPDATE vrp_users SET last_criminal_job = @job WHERE id = @user_id", {user_id = user_id, job = "Pusher"})
          end
        elseif userData.last_criminal_job == "Pusher" then
          vRP.addUserGroup({user_id, "Pusher"})
          TriggerClientEvent("pNotify:SendNotification", source,{text = "Du har skiftet dit job om til ".."Pusher".."", type = "error", queue = "global", timeout = 3000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        else
          TriggerClientEvent("pNotify:SendNotification", source,{text = "Det er desværre ikke 7 dage siden sidste jobskifte.", type = "error", queue = "global", timeout = 3000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
      end
    end)
  end
end)

RegisterServerEvent("indbrudstyv")
AddEventHandler("indbrudstyv", function()
  local source = source
  local user_id = vRP.getUserId({source})

  if vRP.hasGroup({user_id, "user"}) then
    vRP.addUserGroup({user_id, "Indbrudstyv"})
    TriggerClientEvent("pNotify:SendNotification", source,{text = "Du er nu indbrudstyv!", type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
  end
end)
