local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterServerEvent('ftn-clothing:hasaccess')
AddEventHandler('ftn-clothing:hasaccess', function(menuname)
    local source = source
    local user_id = vRP.getUserId({source})
    local group = ""
    if menuname == "Politi Tøj" then group = {"Politi-Job","Politiadvokat-Job","AKS-Job"} elseif menuname == "Private Modeller" then group = "Peds" elseif menuname == "Hemmeligt" then group = "PedsV2" else group = "EMS-Job" end
    local passed = false
    if type(group) == "table" then
        for k,v in pairs(group) do
            if vRP.hasGroup({user_id,v}) then
                passed = true
            end
        end
    else
        if vRP.hasGroup({user_id,group}) then
            passed = true
        end
    end
    if passed then
        TriggerClientEvent('ftn-clothing:access', source, menuname)
    else
        TriggerClientEvent("pNotify:SendNotification", source,{text = "Ingen adgang!", type = "error", queue = "global", timeout = 2000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end)
