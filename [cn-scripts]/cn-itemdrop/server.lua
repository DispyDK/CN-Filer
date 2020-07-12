local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","cn-itemdrop")

local bagtimer = 1200
local bagcount = 0
local bags = {}

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        TriggerClientEvent("cn-itemdrop:load", source, bags)
    end
end)

RegisterServerEvent("cn-itemdrop:pickup")
AddEventHandler("cn-itemdrop:pickup", function(count)
    local bag = bags[count]
    if bags[count] ~= nil then
        bags[count] = nil
        local user_id = vRP.getUserId({source})

        local item_weight = vRP.getItemWeight({bag.item})
        local weight = vRP.getInventoryWeight({user_id})
        local max_weight = vRP.getInventoryMaxWeight({user_id})
        local left = max_weight-weight
        if max_weight-weight > item_weight*bag.amount then
            vRP.giveInventoryItem({user_id,bag.item,bag.amount,true})

            local pickup = {}
            table.insert(pickup, { name = "Fra id:", value = user_id, inline = true })
            table.insert(pickup, { name = "Til id:", value = user_id, inline = true })
            table.insert(pickup, { name = "Ting:", value = bag.item, inline = true })
            table.insert(pickup, { name = "Antal:", value = bag.amount, inline = true })
            table.insert(pickup, { name = "Aktion:", value = "player_pickup", inline = true })

            PerformHttpRequest('https://autisthook.com/api/webhooks/687797207432298511/olNuSmtjbSlx9GCqN3nYGCCg8rqsiqVvYkpYAJFd4gR3l0QvOkwlSh5umRkD2-ADZf_l', function(err, text, headers) end, 'POST', json.encode(
                {
                    username = "Server "..GetConvar("servernumber", "0"),
                    content = "Spiller: "..user_id.." samlede noget op",
                    embeds = {
                        {
                            color = 16769280,
                            fields = pickup
                        }
                    }
                }), { ['Content-Type'] = 'application/json' })

            vRPclient.playAnim(source,{true,{{"pickup_object","pickup_low",1}},false})
            TriggerClientEvent('cn-itemdrop:remove',-1,count)
        else
            if left >= item_weight then
                local amount = math.floor(left/item_weight)
                vRP.giveInventoryItem({user_id,bag.item,amount,true})

                PerformHttpRequest('https://autisthook.com/api/webhooks/687797207432298511/olNuSmtjbSlx9GCqN3nYGCCg8rqsiqVvYkpYAJFd4gR3l0QvOkwlSh5umRkD2-ADZf_l', function(err, text, headers) end, 'POST', json.encode(
                    {
                        username = "Server "..GetConvar("servernumber", "0"),
                        content = "Spiller: "..user_id.." samlede noget op",
                        embeds = {
                            {
                                color = 16769280,
                                fields = pickup
                            }
                        }
                    }), { ['Content-Type'] = 'application/json' })
                bag.amount = bag.amount-amount
                bags[count] = bag
                vRPclient.playAnim(source,{true,{{"pickup_object","pickup_low",1}},false})
                TriggerClientEvent("cn-itemdrop:update",-1,count,bag)
            else
                bags[count] = bag
                TriggerClientEvent("pNotify:SendNotification", source,{text = "Du har ikke nok plads til "..(item_weight*bag.amount).." kg", type = "error", timeout = 4000, layout = "centerRight",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
            end
        end
    end
end)

RegisterServerEvent("cn-itemdrop:drop")
AddEventHandler("cn-itemdrop:drop", function(source,item,amount)

    bagcount = bagcount+1
    local source = source

    local user_id = vRP.getUserId({source})

    local display = vRP.getItemName({item})
    vRPclient.getPosition(source, {}, function(x,y,z)
        bags[bagcount] = {display = display,amount = amount,item = item,coords={x=x,y=y,z=z},timer=bagtimer }
        TriggerClientEvent('cn-itemdrop:create',-1,bags[bagcount],bagcount)

        local drop = {}
        table.insert(drop, { name = "Fra id:", value = user_id, inline = true })
        table.insert(drop, { name = "Ting:", value = item, inline = true })
        table.insert(drop, { name = "Antal:", value = amount, inline = true })
        PerformHttpRequest('https://autisthook.com/api/webhooks/687798240749420596/uo8XjzbQJl8HdEvv2ewX6P4m3yDqNsCkZ4j4qDTf8DJEYV5Dh4xrCnR97KoZClCADQuq', function(err, text, headers) end, 'POST', json.encode(
            {
                username = "Server "..GetConvar("servernumber", "0"),
                content = "Spiller: "..user_id.." sned noget på jorden",
                embeds = {
                    {
                        color = 16769280,
                        fields = drop
                    }
                }
            }), { ['Content-Type'] = 'application/json' })

    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for k,v in pairs(bags) do
            if v.timer > 0 then
                v.timer = v.timer-1
            else
                TriggerClientEvent('cn-itemdrop:remove',-1,k)
                bags[k] = nil
            end
        end
    end
end)
