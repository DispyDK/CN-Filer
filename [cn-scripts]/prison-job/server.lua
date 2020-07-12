local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterServerEvent('indsat')
AddEventHandler('indsat', function(ped)
    local user_id = vRP.getUserId({source})
    MySQL.Async.fetchAll("SELECT dvalue FROM vrp_user_data WHERE user_id = @user_id AND dkey = 'vRP:jail:time'", {user_id = user_id, dvalue = dvalue}, function(rows, affected)
        if #rows > 0 then
            for k,v in pairs(rows) do
                local timer = v.dvalue
                if timer == '5.0' or timer == '4.0' or timer == '3.0' or timer == '2.0' or timer == '1.0' then
                    TriggerEvent("pNotify:SendNotification",user_id, {text = "Du kan ikke lave flere jobs", type = "info", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                else
                    timer = timer - 1
                    vRP.setUData({tonumber(user_id),"vRP:jail:time",json.encode(timer)})
                    TriggerEvent("pNotify:SendNotification",user_id, {text = "Din tid er sat ned", type = "info", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                end
            end
        end
    end)
end)
