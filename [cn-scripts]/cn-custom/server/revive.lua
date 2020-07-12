--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 21-03-2019
-- Time: 17:35
-- Made for CiviliansNetwork
--

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")


vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_revive")

RegisterServerEvent("fuckingmetagamer")
AddEventHandler("fuckingmetagamer", function(timer, type)
  if timer == 0 then
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
    vRP.getUserIdentity({user_id, function(identity)
    TriggerClientEvent('proximityMessage', -1, player, "", {255, 153, 0}, 20, "["..type.."]["..user_id.."]** Du føler, at du blev kigget på **")
    end})
  end
end)

RegisterCommand('revive', function(source)
  local user_id = vRP.getUserId({source})
  local player = vRP.getUserSource({user_id})
  if vRP.hasPermission({user_id,"admin.revive"}) then
      vRPclient.setHealth(player, {200})
      vRP.setHunger({user_id,0})
      vRP.setThirst({user_id,0})

      PerformHttpRequest('https://autisthook.com/api/webhooks/686990773341651066/9iTEtGqp_8VvUCZc_ME_EPrRW_1_yxTcRiHS7Wdmlbv4O2bAkRmtVLPFwxgwzn1KVxhz', function(err, text, headers) end, 'POST', json.encode({username = "slash revive", content = "```\nID: "..user_id.." \n brugte revive".."(**"..os.date("%H:%M:%S %d/%m/%Y") .. "```"}), { ['Content-Type'] = 'application/json' })

  end
end)


