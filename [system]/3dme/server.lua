local logEnabled = true

RegisterServerEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(text, userid, name, radius,diff,time)
	TriggerClientEvent('3dme:triggerDisplay', -1, text, source, radius,time)
	local message = "/me **"..tostring(userid).."** - **"..name.."**: "..text
	if diff then
		PerformHttpRequest('https://autisthook.com/api/webhooks/601915563027202050/YSCPyKKslDQLsnY60Fbz3EU1i2to_yGVwuzvbqLnOvQdoSwQOUK5D5v4fGTD9ncim5q2', function(err, text, headers) end, 'POST', json.encode({username = GetPlayerName(source), content = message}), { ['Content-Type'] = 'application/json' })
	else
		local server = GetConvar("servernumber", "0")
		if server == "1" then
			PerformHttpRequest('https://autisthook.com/api/webhooks/597822343045316619/WO-7_7LsEc82eIY2AgGfZBYS3gc0vRtJvZMuteaMLVVNfylzumFpmCFmAB1Dqq6ZZwlL', function(err, text, headers) end, 'POST', json.encode({username = GetPlayerName(source), content = message}), { ['Content-Type'] = 'application/json' })
		elseif server == "2" then
			PerformHttpRequest('https://autisthook.com/api/webhooks/597822496590528512/kbeq7T4FI2_sFaZJpcuympqR1z1SNEsb1O9V5DC9a7FF_g_ldnHnt1KrgO_HpPX0qt4a', function(err, text, headers) end, 'POST', json.encode({username = GetPlayerName(source), content = message}), { ['Content-Type'] = 'application/json' })
		elseif server == "3" then
			PerformHttpRequest('https://autisthook.com/api/webhooks/597822536184758272/GgAsXvdqucIamOg9LnwSt0r4iC4kzG_IIDg9FOuQdRQuxsvB8YuFuv1EfER2nlptfutY', function(err, text, headers) end, 'POST', json.encode({username = GetPlayerName(source), content = message}), { ['Content-Type'] = 'application/json' })
		elseif server == "4" then
			PerformHttpRequest('https://autisthook.com/api/webhooks/597822579054477324/PvJXmaZO7u_NPBnicIEXtzn6MvKAADyOzgZrDVTWvAKDGWCqn39ZUu1WyYDRb_okXha0', function(err, text, headers) end, 'POST', json.encode({username = GetPlayerName(source), content = message}), { ['Content-Type'] = 'application/json' })
		end
	end
end)
