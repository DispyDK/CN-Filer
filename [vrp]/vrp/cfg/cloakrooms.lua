
-- this file configure the cloakrooms on the map

local cfg = {}

-- prepare surgeries customizations
local surgery_male = { model = "mp_m_freemode_01" }
local surgery_female = { model = "mp_f_freemode_01" }
local police_male = { model = "s_m_y_hwaycop_01" }
local policeundercover_male = { model = "s_m_m_ciasec_01"}
local aks_male = { model = "s_m_y_swat_01"}
local police2_male = { model = "s_m_y_cop_01"}
local ems_male = { model = "s_m_m_paramedic_01"}
local sheriff_male = { model ="s_m_y_sheriff_01"}
local factory_male = { model ="s_m_y_factory_01"}
local doctor_male = { model ="s_m_m_doctor_01"}
local autopsy_male = { model="s_m_y_autopsy_01"}
local hunde_male = { model ="s_m_m_snowcop_01"}
local scrubs_female = { model="s_f_y_scrubs_01"}
local lost_m1 = {model ="g_m_y_lost_01"}
local lost_m2 = {model ="g_m_y_lost_02"}
local lost_m3 = {model ="g_m_y_lost_03"}
local vest_p = {model ="u_m_m_doa_01"}


for i=0,19 do
	surgery_female[i] = {0,0}
	surgery_male[i] = {0,0}
end

-- cloakroom types (_config, map of name => customization)
--- _config:
---- permissions (optional)
---- not_uniform (optional): if true, the cloakroom will take effect directly on the player, not as a uniform you can remove
cfg.cloakroom_types = {
	["polle"] = {
		_config = { permissions = {"police.cloakroom"} },
		["Male uniform"] = {
			[3] = {30,0},
			[4] = {25,2},
			[6] = {24,0},
			[8] = {58,0},
			[11] = {55,0},
			["p2"] = {2,0}
		},
		["Female uniform"] = {
			[3] = {35,0},
			[4] = {30,0},
			[6] = {24,0},
			[8] = {6,0},
			[11] = {48,0},
			["p2"] = {2,0}
		}
	},
	["surgery"] = {
		_config = { not_uniform = true },
		["Male"] = surgery_male,
		["Female"] = surgery_female
	},
	["Politi Omklædningsrum"] = {
		_config = { permissions = {"police.cloakroom"} },
		["Motercykel Betjent"] = police_male,
		["Civil Betjent"] = policeundercover_male,
		["AKS Uniform"] = aks_male,
		["Betjent"] = police2_male,
		["Hundefører"] = hunde_male,
		["Politi Vest"] = vest_p,
		["Betjent2"] = sheriff_male
	},

	["læge"] = {
		_config = { permissions = {"emergency.cloakroom"} },
		["paramediciner"] = ems_male,
		["læge"] = factory_male,
		["doktor"] = doctor_male,
		["Sygeplejske mand"] = autopsy_male,
		["Sygeplejske kvinde"] = scrubs_female,

	}

}


cfg.cloakrooms = {

}

return cfg
