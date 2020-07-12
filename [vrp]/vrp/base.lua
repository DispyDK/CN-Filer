
local isStopped = false

local Proxy = module("lib/Proxy")
local Tunnel = module("lib/Tunnel")
local Lang = module("lib/Lang")
Debug = module("lib/Debug")

local config = module("cfg/base")
local version = module("version")
Debug.active = config.debug

-- open MySQL connection
-- MySQL.createConnection("vRP", config.db.host,config.db.user,config.db.password,config.db.database)

vRP = {}
Proxy.addInterface("vRP",vRP)

tvRP = {}
Tunnel.bindInterface("vRP",tvRP) -- listening for client tunnel

-- load language
local dict = module("cfg/lang/"..config.lang) or {}
vRP.lang = Lang.new(dict)

-- init
vRPex = Proxy.getInterface("vrp_extended")
vRPclient = Tunnel.getInterface("vRP","vRP") -- server -> client tunnel
vRPui = Tunnel.getInterface("dispy_ui","vRP") -- server -> client tunnel
vRPanim = Tunnel.getInterface("cn-animation","vRP") -- server -> client tunnel

vRP.users = {} -- will store logged users (id) by first identifier
vRP.rusers = {} -- store the opposite of users
vRP.user_tables = {} -- user data tables (logger storage, saved to database)
vRP.user_tmp_tables = {} -- user tmp data tables (logger storage, not saved)
vRP.user_sources = {} -- user sources


--Async Queries
MySQL.ready(function ()
  MySQL.Async.execute([[
  CREATE TABLE IF NOT EXISTS vrp_users(
    id INTEGER AUTO_INCREMENT,
    last_login VARCHAR(255),
    whitelisted BOOLEAN,
    banned BOOLEAN,
    CONSTRAINT pk_user PRIMARY KEY(id)
  );

  CREATE TABLE IF NOT EXISTS vrp_user_ids(
    identifier VARCHAR(255),
    user_id INTEGER,
    CONSTRAINT pk_user_ids PRIMARY KEY(identifier),
    CONSTRAINT fk_user_ids_users FOREIGN KEY(user_id) REFERENCES vrp_users(id) ON DELETE CASCADE
  );

  CREATE TABLE IF NOT EXISTS vrp_user_data(
    user_id INTEGER,
    dkey VARCHAR(255),
    dvalue TEXT,
    CONSTRAINT pk_user_data PRIMARY KEY(user_id,dkey),
    CONSTRAINT fk_user_data_users FOREIGN KEY(user_id) REFERENCES vrp_users(id) ON DELETE CASCADE
  );

  CREATE TABLE IF NOT EXISTS vrp_srv_data(
    dkey VARCHAR(255),
    dvalue TEXT,
    CONSTRAINT pk_srv_data PRIMARY KEY(dkey)
  );
  ]], nil, function(rowsChanged)
  end)
end)



