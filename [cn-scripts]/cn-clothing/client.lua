local firstSpawn = true
local componentScroller = 0
local subComponentScroller = 0
local textureScroller = 0
local paletteScroller = 0
local removeScroller = 0
local opacityScroller = 0
local colourScroller = 0

local checkperm = false
function OpenClothes()
    Menu.SetupMenu("clothing_main","Tøjbutik")
    Menu.Switch(nil, "clothing_main")
    for k,v in pairs(menu_options) do
        Menu.addOption("clothing_main", function()
            if(Menu.Option(v.name))then
                if v.name == "Private Modeller" or v.name == "Politi Tøj" or v.name == "EMS Tøj" or v.name == "Hemmeligt" then
                    if checkperm == false then
                        checkperm = true
                        TriggerServerEvent("ftn-clothing:hasaccess", v.name)
                        SetTimeout(3000, function()
                            checkperm = false
                        end)
                    else
                        TriggerEvent("pNotify:SendNotification",{
                            text = "Du skal vente med at prøve igen!",
                            type = "error",
                            timeout = 3000,
                            layout = "centerLeft",
                            queue = "global",
                            animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},
                        })
                    end
                else
                    v.f(v.name,v.param)
                end
            end
        end)
    end
end

RegisterNetEvent('ftn-clothing:access')
AddEventHandler('ftn-clothing:access', function(menuname)
    Menu.Switch(nil, "clothing_main")
    for k,v in pairs(menu_options) do
        if v.name == menuname then
            v.f(menuname,v.param)
        end
    end
end)

function listModels(title, table)
    Menu.SetupMenu("clothing_models", title)
    Menu.Switch("clothing_main", "clothing_models")
    for k,v in pairs(table) do
        Menu.addOption("clothing_models", function()
            if(Menu.Option(v))then
                TriggerEvent("clothes:changemodel", v)
            end
        end)
    end
end

local memscloth = {
    [11] = {
	{draw=20,text={9,10,11,12,13,14}},
        {draw=44,text={0,1,2,3,4,5}},
        {draw=45,text={0,1,2,3,4,5}},
        {draw=46,text={0,1,2,3,4,5}},
        {draw=47,text={0}},
        {draw=48,text={0,1,2,3,4,5}},
		
	},
    [4] = {
        {draw=16,text={1,2}},
    },
}

local femscloth = {
    [11] = {
        {draw=0,text={0,1,2,3,4,5}},
        {draw=2,text={0,1,2,3,4,5}},
        {draw=4,text={0,1,2,3,4,5}},
        {draw=6,text={0,1,2,3,4,5}},
        {draw=7,text={0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}},
        {draw=8,text={0,1,2,3,4,5}},

        },
    [4] = {
        {draw=85,text={0,1,2,3}},
    },
}

local mpolicecloth = {
    [11] = {
        {draw=19,text={1}},
        {draw=20,text={0,1,2,3,4,5,6,7,8,15,16}},
        {draw=21,text={0,1,2,3,4,5,6,7}},
        {draw=22,text={0,1,2,6}},
        {draw=23,text={0}},
        {draw=24,text={0}},
        {draw=25,text={0,1,2,3,4,5,6,7,8,9}},
        {draw=26,text={0,1,2,3,4,5,6}},
        {draw=27,text={0}},
        {draw=30,text={1}},
        {draw=43,text={0,1,2,3,4,5,6,7,8}},
    },
    [10] = {
        {draw=7,text={0,1}},
        {draw=8,text={0}},
        {draw=9,text={0}},
        {draw=10,text={0,1}},
        {draw=11,text={0,1}},
        {draw=12,text={0,1}},
        {draw=13,text={0,1}},
        {draw=14,text={0}},
        {draw=15,text={0,1}},
        {draw=16,text={0}},
        {draw=17,text={0}},
        {draw=18,text={0,1}},
        {draw=19,text={0,1}},
        {draw=20,text={0}},
    },
    [9] = {
        {draw=10,text={1,2,3,4,5,6,7,8,9}},
        {draw=11,text={0,1,2,3,4,5,6,7,8}},
        {draw=12,text={0,1,2,3,4,5,6,7,8}},
        {draw=13,text={0,1,2,3,4,5,6,7,8,9}},
        {draw=14,text={0,1,2,3,4,5,6,7,8,9}},
        {draw=15,text={0,1,2,3,4,5,6,7,8}},
        {draw=16,text={0,1,2,3,4,5,6,7,8}},
        {draw=17,text={0,1,2,3,4,5,6,7,8}},
        {draw=18,text={0}},
    },
    [8] = {
	    {draw=16,text={0}},
        {draw=92,text={0}},
        {draw=156,text={0}},
        {draw=164,text={0}},
    },
    [7] = {
        {draw=16,text={0}},
        {draw=17,text={0}},
        {draw=18,text={0}},
    },
    [4] = {
        {draw=16,text={0,1,3}},
		{draw=17,text={0}},
    },
}

local fpolicecloth = {
    [11] = {
        {draw=77,text={0,1,2,3,4}},
        {draw=78,text={0,1,2}},
        {draw=178,text={0}},
        {draw=264,text={0,1,2,3}},
        {draw=280,text={0,1,2,3,4,5,6,7,8}},
        {draw=309,text={0}},
        {draw=321,text={0}},
    },
    [10] = {
        {draw=101,text={0}},
        {draw=102,text={0}},
        {draw=103,text={0}},
        {draw=114,text={0}},
    },
    [9] = {
        {draw=3,text={0,1,2,3,4}},
        {draw=4,text={2,3,4}},
        {draw=5,text={2,3,4}},
        {draw=6,text={2,3,4}},
        {draw=52,text={0,1,2,3,4}},
        {draw=61,text={0,1,2,3,4,5,6,7,8,9}},
        {draw=62,text={0,1,2,3,4,5,6,7,8,9}},
        {draw=63,text={0,1,2,3,4,5,6,7,8,9}},
        {draw=65,text={0,1,2,3,4,5,6,7,8,9}},
        {draw=70,text={0,1,2,3,4,5,6,7,8,9}},
        {draw=71,text={0,1,2,3,4,5,6,7,8,9}},
    },
    [8] = {
        {draw=9,text={0}},
        {draw=10,text={0}},
        {draw=177,text={0}},
        {draw=178,text={0}},
        {draw=186,text={0}},
        {draw=194,text={0}},
        {draw=195,text={0}},
    },
    [7] = {
        {draw=5,text={0,1,2,3,4,5}},
        {draw=6,text={0,1,2,3,4,5}},
        {draw=135,text={0}},
        {draw=138,text={0}},
    },
    [4] = {
        {draw=66,text={0}},
        {draw=85,text={0,1,2,3}},
    },
}

