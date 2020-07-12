local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","cn-kr")

local lang = {
  police = {
    menu = {
      fine = {
        fined = "Bøde på {2} DKK for {1}.",
        notify_fined = "Du fik en bøde på  {2} DKK for {1}.",
        record = "[Bøde] {2} DKK for {1}"
      }
    }
  }
}


RegisterServerEvent("cn-kr:login")
AddEventHandler("cn-kr:login", function(vehtype)
  local user_id = vRP.getUserId({source})
  local id = source
    TriggerClientEvent("cn-kr:openGui", source)
    --print(id)
    --print("Du loggede ind på KR")
  --  TriggerEvent("cn-kr:checkEfterlysning", "070681-5433")
end)


RegisterServerEvent("cn-kr:checkEfterlysning")
AddEventHandler("cn-kr:checkEfterlysning", function(value, player)
  local source = source
  --print(player)
  --print(dump(value))
  local user_id = value.value
  getCPR(user_id, function(data)
    --print(dump(data))
    if data == nil then
      return
    end
    if data.user_id ~= nil then
      getUData(data.user_id, "vRP:police_warned", function(content)
      --  print(content)
        TriggerClientEvent("cn-kr:updateEfterlysning", source, content)
      --  print("triggered")
      end)
    else
      TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.not_found()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
  end)
end)



