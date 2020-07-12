------------------ change this -------------------

admins = {
	'steam:110000106914569', --Planke
    'steam:11000010345dd6f', --Iplaynaked
    'steam:11000013bf2dc9a', --Iplaynaded 2nd acc
    'steam:110000104771B51', --Lasse
    'steam:110000104BB3E64', --Niller
    'steam:1100001120E5DC8', --Niller 2nd acc
    'steam:1100001032E5953', --Vargas
    'steam:110000108D38F4C', --Doctercute
    'steam:11000011446AF89', --JooMoo
    'steam:11000010AE0D4EC', --Callesoe
	'steam:110000101FAA109', --Branco
	'steam:1100001038313FD', --Ørnen

    --'license:1234975143578921327',
}

-- Set this to false if you don't want the weather to change automatically every 10 minutes.
DynamicWeather = true

--------------------------------------------------
debugprint = false -- don't touch this unless you know what you're doing or you're being asked by Vespura to turn this on.
--------------------------------------------------







-------------------- DON'T CHANGE THIS --------------------
AvailableWeatherTypes = {
    'EXTRASUNNY',
    'CLEAR',
    'NEUTRAL',
    'SMOG',
    'FOGGY',
    'OVERCAST',
    'CLOUDS',
    'CLEARING',
    'THUNDER',
    'SNOW',
    'BLIZZARD',
    'SNOWLIGHT',
    'XMAS',
    'HALLOWEEN',
    'RAIN',
}
CurrentWeather = "EXTRASUNNY"
local baseTime = 0
local timeOffset = 0
local freezeTime = false
local blackout = false
local newWeatherTimer = 20

RegisterServerEvent('vSync:requestSync')
AddEventHandler('vSync:requestSync', function()
    TriggerClientEvent('vSync:updateWeather', -1, CurrentWeather, blackout)
    TriggerClientEvent('vSync:updateTime', -1, baseTime, timeOffset, freezeTime)
end)

function isAllowedToChange(player)
    local allowed = false
    for i,id in ipairs(admins) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if debugprint then print('admin id: ' .. id .. '\nplayer id:' .. pid) end
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end
    return allowed
end

RegisterCommand('frystid', function(source, args)
    if source ~= 0 then
        if isAllowedToChange(source) then
            frystid = not frystid
            if frystid then
                TriggerClientEvent('vSync:notify', source, 'Tiden er nu ~b~frossen~s~.')
            else
                TriggerClientEvent('vSync:notify', source, 'Tiden er ~y~ikke længere frossen~s~.')
            end
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Fejl: ^1Du har ikke tilladelse til at bruge denne kommando.')
        end
    else
        frystid = not frystid
        if frystid then
            print("Tiden er nu frossen.")
        else
            print("Tiden er ikke længere frossen.")
        end
    end
end)

RegisterCommand('frysvejr', function(source, args)
    if source ~= 0 then
        if isAllowedToChange(source) then
            DynamicWeather = not DynamicWeather
            if not DynamicWeather then
                TriggerClientEvent('vSync:notify', source, 'Dynask vejr skifte er nu ~r~deaktiveret~s~.')
            else
                TriggerClientEvent('vSync:notify', source, 'Dynask vejr skifte er nu ~b~aktiveret~s~.')
            end
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Fejl: ^1Du har ikke tilladelse til at bruge denne kommando.')
        end
    else
        DynamicWeather = not DynamicWeather
        if not DynamicWeather then
            print("Vejret er nu frosset.")
        else
            print("Vejret er ikke længere frosset.")
        end
    end
end)

RegisterCommand('vejr', function(source, args)
    if source == 0 then
        local validWeatherType = false
        if args[1] == nil then
            print("Sikker på du skrev kommandoen korrekt? ['/vejr <tilstand>'] ")
            return
        else
            for i,wtype in ipairs(AvailableWeatherTypes) do
                if wtype == string.upper(args[1]) then
                    validWeatherType = true
                end
            end
            if validWeatherType then
                print("Vejret er blevet opdateret.")
                CurrentWeather = string.upper(args[1])
                newWeatherTimer = 10
                TriggerEvent('vSync:requestSync')
            else
                print("Forkert vejrtype, rigtige typer er: \nEXTRASUNNY CLEAR NEUTRAL SMOG FOGGY OVERCAST CLOUDS CLEARING RAIN THUNDER SNOW BLIZZARD SNOWLIGHT XMAS HALLOWEEN ")
            end
        end
    else
        if isAllowedToChange(source) then
            local validWeatherType = false
            if args[1] == nil then
                TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Fejl: ^1Forkert kommando, brug ^0/vejr <VejrType> ^1i stedet!')
            else
                for i,wtype in ipairs(AvailableWeatherTypes) do
                    if wtype == string.upper(args[1]) then
                        validWeatherType = true
                    end
                end
                if validWeatherType then
                    TriggerClientEvent('vSync:notify', source, 'Vejret vil blive ændret til: ~y~' .. string.lower(args[1]) .. "~s~.")
                    CurrentWeather = string.upper(args[1])
                    newWeatherTimer = 10
                    TriggerEvent('vSync:requestSync')
                else
                    TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Fejl: ^1Forkert vejrtype, rigtige typer er: ^0\nEXTRASUNNY CLEAR NEUTRAL SMOG FOGGY OVERCAST CLOUDS CLEARING RAIN THUNDER SNOW BLIZZARD SNOWLIGHT XMAS HALLOWEEN ')
                end
            end
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Fejl: ^1Du har ikke tilladelse til at bruge denne kommando.')
            print('Adgang til kommandoen /vejr nægtet.')
        end
    end
end, false)