local mblocked = {

}

local fblocked = {

}

local mtblocked = {
    [11] = {
        [19] = {1},
        [20] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16},
        [21] = {0,1,2,3,4,5,6,7},
        [22] = {0,1,2,6},
        [23] = {0},
        [24] = {0},
        [25] = {0,1,2,3,4,5,6,7,8,9},
        [26] = {0,1,2,3,4,5,6},
        [27] = {0},
        [28] = {0,1,2,3,4,5},
        [29] = {0}, 
        [30] = {1}, 
        [43] = {0,1,2,3,4,5,6,7,8},
    },
    [10] = {
        [7] = {0,1},
        [8] = {0},
        [9] = {0},
        [10] = {0,1},
        [11] = {0,1},
        [12] = {0,1},
        [13] = {0,1},
        [14] = {0},
        [15] = {0,1},
        [16] = {0},
        [17] = {0},
        [18] = {0,1},
        [19] = {0,1},
        [20] = {0},
    },
    [9] = {
        [10] = {1,2,3,4,5,6,7,8,9},
        [11] = {0,1,2,3,4,5,6,7,8},
        [12] = {0,1,2,3,4,5,6,7,8},
        [13] = {0,1,2,3,4,5,6,7,8,9},
        [14] = {0,1,2,3,4,5,6,7,8,9},
        [15] = {0,1,2,3,4,5,6,7,8},
        [16] = {0,1,2,3,4,5,6,7,8},
        [17] = {0,1,2,3,4,5,6,7,8},
        [18] = {0},
    },
    [8] = {
	    [16] = {0},
        [92] = {0},
        [156] = {0},
        [164] = {0},        
    },
    [7] = {
        [16] = {0},
        [17] = {0},
        [18] = {0},
    },
    [4] = {
        [16] = {0,1,2,3},
        [17] = {0},
    }
}

local ftblocked = {
    [11] = {
        [77] = {0,1,2,3,4},
        [78] = {0,1,2},
        [172] = {0},
        [178] = {0},
        [264] = {0,1,2,3},
        [280] = {0,1,2,3,4,5,6,7,8},
        [309] = {0},
        [321] = {0},
        [329] = {0,1,2,3,4,5},
        [330] = {0,1,2,3,4,5},
        [331] = {0},
    },
    [10] = {
        [101] = {0},
        [102] = {0},
        [103] = {0},
        [114] = {0},
    },
    [9] = {
        [3] = {0,1,2,3,4},
        [4] = {2,3,4},
        [5] = {2,3,4},
        [6] = {2,3,4},
        [52] = {0,1,2,3,4},
        [61] = {0,1,2,3,4,5,6,7,8,9},
        [62] = {0,1,2,3,4,5,6,7,8,9},
        [63] = {0,1,2,3,4,5,6,7,8,9},
        [65] = {0,1,2,3,4,5,6,7,8,9},
        [70] = {0,1,2,3,4,5,6,7,8,9},
        [71] = {0,1,2,3,4,5,6,7,8,9},
    },
    [8] = {
        [9] = {0},
        [10] = {0},
        [70] = {0},
        [177] = {0},
        [178] = {0},
        [186] = {0},
        [193] = {0},
        [194] = {0},
        [195] = {0},
    },
    [7] = {
        [5] = {0,1,2,3,4,5},
        [6] = {0,1,2,3,4,5},
        [135] = {0},
        [138] = {0},
    },
    [6] = {
        [58] = {0},
        [59] = {0},
    },
    [4] = {
        [66] = {0},
        [85] = {0,1,2,3},
    },
}

