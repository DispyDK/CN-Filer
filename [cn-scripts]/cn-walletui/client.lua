
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 178) then
					TriggerServerEvent('cn-walletui:getMoneys')
            SendNUIMessage({control = 'DELETE'})
        end
    end
end)

RegisterNetEvent("cn-walletui:setValues")
AddEventHandler("cn-walletui:setValues", function(wallet, bank, debt)
    SendNUIMessage({
        wallet = format_thousand(wallet),
        bank = format_thousand(bank),
        debt = format_thousand(debt)
    })
end)

format_thousand = function(v)
    local s = string.format("%d", math.floor(v))
    local pos = string.len(s) % 3
    if pos == 0 then pos = 3 end
    return string.sub(s, 1, pos)
    .. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end
