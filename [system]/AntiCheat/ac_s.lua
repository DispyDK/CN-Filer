local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

-- with this you can turn on/off specific anticheese components, note: you can also turn these off while the script is running by using events, see examples for such below
Components = {
	Teleport = false, --Due too the hospital/apartments teleporting to a different location it will mark a false positive. This is turned off to prevent spam.
	GodMode = false,
	Speedhack = false,
	WeaponBlacklist = true,
	CustomFlag = false,
	VehicleBlacklist = true,
}

--[[
event examples are:

anticheese:SetComponentStatus( component, state )
	enables or disables specific components
		component:
			an AntiCheese component, such as the ones listed above, must be a string
		state:
			the state to what the component should be set to, accepts booleans such as "true" for enabled and "false" for disabled


anticheese:ToggleComponent( component )
	sets a component to the opposite mode ( e.g. enabled becomes disabled ), there is no reason to use this.
		component:
			an AntiCheese component, such as the ones listed above, must be a string

anticheese:SetAllComponents( state )
	enables or disables **all** components
		state:
			the state to what the components should be set to, accepts booleans such as "true" for enabled and "false" for disabled


These can be used by triggering them like following:
	TriggerEvent("anticheese:SetComponentStatus", "Teleport", false)

Triggering these events from the clientside is not recommended as these get disabled globally and not just for one player.


]]


Users = {}
violations = {}





RegisterServerEvent("anticheese:timer")
AddEventHandler("anticheese:timer", function()
	if Users[source] then
		if (os.time() - Users[source]) < 15 and Components.Speedhack then -- prevent the player from doing a good old cheat engine speedhack
			DropPlayer(source, "Speedhacking")
		else
			Users[source] = os.time()
		end
	else
		Users[source] = os.time()
	end
end)

--[[
AddEventHandler('playerDropped', function() -- Again, we do not want this system to be kicking people.
	if(Users[source])then
		Users[source] = nil
	end
end)

RegisterServerEvent("anticheese:kick")
AddEventHandler("anticheese:kick", function(reason)
	DropPlayer(source, reason)
end)
]]

AddEventHandler("anticheese:SetComponentStatus", function(component, state)
	if type(component) == "string" and type(state) == "boolean" then
		Components[component] = state -- changes the component to the wished status
	end
end)

AddEventHandler("anticheese:ToggleComponent", function(component)
	if type(component) == "string" then
		Components[component] = not Components[component]
	end
end)

AddEventHandler("anticheese:SetAllComponents", function(state)
	if type(state) == "boolean" then
		for i,theComponent in pairs(Components) do
			Components[i] = state
		end
	end
end)