function customise(title)
    Menu.SetupMenu("clothing_customise", title)
    Menu.Switch("clothing_main", "clothing_customise")
    if GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("player_one") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("player_two") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("player_zero")then
        componentScroller = 0
        subComponentScroller = GetPedDrawableVariation(GetPlayerPed(-1), componentScroller)
        textureScroller = GetPedTextureVariation(GetPlayerPed(-1), componentScroller)
        paletteScroller = GetPedPaletteVariation(GetPlayerPed(-1), componentScroller)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarString({"Hoved (Skift ved frisør)","Masker","Hår (Skift ved frisør)","Arme","Bukser","Faldskærm/Tasker","Sko","Halskæde og slips","Undertrøje","Skudsikker Vest","Detaljer","Trøje"}, componentScroller, function(cb)
                componentScroller = cb
            end)) then
                subComponentScroller = GetPedDrawableVariation(GetPlayerPed(-1), componentScroller)
                textureScroller = GetPedTextureVariation(GetPlayerPed(-1), componentScroller)
                paletteScroller = GetPedPaletteVariation(GetPlayerPed(-1), componentScroller)
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarInt("Komponenter", subComponentScroller, GetNumberOfPedDrawableVariations(GetPlayerPed(-1), componentScroller), function(cb)
                local blocked = ""
                if GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01") then
                    if fblocked[componentScroller] ~= nil then
                        blocked = fblocked[componentScroller]
                    end
                else
                    if mblocked[componentScroller] ~= nil then
                        blocked = mblocked[componentScroller]
                    end
                end
                if blocked ~= "" then
                    local calctype = ""
                    if subComponentScroller < cb then
                        calctype = "+"
                    else
                        calctype = "-"
                    end
                    local check = has_value(blocked,cb)
                    if check then
                        while check do
                            if calctype == "+" then cb = cb+1 else cb = cb-1 end
                            check = has_value(blocked,cb)
                        end
                    end
                end
                subComponentScroller = cb
            end)) then
                if componentScroller == 0 then
                    SetPedHeadBlendData(GetPlayerPed(-1), subComponentScroller, subComponentScroller, 0, subComponentScroller, subComponentScroller, 0, 0.5, 0.5, 0.0, false)
                end
                SetPedComponentVariation(GetPlayerPed(-1), componentScroller, 0, 240, 0)
                local blocked = ""
                if GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01") then
                    if ftblocked[componentScroller] ~= nil and ftblocked[componentScroller][subComponentScroller] ~= nil then
                        blocked = ftblocked[componentScroller][subComponentScroller]
                    end
                else
                    if mtblocked[componentScroller] ~= nil and mtblocked[componentScroller][subComponentScroller] ~= nil then
                        blocked = mtblocked[componentScroller][subComponentScroller]
                    end
                end
                if blocked ~= "" then
                    local check = has_value(blocked,textureScroller)
                    if check then
                        while check do
                            textureScroller = textureScroller+1
                            check = has_value(blocked,textureScroller)
                        end
                    end
                end
                SetPedComponentVariation(GetPlayerPed(-1), componentScroller, subComponentScroller, textureScroller, paletteScroller)
                textureScroller = 0
                paletteScroller = 0
            end
        end)
        Menu.addOption("clothing_customise", function()
            local textureMax = 0
            if componentScroller == 2 then textureMax = GetNumHairColors() else textureMax = GetNumberOfPedTextureVariations(GetPlayerPed(-1), componentScroller, subComponentScroller) end
            if(Menu.ScrollBarInt("Textures", textureScroller, textureMax, function(cb)
                local blocked = ""
                if GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01") then
                    if ftblocked[componentScroller] ~= nil and ftblocked[componentScroller][subComponentScroller] ~= nil then
                        blocked = ftblocked[componentScroller][subComponentScroller]
                    end
                else
                    if mtblocked[componentScroller] ~= nil and mtblocked[componentScroller][subComponentScroller] ~= nil then
                        blocked = mtblocked[componentScroller][subComponentScroller]
                    end
                end
                if blocked ~= "" then
                    local calctype = ""
                    if textureScroller < cb then
                        calctype = "+"
                    else
                        calctype = "-"
                    end
                    local check = has_value(blocked,cb)
                    if check then
                        while check do
                            if calctype == "+" then cb = cb+1 else cb = cb-1 end
                            check = has_value(blocked,cb)
                        end
                    end
                end
                textureScroller = cb
            end)) then
                if componentScroller == 2 then
                    SetPedComponentVariation(GetPlayerPed(-1), componentScroller, subComponentScroller, 0, 1)
                    SetPedHairColor(GetPlayerPed(-1), textureScroller, textureScroller)
                    player_data.clothing.textures[3] = textureScroller
                else
                    SetPedComponentVariation(GetPlayerPed(-1), componentScroller, subComponentScroller, textureScroller, paletteScroller)
                end
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarInt("Farvepalet", paletteScroller, 2, function(cb)  paletteScroller = cb end)) then
                SetPedComponentVariation(GetPlayerPed(-1), componentScroller, subComponentScroller, textureScroller, paletteScroller)
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.Option("Fjern Undertrøjen"))then
                SetPedComponentVariation(GetPlayerPed(-1), 8, 0, 240, 0)
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.Option("Tilfældig"))then
                SetPedRandomComponentVariation(GetPlayerPed(-1), true)
            end
        end)
    else
        componentScroller = 0
        subComponentScroller = GetPedDrawableVariation(GetPlayerPed(-1), componentScroller)
        textureScroller = GetPedTextureVariation(GetPlayerPed(-1), componentScroller)
        paletteScroller = GetPedPaletteVariation(GetPlayerPed(-1), componentScroller)
        Menu.addOption("clothing_customise", function()
            local precomponentTable = {"(HOVED) SKIFT DETTE VED BARBERSHOPPEN","Ingen ide","(HÅR) SKIFT DETTE VED BARBERSHOPPEN","T-Shirt","Bukser","Ingen ide","Ingen ide","Ingen ide","Halskæde & Slips","Ingen ide","Ingen ide","Ingen ide"}
            local componentTable = {}
            for i = 0, 11 do
                if GetNumberOfPedDrawableVariations(GetPlayerPed(-1), i) ~= 0 and GetNumberOfPedDrawableVariations(GetPlayerPed(-1), i) ~= false then
                    componentTable[i+1] = precomponentTable[i+1]
                else
                    componentTable[i+1] = "Tom plads"
                end
            end
            if(Menu.ScrollBarString(componentTable, componentScroller, function(cb)  componentScroller = cb end)) then
                subComponentScroller = GetPedDrawableVariation(GetPlayerPed(-1), componentScroller)
                textureScroller = GetPedTextureVariation(GetPlayerPed(-1), componentScroller)
                paletteScroller = GetPedPaletteVariation(GetPlayerPed(-1), componentScroller)
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarInt("Komponenter", subComponentScroller, GetNumberOfPedDrawableVariations(GetPlayerPed(-1), componentScroller), function(cb)  subComponentScroller = cb end)) then
                SetPedComponentVariation(GetPlayerPed(-1), componentScroller, 0, 240, 0)
                SetPedComponentVariation(GetPlayerPed(-1), componentScroller, subComponentScroller, textureScroller, paletteScroller)
                textureScroller = 0
                paletteScroller = 0
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarInt("Textures", textureScroller, GetNumberOfPedTextureVariations(GetPlayerPed(-1), componentScroller, subComponentScroller), function(cb)  textureScroller = cb end)) then
                if componentScroller == 2 then player_data.clothing.textures[3] = textureScroller end
                SetPedComponentVariation(GetPlayerPed(-1), componentScroller, subComponentScroller, textureScroller, paletteScroller)
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarInt("Farvepalet", paletteScroller, 2, function(cb)  paletteScroller = cb end)) then
                SetPedComponentVariation(GetPlayerPed(-1), componentScroller, subComponentScroller, textureScroller, paletteScroller)
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.Option("Tilfældig"))then
                SetPedRandomComponentVariation(GetPlayerPed(-1), true)
            end
        end)
    end
end