RegisterCommand('blackout', function(source)
    if source == 0 then
        blackout = not blackout
        if blackout then
            print("Blackout er aktiveret.")
        else
            print("Blackout er deaktiveret.")
        end
    else
        if isAllowedToChange(source) then
            blackout = not blackout
            if blackout then
                TriggerClientEvent('vSync:notify', source, 'Blackout er ~b~aktiveret~s~.')
            else
                TriggerClientEvent('vSync:notify', source, 'Blackout er ~r~deaktiveret~s~.')
            end
            TriggerEvent('vSync:requestSync')
        end
    end
end)

RegisterCommand('morgen', function(source)
    if source == 0 then
        print("For consollen, brug \"/tid <tt> <mm>\" kommando istedet!")
        return
    end
    if isAllowedToChange(source) then
        ShiftToMinute(0)
        ShiftToHour(9)
        TriggerClientEvent('vSync:notify', source, 'Tid sat til ~y~morning~s~.')
        TriggerEvent('vSync:requestSync')
    end
end)
RegisterCommand('middag', function(source)
    if source == 0 then
        print("For consollen, brug \"/tid <tt> <mm>\" kommando istedet!")
        return
    end
    if isAllowedToChange(source) then
        ShiftToMinute(0)
        ShiftToHour(12)
        TriggerClientEvent('vSync:notify', source, 'Tid sat til ~y~noon~s~.')
        TriggerEvent('vSync:requestSync')
    end
end)
RegisterCommand('aften', function(source)
    if source == 0 then
        print("For consollen, brug \"/tid <tt> <mm>\" kommando istedet!")
        return
    end
    if isAllowedToChange(source) then
        ShiftToMinute(0)
        ShiftToHour(18)
        TriggerClientEvent('vSync:notify', source, 'Tid sat til ~y~evening~s~.')
        TriggerEvent('vSync:requestSync')
    end
end)
RegisterCommand('nat', function(source)
    if source == 0 then
        print("For consollen, brug \"/tid <tt> <mm>\" kommando istedet!")
        return
    end
    if isAllowedToChange(source) then
        ShiftToMinute(0)
        ShiftToHour(23)
        TriggerClientEvent('vSync:notify', source, 'Tid sat til ~y~night~s~.')
        TriggerEvent('vSync:requestSync')
    end
end)

function ShiftToMinute(minute)
    timeOffset = timeOffset - ( ( (baseTime+timeOffset) % 60 ) - minute )
end

function ShiftToHour(hour)
    timeOffset = timeOffset - ( ( ((baseTime+timeOffset)/60) % 24 ) - hour ) * 60
end

RegisterCommand('tid', function(source, args, rawCommand)
    if source == 0 then
        if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
            local argh = tonumber(args[1])
            local argm = tonumber(args[2])
            if argh < 24 then
                ShiftToHour(argh)
            else
                ShiftToHour(0)
            end
            if argm < 60 then
                ShiftToMinute(argm)
            else
                ShiftToMinute(0)
            end
            print("Tiden er ændret til " .. argh .. ":" .. argm .. ".")
            TriggerEvent('vSync:requestSync')
        else
            print("Forkert kommando, korrekt kommando: tid <timer> <minutter> !")
        end
    elseif source ~= 0 then
        if isAllowedToChange(source) then
            if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
                local argh = tonumber(args[1])
                local argm = tonumber(args[2])
                if argh < 24 then
                    ShiftToHour(argh)
                else
                    ShiftToHour(0)
                end
                if argm < 60 then
                    ShiftToMinute(argm)
                else
                    ShiftToMinute(0)
                end
                local newtime = math.floor(((baseTime+timeOffset)/60)%24) .. ":"
				local minute = math.floor((baseTime+timeOffset)%60)
                if minute < 10 then
                    newtime = newtime .. "0" .. minute
                else
                    newtime = newtime .. minute
                end
                TriggerClientEvent('vSync:notify', source, 'Tiden er ændret til: ~y~' .. newtime .. "~s~!")
                TriggerEvent('vSync:requestSync')
            else
                TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Fejl: ^1Forkert Kommando. Brug ^0/tid <timer> <minutter> ^1i stedet!')
            end
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Fejl: ^1Du har ikke adgang til at bruge denne kommando.')
            print('Adgang til kommandoen /tid nægtet.')
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local newBaseTime = os.time(os.date("!*t"))/2 + 360
        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime
        end
        baseTime = newBaseTime
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        TriggerClientEvent('vSync:updateTime', -1, baseTime, timeOffset, freezeTime)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)
        TriggerClientEvent('vSync:updateWeather', -1, CurrentWeather, blackout)
    end
end)

Citizen.CreateThread(function()
    while true do
        newWeatherTimer = newWeatherTimer - 1
        Citizen.Wait(60000)
        if newWeatherTimer == 0 then
            if DynamicWeather then
                NextWeatherStage()
            end
            newWeatherTimer = 20
        end
    end
end)

function NextWeatherStage()
        local new = math.random(1,9)
        if new == 1 then
          CurrentWeather = "CLOUDS"
        elseif new == 2 then
            CurrentWeather = "CLOUDS"
        elseif new == 3 then
            CurrentWeather = "CLEAR"
        elseif new == 4 then
            CurrentWeather = "CLEAR"
        elseif new == 5 then
            CurrentWeather = "SMOG"
        else
            CurrentWeather = "EXTRASUNNY"
        end
    TriggerEvent("vSync:requestSync")
    if debugprint then
        print("[cn-vejrsync] Ny tilfældig vejrindstilling sat til: " .. CurrentWeather .. ".\n")
        print("[cn-vejrsync] Genstarter til til 10 min.\n")
    end
end
