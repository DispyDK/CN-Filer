local lang = vRP.lang
local cfg = module("cfg/police")
local cfg_inventory = module("cfg/inventory")
-- police records

-- insert a police record for a specific user
--- line: text for one line (can be html)
function vRP.insertPoliceRecord(user_id, line)
    if user_id ~= nil then
        vRP.getUData(user_id, "vRP:police_records", function(data)
            local records = data..line.."<br />"
            vRP.setUData(user_id, "vRP:police_records", records)
        end)
    end
end

-- police PC
local function ch_searchcpr(player,choice)
    vRP.prompt(player,lang.police.pc.searchcpr.prompt(),"",function(player, reg)
        if not string.match(reg, "[0-9][0-9][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9]") then
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Ugyldigt CPR-nummer (Example: 000000-0000)", type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            return;
        end
        vRP.getUserByCPR(reg, function(data)
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

                local bname = "Intet"
                local bcapital = 0
                local home = ""
                local number = ""

                -- Get player business
                vRP.getUserBusiness(data.user_id, function(business)
                    if business then
                        bname = business.name
                        bcapital = business.capital
                    else
                        bname = "Intet firma"
                        bcapital = "0"
                    end

                    -- Get player address
                    vRP.getUserAddress(data.user_id, function(address)
                        if address then
                            home = address.home
                            number = address.number
                        else
                            home = "Hjemløs"
                        end

                        -- Get player license
                        local driverlicense = ""

                        vRP.getDriverLicense(data.user_id, function(license)
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

                            local walletamount = vRP.getWalletAmount(data.user_id)
                            local bankamount = vRP.getBankAmount(data.user_id)

                            local job = vRP.getUserGroupByType(data.user_id,"job")
                            local checksub = vRP.getUserGroupByType(data.user_id,job)
                            if checksub ~= nil and checksub ~= "" then
                                job = checksub
                            end

                            local content = lang.police.identity.infocpr({name,firstname,age,cpr,phone,driverlicense,home,number,bname,bcapital,job})

                            vRPclient.setDiv(player,{"police_pc",".div_police_pc{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 400px; font-style: normal; font-family: 'Calibri Light', sans-serif; padding: 13px; margin: auto; margin-top: 150px; }",content})
                            vRP.request(player, "Luk rapport", 1000, function(player,ok)
                                vRPclient.removeDiv(player,{"police_pc"})
                            end)
                        end)
                    end)
                end)
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = "Ugyldigt CPR-nummer", type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
    end)
end

local function ch_searchbybirth(player,choice)
    vRP.prompt(player,lang.police.pc.searchbirth.prompt(),"",function(player, reg)
        if not string.match(reg, "[0-9][0-9][0-9][0-9][0-9][0-9]") then
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Ugyldigt fødselsdato (Example: 000000)", type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            return;
        end
        vRP.getUsersByBirth(reg, function(data)
            if data ~= nil then
                local content = "<h2>Personregister</h2><br/><br/><table><tr><th>Navn</th><th>CPR</th><th>Fødselsdato</th><th>Telefon</th></tr>"
                for k,v in pairs(data) do
                    local split = {}
                    for i in string.gmatch(v.cpr, "[^-]+") do
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

                    local age = v.cpr.." ("..lage.." år)"
                    local cpr = split[1]..split[2]..string.sub(split[3],3).."-"..v.lastdigits
                    content = content.."<tr><td>"..v.firstname.." "..v.name.."</td><td>"..cpr.."</td><td>"..age.."</td><td>"..v.phone.."</td></tr>"
                end
                content = content.."</table><br/><b>Resultater fundet</b>: "..#data
                vRPclient.setDiv(player,{"police_pc",".div_police_pc{ background-color: rgba(0,0,0,0.75); color: white; width: 900px; font-style: normal; font-family: 'Calibri Light', sans-serif; padding: 13px; margin: auto; margin-top: 150px; font-size: 20px; text-align:center;} table{width:100%} b {font-weight: bold; color:red;} h2{font-size: 34px}",content})
                vRP.request(player, "Luk rapport", 1000, function(player,ok)
                    vRPclient.removeDiv(player,{"police_pc"})
                end)
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = "Ingen resultater fundet", type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
    end)
end

local function ch_getvehiclesbycpr(player,choice)
    vRP.prompt(player,lang.police.pc.getvehiclebycpr.prompt(),"",function(player, reg)
        if not string.match(reg, "[0-9][0-9][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9]") then
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Ugyldigt fødselsdato (Example: 000000-0000)", type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            return;
        end
        vRP.getUserVehiclesByCPR(reg, function(data)
            if data ~= nil then
                local content = "<h2>Køretøjregister</h2><br/><p>Oversigt af "..reg.."</p><br/><br/><table><tr><th>Køretøj</th><th>Type</th><th>Nummerplade</th></tr>"
                local count = 0
                for k,v in pairs(data) do
                        count = count+1
                        local type = (v.veh_type == "car") and "Bil" or "Motorcykel"
                        content = content.."<tr><td>"..v.vehicle.."</td><td>"..type.."</td><td>"..v.vehicle_plate.."</td></tr>"
                end
                content = content.."</table><br/><b>Resultater fundet</b>: "..count
                vRPclient.setDiv(player,{"police_pc",".div_police_pc{ background-color: rgba(0,0,0,0.75); color: white; width: 800px; font-style: normal; font-family: 'Calibri Light', sans-serif; padding: 13px; margin: auto; margin-top: 150px; font-size: 20px; text-align:center;} table{width:100%} b {font-weight: bold; color:red;} h2{font-size: 34px}",content})
                vRP.request(player, "Luk rapport", 1000, function(player,ok)
                    vRPclient.removeDiv(player,{"police_pc"})
                end)
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = "Ingen resultater fundet", type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
    end)
end


-- search identity by registration
local function ch_searchreg(player,choice)
    vRP.prompt(player,lang.police.pc.searchreg.prompt(),"",function(player, reg)
        vRP.getUserByRegistration(reg, function(user_id)
            if user_id ~= nil then
                vRP.getUserIdentity(user_id, function(identity)
                    if identity then
                        -- display identity and business
                        local name = identity.name
                        local firstname = identity.firstname
                        local phone = identity.phone
                        local registration = identity.registration
                        local bname = "Intet"
                        local bcapital = 0
                        local home = ""
                        local number = ""

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

                        local job = vRP.getUserGroupByType(user_id,"job")
                        local checksub = vRP.getUserGroupByType(user_id,job)
                        if checksub ~= nil and checksub ~= "" then
                            job = checksub
                        end
                        if job == "Producent" or job == "Kemiker" or job == "Pusher" or job == "Våbendealer" or job == "Drugdealer" or job == "Indbrudstyv" then
                            job = "Arbejdsløs"
                        end

                        local age = identity.cpr.." ("..lage.." år)"
                        local cpr = split[1]..split[2]..string.sub(split[3],3).."-"..identity.lastdigits

                        vRP.getUserBusiness(user_id, function(business)
                            if business then
                                bname = business.name
                            end

                            vRP.getUserAddress(user_id, function(address)
                                local home = ""
                                if address then
                                    home = address.home.. " nr. "..address.number
                                else
                                    home = "Hjemløs"
                                end

                                local content = "<h3>Oversigt af "..reg.."</h3></br>"..lang.police.identity.info({name,firstname,age,cpr,phone,home,job,bname})
                                vRPclient.setDiv(player,{"police_pc",".div_police_pc{ background-color: rgba(0,0,0,0.75); color: white; font-family: Lato; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
                                vRP.request(player, "Luk rapport", 1000, function(player,ok)
                                    vRPclient.removeDiv(player,{"police_pc"})
                                end)
                            end)
                        end)
                    else
                        TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.not_found()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    end
                end)
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.not_found()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
    end)
end

-- search identity by phone
local function ch_searchphone(player,choice)
    vRP.prompt(player,lang.police.pc.searchphone.prompt(),"",function(player, reg)
        vRP.getUserByPhone(reg, function(user_id)
            if user_id ~= nil then
                vRP.getUserIdentity(user_id, function(identity)
                    if identity then
                        -- display identity and business
                        local name = identity.name
                        local firstname = identity.firstname

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

                        local phone = identity.phone
                        local registration = identity.registration
                        local bname = "Intet"
                        local home = ""

                        local job = vRP.getUserGroupByType(user_id,"job")
                        local checksub = vRP.getUserGroupByType(user_id,job)
                        if checksub ~= nil and checksub ~= "" then
                            job = checksub
                        end
                        if job == "Producent" or job == "Kemiker" or job == "Pusher" or job == "Våbendealer" or job == "Drugdealer" or job == "Indbrudstyv" then
                            job = "Arbejdsløs"
                        end

                        vRP.getUserBusiness(user_id, function(business)
                            if business then
                                bname = business.name
                            end

                            vRP.getUserAddress(user_id, function(address)
                                local home = ""
                                local number = ""
                                if address then
                                    home = address.home.. " nr. "..address.number
                                else
                                    home = "Hjemløs"
                                    number = ""
                                end

                                local content = "<h3>Oversigt af "..reg.."</h3></br>"..lang.police.identity.info({name,firstname,age,cpr,phone,home,job,bname})
                                vRPclient.setDiv(player,{"police_pc",".div_police_pc{ background-color: rgba(0,0,0,0.75); color: white; font-family: Lato; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
                                vRP.request(player, "Luk rapport", 1000, function(player,ok)
                                    vRPclient.removeDiv(player,{"police_pc"})
                                end)
                            end)
                        end)
                    else
                        -- vRPclient.notify(player,{lang.common.not_found()})
                        TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.not_found()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    end
                end)
            else
                -- vRPclient.notify(player,{lang.common.not_found()})
                TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.not_found()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
    end)
end

-- show police records by registration
local function ch_show_police_records(player,choice)
    vRP.prompt(player,lang.police.pc.getvehiclebycpr.prompt(),"",function(player, reg)
        if not string.match(reg, "[0-9][0-9][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9]") then
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Ugyldigt CPR-nummer (Example: 000000-0000)", type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            return;
        end
        vRP.getUserByCPR(reg, function(data)
            if data.user_id ~= nil then
                vRP.getUData(data.user_id, "vRP:police_records", function(content)
                    vRPclient.setDiv(player,{"police_pc",".div_police_pc{ background-color: rgba(0,0,0,0.75); color: white; font-family: Lato; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
                    vRP.request(player, "Luk rapport", 1000, function(player,ok)
                        vRPclient.removeDiv(player,{"police_pc"})
                    end)
                end)
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.not_found()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
    end)
end

-- delete police records by registration
local function ch_delete_police_records(player,choice)
    vRP.prompt(player,lang.police.pc.searchreg.prompt(),"",function(player, reg)
        vRP.getUserByRegistration(reg, function(user_id)
            if user_id ~= nil then
                vRP.setUData(user_id, "vRP:police_records", "")
                TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.police.pc.records.delete.deleted()}, type = "info", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.not_found()}, type = "info", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
    end)
end

-- close business of an arrested owner
local function ch_closebusiness(player,choice)
    vRPclient.getNearestPlayer(player,{5},function(nplayer)
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id ~= nil then
            vRP.getUserIdentity(nuser_id, function(identity)
                vRP.getUserBusiness(nuser_id, function(business)
                    if identity and business then
                        vRP.request(player,lang.police.pc.closebusiness.request({identity.name,identity.firstname,business.name}),15,function(player,ok)
                            if ok then
                                vRP.closeBusiness(nuser_id)
                                TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.police.pc.closebusiness.closed()}, type = "info", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                            end
                        end)
                    else
                        TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    end
                end)
            end)
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end)
end

local function ch_warnedadd(player,choice)
    vRP.prompt(player,lang.police.pc.getvehiclebycpr.prompt(),"",function(player, reg)
        if isCPR(reg) == false then
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Ugyldigt CPR-nummer (Example: 000000-0000)", type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            return;
        end
        vRP.getUserByCPR(reg, function(data)
            if data.user_id ~= nil then
                vRP.prompt(player,"Efterlysnings årsag:","",function(player, reason)
                    if string.len(reason) >= 2 then
                        local nuser_id = vRP.getUserId(player)
                        vRP.getUserIdentity(nuser_id,function(identity)
                            vRP.getUData(data.user_id, "vRP:police_warned", function(rdata)
                                local ldata = json.decode(rdata)
                                if ldata == nil or ldata == -1 then
                                    ldata = {}
                                end
                                table.insert(ldata,{by=identity.firstname.." "..identity.name,reason=reason,time=os.date("%H:%M - %d/%m/%Y")})
                                ldata = json.encode(ldata)
                                vRP.setUData(data.user_id,"vRP:police_warned",ldata)
                                TriggerEvent("vrp_extended:addwarned",data.user_id,ldata)
                                sendToDiscord("https://autisthook.com/api/webhooks/628518824207056896/ZQEVlBzm6I_t2Bq-n0IdIxhkGIeocyUlsGoWcV6uki8noL98HDeP1Wo2y3ETh2zo8Ibu","Server "..GetConvar("servernumber", "0").." - Efterlysning","**"..nuser_id.." - "..identity.firstname.." "..identity.name.."** har lige sat en efterlysning på **"..data.user_id.." - "..data.firstname.." "..data.name.."** med grunden: **"..reason.."** (**"..os.date("%H:%M:%S %d/%m/%Y").."**)")
                                TriggerClientEvent("pNotify:SendNotification", player,{text = {"<b style='color: #4E9350'>"..reg.."</b> er blevet efterlyst for: <br/><b style='color: #4E9350'>"..reason.."</b>"}, type = "success", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                            end)
                        end)
                    else
                        TriggerClientEvent("pNotify:SendNotification", player,{text = {"Årsagen skal være længere end et tegn"}, type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    end
                end)
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.not_found()}, type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
    end)
end

local function ch_warnedremove(player,choice)
    vRP.prompt(player,lang.police.pc.getvehiclebycpr.prompt(),"",function(player, reg)
        if isCPR(reg) == false then
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Ugyldigt CPR-nummer (Example: 000000-0000)", type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            return;
        end
        vRP.getUserByCPR(reg, function(data)
            if data.user_id ~= nil then
                vRP.getUData(data.user_id, "vRP:police_warned", function(rdata)
                    if rdata ~= nil and rdata ~= "" then
                        local content = "<h2>Efterlysnings oversigt af<br/>"..reg.."</h2><br/><br/><table><tr><th>Grund</th><th>Betjent</th><th>Tid</th></tr>"
                        local ldata = json.decode(rdata)
                        if ldata == nil then
                            ldata = {}
                        end
                        for k,v in pairs(ldata) do
                            content = content.."<tr><td>"..v.reason.."</td><td>"..v.by.."</td><td>"..v.time.."</td></tr>"
                        end
                        vRPclient.setDiv(player,{"police_pc",".div_police_pc{ background-color: rgba(0,0,0,0.75); color: white; width: 800px; font-style: normal; font-family: 'Calibri Light', sans-serif; padding: 13px; margin: auto; margin-top: 150px; font-size: 20px; text-align:center;} table{width:100%} b {font-weight: bold; color:red;} h2{font-size: 28px}",content})
                        vRP.request(player, "Fjern efterlysning", 60, function(player,ok)
                            if ok then
                                vRP.removeUData(data.user_id,"vRP:police_warned")
                                TriggerEvent("vrp_extended:removewarned",data.user_id)
                                local nuser_id = vRP.getUserId(player)
                                vRP.getUserIdentity(nuser_id, function(identity)
                                    sendToDiscord("https://autisthook.com/api/webhooks/559362888280702999/VNQKkAtZKoB5R_yBiKBDnY70H7hw11LdFAKOGbo_5FDJ-pQEFQLWBNG4fwmknKHrCoq5","Server "..GetConvar("servernumber", "0").." - Efterlysning","**"..nuser_id.." - "..identity.firstname.." "..identity.name.."** har lige fjernet efterlysningerne på **"..data.user_id.." - "..data.firstname.." "..data.name.."** (**"..os.date("%H:%M:%S %d/%m/%Y").."**)")
                                end)
                            else
                                TriggerClientEvent("pNotify:SendNotification", player,{text = {"Annulleret"}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                            end
                            vRPclient.removeDiv(player,{"police_pc"})
                        end)
                    else
                        TriggerClientEvent("pNotify:SendNotification", player,{text = {"<b style='color: #DB4646'>"..reg.."</b> er ikke efterlyst"}, type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    end
                end)
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.not_found()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
    end)
end

local function ch_warnedlist(player,choice)
    vRP.prompt(player,lang.police.pc.getvehiclebycpr.prompt(),"",function(player, reg)
        if isCPR(reg) == false then
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Ugyldigt CPR-nummer (Example: 000000-0000)", type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            return;
        end
        vRP.getUserByCPR(reg, function(data)
            if data.user_id ~= nil then
                vRP.getUData(data.user_id, "vRP:police_warned", function(rdata)
                    if rdata ~= nil and rdata ~= "" then
                        local content = "<h2>Efterlysnings oversigt af<br/>"..reg.."</h2><br/><br/><table><tr><th>Grund</th><th>Betjent</th><th>Tid</th></tr>"
                        local ldata = json.decode(rdata)
                        if ldata == nil then
                            ldata = {}
                        end
                        for k,v in pairs(ldata) do
                            content = content.."<tr><td>"..v.reason.."</td><td>"..v.by.."</td><td>"..v.time.."</td></tr>"
                        end
                        vRPclient.setDiv(player,{"police_pc",".div_police_pc{ background-color: rgba(0,0,0,0.75); color: white; width: 800px; font-style: normal; font-family: 'Calibri Light', sans-serif; padding: 13px; margin: auto; margin-top: 150px; font-size: 20px; text-align:center;} table{width:100%} b {font-weight: bold; color:red;} h2{font-size: 34px}",content})
                        vRP.request(player, "Luk rapport", 1000, function(player,ok)
                            vRPclient.removeDiv(player,{"police_pc"})
                        end)
                    else
                        TriggerClientEvent("pNotify:SendNotification", player,{text = {"<b style='color: #DB4646'>"..reg.."</b> er ikke efterlyst"}, type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    end
                end)
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = {"Ugyldigt CPR-nummer"}, type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
    end)
end

---- handcuff
local choice_handcuff = {function(player,choice)
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id ~= nil then
            vRPclient.toggleHandcuff(nplayer,{})
            TriggerClientEvent("pNotify:SendNotification", source,{text = {lang.police.cuffs()}, type = "success", queue = "global", timeout = 3000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end)
end,lang.police.menu.handcuff.description()}

local choice_spikes = {function(player,choice)
    vRPclient.spawnspikes(player,{})
end,lang.police.menu.spikes.description()}

local choice_putinveh = {function(player,choice)
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id ~= nil then
            vRPclient.canBeDragged(nplayer,{}, function(handcuffed)  -- check handcuffed
                if handcuffed then
                    TriggerClientEvent("dr:undrag", nplayer)
                    vRPclient.putInNearestVehicleAsPassenger(nplayer,{5}, function(bool)
                        if bool == false then
                            TriggerClientEvent("pNotify:SendNotification", player,{text = {"Der ingen plads i bilen!"}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                        end
                    end)
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.police.not_handcuffed()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                end
            end)
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end)
end,lang.police.menu.putinveh.description()}

local function ch_breakopentrunk(player,choice)
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
        local user_id = vRP.getUserId(player)
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id ~= nil then
            vRPclient.getNearestOwnedVehicle(nplayer,{7},function(ok,vtype,name)
                if ok then
                    vRP.request(player,"Sikker på du vil bryde bagagerummet op på "..name.."?", 60, function(v,ok)
                        if ok then -- take the call
                            local chestname = "u"..nuser_id.."veh_"..string.lower(name)
                            local max_weight = cfg_inventory.vehicle_chest_weights[string.lower(name)] or cfg_inventory.default_vehicle_chest_weight

                            -- open chest
                            local cb_out = function(idname,amount)
                                TriggerClientEvent("pNotify:SendNotification", nplayer,{text = {lang.inventory.give.given({vRP.getItemName(idname),amount})}, type = "info", queue = "global", timeout = 3000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                            end

                            local cb_in = function(idname,amount)
                                TriggerClientEvent("pNotify:SendNotification", nplayer,{text = {lang.inventory.give.received({vRP.getItemName(idname),amount})}, type = "info", queue = "global", timeout = 3000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                            end
                            TriggerClientEvent("cn-animation:startWithoutNotify", player, "breakopentrunk")
                            SetTimeout(2200, function()
                                vRPclient.vc_openDoor(nplayer, {vtype,5})
                                vRP.openChest(player, chestname, max_weight, nil,cb_in,cb_out)
                            end)
                        end
                    end)
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.vehicle.no_owned_near()}, type = "info", queue = "global", timeout = 3000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                end
            end)
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "info", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end)
end

local choice_putinveh_ems = {function(player,choice)
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
        local nuser_id = vRP.getUserId({nplayer})
        if nuser_id ~= nil then
            vRPclient.canBeDragged(nplayer,{}, function(handcuffed)  -- check handcuffed
                if handcuffed then
                    vRPclient.putInNearestVehicleAsPassenger(nplayer, {5})
                    TriggerClientEvent("dr:undrag", nplayer)
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.police.not_handcuffed()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                end
            end)
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end)
end,lang.police.menu.putinveh.description() }

local choice_checkvehreg = {function(player,choice)
    vRPclient.getNearestVehiclePlate(player,{5},function(plate)
        if plate ~= nil then
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Nummerplade: <b style='color: #4E9350'>"..plate.."</b>", type = "success", queue = "global", timeout = 10000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}, killer = true})
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Ingen køretøj fundet", type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}, killer = true})
        end
    end)
end, "Tjek køretøjets registreringsnummer"}


local choice_dragplayer = {function(player,choice)
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id ~= nil then
            vRPclient.canBeDragged(nplayer,{}, function(handcuffed)  -- check handcuffed
                if handcuffed then
                    TriggerClientEvent("dr:drag", nplayer, player)
                else
                    -- vRPclient.notify(player,{lang.police.not_handcuffed()})
                    TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.police.not_handcuffed()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                end
            end)
        else
            -- vRPclient.notify(player,{lang.common.no_player_near()})
            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end)
end,lang.police.menu.dragplayer.description()}

local choice_dragplayer_ems = {function(player,choice)
    vRPclient.getNearestPlayer(player,{3},function(nplayer)
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id ~= nil then
            TriggerClientEvent("dr:drag", nplayer, player)
        else
            -- vRPclient.notify(player,{lang.common.no_player_near()})
            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end)
end,lang.police.menu.dragplayer.description()}

local choice_getoutveh = {function(player,choice)
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id ~= nil then
            vRPclient.canBeDragged(nplayer,{}, function(handcuffed)  -- check handcuffed
                if handcuffed then
                    vRPclient.ejectVehicle(nplayer, {})
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.police.not_handcuffed()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                end
            end)
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end)
end,lang.police.menu.getoutveh.description()}

local choice_getoutveh_ems = {function(player,choice)
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
        local nuser_id = vRP.getUserId({nplayer})
        if nuser_id ~= nil then
            vRPclient.canBeDragged(nplayer,{}, function(handcuffed)  -- check handcuffed
                if handcuffed then
                    vRPclient.ejectVehicle(nplayer, {})
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.police.not_handcuffed()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                end
            end)
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end)
end,lang.police.menu.getoutveh.description() }


local choice_loot_items = {function(player, choice)
    local user_id = vRP.getUserId(player)
    local looted_items = {}
    if user_id ~= nil then
        vRPclient.getNearestPlayer(player, {5}, function(nplayer)
            local nuser_id = vRP.getUserId(nplayer)
            if nuser_id ~= nil then
                vRPclient.isInComa(nplayer,{}, function(in_coma)  -- check handcuffed
                    if in_coma then
                --Kode til at gemme items personen har equipped
                vRPclient.replaceWeapons(nplayer,{},function(weapons)
                    vRP.getUserIdentity(nuser_id, function(identity)
                        local fornavn = identity.firstname
                        local efternavn = identity.name
                        local dato = os.date("**%d-%m-%Y** kl. **%X**")
                        if identity then
                            table.insert(looted_items, "**"..fornavn.." "..efternavn.." ("..user_id..")** gemte følgende våben - ("..dato.."): \n")
                            for k,v in pairs(weapons) do
                                vRP.giveInventoryItem(nuser_id, "wbody|"..k, 1, true)
                                table.insert(looted_items, "- 1x "..vRP.getItemName("wbody|"..k).."\n")
                                if v.ammo > 0 then
                                    vRP.giveInventoryItem(nuser_id, "wammo|"..k, v.ammo, true)
                                    table.insert(looted_items, "- "..v.ammo.."x "..vRP.getItemName("wammo|"..k).."\n")
                                end
                            end
                        end
                    end)

                end)
                --slut på kode dertil
                        vRP.getUserIdentity(user_id, function(identity_cop)
                            vRP.getUserIdentity(nuser_id, function(identity_civ)
                                if identity_cop and identity_civ then
                                    local cop_name = identity_cop.firstname
                                    local cop_lname = identity_cop.name
                                    local civ_name = identity_civ.firstname
                                    local civ_lname = identity_civ.name

                                        local revive_seq = {
                                            {"amb@medic@standing@kneel@enter","enter",1},
                                            {"amb@medic@standing@kneel@idle_a","idle_a",1},
                                            {"amb@medic@standing@kneel@exit","exit",1}
                                        }
                                        vRPclient.playAnim(player,{false,revive_seq,false}) -- anim
                                        SetTimeout(15000, function()
                                            table.insert(looted_items, "**"..cop_name.." "..cop_lname.." ("..user_id..")** beslaglagde følgende genstande fra **"..civ_name.." "..civ_lname.." ("..nuser_id..")**: \n")
                                            for k,v in pairs(cfg.lootable_items) do -- transfer seizable items
                                                local amount = vRP.getInventoryItemAmount(nuser_id,v)
                                                if amount > 0 then
                                                    local item = vRP.items[v]
                                                    if item then -- do transfer
                                                        if vRP.tryGetInventoryItem(nuser_id,v,amount,true) then
                                                            table.insert(looted_items, "- "..amount.."x "..vRP.getItemName(v).."\n")
                                                            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.police.menu.seize.seized({item.name,amount})}, type = "info", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                                            vRP.giveInventoryItem(user_id,v,amount,false)
                                                        end
                                                    end
                                                end
                                            end
                                            PerformHttpRequest('https://autisthook.com/api/webhooks/634897731089072138/VBJsV03l4aqupFnkDcaNtdEAMwnav2ehMu4f5kvm4wf3tBtX67NcnfSiSra27NvC6doO', function(err, text, headers) end, 'POST', json.encode({username = "Beslaglagt - Server " .. GetConvar("servernumber","0"), content = table.concat(looted_items)}), { ['Content-Type'] = 'application/json' })
                                            TriggerClientEvent("pNotify:SendNotification", nplayer,{text = {lang.police.menu.seize.items.seized()}, type = "info", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})


                                        end)
                                    else
                                        TriggerClientEvent("pNotify:SendNotification", player,{text = {"Personen er ikke bevistløs"}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                    end
                                end)
                            end)
                        end
                    end)
                    else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    end
                end)
            end
        end, lang.police.menu.seize.items.description()}

---- askid
local choice_askid = {function(player,choice)
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id ~= nil then
            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.police.menu.askid.asked()}, type = "info", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            vRP.request(nplayer,lang.police.menu.askid.request(),15,function(nplayer,ok)
                if ok then
                    vRP.getUserIdentity(nuser_id, function(identity)
                        if identity then
                            -- display identity and business
                            local name = identity.name
                            local firstname = identity.firstname

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

                            local phone = identity.phone

                            local job = vRP.getUserGroupByType(nuser_id,"job")
                            local checksub = vRP.getUserGroupByType(nuser_id,job)
                            if checksub ~= nil and checksub ~= "" then
                                job = checksub
                            end
                            if job == "Producent" or job == "Kemiker" or job == "Pusher" or job == "Våbendealer" or job == "Drugdealer" or job == "Indbrudstyv" then
                                job = "Arbejdsløs"
                            end
                            local bname = "Ingen"
                            vRP.getUserBusiness(nuser_id, function(business)
                                if business then
                                    bname = business.name
                                end
                                vRP.getUserAddress(nuser_id, function(address)
                                    local home = ""
                                    if address then
                                        home = address.home.. " nr. "..address.number
                                    else
                                        home = "Hjemløs"
                                    end
                                    local content = lang.police.identity.info({name,firstname,age,cpr,phone,home,job,bname})
                                    vRPclient.setDiv(player,{"police_identity",".div_police_identity{ background-color: rgba(0,0,0,0.75); color: white; font-family: Lato; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
                                    -- request to hide div
                                    vRP.request(player, lang.police.menu.askid.request_hide(), 1000, function(player,ok)
                                        vRPclient.removeDiv(player,{"police_identity"})
                                    end)
                                end)
                            end)
                        end
                    end)
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.request_refused()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                end
            end)
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end)
end, lang.police.menu.askid.description()}


--Vis ID
local choice_showid = {function(player,choice)
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
        local nuser_id = vRP.getUserId(nplayer)
        local user_id = vRP.getUserId(player)
        if nuser_id ~= nil then
          vRP.getUserIdentity(user_id, function(identity)
            print(user_id)
                if identity then
                    -- display identity and business
                    local name = identity.name
                    local firstname = identity.firstname
                    print(firstname)
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

                    local phone = identity.phone


                    local bname = "Ingen"
                    vRP.getUserBusiness(user_id, function(business)
                        if business then
                            bname = business.name
                        end
                        vRP.getUserAddress(user_id, function(address)
                            local home = ""
                            if address then
                                home = address.home.. " nr. "..address.number
                            else
                                home = "Hjemløs"
                            end
                            local content = lang.police.identity.info({name,firstname,age,cpr,phone,home,bname, user_id})
                            vRPclient.setDiv(nplayer,{"police_identity",".div_police_identity{ background-color: rgba(0,0,0,0.75); color: white; font-family: Lato; width: 300px; padding: 10px; margin: auto; margin-top: 150px; margin-left:250px; z-index:100000000000; }",content})
                            -- request to hide div
                            vRP.request(nplayer, lang.police.menu.askid.request_hide(), 1000, function(player,ok)
                                vRPclient.removeDiv(nplayer,{"police_identity"})
                            end)
                        end)
                    end)
                end
            end)
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end)
end, "Viser id til nærmeste person"}

--Spørg om visitation
local choice_user_check = {function(player,choice)
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id ~= nil then
            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.police.menu.check.asked()}, type = "info", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            vRP.request(nplayer,lang.police.menu.check.request(),15,function(nplayer,ok)
                if ok then
                    vRPclient.getWeapons(nplayer,{},function(weapons)
                        -- prepare display data (money, items, weapons)
                        local money = vRP.getMoney(nuser_id)
                        local items = ""
                        local data = vRP.getUserDataTable(nuser_id)
                        if data and data.inventory then
                            for k,v in pairs(data.inventory) do
                                local item = vRP.items[k]
                                if item then
                                    items = items.."<br />"..item.name.." ("..v.amount..")"
                                end
                            end
                        end

                        local weapons_info = ""
                        for k,v in pairs(weapons) do
                            weapons_info = weapons_info.."<br />"..k.." ("..v.ammo..")"
                        end

                        vRPclient.setDiv(player,{"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info})})
                        -- request to hide div
                        vRP.request(player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
                            vRPclient.removeDiv(player,{"police_check"})
                        end)
                    end)
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.request_refused()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                end
            end)
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end)
end, lang.police.menu.check.description()}



---- police check
local choice_check = {function(player,choice)
    vRPclient.getNearestPlayer(player,{5},function(nplayer)
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id ~= nil then
            TriggerClientEvent("pNotify:SendNotification", nplayer,{text = {lang.police.menu.check.checked()}, type = "info", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            vRPclient.getWeapons(nplayer,{},function(weapons)
                -- prepare display data (money, items, weapons)
                local money = vRP.getMoney(nuser_id)
                local items = ""
                local data = vRP.getUserDataTable(nuser_id)
                if data and data.inventory then
                    for k,v in pairs(data.inventory) do
                        local item = vRP.items[k]
                        if item then
                            items = items.."<br />"..item.name.." ("..v.amount..")"
                        end
                    end
                end

                local weapons_info = ""
                for k,v in pairs(weapons) do
                    weapons_info = weapons_info.."<br />"..k.." ("..v.ammo..")"
                end

                vRPclient.setDiv(player,{"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info})})
                -- request to hide div
                vRP.request(player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
                    vRPclient.removeDiv(player,{"police_check"})
                end)
            end)
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end)
end, lang.police.menu.check.description()}

local choice_seize_weapons = {function(player, choice)
    local user_id = vRP.getUserId(player)
    local seized_guns = {}
    if user_id ~= nil then
        vRPclient.getNearestPlayer(player, {5}, function(nplayer)
            local nuser_id = vRP.getUserId(nplayer)
            if nuser_id ~= nil and vRP.hasPermission(nuser_id, "police.seizable") then
                vRPclient.canBeDragged(nplayer,{}, function(handcuffed) -- check handcuffed
                    vRP.getUserIdentity(user_id, function(identity_cop)
                        vRP.getUserIdentity(nuser_id, function(identity_civ)
                            if identity_cop and identity_civ then
                                local cop_name = identity_cop.firstname
                                local cop_lname = identity_cop.name
                                local civ_name = identity_civ.firstname
                                local civ_lname = identity_civ.name

                                if handcuffed then
                                    table.insert(seized_guns, "**"..cop_name.." "..cop_lname.." ("..user_id..")** beslaglagde følgende våben fra **"..civ_name.." "..civ_lname.." ("..nuser_id..")**: \n")
                                    vRPclient.replaceWeapons(nplayer,{},function(weapons)
                                        for k,v in pairs(weapons) do -- display seized weapons
                                            table.insert(seized_guns, "- 1x "..vRP.getItemName("wbody|"..k).."\n")
                                            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.police.menu.seize.seized({vRP.getItemName("wbody|"..k),1})}, type = "info", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                            vRP.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                                            if v.ammo > 0 then
                                                vRP.giveInventoryItem(user_id, "wammo|"..k, v.ammo, true)
                                                table.insert(seized_guns, "- "..v.ammo.."x "..vRP.getItemName("wammo|"..k).."\n")
                                                TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.police.menu.seize.seized({vRP.getItemName("wammo|"..k),v.ammo})}, type = "info", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                            end
                                        end
                                        vRPclient.giveWeapons(nplayer,{{},true})
                                        PerformHttpRequest('https://autisthook.com/api/webhooks/537781757500719124/BmDgEErY5pq3qg2vZH5DE0ZaeGrb147gobrp4d7lLrk_z6hw_fFlyyaOznOlfv2QsqeY', function(err, text, headers) end, 'POST', json.encode({username = "Beslaglagt våben - Server " .. GetConvar("servernumber","0"), content = table.concat(seized_guns)}), { ['Content-Type'] = 'application/json' })
                                        TriggerClientEvent("pNotify:SendNotification", nplayer,{text = {lang.police.menu.seize.weapons.seized()}, type = "warning", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                    end)
                                else
                                    TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.police.not_handcuffed()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                end
                            end
                        end)
                    end)
                end)
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
    end
end, lang.police.menu.seize.weapons.description()}

local choice_seize_items = {function(player, choice)
    local user_id = vRP.getUserId(player)
    local seized_items = {}
    if user_id ~= nil then
        vRPclient.getNearestPlayer(player, {5}, function(nplayer)
            local nuser_id = vRP.getUserId(nplayer)
            if nuser_id ~= nil and vRP.hasPermission(nuser_id, "police.seizable") then
                vRPclient.canBeDragged(nplayer,{}, function(handcuffed)  -- check handcuffed
                    vRP.getUserIdentity(user_id, function(identity_cop)
                        vRP.getUserIdentity(nuser_id, function(identity_civ)
                            if identity_cop and identity_civ then
                                local cop_name = identity_cop.firstname
                                local cop_lname = identity_cop.name
                                local civ_name = identity_civ.firstname
                                local civ_lname = identity_civ.name

                                if handcuffed then
                                    table.insert(seized_items, "**"..cop_name.." "..cop_lname.." ("..user_id..")** beslaglagde følgende genstande fra **"..civ_name.." "..civ_lname.." ("..nuser_id..")**: \n")
                                    for k,v in pairs(cfg.seizable_items) do -- transfer seizable items
                                        local amount = vRP.getInventoryItemAmount(nuser_id,v)
                                        if amount > 0 then
                                            local item = vRP.items[v]
                                            if item then -- do transfer
                                                if vRP.tryGetInventoryItem(nuser_id,v,amount,true) then
                                                    table.insert(seized_items, "- "..amount.."x "..vRP.getItemName(v).."\n")
                                                    TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.police.menu.seize.seized({item.name,amount})}, type = "info", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                                    vRP.giveInventoryItem(user_id,v,amount,false)
                                                end
                                            end
                                        end
                                    end
                                    PerformHttpRequest('https://autisthook.com/api/webhooks/707717676478496828/RIix3N5XmluAFrRoIVyoMgbhhtHK9jhfQfD2p0ijirjkQnEykTSWbuD6RVi6oVomiiAC', function(err, text, headers) end, 'POST', json.encode({username = "Beslaglagt - Server " .. GetConvar("servernumber","0"), content = table.concat(seized_items)}), { ['Content-Type'] = 'application/json' })
                                    TriggerClientEvent("pNotify:SendNotification", nplayer,{text = {lang.police.menu.seize.items.seized()}, type = "info", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                else
                                    TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.police.not_handcuffed()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                end
                            end
                        end)
                    end)
                end)
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
    end
end, lang.police.menu.seize.items.description()}

local choice_fine = {function(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        vRPclient.getNearestPlayer(player, {5}, function(nplayer)
            local nuser_id = vRP.getUserId(nplayer)
            if nuser_id ~= nil then
                local money = vRP.getMoney(nuser_id)+vRP.getBankMoney(nuser_id)

                -- build fine menu
                local menu = {name=lang.police.menu.fine.title(),css={top="75px",header_color="rgba(100,0,0,0.75)"}}

                local choose = function(player,choice) -- fine action
                    local amount = cfg.fines[choice]
                    if amount ~= nil then
                        if vRP.tryFullPayment(nuser_id, amount) then
                            vRP.insertPoliceRecord(nuser_id, lang.police.menu.fine.record({choice,amount}))
                            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.police.menu.fine.fined({choice,amount})}, type = "info", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                            TriggerClientEvent("pNotify:SendNotification", nplayer,{text = {lang.police.menu.fine.notify_fined({choice,amount})}, type = "info", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                            vRP.closeMenu(player)
                        else
                            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.money.not_enough()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                        end
                    end
                end

                for k,v in pairs(cfg.fines) do -- add fines in function of money available
                    if v <= money then
                        menu[k] = {choose,v}
                    end
                end

                -- open menu
                vRP.openMenu(player, menu)
            else
                TriggerClientEvent("pNotify:SendNotification",player,{text = {lang.common.no_player_near()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
    end
end, lang.police.menu.fine.description()}

-- Fjern kørekort
-- Remove License (UserID)
local choice_license = {function(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        vRPclient.getNearestPlayers(player,{5},function(nplayer)
            usrList = ""
            for k,v in pairs(nplayer) do
                usrList = usrList .. "[" .. vRP.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
            end
            if usrList ~= "" then
                vRP.prompt(player,"Nærmeste spiller(e): " .. usrList .. "","",function(player,nuser_id)
                    if nuser_id ~= nil and nuser_id ~= "" then
                        local target = vRP.getUserSource(tonumber(nuser_id))
                        if target ~= nil then
                            vRP.setLicense(nuser_id,2)
                            TriggerClientEvent("pNotify:SendNotification", player,{text = nuser_id.. " fik frakendt sit kørekort.", type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                            TriggerClientEvent("pNotify:SendNotification", target,{text = "Dit kørekort blev frataget", type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                            sendToDiscord("https://autisthook.com/api/webhooks/597829102757478400/qixuI01zFsM2nvrhuXPOlm6bw23OT6oG-_KEn62zGPAn3jLrrbatWDvYDESZocsfrSfC","Server "..GetConvar("servernumber", "0").." - Frakendt","**"..user_id.."** har lige frakendt **"..nuser_id.."**'s kørekort (**"..os.date("%H:%M:%S %d/%m/%Y").."**)")
                        else
                            TriggerClientEvent("pNotify:SendNotification", player,{text = {"Dette ID ser ud til ikke at eksistere"}, type = "warning", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                        end
                    else
                        TriggerClientEvent("pNotify:SendNotification", player,{text = {"Intet ID valgt"}, type = "warning", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    end
                end)
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = {"Ingen spiller i nærheden"}, type = "warning", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
    end
end,lang.police.menu.license.description()}


-- Tildel kørekort
-- Remove License (UserID)
local choice_licenseGive = {function(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        vRPclient.getNearestPlayers(player,{5},function(nplayer)
            usrList = ""
            for k,v in pairs(nplayer) do
                usrList = usrList .. "[" .. vRP.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
            end
            if usrList ~= "" then
              vRP.prompt(player,"Kategori: bil (1), Motorcykel (3), Lastbil (4)","",function(player,category)
                  vRP.prompt(player,"Nærmeste spiller(e): " .. usrList .. "","",function(player,nuser_id)
                      if nuser_id ~= nil and nuser_id ~= "" then
                          local target = vRP.getUserSource(tonumber(nuser_id))
                          local category = tonumber(category)
                          if target ~= nil then
                              vRP.setLicense(nuser_id,category)
                              TriggerClientEvent("pNotify:SendNotification", player,{text = nuser_id.. " fik tildelt et kørekort.", type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                              TriggerClientEvent("pNotify:SendNotification", target,{text = "Du har fået tildelt et kørekort", type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                              sendToDiscord("https://autisthook.com/api/webhooks/597829102757478400/qixuI01zFsM2nvrhuXPOlm6bw23OT6oG-_KEn62zGPAn3jLrrbatWDvYDESZocsfrSfC","Server "..GetConvar("servernumber", "0").." - Tildelt","**"..user_id.."** har lige tildelt **"..nuser_id.."** et kørekort (**"..os.date("%H:%M:%S %d/%m/%Y").."**)")
                          else
                              TriggerClientEvent("pNotify:SendNotification", player,{text = {"Dette ID ser ud til ikke at eksistere"}, type = "warning", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                          end
                      else
                          TriggerClientEvent("pNotify:SendNotification", player,{text = {"Intet ID valgt"}, type = "warning", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                      end
                  end)
                end)
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = {"Ingen spiller i nærheden"}, type = "warning", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
    end
end,lang.police.menu.licenseGive.description()}

-- search identity by registration
local choice_carsearch = {function(player, choice)
    vRP.prompt(player,lang.police.menu.searchcar.prompt(),"",function(player, reg)
        vRP.getUserByRegistration(reg, function(user_id)
            if user_id ~= nil then
                vRP.getUserIdentity(user_id, function(identity)
                    if identity then
                        -- display identity and business
                        local name = identity.name
                        local firstname = identity.firstname

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

                        local phone = identity.phone
                        local registration = identity.registration
                        local bname = "Intet"
                        local home = ""

                        vRP.getUserBusiness(user_id, function(business)
                            if business then
                                bname = business.name
                            end

                            vRP.getUserAddress(user_id, function(address)
                                local home = ""
                                if address then
                                    home = address.home.. " nr. "..address.number
                                else
                                    home = "Hjemløs"
                                end

                                local job = vRP.getUserGroupByType(user_id,"job")
                                local checksub = vRP.getUserGroupByType(user_id,job)
                                if checksub ~= nil and checksub ~= "" then
                                    job = checksub
                                end
                                if job == "Producent" or job == "Kemiker" or job == "Pusher" or job == "Våbendealer" or job == "Drugdealer" or job == "Indbrudstyv" then
                                    job = "Arbejdsløs"
                                end

                                local content = "<h3>Oversigt af P "..reg.."</h3></br>"..lang.police.identity.info({name,firstname,age,cpr,phone,home,job,bname})
                                vRPclient.setDiv(player,{"police_identity",".div_police_identity{ background-color: rgba(0,0,0,0.75); color: white; font-family: Lato; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
                                vRP.request(player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
                                    vRPclient.removeDiv(player,{"police_identity"})
                                end)
                            end)
                        end)
                    else
                        TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.not_found()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    end
                end)
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.not_found()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
    end)
end, lang.police.menu.searchcar.description()}

local choice_store_weapons = {function(player, choice)
    local user_id = vRP.getUserId(player)
    local stored_items = {}
    if user_id ~= nil then
        vRPclient.replaceWeapons(player,{},function(weapons)
            vRP.getUserIdentity(user_id, function(identity)
                local fornavn = identity.firstname
                local efternavn = identity.name
                local dato = os.date("**%d-%m-%Y** kl. **%X**")
                if identity then
                    table.insert(stored_items, "**"..fornavn.." "..efternavn.." ("..user_id..")** gemte følgende våben - ("..dato.."): \n")
                    for k,v in pairs(weapons) do
                        vRP.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                        table.insert(stored_items, "- 1x "..vRP.getItemName("wbody|"..k).."\n")
                        if v.ammo > 0 then
                            vRP.giveInventoryItem(user_id, "wammo|"..k, v.ammo, true)
                            table.insert(stored_items, "- "..v.ammo.."x "..vRP.getItemName("wammo|"..k).."\n")
                        end
                    end
                    -- clear all weapons
                    --vRPclient.giveWeapons(player,{{},true})
                    vRP.closeMenu(player)
                end
            end)
        end)
    end
end, lang.police.menu.store_weapons.description()}

local revive_seq = {
    {"amb@medic@standing@kneel@enter","enter",1},
    {"amb@medic@standing@kneel@idle_a","idle_a",1},
    {"amb@medic@standing@kneel@exit","exit",1}
}

local choice_revive = {function(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        vRPclient.getNearestPlayer(player,{10},function(nplayer)
            local nuser_id = vRP.getUserId(nplayer)
            if nuser_id ~= nil then
                vRPclient.isInComa(nplayer,{}, function(in_coma)
                    if in_coma then
                        vRPclient.playAnim(player,{false,revive_seq,false}) -- anim
                        SetTimeout(15000, function()
                            vRPclient.varyHealth(nplayer,{50}) -- heal 50
                            TriggerClientEvent("pNotify:SendNotification", nplayer,{text ="Du er blevet genoplivet af en læge.", type = "success", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
                            TriggerClientEvent("pNotify:SendNotification", player,{text ="Personen blev genoplivet.", type = "success", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
                        end)
                    else
                        TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.emergency.menu.revive.not_in_coma()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    end
                end)
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
    end
end,lang.emergency.menu.revive.description()}

local heal_seq = {
    {"amb@prop_human_parking_meter@male@enter","enter",1},
    {"amb@prop_human_parking_meter@male@idle_a","idle_a",1},
    {"amb@prop_human_parking_meter@male@exit","exit",1}
}

local choice_heal = {function(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        vRPclient.getNearestPlayer(player,{10},function(nplayer)
            local nuser_id = vRP.getUserId(nplayer)
            if nuser_id ~= nil then
                vRPclient.isInComa(nplayer,{}, function(in_coma)
                    if not in_coma then
                        if vRP.tryGetInventoryItem(user_id,"bandage",1,true) then
                            vRPclient.playAnim(player,{false,heal_seq,false}) -- anim
                            SetTimeout(7500, function()
                                vRPclient.isInComa(nplayer,{}, function(in_coma2)
                                    if not in_coma2 then
                                        vRPclient.varyHealth(nplayer,{100}) -- heal 100
                                        TriggerClientEvent("pNotify:SendNotification", nplayer,{text ="Du er blevet helbredt af en læge.", type = "success", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
                                        TriggerClientEvent("pNotify:SendNotification", player,{text ="Personen blev helbredt.", type = "success", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
                                    else
                                        TriggerClientEvent("pNotify:SendNotification", player,{text ="Personen døde under helbredelsen.", type = "success", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
                                    end
                                end)
                            end)
                        end
                    else
                        TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.emergency.menu.heal.in_coma()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    end
                end)
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.common.no_player_near()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
    end
end,lang.emergency.menu.heal.description()}

local choice_blodpromille = {function(player,choice)
    vRPclient.getNearestPlayer(player,{5},function(nplayer)
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id ~= nil then
            local promille = math.abs(vRP.getPromille(nuser_id))
            if promille == 0 then promille = promille..".0" end
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Tjekker efter promille...", type = "success", queue = "global", timeout = 14500, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            Wait(15000)
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Promille på <b style='color: #4E9350'>"..promille.."</b>", type = "success", queue = "global", timeout = 5000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Ingen personer nær dig", type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}, killer = true})
        end
    end)
end, "Tager en blodprøve af nærmeste person for at finde promille" }

local choice_cleanpromille = {function(player,choice)
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id ~= nil then
            local promille = math.abs(vRP.getPromille(nuser_id))
            if promille > 1 then
                TriggerClientEvent("pNotify:SendNotification", player,{text = "Starter udpumpning", type = "success", queue = "global", timeout = 5000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                Wait(30000)
                vRP.setPromille(nuser_id,0)
                TriggerClientEvent("pNotify:SendNotification", player,{text = "Udpumpning færdig", type = "success", queue = "global", timeout = 5000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = "Personen har ikke brug for udpumpning", type = "success", queue = "global", timeout = 5000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Ingen personer nær dig", type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}, killer = true})
        end
    end)
end, "Udpumpning"}

local choice_checkpromille = {function(player,choice)
    vRPclient.getNearestPlayer(player,{5},function(nplayer)
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id ~= nil then
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Spørger person...", type = "success", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}, killer = true})
            vRP.request(nplayer,"Vil du puste i alkometeret?",30,function(nplayer,ok)
                if ok then
                    local promille = math.abs(vRP.getPromille(nuser_id))
                    if promille == 0 then promille = promille..".0" end
                    TriggerClientEvent("pNotify:SendNotification", player,{text = "Tjekker efter promille", type = "success", queue = "global", timeout = 4500, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    TriggerEvent("InteractSound_SV:PlayWithinDistanceWithSource",player, 5,"alkometer", 0.2)
                    Wait(5000)
                    TriggerClientEvent("pNotify:SendNotification", player,{text = "Promille på <b style='color: #4E9350'>"..promille.."</b>", type = "success", queue = "global", timeout = 5000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = "Person nægtet at puste", type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}, killer = true})
                end
            end)
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Ingen personer nær dig", type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}, killer = true})
        end
    end)
end, "Tjek promille på den nærmeste person" }

local choice_driverslicense = {function(player,choice)
    vRPclient.getNearestPlayer(player,{5},function(nplayer)
        local nuser_id = vRP.getUserId(nplayer)
        if nuser_id ~= nil then
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Spørger person...", type = "success", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}, killer = true})
            vRP.request(nplayer,"Vil du vise kørekort?",30,function(nplayer,ok)
                if ok then
                    vRP.getUserIdentity(nuser_id, function(identity)
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

                        local cpr = split[1]..split[2]..string.sub(split[3],3).."-"..identity.lastdigits

                        vRP.getDriverLicense(nuser_id, function(license)
                            local driverlicense = ""
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
                            local content = lang.police.identity.driverlicense({identity.firstname,identity.name,identity.cpr,cpr,driverlicense})
                            vRPclient.setDiv(player,{"police_pc",".div_police_pc{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 400px; font-style: normal; font-family: 'Calibri Light', sans-serif; padding: 13px; margin: auto; margin-top: 150px; }",content})
                            vRP.request(player, lang.police.menu.askid.request_hide(), 1000, function(player,ok)
                                vRPclient.removeDiv(player,{"police_pc"})
                            end)
                        end)

                    end)
                else
                    TriggerClientEvent("pNotify:SendNotification", player,{text = "Person nægtet at vise kørekort", type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}, killer = true})
                end
            end)
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Ingen personer nær dig", type = "error", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}, killer = true})
        end
    end)
end, "Tjek kørekort på nærmeste person"}

local choice_impound = {function(player,choice)
    vRPclient.forceCommand(player,{"impound"})
end, "Beslaglag nærmeste køretøj" }

function isCPR(cpr)
    local cancel = true
    if #cpr == 11 then
        for i = 1, #cpr do
            local c = cpr:sub(i,i)
            if i < 6 then
                if not tonumber(c) then
                    cancel = false
                end
            elseif i == 7 then
                if c ~= "-" then
                    cancel = false
                end
            elseif i > 7 then
                if not tonumber(c) then
                    cancel = false
                end
            end
        end
    else
        cancel = false
    end
    return cancel
end

-- add choices to the menu
vRP.registerMenuBuilder("main", function(add, data)
    local player = data.player

    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        local choices = {}
        if vRP.hasPermission(user_id,"police.menu") then
            choices[lang.police.title()] = {function(player,choice)
                vRP.buildMenu("police", {player = player}, function(menu)
                    menu.name = lang.police.title()
                    menu.css = {top="75px",header_color="rgba(2,0,49,0.75)"}

                    if vRP.hasPermission(user_id,"politi.onduty") then -- Til så admine ikke får dem
                        menu["Tjek promille"] = choice_checkpromille
                        menu["Tjek kørekort"] = choice_driverslicense
                        menu[lang.police.pc.searchbirth.title()] = {ch_searchbybirth,lang.police.pc.searchbirth.description()}
                        menu[lang.police.pc.searchcpr.title()] = {ch_searchcpr,lang.police.pc.searchcpr.description()}
                        menu[lang.police.pc.getvehiclebycpr.title()] = {ch_getvehiclesbycpr,lang.police.pc.getvehiclebycpr.description()}
                        menu[lang.police.pc.searchphone.title()] = {ch_searchphone,lang.police.pc.searchphone.description()}
                        menu[lang.police.pc.records.show.title()] = {ch_show_police_records,lang.police.pc.records.show.description()}
                        menu["Tjek registreringsnummer"] = choice_checkvehreg
                        menu["Beslaglæg køretøj"] = choice_impound
                        menu["Eftersøg person"] = {ch_warnedadd,"Skriv en efterlysning af en person"}
                        menu["Efterlysning på CPR"] = {ch_warnedlist,"Få alle efterlysninger på et cpr"}
                        menu["Fjern efterlysning"] = {ch_warnedremove,"Fjern alle efterlysninger på et cpr"}
                        menu["Bryd bagagerum op"] = {ch_breakopentrunk,"Bryd bagagerum op, hvis en person ikke vil åbne det."}
                    end
                    if vRP.hasPermission(user_id,"police.putinveh") then
                        menu[lang.police.menu.putinveh.title()] = choice_putinveh
                    end
                    if vRP.hasPermission(user_id,"police.getoutveh") then
                        menu[lang.police.menu.getoutveh.title()] = choice_getoutveh
                    end
                    if vRP.hasPermission(user_id,"emergency.revive") then
                        menu[lang.emergency.menu.revive.title()] = choice_revive
                    end
                    if vRP.hasPermission(user_id,"police.check") then
                        menu[lang.police.menu.check.title()] = choice_check
                    end
                    if vRP.hasPermission(user_id,"police.seize.weapons") then
                        menu[lang.police.menu.seize.weapons.title()] = choice_seize_weapons
                    end
                    if vRP.hasPermission(user_id,"police.spikes") then
                        menu[lang.police.menu.spikes.title()] = choice_spikes
                    end
                    if vRP.hasPermission(user_id,"police.drag") then
                        menu[lang.police.menu.dragplayer.title()] = choice_dragplayer
                    end
                    if vRP.hasPermission(user_id,"police.seize.items") then
                        menu[lang.police.menu.seize.items.title()] = choice_seize_items
                    end
                    if vRP.hasPermission(user_id,"police.licenseGive") then
                        menu[lang.police.menu.licenseGive.title()] = choice_licenseGive
                    end
                    if vRP.hasPermission(user_id,"police.license") then
                        menu[lang.police.menu.license.title()] = choice_license
                    end
                    if vRP.hasPermission(user_id,"police.carsearch") then
                        menu[lang.police.menu.searchcar.title()] = choice_carsearch
                    end
                    vRP.openMenu(player,menu)
                end)
            end}
        end

        if vRP.hasPermission(user_id,"emergency.menu") then
            choices[lang.emergency.title()] = {function(player,choice)
                vRP.buildMenu("ems", {player = player}, function(menu)
                    menu.name = lang.emergency.title()
                    menu.css = {top="75px",header_color="rgba(1,92,83,0.75)"}

                    menu["Udpumpning"] = choice_cleanpromille
                    menu["Tag blodprøve"] = choice_blodpromille
                    if vRP.hasPermission(user_id,"emergency.putinveh") then
                        menu[lang.police.menu.putinveh.title()] = choice_putinveh_ems
                    end
                    if vRP.hasPermission(user_id,"emergency.getoutveh") then
                        menu[lang.police.menu.getoutveh.title()] = choice_getoutveh_ems
                    end
                    if vRP.hasPermission(user_id,"emergency.drag") then
                        menu[lang.police.menu.dragplayer.title()] = choice_dragplayer_ems
                    end
                    if vRP.hasPermission(user_id,"emergency.revive") then
                        menu[lang.emergency.menu.revive.title()] = choice_revive
                    end
                    if vRP.hasPermission(user_id,"emergency.heal") then
                        menu[lang.emergency.menu.heal.title()] = choice_heal
                    end
                    vRP.openMenu(player,menu)
                end)
            end}
        end

        if vRP.hasPermission(user_id, "user.askid") then
            choices[lang.police.menu.askid.title()] = choice_askid
            choices["Vis id til nærmeste"] = choice_showid
            -- choices[lang.police.menu.kiss.title()] = choice_kiss
            choices["Loot"] = choice_loot_items
        end

        add(choices)
    end
end)

vRP.registerMenuBuilder("Bilforhandler", function(add, data)
    local user_id = vRP.getUserId({data.player})
    if user_id ~= nil then
        local choices = {}
        choices["Tjek kørekort"] = choice_driverslicense
        add(choices)
    end
end)

-- WANTED SYNC
local wantedlvl_players = {}

function vRP.getUserWantedLevel(user_id)
    return wantedlvl_players[user_id] or 0
end

-- receive wanted level
function tvRP.updateWantedLevel(level)
    local player = source
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        local was_wanted = (vRP.getUserWantedLevel(user_id) > 0)
        wantedlvl_players[user_id] = level
        local is_wanted = (level > 0)

        -- send wanted to listening service
        --[[if not was_wanted and is_wanted then
            vRPclient.getPosition(player, {}, function(x,y,z)
                vRP.sendServiceAlert(nil, cfg.wanted.service,x,y,z,lang.police.wanted({level}))
            end)
        end]]

        if was_wanted and not is_wanted then
            vRPclient.removeNamedBlip(-1, {"vRP:wanted:"..user_id}) -- remove wanted blip (all to prevent phantom blip)
        end
    end
end

-- delete wanted entry on leave
AddEventHandler("vRP:playerLeave", function(user_id, player)
    wantedlvl_players[user_id] = nil
    vRPclient.removeNamedBlip(-1, {"vRP:wanted:"..user_id})  -- remove wanted blip (all to prevent phantom blip)
end)

-- display wanted positions
local function task_wanted_positions()
    local listeners = vRP.getUsersByPermission("police.wanted")
    for k,v in pairs(wantedlvl_players) do -- each wanted player
        local player = vRP.getUserSource(tonumber(k))
        if player ~= nil and v ~= nil and v > 0 then
            vRPclient.getPosition(player, {}, function(x,y,z)
                for l,w in pairs(listeners) do -- each listening player
                    local lplayer = vRP.getUserSource(w)
                    if lplayer ~= nil then
                        vRPclient.setNamedBlip(lplayer, {"vRP:wanted:"..k,x,y,z,cfg.wanted.blipid,cfg.wanted.blipcolor,lang.police.wanted({v})})
                    end
                end
            end)
        end
    end

    SetTimeout(5000, task_wanted_positions)
end
task_wanted_positions()

RegisterServerEvent('handcuff:cuffHim')
AddEventHandler('handcuff:cuffHim', function()
    local source = source
    local user_id = vRP.getUserId({source})

    vRPclient.getNearestPlayer(source,{1.5},function(cplayer)
        if cplayer ~= nil then
            vRPclient.toggleHandcuff(cplayer,{})
            vRPclient.isHandcuffed(cplayer,{}, function(handcuffed)
                if handcuffed then

                  TriggerClientEvent("cn-animation:start", source, "arrester")
                    TriggerClientEvent("pNotify:SendNotification", source,{text = {"Personen blev sat i håndjern."}, type = "info", queue = "global", timeout = 3000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                else
                    TriggerClientEvent("pNotify:SendNotification", source,{text = {"Personen fik løsnet sine håndjern."}, type = "info", queue = "global", timeout = 3000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                end
            end)
        else
            TriggerClientEvent("pNotify:SendNotification", source,{text = {lang.common.no_player_near()}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end)
end)

function sendToDiscord(discord,name, message)
    if message == nil or message == '' or message:sub(1, 1) == '/' then return FALSE end
    PerformHttpRequest(discord, function(err, text, headers) end, 'POST', json.encode({avatar_url = "https://i.imgur.com/HUgauWf.png",username = name,content = message}), { ['Content-Type'] = 'application/json' })
end
