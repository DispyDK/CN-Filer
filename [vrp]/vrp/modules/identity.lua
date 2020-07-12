local htmlEntities = module("lib/htmlEntities")

local cfg = module("cfg/identity")
local lang = vRP.lang

local sanitizes = module("cfg/sanitizes")

-- this module describe the identity system

-- init sql

-- init
MySQL.ready(function ()
  MySQL.Async.execute([[
  CREATE TABLE IF NOT EXISTS vrp_user_identities(
    user_id INTEGER,
    registration VARCHAR(20),
    phone VARCHAR(20),
    firstname VARCHAR(50),
    name VARCHAR(50),
    age INTEGER,
    CONSTRAINT pk_user_identities PRIMARY KEY(user_id),
    CONSTRAINT fk_user_identities_users FOREIGN KEY(user_id) REFERENCES vrp_users(id) ON DELETE CASCADE,
    INDEX(registration),
    INDEX(phone)
  );
  ]])
end)

-- api

-- CACHES
local licenses = {}
local isVip = {}
local userphone = {}
local userIdentities = {}

-- wallet amount
function vRP.getWalletAmount(user_id)
    local tmp = vRP.getUserTmpTable(user_id)
    if tmp then
        return tmp.wallet or 0
    else
        return 0
    end
end

-- bank amount
function vRP.getBankAmount(user_id)
    local tmp = vRP.getUserTmpTable(user_id)
    if tmp then
        return tmp.bank or 0
    else
        return 0
    end
end

function vRP.setLicense(user_id,dmvtest)
    MySQL.Async.execute("UPDATE vrp_users SET DmvTest = @dmvtest WHERE id = @user_id", {user_id = user_id, dmvtest = dmvtest})
    licenses[user_id] = dmvtest
    TriggerEvent("vrp_extended:updatelicense",user_id,dmvtest)
end

-- cbreturn driverlicense status
function vRP.getDriverLicense(user_id, cbr)
    local task = Task(cbr)
    if licenses[user_id] ~= nil then
        task({licenses[user_id]})
    else
        MySQL.Async.fetchAll("SELECT DmvTest FROM vrp_users WHERE id = @user_id", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then
                licenses[user_id] = rows[1].DmvTest
                task({licenses[user_id]})
            else
                task()
            end
        end)
    end
end

function vRP.isVip(user_id, cbr)
    local task = Task(cbr)
    if isVip[user_id] ~= nil then
        task({isVip[user_id]})
    else
        -- MySQL.Async.fetchAll("SELECT * FROM vrp_users WHERE id = @user_id", {user_id = user_id}, function(rows, affected)
        --     if #rows > 0 then
        --         isVip[user_id] = rows[1].vip
        --         task({isVip[user_id]})
        --     else
        --         task()
        --     end
        -- end)
    end
end

function vRP.getUserByCPR(cpr, cbr)
    local task = Task(cbr)

    local split = {}
    for i in string.gmatch(cpr, "[^-]+") do
        table.insert(split, i)
    end

    local res={}
    for num in split[1]:gmatch('%d%d') do
        res[#res+1]=num
    end

    local search = res[1].."-"..res[2].."-%%"..res[3]
    MySQL.Async.fetchAll("SELECT * FROM vrp_user_identities WHERE cpr LIKE @cpr AND lastdigits = @last", {cpr = search, last = split[2]}, function(rows, affected)
        if #rows > 0 then
            task({rows[1]})
        else
            task()
        end
    end)
end

function vRP.getUsersByBirth(cpr, cbr)
    local task = Task(cbr)

    local res={}
    for num in cpr:gmatch('%d%d') do
        res[#res+1]=num
    end

    local search = res[1].."-"..res[2].."-%%"..res[3]
    MySQL.Async.fetchAll("SELECT * FROM vrp_user_identities WHERE cpr LIKE @cpr", {cpr = search}, function(rows, affected)
        if #rows > 0 then
            task({rows})
        else
            task()
        end
    end)
end

-- cbreturn user identity
function vRP.getUserIdentity(user_id, cbr)
    local task = Task(cbr)
    if userIdentities[user_id] ~= nil then
        task({userIdentities[user_id]})
    else
        MySQL.Async.fetchAll("SELECT * FROM vrp_user_identities WHERE user_id = @user_id", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then
                userIdentities[user_id] = rows[1]
                userphone[userIdentities[user_id].phone] = user_id
                task({userIdentities[user_id]})
            else
                task()
            end
        end)
    end
end

-- cbreturn user_id by registration or nil
function vRP.getUserByRegistration(registration, cbr)
    local task = Task(cbr)

    MySQL.Async.fetchAll("SELECT user_id FROM vrp_user_identities WHERE registration = @registration", {registration = registration or ""}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].user_id})
        else
            task()
        end
    end)