function customisedebug(title)
    Menu.SetupMenu("clothing_customise", title)
    Menu.Switch("clothing_main", "clothing_customise")
    if GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("player_one") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("player_two") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("player_zero")then
        componentScroller = 0
        subComponentScroller = GetPedDrawableVariation(GetPlayerPed(-1), componentScroller)
        textureScroller = GetPedTextureVariation(GetPlayerPed(-1), componentScroller)
        paletteScroller = GetPedPaletteVariation(GetPlayerPed(-1), componentScroller)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarString({"Hoved (Skift ved frisør)","Masker","Hår (Skift ved frisør)","Arme","Bukser","Faldskærm/Tasker","Sko","Halskæde og slips","Undertrøje","Skudsikker Vest","Detaljer","Trøje"}, componentScroller, function(cb)
                if componentScroller < cb then
                    if cb == 0 or cb == 2 then
                        cb = cb+1
                    end
                else
                    if cb == 0 or cb == 2 then
                        if cb == 0 then
                            if componentScroller == 11 then
                                cb = 2
                            else
                                cb = 12
                            end
                        end
                        cb = cb-1
                    end
                end
                print(cb)
                componentScroller = cb
            end)) then
                subComponentScroller = GetPedDrawableVariation(GetPlayerPed(-1), componentScroller)
                textureScroller = GetPedTextureVariation(GetPlayerPed(-1), componentScroller)
                paletteScroller = GetPedPaletteVariation(GetPlayerPed(-1), componentScroller)
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarInt("Komponenter", subComponentScroller, GetNumberOfPedDrawableVariations(GetPlayerPed(-1), componentScroller), function(cb)
                subComponentScroller = cb
            end)) then
                if componentScroller == 0 then
                    SetPedHeadBlendData(GetPlayerPed(-1), subComponentScroller, subComponentScroller, 0, subComponentScroller, subComponentScroller, 0, 0.5, 0.5, 0.0, false)
                end
                SetPedComponentVariation(GetPlayerPed(-1), componentScroller, 0, 240, 0)
                SetPedComponentVariation(GetPlayerPed(-1), componentScroller, subComponentScroller, textureScroller, paletteScroller)
                textureScroller = 0
                paletteScroller = 0
            end
        end)
        Menu.addOption("clothing_customise", function()
            local textureMax = 0
            if componentScroller == 2 then textureMax = GetNumHairColors() else textureMax = GetNumberOfPedTextureVariations(GetPlayerPed(-1), componentScroller, subComponentScroller) end
            if(Menu.ScrollBarInt("Textures", textureScroller, textureMax, function(cb)
                textureScroller = cb
            end)) then
                print("Cat:"..componentScroller.." Kom:"..subComponentScroller.." Text:"..textureScroller)
                if componentScroller == 2 then
                    SetPedComponentVariation(GetPlayerPed(-1), componentScroller, subComponentScroller, 0, 1)
                    SetPedHairColor(GetPlayerPed(-1), textureScroller, textureScroller)
                    player_data.clothing.textures[3] = textureScroller
                else
                    SetPedComponentVariation(GetPlayerPed(-1), componentScroller, subComponentScroller, textureScroller, paletteScroller)
                end
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarInt("Farvepalet", paletteScroller, 2, function(cb)  paletteScroller = cb end)) then
                SetPedComponentVariation(GetPlayerPed(-1), componentScroller, subComponentScroller, textureScroller, paletteScroller)
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.Option("Fjern Undertrøjen"))then
                SetPedComponentVariation(GetPlayerPed(-1), 8, 0, 240, 0)
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.Option("Tilfældig"))then
                SetPedRandomComponentVariation(GetPlayerPed(-1), true)
            end
        end)
    else
        componentScroller = 0
        subComponentScroller = GetPedDrawableVariation(GetPlayerPed(-1), componentScroller)
        textureScroller = GetPedTextureVariation(GetPlayerPed(-1), componentScroller)
        paletteScroller = GetPedPaletteVariation(GetPlayerPed(-1), componentScroller)
        Menu.addOption("clothing_customise", function()
            local precomponentTable = {"(HOVED) SKIFT DETTE VED BARBERSHOPPEN","Ingen ide","(HÅR) SKIFT DETTE VED BARBERSHOPPEN","T-Shirt","Bukser","Ingen ide","Ingen ide","Ingen ide","Halskæde & Slips","Ingen ide","Ingen ide","Ingen ide"}
            local componentTable = {}
            for i = 0, 11 do
                if GetNumberOfPedDrawableVariations(GetPlayerPed(-1), i) ~= 0 and GetNumberOfPedDrawableVariations(GetPlayerPed(-1), i) ~= false then
                    componentTable[i+1] = precomponentTable[i+1]
                else
                    componentTable[i+1] = "Tom plads"
                end
            end
            if(Menu.ScrollBarString(componentTable, componentScroller, function(cb)  componentScroller = cb end)) then
                subComponentScroller = GetPedDrawableVariation(GetPlayerPed(-1), componentScroller)
                textureScroller = GetPedTextureVariation(GetPlayerPed(-1), componentScroller)
                paletteScroller = GetPedPaletteVariation(GetPlayerPed(-1), componentScroller)
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarInt("Komponenter", subComponentScroller, GetNumberOfPedDrawableVariations(GetPlayerPed(-1), componentScroller), function(cb)  subComponentScroller = cb end)) then
                SetPedComponentVariation(GetPlayerPed(-1), componentScroller, 0, 240, 0)
                SetPedComponentVariation(GetPlayerPed(-1), componentScroller, subComponentScroller, textureScroller, paletteScroller)
                textureScroller = 0
                paletteScroller = 0
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarInt("Textures", textureScroller, GetNumberOfPedTextureVariations(GetPlayerPed(-1), componentScroller, subComponentScroller), function(cb)  textureScroller = cb end)) then
                if componentScroller == 2 then player_data.clothing.textures[3] = textureScroller end
                SetPedComponentVariation(GetPlayerPed(-1), componentScroller, subComponentScroller, textureScroller, paletteScroller)
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarInt("Farvepalet", paletteScroller, 2, function(cb)  paletteScroller = cb end)) then
                SetPedComponentVariation(GetPlayerPed(-1), componentScroller, subComponentScroller, textureScroller, paletteScroller)
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.Option("Tilfældig"))then
                SetPedRandomComponentVariation(GetPlayerPed(-1), true)
            end
        end)
    end
end

function getEMSCloth()
    local cloth = ""
    if GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01") then
        if femscloth[lcomponentScroller] ~= nil then
            cloth = femscloth[lcomponentScroller]
        end
    else
        if memscloth[lcomponentScroller] ~= nil then
            cloth = memscloth[lcomponentScroller]
        end
    end
    if cloth ~= "" then return cloth else return false end
end
function getCloth()
    local cloth = ""
    if GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01") then
        if fpolicecloth[lcomponentScroller] ~= nil then
            cloth = fpolicecloth[lcomponentScroller]
        end
    else
        if mpolicecloth[lcomponentScroller] ~= nil then
            cloth = mpolicecloth[lcomponentScroller]
        end
    end
    if cloth ~= "" then return cloth else return false end
