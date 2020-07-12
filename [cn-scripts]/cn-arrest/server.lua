local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterServerEvent('cn-arrest:requestarrest')
AddEventHandler('cn-arrest:requestarrest', function(target, playerheading, playerCoords,  playerlocation)
    _source = source
    local xPlayer = vRP.getUserId(source)

    if vRP.hasPermission(_source,"police.menu") then
        TriggerClientEvent('cn-arrest:getarrested', target, playerheading, playerCoords, playerlocation)
        TriggerClientEvent('cn-arrest:doarrested', _source)
    end
end)

RegisterServerEvent('cn-arrest:requestrelease')
AddEventHandler('cn-arrest:requestrelease', function(target, playerheading, playerCoords,  playerlocation)
    _source = source
    local xPlayer = vRP.getUserId(source)

    if vRP.hasPermission(_source,"police.menu") then
        TriggerClientEvent('cn-arrest:getuncuffed', target, playerheading, playerCoords, playerlocation)
        TriggerClientEvent('cn-arrest:douncuffing', _source)
    end
end)