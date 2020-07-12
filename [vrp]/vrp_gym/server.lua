--[[
========================================================
=============== PROJECT: vRP Gym =======================
=============== SCRIPTER: DGVaniX ======================
=============== DATE: 03/11/2018 =======================
========================================================
]]

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_gym")
vRPCgym = Tunnel.getInterface("vRP_gym","vRP_gym")

vRPgym = {}
Tunnel.bindInterface("vRP_gym",vRPgym)
Proxy.addInterface("vRP_gym",vRPgym)

members = {}

gymTable = {
	["biceps1"] = {-1198.9050, -1564.1252, 4.1115, "Z-Bar Biceps"},
	["abdo"] = {-1197.7672, -1571.3300, 4.1115, "Mavebøjninger"},
	["biceps2"] = {-1210.0610, -1560.6418, 4.1115, "Z-Bar (Biceps)"},
	["yoga"] = {-1204.2547, -1556.8259, 4.1115, "Yoga"},
	["tractiuni1"] = {-1200.1284, -1570.9903, 4.1115, "Pull-Ups"},
	["tractiuni2"] = {-1204.7150, -1564.3831, 4.1115, "Pull-Ups"},
	["flotari"] = {-1194.1945, -1570.1912, 4.1115, "Push-Ups"},
	["bench1"] = {-1197.1033, -1567.5870, 4.1115, "Bænk"},
	["bench2"] = {-1200.6325, -1575.8344, 4.1115, "Bænk"},
	["bench3"] = {-1206.4871, -1561.5948, 4.1115, "Bænk"},
	["bench4"] = {-1201.4362, -1562.7670, 4.1115, "Bænk"},

	["tractiuni3"] = {1643.1925048828,2527.8122558594,45.564861297607, "Pull-Ups"},
	["tractiuni4"] = {1649.3120117188,2529.6716308594,45.564861297607, "Pull-Ups"},
	["bench5"] = {1639.1961669922,2523.345703125,45.564861297607, "Bænk"},
	["bench6"] = {1634.6540527344,2527.5446777344,45.566368103027, "Bænk"},
	["bench7"] = {1636.9792480469,2530.6484375,45.56489944458, "Bænk"},
	["bench8"] = {1639.7114257813,2533.5915527344,45.564933776855, "Bænk"},
	["flotari1"] = {1648.2584228516,2533.9462890625,45.564895629883, "Push-Ups"},
	["abdo1"] = {1637.0346679688,2522.4291992188,45.5648956298835, "Mavebøjninger"},
	["biceps3"] = {1642.857421875,2524.4274902344,45.564895629883, "Z-Bar (Biceps)"},
	["biceps4"] = {1646.5893554688,2535.8071289063,45.564895629883, "Z-Bar (Biceps)"},
}

theGym = {-1195.4376, -1577.6749, 4.1115}
thePrisonGym = {1643.80859375,2540.0791015625,45.56485748291}

workouts = {
	["PROP_HUMAN_MUSCLE_CHIN_UPS"] = {"tractiuni1", "tractiuni2" , "tractiuni3" , "tractiuni4"},
	["WORLD_HUMAN_MUSCLE_FREE_WEIGHTS"] = {"biceps1", "biceps2" , "biceps3" , "biceps4"},
	["WORLD_HUMAN_SIT_UPS"] = {"abdo", "abdo1"},
	["WORLD_HUMAN_YOGA"] = {"yoga"},
	["WORLD_HUMAN_PUSH_UPS"] = {"flotari" , "flotari1"},
	["PROP_HUMAN_SEAT_MUSCLE_BENCH_PRESS"] = {"bench1", "bench2", "bench3", "bench4", "bench5", "bench6", "bench7", "bench8"}
}

gym_menu = {name="Gym Shop",css={top="75px", header_color="rgba(0,125,255,0.75)"}}

AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
	if first_spawn then
		thePlayer = vRP.getUserSource({user_id})
		vRPCgym.populateGymTable(thePlayer, {gymTable, theGym, thePrisonGym})
	end
end)

function vRPgym.initWorkout(workout)
	thePlayer = source
	for i, v in pairs(workouts) do
		workTable = v
		for k, vl in pairs(workTable) do
			if(vl == workout)then
				vRPCgym.startWorkout(thePlayer, {i})
				break
			end
		end
	end
end

function vRPgym.gainStrenght(strenght)
	user_id = vRP.getUserId({source})
	
	local parts = splitString("physical.strength",".")
    if #parts == 2 then
        vRP.varyExp({user_id,parts[1],parts[2],tonumber(strenght)})
    end
end

function vRPgym.hasMembership()
	thePlayer = source
	user_id = vRP.getUserId({thePlayer})
	if(user_id ~= nil)then
		if(members[user_id] == true)then
			return true
		else
			return false
		end
	end
end

function buyMembership(player, choice)
	user_id = vRP.getUserId({player})
	if(members[user_id] ~= true)then
		if(vRP.tryBankPaymentOrDebt({user_id, 1500}))then
			members[user_id] = true
			vRPclient.notify(player, {"~w~[GYM] ~g~Du har betalt 1500 DKK for et 1 dags gym medlemskab! Du kan nu bruge de forskellige trænings muligheder!"})
		else
			vRPclient.notify(player, {"~w~[GYM] ~r~Du har ikke nok penge til medlemskab"})
		end
	else
		vRPclient.notify(player, {"~w~[GYM] ~r~Du har allerede et gym medlemskab"})
	end
	vRP.closeMenu({player})
end

function cancelMembership(player, choice)
	user_id = vRP.getUserId({player})
	if(members[user_id] == true)then
		members[user_id] = false
		vRPclient.notify(player, {"~w~[GYM] ~g~Du har aflyst dit gym medlemskab"})
	else
		vRPclient.notify(player, {"~w~[GYM] ~r~Du har ikke et gym medlemskab!"})
	end
	vRP.closeMenu({player})
end



RegisterServerEvent("showGymMenu")
AddEventHandler("showGymMenu", function()
	thePlayer = source
	if(members[user_id] ~= true)then
		gym_menu["Open Membership"] = {buyMembership, "Køb et gym medlemskab for 1 dag<br>Pris: <font color='red'>1500 DKK</font>"}
		gym_menu["Cancel Membership"] = nil
	else
		gym_menu["Cancel Membership"] = {cancelMembership, "Annuller dit medlemskab"}
		gym_menu["Open Membership"] = nil
	end
	vRP.openMenu({thePlayer,gym_menu})
end)