end
function lastDraw(table)
    local count = (table and #table or false)
    if count then
        return count;
    end
    return false;
end
function getDraw(arr,draw)
    for k,v in pairs(arr) do
        if v.draw == draw then
            return v
        end
    end
    return false
end
function hasDraw(arr,draw)
    for k,v in pairs(arr) do
        if v.draw == draw then
            return true
        end
    end
    return false
end
function getDrawKey(arr,draw)
    for k,v in pairs(arr) do
        if v.draw == draw then
            return k
        end
    end
    return false
end
function getClothAmount(arr)
    local n = 0
    for k,v in pairs(arr) do
        n=n+1
    end
    return n
end
function policecustomise(title)
    Menu.SetupMenu("clothing_customise", title)
    Menu.Switch("clothing_main", "clothing_customise")
    if GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("player_one") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("player_two") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("player_zero")then
        componentScroller = 0
        lcomponentScroller = 6
        local lcloth = getCloth()
        subComponentScroller = lcloth ~= false and hasDraw(lcloth,GetPedDrawableVariation(GetPlayerPed(-1),lcomponentScroller)) ~= false and GetPedDrawableVariation(GetPlayerPed(-1),lcomponentScroller) or 1 or GetPedDrawableVariation(GetPlayerPed(-1),lcomponentScroller)
        textureScroller = GetPedTextureVariation(GetPlayerPed(-1), lcomponentScroller)
        paletteScroller = GetPedPaletteVariation(GetPlayerPed(-1), lcomponentScroller)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarString({"Sko","Bukser","Politiskilt & Hylstre","Undertrøje","Skudsikker Vest","Arme","Politibælter","Trøje"}, componentScroller, function(cb)
                if cb == 0 then
                    lcomponentScroller = 6
                elseif cb == 1 then
                    lcomponentScroller = 4
                elseif cb == 2 then
                    lcomponentScroller = 7
                elseif cb == 3 then
                    lcomponentScroller = 8
                elseif cb == 4 then
                    lcomponentScroller = 9
                elseif cb == 5 then
                    lcomponentScroller = 3
                elseif cb == 6 then
                    lcomponentScroller = 10
                elseif cb == 7 then
                    lcomponentScroller = 11
                end
                componentScroller = cb
            end)) then
                local lcloth = getCloth()
                local ldraw = lcloth ~= false and getDrawKey(lcloth,GetPedDrawableVariation(GetPlayerPed(-1),lcomponentScroller)) or GetPedDrawableVariation(GetPlayerPed(-1))
                if lcloth ~= false then
                    subComponentScroller = ldraw ~= false and ldraw or 1
                else
                    subComponentScroller = GetPedDrawableVariation(GetPlayerPed(-1),lcomponentScroller)
                end
                --lcloth ~= false and lcloth[subComponentScroller+1].text[1] or
                textureScroller = GetPedTextureVariation(GetPlayerPed(-1), lcomponentScroller)
                paletteScroller = GetPedPaletteVariation(GetPlayerPed(-1), lcomponentScroller)
            end
        end)
        Menu.addOption("clothing_customise", function()
            cloth = getCloth()
            ncloth = cloth ~= false and getClothAmount(cloth) or GetNumberOfPedDrawableVariations(GetPlayerPed(-1), lcomponentScroller)
            if(Menu.ScrollBarInt("Komponenter", subComponentScroller, ncloth, function(cb)
                if cloth ~= false then
                    local lastdraw = lastDraw(cloth)-1
                    if subComponentScroller < cb then
                        if cb > lastdraw then
                            subComponentScroller = 0
                        else
                            subComponentScroller = cb
                        end
                    else
                        if cb < 0 then
                            subComponentScroller=lastdraw-1
                        else
                            subComponentScroller=cb
                        end
                    end
                else
                    subComponentScroller=cb
                end
            end)) then
                if lcomponentScroller == 0 then
                    SetPedHeadBlendData(GetPlayerPed(-1), subComponentScroller, subComponentScroller, 0, subComponentScroller, subComponentScroller, 0, 0.5, 0.5, 0.0, false)
                end
                SetPedComponentVariation(GetPlayerPed(-1), lcomponentScroller, 0, 240, 0)
                if cloth ~= false then
                    if cloth[subComponentScroller+1] ~= nil then
                        SetPedComponentVariation(GetPlayerPed(-1), lcomponentScroller, cloth[subComponentScroller+1].draw, cloth[subComponentScroller+1].text[1], paletteScroller)
                    end
                else
                    SetPedComponentVariation(GetPlayerPed(-1), lcomponentScroller, subComponentScroller, textureScroller, paletteScroller)
                end
                textureScroller = cloth ~= false and cloth[subComponentScroller+1] ~= nil and cloth[subComponentScroller+1].text[1] or 0 or 0
                paletteScroller = 0
            end
        end)
        Menu.addOption("clothing_customise", function()
            local tcloth = getCloth()
            local lgetdraw = tcloth ~= false and getDraw(tcloth,GetPedDrawableVariation(GetPlayerPed(-1),lcomponentScroller)) or false -- lave om
            local textureMax = lgetdraw ~= false and getClothAmount(lgetdraw.text) or 0
            if componentScroller == 2 then textureMax = GetNumHairColors() else textureMax = textureMax ~= 0 and textureMax or GetNumberOfPedTextureVariations(GetPlayerPed(-1), lcomponentScroller, subComponentScroller) end
            if(Menu.ScrollBarInt("Textures", textureScroller, textureMax, function(cb)
                textureScroller = cb
            end)) then
                if componentScroller == 2 then
                    SetPedComponentVariation(GetPlayerPed(-1), lcomponentScroller, subComponentScroller, 0, 1)
                    SetPedHairColor(GetPlayerPed(-1), textureScroller, textureScroller)
                    player_data.clothing.textures[3] = textureScroller
                else
                    local thisdraw = lgetdraw ~= false and lgetdraw.draw or subComponentScroller
                    local thistext = lgetdraw ~= false and lgetdraw.text[textureScroller+1] or textureScroller
                    SetPedComponentVariation(GetPlayerPed(-1), lcomponentScroller, thisdraw, thistext, paletteScroller)
                end
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.Option("Fjern Undertrøjen"))then
                SetPedComponentVariation(GetPlayerPed(-1), 8, 0, 240, 0)
            end
        end)
    else
        componentScroller = 0
        subComponentScroller = GetPedDrawableVariation(GetPlayerPed(-1), componentScroller)
        textureScroller = GetPedTextureVariation(GetPlayerPed(-1), componentScroller)
        paletteScroller = GetPedPaletteVariation(GetPlayerPed(-1), componentScroller)
        Menu.addOption("clothing_customise", function()
            local precomponentTable = {"Hoved (Skift ved frisør)","Masker","Hår (Skift ved frisør)","Arme","Bukser","Faldskærm/Tasker","Sko","Halskæde og slips","Undertrøje","Skudsikker Vest","Detaljer","Trøje"}
            local componentTable = {}
            for i = 0, 11 do
                if GetNumberOfPedDrawableVariations(GetPlayerPed(-1), i) ~= 0 and GetNumberOfPedDrawableVariations(GetPlayerPed(-1), i) ~= false then
                    componentTable[i+1] = precomponentTable[i+1]
                else
                    componentTable[i+1] = "Tom plads"
                end
            end
            if(Menu.ScrollBarString(componentTable, componentScroller, function(cb)  componentScroller = cb end)) then
                subComponentScroller = GetPedDrawableVariation(GetPlayerPed(-1), componentScroller)
                textureScroller = GetPedTextureVariation(GetPlayerPed(-1), componentScroller)
                paletteScroller = GetPedPaletteVariation(GetPlayerPed(-1), componentScroller)
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarInt("Komponenter", subComponentScroller, GetNumberOfPedDrawableVariations(GetPlayerPed(-1), componentScroller), function(cb)  subComponentScroller = cb end)) then
                SetPedComponentVariation(GetPlayerPed(-1), componentScroller, 0, 240, 0)
                SetPedComponentVariation(GetPlayerPed(-1), componentScroller, subComponentScroller, textureScroller, paletteScroller)
                textureScroller = 0
                paletteScroller = 0
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarInt("Textures", textureScroller, GetNumberOfPedTextureVariations(GetPlayerPed(-1), componentScroller, subComponentScroller), function(cb)  textureScroller = cb end)) then
                if componentScroller == 2 then player_data.clothing.textures[3] = textureScroller end
                SetPedComponentVariation(GetPlayerPed(-1), componentScroller, subComponentScroller, textureScroller, paletteScroller)
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarInt("Farvepalet", paletteScroller, 2, function(cb)  paletteScroller = cb end)) then
                SetPedComponentVariation(GetPlayerPed(-1), componentScroller, subComponentScroller, textureScroller, paletteScroller)
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.Option("Tilfældig"))then
                SetPedRandomComponentVariation(GetPlayerPed(-1), true)
            end
        end)
    end
