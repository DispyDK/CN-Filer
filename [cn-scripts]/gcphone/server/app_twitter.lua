function twitter_addMessage (user_id, name, message, time)
  -- RMySQL.execute("vRP/gcphone_addTweet", {userid = user_id, name = name, message = message, time = time}, function(affected)
  --   TriggerEvent("gcphone:addtweet",name,message,time)
  --   TriggerClientEvent('gcPhone:twitter_receive', -1, {userid=user_id,name=name,message=message,time=time})
  -- end)

  MySQL.Async.execute("INSERT INTO `phone_twitter`(`userid`, `name`, `message`, `time`) VALUES (@userid, @name, @message, @time)", {userid = user_id, name = name, message = message, time = time}, function(rowsChanged)
    TriggerEvent("gcphone:addtweet",name,message,time)
    TriggerClientEvent('gcPhone:twitter_receive', -1, {userid=user_id,name=name,message=message,time=time})
  end)
end

RegisterServerEvent('gcPhone:twitter_addMessage')
AddEventHandler('gcPhone:twitter_addMessage', function(message, time)
  local user_id = vRP.getUserId({source})
  local steam = GetPlayerName(source)
  vRP.getUserIdentity({user_id, function(identity)
    local name = identity.firstname.." "..identity.name
    twitter_addMessage(user_id,name,message,time)
    sendToDiscord(steam, 'TWITTER: **'..user_id..'** - **'..name..'**: '..message..'')
  end})
end)

function sendToDiscord(name, message)
    if message == nil or message == '' or message:sub(1, 1) == '/' then return FALSE end
    local server = GetConvar("servernumber", "0")
    if server == "1" then
			PerformHttpRequest('https://autisthook.com/api/webhooks/597822343045316619/WO-7_7LsEc82eIY2AgGfZBYS3gc0vRtJvZMuteaMLVVNfylzumFpmCFmAB1Dqq6ZZwlL', function(err, text, headers) end, 'POST', json.encode({username = GetPlayerName(source), content = message}), { ['Content-Type'] = 'application/json' })
		elseif server == "2" then
			PerformHttpRequest('https://autisthook.com/api/webhooks/597822496590528512/kbeq7T4FI2_sFaZJpcuympqR1z1SNEsb1O9V5DC9a7FF_g_ldnHnt1KrgO_HpPX0qt4a', function(err, text, headers) end, 'POST', json.encode({username = GetPlayerName(source), content = message}), { ['Content-Type'] = 'application/json' })
		elseif server == "3" then
			PerformHttpRequest('https://autisthook.com/api/webhooks/597822536184758272/GgAsXvdqucIamOg9LnwSt0r4iC4kzG_IIDg9FOuQdRQuxsvB8YuFuv1EfER2nlptfutY', function(err, text, headers) end, 'POST', json.encode({username = GetPlayerName(source), content = message}), { ['Content-Type'] = 'application/json' })
		elseif server == "4" then
			PerformHttpRequest('https://discordapp.com/api/webhooks/597822579054477324/PvJXmaZO7u_NPBnicIEXtzn6MvKAADyOzgZrDVTWvAKDGWCqn39ZUu1WyYDRb_okXha0', function(err, text, headers) end, 'POST', json.encode({username = GetPlayerName(source), content = message}), { ['Content-Type'] = 'application/json' })
		end
end
