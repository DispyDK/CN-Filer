vRP = Proxy.getInterface("vRP")

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

RegisterCommand("briller", function(source, args, rawCommand)
    changeCloth("briller")
end)
RegisterCommand("maske", function(source, args, rawCommand)
    changeCloth("maske")
end)
RegisterCommand("hat", function(source, args, rawCommand)
    changeCloth("hat")
end)
RegisterCommand("jakke", function(source, args, rawCommand)
    changeCloth("jakke")
end)
RegisterCommand("vest", function(source, args, rawCommand)
    changeCloth("vest")
end)
RegisterCommand("tshirt", function(source, args, rawCommand)
    changeCloth("tshirt")
end)
RegisterCommand("bukser", function(source, args, rawCommand)
    changeCloth("bukser")
end)
RegisterCommand("slips", function(source, args, rawCommand)
    changeCloth("slips")
end)
RegisterCommand("sko", function(source, args, rawCommand)
    changeCloth("sko")
end)
RegisterCommand("taske", function(source, args, rawCommand)
    changeCloth("taske")
    print("hej")
end)


local cloths =  {
    ["maske"] = {
        status = false,
        comp = 1,
        offdict = "misscommon@std_take_off_masks",
        offanim = "take_off_mask_rps",
        ondict = "mp_masks@on_foot",
        onanim = "put_on_mask",
        start = 500,
        stop = 750
    },
    ["briller"] = {
        status = false,
        prop = 1,
        offdict = "clothingspecs",
        offanim = "try_glasses_positive_a",
        ondict = "clothingspecs",
        onanim = "try_glasses_positive_a",
        first = 0
    },
    ["hat"] = {
        status = false,
        prop = 0,
        offdict = "misscommon@std_take_off_masks",
        offanim = "take_off_mask_rps",
        ondict = "mp_masks@on_foot",
        onanim = "put_on_mask",
        first = -1,
        start = 500,
        stop = 750
    },
    ["jakke"] = {
        status = false,
        comp = 11,
        offdict = "clothingshirt",
        offanim = "try_shirt_negative_a",
        ondict = "clothingshirt",
        onanim = "try_shirt_positive_a",
        start = 2500,
        stop = 2500,
        savevar = {comp=3,text="arms"}
    },
    ["vest"] = {
        status = false,
        comp = 9,
        offdict = "clothingshirt",
        offanim = "try_shirt_negative_a",
        ondict = "clothingshirt",
        onanim = "try_shirt_positive_a",
        start = 2500,
        stop = 2500,
    },
    ["tshirt"] = {
        status = false,
        comp = 8,
        offdict = "clothingshirt",
        offanim = "try_shirt_negative_a",
        ondict = "clothingshirt",
        onanim = "try_shirt_positive_a",
        start = 2500,
        stop = 2500
    },
    ["bukser"] = {
        status = false,
        comp = 4,
        offdict = "clothingshoes",
        offanim = "try_shoes_positive_d",
        ondict = "clothingshoes",
        onanim = "try_shoes_positive_d",
        start = 2500,
        stop = 2500
    },
    ["slips"] = {
        status = false,
        comp = 7,
        offdict = "clothingtie",
        offanim = "try_tie_neutral_b",
        ondict = "clothingtie",
        onanim = "try_tie_neutral_b",
        start = 2500,
        stop = 2500
    },
    ["sko"] = {
        status = false,
        comp = 6,
        offdict = "clothingshoes",
        offanim = "try_shoes_positive_d",
        ondict = "clothingshoes",
        onanim = "try_shoes_positive_d",
        start = 2500,
        stop = 2500
    },
    ["taske"] = {
        status = false,
        comp = 5,
        offdict = "clothingshirt",
        offanim = "try_shirt_negative_a",
        ondict = "clothingshirt",
        onanim = "try_shirt_positive_a",
        start = 2500,
        stop = 2500
    },
}
function changeCloth(cloth)
    if not vRP.isHandcuffed() then
        local ped = GetPlayerPed(-1)
        if cloths[cloth].status == false or (cloths[cloth].prop ~= nil and GetPedPropIndex(ped,cloths[cloth].prop) ~= cloths[cloth].first and GetPedPropIndex(ped,cloths[cloth].prop) ~= -1) then
            loadAnimDict(cloths[cloth].offdict)
            if cloths[cloth].comp ~= nil then
                cloths[cloth].cloth = {
                    draw = GetPedDrawableVariation(ped, cloths[cloth].comp),
                    text = GetPedTextureVariation(ped, cloths[cloth].comp),
                    pal = GetPedPaletteVariation(ped, cloths[cloth].comp),
                }
                if cloths[cloth].savevar ~= nil then
                    cloths[cloths[cloth].savevar.text] = {
                        ["cloth"] = {
                            draw = GetPedDrawableVariation(ped, cloths[cloth].savevar.comp),
                            text = GetPedTextureVariation(ped, cloths[cloth].savevar.comp),
                        }
                    }
                end
            elseif cloths[cloth].prop ~= nil then
                cloths[cloth].cloth = {
                    draw = GetPedPropIndex(ped,cloths[cloth].prop),
                    text = GetPedPropTextureIndex(ped,cloths[cloth].prop),
                }
            end
            TaskPlayAnim(ped, cloths[cloth].offdict, cloths[cloth].offanim, 2.0, 2.0, -1, 49, 0, 0, 0, 0)
            if cloths[cloth].stop ~= nil then Citizen.Wait(cloths[cloth].stop) else Citizen.Wait(1000) end
            if cloths[cloth].comp ~= nil then
                local text = 0
                local draw = 0
                if cloth == "jakke" or cloth == "tshirt" or cloth == "slips" then
                    text = 271
                    draw = 52
                    SetPedComponentVariation(ped, 3, 15, 0, 0)
                elseif cloth == "bukser" then
                    if(GetEntityModel(ped) == GetHashKey("mp_f_freemode_01")) then
                        draw = 51
                    else
                        draw = 95
                    end
                elseif cloth == "sko" then
                    if(GetEntityModel(ped) == GetHashKey("mp_f_freemode_01")) then
                        draw = 69
                    else
                        draw = 68
                    end
                end
                SetPedComponentVariation(ped, cloths[cloth].comp, draw, text, 0)
            elseif cloths[cloth].prop ~= nil then
                ClearPedProp(ped,cloths[cloth].prop)
            end
            ClearPedTasks(ped)
            cloths[cloth].status = true
        else
            loadAnimDict(cloths[cloth].ondict)
            TaskPlayAnim(ped, cloths[cloth].ondict, cloths[cloth].onanim, 2.0, 2.0, -1, 49, 0, 0, 0, 0)
            if cloths[cloth].start ~= nil then Citizen.Wait(cloths[cloth].start) else Citizen.Wait(1000) end
            if cloths[cloth].comp ~= nil then
                SetPedComponentVariation(ped, cloths[cloth].comp, cloths[cloth].cloth.draw, cloths[cloth].cloth.text, cloths[cloth].cloth.pal)
            elseif cloths[cloth].prop ~= nil then
                SetPedPropIndex(ped,cloths[cloth].prop,cloths[cloth].cloth.draw, cloths[cloth].cloth.text, true)
            end
            if cloths[cloth].savevar ~= nil then
                SetPedComponentVariation(ped, cloths[cloth].savevar.comp, cloths[cloths[cloth].savevar.text].cloth.draw, cloths[cloths[cloth].savevar.text].cloth.text, 0)
            end
            ClearPedTasks(ped)
            cloths[cloth].status = false
        end
    end
