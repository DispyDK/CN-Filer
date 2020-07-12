local spawned = true
local _wheel = nil
local _lambo = nil
local _isShowCar = false
local _wheelPos = vector3(1109.76, 227.89, -49.64)
local _baseWheelPos = vector3(1111.05, 229.81, -50.18)
local Keys = {
	["ESC"] = 322, ["BACKSPACE"] = 177, ["E"] = 38, ["ENTER"] = 18,	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173
}
local _isRolling = false

Citizen.CreateThread(function()


    if spawned then
        local model = GetHashKey('vw_prop_vw_luckywheel_02a')
        local baseWheelModel = GetHashKey('vw_prop_vw_luckywheel_01a')
        local carmodel = GetHashKey('thrax')

        Citizen.CreateThread(function()
            -- Base wheel
            RequestModel(baseWheelModel)
            while not HasModelLoaded(baseWheelModel) do
                Citizen.Wait(0)
            end
            RequestModel(model)

            while not HasModelLoaded(model) do
                Citizen.Wait(0)
            end

            _wheel = CreateObject(model, 1111.05, 229.81, -50.5, false, false, true)
            SetEntityHeading(_wheel, 0.0)
            SetModelAsNoLongerNeeded(model)

            -- Car
            RequestModel(carmodel)
            while not HasModelLoaded(carmodel) do
                Citizen.Wait(0)
            end

            local vehicle = CreateVehicle(carmodel, 1100.39, 220.09, -51.0, 0.0, false, false)

            SetModelAsNoLongerNeeded(carmodel)
            FreezeEntityPosition(vehicle, true)
            local _curPos = GetEntityCoords(vehicle)
            SetEntityCoords(vehicle, _curPos.x, _curPos.y, _curPos.z + 1, false, false, true, true)
            _lambo = vehicle

        end)
    end
end)

Citizen.CreateThread(function()
    while true do
        if _lambo ~= nil then
            local _heading = GetEntityHeading(_lambo)
            local _z = _heading - 0.3
            SetEntityHeading(_lambo, _z)
        end
        Citizen.Wait(5)
    end
end)

RegisterNetEvent("lmc_casino:doRoll")
AddEventHandler("lmc_casino:doRoll", function(_priceIndex)
    _isRolling = true
    SetEntityHeading(_wheel, -30.0)
    SetEntityRotation(_wheel, 0.0, 0.0, 0.0, 1, true)
    Citizen.CreateThread(function()
        local speedIntCnt = 1
        local rollspeed = 1.0
        local _winAngle = (_priceIndex - 1) * 18
        local _rollAngle = _winAngle + (360 * 8)
        local _midLength = (_rollAngle / 2)
        local intCnt = 0
        while speedIntCnt > 0 do
            local retval = GetEntityRotation(_wheel, 1)
            if _rollAngle > _midLength then
                speedIntCnt = speedIntCnt + 1
            else
                speedIntCnt = speedIntCnt - 1
                if speedIntCnt < 0 then
                    speedIntCnt = 0

                end
            end
            intCnt = intCnt + 1
            rollspeed = speedIntCnt / 10
            local _y = retval.y - rollspeed
            _rollAngle = _rollAngle - rollspeed
            SetEntityRotation(_wheel, 0.0, _y, 0.0, 1, true)
            Citizen.Wait(0)
        end
    end)
end)

RegisterNetEvent("lmc_casino:rollFinished")
AddEventHandler("lmc_casino:rollFinished", function()
    _isRolling = false
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function doRoll()
    if not _isRolling then
        _isRolling = true
        local playerPed = PlayerPedId()
				loadAnimDict("anim_casino_a@amb@casino@games@lucky7wheel@male")
            local _movePos = vector3(1109.55, 228.88, -49.64)
            TaskGoStraightToCoord(playerPed,  _movePos.x,  _movePos.y,  _movePos.z,  1.0,  -1,  312.2,  0.0)
            local _isMoved = false
            while not _isMoved do
                local coords = GetEntityCoords(PlayerPedId())
                if coords.x >= (_movePos.x - 0.01) and coords.x <= (_movePos.x + 0.01) and coords.y >= (_movePos.y - 0.01) and coords.y <= (_movePos.y + 0.01) then
                    _isMoved = true
                end
                Citizen.Wait(0)
            end
            TaskPlayAnim(playerPed, 'anim_casino_a@amb@casino@games@lucky7wheel@male', anim, 8.0, -8.0, -1, 0, 0, false, false, false)
						print(TaskPlayAnim(playerPed, 'anim_casino_a@amb@casino@games@lucky7wheel@male', anim, 8.0, -8.0, -1, 0, 0, false, false, false))
            while IsEntityPlayingAnim(playerPed, 'anim_casino_a@amb@casino@games@lucky7wheel@male', anim, 3) do
                    Citizen.Wait(0)
                    DisableAllControlActions(0)
            end
            TaskPlayAnim(playerPed, 'anim_casino_a@amb@casino@games@lucky7wheel@male', 'enter_to_armraisedidle', 8.0, -8.0, -1, 0, 0, false, false, false)
            while IsEntityPlayingAnim(playerPed, 'anim_casino_a@amb@casino@games@lucky7wheel@male', 'enter_to_armraisedidle', 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end
            TriggerServerEvent("lmc_casino:getLucky")
            TaskPlayAnim(playerPed, 'anim_casino_a@amb@casino@games@lucky7wheel@male', 'armraisedidle_to_spinningidle_high', 8.0, -8.0, -1, 0, 0, false, false, false)

    end
end

-- Menu Controls
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(1)
        local coords = GetEntityCoords(PlayerPedId())

        if(GetDistanceBetweenCoords(coords, _wheelPos.x, _wheelPos.y, _wheelPos.z, true) < 1.5) and not _isRolling then
            showHelpText("Tryk E for at spinne - Pris: 50000 DKK")
            if IsControlJustReleased(0, Keys['E']) then
                doRoll()
            end
        end
	end
end)


function showHelpText(s)
	SetTextComponentFormat("STRING")
	AddTextComponentString(s)
	EndTextCommandDisplayHelp(0,0,0,-1)
end
