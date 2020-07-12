
local items = {}

items["medkit"] = {"Medkit","Bruges til genoplivning af bevidstløs mennesker.",nil,0.5 }
items["bandage"] = {"Plaster","Bruges til at helbrede personer.",nil,0.05}
items["dirty_money"] = {"Dollars", "Real American Dollars",nil,0}
items["repairkit"] = {"Professionelt Værktøj","Bruges til at reparere køretøjer.",nil,0.5}

-- money
items["money"] = {"Kontanter","Sammenpakket penge.",function(args)
	local choices = {}
	local idname = args[1]

	choices["> Pak ud"] = {function(player,choice,mod)
		local user_id = vRP.getUserId(player)
		if user_id ~= nil then
			local amount = vRP.getInventoryItemAmount(user_id, idname)
			vRP.prompt(player, "Beløb du ønsker at udpakke ? (maks "..amount..")", "", function(player,ramount)
				ramount = parseInt(ramount)
				if vRP.tryGetInventoryItem(user_id, idname, ramount, true) then -- unpack the money
					vRP.giveMoney(user_id, ramount)
					vRP.closeMenu(player)
				end
			end)
		end
	end}

	return choices
end,0}


-- Pengepose
items["pengepose"] = {"Pengepose","Pose med penge (50000).",function(args)
	local choices = {}
	local idname = args[1]

	choices["> Åben"] = {function(player,choice,mod)
		local user_id = vRP.getUserId(player)
		if user_id ~= nil then
			if vRP.tryGetInventoryItem(user_id, "pengepose", 1, true) then
				vRP.giveInventoryItem(user_id, "dirty_money", 50000, true)
			end
		end
	end}

	return choices
end,25}


