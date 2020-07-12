local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_kikkert")


--SERVER EVENTET--



RegisterNetEvent('vrp_breakin:checkC4')
AddEventHandler('vrp_breakin:checkC4', function(k, coords, closeDoor)
local player = source
  local user_id = vRP.getUserId({player})
  if vRP.tryGetInventoryItem({user_id, "c4", 1, false}) then
    TriggerClientEvent("vrp_breakin:effects", player, k, coords, closeDoor)
    Wait(5000)
    TriggerClientEvent("vrp_breakin:sounds", player, k, coords)
    Wait(5000)
    TriggerEvent("cn-emotes:effects",coords,"core","exp_grd_plane_sp",{default={0.0, 0.0, -0.1, -90.0, 0.0, 20.0,11816},female={0.0, 0.0, -0.55, 0.0, 0.0, 20.0,11816}},"entity",5000)
    TriggerEvent("vrp_doors:changeStatus", k, false)
  end
end)