end

-- cbreturn user_id by phone or nil
function vRP.getUserByPhone(phone, cbr)
    local task = Task(cbr)
    if userphone[phone] ~= nil then
        task({userphone[phone]})
    else
        if phone ~= nil then
            MySQL.Async.fetchAll("SELECT user_id FROM vrp_user_identities WHERE phone = @phone", {phone = phone or ""}, function(rows, affected)
                if #rows > 0 then
                    userphone[phone] = rows[1].user_id
                    task({userphone[phone]})
                else
                    task()
                end
            end)
        else
            task()
        end
    end
end

function vRP.generateStringNumber(format) -- (ex: DDDLLL, D => digit, L => letter)
    local abyte = string.byte("A")
    local zbyte = string.byte("0")

    local number = ""
    for i=1,#format do
        local char = string.sub(format, i,i)
        if char == "D" then number = number..string.char(zbyte+math.random(0,9))
        elseif char == "L" then number = number..string.char(abyte+math.random(0,25))
        else number = number..char end
    end

    return number
end

-- cbreturn a unique registration number
function vRP.generateRegistrationNumber(cbr)
    local task = Task(cbr)

    local function search()
        -- generate registration number
        local registration = vRP.generateStringNumber("DDDDDD") --CPR
        vRP.getUserByRegistration(registration, function(user_id)
            if user_id ~= nil then
                search() -- continue generation
            else
                task({registration})
            end
        end)
    end

    search()
end

-- cbreturn a unique phone number (0DDDDD, D => digit)
function vRP.generatePhoneNumber(cbr)
    local task = Task(cbr)

    local function search()
        -- generate phone number
        local phone = vRP.generateStringNumber(cfg.phone_format)
        vRP.getUserByPhone(phone, function(user_id)
            if user_id ~= nil then
                search() -- continue generation
            else
                task({phone})
            end
        end)
    end

    search()
end