-- Svejser
items["skaerebraender"] = {"Skærebrænder","Bruges til at svejse.",function(args)
	local choices = {}
	local idname = args[1]

	choices["> Brug"] = {function(player,choice,mod)
		local user_id = vRP.getUserId(player)
		if user_id ~= nil then
			local amount = vRP.getInventoryItemAmount(user_id, idname)
			TriggerClientEvent("cn-animation:start", player, "weld")
			vRP.tryGetInventoryItem(user_id, "skaerebraender", 1, true)
            Wait(60000)
            vRPanim.getCurrentAnim(player,{},function(anim)
            if anim == "weld" then
				vRPclient.getNearestPlayer(player,{10},function(nplayer)
					local nuser_id = vRP.getUserId(nplayer)
					if nuser_id ~= nil then
						vRPclient.ejectVehicle(nplayer, {})
					end

				end)
				TriggerClientEvent("cn-animation:stopAnim", player)

            else
          TriggerClientEvent("pNotify:SendNotification", player,{text = "Du afbrød handlingen, og kom ikke ind i bilen!", type = "error", queue = "global", timeout = 3000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
			end)
		end
	end}

	return choices
end,15}

-- Faxekondi
items["faxekondi"] = {"Faxe Kondi","Indeholder glukose - Læskedrik",function(args)
	local choices = {}
	local idname = args[1]

	choices["> Brug"] = {function(player,choice,mod)
		local user_id = vRP.getUserId(player)
		if user_id ~= nil then
			if vRP.tryGetInventoryItem(user_id, "skaerebraender", 1, true) then
				TriggerClientEvent("cn-animation:startWithItem", player, "faxe")
			end
		end
	end}

	return choices
end,0.1}

---- Koben
--items["koben"] = {"Koben","Bruges til at bryde ind i ting.",function(args)
--	local choices = {}
--	local idname = args[1]
--
--	choices["> Brug"] = {function(player,choice,mod)
--		local user_id = vRP.getUserId(player)
--		vRPclient.getNearestPlayer(player,{10},function(nplayer)
--			local nuser_id = vRP.getUserId(nplayer)
--			local user_id = vRP.getUserId(player)
--			if user_id ~= nil then
--				local amount = vRP.getInventoryItemAmount(user_id, idname)
--				TriggerClientEvent("cn-animation:startWithoutNotify", player, "breakopentrunk")
--				vRP.tryGetInventoryItem(user_id, "koben", 1, true)
--				Wait(30000) --30000
--				vRPanim.getCurrentAnim(player,{},function(anim)
--					if anim == "breakopentrunk" then
--						vRPclient.getNearestOwnedVehicle(nplayer,{7},function(ok,vtype,name)
--							if ok then
--								vRP.request(player,"Sikker på du vil bryde bagagerummet op på "..name.."?", 60, function(v,ok)
--									if ok then -- take the call
--										local chestname = "u"..nuser_id.."veh_"..string.lower(name)
--										local max_weight = cfg_inventory.vehicle_chest_weights[string.lower(name)] or cfg_inventory.default_vehicle_chest_weight
--
--										-- open chest
--										local cb_out = function(idname,amount)
--											TriggerClientEvent("pNotify:SendNotification", nplayer,{text = {lang.inventory.give.given({vRP.getItemName(idname),amount})}, type = "info", queue = "global", timeout = 3000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
--										end
--
--										local cb_in = function(idname,amount)
--											TriggerClientEvent("pNotify:SendNotification", nplayer,{text = {lang.inventory.give.received({vRP.getItemName(idname),amount})}, type = "info", queue = "global", timeout = 3000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
--										end
--										TriggerClientEvent("cn-animation:startWithoutNotify", player, "breakopentrunk")
--										SetTimeout(2200, function()
--											vRPclient.vc_openDoor(nplayer, {vtype,5})
--											vRP.openChest(player, chestname, max_weight, nil,cb_in,cb_out)
--										end)
--									end
--								end)
--							else
--								TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.vehicle.no_owned_near()}, type = "info", queue = "global", timeout = 3000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
--							end
--						end)
--					end
--				end)
--			else
--				TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "info", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
--			end
--		end)
--		return choices
--	end}
--end ,10}



-- money binder
items["money_binder"] = {"Money binder","Used to bind 1000$ of money.",function(args)
	local choices = {}
	local idname = args[1]

	choices["Bind money"] = {function(player,choice,mod) -- bind the money
		local user_id = vRP.getUserId(player)
		if user_id ~= nil then
			local money = vRP.getMoney(user_id)
			if money >= 1000 then
				if vRP.tryGetInventoryItem(user_id, idname, 1, true) and vRP.tryPayment(user_id,1000) then
					vRP.giveInventoryItem(user_id, "money", 1000, true)
					vRP.closeMenu(player)
				end
			else
				TriggerClientEvent("pNotify:SendNotification",player,{text = "<span color='red'>Du har ikke nok penge.</span>", type = "error", timeout = (3000),layout = "centerLeft"})
			end
		end
	end}

	return choices
end,0}

-- parametric weapon items
-- give "wbody|WEAPON_PISTOL" and "wammo|WEAPON_PISTOL" to have pistol body and pistol bullets

local get_wname = function(weapon_id)
	local name = string.gsub(weapon_id,"WEAPON_","")
	name = string.upper(string.sub(name,1,1))..string.lower(string.sub(name,2))
	-- lang translation support, ex: weapon.pistol = "Pistol", by default use the native name
	return vRP.lang.weapon[string.lower(name)]({}, name)
end

--- weapon body
local wbody_name = function(args)
	return get_wname(args[2]).." body"
end

local wbody_desc = function(args)
	return ""
end

local wbody_choices = function(args)
	local choices = {}
	local fullidname = joinStrings(args,"|")

	choices["> Udstyr"] = {function(player,choice)
		local user_id = vRP.getUserId(player)
		if user_id ~= nil then
			if vRP.tryGetInventoryItem(user_id, fullidname, 1, true) then -- give weapon body
				local weapons = {}
				weapons[args[2]] = {ammo = 0}
				vRPclient.giveWeapons(player, {weapons})

				vRP.closeMenu(player)
			end
		end
	end}

	return choices
end

local wbody_weight = function(args)
	return 2.0
end


items["wbody"] = {wbody_name,wbody_desc,wbody_choices,wbody_weight}

--- weapon ammo
local wammo_name = function(args)
	return get_wname(args[2]).." ammo"
end

local wammo_desc = function(args)
	return ""
end

local wammo_choices = function(args)
	local choices = {}
	local fullidname = joinStrings(args,"|")

	choices["> Lad våbnet"] = {function(player,choice)
		local user_id = vRP.getUserId(player)
		if user_id ~= nil then
			local amount = vRP.getInventoryItemAmount(user_id, fullidname)
			vRP.prompt(player, "Mængde at lade ? (max "..amount..")", "", function(player,ramount)
				ramount = parseInt(ramount)

				vRPclient.getWeapons(player, {}, function(uweapons)
					if uweapons[args[2]] ~= nil then -- check if the weapon is equiped
						if vRP.tryGetInventoryItem(user_id, fullidname, ramount, true) then -- give weapon ammo
							local weapons = {}
							weapons[args[2]] = {ammo = ramount}
							vRPclient.giveWeapons(player, {weapons,false})
							vRP.closeMenu(player)
						end
					end
				end)
			end)
		end
	end}

	return choices
end

local wammo_weight = function(args)
	return 0.01
end

items["wammo"] = {wammo_name,wammo_desc,wammo_choices,wammo_weight}

--extended
local extended_name = function(args)
	return get_wname(args[2]).." extended"
end

local extended_desc = function(args)
	return ""
end

local extended_choices = function(args)
	local choices = {}
	local fullidname = joinStrings(args,"|")

	choices["> Udstyr"] = {function(player,choice)
		local user_id = vRP.getUserId(player)
		if user_id ~= nil then
			if vRP.tryGetInventoryItem(user_id, fullidname, 1, true) then -- give weapon body
				local weapons = {}
				weapons[args[2]] = {ammo = 0}
				vRPclient.giveWeapons(player, {weapons})

				vRP.closeMenu(player)
			end
		end
	end}

	return choices
end

local extended_weight = function(args)
	return 0.75
end

items["extended"] = {extended_name,extended_desc,extended_choices,extended_weight}

--silencer
local silencer_name = function(args)
	return get_wname(args[2]).." silencer"
end

local silencer_desc = function(args)
	return ""
end

local silencer_choices = function(args)
	local choices = {}
	local fullidname = joinStrings(args,"|")

	choices["> Udstyr"] = {function(player,choice)
		local user_id = vRP.getUserId(player)
		if user_id ~= nil then
			if vRP.tryGetInventoryItem(user_id, fullidname, 1, true) then -- give weapon body
				local weapons = {}
				weapons[args[2]] = {ammo = 0}
				vRPclient.giveWeapons(player, {weapons})

				vRP.closeMenu(player)
			end
		end
	end}

	return choices
end

local silencer_weight = function(args)
	return 0.75
end

items["silencer"] = {silencer_name,silencer_desc,silencer_choices,silencer_weight}

--skin
local skin_name = function(args)
	return get_wname(args[2]).." skin"
end

local skin_desc = function(args)
	return ""
end

local skin_choices = function(args)
	local choices = {}
	local fullidname = joinStrings(args,"|")

	choices["> Udstyr"] = {function(player,choice)
		local user_id = vRP.getUserId(player)
		if user_id ~= nil then
			if vRP.tryGetInventoryItem(user_id, fullidname, 1, true) then -- give weapon body
				local weapons = {}
				weapons[args[2]] = {ammo = 0}
				vRPclient.giveWeapons(player, {weapons})

				vRP.closeMenu(player)
			end
		end
	end}

	return choices
end

local skin_weight = function(args)
	return 0.75
end

items["skin"] = {skin_name,skin_desc,skin_choices,skin_weight}

return items
