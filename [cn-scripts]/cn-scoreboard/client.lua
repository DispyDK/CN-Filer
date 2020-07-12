vRPsb = Proxy.getInterface("vrp_extended")

local servernumber = 0
local menu = false
local users = {}
local font = 6

function DrawText3D(text,x,y,scale,r,g,b,a)
    SetTextFont(font)
    SetTextProportional(6)
    SetTextScale(scale/1.2, scale/1.2)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x , y)
end

local spawned = true
AddEventHandler("playerSpawned",function() -- delay state recording
    spawned = true
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if spawned then
            if servernumber == 0 then servernumber = vRPsb.getServerNumber() end
            if IsControlPressed(0, 344) then

                if menu == false then
                    users = vRPsb.getAmountOnline({"all"})
                    menu = true
                end
                if users.ems ~= nil then
                    DrawText3D("CiviliansNetwork Server #"..servernumber,0.5,0.17,1,255,255,255,255)
                    DrawText3D("EMS: "..users.ems,0.5,0.23,0.8,255,255,255,255)
                    DrawText3D("Taxi: "..users.taxa,0.5,0.27,0.8,255,255,255,255)
                    DrawText3D("Dommer: "..users.dommer,0.5,0.31,0.8,255,255,255,255)
                    DrawText3D("Advokat: "..users.advokat,0.5,0.35,0.8,255,255,255,255)
                    DrawText3D("Mekaniker: "..users.mechanic,0.5,0.39,0.8,255,255,255,255)
                    DrawText3D("Bilforhandler: "..users.bilforhandler,0.5,0.47,0.8,255,255,255,255)
                    DrawText3D("Ejendomsmægler: "..users.realestate,0.5,0.51,0.8,255,255,255,255)
                    local onlinetpos = 0.60
                    local height = 0.54
                    local y = 0.390
                    onlinetpos = 0.64
                        height = 0.59
                        y = 0.410
                    DrawText3D("Spillere online: "..users.online.."/128",0.5,onlinetpos,0.8,255,255,255,255)
                    DrawRect(0.5, y, 0.24,height,0,0,0,180)
                end
            else
                menu = false
            end
        end
    end
end)