end
function emscustomise(title)
    Menu.SetupMenu("clothing_customise", title)
    Menu.Switch("clothing_main", "clothing_customise")
    if GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("player_one") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("player_two") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("player_zero")then
        componentScroller = 0
        lcomponentScroller = 6
        local lcloth = getEMSCloth()
        subComponentScroller = lcloth ~= false and hasDraw(lcloth,GetPedDrawableVariation(GetPlayerPed(-1),lcomponentScroller)) ~= false and GetPedDrawableVariation(GetPlayerPed(-1),lcomponentScroller) or 1 or GetPedDrawableVariation(GetPlayerPed(-1),lcomponentScroller)
        textureScroller = GetPedTextureVariation(GetPlayerPed(-1), lcomponentScroller)
        paletteScroller = GetPedPaletteVariation(GetPlayerPed(-1), lcomponentScroller)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarString({"Sko","Bukser","Arme","Trøje"}, componentScroller, function(cb)
                if cb == 0 then
                    lcomponentScroller = 6
                elseif cb == 1 then
                    lcomponentScroller = 4
                elseif cb == 2 then
                    lcomponentScroller = 3
                elseif cb == 3 then
                    lcomponentScroller = 11
                end
                componentScroller = cb
            end)) then
                local lcloth = getEMSCloth()
                local ldraw = lcloth ~= false and getDrawKey(lcloth,GetPedDrawableVariation(GetPlayerPed(-1),lcomponentScroller)) or GetPedDrawableVariation(GetPlayerPed(-1))
                if lcloth ~= false then
                    subComponentScroller = ldraw ~= false and ldraw or 1
                else
                    subComponentScroller = GetPedDrawableVariation(GetPlayerPed(-1),lcomponentScroller)
                end
                --lcloth ~= false and lcloth[subComponentScroller+1].text[1] or
                textureScroller = GetPedTextureVariation(GetPlayerPed(-1), lcomponentScroller)
                paletteScroller = GetPedPaletteVariation(GetPlayerPed(-1), lcomponentScroller)
            end
        end)
        Menu.addOption("clothing_customise", function()
            cloth = getEMSCloth()
            ncloth = cloth ~= false and getClothAmount(cloth) or GetNumberOfPedDrawableVariations(GetPlayerPed(-1), lcomponentScroller)
            if(Menu.ScrollBarInt("Komponenter", subComponentScroller, ncloth, function(cb)
                if cloth ~= false then
                    local lastdraw = lastDraw(cloth)-1
                    if subComponentScroller < cb then
                        if cb > lastdraw then
                            subComponentScroller = 0
                        else
                            subComponentScroller = cb
                        end
                    else
                        if cb < 0 then
                            subComponentScroller=lastdraw-1
                        else
                            subComponentScroller=cb
                        end
                    end
                else
                    subComponentScroller=cb
                end
            end)) then
                if lcomponentScroller == 0 then
                    SetPedHeadBlendData(GetPlayerPed(-1), subComponentScroller, subComponentScroller, 0, subComponentScroller, subComponentScroller, 0, 0.5, 0.5, 0.0, false)
                end
                SetPedComponentVariation(GetPlayerPed(-1), lcomponentScroller, 0, 240, 0)
                if cloth ~= false then
                    if cloth[subComponentScroller+1] ~= nil then
                        SetPedComponentVariation(GetPlayerPed(-1), lcomponentScroller, cloth[subComponentScroller+1].draw, cloth[subComponentScroller+1].text[1], paletteScroller)
                    end
                else
                    SetPedComponentVariation(GetPlayerPed(-1), lcomponentScroller, subComponentScroller, textureScroller, paletteScroller)
                end
                textureScroller = cloth ~= false and cloth[subComponentScroller+1] ~= nil and cloth[subComponentScroller+1].text[1] or 0 or 0
                paletteScroller = 0
            end
        end)
        Menu.addOption("clothing_customise", function()
            local tcloth = getEMSCloth()
            local lgetdraw = tcloth ~= false and getDraw(tcloth,GetPedDrawableVariation(GetPlayerPed(-1),lcomponentScroller)) or false -- lave om
            local textureMax = lgetdraw ~= false and getClothAmount(lgetdraw.text) or 0
            if componentScroller == 2 then textureMax = GetNumHairColors() else textureMax = textureMax ~= 0 and textureMax or GetNumberOfPedTextureVariations(GetPlayerPed(-1), lcomponentScroller, subComponentScroller) end
            if(Menu.ScrollBarInt("Textures", textureScroller, textureMax, function(cb)
                textureScroller = cb
            end)) then
                if componentScroller == 2 then
                    SetPedComponentVariation(GetPlayerPed(-1), lcomponentScroller, subComponentScroller, 0, 1)
                    SetPedHairColor(GetPlayerPed(-1), textureScroller, textureScroller)
                    player_data.clothing.textures[3] = textureScroller
                else
                    local thisdraw = lgetdraw ~= false and lgetdraw.draw or subComponentScroller
                    local thistext = lgetdraw ~= false and lgetdraw.text[textureScroller+1] or textureScroller
                    SetPedComponentVariation(GetPlayerPed(-1), lcomponentScroller, thisdraw, thistext, paletteScroller)
                end
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.Option("Fjern Undertrøjen"))then
                SetPedComponentVariation(GetPlayerPed(-1), 8, 0, 240, 0)
            end
        end)
    else
        componentScroller = 0
        subComponentScroller = GetPedDrawableVariation(GetPlayerPed(-1), componentScroller)
        textureScroller = GetPedTextureVariation(GetPlayerPed(-1), componentScroller)
        paletteScroller = GetPedPaletteVariation(GetPlayerPed(-1), componentScroller)
        Menu.addOption("clothing_customise", function()
            local precomponentTable = {"Hoved (Skift ved frisør)","Masker","Hår (Skift ved frisør)","Arme","Bukser","Faldskærm/Tasker","Sko","Halskæde og slips","Undertrøje","Skudsikker Vest","Detaljer","Trøje"}
            local componentTable = {}
            for i = 0, 11 do
                if GetNumberOfPedDrawableVariations(GetPlayerPed(-1), i) ~= 0 and GetNumberOfPedDrawableVariations(GetPlayerPed(-1), i) ~= false then
                    componentTable[i+1] = precomponentTable[i+1]
                else
                    componentTable[i+1] = "Tom plads"
                end
            end
            if(Menu.ScrollBarString(componentTable, componentScroller, function(cb)  componentScroller = cb end)) then
                subComponentScroller = GetPedDrawableVariation(GetPlayerPed(-1), componentScroller)
                textureScroller = GetPedTextureVariation(GetPlayerPed(-1), componentScroller)
                paletteScroller = GetPedPaletteVariation(GetPlayerPed(-1), componentScroller)
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarInt("Komponenter", subComponentScroller, GetNumberOfPedDrawableVariations(GetPlayerPed(-1), componentScroller), function(cb)  subComponentScroller = cb end)) then
                SetPedComponentVariation(GetPlayerPed(-1), componentScroller, 0, 240, 0)
                SetPedComponentVariation(GetPlayerPed(-1), componentScroller, subComponentScroller, textureScroller, paletteScroller)
                textureScroller = 0
                paletteScroller = 0
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarInt("Textures", textureScroller, GetNumberOfPedTextureVariations(GetPlayerPed(-1), componentScroller, subComponentScroller), function(cb)  textureScroller = cb end)) then
                if componentScroller == 2 then player_data.clothing.textures[3] = textureScroller end
                SetPedComponentVariation(GetPlayerPed(-1), componentScroller, subComponentScroller, textureScroller, paletteScroller)
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.ScrollBarInt("Farvepalet", paletteScroller, 2, function(cb)  paletteScroller = cb end)) then
                SetPedComponentVariation(GetPlayerPed(-1), componentScroller, subComponentScroller, textureScroller, paletteScroller)
            end
        end)
        Menu.addOption("clothing_customise", function()
            if(Menu.Option("Tilfældig"))then
                SetPedRandomComponentVariation(GetPlayerPed(-1), true)
            end
        end)
    end
