--[[
    FiveM Scripts
    Copyright C 2018  Sighmir

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    at your option any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

cfg = {}

cfg.blips = false -- enable blips

cfg.seconds = 300 -- seconds to rob

cfg.cooldown = 3600 -- time between robbaries

cfg.cops = 3 -- minimum cops online
cfg.permission = "bank.police" -- permission given to cops

cfg.banks = { -- list of banks
	["Midtby Bank"] = {
		mincops = 3,
		position = { ['x'] = 143.3666229248, ['y'] = -1043.1236572266, ['z'] = 29.367919921875 },
		nameofbank = "Midtby Bank",
		lastrobbed = 0,
		seconds = 300,
		type = "bank",
		door1 = vector3(146.89179992676,-1045.1602783203,29.368021011353),
		door2 = vector3(149.48538208008,-1047.3760986328,29.346326828003),
		door1ID = 394,
		door2ID = 395,
		model1 = 2121050683,
		model2 = -1591004109,
		doorheading = 250.5950012207,
		drill = vector3(148.4400177002,-1050.2366943359,29.346366882324),
		terminal = vector3(149.94789123535,-1045.84375,29.34628868103),
		cash = { 1800, 2200 }, -- this is what you receive every cash stack math.random(1, 2)
		model = GetHashKey("hei_prop_hei_cash_trolly_01"),
		["trolleys"] = {
			["left"] = {
				["pos"] = vector3(150.36444091797,-1049.7564697266,29.346405029297),
				["heading"] = 67.276466369629 + 0.0
			},
			["right"] = {
				["pos"] = vector3(146.75869750977,-1048.6015625,29.346298217773),
				["heading"] = 248.30834960938 + 0.0
			},
		},
	},
	["Nordea Bank"] = {
		mincops = 3,
		position = { ['x'] = -2958.2927246094, ['y'] = 477.44729614258, ['z'] = 15.69692325592 },
		nameofbank = "Nordea Bank (Vestlig Motorvej)",
		lastrobbed = 0,
		seconds = 300,
		type = "bank",
		door1 = vector3(-2957.4604492188,481.43911743164,15.697025299072),
		door2 = vector3(-2956.234375,484.50592041016,15.675326347351),
		door1ID = 392,
		door2ID = 393,
		model1 = -63539571,
		model2 = -1591004109,
		doorheading = 7.8995199203491,
		drill = vector3(-2953.1567382813,484.15643310547,15.675387382507),
		terminal = vector3(-2957.1232910156,484.87057495117,15.675311088562),
		cash = { 1800, 2200 }, -- this is what you receive every cash stack math.random(1, 2)
		model = GetHashKey("hei_prop_hei_cash_trolly_01"),
		["trolleys"] = {
			["left"] = {
				["pos"] = vector3(-2954.0903320313,486.38439941406,15.675416946411),
				["heading"] = 177.71559143066 + 0.0
			},
			["right"] = {
				["pos"] = vector3(-2954.1276855469,482.39407348633,15.67530632019),
				["heading"] = 354.95855712891 + 0.0
			},
		},
	},
	["Ringkjøbing LandboBank"] = {
		mincops = 3,
		position = { ['x'] = 1180.4053955078, ['y'] = 2711.1911621094, ['z'] = 38.087852478027 },
		nameofbank = "Ringkjøbing LandboBank (Sandy - The Motor Motel)",
		lastrobbed = 0,
		seconds = 300,
		type = "bank",
		door1 = vector3(1176.3171386719,2712.0217285156,38.088241577148),
		door2 = vector3(1173.0814208984,2713.173828125,38.066265106201),
		door1ID = 390,
		door2ID = 391,
		doorheading = 93.932060241699,
		model1 = 2121050683,
		model2 = -1591004109,
		drill = vector3(1173.1676025391,2716.2814941406,38.066307067871),
		terminal = vector3(1173.0489501953,2711.7868652344,38.066226959229),
		cash = { 1800, 2200 }, -- this is what you receive every cash stack math.random(1, 2)
		model = GetHashKey("hei_prop_hei_cash_trolly_01"),
		["trolleys"] = {
			["left"] = {
				["pos"] = vector3(1171.2133789063,2715.0869140625,38.066349029541),
				["heading"] = 267.35513305664 + 0.0
			},
			["right"] = {
				["pos"] = vector3(1175.2755126953,2715.1655273438,38.066272735596),
				["heading"] = 88.237678527832 + 0.0
			},
		},
	},
	["Jyske Bank"] = {
		mincops = 3,
		position = { ['x'] = -104.70536804199, ['y'] = 6468.8818359375, ['z'] = 31.626718521118 },
		nameofbank = "Jyske Bank (Paleto Bay)",
		lastrobbed = 0,
		seconds = 300,
		type = "bank",
		door1 = vector3(-105.60328674316,6472.0029296875,31.62670135498),
		door2 = vector3(-105.86994171143,6475.7109375,31.626710891724),
		door1ID = 388,
		door2ID = 389,
		doorheading = 49.370807647705,
		model1 = 1622278560,
		model2 = 1309269072,
		drill = vector3(-103.748878479,6478.0458984375,31.626705169678),
		terminal = vector3(-107.14981842041,6474.4907226563,31.626703262329),
		cash = { 1800, 2200 }, -- this is what you receive every cash stack math.random(1, 2)
		model = GetHashKey("hei_prop_hei_cash_trolly_01"),
		["trolleys"] = {
			["left"] = {
				["pos"] = vector3(-106.03469848633,6478.5405273438,31.626722335815),
				["heading"] = 225.81489562988 + 0.0
			},
			["right"] = {
				["pos"] = vector3(-102.9292678833,6475.5131835938,31.626722335815),
				["heading"] = 46.995166778564 + 0.0
			},

		},
	},
	["Sydbank"] = {
		mincops = 3,
		position = { ['x'] = -1215.4323730469, ['y'] = -337.1042175293, ['z'] = 37.780853271484 },
		nameofbank = "Sydbank (Rockford Hills - Vestlig Los Santos)",
		lastrobbed = 0,
		seconds = 300,
		type = "bank",
		door1 = vector3(-1211.3443603516,-336.00134277344,37.78112411499),
		door2 = vector3(-1208.0363769531,-335.56130981445,37.759269714355),
		door1ID = 386,
		door2ID = 387,
		doorheading = 302.54598999023,
		model1 = 2121050683,
		model2 = -1591004109,
		drill = vector3(-1206.71484375,-338.38235473633,37.759311676025),
		terminal = vector3(-1208.6274414063,-334.35485839844,37.759258270264),
		cash = { 1800, 2200 }, -- this is what you receive every cash stack math.random(1, 2)
		model = GetHashKey("hei_prop_hei_cash_trolly_01"),
		["trolleys"] = {
			["left"] = {
				["pos"] = vector3(-1205.5577392578,-336.47784423828,37.759357452393),
				["heading"] = 117.22966003418 + 0.0
			},
			["right"] = {
				["pos"] = vector3(-1209.0550537109,-338.32632446289,37.75927734375),
				["heading"] = 293.765625 + 0.0
			},

		},
	},
	["Alm. Brand Bank"] = {
		mincops = 3,
		position = { ['x'] = 307.66384887695, ['y'] = -281.8606262207, ['z'] = 54.164638519287 },
		nameofbank = "Alm. Brand Bank (Alta - Nord for LS Midtby)",
		lastrobbed = 0,
		seconds = 300,
		type = "bank",
		door1 = vector3(311.08981323242,-283.55004882813,54.174533843994),
		door2 = vector3(313.89852905273,-285.77478027344,54.143043518066),
		door1ID = 384,
		door2ID = 385,
		doorheading = 249.57357788086,
		model1 = 2121050683,
		model2 = -1591004109,
		drill = vector3(312.73922729492,-288.65542602539,54.143070220947),
		terminal = vector3(314.66284179688,-284.10833740234,54.142990112305	),
		--terminal2 = vector3(312.9375,-284.61618041992,54.142978668213),
		cash = { 1800, 2200 }, -- this is what you receive every cash stack math.random(1, 2)
		model = GetHashKey("hei_prop_hei_cash_trolly_01"),
		["trolleys"] = {
			["left"] = {
				["pos"] = vector3(314.9875793457,-288.12905883789,54.143096923828),
				["heading"] = 70.491752624512 + 0.0
			},
			["right"] = {
				["pos"] = vector3(311.04708862305,-287.07241821289,54.143009185791),
				["heading"] = 251.47555541992 + 0.0
			},

		},
	},
	["Danmarks Nationalbank"] = {
			mincops = 4,
			position = { ['x'] = 251.85081481934, ['y'] = 219.17041015625, ['z'] = 106.28687286377},
			nameofbank = "Danmarks Nationalbank (Downtown Vinewood)",
			lastrobbed = 0,
			seconds = 300,
			type = "bank",
			door1 = vector3(256.73919677734,219.73313903809,106.28636169434),
			door1ID = 381,
			door2ID = 382,
			door3ID = 383,
			doorheading = 341.7405090332,
			door2 = vector3(262.00482177734,221.65824890137,106.28512573242),
			door3 = vector3(253.92442321777,224.26240539551,101.88327026367),
			model1 = -222270721,
			model2 = 746855201,
			model3 = 961976194,
			drill = vector3(266.10110473633,213.4658203125,101.68338775635),
			terminal = vector3(261.53271484375,223.29843139648,106.2841796875),
			terminal2 = vector3(253.35482788086,228.3329010009, 101.68324279785),
			cash = { 1800, 2200 }, -- this is what you receive every cash stack math.random(1, 2)
			model = GetHashKey("hei_prop_hei_cash_trolly_01"),
		["trolleys"] = {
			["left"] = {
				["pos"] = vector3(264.64, 212.0, 101.67),
				["heading"] = 338.37 + 0.0
			},
			["right"] = {
				["pos"] = vector3(262.20, 212.88, 101.68),
				["heading"] = 338.37 + 0.0
			},
			["left2"] = {
				["pos"] = vector3(263.20, 216.39, 101.68),
				["heading"] = 338.37 + 180.0
			},
			["right2"] = {
				["pos"] = vector3(266.17, 215.38, 101.68),
				["heading"] = 338.37 + 180.0
			},
		}
	},

}