RegisterCommand('regning', function(source)
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
    if vRP.hasGroup({user_id,"Mekaniker Domingo"}) or vRP.hasGroup({user_id,"Mekaniker-Job"}) or vRP.hasGroup({user_id,"Mekaniker Civilians"}) or vRP.hasGroup({user_id,"Mekaniker Chef"}) then
      vRP.prompt({player,"Mobilnummer:","",function(player,phone)
        if phone ~= nil and phone ~= "" then
        chargePhoneNumber(user_id,phone)
      else
        TriggerClientEvent("pNotify:SendNotification", player,{text = "Du skal indtaste et gyldigt nummer.", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
      end
      end})
    end
end)

function chargePhoneNumber(user_id,phone)
  local player = vRP.getUserSource({user_id})
  local directory_name = vRP.getPhoneDirectoryName({user_id, phone})
  if directory_name == "unknown" then
  directory_name = phone

end
  vRP.prompt({player,"Beløbet du vil opkræve "..directory_name..":","",function(player,charge)
	if charge ~= nil and charge ~= "" and tonumber(charge)>0 then
	  vRP.getUserByPhone({phone, function(target_id)
		if target_id~=nil then
			if charge ~= nil and charge ~= "" then
	          local target = vRP.getUserSource({target_id})
			  if target ~= nil then
				vRP.getUserIdentity({user_id, function(identity)
				  local my_directory_name = vRP.getPhoneDirectoryName({target_id, identity.phone})
				  if my_directory_name == "unknown" then
				    my_directory_name = identity.phone
				  end
			      local text = "" .. phone .. " har sendt dig en regning på DKK" .. charge .. " for sin services."
				  vRP.request({target,text,600,function(req_player,ok)
				    if ok then
					  local target_bank = vRP.getBankMoney({target_id}) - tonumber(charge)
					  local my_bank = vRP.getBankMoney({user_id}) + tonumber(charge)
		              if target_bank>0 then
					    vRP.setBankMoney({user_id,my_bank})
					    vRP.setBankMoney({target_id,target_bank})
						TriggerClientEvent("pNotify:SendNotification", player,{text = "Du modtog <b style='color: #4E9350'>"..charge.." DKK</b> fra "..directory_name.." for dine services.", type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
						TriggerClientEvent("pNotify:SendNotification", player,{text = phone.." modtog <b style='color: #DB4646'>"..charge.." DKK</b> for sine services.", type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
					    vRP.closeMenu({player})
                      else
						TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.money.not_enough()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
						TriggerClientEvent("pNotify:SendNotification", player,{text = directory_name.." forsøgte at betale, men har ikke penge nok til at betale for dine services.", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
                      end
				    else
						TriggerClientEvent("pNotify:SendNotification", player,{text = phone.." nægtede at betale for dine services.", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
				    end
				  end})
				end})
			  else
				TriggerClientEvent("pNotify:SendNotification", player,{text = "Du kan ikke sende regninger til offline spillere", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
			  end
			else
				TriggerClientEvent("pNotify:SendNotification", player,{text = "Din regning skal have et beløb", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
			end
		else
		 TriggerClientEvent("pNotify:SendNotification", player,{text = "Ugyldigt nummer", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
		end
	  end})
	else
		 TriggerClientEvent("pNotify:SendNotification", player,{text = "Beløbet skal være større end 0.", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
	end
  end})
end

RegisterServerEvent("gcphonePicture")
AddEventHandler("gcphonePicture", function(data)
  PerformHttpRequest('https://autisthook.com/api/webhooks/686990773341651066/9iTEtGqp_8VvUCZc_ME_EPrRW_1_yxTcRiHS7Wdmlbv4O2bAkRmtVLPFwxgwzn1KVxhz', function(err, text, headers) end, 'POST', json.encode({username = "slash sadsa", content = data}), { ['Content-Type'] = 'application/json' })
end)


local player_zero = GetHashKey('player_zero')

RegisterCommand('player_zero', function(player, args, raw)
  -- Check if the command was executed by a player
  if player ~= 0 then
    -- First we tell the player if they are player_zero or not
    local ped = GetPlayerPed(player)
    local exist = DoesEntityExist(ped)
    local model = 0
    if exist then
      model = GetEntityModel(ped)
    end

    if model == 0 or model == player_zero then
      TriggerClientEvent('chatMessage', player, 'Du er desværre ^1usynlig^7 for andre spillere, du bliver nød til at genstarte dit spil for at fixe det. ☹️')
    else
      TriggerClientEvent('chatMessage', player, 'Wuhu - Du er ^2ikke usynlig^7 for andre spillere 🐌')
    end

    -- Check if we should show others players too
  end

  local foundAny = false
  local players = GetNumPlayerIndices()
  for i = 0, players - 1, 1 do
    local source = GetPlayerFromIndex(i)
    local ped = GetPlayerPed(tostring(source))

    local exist = DoesEntityExist(ped)
    local model = 0
    if exist then
      model = GetEntityModel(ped)
    end

    if model == 0 or model == player_zero then
      local user_id = vRP.getUserId({source})
      local playername = GetPlayerName(source)
      local tmpdata = vRP.getUserTmpTable({user_id})

      -- Don't let this player show up if they have not spawned yet
      if not tmpdata or (tmpdata.spawns and tmpdata.spawns >= 1) then
        -- Tell the executer of the command
        TriggerClientEvent('chatMessage', player, "^1ID: "..user_id.."^7 er usynlig for andre spillere (player_zero bug)", user_id, playername)

        -- We found aleast one result, so we change the boolean
        foundAny = true
      end
    end
  end

  -- If no player_zero player was found tell the command executer that good news (Yeah)
  if not foundAny then
    TriggerClientEvent('chatMessage', player, "^2Ingen player_zero^7 spiller fundet, jubi 🥳")
  end
end)



local allowedFileTypes = {
    ".ytd",
    ".ydr",
    ".yft",
    ".ybn",
    ".ycd",
    
}

local showFilesAbovePhys = 35.0

local function writeLog(file,text)
    log = io.open("resources/"..file, "a")
	if log then
		log:write(text)
    else
        print("Log file doesnt exist")
    end
    log:close()
end

local function getMem(path) --credits to @github.com/blattersturm
    local f = io.open(path, 'rb')
    if f then
        local magic, version, virtual, physical = ("<c4I4I4I4"):unpack(f:read(16))
        f:close()

        if magic ~= 'RSC7' then
            print("not RSC7")
            return
        end

        local function flagToSize(flag)
            return ((((flag >> 17) & 0x7f) + (((flag >> 11) & 0x3f) << 1) + (((flag >> 7) & 0xf) << 2) + (((flag >> 5) & 0x3) << 3) + (((flag >> 4) & 0x1) << 4)) * (0x2000 << (flag & 0xF)))
        end

        local fmt = "%.2f MiB"

        if (flagToSize(physical) / 1024 / 1024) > showFilesAbovePhys then
            writeLog("strmeme.txt",(flagToSize(physical) / 1024 / 1024)..":"..path.."\n")
            print(path)
            print("Virtual Size", fmt:format(flagToSize(virtual) / 1024 / 1024))
            print("Physical Size", fmt:format(flagToSize(physical) / 1024 / 1024))
        end
    else
        print("failed to open file :(")
    end
end

local function scandir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('dir "'..directory..'" /b /ad')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

local function scanfiles(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('dir "'..directory..'" /b /a')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

local function recursiveCheckStrMeme(path)
    local listOfDirectories = scandir(path)
    for k,directory in pairs(listOfDirectories) do
        for _,fileName in pairs(scanfiles(path.."/"..directory)) do
            for _,fileType in pairs(allowedFileTypes) do
                if string.match(fileName, fileType) then
                    getMem(path.."/"..directory.."/"..fileName)
                end
            end
        end
        recursiveCheckStrMeme(path.."/"..directory)
    end
end

RegisterCommand("checkstrmeme",function(source)
    if source == 0 then
        local startTime = os.time()
        print("Str Meme Values")
        print("==============")
        recursiveCheckStrMeme("resources")
        print("==============")
        print("Completed and exported to resources/strmeme.txt, took " .. os.time()-startTime .. " seconds.")
	end
end)
