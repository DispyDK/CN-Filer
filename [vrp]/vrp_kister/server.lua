local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_chests")

--- Config
-- list of static chests
-- {access, x, y, z, name-optional}
-- access = can be user_id, user_permission or user_group. Set it to "none" to give to all players access to the chest.
-- name = if you have multiple chests with same access you need to set different name, or the chests with same access will containt same items.
local chests = {}
chests = {
	{"police.menu", 477.68280029297,-982.70867919922,24.914762496948, "Politi lager"},
	{"police.menu", 1843.3240966797,3683.384765625,30.267953872681, "Politi lager sandyPD"},
	{"police.menu", 1838.4002685547,3683.9045410156,30.267911911011, "Politi lager sandyPD 2"},
	{"police.menu", -442.19360351563,5987.4458007813,31.716171264648, "Politi lager PaletoPD"},
	{"drugdealer.menu", 3051.5007324219,-4714.7666015625,6.2449712753296, "Drugdealer lager"},
	{"druglord.adgang" , 3052.6169433594,-4719.81640625,6.2449717521667, "Druglord lager"},
	{"forsyningen.loadshop", -157.85681152344,6154.2490234375,31.206373214722, "Forsyningen lager"},
	{"weapons.dealer", 907.90069580078,-3211.3923339844,-98.221969604492, "Fælles Lager"},
	{"weapons.dealer", 910.07727050781,-3210.3610839844,-98.222267150879, "Madses Lager"},
	{'weapons.dealer', 807.81927490234,-2159.6848144531,29.619010925293, 'Weapon Dealer Shop'},
	{"weapons.dealer", 907.50170898438,-3203.6411132813,-97.187957763672, "Weapon Dealer"},
	{"weapons.dealer", 905.82775878906,-3208.4936523438,-97.187881469727, "Weapon Dealer Materiale"},
	{"casinomanager.adgang", 1114.8880615234,244.03031921387,-46.340969085693, "Casino Lager"}
}
-- I've put some random locations just for test, change them.
---#

local function create_pleschest(owner_access, x, y, z, player, name)
	local namex = name or "chest"

	local chest_enter = function(player, area)
		local user_id = vRP.getUserId({player})
		if user_id ~= nil then
			if owner_access == "none" or user_id == tonumber(owner_access) or vRP.hasGroup({user_id, owner_access}) or vRP.hasPermission({user_id, owner_access}) then
				vRP.openChest({player, "static:"..owner_access..":"..namex, 1000000, nil, nil, nil})
			end
		end
	end

	local chest_leave = function(player,area)
		vRP.closeMenu({player})
	end

	local nid = "vRP:static-"..namex..":"..owner_access
	vRP.setArea({player,nid,x,y,z,1,1.5,chest_enter,chest_leave})
	vRPclient.addMarker(player,{x,y,z-0.87,0.7,0.7,0.5,0,255,125,125,150})
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
  if first_spawn then
	for k, v in pairs(chests) do
		create_pleschest(v[1], v[2], v[3], v[4], source, v[5])
		--TriggerClientEvent('chatMessage', -1, "Chest created: "..v[1]..", "..v[2]..", "..v[3]..", "..v[4]..", "..v[5]..".") -- debuging.
	end
  end
end)
