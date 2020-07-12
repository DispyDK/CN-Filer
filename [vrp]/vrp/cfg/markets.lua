
local cfg = {}

-- define market types like garages and weapons
-- _config: blipid, blipcolor, permissions (optional, only users with the permission will have access to the market)

cfg.market_types = {

	["Juvelbutik"] = {
		_config = {blipid=617, blipcolor=42}, --
		["soelvring"] = 200000,
		["guldring"] = 500000,
		["diamantring"] = 750000
	},

	["Værktøjskasser"] = {
		_config = {permissions = {"repair.loadshop"}},
		["repairkit"] = 25,
		["key_ca"] = 5,
	},

	["Dykker Udstyr"] = {
		_config = {},
		["dive"] = 5000
	}
}

-- list of markets {type,x,y,z}

cfg.markets = {
	----  [ Stay ] ----
	{"Dykker Udstyr", -1218.5515136719,-1516.1329345703,4.3798451423645, true},
	{"Værktøjskasser", -216.46533203125,-1318.8717041016,30.890382766724, true},
	{"Værktøjskasser", 1764.8836669922,3332.1391601563,41.438529968262, true},
	{"Juvelbutik", -623.05627441406,-233.07986450195,38.057060241699, true},
}

return cfg
