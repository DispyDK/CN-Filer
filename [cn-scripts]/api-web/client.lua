RegisterNetEvent('api-web:alert')
AddEventHandler('api-web:alert', function()
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    for i=1,20 do
        Wait(1000)
        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    end
end)


RegisterNetEvent('api-web:revive')
AddEventHandler('api-web:revive', function()
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    for i=1,5 do
        Wait(1000)
        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    end
    SetEntityHealth(GetPlayerPed(-1), 200)
end)