--- sql.
-- cbreturn user id or nil in case of error (if not found, will create it)
function vRP.getUserIdByIdentifiers(ids, cbr)
  local task = Task(cbr)
  if ids ~= nil and #ids then
    local i = 0
    local validids = 0

    -- search identifiers
    local function search()
      i = i+1
      if i <= #ids then
        if (not config.ignore_ip_identifier or (string.find(ids[i], "ip:") == nil)) and

                (not config.ignore_license_identifier or (string.find(ids[i], "license:") == nil)) and

                (not config.ignore_xbox_identifier or (string.find(ids[i], "xbl:") == nil)) and

                (not config.ignore_discord_identifier or (string.find(ids[i], "discord:") == nil)) and

                (not config.ignore_live_identifier or (string.find(ids[i], "live:") == nil))

        then  -- ignore ip & license
          validids = validids + 1
          MySQL.Async.fetchAll("SELECT user_id FROM vrp_user_ids WHERE identifier = @identifier", {identifier = ids[i]}, function(rows, affected)
            if #rows > 0 then  -- found
              task({rows[1].user_id})
            else -- not found
              search()
            end
          end)
        else
          search()
        end
      elseif validids > 0 then -- no ids found, create user
        MySQL.Async.execute("INSERT INTO vrp_users(whitelisted,banned) VALUES(0,0)", {}, function(rows)
        end)
        MySQL.Async.fetchAll("SELECT * FROM vrp_users ORDER BY id DESC LIMIT 0, 1", {}, function(rows, affected)
          if #rows > 0 then
            local user_id = rows[1].id
            -- add identifiers
            for l,w in pairs(ids) do
              if (not config.ignore_ip_identifier or (string.find(w, "ip:") == nil)) and

                      (not config.ignore_license_identifier or (string.find(w, "license:") == nil)) and

                      (not config.ignore_xbox_identifier or (string.find(w, "xbl:") == nil)) and

                      (not config.ignore_discord_identifier or (string.find(w, "discord:") == nil)) and

                      (not config.ignore_live_identifier or (string.find(w, "live:") == nil))
              then  -- ignore ip & license identifier
                MySQL.Async.execute("INSERT INTO vrp_user_ids(identifier,user_id) VALUES(@identifier,@user_id)", {user_id = user_id, identifier = w})
              end
            end
            task({user_id})
          else
            task()
          end
        end)
      end
    end

    search()
  else
    task()
  end
end

function vRP.getUserIdByIdentifier(ids, cbr)
  local task = Task(cbr)
  if ids ~= nil then

    MySQL.Async.fetchAll("SELECT user_id FROM vrp_user_ids WHERE identifier = @identifier", {identifier = ids}, function (rows)
      if #rows > 0 then
        task({rows[1].user_id})
      else -- not found
        task()
      end
    end)

  end
end

-- return identification string for the source (used for non vRP identifications, for rejected players)
function vRP.getSourceIdKey(source)
  local ids = GetPlayerIdentifiers(source)
  local idk = "idk_"
  for k,v in pairs(ids) do
    idk = idk..v
  end

  return idk
end

function vRP.getPlayerEndpoint(player)
  return GetPlayerEndpoint(player) or "0.0.0.0"
end

function vRP.getPlayerName(player)
  return GetPlayerName(player) or "ukendt"
end

--- sql
function vRP.isBanned(user_id, cbr)
  local task = Task(cbr, {false})


  MySQL.Async.fetchAll("SELECT * FROM vrp_users WHERE id = @user_id", {user_id = user_id}, function (rows)
    if #rows > 0 then
      task({rows[1].banned})
    else -- not found
      task()
    end
  end)

end

-- UPDATE DISCORD
function vRP.setDiscord(source,user_id,ndiscord)
  local ids = GetPlayerIdentifiers(source)
  local discord = ""
  for k,v in pairs(ids) do
    if string.find(v, "discord:") ~= nil then
      discord = v:gsub("discord:","")
    end
  end
  if discord ~= "" and discord ~= ndiscord then
    MySQL.Async.execute("UPDATE vrp_users SET discord=@discord WHERE id = @user_id", {user_id = user_id, discord = discord})
  end
end

--- BANS
function vRP.updateIP(user_id,ip)
  MySQL.Async.execute("UPDATE vrp_users SET last_login = @last_login WHERE id = @user_id", {user_id = user_id, last_login = ip})
end

function vRP.setBanned(user_id,banned,reason)
  MySQL.Async.execute("UPDATE vrp_users SET banned = @banned, ban_reason = @reason WHERE id = @user_id", {user_id = user_id, banned = banned, reason = reason})
end

function vRP.setUnbanned(user_id,banned,reason)
  MySQL.Async.execute("UPDATE vrp_users SET banned = @banned, ban_reason = @reason WHERE id = @user_id", {user_id = user_id, banned = banned, reason = reason})
end

function vRP.getBannedReason(user_id, cbr)
  local task = Task(cbr, {false})

  MySQL.Async.fetchAll("SELECT * FROM vrp_users WHERE id = @user_id", {user_id = user_id}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].ban_reason})
    else
      task()
    end
  end)