RegisterServerEvent("cn-kr:checkPersonregister")
AddEventHandler("cn-kr:checkPersonregister", function(value, player)
  local source = source
--  print(player)
--  print(dump(value))
  local user_id = value.value
  getCPR(user_id, function(data)

    if data == nil then
      return
    end
            if data.user_id ~= nil then
                -- display identity and business
                local name = data.name
                local firstname = data.firstname
                local phone = data.phone

                -- split age
                local split = {}
                for i in string.gmatch(data.cpr, "[^-]+") do
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

                local age = data.cpr.." ("..lage.." år)"
                local cpr = split[1]..split[2]..string.sub(split[3],3).."-"..data.lastdigits
                local registration = data.registration
                local clips = data.driver_clips

                local bname = "Intet"
                local bcapital = 0
                local home = ""
                local number = ""

                -- Get player business
                getUserBusiness(data.user_id, function(business)
                    if business then
                        bname = business.name
                        bcapital = business.capital
                    else
                        bname = "Intet firma"
                        bcapital = "0"
                    end

                    -- Get player address
                    getUserAddress(data.user_id, function(address)
                        if address then
                            home = address.home
                            number = address.number
                        else
                            home = "Hjemløs"
                        end

                        -- Get player license
                        local driverlicense = ""

                        getDriverLicense(data.user_id, function(license)
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

                            local user_id = data.user_id


                            local content = {user_id = user_id, registration = registration,name = name,firstname = firstname,age = age, cpr = cpr, phone = phone, driverlicense = driverlicense,home = home, number= number,bname = bname,bcapital = bcapital,job = job, driver_clips = clips}

                          --  print(dump(content))
                            TriggerClientEvent("cn-kr:updatePersonregister", source, content)
                          --  print("triggered")

                        end)
                    end)
                end)
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = "Ugyldigt CPR-nummer", type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
end)




RegisterServerEvent("cn-kr:checkKoretojer")
AddEventHandler("cn-kr:checkKoretojer", function(value, player)
  local source = source
  --print(player)
  --print(dump(value))
  local user_id = value.value
  getCPR(user_id, function(data)

    if data == nil then
      return
    end
    if data.user_id ~= nil then
      MySQL.Async.fetchAll("SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id", {user_id = data.user_id}, function(rows, affected)
        if #rows > 0 then
            -- task({rows})
            local data = rows
            TriggerClientEvent("cn-kr:updateKoretojer", source, data)
        else
            task()
        end
    end)
    else
      TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.not_found()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
  end)
end)


RegisterServerEvent("cn-kr:checkBoder")
AddEventHandler("cn-kr:checkBoder", function(value, player)
  local source = source
--  print(player)
--  print(dump(value))
  local user_id = value.value
  getCPR(user_id, function(data)

    if data == nil then
      return
    end
    if data.user_id ~= nil then
      getUData(data.user_id, "vRP:police_records", function(content)
      --  print(content)
        TriggerClientEvent("cn-kr:updateBoder", source, content)
      --  print("triggered")
      end)
    else
      TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.not_found()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
  end)
end)




RegisterServerEvent("cn-kr:frakend")
AddEventHandler("cn-kr:frakend", function(value)
  -- local user_id = vRP.getUserId({source})
  local user_id = value.id
  setLicense(user_id,2)
end)

RegisterServerEvent("cn-kr:givklip")
AddEventHandler("cn-kr:givklip", function(value)
  local phone = value.id

  MySQL.Async.execute("UPDATE vrp_user_identities SET driver_clips = driver_clips + 1 WHERE phone = @phone", {phone = phone})
  Wait(1000)
--  print(phone)
  MySQL.Async.fetchAll("SELECT * FROM vrp_user_identities WHERE phone = @phone", {phone = phone}, function(rows, affected)
    if #rows > 0 then
      local clips = tonumber(rows[1].driver_clips)
      local user_id = rows[1].user_id
      print(clips)
      if (clips > 2) then
        print("klip = klip")
        MySQL.Async.execute("UPDATE vrp_user_identities SET driver_clips = 0 WHERE phone = @phone", {phone = phone})
        setLicense(user_id,2)
      end
    else
      --task()
    end
  end)

  setLicense(user_id,2)
end)


RegisterServerEvent("cn-kr:bode")
AddEventHandler("cn-kr:bode", function(value)
  local user_id2 = vRP.getUserId({source})
  local user_id = value.id
  local reason = value.reason
  local taker = value.taker
  local taker2 = value.taker2
  local reason2 = string.gsub(reason, "\n", "<br>")
  local reason2 = string.gsub(reason2, "'", "")
  local time=os.date("%H:%M - %d/%m/%Y")
  print(reason2)
  print(taker)


      MySQL.Async.execute("INSERT INTO vrp_kr (user_id, taker, contributor, rapport) VALUES (@user_id, @taker, @taker2, @reason)", {user_id = user_id, taker = taker, taker2 = taker2, reason = reason})
    -- ch_kradd(user_id, reason2, taker, taker2)
  --  TriggerClientEvent("pNotify:SendNotification", source,{text = "Du gav en bøde på "..fine.." DKK for: "..reason, type = "info", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
    PerformHttpRequest('https://discordapp.com/api/webhooks/730761510246416384/ioU3k0AlA-eZPMYbDqgFI9YEDe5rSzbU9Cx4Kibsoye0qRj6dq65FtZdrLpEVhkkrMvv', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0").." - Rapport", content = "**Rapport tager:** ".. taker .. " - (id: ".. user_id2 ..")" .. "\n**Medvirkende:** " .. taker2 .. "\n**Vedrørende:** ".. user_id .. "\n**Tidspunkt:** " .. time .. " ```"..reason.."```"}), { ['Content-Type'] = 'application/json' })

end)



--Funktioner down here

function ch_kradd(user_id, reason2, taker, taker2)

  PerformHttpRequest('http://54.36.127.174:3000/kr/ingamePoliti12A', function(err,text,headers)
print(taker)



end, "POST", json.encode({user_id = user_id, reason = reason2, taker = taker, taker2 = taker2}),{['user_id']=user_id,['reason']=reason2,['taker']=taker,['taker2']=taker2,["Content-Type"]="application/json; charset=utf-8"})
  --PerformHttpRequest('http://54.36.127.174:3000/kr/ingamePoliti12A', function(err, text, headers) end, 'POST', json.encode({user_id = user_id, reason = reason}), { ['Content-Type'] = 'application/json' })
  print(headers)
  -- vRP.getUData(user_id, "vRP:police_kr", function(rdata)
  --     local ldata = json.decode(rdata)
  --     if ldata == nil or ldata == -1 then
  --         ldata = {}
  --     end
  --     table.insert(ldata,{by=by_id,reason=reason,time=os.date("%H:%M - %d/%m/%Y")})
  --     ldata = json.encode(ldata)
  --     vRP.setUData(user_id,"vRP:police_kr",ldata)
  --     TriggerEvent("vrp_extended:addwarned",user_id,ldata)
  --
  --     -- sendToDiscord("http://54.36.127.174:3000/kr/107/ingamePoliti12A","Server "..GetConvar("servernumber", "0").." - Efterlysning","**"..nuser_id.." - "..identity.firstname.." "..identity.name.."** har lige sat en efterlysning på **"..data.user_id.." - "..data.firstname.." "..data.name.."** med grunden: **"..reason.."** (**"..os.date("%H:%M:%S %d/%m/%Y").."**)")
  --     -- TriggerClientEvent("pNotify:SendNotification", player,{text = {"<b style='color: #4E9350'>"..reg.."</b> er blevet efterlyst for: <br/><b style='color: #4E9350'>"..reason.."</b>"}, type = "success", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
  -- end)
end

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function tryBankPaymentOrDebt(user_id,amount)
  amount = tonumber(amount)
    local money = vRP.getBankMoney({user_id})
    if amount > 0 and money >= amount then
        vRP.setBankMoney(user_id,money-amount)
        return "paid"
    else
        local tmp = vRP.getUserTmpTable({user_id})
        local diff = amount-money
        tmp.debt = tmp.debt+diff+500
        vRP.setBankMoney(user_id,500)
        return tmp.debt
    end
    return false
end

function getCPR(cpr, cbr)
    local task = Task(cbr)

    if string.match(cpr, "-") then
      --print ("Henter udfra CPR")
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
          --    print(dump(rows[1]))
          task({rows[1]})
        else
          task()
        end
      end)
    elseif (string.len(cpr) == 6) then
      --print(cpr)
      MySQL.Async.fetchAll("SELECT * FROM vrp_user_identities WHERE registration = @registration", {registration = cpr}, function(rows, affected)
          if #rows > 0 then
              task({rows[1]})
          else
              task()
          end
      end)
    else
      MySQL.Async.fetchAll("SELECT * FROM vrp_user_identities WHERE phone = @phone", {phone = cpr}, function(rows, affected)
        if #rows > 0 then
          --    print(dump(rows[1]))
          task({rows[1]})
        else
          task()
        end
      end)
    end

end



function getUData(user_id,key,cbr)
  local task = Task(cbr,{""})

  MySQL.Async.fetchAll("SELECT dvalue FROM vrp_user_data WHERE user_id = @user_id AND dkey = @key", {user_id = user_id, key = key}, function(rows, affected)
    --print(user_id)
    if #rows > 0 then
      task({rows[1].dvalue})
    else
      task()
    end
  end)
end


function getUserBusiness(user_id, cbr)
  local task = Task(cbr)

  if user_id ~= nil then
    MySQL.Async.fetchAll("SELECT name,description,capital,laundered,reset_timestamp FROM vrp_user_business WHERE user_id = @user_id", {user_id = user_id}, function(rows, affected)
      if #rows > 0 then
        local business = rows[1]

        -- when a business is fetched from the database, check for update of the laundered capital transfer capacity


        task({business})
      else
        task()
      end
    end)
  else
    task()
  end
end


function getUserAddress(user_id, cbr)
  local task = Task(cbr)
    MySQL.Async.fetchAll("SELECT home, number FROM vrp_user_homes WHERE user_id = @user_id", {user_id = user_id}, function(rows,affected)
      if #rows > 0 then
        userhome = rows[1]
        task({userhome})
      else
        task()
      end
    end)
end

local licenses = {}

function getDriverLicense(user_id, cbr)
    local task = Task(cbr)
        MySQL.Async.fetchAll("SELECT DmvTest FROM vrp_users WHERE id = @user_id", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then
                licenses[user_id] = rows[1].DmvTest
                task({licenses[user_id]})
            else
                task()
            end
        end)
end

function getJob(user_id,key,cbr)
  local task = Task(cbr,{""})

  MySQL.Async.fetchAll("SELECT dvalue FROM vrp_user_data WHERE user_id = @user_id AND dkey = @key", {user_id = user_id, key = key}, function(rows, affected)
    --print(user_id)
    if #rows > 0 then
      task({rows[1].dvalue})
    else
      task()
    end
  end)
end

function getUserVehiclesByCPR(cpr, cbr)
    local task = Task(cbr)

    if string.match(cpr, "-") then
    local split = {}
    for i in string.gmatch(cpr, "[^-]+") do
        table.insert(split, i)
    end

    local res={}
    for num in split[1]:gmatch('%d%d') do
        res[#res+1]=num
    end

    local search = res[1].."-"..res[2].."-%%"..res[3]
    MySQL.Async.fetchAll("SELECT vehicle, veh_type, vehicle_plate FROM vrp_user_vehicles INNER JOIN vrp_user_identities ON vrp_user_vehicles.user_id = vrp_user_identities.user_id WHERE vrp_user_identities.cpr LIKE @cpr AND vrp_user_identities.lastdigits = @last", {cpr = search, last = split[2]}, function(rows, affected)
        if #rows > 0 then
            task({rows})
        else
            task()
        end
    end)
  elseif (string.len(cpr) == 6) then
    MySQL.Async.fetchAll("SELECT vehicle, veh_type, vehicle_plate FROM vrp_user_vehicles INNER JOIN vrp_user_identities ON vrp_user_vehicles.user_id = vrp_user_identities.user_id WHERE vrp_user_identities.registration = @registration", {registration = cpr}, function(rows, affected)
        if #rows > 0 then
            task({rows})
        else
            task()
        end
    end)
  else
    MySQL.Async.fetchAll("SELECT vehicle, veh_type, vehicle_plate FROM vrp_user_vehicles INNER JOIN vrp_user_identities ON vrp_user_vehicles.user_id = vrp_user_identities.user_id WHERE vrp_user_identities.phone = @phone", {phone = cpr}, function(rows, affected)
        if #rows > 0 then
            task({rows})
        else
            task()
        end
    end)
  end
end


function setLicense(user_id,dmvtest)
    MySQL.Async.execute("UPDATE vrp_users SET DmvTest = @dmvtest WHERE id = @user_id", {user_id = user_id, dmvtest = dmvtest})
    TriggerEvent("vrp_extended:updatelicense",user_id,dmvtest)
end
