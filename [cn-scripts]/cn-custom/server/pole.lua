RegisterServerEvent("DanceServer")
AddEventHandler("DanceServer", function()
	TriggerClientEvent("DanceClient",-1)
end)