end


--- sql
function vRP.isWhitelisted(user_id, cbr)
  local task = Task(cbr, {false})

  MySQL.Async.fetchAll("SELECT whitelisted FROM vrp_users WHERE id = @user_id", {user_id = user_id}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].whitelisted})
    else
      task()
    end
  end)
end

--- sql
function vRP.setWhitelisted(user_id,whitelisted)
  MySQL.Async.execute("UPDATE vrp_users SET whitelisted = @whitelisted WHERE id = @user_id", {user_id = user_id, whitelisted = whitelisted})
end

--- sql
function vRP.getLastLogin(user_id, cbr)
  local task = Task(cbr,{""})
  MySQL.Async.fetchAll("SELECT last_login FROM vrp_users WHERE id = @user_id", {user_id = user_id}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].last_login})
    else
      task()
    end
  end)
end

function vRP.getUserData(user_id, cbr)
  local task = Task(cbr, {false})
  MySQL.Async.fetchAll("SELECT * FROM vrp_users WHERE id = @user_id", {user_id = user_id}, function(rows, affected)
    if #rows > 0 then
      task({rows[1]})
    else
      task()
    end
  end)
end

function vRP.removeUData(user_id,key)
  MySQL.Async.fetchAll("DELETE FROM vrp_user_data WHERE user_id = @user_id AND dkey = @key", {user_id = user_id, key = key})
end

function vRP.setUData(user_id,key,value)
  MySQL.Async.execute("REPLACE INTO vrp_user_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)", {user_id = user_id, key = key, value = value})
end

function vRP.getUData(user_id,key,cbr)
  local task = Task(cbr,{""})

  MySQL.Async.fetchAll("SELECT dvalue FROM vrp_user_data WHERE user_id = @user_id AND dkey = @key", {user_id = user_id, key = key}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].dvalue})
    else
      task()
    end
  end)
end

function vRP.setSData(key,value)
  MySQL.Async.execute("REPLACE INTO vrp_srv_data(dkey,dvalue) VALUES(@key,@value)", {key = key, value = value})
end

function vRP.getSData(key, cbr)
  local task = Task(cbr,{""})

  MySQL.Async.fetchAll("SELECT dvalue FROM vrp_srv_data WHERE dkey = @key", {key = key}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].dvalue})
    else
      task()
    end
  end)
end

-- return user data table for vRP internal persistant connected user storage
function vRP.getUserDataTable(user_id)
  return vRP.user_tables[user_id]
end

function vRP.getUserTmpTable(user_id)
  return vRP.user_tmp_tables[user_id]
end

function vRP.isConnected(user_id)
  return vRP.rusers[user_id] ~= nil
end

function vRP.isFirstSpawn(user_id)
  local tmp = vRP.getUserTmpTable(user_id)
  return tmp and tmp.spawns == 1
end

function vRP.getUserId(source)
  if source ~= nil then
    local ids = GetPlayerIdentifiers(source)
    if ids ~= nil and #ids > 0 then
      return vRP.users[ids[1]]
    end
  end

  return nil
end

-- return map of user_id -> player source
function vRP.getUsers()
  local users = {}
  for k,v in pairs(vRP.user_sources) do
    users[k] = v
  end

  return users
end

-- return source or nil
function vRP.getUserSource(user_id)
  return vRP.user_sources[user_id]
end

function vRP.ban(source,reason, isUser)
  local user_id = (isUser == false and vRP.getUserId(source) or source)
  if user_id ~= nil then
    vRP.setBanned(user_id,true,reason)
    source = (isUser == false and source or vRP.getUserSource(user_id))
    if source ~= nil then
      vRP.kick(source,"Udelukket med grunden: "..reason)
    end
  end
end

function vRP.unban(id,reason)
  vRP.setBanned(id,false,reason)
end

function vRP.kick(source,reason)
  DropPlayer(source,reason)
end

-- tasks