end
function accessories(title)
    Menu.SetupMenu("clothing_accessories", title)
    Menu.Switch("clothing_main", "clothing_accessories")
    if GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("player_one") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("player_two") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("player_zero")then
        componentScroller = 0
        subComponentScroller = GetPedPropIndex(GetPlayerPed(-1), componentScroller)
        textureScroller = GetPedPropTextureIndex(GetPlayerPed(-1), componentScroller)
        Menu.addOption("clothing_accessories", function()
            if(Menu.ScrollBarString({"Hatte/Hjelme","Briller","Øreringe","Tom plads","Tom plads","Tom plads","Venstre håndled","Højre håndled"}, componentScroller, function(cb)  componentScroller = cb end)) then
                subComponentScroller = GetPedPropIndex(GetPlayerPed(-1), componentScroller)
                textureScroller = GetPedPropTextureIndex(GetPlayerPed(-1), componentScroller)
            end
        end)
        Menu.addOption("clothing_accessories", function()
            if(Menu.ScrollBarInt("Komponenter", subComponentScroller, GetNumberOfPedPropDrawableVariations(GetPlayerPed(-1), componentScroller), function(cb)  subComponentScroller = cb end)) then
                SetPedPropIndex(GetPlayerPed(-1), componentScroller, 0, 240, 0)
                SetPedPropIndex(GetPlayerPed(-1), componentScroller, subComponentScroller, textureScroller, false)
                textureScroller = 0
            end
        end)
        Menu.addOption("clothing_accessories", function()
            if(Menu.ScrollBarInt("Textures", textureScroller, GetNumberOfPedPropTextureVariations(PlayerPedId(), componentScroller, subComponentScroller), function(cb)  textureScroller = cb end)) then
                SetPedPropIndex(GetPlayerPed(-1), componentScroller, subComponentScroller, textureScroller, false)
            end
        end)
        Menu.addOption("clothing_accessories", function()
            if(Menu.ScrollBarStringSelect({"Fjern Hjelme","Fjern Briller","Fjern Øreringe","Fjern venstre håndled","Fjern højre håndled"}, removeScroller, function(cb)  removeScroller = cb end)) then
                if removeScroller ~= 3 and removeScroller ~= 4 then
                    ClearPedProp(GetPlayerPed(-1), tonumber(removeScroller))
                elseif removeScroller == 3 then
                    ClearPedProp(GetPlayerPed(-1), 6)
                else
                    ClearPedProp(GetPlayerPed(-1), 7)
                end
            end
        end)
        Menu.addOption("clothing_accessories", function()
            if(Menu.Option("Tilfældig"))then
                SetPedRandomProps(GetPlayerPed(-1))
            end
        end)
    else
        local precomponentTable = {"Hatte/Hjelme","Briller","Øreringe","Tom Plads","Tom Plads","Tom Plads","Venstre håndled","Højre håndled"}
        local componentTable = {}
        for i = 0, 7 do
            if GetNumberOfPedPropDrawableVariations(GetPlayerPed(-1), i) ~= 0 and GetNumberOfPedPropDrawableVariations(GetPlayerPed(-1), i) ~= false then
                componentTable[i+1] = precomponentTable[i+1]
            else
                componentTable[i+1] = "Tom Plads"
            end
        end
        componentScroller = 0
        subComponentScroller = GetPedDrawableVariation(GetPlayerPed(-1), componentScroller)
        textureScroller = GetPedTextureVariation(GetPlayerPed(-1), componentScroller)
        Menu.addOption("clothing_accessories", function()
            if(Menu.ScrollBarString(componentTable, componentScroller, function(cb)  componentScroller = cb end)) then
                subComponentScroller = GetPedPropIndex(GetPlayerPed(-1), componentScroller)
                textureScroller = GetPedPropTextureIndex(GetPlayerPed(-1), componentScroller)
            end
        end)
        Menu.addOption("clothing_accessories", function()
            if(Menu.ScrollBarInt("Komponenter", subComponentScroller, GetNumberOfPedPropDrawableVariations(GetPlayerPed(-1), componentScroller), function(cb)  subComponentScroller = cb end)) then
                SetPedPropIndex(GetPlayerPed(-1), componentScroller, 0, 240, 0)
                SetPedPropIndex(GetPlayerPed(-1), componentScroller, subComponentScroller, textureScroller, false)
                textureScroller = 0
            end
        end)
        Menu.addOption("clothing_accessories", function()
            if(Menu.ScrollBarInt("Textures", textureScroller, GetNumberOfPedTextureVariations(GetPlayerPed(-1), componentScroller, subComponentScroller), function(cb)  textureScroller = cb end)) then
                SetPedPropIndex(GetPlayerPed(-1), componentScroller, subComponentScroller, textureScroller, false)
            end
        end)
        Menu.addOption("clothing_accessories", function()
            if(Menu.ScrollBarStringSelect({"Fjern Hjelme","Fjern Briller","Fjern Øreringe","Fjern venstre håndled","Fjern højre håndled"}, removeScroller, function(cb)  removeScroller = cb end)) then
                if removeScroller ~= 3 and removeScroller ~= 4 then
                    ClearPedProp(GetPlayerPed(-1), tonumber(removeScroller))
                elseif removeScroller == 3 then
                    ClearPedProp(GetPlayerPed(-1), 6)
                else
                    ClearPedProp(GetPlayerPed(-1), 7)
                end
            end
        end)
        Menu.addOption("clothing_accessories", function()
            if(Menu.Option("Tilfældig"))then
                SetPedRandomProps(GetPlayerPed(-1))
            end
        end)
    end