end

RegisterCommand("gembriller", function(source, args, rawCommand)
    saveCloth("briller")
end)

RegisterCommand("brugbriller", function(source, args, rawCommand)
    useCloth("briller")
end)

function saveCloth(cloth)
    if not vRP.isHandcuffed() then
        local ped = GetPlayerPed(-1)
            if cloths[cloth].start ~= nil then Citizen.Wait(cloths[cloth].start) else Citizen.Wait(1000) end
            if cloths[cloth].comp ~= nil then
                SetPedComponentVariation(ped, cloths[cloth].comp, cloths[cloth].cloth.draw, cloths[cloth].cloth.text, cloths[cloth].cloth.pal)
            elseif cloths[cloth].prop ~= nil then
                SetPedPropIndex(ped,cloths[cloth].prop,cloths[cloth].cloth.draw, cloths[cloth].cloth.text, true)
            end
            if cloths[cloth].savevar ~= nil then
                SetPedComponentVariation(ped, cloths[cloth].savevar.comp, cloths[cloths[cloth].savevar.text].cloth.draw, cloths[cloths[cloth].savevar.text].cloth.text, 0)
            end
            ClearPedTasks(ped)
    end
end


function useCloth(cloth)
    if not vRP.isHandcuffed() then
        local ped = GetPlayerPed(-1)
            if cloths[cloth].start ~= nil then Citizen.Wait(cloths[cloth].start) else Citizen.Wait(1000) end
            if cloths[cloth].comp ~= nil then
                SetPedComponentVariation(ped, cloths[cloth].comp, cloths[cloth].cloth.draw, cloths[cloth].cloth.text, cloths[cloth].cloth.pal)
            elseif cloths[cloth].prop ~= nil then
                SetPedPropIndex(ped,cloths[cloth].prop,cloths[cloth].cloth.draw, cloths[cloth].cloth.text, true)
            end
            if cloths[cloth].savevar ~= nil then
                SetPedComponentVariation(ped, cloths[cloth].savevar.comp, cloths[cloths[cloth].savevar.text].cloth.draw, cloths[cloths[cloth].savevar.text].cloth.text, 0)
            end
            ClearPedTasks(ped)
    end
end


local save = {
    "briller",
    "hat",
}



-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(15000)
--         for k,v in pairs(save) do
--             local propindex = GetPedPropIndex(PlayerPedId(),cloths[v].prop)
--             if propindex ~= cloths[v].first and propindex ~= -1 then
--                 local text = GetPedPropTextureIndex(PlayerPedId(),cloths[v].prop)
--                 cloths[v].cloth = {
--                     draw = propindex,
--                     text = text,
--                 }
--             end
--         end
--     end
-- end)
