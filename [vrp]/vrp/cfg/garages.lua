
local cfg = {}
-- define garage types with their associated vehicles
-- (vehicle list: https://wiki.fivem.net/wiki/Vehicles)

-- each garage type is an associated list of veh_name/veh_definition
-- they need a _config property to define the blip and the vehicle type for the garage (each vtype allow one vehicle to be spawned at a time, the default vtype is "default")
-- this is used to let the player spawn a boat AND a car at the same time for example, and only despawn it in the correct garage
-- _config: vtype, blipid, blipcolor, permissions (optional, only users with the permission will have access to the shop)

cfg.rent_factor = 0.1 -- 10% of the original price if a rent
cfg.sell_factor = 0.60 -- sell for 75% of the original price

cfg.garage_types = {

	-- JOBS GARAGES
	--["Gumphermarket"] = {
	--	_config = {vtype="default", permissions = {"gumphermarket.garage"}},
	--	["rumpog"] = {"Rumpo Gumphermarket", 0, ""},
	--},
	["Taxa"] = {
		_config = {vtype="default", blipid=198, blipcolor=5, permissions = {"taxi.garage"}},
		["CN_TAXI"] = {"Vapid Stanier", 0, ""},
		["TAXI_DRT1993"] = {"Tourbus", 0, ""},
	},
	["Indbrudstyv"] = {
		_config = {vtype="default", blipid=67, blipcolor=59, permissions = {"indbrudstyv.adgang"}},
		["boxville"] = {"Kassevogn", 100000, "Indbrud kan kun forgå om natten"},
		["boxville2"] = {"Kassevogn2", 100000, "Indbrud kan kun forgå om natten"},
		["boxville3"] = {"Kassevogn3", 100000, "Indbrud kan kun forgå om natten"},
		["boxville4"] = {"Kassevogn4", 100000, "Indbrud kan kun forgå om natten"}
	},
	["The High Table Garage"] = {
		_config = {vtype="default", permissions = {"drugdealer.garage"}},
		["NIGHTSHARK"] = {"Amored OFF-Roader", 0, ""},
		["XLS2"] = {"Armored SUV", 0, ""},
		["BRICKADE"] = {"Armored Lastbil", 0, ""},
		["VACCA"] = {"Sports bil", 0, ""},
		["benson"] = {"Lastbil", 0, ""},
		["SCHAFTER6"] = {"Armored Schafter", 0, ""},
		["BALLER5"] = {"Armored Baller", 0, ""},
		["COG552"] = {"Armored Cognoscenti", 0, ""},

	},

	["The High Table Luftfart"] = {
		_config = {vtype="default", permissions = {"drugdealer.garage"}},
		["nimbus"] = {"Mexikanske luksus fly", 0, ""},
		["avenger"] = {"Lastfly", 0, ""},
		["buzzard2"] = {"Narkokartel Helikopter", 0, ""},
		["tula"] = {"Vand lastfly", 0, ""},
		["cargobob2"] = {"Lasthelikopter", 0, ""},
		["seasparrow"] = {"vandheli", 0, ""},
	},
	["The High Table Både"] = {
		_config = {vtype="default", permissions = {"drugdealer.garage"}},
		["Dinghy4"] = {"Speedgummi båd", 0, ""},
		["tug"] = {"Lastbåd (STOR)", 0, ""},
		["submersible2"] = {"Ubåd", 0, ""},
	},

	["Både"] = {
		_config = {vtype="boat",blipid=427,blipcolor=4},
		["seashark"] = {"Jetski",50000, ""},
		["toro"] = {"Toro",350000, ""},
		["jetmax"] = {"Jetmax",575000, ""},
		["marquis"] = {"Yacht",999000, ""},
		["suntrap"] = {"Suntrap",400000, ""}
	},
	["Både Politi"] = {
    		_config = {vtype="default",blipid=427,blipcolor=2, permissions = {"police.garage"}},
    		["Dinghy4"] = {"Speedgummi båd",0, ""},
    		["Predator"] = {"Politibåd",0, ""},

    	},

	["Helikopter Politiet"] = {
		_config = {vtype="helicopter", permissions = {"police.garage"}},
		["EAS350EP"] = {"Helikopter",0,""}
	},

	["Helikopter EMS"] = {
		_config = {vtype="helicopter",blipid=0,blicolor=0, permissions = {"emergency.garage"}},
		["EAS350EA"] = {"Helikopter",0,""}
	},

	["Ejendomsmægler Garage"] = {
		_config = {vtype="default", permissions = {"realestate.duty"}},
		["EM_BG2019"] = {"Bravado", 0, ""}
	},
	
	["Kørelærer Garage"] = {
		_config = {vtype="default", permissions = {"kørelærer.adgang"}},
		["SKOLE_BBS2009"] = {"Buffalo S Skolevogn", 0, ""},
		["buffalo2"] = {"Buffalo S", 0, ""}
	},

	["Politi Garage"] = {
		_config = {vtype="default", permissions = {"police.garage"}},
		["bcpd10"] = {"01 Lampadati Felon (U)", 0, ""},
		["FIBP62"] = {"02 Vapid Scout (U)", 0, ""},
		["RAIDENP"] = {"03 Coil Raiden (U)", 0, ""},
		["bcpd6"] = {"04 Übermacht Sentinel XS (U)", 0, ""},
		["PMCV"] = {"05 Shitzu Hakuchou (M)", 0,""},
		["BF400P"] = {"06 Nagasaki BF-400 (M)", 0, ""},
		["UO2018U"] = {"07 Oracle 2018 (C)", 0, ""},
		["KSRS2018U"] = {"08 Sultan RS 2018 (C)", 0, ""},
		["bcpd7"] = {"09 Annis Elegy RH8 (!)", 0, ""},
		["FIBP62HP"] = {"10 Vapid Scout (K9)", 0, ""},
		["riot"] = {"11 Lenco Bearcat (!)", 0, ""},
		["PRISONBUS"] = {"12 Fængsels bus (!)", 0, ""},
		["burrito3"] = {"13 Fotovogn (!)", 0, ""},
	},


	["EMS Bil"] = {
		_config = {vtype="default", permissions = {"emergency.garage"}},
		["STEEDAMB"] = {"1. Ambulance", 0, ""},
		["bcpd10a"] = {"2. Lampadati Felon (Akut)", 0, ""},
	},

	["Domingo Auto"] = {
		_config = {vtype="default",blipid=68,blipcolor=4, permissions = {"domingo.loadshop"}},
		["DA_CS2015M"] = {"Suburban 2015", 0, "Service vogn 2"},
		["DA_DRV2003M"] = {"Dodge Ram Van 2003", 0, "Reklame vogn"},
		["DA_MTLFB2013M"] = {"MTL Flatbed 2013", 0, "Autotransporter vogn 1."},
	},

	["Minebilen"] = {
		_config = {vtype="default",blipid=318,blipcolor=4,permissions = {"miner.adgang"}},
		["tiptruck"] = {"Minebilen", 50000,""}
	},

	["Super Mechanics"] = {
		_config = {vtype="default",blipid=89,blipcolor=59, permissions = {"civilians.loadshop"}},
		["SM_MTLFB2013M"] = {"MTL Flatbed 2013", 0, "Autotransporter."},
		["SM_TT"] = {"Tow Truck", 0, "Autotransporter."},
	},
	
	["Innovation Auto"] = {
		_config = {vtype="default",blipid=89,blipcolor=59, permissions = {"domingo.loadshop"}},
		["INNO_TT"] = {"Tow Truck", 0, "Autotransporter."},
	},

	["Skraldevogn"] = {
		_config = {vtype="default",blipid=318,blipcolor=4, permissions = {"skralde.vehicle"}},
		["trash"] = {"Skraldevogn", 1000,""}
	},
	["Skovhugger"] = {
		_config = {vtype="default",blipid=318,blipcolor=4, permissions = {"skov.vehicle"}},
		["scrap"] = {"Truck", 10000,""}
	},

	["Lastbil garage"] = {
		_config = {vtype="default",blipid=477,blipcolor=4,permissions={"trucker.vehicle"}},
		["phantom"] = {"Phantom",0, ""},
		["packer"] = {"Packer",0, ""}
	},

	["Sikkerhedsvagt garage"] = {
		_config = {vtype="default",blipid=477,blipcolor=4,permissions={"security.vehicle"}},
		["SV2020"] = {"Merryweather Baller",0, ""},
	},

	["Cykel garage"] = {
		_config = {vtype="default",blipid=226,blipcolor=69},
		["bmx"] = {"BMX",1000, ""},
		["cruiser"] = {"Cruiser",1500, ""},
		["fixter"] = {"Fixter",2000, ""},
		["Scorcher"] = {"Scorcher Mountain Bike",2500, ""},
		["JAPBICYCLE"] = {"Japansk Cykel",1299, ""},
		["tribike"] = {"Racer cykel #1",4000, ""},
		["tribike2"] = {"Racer cykel #2",4000, ""},
		["tribike3"] = {"Racer cykel #3	",4000, ""}
	},

	["Forsyningen"] = {
		_config = {vtype="default",blipid=68,blipcolor=4, permissions = {"forsyningen.loadshop"}},
		["RUMPOF"] = {"Forsyningens rumpo", 0, ""},
	},

	["Helikopter Garage"] = {
		_config = {vtype="default",blipid=360,blipcolor=3, permissions = {"helikopter.adgang"}},
		["havok"] = {"Nagasaki Havok (1)",17500000, ""},
		["buzzard2"] = {"Nagasaki Buzzard (4)",25000000, ""},

	},

}

-- {garage_type,x,y,z,hidden,large}
cfg.garages = {
	{"EMS Bil",1813.4295654297,3685.4643554688,34.224239349365, true, true},--EMS Sandy
	{"EMS Bil",241.85296630859,-565.96429443359,43.278755187988, true, true},-- Midtby
	{"Super Mechanics",546.40753173828,-209.76663208008,53.663707733154, true, true},--midtby
	{"Innovation Auto",-172.62983703613,-1367.3217773438,30.220600128174, true, true},--midtby
	{"Sikkerhedsvagt garage",-38.941093444824,-786.78863525391,43.871754760742, true, true},
	{"Helikopter EMS",352.40744018555,-588.03961181641,74.165657043457, true, true},
	{"Helikopter EMS",1867.1141357422,3646.1313476563,35.605903625488, true, true},
	{"Helikopter Politiet",449.51892089844,-987.99310302734,43.691665649414, true, true},
	{"Helikopter Politiet",-475.13912963867,5988.3642578125,31.336708068848, true, true},
	{"Helikopter Politiet",1867.1141357422,3646.1313476563,35.605903625488, true, true},
	{"Både Politi",-681.26495361328,6165.017578125,0.25208702683449, false, false},
    {"Både Politi",-3291.5266113281,1189.5262451172,0.17722804844379, false, false},
    {"Både Politi",1621.1612548828,3902.8767089844,30.560333251953, false, false},
    {"Både Politi",2805.8913574219,-850.19763183594,0.40806207060814, false, false},
    {"Både Politi",16.380355834961,-2805.4892578125,-0.40078911185265, false, false},
	{"Både",-2013.9351806641,-1041.3424072266,-0.4406553208828, false, false},
	{"Både",-785.62957763672,-1498.5974121094,-0.086649641394615, false, false},
	{"Både",1571.1760253906,3845.3767089844,30.856819152832, false, false},
	{"Både",-1806.4201660156,-988.86822509766,0.074662901461124, false, false},
	{"Både",3845.25390625,4445.0776367188,-0.017860990017653, false, false},
	{"Både",139.64183044434,3833.4389648438,29.600109100342, false, false},
	{"Både",2812.4978027344,-845.96112060547,0.020922610536218, false, false},
	{"Både",12.137045860291,-2805.5737304688,-0.40212666988373, false, false},
	{"Politi Garage", 449.77325439453,-1018.7691040039,28.513710021973, true, true},
	{"Politi Garage", 1863.0129394531,3704.1630859375,33.439643859863, true, true},
	{"Politi Garage", -452.27276611328,5994.9067382813,31.340549468994, true, true},
	{"Taxa", 915.24536132813,-165.7215423584,74.482749938965, false, false},
	{"Minebilen", 496.79681396484,-1970.5522460938,24.905403137207, false, false},
	{"Minebilen", 2681.2834472656,2821.2709960938,40.435745239258, false, false},
	{"Skraldevogn", 1540.0747070313,-2093.2795410156,77.100486755371, false, false},
	{"Skovhugger", -579.33636474609,5243.3696289063,70.46947479248, false, false},
	{"Lastbil garage",160.06260681152,6407.921875,31.162828445435, false, false},
	{"Lastbil garage",548.78143310547,-1926.2774658203,24.81053352356, false, false},
	{"Cykel garage",256.87316894531,-783.86700439453,30.507152557373, false, false},
	{"Cykel garage",110.01765441895,-1924.8909912109,20.751617431641, false, false},
	{"Cykel garage",-105.62579345703,-613.40588378906,36.0758934021, true, true},
	{"Cykel garage",-8.7785520553589,-1474.8852539063,30.509767532349, true, true},
	{"Ejendomsmægler Garage", -101.63906860352,-601.24407958984,36.073963165283, true, false},
	{"Kørelærer Garage", -1023.0930175781,-1520.3654785156,5.5920186042786, true, false},
	{"Indbrudstyv", 490.38961791992,-1334.2969970703,29.328872680664, false, false},
	{"Gumphermarket", 15.692157745361,-1342.8907470703,29.287052154541, false, false},
    {"The High Table Garage", 3110.1694335938,-4762.001953125,15.257628440857, true, true},
    {"The High Table Garage", 493.90014648438,-3370.0673828125,6.06991291046147, true, true},
    {"The High Table Luftfart", 2134.1174316406,4809.7958984375,41.19596862793, true, true},
    {"The High Table Luftfart", 3094.1711425781,-4798.5600585938,15.261610984802, true, true},
	{"The High Table Luftfart", -1639.5635986328,-3120.9931640625,13.945010185242, true, true},
    {"The High Table Luftfart", 478.45867919922,-3369.8110351563,6.0699071884155, true, true},
	{"The High Table Både", 463.41473388672,-3380.5424804688,0.228886370360851, true, true},
	{"The High Table Både", 3038.6135253906,-4800.7841796875,0.2400504112244, true, true},
	{"Helikopter Garage", 2107.5886230469,3200.3618164063,46.324890136719, false, true},
	{"Helikopter Garage", 99.770179748535,6721.134765625,43.001876831055, false, true},
	{"Helikopter Garage", -1112.4040527344,-2883.9580078125,13.946011543274, false, true},
}

return cfg
