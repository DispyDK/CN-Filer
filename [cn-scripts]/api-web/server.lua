--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 24-05-2019
-- Time: 00:51
-- Made for CiviliansNetwork
--
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
AddEventHandler('rconCommand', function(commandName, args)
    if commandName == "rank" then
        CancelEvent()
        local id = tonumber(args[2]);
        if id ~= nil then
            if args[3] ~= nil then
                local ranks = vRP.getAllGroups();
                if ranks[args[3]] ~= nil then
                    local source = vRP.getUserSource({id})
                    if source ~= nil then
                        if args[1] == "add" then
                            vRP.addUserGroup({id,args[3]});
                            print(id.." har fået tilføjet "..args[3]);
                        elseif args[1] == "remove" then
                            vRP.removeUserGroup({id,args[3]});
                            print(id.." har fået fjernet "..args[3]);
                        end
                        local method = (args[1] == "add") and "tilføjet" or "fjernet"
                        sendToDiscord("Rank - Ingame", "**"..id.."** har lige fået "..method.." ranken: **"..args[3].."**","https://autisthook.com/api/webhooks/589801962963468348/yyG-8ZB6oCVnR0RI1_nKjcKRLgVYW1xob6uBo80XXpFB8z_DVWsOXnogUQ7pEee8cmzM")
                    else
                        print(id.." er ikke online");
                    end

                else
                    print("Ranken: "..args[3].." findes ikke");
                end
            end
        end
    elseif commandName == "lpkick" then
        CancelEvent()
        local id = tonumber(args[1]);
        if id ~= nil then
            local reason = (args[2]) and args[2] or ""
            local source = vRP.getUserSource({id})
            vRP.kick({source,reason})
            sendToDiscord("Kick - Ingame", "**"..id.."** er lige blevet kicket med grunden: **"..reason.."**","https://autisthook.com/api/webhooks/589801337265586187/4kZ28hx4rB-jp3O-jE1Gb0h7EUfqM2xhxc5RxoPKOM_7c2LlagFmEADxziXZs33ETaLz")
        end
    elseif commandName == "lpban" then
        CancelEvent()
        local id = tonumber(args[1]);
        if id ~= nil then
            if(args[2] ~= nil) then
                vRP.ban({id,args[2]})
                sendToDiscord("Ban - Ingame", "**"..id.."** er lige blevet bannet med grunden: **"..args[2].."**","https://autisthook.com/api/webhooks/589801144818073611/piAUc9Mp_igWvbxQ3qvZ-l7MC9HYbhsD675USdyK4qOJYuS5vusehb9L0XNG8hoYViMf")
            end
        end
    elseif commandName == "lpunban" then
        CancelEvent()
        local id = tonumber(args[1]);
        if id ~= nil then
            vRP.unban({id})
            sendToDiscord("Unban - Ingame", "**"..id.."** er lige blevet unbannet","https://autisthook.com/api/webhooks/589801077046509568/AoPQs32Q0dXxHak2eNkRmQUjtPoLigVbcdpngpAxwmKHAlaaHGVXpsmpwBm0EPN7Faqh")
        end


    elseif commandName == "revive" then
        CancelEvent()
        local id = tonumber(args[1]);
        if id ~= nil then
          local source = vRP.getUserSource({id})
          if source then
              TriggerClientEvent("api-web:revive",source)
              TriggerClientEvent("pNotify:SendNotification", source,{text = "<h2 style='text-align:center; margin: 10px 0 25px 0;'>STAFF REVIVE</h2>"..args[2].." <h3 style='text-align:center; margin: 25px 0 10px 0;'>Mvh. "..args[3].."</h3>", type = "error", queue = "global", timeout = 20000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end


    elseif commandName == "alert" then
        CancelEvent()
        local id = tonumber(args[1]);
        if id ~= nil then
            local source = vRP.getUserSource({id})
            if source then
                TriggerClientEvent("api-web:alert",source)
                TriggerClientEvent("pNotify:SendNotification", source,{text = "<h2 style='text-align:center; margin: 10px 0 25px 0;'>STAFF ALERT</h2>"..args[2].." <h3 style='text-align:center; margin: 25px 0 10px 0;'>Mvh. "..args[3].."</h3>", type = "error", queue = "global", timeout = 20000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end
    end
end)
function sendToDiscord(name, message, discord)
    if message == nil or message == '' or message:sub(1, 1) == '/' then return FALSE end
    PerformHttpRequest(discord, function(err, text, headers) end, 'POST', json.encode({avatar_url = "https://i.imgur.com/HUgauWf.png",username = name,content = message}), { ['Content-Type'] = 'application/json' })
end