-- events, init user identity at connection
AddEventHandler("vRP:playerJoin",function(user_id,source,name,last_login)
    vRP.getUserIdentity(user_id, function(identity)
        if identity == nil then
            vRP.generateRegistrationNumber(function(registration)
                vRP.generatePhoneNumber(function(phone)
                    if phone == nil or registration == nil then
                        vRP.kick(source,"Der er sket en fejl kontakt support")
                    else
                        MySQL.Async.execute("INSERT IGNORE INTO vrp_user_identities(user_id,registration,phone,firstname,name,cpr,lastdigits) VALUES(@user_id,@registration,@phone,@firstname,@name,concat(LPAD(FLOOR((RAND() * (28-01+1))+01), 2, '0'),LPAD(FLOOR((RAND() * (12-01+1))+01), 3, '-0'),LPAD(2000, 5, '-')),LPAD(FLOOR((RAND() * (9999-1+1))+1), 4, '0'))", {
                            user_id = user_id,
                            registration = registration,
                            phone = phone,
                            firstname = cfg.random_first_names[math.random(1,#cfg.random_first_names)],
                            name = cfg.random_last_names[math.random(1,#cfg.random_last_names)],
                            age = math.random(25,40)
                        })
                    end
                end)
            end)
        end
    end)
end)

-- Remove cache
AddEventHandler("vRP:playerLeave",function(user_id,source)
    if userIdentities[user_id] ~= nil then
        userIdentities[user_id] = nil
    end
    for k,v in pairs(userphone) do
        if v == user_id then
            userphone[k] = nil
        end
    end
end)

-- city hall menu

--[[local cityhall_menu = {name=lang.cityhall.title(),css={top="75px", header_color="rgba(0,125,255,0.75)"}}

local function ch_identity(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRP.prompt(player,lang.cityhall.identity.prompt_firstname(),"",function(player,firstname)
      if string.len(firstname) >= 2 and string.len(firstname) < 50 then
        firstname = sanitizeString(firstname, sanitizes.name[1], sanitizes.name[2])
        vRP.prompt(player,lang.cityhall.identity.prompt_name(),"",function(player,name)
          if string.len(name) >= 2 and string.len(name) < 50 then
            name = sanitizeString(name, sanitizes.name[1], sanitizes.name[2])
            vRP.prompt(player,lang.cityhall.identity.prompt_age(),"",function(player,age)
              age = parseInt(age)
              if age >= 16 and age <= 150 then
                if vRP.tryPayment(user_id,cfg.new_identity_cost) then
                  vRP.generateRegistrationNumber(function(registration)
                    vRP.generatePhoneNumber(function(phone)

                      MySQL.execute("vRP/update_user_identity", {
                        user_id = user_id,
                        firstname = firstname,
                        name = name,
                        age = age,
                        registration = registration,
                        phone = phone
                      })

                      -- update client registration
                      vRPclient.setRegistrationNumber(player,{registration})
                      TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.money.paid({cfg.new_identity_cost})}, type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    end)
                  end)
                else
                  TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.money.not_enough()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                end
              else
                TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.invalid_value()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
              end
            end)
          else
            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.invalid_value()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
          end
        end)
      else
        TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.invalid_value()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
      end
    end)
  end
end

cityhall_menu[lang.cityhall.identity.title()] = {ch_identity,lang.cityhall.identity.description({cfg.new_identity_cost})}

local function cityhall_enter()
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    vRP.openMenu(source,cityhall_menu)
  end
end]]

--[[local function cityhall_leave()
  vRP.closeMenu(source)
end

local function build_client_cityhall(source) -- build the city hall area/marker/blip
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    local x,y,z = table.unpack(cfg.city_hall)

    --vRPclient.addBlip(source,{x,y,z,cfg.blip[1],cfg.blip[2],lang.cityhall.title()})
    vRPclient.addMarker(source,{x,y,z-1,0.7,0.7,0.5,0,255,125,125,150})

    vRP.setArea(source,"vRP:cityhall",x,y,z,1,1.5,cityhall_enter,cityhall_leave)
  end
end]]

AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
    -- send registration number to client at spawn
    vRP.getUserIdentity(user_id, function(identity)
        if identity then
            vRPclient.setRegistrationNumber(source,{identity.registration or "000AAA"})
        end
    end)

    -- first spawn, build city hall
    --[[if first_spawn then
      build_client_cityhall(source)
    end]]
end)

-- player identity menu

-- add identity to main menu
vRP.registerMenuBuilder("main", function(add, data)
    local player = data.player

    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        vRP.getUserIdentity(user_id, function(identity)

            if identity then
                -- generate identity content
                -- get address
                vRP.getUserAddress(user_id, function(address)
                    local home = ""
                    local number = ""
                    if address then
                        home = address.home.. " nr. "
                        number = address.number
                    else
                        home = "Hjemløs"
                        number = ""
                    end

                    local split = {}
                    for i in string.gmatch(identity.cpr, "[^-]+") do
                        table.insert(split, i)
                    end

                    local lage = math.abs(tonumber(split[3]) - tonumber(os.date("%Y")))
                    local cd =  tonumber(os.date("%d"))
                    local cm = tonumber(os.date("%m"))

                    if cm <= tonumber(split[2]) then
                        if cm == tonumber(split[2]) then
                            if cd < tonumber(split[1]) then
                                lage = lage-1
                            end
                        elseif cm < tonumber(split[2]) then
                            lage = lage-1
                        end
                    end

                    local age = identity.cpr.." ("..lage.." år)"
                    local cpr = split[1]..split[2]..string.sub(split[3],3).."-"..identity.lastdigits

                    -- get driver license status
                    local driverlicense = ""
                    vRP.getDriverLicense(user_id, function(license)
                      if license == 1 then
                          driverlicense = "Bil"
                      elseif license == 2 then
                          driverlicense = "Frakendt"
                      elseif license == 3 then
                          driverlicense = "Bil, motorcykel"
                      elseif license == 4 then
                          driverlicense = "Bil, motorcykel, lastbil"
                      else
                          driverlicense = "Nej"
                      end

                        -- get wallet amount
                        local walletamount = format_thousand(math.floor(vRP.getWalletAmount(user_id)))

                        local job = vRP.getUserGroupByType(user_id,"job")
                        local checksub = vRP.getUserGroupByType(user_id,job)
                        if checksub ~= nil and checksub ~= "" then
                            job = checksub
                        end
                        vRP.getUserBusiness(user_id, function(business)
                            local content = ""
                            if business then
                                content = lang.cityhall.menu.firmainfo({htmlEntities.encode(identity.name),htmlEntities.encode(identity.firstname),age,cpr,home,number,driverlicense,walletamount,user_id,job,business.name,format_thousand(tonumber(business.capital))})
                            else
                                content = lang.cityhall.menu.info({htmlEntities.encode(identity.name),htmlEntities.encode(identity.firstname),age,cpr,home,number,driverlicense,walletamount,user_id,job})
                            end
                            local choices = {}
                            choices[lang.cityhall.menu.title()] = {function()end, content}

                            add(choices)
                        end)
                    end)
                end)
            end
        end)
    end
end)

function format_thousand(v)
    local s = string.format("%d", math.floor(v))
    local pos = string.len(s) % 3
    if pos == 0 then pos = 3 end
    return string.sub(s, 1, pos)
            .. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end
