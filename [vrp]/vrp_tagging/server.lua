local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterServerEvent('vrp_tagging:check')
AddEventHandler('vrp_tagging:check', function()
    local source = source
    local user_id = vRP.getUserId({source})

    local player = vRP.getUserSource({user_id})
    local cop = vRP.hasGroup({user_id,"Politi-Job"})
    if not cop then
        local trigger = false
        if vRP.hasGroup({user_id,"Tagging"}) then
            trigger = true
        end
        TriggerClientEvent('vrp_tagging:alarm',player, trigger)
    end
end)


function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end