function task_save_datatables()
  TriggerEvent("vRP:save")

  Debug.pbegin("vRP save datatables")
  for k,v in pairs(vRP.user_tables) do
    vRP.setUData(k,"vRP:datatable",json.encode(v))
    Wait(100)
  end

  Debug.pend()
  SetTimeout(config.save_interval*1000, task_save_datatables)
end
task_save_datatables()

function tvRP.ping()
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    local tmpdata = vRP.getUserTmpTable(user_id)
    tmpdata.pings = 0 -- reinit ping countdown
  end
end

function vRP.getServerStatus()
  return isStopped
end

function vRP.setServerStatus(reason)
  isStopped = reason
end

function vRP.startLoadingIn(source,user_id,steam,name,deferrals)
  local source = source
  Debug.pbegin("playerConnecting_delayed")
  if vRP.rusers[user_id] == nil then -- not present on the server, init
    -- init entries

    vRP.users[steam] = user_id
    vRP.rusers[user_id] = steam
    vRP.user_tables[user_id] = {}
    vRP.user_tmp_tables[user_id] = {}
    vRP.user_sources[user_id] = source

    -- load user data table
    deferrals.update("[vRP] Indlæser din data...")
    vRP.getUData(user_id, "vRP:datatable", function(sdata)
      local data = json.decode(sdata)
      if type(data) == "table" then vRP.user_tables[user_id] = data end

      -- init user tmp table
      local tmpdata = vRP.getUserTmpTable(user_id)

      deferrals.update("[vRP] Tjekker seneste login...")
      vRP.getLastLogin(user_id, function(last_login)
        tmpdata.last_login = last_login or ""
        tmpdata.spawns = 0

        -- set last login
        local ep = vRP.getPlayerEndpoint(source)
        local last_login_stamp = ep
        local last_login_date = os.date("%H:%M:%S %d/%m/%Y")
        MySQL.Async.execute("UPDATE vrp_users SET last_login = @last_login, last_date = @last_date WHERE id = @user_id", {user_id = user_id, last_login = last_login_stamp, last_date = last_login_date})

        -- trigger join
        print(name.." ("..vRP.getPlayerEndpoint(source)..") tilsluttede ("..user_id..", s: "..source..")")
        TriggerEvent("vRP:playerJoin", user_id, source, name, tmpdata.last_login)
        -- sendToDiscord3("teeest", "**"..tostring(user_id) .. "** joinet serveren (**"..os.date("%H:%M:%S %d/%m/%Y").."**)")

        deferrals.done()
      end)
    end)
  else -- already connected
    print(name.." ("..vRP.getPlayerEndpoint(source)..") tilsluttede igen ("..user_id..", s: "..source..")")
    TriggerEvent("vRP:playerRejoin", user_id, source, name)
    deferrals.done()

    -- reset first spawn
    local tmpdata = vRP.getUserTmpTable(user_id)
    tmpdata.spawns = 0
  end
  Debug.pend()
end

