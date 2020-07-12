local htmlEntities = module("lib/htmlEntities")
local Tools = module("lib/Tools")
local lang = vRP.lang
local cfg = module("cfg/admin")

-- this module define some admin menu functions
local player_lists = {}

local function ch_list(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil and vRP.hasPermission(user_id,"player.list") then
        if player_lists[player] then -- hide
            player_lists[player] = nil
            vRPclient.removeDiv(player,{"user_list"})
        else -- show
            local content = ""
            local count = 0
            for k,v in pairs(vRP.rusers) do
                count = count+1
                local source = vRP.getUserSource(k)
                vRP.getUserIdentity(k, function(identity)
                    local job = vRP.getUserGroupByType(k,"job")
                    local checksub = vRP.getUserGroupByType(k,job)
                    if checksub ~= nil and checksub ~= "" then
                        job = checksub
                    end
                    if source ~= nil then
                        if identity then
                            -- content = content.."("..k..") <span class=\"pseudo\">"..vRP.getPlayerName(source).."</span> - <span class=\"name\">"..htmlEntities.encode(identity.firstname).." "..htmlEntities.encode(identity.name).."</span> CPR: <span class=\"reg\">"..identity.registration.."</span> JOB: <span class=\"phone\">"..job.."</span><br>"
                            content = content.."<div class=\"user\"> <div class=\"Name\">"..vRP.getPlayerName(source).." - "..htmlEntities.encode(identity.firstname).." "..htmlEntities.encode(identity.name).." - S: " .. source .. "</div> <span class=\"ident\">"..k.."</span> <span class=\"info\"> CPR: "..identity.registration.."</span> <span class=\"job\"> Job: "..job.."</span> </div>"
                        end
                    end

                    -- check end
                    count = count-1
                    if count == 0 then
                        player_lists[player] = true
                        local css = [[
				.div_user_list{
				 width: 1250px;
				 margin-top: 65px;
				 height: auto;
				 position: relative;
				 left: 50%;
				 transform: translateX(-50%);
				}

				.div_user_list .user{
				    margin-top: 5px;
				    font-weight: bold;
					font-size: 11px;
					font-family: arial;
				  color: #fff;
				  display: inline-block;
				  width: 19%;
				  height: 30px;
				  background: #1c1c1c;
				}

				.div_user_list .ident{
				      color: #00ff00;
				    margin-left: 5px;
				    margin-bottom: 3px;
				   display: inline-block;
				}

				.div_user_list .job{
				      color: #cc00ff;
  					display: inline-block;
				}

				.div_user_list .info{
				    color: #0066ff;
  					display: inline-block;
				}

				.div_user_list .Name{
				    margin-left: 5px;
					margin-top: 2px;
				}
            ]]
                        vRPclient.setDiv(player,{"user_list", css, content})
                    end
                end)
            end
        end
    end
end

local function ch_addgroup(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil and vRP.hasPermission(user_id,"player.group.add") then
        vRP.prompt(player,"Spiller ID: ","",function(player,id)
            id = parseInt(id)
            local checkid = vRP.getUserSource(tonumber(id))
            if checkid ~= nil then
                vRP.prompt(player,"Job: ","",function(player,group)
                    if group == " " or group == "" or group == null or group == 0 or group == nil then
                        TriggerClientEvent("pNotify:SendNotification",player,{text = "Du angav ikke et job.", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        if group == "ledelse" then
                            TriggerClientEvent("pNotify:SendNotification", player,{text = "Du har ikke rettigheder til at tildele rangen "..group, type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                        else
                            vRP.addUserGroup(id,group)
                            TriggerClientEvent("pNotify:SendNotification", player,{text = id.." blev ansat som "..group, type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                        end
                    end
                end)
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = "ID "..id.." er ugyldigt eller ikke online.", type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
    end
end

local function ch_removegroup(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil and vRP.hasPermission(user_id,"player.group.remove") then
        vRP.prompt(player,"Spiller ID: ","",function(player,id)
            id = parseInt(id)
            local checkid = vRP.getUserSource(tonumber(id))
            if checkid ~= nil then
                vRP.prompt(player,"Job: ","",function(player,group)
                    if group == " " or group == "" or group == null or group == 0 or group == nil then
                        TriggerClientEvent("pNotify:SendNotification",player,{text = "Du angav ikke et job.", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        if group == "ledelse" then
                            TriggerClientEvent("pNotify:SendNotification", player,{text = "Du har ikke rettigheder til at fyre rangen "..group, type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                        else
                            vRP.removeUserGroup(id,group)

                            TriggerClientEvent("pNotify:SendNotification", player,{text = id.." blev fyret som "..group, type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                        end
                    end
                end)
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = "ID "..id.." er ugyldigt eller ikke online.", type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
    end
end

local function ch_addgroup_staff(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil and vRP.hasPermission(user_id,"player.group.add.staff") then
        vRP.prompt(player,"Spiller ID: ","",function(player,id)
            id = parseInt(id)
            local checkid = vRP.getUserSource(tonumber(id))
            if checkid ~= nil then
                vRP.prompt(player,"Job: ","",function(player,group)
                    if group == " " or group == "" or group == null or group == 0 or group == nil then
                        TriggerClientEvent("pNotify:SendNotification",player,{text = "Du angav ikke et job/rang.", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        vRP.addUserGroup(id,group)

                        local dname = "Server "..GetConvar("servernumber", "0") .."- Addgroup"
                        local dmessage = "**".. tostring(user_id).. "** tilføjede gruppe **[ ".. tostring(group).. " ]** til **" .. tostring(id).. "**"
                        PerformHttpRequest('https://autisthook.com/api/webhooks/597823625902424075/PIqFpLCjJSf98YF4gEhMfKLc6UYh77Jo2osCFyl0TQ4HsQoZw3U9nW3C0rSyq6U5_kBV', function(err, text, headers) end, 'POST', json.encode({username = dname, content = dmessage}), { ['Content-Type'] = 'application/json' })

                        TriggerClientEvent("pNotify:SendNotification", player,{text = id.." blev ansat som "..group, type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    end
                end)
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = "ID "..id.." er ugyldigt eller ikke online.", type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
    end
end

local function ch_removegroup_staff(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil and vRP.hasPermission(user_id,"player.group.remove.staff") then
        vRP.prompt(player,"Spiller ID: ","",function(player,id)
            id = parseInt(id)
            local checkid = vRP.getUserSource(tonumber(id))
            if checkid ~= nil then
                vRP.prompt(player,"Job: ","",function(player,group)
                    if group == " " or group == "" or group == null or group == 0 or group == nil then
                        TriggerClientEvent("pNotify:SendNotification",player,{text = "Du angav ikke et job/rang.", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        vRP.removeUserGroup(id,group)

                        local dname = "Server "..GetConvar("servernumber", "0") .." Removegroup"
                        local dmessage = "**".. tostring(user_id).. "** fjernet gruppe **[ ".. tostring(group).. " ]** fra **" .. tostring(id).. "**"
                        PerformHttpRequest('https://autisthook.com/api/webhooks/597823625902424075/PIqFpLCjJSf98YF4gEhMfKLc6UYh77Jo2osCFyl0TQ4HsQoZw3U9nW3C0rSyq6U5_kBV', function(err, text, headers) end, 'POST', json.encode({username = dname, content = dmessage}), { ['Content-Type'] = 'application/json' })

                        TriggerClientEvent("pNotify:SendNotification", player,{text = id.." blev fyret som "..group, type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    end
                end)
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = "ID "..id.." er ugyldigt eller ikke online.", type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
    end
end

local function ch_seize(player,choice)
    local user_id = vRP.getUserId(player)
    local seized_items = {}
    if user_id ~= nil then
        vRPclient.getNearestPlayer(player, {5}, function(nplayer)
            local nuser_id = vRP.getUserId(nplayer)
            if nuser_id ~= nil and vRP.hasPermission(nuser_id, "staff.seizable") then
                vRP.getUserIdentity(user_id, function(identity_cop)
                    vRP.getUserIdentity(nuser_id, function(identity_civ)
                        if identity_cop and identity_civ then
                            local cop_name = identity_cop.firstname
                            local cop_lname = identity_cop.name
                            local civ_name = identity_civ.firstname
                            local civ_lname = identity_civ.name
                            table.insert(seized_items, "**"..cop_name.." "..cop_lname.." ("..user_id..")** beslaglagde følgende genstande fra **"..civ_name.." "..civ_lname.." ("..nuser_id..")**: \n")
                            for k,v in pairs(cfg.removeable_items) do -- transfer seizable items
                                local amount = vRP.getInventoryItemAmount(nuser_id,v)
                                if amount > 0 then
                                    local item = vRP.items[v]
                                    if item then -- do transfer
                                        if vRP.tryGetInventoryItem(nuser_id,v,amount,true) then
                                            table.insert(seized_items, "- "..amount.."x "..vRP.getItemName(v).."\n")
                                            TriggerClientEvent("pNotify:SendNotification", player,{text = {lang.police.menu.seize.seized({item.name,amount})}, type = "info", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                        end
                                    end
                                end
                            end
                            PerformHttpRequest('https://autisthook.com/api/webhooks/537782921293987890/bVI8rOhjwTPLokT2nLOly2ezyQXNRuxoXJ6VC1b84LOzvnSfSV2NCJr0JsgE_kIMz_Y6', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0").." - Seize", content = table.concat(seized_items)}), { ['Content-Type'] = 'application/json' })
                            TriggerClientEvent("pNotify:SendNotification", nplayer,{text = {lang.police.menu.seize.items.seized()}, type = "info", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                        end
                    end)
                end)
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = "Ingen spiller i nærheden", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
    end
end

local function ch_kick(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil and vRP.hasPermission(user_id,"player.kick") then
        vRP.prompt(player,"Spiller ID: ","",function(player,id)
            id = parseInt(id)
            vRP.prompt(player,"Årsag: ","",function(player,reason)
                local source = vRP.getUserSource(id)
                if source ~= nil then
                    vRP.kick(source,reason)

                    local dname = "Server "..GetConvar("servernumber", "0").." - Kick"
                    local dmessage = "**".. tostring(user_id).. "** kickede **".. tostring(id).. "** - Begrundelse: **" .. tostring(reason).. "**"
                    PerformHttpRequest('https://autisthook.com/api/webhooks/597823897798311956/ka8BaqhbkFcbNu1rmgFEsCB7Eo8KF5QJZiWm4UywhJ2WGi-fr97voCN9JVNF51lrOF3A', function(err, text, headers) end, 'POST', json.encode({username = dname, content = dmessage}), { ['Content-Type'] = 'application/json' })

                    TriggerClientEvent("pNotify:SendNotification", player,{text = "Du kickede "..id, type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                end
            end)
        end)
    end
end

local function ch_ban(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil and vRP.hasPermission(user_id,"player.ban") then
        vRP.prompt(player,"Spiller ID: ","",function(player,id)
            id = parseInt(id)
            vRP.prompt(player,"Årsag: ","",function(player,reason)
                local dname = "Server "..GetConvar("servernumber", "0").." - Ban"
                local dmessage = "**".. tostring(user_id).. "** bannede **".. tostring(id).. "** - Begrundelse: **" .. tostring(reason).. "**"
                PerformHttpRequest('https://autisthook.com/api/webhooks/597823897798311956/ka8BaqhbkFcbNu1rmgFEsCB7Eo8KF5QJZiWm4UywhJ2WGi-fr97voCN9JVNF51lrOF3A', function(err, text, headers) end, 'POST', json.encode({username = dname, content = dmessage}), { ['Content-Type'] = 'application/json' })
                vRP.ban(id,reason,true)
                TriggerClientEvent("pNotify:SendNotification", player,{text = "Du bannede "..id, type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end)
        end)
    end
end

local function ch_unban(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil and vRP.hasPermission(user_id,"player.unban") then
        vRP.prompt(player,"Spiller ID: ","",function(player,id)
            id = parseInt(id)
            vRP.prompt(player,"Årsag: ","Unban: ",function(player,reason)
                local dname = "Server "..GetConvar("servernumber", "0").." - Unban"
                local dmessage = "**".. tostring(user_id).. "** unbannede **".. tostring(id).. "** - Begrundelse: **" .. tostring(reason).. "**"
                PerformHttpRequest('https://autisthook.com/api/webhooks/597823897798311956/ka8BaqhbkFcbNu1rmgFEsCB7Eo8KF5QJZiWm4UywhJ2WGi-fr97voCN9JVNF51lrOF3A', function(err, text, headers) end, 'POST', json.encode({username = dname, content = dmessage}), { ['Content-Type'] = 'application/json' })

                vRP.unban(id,reason)
                TriggerClientEvent("pNotify:SendNotification", player,{text = "Du unbannede "..id, type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end)
        end)
    end
end

local function ch_revivePlayer(player,choice)
    local nuser_id = vRP.getUserId(player)
    vRP.prompt(player,"Spiller ID:","",function(player,user_id)
        local deadplayer = vRP.getUserSource(tonumber(user_id))
        if deadplayer == nil then
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Ugyldigt eller manglende ID", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Du genoplivede spilleren med ID "..user_id, type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            vRPclient.varyHealth(deadplayer, {100})
            vRP.setHunger(tonumber(user_id), 0)
            vRP.setThirst(tonumber(user_id), 0)
            local dname = "Server "..GetConvar("servernumber", "0").." - Revive"
            local dmessage = "**".. tostring(nuser_id).. "** genoplivet **".. tostring(user_id).. "** (**"..os.date("%H:%M:%S %d/%m/%Y").."**)"
            PerformHttpRequest('https://autisthook.com/api/webhooks/597824073376202772/5Hkqp57z29dMID6_qvdW9CYpSXV6TcZJ5bAf-l9qv1DyE4GagDcJ2gl8F45BG35V2INN', function(err, text, headers) end, 'POST', json.encode({username = dname, content = dmessage}), { ['Content-Type'] = 'application/json' })

        end
    end)
end

local function ch_changeplate(player,choice)
    vRPclient.changeNummerPlate(player,{5})
end

local function ch_repairVehicle(player,choice)
    vRPclient.fixeNearestVehicleAdmin(player,{3})
end

local function ch_coords(player,choice)
    vRPclient.getPosition(player,{},function(x,y,z)
        vRP.prompt(player,"Kopier koordinaterne med CTRL-A CTRL-C",x..","..y..","..z,function(player,choice) end)
    end)
end

local function ch_coordsh(player,choice)
    vRPclient.getPosition(player,{},function(x,y,z)
        vRPclient.getHeading(player,{},function(h)
            vRP.prompt(player,"Kopier koordinaterne med CTRL-A CTRL-C",x..","..y..","..z..","..h,function(player,choice) end)
        end)
    end)
end

local function ch_tptome(player,choice)
    vRPclient.getPosition(player,{},function(x,y,z)
        vRP.prompt(player,"Spiller ID:","",function(player,user_id)
            local tplayer = vRP.getUserSource(tonumber(user_id))
            if tplayer ~= nil then
                vRPclient.teleport(tplayer,{x,y,z})
            end
        end)
    end)
end

local function ch_tpto(player,choice)
    vRP.prompt(player,"Spiller ID:","",function(player,user_id)
        local tplayer = vRP.getUserSource(tonumber(user_id))
        if tplayer ~= nil then
            vRPclient.getPosition(tplayer,{},function(x,y,z)
                vRPclient.teleport(player,{x,y,z})
            end)
        end
    end)
end

local function ch_tptocoords(player,choice)
    vRP.prompt(player,"Koordinater x,y,z:","",function(player,fcoords)
        local coords = {}
        for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
            table.insert(coords,tonumber(coord))
        end

        local x,y,z = 0,0,0
        if coords[1] ~= nil then x = coords[1] end
        if coords[2] ~= nil then y = coords[2] end
        if coords[3] ~= nil then z = coords[3] end

        if x == 0 and y == 0 and z == 0 then
            TriggerClientEvent("pNotify:SendNotification",player,{text = "Ugyldige koordinater.", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        else
            vRPclient.teleport(player,{x,y,z})
        end
    end)
end

-- teleport waypoint
local function ch_tptowaypoint(player,choice)
    TriggerClientEvent("TpToWaypoint", player)
end

local function ch_givemoney(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        vRP.getUserIdentity(user_id, function(identity)
            if identity then
                local steamname = GetPlayerName(player)
                vRP.prompt(player,"Beløb:","",function(player,amount)
                    vRP.prompt(player,"Formål ved spawn af penge:","",function(player,reason)
                        if reason == " " or reason == "" or reason == null or reason == 0 or reason == nil then
                            reason = "Ingen kommentar..."
                        end
                        amount = parseInt(amount)
                        if amount == " " or amount == "" or amount == null or amount == 0 or amount == nil then
                            TriggerClientEvent("pNotify:SendNotification",player,{text = "Ugyldigt pengebeløb.", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                        else
                            vRP.giveMoney(user_id, amount)
                            TriggerClientEvent("pNotify:SendNotification", player,{text = "Du spawnede " ..amount.. "DKK", type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})



                            PerformHttpRequest('https://autisthook.com/api/webhooks/597824185875562496/mbYJUlwZ-g5BYSuFxYFY6nnQVwXH3zzJhAKie70cD-BJ_EZd9r6MkqmI6KWw-93lBL4Z', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0") .." - "..steamname, content = "**ID: "..user_id.." ("..identity.firstname.." "..identity.name..")** spawnede **"..amount.." DKK** - Kommentar: *"..reason.."*"}), { ['Content-Type'] = 'application/json' })
                        end
                    end)
                end)
            end
        end)
    end
end

local function ch_giveitem(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        vRP.getUserIdentity(user_id, function(identity)
            if identity then
                local steamname = GetPlayerName(player)
                vRP.prompt(player,"Tingens ID:","",function(player,idname)
                    idname = idname
                    if idname == " " or idname == "" or idname == null or idname == nil then
                        TriggerClientEvent("pNotify:SendNotification",player,{text = "Ugyldigt ID.", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    else
                        vRP.prompt(player,"Antal:","",function(player,amount)
                            vRP.prompt(player,"Formål ved spawn af ting:","",function(player,reason)
                                if reason == " " or reason == "" or reason == null or reason == 0 or reason == nil then
                                    reason = "Ingen kommentar..."
                                end
                                if amount == " " or amount == "" or amount == null or amount == nil then
                                    TriggerClientEvent("pNotify:SendNotification",player,{text = "Ugyldigt antal.", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                else
                                    amount = parseInt(amount)
                                    vRP.giveInventoryItem(user_id, idname, amount,true)



                                    PerformHttpRequest('https://autisthook.com/api/webhooks/597824185875562496/mbYJUlwZ-g5BYSuFxYFY6nnQVwXH3zzJhAKie70cD-BJ_EZd9r6MkqmI6KWw-93lBL4Z', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0") .." - "..steamname, content = "**ID: "..user_id.." ("..identity.firstname.." "..identity.name..")** spawnede **"..amount.." stk. "..idname.."** - Kommentar: *"..reason.."*"}), { ['Content-Type'] = 'application/json' })
                                end
                            end)
                        end)
                    end
                end)
            end
        end)
    end
end

local function ch_calladmin(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        vRP.prompt(player,"Beskriv dit problem:","",function(player,desc)
            desc = desc

            local answered = false
            local players = {}
            for k,v in pairs(vRP.rusers) do
                local player = vRP.getUserSource(tonumber(k))
                -- check user
                if vRP.hasPermission(k,"admin.tickets") and player ~= nil then
                    table.insert(players,player)
                end
            end

            -- send notify and alert to all listening players
            if desc == " " or desc == "" or desc == null then
                TriggerClientEvent("pNotify:SendNotification",player,{text = "Din admin-sag blev ikke sendt.", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            else
                for k,v in pairs(players) do
                    vRP.request(v,"Admin report fra "..user_id.." - Tager du den?: "..htmlEntities.encode(desc), 60, function(v,ok)
                        if ok then -- take the call
                            local take = vRP.getUserId(v)
                            vRP.getUserIdentity(take, function(identity)
                                local name = identity.firstname.." "..identity.name
                                TriggerEvent('cn_notify:notifyStaff', name)
                            end)
                            TriggerClientEvent("pNotify:SendNotification",player,{text = "Din sag blev taget", type = "success", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                            vRPclient.getPosition(player, {}, function(x,y,z)
                                vRPclient.teleport(v,{x,y,z})
                            end)
                        end
                    end)
                end
            end
        end)
    end
end

-- local function choice_carprice(player, choice)
--     local user_id = vRP.getUserId(player)
--     if user_id ~= nil then
--         vRP.prompt(player,"Spawnnavne på bilen du vil have pris på:","",function(player,spawn)
--             local prices = vRP.getCarPrices()
--             local veh = prices[spawn]
--             if veh ~= nil then
--                 MySQL.Async.fetchAll("INSERT INTO _log_items_transaction(user_id_from, user_id_to, item, amount, action) VALUES (@user_id_from, @user_id_to, @item, @amount, @action)", {vehicle = spawn}, function(rows, affected)
--                     if #rows > 0 then
--                         for k,v in pairs(rows) do
--                             local stock = v.stock
--                 TriggerClientEvent("pNotify:SendNotification", player,{text = {"<b style='color: #4E9350'>"..spawn:gsub("^%l", string.upper).."</b> nypris: <b style='color: #4E9350'>"..format_thousands(tonumber(veh.price)).." DKK</b> - <b>Stock:</b> "..stock.." "}, type = "error", queue = "global", timeout = 5000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
--             end
--         end
--     end)
--             end
--         end)
--     end
-- end

local function choice_carprice(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        vRP.prompt(player,"Spawnnavne på bilen du vil have pris på:","",function(player,spawn)
            local prices = vRP.getCarPrices()
            local veh = prices[spawn]
            if veh ~= nil then
                MySQL.Async.fetchAll("SELECT stock FROM bilforhandler WHERE vehicle = @vehicle", {vehicle = spawn}, function(rows, affected)
                    if #rows > 0 then
                        for k,v in pairs(rows) do
                            local stock = v.stock
                TriggerClientEvent("pNotify:SendNotification", player,{text = {"<b style='color: #4E9350'>"..spawn:gsub("^%l", string.upper).."</b> nypris: <b style='color: #4E9350'>"..format_thousands(tonumber(veh.price)).." DKK</b> - <b>Stock:</b> "..stock.." "}, type = "error", queue = "global", timeout = 5000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end
    end)
            end
        end)
    end
end


local function choice_bilforhandler(player, choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        local usrList = ""
        vRPclient.getNearestPlayers(player,{5},function(nplayer)
            for k,v in pairs(nplayer) do
                usrList = usrList .. " | " .. "[" .. vRP.getUserId(k) .. "]" .. GetPlayerName(k)
            end
            if usrList ~= "" then
                vRP.prompt(player,"Nærmeste spiller(e): " .. usrList .. "","",function(player,nuser_id)
                    if nuser_id ~= nil and nuser_id ~= "" then
                        local target = vRP.getUserSource(tonumber(nuser_id))
                        if target ~= nil then
                            vRP.prompt(player,"Skriv spawnnavn på bilen du vil sælge:","",function(player,spawn)
                                local prices = vRP.getCarPrices()
                                local veh = prices[spawn]

                                MySQL.Async.fetchAll("SELECT stock FROM bilforhandler WHERE vehicle = @vehicle", {vehicle = spawn}, function(rows, affected)
                                    if #rows > 0 then
                                        for k,v in pairs(rows) do
                                            local stock = v.stock

                                if veh ~= nil and stock > 0 then
                                    vRP.prompt(player,"Antal procent?","0",function(player,procent)
                                        procent = parseInt(tonumber(procent))
                                        if procent >= 0 and procent <= 10 then
                                            local price = veh.price
                                            if procent > 0 then
                                                local rabat = price/100*procent
                                                price = price-rabat
                                            end
                                            price = parseInt(price)
                                            if price > 0 then
                                                vRP.prompt(player,"Bekræft: "..spawn.." sælges til "..nuser_id.." for "..format_thousands(tonumber(price)),"",function(player,bool)
                                                    if string.lower(bool) == "bekræft" then
                                                        MySQL.Async.execute("UPDATE bilforhandler SET stock = stock - 1 WHERE vehicle = @vehicle", {vehicle = spawn})
                                                        MySQL.Async.fetchAll("SELECT vehicle FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle", {user_id = nuser_id, vehicle = spawn}, function(rows, affected)
                                                            if #rows > 0 then -- has vehicle
                                                                TriggerClientEvent("pNotify:SendNotification", player,{text = {"<b style='color: #DB4646'>"..nuser_id.."</b> har allerede en <b style='color: #DB4646'>"..spawn.."</b>"}, type = "error", queue = "global", timeout = 2000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                                            else
                                                                if vRP.tryFullPayment(tonumber(nuser_id),tonumber(price)) then
                                                                    vRP.getUserIdentity(tonumber(nuser_id), function(identity)
                                                                        local pp = math.floor(tonumber(price)/100*5)
                                                                        vRP.giveBankMoney(user_id,tonumber(pp))
                                                                        MySQL.Async.fetchAll("INSERT IGNORE INTO vrp_user_vehicles(user_id,vehicle,vehicle_plate,veh_type,vehicle_name) VALUES(@user_id,@vehicle,@vehicle_plate,@veh_type,@vehicle_name)", {user_id = tonumber(nuser_id), vehicle = spawn, vehicle_plate = "P "..identity.registration, veh_type = veh.type, vehicle_name = veh.name})
                                                                        TriggerClientEvent("pNotify:SendNotification", player,{text = {identity.firstname.." "..identity.name.." har modtaget "..spawn.." for "..format_thousands(tonumber(price)).." DKK<br>Du modtog <b style='color: #4E9350'>"..format_thousands(tonumber(pp)).."</b> for handlen!"}, type = "success", queue = "global", timeout = 4000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                                                    end)
                                                                    local message = "**"..user_id.."** solgte en **"..spawn.."** til **"..nuser_id.."** for **"..format_thousands(tonumber(price)).." DKK** med en rabat på **"..procent.." procent"
                                                                    PerformHttpRequest('https://autisthook.com/api/webhooks/597824398086504454/Vttejm_BoQ0N_sJx9ntAlh2OzRdGIigQPYfJ3t3f58nucEUvfG4MrKZbP46X-Bp6U6GF', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0") .." - Bilforhandler", content = message}), { ['Content-Type'] = 'application/json' })
                                                                    TriggerClientEvent("pNotify:SendNotification", target,{text = {"Tillykke med din <b style='color: #4E9350'>"..spawn.."</b>!"}, type = "warning", queue = "global", timeout = 4000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                                                else
                                                                    TriggerClientEvent("pNotify:SendNotification", player,{text = {"Personen har ikke nok penge"}, type = "warning", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                                                end
                                                            end
                                                        end)
                                                    else
                                                        TriggerClientEvent("pNotify:SendNotification", player,{text = {"Du har annulleret"}, type = "warning", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                                    end
                                                end)

                                            else
                                                TriggerClientEvent("pNotify:SendNotification", player,{text = {"Beløbet skal være over 0!"}, type = "warning", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                            end
                                        else
                                            TriggerClientEvent("pNotify:SendNotification", player,{text = {"Du kan ikke give højere end 10%"}, type = "warning", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                        end
                                    end)
                                else
                                    TriggerClientEvent("pNotify:SendNotification", player,{text = {"Kunne ikke finde "..spawn.." kontakt admin, hvis det en fejl."}, type = "warning", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                                end
                            end
                        end
                    end)

                end)
                        else
                            TriggerClientEvent("pNotify:SendNotification", player,{text = {"Dette ID ser ud til ikke at eksistere"}, type = "warning", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                        end
                    else
                        TriggerClientEvent("pNotify:SendNotification", player,{text = {"Intet ID valgt"}, type = "warning", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                    end
                end)
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = {"Ingen spiller i nærheden"}, type = "warning", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end)
    end
end

function format_thousands(v)
    local s = string.format("%d", math.floor(v))
    local pos = string.len(s) % 3
    if pos == 0 then pos = 3 end
    return string.sub(s, 1, pos)
            .. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end

local player_customs = {}

local function ch_display_custom(player, choice)
    vRPclient.getCustomization(player,{},function(custom)
        if player_customs[player] then -- hide
            player_customs[player] = nil
            vRPclient.removeDiv(player,{"customization"})
        else -- show
            local content = ""
            for k,v in pairs(custom) do
                content = content..k.." => "..json.encode(v).."<br />"
            end

            player_customs[player] = true
            vRPclient.setDiv(player,{"customization",".div_customization{ margin: auto; padding: 8px; width: 500px; margin-top: 80px; background: black; color: white; font-weight: bold; ", content})
        end
    end)
end

local function ch_noclip(player, choice)
    local user_id = vRP.getUserId(player)
    vRPclient.toggleNoclip(player,{},function(data)
        local server = tonumber(GetConvar("servernumber", "0"))
        if server < 5 then
            local msg = ""
            local coords = data.coords[1]..","..data.coords[2]..","..data.coords[3]
            if data.noclip then
                msg = "startet noclip her: `"..coords.."`"
            else
                msg = "stoppet noclip her: `"..coords.."`"
            end
            local message = "**"..user_id.."** "..msg.." (**"..os.date("%H:%M:%S %d/%m/%Y").."**)"
            sendToDiscord2("https://autisthook.com/api/webhooks/597824491380408330/E_hqu2e83a0-dAD8nIMWxB98bJOsUb7c7fTKigDQ2s5EPX7V5RkIV-Mr5cKUyzaCzCxM","Server "..server.." - Noclip",message)
        end
    end)
end

local function ch_spectate(player, choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil and vRP.hasPermission(user_id,"player.spec") then
		vRP.prompt(player,"Skriv ID du vil spectate!","",function(player,pid)
			if pid ~= nil then
				local id = tonumber(pid)
				if id == 0 then
                    TriggerClientEvent("pNotify:SendNotification", player,{text = {"Stopper med at spectate"}, type = "warning", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
					vRPclient.stopSpec(player, {})
				elseif id == user_id then
                    TriggerClientEvent("pNotify:SendNotification", player,{text = {"Ugyldigt spiller ID"}, type = "warning", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
				else
					local nplayer = vRP.getUserSource(id)
					if nplayer ~= nil then
                        TriggerClientEvent("pNotify:SendNotification", player,{text = {"Du spectater nu ID: "..id}, type = "warning", queue = "global", timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
						vRPclient.toggleSpec(player, {nplayer})
                        local message = "ID: **"..user_id.."** spectater  ID: **"..id.. "**"
                        PerformHttpRequest('https://autisthook.com/api/webhooks/597824491380408330/E_hqu2e83a0-dAD8nIMWxB98bJOsUb7c7fTKigDQ2s5EPX7V5RkIV-Mr5cKUyzaCzCxM', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0") .." - Spectate", content = message}), { ['Content-Type'] = 'application/json' })
					end
				end
			end
		end)
	end
end



local function ch_freezeplayer(player, choice)
    local user_id = vRP.getUserId(player)
    vRP.prompt(player,"Spiller ID:","",function(player,user_id)
        local frozenplayer = vRP.getUserSource(tonumber(user_id))
        if frozenplayer == nil then
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Ugyldigt eller manglende ID", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = "Du frøs/optøede spilleren med ID "..user_id, type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            vRPclient.toggleFreeze(frozenplayer, {})
        end
    end)
end

local function ch_spawnvehicle(player, choice)
    vRP.prompt(player,"Bilen's modelnavn f.eks. police3:","",function(player,veh)
        if veh ~= "" then
            TriggerClientEvent("hp:spawnvehicle",player,veh)
        end
    end)
end

local function ch_deletevehicle(player, choice)
    TriggerClientEvent("hp:deletevehicle", player)
end

local function ch_unlockvehicle(player, choice)
    vRPclient.vehicleUnlockAdmin(player)
end

local function ch_addadvokatjob(player, choice)
    addjob(player,"Advokat-Job")
end
local function ch_removeadvokatjob(player, choice)
    removejob(player,"Advokat-Job")
end
local function ch_adddommerjob(player, choice)
    addjob(player,"Dommer-Job")
end
local function ch_removedommerjob(player, choice)
    removejob(player,"Dommer-Job")
end
local function ch_addmekanikerjob(player, choice)
    addjob(player,"Mekaniker-Job")
end
local function ch_removemekanikerjob(player, choice)
    removejob(player,"Mekaniker-Job")
end
local function ch_addtaggingjob(player, choice)
    addjob(player,"Tagging")
end
local function ch_removetaggingjob(player, choice)
    removejob(player,"Tagging")
end
local function ch_addbilforhandlerjob(player, choice)
    addjob(player,"Bilforhandler-Job")
end
local function ch_removebilforhandlerjob(player, choice)
    removejob(player,"Bilforhandler-Job")
end
local function ch_addjournalistjob(player, choice)
    addjob(player,"Journalist-Job")
end
local function ch_removejournalistjob(player, choice)
    removejob(player,"Journalist-Job")
end
local function ch_addpsykologjob(player, choice)
    addjob(player,"Psykolog-Job")
end
local function ch_removepsykologjob(player, choice)
    removejob(player,"Psykolog-Job")
end
local function ch_addrealestatejob(player, choice)
    addjob(player,"Ejendomsmægler-Job")
end
local function ch_removerealestatejob(player, choice)
    removejob(player,"Ejendomsmægler-Job")
end
local function ch_addsikkerhedsvagtjob(player, choice)
    addjob(player,"Sikkerhedsvagt-Job")
end
local function ch_removesikkerhedsvagtjob(player, choice)
    removejob(player,"Sikkerhedsvagt-Job")
end

local function ch_addemsjob(player, choice)
    addjob(player,"EMS-Job")
end
local function ch_removeemsjob(player, choice)
    removejob(player,"EMS-Job")
end

local function ch_addcopjob(player, choice)
    addjob(player,"Politi-Job")
end
local function ch_removecopjob(player, choice)
    removejob(player,"Politi-Job")
end
local function ch_addpolitiadvokatjob(player, choice)
    addjob(player,"Politiadvokat-Job")
end
local function ch_removepolitiadvokatjob(player, choice)
    removejob(player,"Politiadvokat-Job")
end
local function ch_addgumphermarketjob(player, choice)
    addjob(player,"Gumphermarket-Job")
end
local function ch_removegumphermarketjob(player, choice)
    removejob(player,"Gumphermarket-Job")
end
local function ch_addcasinojob(player, choice)
    addjob(player,"Casino-Job")
end
local function ch_removecasinojob(player, choice)
    removejob(player,"Casino-Job")
end
local function ch_addkoerelaererjob(player, choice)
    addjob(player,"Kørelærer-Job")
end
local function ch_removekoerelaererjob(player, choice)
    removejob(player,"Kørelærer-Job")
end

function addjob(player,group)
    local user_id = vRP.getUserId(player)
    vRP.prompt(player, "Skriv id du vil ansætte:", "", function(player,nuser_id)
        if tonumber(nuser_id) == tonumber(user_id) then
            TriggerClientEvent("pNotify:SendNotification", player,{text = {"Du kan ikke forfremme dig selv!"}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            return
        end
        local target = vRP.getUserSource(tonumber(nuser_id))
        if target ~= nil then
            local check = vRP.getUserGroupByType(tonumber(nuser_id),group)
            local rankup = vRP.getUserGroupRankup(group,check)
            if rankup then
                vRP.addUserGroup(tonumber(nuser_id),rankup[1])
                local word = ""
                local title = ""
                local dmessage = ""
                local dato = os.date("**%d-%m-%Y** kl. **%X**")
                if rankup[2] == 1 then
                    title = "Ansat"
                    word = "ansat som"
                    vRP.addUserGroup(tonumber(nuser_id),group)
                    dmessage = "**"..user_id.."** har lige ansat **"..nuser_id.."** som **"..rankup[1].."** ("..dato..")"
                else
                    title = "Forfremmet"
                    word = "forfremmet til"
                    dmessage = "**"..user_id.."** har lige forfremmet **"..nuser_id.."** til **"..rankup[1].."** ("..dato..")"
                end
                PerformHttpRequest('https://autisthook.com/api/webhooks/597823625902424075/PIqFpLCjJSf98YF4gEhMfKLc6UYh77Jo2osCFyl0TQ4HsQoZw3U9nW3C0rSyq6U5_kBV', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0").." - "..title, content = dmessage}), { ['Content-Type'] = 'application/json' })
                TriggerClientEvent("pNotify:SendNotification", player,{text = {nuser_id.." er blevet "..word.." <b style='color: #4E9350'>"..rankup[1].."</b>!"}, type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                TriggerClientEvent("pNotify:SendNotification", target,{text = {"Du er blevet "..word.." <b style='color: #4E9350'>"..rankup[1].."</b>!"}, type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = {nuser_id.." er allerede det højeste rank!"}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = {"Dette ID ser ud til ikke at eksistere"}, type = "warning", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end)
end

function removejob(player,group)
    local user_id = vRP.getUserId(player)
    vRP.prompt(player, "Skriv id du vil fyre:", "", function(player,nuser_id)
        nuser_id = tonumber(nuser_id)
        local target = vRP.getUserSource(nuser_id)
        if target ~= nil then
            local rank = vRP.getUserGroupByType(nuser_id,group)
            if rank ~= "" then
                vRP.removeUserGroup(nuser_id,rank)
                vRP.addUserGroup(nuser_id,"Arbejdsløs")
                local dato = os.date("**%d-%m-%Y** kl. **%X**")
                local dmessage = "**"..user_id.."** har lige fyret **"..nuser_id.."** fra **"..rank.."** ("..dato..")"
                PerformHttpRequest('https://autisthook.com/api/webhooks/597823625902424075/PIqFpLCjJSf98YF4gEhMfKLc6UYh77Jo2osCFyl0TQ4HsQoZw3U9nW3C0rSyq6U5_kBV', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0").." - Fyret", content = dmessage}), { ['Content-Type'] = 'application/json' })
                TriggerClientEvent("pNotify:SendNotification", player,{text = {nuser_id.." er blevet fyret som <b style='color: #DB4646'>"..rank.."</b>!"}, type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                TriggerClientEvent("pNotify:SendNotification", target,{text = {"Du er blevet fyret som <b style='color: #DB4646'>"..rank.."</b>!"}, type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = {nuser_id.." har ikke noget <b style='color: #DB4646'>"..group:gsub("-"," ").."</b>!"}, type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        else
            TriggerClientEvent("pNotify:SendNotification", player,{text = {"Dette ID ser ud til ikke at eksistere"}, type = "warning", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        end
    end)
end

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

vRP.registerMenuBuilder("main", function(add, data)
    local user_id = vRP.getUserId(data.player)
    if user_id ~= nil then
        local choices = {}

        -- build admin menu
        choices["Admin"] = {function(player,choice)

            local menu = {name="Admin menu",css={top="75px",header_color="rgba(225,160,0,0.75)"}}
            menu.onclose = function(player) vRP.openMainMenu(player) end -- nest menu

            if vRP.hasPermission(user_id,"sikkerhedsvagt.mangroup") then
                menu["ANSÆT/FORFREM"] = {ch_addsikkerhedsvagtjob,"Ansæt eller forfremme en ansat"}
                menu["FYR ANSAT"] = {ch_removesikkerhedsvagtjob,"Fyr en ansat"}
            end
            if vRP.hasPermission(user_id,"advokat.mangroup") then
                menu["ANSÆT/FORFREM"] = {ch_addadvokatjob,"Ansæt eller forfremme en ansat"}
                menu["FYR ANSAT"] = {ch_removeadvokatjob,"Fyr en ansat"}
            end
            if vRP.hasPermission(user_id,"dommer.mangroup") then
                menu["ANSÆT/FORFREM"] = {ch_adddommerjob,"Ansæt eller forfremme en ansat"}
                menu["FYR ANSAT"] = {ch_removedommerjob,"Fyr en ansat"}
            end
            if vRP.hasPermission(user_id,"politiadvokat.mangroup") then
                menu["ANSÆT/FORFREM"] = {ch_addpolitiadvokatjob,"Ansæt eller forfremme en ansat"}
                menu["FYR ANSAT"] = {ch_removepolitiadvokatjob,"Fyr en ansat"}
            end
            if vRP.hasPermission(user_id,"mekaniker.mangroup") then
                menu["ANSÆT/FORFREM"] = {ch_addmekanikerjob,"Ansæt eller forfremme en ansat"}
                menu["FYR ANSAT"] = {ch_removemekanikerjob,"Fyr en ansat"}
            end
            if vRP.hasPermission(user_id,"tagging.mangroup") then
                menu["TILFØJ FODLÆNKE"] = {ch_addtaggingjob,"Tilføj fodlænke"}
                menu["FJERN FODLÆNKE"] = {ch_removetaggingjob,"Fjern fodlænke"}
            end

            if vRP.hasPermission(user_id,"psykolog.mangroup") then
                menu["ANSÆT/FORFREM"] = {ch_addpsykologjob,"Ansæt eller forfremme en ansat"}
                menu["FYR ANSAT"] = {ch_removepsykologjob,"Fyr en ansat"}
            end

            if vRP.hasPermission(user_id,"journalist.mangroup") then
                menu["ANSÆT/FORFREM"] = {ch_addjournalistjob,"Ansæt eller forfremme en ansat"}
                menu["FYR ANSAT"] = {ch_removejournalistjob,"Fyr en ansat"}
            end

            if vRP.hasPermission(user_id,"realestate.mangroup") then
                menu["ANSÆT/FORFREM"] = {ch_addrealestatejob,"Ansæt eller forfremme en ansat"}
                menu["FYR ANSAT"] = {ch_removerealestatejob,"Fyr en ansat"}
            end

            if vRP.hasPermission(user_id,"politi.mangroup") then
                menu["ANSÆT/FORFREM BETJENT"] = {ch_addcopjob,"Ansæt eller forfremme en betjent"}
                menu["FYR BETJENT"] = {ch_removecopjob,"Fyr en betjent"}
            end
            if vRP.hasPermission(user_id,"ems.mangroup") then
                menu["ANSÆT/FORFREM EMS"] = {ch_addemsjob,"Ansæt eller forfremme en ems"}
                menu["FYR EMS"] = {ch_removeemsjob,"Fyr en ems"}
            end
			if vRP.hasPermission(user_id,"gumpher.mangroup") then
                menu["ANSÆT/FORFREM"] = {ch_addgumphermarketjob,"Ansæt eller forfremme en ansat"}
                menu["FYR ANSAT"] = {ch_removegumphermarketjob,"Fyr en ansat"}
            end
			if vRP.hasPermission(user_id,"casino.mangroup") then
                menu["ANSÆT/FORFREM"] = {ch_addcasinojob,"Ansæt eller forfremme en ansat"}
                menu["FYR ANSAT"] = {ch_removecasinojob,"Fyr en ansat"}
            end
			if vRP.hasPermission(user_id,"kørelærer.mangroup") then
                menu["ANSÆT/FORFREM"] = {ch_addkoerelaererjob,"Ansæt eller forfremme en ansat"}
                menu["FYR ANSAT"] = {ch_removekoerelaererjob,"Fyr en ansat"}
            end
			

            if vRP.hasPermission(user_id,"player.list") then
                menu["> Brugerliste"] = {ch_list,"Vis/Gem"}
            end
            if vRP.hasPermission(user_id,"player.group.add") then
                menu["Tilføj job"] = {ch_addgroup}
            end
            if vRP.hasPermission(user_id,"player.group.remove") then
                menu["Fjern job"] = {ch_removegroup}
            end
            if vRP.hasPermission(user_id,"player.group.add.staff") then
                menu["Tilføj job/rang"] = {ch_addgroup_staff}
            end
            if vRP.hasPermission(user_id,"player.group.remove.staff") then
                menu["Fjern job/rang"] = {ch_removegroup_staff}
            end
            if vRP.hasPermission(user_id,"player.kick") then
                menu["Kick"] = {ch_kick}
            end
            if vRP.hasPermission(user_id,"staff.seizable") then
                menu["Fjern items"] = {ch_seize}
            end
            if vRP.hasPermission(user_id,"player.ban") then
                menu["Ban"] = {ch_ban}
            end
            if vRP.hasPermission(user_id,"player.unban") then
                menu["Unban"] = {ch_unban}
            end
            if vRP.hasPermission(user_id,"player.freeze") then
                menu["Frys/optø spiller"] = {ch_freezeplayer}
            end
            if vRP.hasPermission(user_id,"admin.revive") then
                menu["Genopliv spiller"] = {ch_revivePlayer}
            end
            -- if vRP.hasPermission(user_id,"player.repairvehicle") then
            --     menu["Reparer køretøj"] = {ch_repairVehicle}
            -- end
            if vRP.hasPermission(user_id,"player.replaceplate") then
                menu["> Udskift nummerplade"] = {ch_changeplate}
            end
            if vRP.hasPermission(user_id,"player.spec") then
                menu["Spectate spiller"] = {ch_spectate}
              end
            if vRP.hasPermission(user_id,"player.noclip") then
                menu["Noclip"] = {ch_noclip}
            end
            if vRP.hasPermission(user_id,"player.spawnvehicle") then
                menu["Spawn køretøj"] = {ch_spawnvehicle}
            end
            if vRP.hasPermission(user_id,"player.deletevehicle") then
                menu["Fjern køretøj"] = {ch_deletevehicle}
            end
            if vRP.hasPermission(user_id,"player.unlockvehicle") then
                menu["Lås køretøj op"] = {ch_unlockvehicle}
            end
            if vRP.hasPermission(user_id,"player.coords") then
                menu["Koordinater"] = {ch_coords}
            end
            if vRP.hasPermission(user_id,"player.coords") then
                menu["Koordinater med H"] = {ch_coordsh}
            end
            if vRP.hasPermission(user_id,"player.tptome") then
                menu["TP person til mig"] = {ch_tptome}
            end
            if vRP.hasPermission(user_id,"player.tpto") then
                menu["TP til person"] = {ch_tpto}
            end
            if vRP.hasPermission(user_id,"player.tpto") then
                menu["TP til koordinater"] = {ch_tptocoords}
            end
            if vRP.hasPermission(user_id,"player.tptowaypoint") then
                menu["TP til waypoint"] = {ch_tptowaypoint} -- teleport user to map blip
            end
            if vRP.hasPermission(user_id,"player.givemoney") then
                menu["Spawn penge"] = {ch_givemoney}
            end
            if vRP.hasPermission(user_id,"player.giveitem") then
                menu["Spawn ting"] = {ch_giveitem}
            end
            -- if vRP.hasPermission(user_id,"player.calladmin") then
            --     menu["> Tilkald staff"] = {ch_calladmin}
            -- end

            vRP.openMenu(player,menu)
        end }

        if vRP.hasPermission(user_id,"admin.bilforhandler") then
            choices["Bilforhandler"] = {function(player,choice)
                local menu = {name="Bilforhandler",css={top="75px",header_color="rgba(225,160,0,0.75)"}}
                menu.onclose = function(player) vRP.openMainMenu(player) end -- nest menu

                if vRP.hasPermission(user_id,"bilforhandler.mangroup") then
                    menu["ANSÆT/FORFREM"] = {ch_addbilforhandlerjob,"Ansæt eller forfremme en ansat"}
                    menu["FYR ANSAT"] = {ch_removebilforhandlerjob,"Fyr en ansat"}
                end
                menu["Sælg bil"] = {choice_bilforhandler}
                menu["Tjek bil pris"] = {choice_carprice}
                --menu["Spawn køretøj"] = {ch_spawnvehicle}
                menu["Fjern køretøj"] = {ch_deletevehicle}
                menu["Tjek kørekort"] = choice_driverslicense

                vRP.openMenu(player,menu)
            end }
        end

        add(choices)
    end
end)

-- admin god mode
-- function task_god()
-- SetTimeout(10000, task_god)

-- for k,v in pairs(vRP.getUsersByPermission("admin.god")) do
-- vRP.setHunger(v, 0)
-- vRP.setThirst(v, 0)

-- local player = vRP.getUserSource(v)
-- if player ~= nil then
-- vRPclient.setHealth(player, {200})
-- end
-- end
-- end

-- task_god()

function sendToDiscord2(discord, name, message)
    if message == nil or message == '' or message:sub(1, 1) == '/' then return FALSE end
    PerformHttpRequest(discord, function(err, text, headers) end, 'POST', json.encode({avatar_url = "https://i.imgur.com/HUgauWf.png",username = name,content = message}), { ['Content-Type'] = 'application/json' })
end
