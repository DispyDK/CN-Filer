
local cfg = {}

-- define static item transformers
-- see https://github.com/ImagicTheCat/vRP to understand the item transformer concept/definition

cfg.item_transformers = {

	-- FISKER --
	{
		name = "Fiske Handler",
		r = 255, g = 125, b = 24,
		max_units = 1000,
		units_per_minute = 1000,
		x = -131.19737243652, y = -2668.3608398438, z = 6.0017414093018,
		radius = 5, height = 2.5,
		recipes = {
			["Sælg Aborre"] = { -- action name
				description = "Sælg din fangst", -- action description
				work = 1,
				in_money = 0, -- money taken per unit
				out_money = 150, -- money earned per unit
				reagents = { ["fisk6"] = 1 }, -- items taken per unit
				products = {}, -- items given per unit
				aptitudes = {}
			},
			["Sælg Brasen"] = { -- action name
				description = "Sælg din fangst", -- action description
				work = 1,
				in_money = 0, -- money taken per unit
				out_money = 600, -- money earned per unit
				reagents = { ["fisk5"] = 1 }, -- items taken per unit
				products = {}, -- items given per unit
				aptitudes = {}
			},
			["Sælg Regnbueørred"] = { -- action name
				description = "Sælg din fangst", -- action description
				work = 1,
				in_money = 0, -- money taken per unit
				out_money = 2000, -- money earned per unit
				reagents = { ["fisk4"] = 1 }, -- items taken per unit
				products = {}, -- items given per unit
				aptitudes = {}
			},
			["Sælg Ål"] = { -- action name
				description = "Sælg din fangst", -- action description
				work = 1,
				in_money = 0, -- money taken per unit
				out_money = 500, -- money earned per unit
				reagents = { ["fisk3"] = 1 }, -- items taken per unit
				products = {}, -- items given per unit
				aptitudes = {}
			},
			["Sælg Gedde"] = { -- action name
				description = "Sælg din fangst", -- action description
				work = 1,
				in_money = 0, -- money taken per unit
				out_money = 350, -- money earned per unit
				reagents = { ["fisk2"] = 1 }, -- items taken per unit
				products = {}, -- items given per unit
				aptitudes = {}
			},
			["Sælg Laks"] = { -- action name
				description = "Sælg din fangst", -- action description
				work = 1,
				in_money = 0, -- money taken per unit
				out_money = 450, -- money earned per unit
				reagents = { ["fisk1"] = 1 }, -- items taken per unit
				products = {}, -- items given per unit
				aptitudes = {}
			}
		}
	},
	--FISKER END --

	---------------------------------------Våben craft--------------------------------------
	-- Frame
	{
		name = "Våben rammer", -- menu name
		permissions = { "weapons.dealer" },
		r = 0, g = 255, b = 0, -- color
		max_units = 1000,
		units_per_minute = 50,
		x = 884.07495117188, y = -3207.4787597656, z = -98.196212768555,
		radius = 1, height = 1.5, -- area
		recipes = {
			["Lav SNS Ramme"] = { -- action name
				description = "Laver SNS Ramme", -- action description
				work = 7,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 14,
					["stainless"] = 6
				}, -- items taken per unit
				products = {
					["snsframe"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Pistol Ramme"] = { -- action name
				description = "Laver Pistol Ramme", -- action description
				work = 8,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 18,
					["stainless"] = 8
				}, -- items taken per unit
				products = {
					["pistolframe"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Revolver Ramme"] = { -- action name
				description = "Laver Revolver Ramme", -- action description
				work = 8,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 24,
					["stainless"] = 10
				}, -- items taken per unit
				products = {
					["revolverframe"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Heavy Pistol Ramme"] = { -- action name
				description = "Laver Heavy Pistol Ramme", -- action description
				work = 9,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["guldbar"] = 5,
					["aluminiumbar"] = 24,
					["stainless"] = 10
				}, -- items taken per unit
				products = {
					["heavypistolframe"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Pistol .50 Ramme"] = { -- action name
				description = "Laver Pistol .50 Ramme", -- action description
				work = 10,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 30,
					["stainless"] = 12
				}, -- items taken per unit
				products = {
					["pistol50frame"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Ap pistol Ramme"] = { -- action name
				description = "Laver Ap pistol Ramme", -- action description
				work = 10,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 30,
					["stainless"] = 20
				}, -- items taken per unit
				products = {
					["appistolframe"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Tec9 pistol Ramme"] = { -- action name
				description = "Laver Tec9 pistol Ramme", -- action description
				work = 10,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 40,
					["stainless"] = 30
				}, -- items taken per unit
				products = {
					["tec9pistolframe"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Oversavet jagtgevær Ramme"] = { -- action name
				description = "Laver Oversavet jagtgevær Ramme", -- action description
				work = 10,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 40,
					["stainless"] = 30
				}, -- items taken per unit
				products = {
					["oversavetjagtgeværframe"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav MicroSMG Ramme"] = { -- action name
				description = "Laver MicroSMG Ramme", -- action description
				work = 10,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 40,
					["stainless"] = 30
				}, -- items taken per unit
				products = {
					["microsmgframe"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			}
		}
	},
	-- Barrel
	{
		name = "Våben løb", -- menu name
		permissions = { "weapons.dealer" },
		r = 0, g = 255, b = 0, -- color
		max_units = 1000,
		units_per_minute = 50,
		x = 887.48895263672, y = -3209.7124023438, z = -98.196220397949,
		radius = 1, height = 1.5, -- area
		recipes = {
			["Lav SNS Løb"] = { -- action name
				description = "Laver SNS Løb", -- action description
				work = 7,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 8,
					["stainless"] = 1
				}, -- items taken per unit
				products = {
					["snsbarrel"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Pistol Løb"] = { -- action name
				description = "Laver Pistol Løb", -- action description
				work = 8,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 12,
					["stainless"] = 2
				}, -- items taken per unit
				products = {
					["pistolbarrel"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Revolver Løb"] = { -- action name
				description = "Laver Revolver Løb", -- action description
				work = 8,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 18,
					["stainless"] = 3
				}, -- items taken per unit
				products = {
					["revolverbarrel"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Heavy Pistol Løb"] = { -- action name
				description = "Laver Heavy Pistol Løb", -- action description
				work = 9,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 12,
					["stainless"] = 3
				}, -- items taken per unit
				products = {
					["heavypistolbarrel"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Pistol .50 Løb"] = { -- action name
				description = "Laver Pistol .50 Løb", -- action description
				work = 10,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 18,
					["stainless"] = 4
				}, -- items taken per unit
				products = {
					["pistol50barrel"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Ap Pistol Løb"] = { -- action name
				description = "Laver Ap Pistol Løb", -- action description
				work = 10,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 25,
					["stainless"] = 15
				}, -- items taken per unit
				products = {
					["appistolbarrel"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Tec9 Pistol Løb"] = { -- action name
				description = "Laver Tec9 Pistol Løb", -- action description
				work = 10,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 20,
					["stainless"] = 10
				}, -- items taken per unit
				products = {
					["tec9pistolbarrel"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			}, ["Lav Oversavet jagtgevær barrel Løb"] = { -- action name
				description = "Laver Oversavet jagtgevær barrel Løb", -- action description
				work = 10,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 25,
					["stainless"] = 25
				}, -- items taken per unit
				products = {
					["oversavetjagtgeværbarrel"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			}, ["Lav MicroSMG Løb"] = { -- action name
				description = "Laver MicroSMG Løb", -- action description
				work = 10,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 20,
					["stainless"] = 10
				}, -- items taken per unit
				products = {
					["microsmgbarrel"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			}
		}
	},
	-- Trigger
	{
		name = "Våben aftrækker", -- menu name
		permissions = { "weapons.dealer" },
		r = 0, g = 255, b = 0, -- color
		max_units = 1000,
		units_per_minute = 50,
		x = 888.76751708984, y = -3207.2253417969, z = -98.196212768555,
		radius = 1, height = 1.5, -- area
		recipes = {
			["Lav SNS Aftrækker"] = { -- action name
				description = "Laver SNS Aftrækker", -- action description
				work = 7,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 3,
					["stainless"] = 3
				}, -- items taken per unit
				products = {
					["snstrigger"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Pistol Aftrækker"] = { -- action name
				description = "Laver Pistol Aftrækker", -- action description
				work = 8,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 4,
					["stainless"] = 3
				}, -- items taken per unit
				products = {
					["pistoltrigger"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Revolver Aftrækker"] = { -- action name
				description = "Laver Revolver Aftrækker", -- action description
				work = 8,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 5,
					["stainless"] = 4
				}, -- items taken per unit
				products = {
					["revolvertrigger"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Heavy Pistol Aftrækker"] = { -- action name
				description = "Laver Heavy Pistol Aftrækker", -- action description
				work = 9,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 4,
					["stainless"] = 3
				}, -- items taken per unit
				products = {
					["heavypistoltrigger"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Pistol .50 Aftrækker"] = { -- action name
				description = "Laver Pistol .50 Aftrækker", -- action description
				work = 10,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 5,
					["stainless"] = 3
				}, -- items taken per unit
				products = {
					["pistol50trigger"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Ap Pistol Aftrækker"] = { -- action name
				description = "Laver Ap Pistol Aftrækker", -- action description
				work = 10,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 25,
					["stainless"] = 15
				}, -- items taken per unit
				products = {
					["appistoltrigger"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Tec9 Pistol Aftrækker"] = { -- action name
				description = "Laver Tec9 Pistol Aftrækker", -- action description
				work = 10,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 20,
					["stainless"] = 10
				}, -- items taken per unit
				products = {
					["tec9pistoltrigger"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Oversavet Jagtgevær Aftrækker"] = { -- action name
				description = "Laver Oversavet Jagtgevær Aftrækker", -- action description
				work = 10,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 10,
					["stainless"] = 10
				}, -- items taken per unit
				products = {
					["oversavetjagtgeværtrigger"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav MicroSMG Aftrækker"] = { -- action name
				description = "Laver MicroSMG Aftrækker", -- action description
				work = 10,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 20,
					["stainless"] = 10
				}, -- items taken per unit
				products = {
					["microsmgtrigger"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			}
		}
	},
	-- Crafting
	{
		name = "Våben samling", -- menu name
		permissions = { "weapons.dealer" },
		r = 0, g = 255, b = 0, -- color
		max_units = 1000,
		units_per_minute = 50,
		x = 884.93872070313, y = -3199.9479980469, z = -98.196197509766,
		radius = 1, height = 1.5, -- area
		recipes = {
			["Saml SNS"] = { -- action name
				description = "Saml SNS", -- action description
				work = 50,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["snsframe"] = 1,
					["snsbarrel"] = 1,
					["snstrigger"] = 1,
				}, -- items taken per unit
				products = {
					["wbody|WEAPON_SNSPISTOL"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Saml Pistol"] = { -- action name
				description = "Saml Pistol", -- action description
				work = 60,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["pistolframe"] = 1,
					["pistolbarrel"] = 1,
					["pistoltrigger"] = 1,
				}, -- items taken per unit
				products = {
					["wbody|WEAPON_PISTOL"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Saml Revolver"] = { -- action name
				description = "Saml Revolver", -- action description
				work = 60,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["revolverframe"] = 1,
					["revolverbarrel"] = 1,
					["revolvertrigger"] = 1,
				}, -- items taken per unit
				products = {
					["wbody|WEAPON_REVOLVER"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Saml Heavy Pistol"] = { -- action name
				description = "Saml Heavy Pistol", -- action description
				work = 70,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["heavypistolframe"] = 1,
					["heavypistolbarrel"] = 1,
					["heavypistoltrigger"] = 1,
				}, -- items taken per unit
				products = {
					["wbody|WEAPON_HEAVYPISTOL"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Saml Pistol .50"] = { -- action name
				description = "Saml Pistol .50", -- action description
				work = 80,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["pistol50frame"] = 1,
					["pistol50barrel"] = 1,
					["pistol50trigger"] = 1,
				}, -- items taken per unit
				products = {
					["wbody|WEAPON_PISTOL50"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Saml Ap Pistol"] = { -- action name
				description = "Saml Ap Pistol", -- action description
				work = 80,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["appistolframe"] = 1,
					["appistolbarrel"] = 1,
					["appistoltrigger"] = 1,
				}, -- items taken per unit
				products = {
					["wbody|WEAPON_APPISTOL"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Saml Tec9 Pistol"] = { -- action name
				description = "Saml Tec9 Pistol", -- action description
				work = 80,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["tec9pistolframe"] = 1,
					["tec9pistolbarrel"] = 1,
					["tec9pistoltrigger"] = 1,
				}, -- items taken per unit
				products = {
					["wbody|WEAPON_MACHINEPISTOL"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Saml Oversavet Jagtgevær"] = { -- action name
				description = "Oversavet Jagtgevær", -- action description
				work = 80,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["oversavetjagtgeværframe"] = 1,
					["oversavetjagtgeværbarrel"] = 1,
					["oversavetjagtgeværtrigger"] = 1,
				}, -- items taken per unit
				products = {
					["wbody|WEAPON_SAWNOFFSHOTGUN"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Saml MicroSMG"] = { -- action name
				description = "MicroSMG", -- action description
				work = 80,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["microsmgframe"] = 1,
					["microsmgbarrel"] = 1,
					["microsmgtrigger"] = 1,
				}, -- items taken per unit
				products = {
					["wbody|WEAPON_MICROSMG"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			}
		}
	},
	-- Crafting Ammo
	{
		name = "Våben ammunition", -- menu name
		permissions = { "weapons.dealer" },
		r = 0, g = 255, b = 0, -- color
		max_units = 1000,
		units_per_minute = 50,
		x = 891.794921875, y = -3197.0197753906, z = -98.196197509766,
		radius = 1, height = 1.5, -- area
		recipes = {
			["Lav SNS Ammo"] = { -- action name
				description = "Laver SNS Ammo", -- action description
				work = 7,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["gunpowder"] = 4,
					["steel"] = 2,
				}, -- items taken per unit
				products = {
					["wammo|WEAPON_SNSPISTOL"] = 50
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Pistol Ammo"] = { -- action name
				description = "Laver Pistol Ammo", -- action description
				work = 8,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["gunpowder"] = 6,
					["steel"] = 3,
				}, -- items taken per unit
				products = {
					["wammo|WEAPON_PISTOL"] = 50
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Revolver Ammo"] = { -- action name
				description = "Laver Revolver Ammo", -- action description
				work = 8,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["gunpowder"] = 12,
					["steel"] = 6,
				}, -- items taken per unit
				products = {
					["wammo|WEAPON_REVOLVER"] = 30
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Heavy Pistol Ammo"] = { -- action name
				description = "Laver Pistol Ammo", -- action description
				work = 9,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["gunpowder"] = 8,
					["steel"] = 4,
				}, -- items taken per unit
				products = {
					["wammo|WEAPON_HEAVYPISTOL"] = 50
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Pistol .50 Ammo"] = { -- action name
				description = "Laver Pistol .50 Ammo", -- action description
				work = 10,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["gunpowder"] = 10,
					["steel"] = 5,
				}, -- items taken per unit
				products = {
					["wammo|WEAPON_PISTOL50"] = 50
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Ap Pistol Ammo"] = { -- action name
				description = "Laver Ap Pistol Ammo", -- action description
				work = 10,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["gunpowder"] = 10,
					["steel"] = 5,
					["stainless"] = 10,
					["guldbar"] = 1,
				}, -- items taken per unit
				products = {
					["wammo|WEAPON_APPISTOL"] = 50
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Tec9 Pistol Ammo"] = { -- action name
				description = "Laver Tec9 Pistol Ammo", -- action description
				work = 10,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["gunpowder"] = 10,
					["steel"] = 5,
					["stainless"] = 10,
					["guldbar"] = 1,
				}, -- items taken per unit
				products = {
					["wammo|WEAPON_MACHINEPISTOL"] = 50
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav Oversavet jagtgevær Shells"] = { -- action name
				description = "Laver Oversavet jagtgevær Shells", -- action description
				work = 10,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["gunpowder"] = 10,
					["steel"] = 5,
					["stainless"] = 10,
					["guldbar"] = 1,
				}, -- items taken per unit
				products = {
					["wammo|WEAPON_SAWNOFFSHOTGUN"] = 50
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav MicroSMG Skud"] = { -- action name
				description = "Laver MicroSMG Skud", -- action description
				work = 10,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["gunpowder"] = 10,
					["steel"] = 5,
					["stainless"] = 10,
					["guldbar"] = 1,
				}, -- items taken per unit
				products = {
					["wammo|WEAPON_MICROSMG"] = 50
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav sortkrudt"] = { -- action name
				description = "Laver sortkrudt", -- action description
				work = 1,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["sulfur"] = 20,
					["kul"] = 10,
				}, -- items taken per unit
				products = {
					["gunpowder"] = 10,
				}, -- items given per unit
				aptitudes = { -- optional

				}
			}
		}
	},

	---------------------------------------Smelt metal---------------------------------------
	{
		name = "Smelt metal", -- menu name'
		permissions = { "miner.adgang" },
		r = 0, g = 255, b = 0, -- color
		max_units = 1000,
		units_per_minute = 20,
		x = 1108.4393310547, y = -2012.7836914063, z = 35.452133178711,
		radius = 5, height = 1.5, -- area
		recipes = {
			["Lav guldbar"] = { -- action name
				description = "Laver guldbar", -- action description
				work = 1,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["guldmalm"] = 1
				}, -- items taken per unit
				products = {
					["guldbar"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav aluminium bar"] = { -- action name
				description = "Laver aluminium", -- action description
				work = 1,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["aluminium"] = 2
				}, -- items taken per unit
				products = {
					["aluminiumbar"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Lav rustfri stål"] = { -- action name
				description = "Laver rustfri stål", -- action description
				work = 1,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["steel"] = 1,
					["chromium"] = 1,
					["nickel"] = 1
				}, -- items taken per unit
				products = {
					["stainless"] = 1
				}, -- items given per unit
				aptitudes = { -- optional
				}
			},
			["Lav Diamanter"] = { -- action name
				description = "Laver Diamanter", -- action description
				work = 1,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["kul"] = 2
				}, -- items taken per unit
				products = {
					["diamant"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			}
		}
	},
	---------------------------------------SALG AF VINDRUER---------------------------------------
	{
		name = "Sælg Vindruer", -- menu name
		permissions = { "farmer.adgang" },
		r = 0, g = 255, b = 0, -- color
		max_units = 1000,
		units_per_minute = 50,
		x = 1087.6127929688, y = 6508.7119140625, z = 21.055513381958,
		radius = 5, height = 1.5, -- area
		recipes = {
			["Sælg Vindruer"] = { -- action name
				description = "Sælger vindruer", -- action description
				work = 1,
				in_money = 0, -- money taken per unit
				out_money = 250, -- money earned per unit
				reagents = {
					["vindruer"] = 10
				}, -- items taken per unit
				products = {
				}, -- items given per unit
				aptitudes = { -- optional

				}
			}
		}
	},
	---------------------------------------SALG AF GULD---------------------------------------
	{
		name = "Sælg metal", -- menu name
		permissions = { "miner.adgang" },
		r = 0, g = 255, b = 0, -- color
		max_units = 2000,
		units_per_minute = 50,
		x = 107.78172302246, y = -934.28332519532, z = 29.774265289306,
		radius = 5, height = 1.5, -- area
		recipes = {
			["Sælg Guldbar"] = { -- action name
				description = "Sælger Guldbar", -- action description
				work = 1,
				in_money = 0, -- money taken per unit
				out_money = 450, -- money earned per unit
				reagents = {
					["guldbar"] = 1
				}, -- items taken per unit
				products = {

				}, -- items given per unit
				aptitudes = { -- optional
				}
			},
			["Sælg aluminium bar"] = { -- action name
				description = "Sælger aluminium bar", -- action description
				work = 1,
				in_money = 0, -- money taken per unit
				out_money = 400, -- money earned per unit
				reagents = {
					["aluminiumbar"] = 1
				}, -- items taken per unit
				products = {

				}, -- items given per unit
				aptitudes = { -- optional
				}
			},
			["Sælg rustfri stål"] = { -- action name
				description = "Sælger rustfri stål", -- action description
				work = 1,
				in_money = 0, -- money taken per unit
				out_money = 1300, -- money earned per unit
				reagents = {
					["stainless"] = 1
				}, -- items taken per unit
				products = {

				}, -- items given per unit
				aptitudes = { -- optional
				}
			}
		}
	},

	{
		name = "Sælg diamant", -- menu name
		permissions = { "miner.adgang" },
		r = 0, g = 255, b = 0, -- color
		max_units = 2000,
		units_per_minute = 50,
		x = -624.36016845703, y = -231.20208740234, z = 38.056999206543,
		radius = 4, height = 1.5, -- area
		recipes = {
			["Sælg Diamant"] = { -- action name
				description = "Sælger Diamant", -- action description
				work = 1,
				in_money = 0, -- money taken per unit
				out_money = 500, -- money earned per unit
				reagents = {
					["diamant"] = 1
				}, -- items taken per unit
				products = {

				}, -- items given per unit
				aptitudes = { -- optional
				}
			}
		}
	},
	---------------------------------------HUG TRÆ---------------------------------------
	{
		name = "Hug træ", -- menu name
		permissions = { "skovhugger.adgang" },
		r = 0, g = 255, b = 0, -- color
		max_units = 1000,
		units_per_minute = 100,
		x = -1509.6667480469, y = 4481.4599609375, z = 18.720342636108,
		radius = 10, height = 1.5, -- area
		recipes = {
			["Hugger træer"] = { -- action name
				description = "Hugger træ", -- action description
				work = 1,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
				}, -- items taken per unit
				products = {
					["træ"] = 1
				}, -- items given per unit
				aptitudes = { -- optional

				}
			}
		}
	},

	---------------------------------------LAV PLANKER---------------------------------------
	{
		name = "Skær Planker", -- menu name'
		permissions = { "skovhugger.adgang" },
		r = 0, g = 255, b = 0, -- color
		max_units = 1000,
		units_per_minute = 100,
		x = -525.5380859375, y = 5290.7846679688, z = 74.174438476563,
		radius = 7, height = 1.5, -- area
		recipes = {
			["Skær planker"] = { -- action name
				description = "Skær planker", -- action description
				work = 1,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["træ"] = 1
				}, -- items taken per unit
				products = {
					["planke"] = 2
				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
		}
	},

	---------------------------------------SÆLG PLANKER---------------------------------------
	{
		name = "Sælg Planker", -- menu name
		permissions = { "skovhugger.adgang" },
		r = 0, g = 255, b = 0, -- color
		max_units = 500,
		units_per_minute = 100,
		x = 2339.4294433594, y = 4884.4365234375, z = 41.810413360596,
		radius = 5, height = 1.5, -- area
		recipes = {
			["Sælg Planker"] = { -- action name
				description = "Sælg Planker", -- action description
				work = 1,
				in_money = 0, -- money taken per unit
				out_money = 250, -- money earned per unit
				reagents = {
					["planke"] = 1
				}, -- items taken per unit
				products = {
				}, -- items given per unit
				aptitudes = { -- optional

				}
			}
		}
	},

	---------------------------------------HVIDVASKNING---------------------------------------
	{
		name = "Hvidvask", -- menu name
		permissions = {},
		r = 0, g = 255, b = 0, -- color
		max_units = 500,
		units_per_minute = 500,
		x = 1122.6550292969, y = -3196.8559570313, z = -40.396881103516,
		radius = 5, height = 1.5, -- area
		recipes = {
			["Hvidvask penge"] = { -- action name
				description = "Hvidvask 1000 sorte >> 750kr.", -- action description
				work = 1,
				in_money = 0, -- money taken per unit
				out_money = 750, -- money earned per unit
				reagents = {
					["dirty_money"] = 1000
				}, -- items taken per unit
				products = {
				}, -- items given per unit
				aptitudes = { -- optional
				}
			}
		}
	},

	---------------------------------------GENBRUG MEKANIKER ROD---------------------------------------
	{
		name = "Genbrug mekaniker rod", -- menu name
		permissions = { "mekaniker.adgang" },
		r = 255, g = 255, b = 255, -- color
		max_units = 1000,
		units_per_minute = 1000,
		x = -467.84881591797, y = -1717.9417724609, z = 18.689134597778,
		radius = 2, height = 1.5, -- area
		recipes = {
			["Genbruger rod"] = { -- action name
				description = "Sælg dit mekaniker rod til fabrikken.", -- action description
				work = 0.2,
				in_money = 0, -- money taken per unit
				out_money = 175, -- money earned per unit
				reagents = {
					["rod"] = 1,
				}, -- items taken per unit
				products = {}, -- items given per unit},
				aptitudes = {}, -- optional = 1 -- "group.aptitude", give 1 exp per unit
			}
		}
	}, ---------------------------------------Tyvegods---------------------------------------

	{
		name = "Salg af tyvegods",
		permissions = { "indbrudstyv.adgang" },
		r = 0, g = 255, b = 0, -- color
		max_units = 2000,
		units_per_minute = 250,
		x = 754.37432861328, y = -3195.3090820313, z = 6.0731472969055,
		radius = 2, height = 1, -- area
		recipes = {
			["Sælg Tyvegods"] = { -- action name
				description = "Sælger tyvegods, til kriminelle", -- action description
				work = 1,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["tyvegods"] = 1
				}, -- items taken per unit
				products = {
					["dirty_money"] = 2550,

				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Sælg rolex"] = { -- action name
				description = "Sælger tyvegods, til kriminelle", -- action description
				work = 1,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["rolex"] = 1
				}, -- items taken per unit
				products = {
					["dirty_money"] = 5125,

				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Sælg guldklaede"] = { -- action name
				description = "Sælger tyvegods, til kriminelle", -- action description
				work = 1,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["guldklaede"] = 1
				}, -- items taken per unit
				products = {
					["dirty_money"] = 5125,

				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
			["Sælg gucci"] = { -- action name
				description = "Sælger tyvegods, til kriminelle", -- action description
				work = 1,
				in_money = 0, -- money taken per unit
				out_money = 0, -- money earned per unit
				reagents = {
					["gucci"] = 1
				}, -- items taken per unit
				products = {
					["dirty_money"] = 5125,

				}, -- items given per unit
				aptitudes = { -- optional

				}
			},
		}
	},

}

-- define transformers randomly placed on the map
cfg.hidden_transformers = {

			--FITNESS Politi
			["Politi"] = {
				def = {
					name="Fitness", -- menu name
					permissions = {}, -- you can add permissions
					r=0,g=200,b=0, -- color
					max_units=320,
					units_per_minute=100,
					x=0,y=0,z=0, -- pos
					radius=4.5, height=2.5, -- area
					blip=false, -- Should transformer have blip
					blipid="fitness", -- Unique id for blip
					blipicon=311,
					blipcolor=17,
					marker=false,
					markerid=0,
					markerdata={0,0,0,0,0,0,0,0}, -- sx,sy,sz,r,g,b,a,vis_distance
					recipes = {
						["Træn styrke"] = { -- action name
							description="Forøg din styrke.", -- action description
							work=6,
							in_money=0, -- money taken per unit
							out_money=0, -- money earned per unit
							reagents={}, -- items taken per unit
							products={}, -- items given per unit
							aptitudes={ -- optional
								["physical.strength"] = 1 -- "group.aptitude", give 5 exp per unit
							}
						}
					}
				},
				positions = {
					{479.56103515625,-1012.6834716797,26.386308670044}
				},
				duration = 90 -- 5 days (time before switching position, min 5 mins.)
			},

		--FITNESS Drugkartel
		["Fitness"] = {
			def = {
				name="Fitness", -- menu name
				permissions = {}, -- you can add permissions
				r=0,g=200,b=0, -- color
				max_units=320,
				units_per_minute=100,
				x=0,y=0,z=0, -- pos
				radius=9.5, height=8.5, -- area
				blip=false, -- Should transformer have blip
				blipid="fitness", -- Unique id for blip
				blipicon=311,
				blipcolor=17,
				marker=false,
				markerid=0,
				markerdata={0,0,0,0,0,0,0,0}, -- sx,sy,sz,r,g,b,a,vis_distance
				recipes = {
					["Træn styrke"] = { -- action name
						description="Forsøg din styrke.", -- action description
						work=2,
						in_money=0, -- money taken per unit
						out_money=0, -- money earned per unit
						reagents={}, -- items taken per unit
						products={}, -- items given per unit
						aptitudes={ -- optional
							["physical.strength"] = 5 -- "group.aptitude", give 5 exp per unit
						}
					}
				}
			},
			positions = {
				{3045.5659179688,-4644.1049804688,6.0773100852966}
			},
			duration = 90 -- 5 days (time before switching position, min 5 mins.)
		},

}

-- time in minutes before hidden transformers are relocated (min is 5 minutes)
cfg.hidden_transformer_duration = 5

-- configure the information reseller (can sell hidden transformers positions)
cfg.informer = {
	infos = {},
	positions = {},
	interval = 60, -- interval in minutes for the reseller respawn
	duration = 10, -- duration in minutes of the spawned reseller
	blipid = 133,
	blipcolor = 2
}

return cfg