-- handlers
local antispam = {}
local enabledefault = false
AddEventHandler("playerConnecting",function(name,setMessage, deferrals)
  if enabledefault then
    deferrals.defer()
    local source = source
    Debug.pbegin("playerConnecting")
    if isStopped == false then
      local ids = GetPlayerIdentifiers(source)
      if ids ~= nil and #ids > 0 then
        deferrals.update("[vRP] Tjekker identifikatorer...")
        vRP.getUserIdByIdentifiers(ids, function(user_id)
          if user_id ~= nil then
            deferrals.update("[vRP] Tjekker om du er banned...")
            vRP.getUserData(user_id, function(userdata)
              if not userdata.banned then
                deferrals.update("[vRP] Tjekker om du er whitelisted...")
                if not config.whitelist or userdata.whitelisted then
                  Debug.pbegin("playerConnecting_delayed")
                  if vRP.rusers[user_id] == nil then

                    vRP.users[ids[1]] = user_id
                    vRP.rusers[user_id] = ids[1]
                    vRP.user_tables[user_id] = {}
                    vRP.user_tmp_tables[user_id] = {}
                    vRP.user_sources[user_id] = source


                    deferrals.update("[vRP] Indlæser din data...")
                    vRP.getUData(user_id, "vRP:datatable", function(sdata)
                      local data = json.decode(sdata)
                      if type(data) == "table" then vRP.user_tables[user_id] = data end


                      local tmpdata = vRP.getUserTmpTable(user_id)

                      deferrals.update("[vRP] Tjekker seneste login...")
                      vRP.getLastLogin(user_id, function(last_login)
                        tmpdata.last_login = last_login or ""
                        tmpdata.spawns = 0


                        local ep = vRP.getPlayerEndpoint(source)
                        local last_login_stamp = ep
                        local last_login_date = os.date("%H:%M:%S %d/%m/%Y")
                        MySQL.Async.execute("UPDATE vrp_users SET last_login = @last_login, last_date = @last_date WHERE id = @user_id", {user_id = user_id, last_login = last_login_stamp, last_date = last_login_date})


                        print(name.." ("..vRP.getPlayerEndpoint(source)..") tilsluttede ("..user_id..")")
                        TriggerEvent("vRP:playerJoin", user_id, source, name, tmpdata.last_login)
                        sendToDiscord3(name, "**"..tostring(user_id) .. " S: "..source.."** joinet serveren (**"..os.date("%H:%M:%S %d/%m/%Y").."**)")
                        deferrals.done()
                      end)
                    end)
                  else
                    print(name.." ("..vRP.getPlayerEndpoint(source)..") tilsluttede igen ("..user_id..")")
                    TriggerEvent("vRP:playerRejoin", user_id, source, name)
                    deferrals.done()


                    local tmpdata = vRP.getUserTmpTable(user_id)
                    tmpdata.spawns = 0
                  end
                  vRP.setDiscord(source,user_id,userdata.discord)
                  Debug.pend()
                else
                  print(name.." ("..vRP.getPlayerEndpoint(source)..") afvist: ikke whitelisted ("..user_id..")")
                  deferrals.done("[vRP] Ikke whitelisted ansøg på Discord.gg/AxpEspz (user_id = "..user_id..")")
                end
              else
                vRP.setDiscord(source,user_id,userdata.discord)
                local ep = vRP.getPlayerEndpoint(source)
                if ep ~= userdata.last_login and ep ~= "0.0.0.0" or userdata.last_login == "" then
                  local last_login_stamp = ep
                  local last_login_date = os.date("%H:%M:%S %d/%m/%Y")
                  MySQL.Async.execute("UPDATE vrp_users SET last_login = @last_login, last_date = @last_date WHERE id = @user_id", {user_id = user_id, last_login = last_login_stamp, last_date = last_login_date})
                end
                local ban_reason = userdata.ban_reason
                if type(userdata.ban_reason) == "table" then
                  ban_reason = "Ingen grund sat"
                end
                print(name.." ("..vRP.getPlayerEndpoint(source)..") afvist: banned ("..user_id..")")
                deferrals.done("[vRP] Du er bannet for: "..ban_reason.." (user_id = "..user_id..")")
              end
            end)
          else
            print(name.." ("..vRP.getPlayerEndpoint(source)..") afvist: identifikationsfejl")
            deferrals.done("[vRP] Tjek om du har dit steam åben og ellers prøv at genstarte det.")
          end
        end)
      else
        print(name.." ("..vRP.getPlayerEndpoint(source)..") afvist: mangler steamid")
        deferrals.done("[vRP] Tjek om du har dit steam åben og ellers prøv at genstarte det.")
      end
    else
      print("("..vRP.getPlayerEndpoint(source)..") blev kicket for at joine imens serveren er igang med at "..isStopped)
      deferrals.done("[SafeStop] Serveren er igang med at "..isStopped)
    end
    Debug.pend()
  end
end)