Citizen.CreateThread(function()
	webhook = GetConvar("ac_webhook", "none")


	function SendWebhookMessage(webhook,username,message)
		if webhook ~= "none" then
			PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = username,content = message}), { ['Content-Type'] = 'application/json' })
		end
	end

	function WarnPlayer(playername, reason)
		local isKnown = false
		local isKnownCount = 1
		local isKnownExtraText = ""
		for i,thePlayer in ipairs(violations) do
			if thePlayer.name == name then
				isKnown = true
				if violations[i].count == 3 then
					TriggerEvent("obama", source,"Cheating") -- We do not want the system automatically banning people.
					isKnownCount = violations[i].count
					table.remove(violations,i)
					isKnownExtraText = ""
				else
					violations[i].count = violations[i].count+1
					isKnownCount = violations[i].count
				end
			end
		end

		if not isKnown then
			table.insert(violations, { name = name, count = 1 })
		end

		return isKnown, isKnownCount,isKnownExtraText
	end

	function GetPlayerNeededIdentifiers(player)
		local ids = GetPlayerIdentifiers(player)
		for i,theIdentifier in ipairs(ids) do
			if string.find(theIdentifier,"steam:") or -1 > -1 then
				steam = theIdentifier
			end
		end
		if not steam then
			steam = "steam: missing"
		end
		return license, steam
	end

	RegisterServerEvent('AntiCheese:SpeedFlag')
	AddEventHandler('AntiCheese:SpeedFlag', function(rounds, roundm)
		if Components.Speedhack and not IsPlayerAceAllowed(source,"anticheese.bypass") then
			license, steam = GetPlayerNeededIdentifiers(source)

			name = GetPlayerName(source)

			isKnown, isKnownCount, isKnownExtraText = WarnPlayer(name,"Speed Hacking")

			SendWebhookMessage(webhook, "Server "..GetConvar("servernumber", "0").." - Speed Hacker", "```\nUser:"..name.."\nId:"..id.."\nIngame User-ID: "..vRP.getUserId({source}).."\n"..steam.."\nWas travelling "..rounds.. " units. That's "..roundm.." more than normal! \nAnticheat Flags:"..isKnownCount..""..isKnownExtraText.." ```")
		end
	end)



	RegisterServerEvent('AntiCheese:NoclipFlag')
	AddEventHandler('AntiCheese:NoclipFlag', function(distance)
		if Components.Speedhack and not IsPlayerAceAllowed(source,"anticheese.bypass") then
			license, steam = GetPlayerNeededIdentifiers(source)
			name = GetPlayerName(source)
			local id = source

			isKnown, isKnownCount, isKnownExtraText = WarnPlayer(name,"Noclip/Teleport Hacking")


			SendWebhookMessage(webhook, "Server "..GetConvar("servernumber", "0").." - Noclip/Teleport","```\nUser:"..name.."\nId:"..id.."\nIngame User-ID: "..vRP.getUserId({source}).."\n"..steam.."\nCaught with "..distance.." units between last checked location\nAnticheat Flags:"..isKnownCount..""..isKnownExtraText.." ```")
		end
	end)


	RegisterServerEvent('AntiCheese:CustomFlag')
	AddEventHandler('AntiCheese:CustomFlag', function(reason,extrainfo)
		if Components.CustomFlag and not IsPlayerAceAllowed(source,"anticheese.bypass") then
			license, steam = GetPlayerNeededIdentifiers(source)
			name = GetPlayerName(source)
			if not extrainfo then extrainfo = "no extra informations provided" end
			isKnown, isKnownCount, isKnownExtraText = WarnPlayer(name,reason)


			SendWebhookMessage(webhook, "Server "..GetConvar("servernumber", "0").." - CustomFlag","**"..reason.."** \n```\nUser:"..name.."\nId:"..id.."\nIngame User-ID: "..vRP.getUserId({source}).."\n"..steam.."\n"..extrainfo.."\n")
		end
	end)

	RegisterServerEvent('AntiCheese:HealthFlag')
	AddEventHandler('AntiCheese:HealthFlag', function(invincible,oldHealth, newHealth, curWait)
		if Components.GodMode and not IsPlayerAceAllowed(source,"anticheese.bypass") then
			license, steam = GetPlayerNeededIdentifiers(source)
			name = GetPlayerName(source)
			local id = source

			isKnown, isKnownCount, isKnownExtraText = WarnPlayer(name,"Health Hacking")

			if invincible then
				SendWebhookMessage(webhook, "Server "..GetConvar("servernumber", "0").." - Health Hack","```\nUser:"..name.."\nId:"..id.."\nIngame User-ID: "..vRP.getUserId({source}).."\n"..steam.."\nRegenerated "..newHealth-oldHealth.."hp ( to reach "..newHealth.."hp ) in "..curWait.."ms! (PlayerPed was invincible)\n```")
			else
				SendWebhookMessage(webhook, "Server "..GetConvar("servernumber", "0").." - Health Hack","```\nUser:"..name.."\nId:"..id.."\nIngame User-ID: "..vRP.getUserId({source}).."\n"..steam.."\nRegenerated "..newHealth-oldHealth.."hp ( to reach "..newHealth.."hp ) in "..curWait.."ms! (Health was Forced)\n```")
			end
		end
	end)

	RegisterServerEvent('AntiCheese:JumpFlag')
	AddEventHandler('AntiCheese:JumpFlag', function(jumplength)
		if Components.SuperJump and not IsPlayerAceAllowed(source,"anticheese.bypass") then
			license, steam = GetPlayerNeededIdentifiers(source)
			name = GetPlayerName(source)
			local id = source

			isKnown, isKnownCount, isKnownExtraText = WarnPlayer(name,"SuperJump Hacking")

			SendWebhookMessage(webhook, "Server "..GetConvar("servernumber", "0").." - SuperJump Hack","```\nUser:"..name.."\nId:"..id.."\nIngame User-ID: "..vRP.getUserId({source}).."\n"..steam.."\nJumped "..jumplength.."ms long\n```")
		end
	end)

	RegisterServerEvent('AntiCheese:WeaponFlag')
	AddEventHandler('AntiCheese:WeaponFlag', function(weapons)
		if Components.WeaponBlacklist and not IsPlayerAceAllowed(source,"anticheese.bypass") then
			name = GetPlayerName(source)
			local id = source
			local user_id = vRP.getUserId({source})
			isKnown, isKnownCount, isKnownExtraText = WarnPlayer(name,"Blacklisted Weapon")
			local admin = false
			if vRP.hasPermission({user_id,"blacklisted.weapons"}) then
				admin = true
			else
				vRP.ban({user_id, "Brug af blacklisted våben ("..#weapons..")",true})
			end

			local fields = {}
			local lweapons = ""
			for k,v in pairs(weapons) do
				lweapons = lweapons.."\n"..v
			end
			table.insert(fields, { name = "Name:", value = name })
			table.insert(fields, { name = "ID:", value = user_id })
			table.insert(fields, { name = "Våben:", value = lweapons })
			table.insert(fields, { name = "Ledelse:", value = (admin == true and "Ja" or "Nej") })
			table.insert(fields, { name = "Banned:", value = (admin == true and "Nej" or "Ja") })
			PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(
				{
					username = "Server "..GetConvar("servernumber", "0").." - Blacklistet Våben",
					embeds = {
						{
							color = 11871532,
							fields = fields
						}
					}
				}), { ['Content-Type'] = 'application/json' })
			--SendWebhookMessage(webhook, "Server "..GetConvar("servernumber", "0").." - Blacklisted Weapon","```\nUser:"..name.."\nId:"..id.."\nIngame User-ID: "..user_id.."\n"..steam.."\nGot Weapon: "..theWeapon.."\nAdmin: "..(admin == true and "Ja" or "Nej").."\nBanned: "..(admin == true and "Nej" or "Ja").."```")
		end
	end)
	local isAllowed = {}
	RegisterServerEvent('AntiCheese:VehicleFlag')
	AddEventHandler('AntiCheese:VehicleFlag', function(carModel)
		if Components.VehicleBlacklist and not IsPlayerAceAllowed(source,"anticheese.bypass") then
			local user_id = vRP.getUserId({source})
			if isAllowed[user_id] == nil then
				if vRP.hasPermission({user_id,"blacklisted.vehicles"}) then
					isAllowed[user_id] = true
				else
					license, steam = GetPlayerNeededIdentifiers(source)
					name = GetPlayerName(source)
					local id = source

					isKnown, isKnownCount, isKnownExtraText = WarnPlayer(name,"Blacklisted Vehicle")

					SendWebhookMessage(webhook, "Server "..GetConvar("servernumber", "0").." - Blacklisted Vehicle","```\nUser:"..name.."\nId:"..id.."\nIngame User-ID: "..user_id.."\n"..steam.."\nEntered Vehicle: "..carModel.." (Blacklisted)\n```")
				end
			end
		end
	end)
end)