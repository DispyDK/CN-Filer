local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

local weapons = {
    "wbody|WEAPON_HOMINGLAUNCHER",
    "wbody|WEAPON_PROXMINE",
    "wbody|WEAPON_SNOWBALL",
    "wbody|WEAPON_RAILGUN",
    "wbody|WEAPON_ANIMAL",
    "wbody|WEAPON_COUGAR",
    "wbody|WEAPON_KNIFE",
    "wbody|WEAPON_NIGHTSTICK",
    "wbody|WEAPON_HAMMER",
    "wbody|WEAPON_BAT",
    "wbody|WEAPON_GOLFCLUB",
    "wbody|WEAPON_CROWBAR",
    "wbody|WEAPON_PISTOL",
    "wbody|WEAPON_COMBATPISTOL",
    "wbody|WEAPON_APPISTOL",
    "wbody|WEAPON_PISTOL50",
    "wbody|WEAPON_MICROSMG",
    "wbody|WEAPON_SMG",
    "wbody|WEAPON_ASSAULTSMG",
    "wbody|WEAPON_ASSAULTRIFLE",
    "wbody|WEAPON_CARBINERIFLE",
    "wbody|WEAPON_ADVANCEDRIFLE",
    "wbody|WEAPON_MG",
    "wbody|WEAPON_COMBATMG",
    "wbody|WEAPON_PUMPSHOTGUN",
    "wbody|WEAPON_SAWNOFFSHOTGUN",
    "wbody|WEAPON_ASSAULTSHOTGUN",
    "wbody|WEAPON_BULLPUPSHOTGUN",
    "wbody|WEAPON_STUNGUN",
    "wbody|WEAPON_SNIPERRIFLE",
    "wbody|WEAPON_HEAVYSNIPER",
    "wbody|WEAPON_REMOTESNIPER",
    "wbody|WEAPON_GRENADELAUNCHER",
    "wbody|WEAPON_GRENADELAUNCHER_SMOKE",
    "wbody|WEAPON_RPG",
    "wbody|WEAPON_STINGER",
    "wbody|WEAPON_MINIGUN",
    "wbody|WEAPON_GRENADE",
    "wbody|WEAPON_STICKYBOMB",
    "wbody|WEAPON_SMOKEGRENADE",
    "wbody|WEAPON_BZGAS",
    "wbody|WEAPON_MOLOTOV",
    "wbody|WEAPON_FIREEXTINGUISHER",
    "wbody|WEAPON_FLARE",
    "wbody|WEAPON_SNSPISTOL",
    "wbody|WEAPON_BOTTLE",
    "wbody|WEAPON_GUSENBERG",
    "wbody|WEAPON_SPECIALCARBINE",
    "wbody|WEAPON_HEAVYPISTOL",
    "wbody|WEAPON_BULLPUPRIFLE",
    "wbody|WEAPON_DAGGER",
    "wbody|WEAPON_VINTAGEPISTOL",
    "wbody|WEAPON_FIREWORK",
    "wbody|WEAPON_MUSKET",
    "wbody|WEAPON_HEAVYSHOTGUN",
    "wbody|WEAPON_MARKSMANRIFLE",
    "wbody|WEAPON_HOMINGLAUNCHER",
    "wbody|WEAPON_PROXMINE",
    "wbody|WEAPON_SNOWBALL",
    "wbody|WEAPON_FLAREGUN",
    "wbody|WEAPON_GARBAGEBAG",
    "wbody|WEAPON_HANDCUFFS",
    "wbody|WEAPON_COMBATPDW",
    "wbody|WEAPON_MARKSMANPISTOL",
    "wbody|WEAPON_KNUCKLE",
    "wbody|WEAPON_HATCHET",
    "wbody|WEAPON_RAILGUN",
    "wbody|WEAPON_MACHETE",
    "wbody|WEAPON_MACHINEPISTOL",
    "wbody|WEAPON_SWITCHBLADE",
    "wbody|WEAPON_REVOLVER",
    "wbody|WEAPON_DBSHOTGUN",
    "wbody|WEAPON_COMPACTRIFLE",
    "wbody|WEAPON_AUTOSHOTGUN",
    "wbody|WEAPON_BATTLEAXE",
    "wbody|WEAPON_COMPACTLAUNCHER",
    "wbody|WEAPON_MINISMG",
    "wbody|WEAPON_PIPEBOMB",
    "wbody|WEAPON_POOLCUE",
    "wbody|WEAPON_WRENCH",
    "wbody|WEAPON_SNOWBALL"
}


RegisterServerEvent('vrp_detector:check')
AddEventHandler('vrp_detector:check', function()
    local source = source
    local user_id = vRP.getUserId({source})

    local player = vRP.getUserSource({user_id})
    local cop = vRP.hasGroup({user_id,"Politi-Job"})
    local ems = vRP.hasGroup({user_id,"EMS-Job"})
    local advokat = vRP.hasGroup({user_id,"Politiadvokat-Job"})

    if not cop and not ems and not advokat and not aks  then
        local trigger = false
        local inv = vRP.getInventory({user_id})
        for k,v in pairs(inv) do
            if has_value(weapons, k) then
                trigger = true
            end
        end
        TriggerClientEvent('vrp_detector:gooff',player, trigger)
    end
end)


function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end