AddEventHandler("playerDropped",function(reason)
  local source = source
  
  Debug.pbegin("playerDropped")

  -- remove player from connected clients
  vRPclient.removePlayer(-1,{source})


  local user_id = vRP.getUserId(source)

  if user_id ~= nil then
    TriggerEvent("vRP:playerLeave", user_id, source)

    local steam = GetPlayerName(source)
    local dmessage = "**".. tostring(user_id)..", s: "..source.. " ** forlod serveren (**"..os.date("%H:%M:%S %d/%m/%Y").."**)"

    sendToDiscord3(steam, dmessage)

    -- save user data table
    vRP.setUData(user_id,"vRP:datatable",json.encode(vRP.getUserDataTable(user_id)))

    print("[vRP] "..vRP.getPlayerEndpoint(source).." forlod (ID: "..user_id..", s: "..source..")")
    vRP.users[vRP.rusers[user_id]] = nil
    vRP.rusers[user_id] = nil
    vRP.user_tables[user_id] = nil
    vRP.user_tmp_tables[user_id] = nil
    vRP.user_sources[user_id] = nil
  end
  Debug.pend()
end)

function vRP.disconnectPlayer(user_id, source)
  local data = vRP.user_tables[user_id]
  if data ~= nil and data ~= "" then
    TriggerEvent("vRP:playerLeave", user_id, source)
    local steam = GetPlayerName(source)
    local dmessage = "**".. tostring(user_id).. "** er blevet disconnected fra serveren (**"..os.date("%H:%M:%S %d/%m/%Y").."**)"

    sendToDiscord3(steam, dmessage)

    -- save user data table
    vRP.setUData(user_id,"vRP:datatable",json.encode(data))
  end
  print("[vRP] "..vRP.getPlayerEndpoint(source).." blev disconnected (ID: "..user_id..")")
  if vRP.rusers[user_id] ~= nil then
    vRP.users[vRP.rusers[user_id]] = nil
  end
  vRP.rusers[user_id] = nil
  vRP.user_tables[user_id] = nil
  vRP.user_tmp_tables[user_id] = nil
  vRP.user_sources[user_id] = nil
  DropPlayer(source,"Du er blevet disconnected, kontakt venligst support.")
end

local timeout = {}


RegisterServerEvent("vRPcli:playerSpawned")
AddEventHandler("vRPcli:playerSpawned", function()
  Debug.pbegin("playerSpawned")

  -- register user sources and then set first spawn to false
  local user_id = vRP.getUserId(source)
  local dmessage = "**".. tostring(user_id).. "** joinet serveren (**"..os.date("%H:%M:%S %d/%m/%Y").."**)"
  sendToDiscord3(user_id, dmessage)
  local player = source
  if user_id ~= nil then
    vRP.user_sources[user_id] = source
    local tmp = vRP.getUserTmpTable(user_id)
    tmp.spawns = tmp.spawns+1
    local first_spawn = (tmp.spawns == 1)

    if first_spawn then
      -- first spawn, reference player
      -- send players to new player
      for k,v in pairs(vRP.user_sources) do
        vRPclient.addPlayer(source,{v})
      end
      -- send new player to all players
      vRPclient.addPlayer(-1,{source})
    end

    -- set client tunnel delay at first spawn
    Tunnel.setDestDelay(player, config.load_delay)

    -- show loading
    vRPclient.setProgressBar(player,{"vRP:loading", "botright", "Indlæser...", 0,0,0, 100})

    SetTimeout(2000, function() -- trigger spawn event
      TriggerEvent("vRP:playerSpawn",user_id,player,first_spawn)

      SetTimeout(config.load_duration*1000, function() -- set client delay to normal delay
        Tunnel.setDestDelay(player, config.global_delay)
        vRPclient.removeProgressBar(player,{"vRP:loading"})
        --TriggerClientEvent('movebitch',player)
      end)
    end)
  end

  Debug.pend()
end)

RegisterServerEvent("vRP:playerDied")

function sendToDiscord3(name, message)
  if message == nil or message == '' or message:sub(1, 1) == '/' then return FALSE end
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
