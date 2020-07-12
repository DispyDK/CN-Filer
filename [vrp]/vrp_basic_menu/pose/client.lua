can_putbag = true

local a = 0

function openGui()
	SetNuiFocus(false)
	SendNUIMessage({openNUI = true})
end

function closeGui()
	SetNuiFocus(false)
	SendNUIMessage({openNUI = false})
end

RegisterNetEvent('pose_off')
AddEventHandler('pose_off', function()
    DeleteEntity(bag)
    closeGui()
    can_putbag = true
end)