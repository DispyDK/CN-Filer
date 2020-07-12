-- This resource was made by plesalex100#7387
-- Please respect it, don't repost it without my permission
-- This Resource started from: https://codepen.io/AdrianSandu/pen/MyBQYz


local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_slots")

RegisterServerEvent("ples-slots:catiLeiBagi")
AddEventHandler("ples-slots:catiLeiBagi", function()
  local user_id = vRP.getUserId({source})
  if user_id then
    vRP.prompt({source, "Hvor meget vil du sætte i maskinen du kan bette af?: Det skal være et beløb der går op i 1000", "", function(source, amount)
      amount = parseInt(amount)
      if amount % 1000 == 0 and amount >= 1000 then
        if vRP.tryFullPayment({user_id, amount}) then
          TriggerClientEvent("ples-slots:bagXLei", source, amount)
          sendToDiscord("Slots - Indbetal", 'SLOTS: **'..user_id..'** - smed penge ind: '..amount..'')
        else
          TriggerClientEvent("pNotify:SendNotification", source,{text = "Du har ikke nok kontanter.", type = "success", queue = "global", timeout = 5000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
      else
        TriggerClientEvent("pNotify:SendNotification", source,{text = "Du skal indsætte noget der går op i 1000 DKK (eks: 2000, 5000 osv.)", type = "success", queue = "global", timeout = 5000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
      end
    end})
  end
end)

RegisterServerEvent("ples-slots:aiCastigat")
AddEventHandler("ples-slots:aiCastigat", function(amount)
  local user_id = vRP.getUserId({source})
  if user_id then
    amount = tonumber(amount)
    Wait(1000)
    if amount > 0 then
      vRP.giveInventoryItem({user_id, "polet", amount/1000, true})
      sendToDiscord("Slots - Udbetal", 'SLOTS: **'..user_id..'** - Vandt penge: '..amount..'')
    else
      --ingenting
    end
  end
end)


function sendToDiscord(name, message)
    if message == nil or message == '' or message:sub(1, 1) == '/' then return FALSE end
    local server = GetConvar("servernumber", "0")
		PerformHttpRequest('https://autisthook.com/api/webhooks/655977621548695572/nUm5k0rBIeTGB4e-TBCSXpNETsigvxNs0u__Fgapk-EJ0n1oL-c1qW4oDCOPSn4tcYzS', function(err, text, headers) end, 'POST', json.encode({username = name, content = message}), { ['Content-Type'] = 'application/json' })
end