end

function overlays(title)
    Menu.SetupMenu("clothing_overlays", title)
    Menu.Switch("clothing_main", "clothing_overlays")
    if GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("player_one") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("player_two") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("player_zero")then
        componentScroller = 0
        subComponentScroller = GetPedHeadOverlayValue(GetPlayerPed(-1), componentScroller)
        Menu.addOption("clothing_overlays", function()
            if(Menu.ScrollBarString({"Pletter","Ansigtshår","Øjenbryn","Aging","Makeup","Rødme","Teint","Solskader","Læbestift","Mol/fregner","Brysthår","Kropssmerter","Tilføj Kropssmerter"}, componentScroller, function(cb)  componentScroller = cb end)) then
                subComponentScroller = GetPedHeadOverlayValue(GetPlayerPed(-1), componentScroller)
            end
        end)
        Menu.addOption("clothing_overlays", function()
            if(Menu.ScrollBarInt("Komponenter", subComponentScroller, GetNumHeadOverlayValues(GetPlayerPed(-1), componentScroller), function(cb)  subComponentScroller = cb end)) then
                SetPedHeadOverlay(GetPlayerPed(-1), componentScroller, subComponentScroller, 1.0)
                opacityScroller = 1.0
            end
        end)
        Menu.addOption("clothing_overlays", function()
            if(Menu.ScrollBarInt("Gennemsigtighed", opacityScroller, 10, function(cb)  opacityScroller = cb end)) then
                SetPedHeadOverlay(GetPlayerPed(-1), componentScroller, subComponentScroller, tonumber(opacityScroller/10))
                player_data.overlays.opacity[componentScroller+1] = tonumber(opacityScroller/10)
            end
        end)
        Menu.addOption("clothing_overlays", function()
            if(Menu.ScrollBarInt("Farver", colourScroller, 63, function(cb)  colourScroller = cb end)) then
                local colourType = 0
                if componentScroller == 1 or componentScroller == 2 or componentScroller == 10 then colourType = 1 elseif componentScroller == 5 or componentScroller == 8 then colourType = 2 else colourType = 0 end
                SetPedHeadOverlayColor(GetPlayerPed(-1), componentScroller, colourType, colourScroller, colourScroller)
                player_data.overlays.colours[componentScroller+1] = {colourType = colourType, colour = colourScroller}
            end
        end)
    else
    end
end

function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

AddEventHandler("clothes:changemodel", function(skin)
    local model = GetHashKey(skin)
    if IsModelInCdimage(model) and IsModelValid(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end
        local health = GetEntityHealth(PlayerPedId())
        SetPlayerModel(PlayerId(), model)
        SetEntityHealth(PlayerPedId(),health)
        if skin ~= "mp_f_freemode_01" and skin ~= "mp_m_freemode_01" then
            SetPedRandomComponentVariation(GetPlayerPed(-1), true)
        else
            SetPedComponentVariation(GetPlayerPed(-1), 11, 0, 240, 0)
            SetPedComponentVariation(GetPlayerPed(-1), 8, 0, 240, 0)
            SetPedComponentVariation(GetPlayerPed(-1), 11, 6, 1, 0)
        end
        SetModelAsNoLongerNeeded(model)
    else
    end
end)

AddEventHandler("clothes:setComponents", function()
    if GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01") or GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01") then
        for i = 0, 11 do
            if i == 0 then
                SetPedHeadBlendData(GetPlayerPed(-1), player_data.clothing.drawables[i+1], player_data.clothing.drawables[i+1], 0, player_data.clothing.drawables[i+1], player_data.clothing.drawables[i+1], 0, 0.5, 0.5, 0.0, false)
            elseif i == 2 then
                SetPedComponentVariation(GetPlayerPed(-1), i, player_data.clothing.drawables[i+1], 0, 1)
                SetPedHairColor(GetPlayerPed(-1), player_data.clothing.textures[i+1], player_data.clothing.textures[i+1])
            else
                SetPedComponentVariation(GetPlayerPed(-1), i, player_data.clothing.drawables[i+1], player_data.clothing.textures[i+1], player_data.clothing.palette[i+1])
            end
        end
        for i = 0, 7 do
            SetPedPropIndex(GetPlayerPed(-1), i, player_data.props.drawables[i+1], player_data.props.textures[i+1], false)
        end
        for i = 0, 12 do
            SetPedHeadOverlay(GetPlayerPed(-1), i, player_data.overlays.drawables[i+1], player_data.overlays.opacity[i+1])
            SetPedHeadOverlayColor(GetPlayerPed(-1), i, player_data.overlays.colours[i+1].colourType, player_data.overlays.colours[i+1].colour, player_data.overlays.colours[i+1].colour)
        end
    else
        for i = 0, 11 do
            SetPedComponentVariation(GetPlayerPed(-1), i, player_data.clothing.drawables[i+1], player_data.clothing.textures[i+1], player_data.clothing.palette[i+1])
        end
        for i = 0, 7 do
            SetPedPropIndex(GetPlayerPed(-1), i, player_data.props.drawables[i+1], player_data.props.textures[i+1], false)
        end
    end
end)
