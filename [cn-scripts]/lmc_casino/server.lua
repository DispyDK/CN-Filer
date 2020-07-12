local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("lmc_casino","lmc_casino")
vRPct = Tunnel.getInterface("vRP","lmc_casino")


isRoll = false
amount = 50000



RegisterServerEvent('lmc_casino:getLucky')
AddEventHandler('lmc_casino:getLucky', function()
    local _source = source
    local user_id = vRP.getUserId({_source})
    if not isRoll then
        if user_id ~= nil then
            if vRP.tryFullPayment({user_id,amount}) then
                isRoll = true
                -- local _priceIndex = math.random(1, 20)
                local _randomPrice = math.random(1, 100)
                if _randomPrice == 1 then
                    -- Win car
                    local _subRan = math.random(1,10)
                    if _subRan <= 1 then
                        _priceIndex = 19
                    else
                        _priceIndex = 3
                    end
                elseif _randomPrice > 1 and _randomPrice <= 6 then
                    -- Win skin AK Gold
                    _priceIndex = 12
                    local _subRan = math.random(1,20)
                    if _subRan <= 2 then
                        _priceIndex = 12
                    else
                        _priceIndex = 7
                    end
                elseif _randomPrice > 6 and _randomPrice <= 15 then
                    -- Black money
                    -- 4, 8, 11, 16
                    local _sRan = math.random(1, 4)
                    if _sRan == 1 then
                        _priceIndex = 4
                    elseif _sRan == 2 then
                        _priceIndex = 8
                    elseif _sRan == 3 then
                        _priceIndex = 11
                    else
                        _priceIndex = 16
                    end
                elseif _randomPrice > 15 and _randomPrice <= 25 then
                    -- Win 300,000$
                    -- _priceIndex = 5
                    local _subRan = math.random(1,20)
                    if _subRan <= 2 then
                        _priceIndex = 5
                    else
                        _priceIndex = 20
                    end
                elseif _randomPrice > 25 and _randomPrice <= 40 then
                    -- 1, 9, 13, 17
                    local _sRan = math.random(1, 4)
                    if _sRan == 1 then
                        _priceIndex = 1
                    elseif _sRan == 2 then
                        _priceIndex = 9
                    elseif _sRan == 3 then
                        _priceIndex = 13
                    else
                        _priceIndex = 17
                    end
                elseif _randomPrice > 40 and _randomPrice <= 60 then
                    local _itemList = {}
                    _itemList[1] = 2
                    _itemList[2] = 6
                    _itemList[3] = 10
                    _itemList[4] = 14
                    _itemList[5] = 18
                    _priceIndex = _itemList[math.random(1, 5)]
                elseif _randomPrice > 60 and _randomPrice <= 100 then
                    local _itemList = {}
                    _itemList[1] = 3
                    _itemList[2] = 7
                    _itemList[3] = 15
                    _itemList[4] = 20
                    _priceIndex = _itemList[math.random(1, 4)]
                end
                -- print("Price " .. _priceIndex)
                SetTimeout(12000, function()
                    isRoll = false
                    -- Give Price
                    if _priceIndex == 1 or _priceIndex == 9 or _priceIndex == 13 or _priceIndex == 17 then
                        vRP.giveInventoryItem({user_id, "polet", 10, true})
                      --  TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^8LYKKEHJULET: ^1'.. user_id .. " har lige vundet 10 poletter")
                      sendToDiscord("Lykkehjulet - Casino", 'Lykkehjulet: **'..user_id..'** - Vandt 10 poletter')
                    elseif _priceIndex == 2 or _priceIndex == 6 or _priceIndex == 10 or _priceIndex == 14 or _priceIndex == 18 then
                        vRP.giveInventoryItem({user_id, "silvercard", 1, true})
                    --    TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^8LYKKEHJULET: ^1'.. user_id .. " har lige vundet 1 sølv kort")
                    sendToDiscord("Lykkehjulet - Casino", 'Lykkehjulet: **'..user_id..'** - Vandt 1 sølv kort')
                    elseif _priceIndex == 3 or _priceIndex == 7 or _priceIndex == 15 or _priceIndex == 20 then
                        vRP.giveInventoryItem({user_id, "goldencard", 1, true})
                      --  TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^8LYKKEHJULET: ^1'.. user_id .. " har lige vundet 1 guld kort")
                      sendToDiscord("Lykkehjulet - Casino", 'Lykkehjulet: **'..user_id..'** - Vandt 1 guld kort')
                    elseif _priceIndex == 4 or _priceIndex == 8 or _priceIndex == 11 or _priceIndex == 16 then
                      vRP.giveInventoryItem({user_id, "polet", 100, true})
                      --  TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^8LYKKEHJULET: ^1'.. user_id .. " har lige vundet 100 poletter")
                      sendToDiscord("Lykkehjulet - Casino", 'Lykkehjulet: **'..user_id..'** - Vandt 100 poletter')
                    elseif _priceIndex == 5 then
                      vRP.giveInventoryItem({user_id, "polet", 250, true})
                      --  TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^8LYKKEHJULET: ^1'.. user_id .. " har lige vundet 250 poletter")
                      sendToDiscord("Lykkehjulet - Casino", 'Lykkehjulet: **'..user_id..'** - Vandt 250 poletter')
                    elseif _priceIndex == 12 then
                      vRP.giveInventoryItem({user_id, "polet", 350, true})
                      --  TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^8LYKKEHJULET: ^1'.. user_id .. " har lige vundet 350 poletter")
                      sendToDiscord("Lykkehjulet - Casino", 'Lykkehjulet: **'..user_id..'** - Vandt 350 poletter')
                    elseif _priceIndex == 19 then
                    vRP.giveInventoryItem({user_id, "polet", 20000, true})
                      --  TriggerClientEvent('chatMessage', -1, '', {255,255,255}, '^8LYKKEHJULET: ^1En person har lige vundet 20000 poletter')
                        sendToDiscord("Lykkehjulet - Casino", 'Lykkehjulet: **'..user_id..'** - Vandt 20000 poletter')
                    end
                    TriggerClientEvent("lmc_casino:rollFinished", -1)
                end)
                TriggerClientEvent("lmc_casino:doRoll", -1, _priceIndex)
            else
                TriggerClientEvent("lmc_casino:rollFinished", -1)
            end
        end
    end
end)


function sendToDiscord(name, message)
    if message == nil or message == '' or message:sub(1, 1) == '/' then return FALSE end
    local server = GetConvar("servernumber", "0")
		PerformHttpRequest('https://autisthook.com/api/webhooks/722520667789983826/kk54sd9SNh9owhB4KX7LBOXsNjUi3qK1FxH6nOwFFv0VgQsAq_Osi-ym98sJrW8w2m7T', function(err, text, headers) end, 'POST', json.encode({username = name, content = message}), { ['Content-Type'] = 'application/json' })
end
