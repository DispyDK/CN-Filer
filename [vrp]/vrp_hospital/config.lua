Config = {}

Config.Healing = 32 -- // If this is 0, then its disabled.. Default: 3.. That means, if a person lies in a bed, then he will get 1 health every 3 seconds.
Config.HealingDuty = 16

Config.objects = {
	ButtonToSitOnChair = 23, -- // Default: F -- // https://docs.fivem.net/game-references/controls/
	ButtonToLayOnBed = 23, -- // Default: F -- // https://docs.fivem.net/game-references/controls/
	ButtonToStandUp = 23, -- // Default: F -- // https://docs.fivem.net/game-references/controls/
	SitAnimation = {anim='PROP_HUMAN_SEAT_CHAIR_MP_PLAYER'},
	BedBackAnimation = {anim='WORLD_HUMAN_SUNBATHE_BACK'},
	BedStomachAnimation = {anim='WORLD_HUMAN_SUNBATHE'},
	BedSitAnimation = {anim='WORLD_HUMAN_PICNIC'},
	locations = {
		{object="v_med_bed1", verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=-1.4, direction=0.0, bed=true},
  		{object="v_med_bed2", verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=-1.4, direction=0.0, bed=true},
    	{object="v_med_emptybed", verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=-1.4, direction=0.0, bed=true},
    	{object=-289946279, verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=-1.4, direction=0.0, bed=true},
    	{object=-1519439119, verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=-1.4, direction=0.0, bed=true},

		{object="v_serv_ct_chair02", verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=-0.0, direction=168.0, bed=false},
		{object="prop_off_chair_04", verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=-0.4, direction=168.0, bed=false},
		{object="prop_off_chair_03", verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=-0.4, direction=168.0, bed=false},
		{object="prop_off_chair_05", verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=-0.4, direction=168.0, bed=false},
		{object="v_club_officechair", verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=-0.4, direction=168.0, bed=false},
		{object="v_ilev_leath_chr", verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=-0.4, direction=168.0, bed=false},
		{object="v_corp_offchair", verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=-0.4, direction=168.0, bed=false},
		{object="v_med_emptybed", verticalOffsetX=0.0, verticalOffsetY=0.13, verticalOffsetZ=-0.2, direction=90.0, bed=false},
		{object="Prop_Off_Chair_01", verticalOffsetX=0.0, verticalOffsetY=-0.1, verticalOffsetZ=-0.5, direction=180.0, bed=false},
		{object="v_ret_gc_chair02", verticalOffsetX=0.0, verticalOffsetY=-0.1, verticalOffsetZ=-0.5, direction=180.0, bed=false},
		{object="prop_sol_chair", verticalOffsetX=0.0, verticalOffsetY=-0.1, verticalOffsetZ=-0.5, direction=180.0, bed=false},
		{object="v_tre_sofa_mess_b_s", verticalOffsetX=0.0, verticalOffsetY=-0.1, verticalOffsetZ=-0.5, direction=180.0, bed=false},
		{object="prop_table_01_chr_a", verticalOffsetX=0.0, verticalOffsetY=-0.1, verticalOffsetZ=0.0, direction=180.0, bed=false},
		{object="prop_table_01_chr_b", verticalOffsetX=0.0, verticalOffsetY=-0.1, verticalOffsetZ=0.0, direction=180.0, bed=false},
		{object="gabz_pillbox_diagnostics_bed_01", verticalOffsetX=0.15, verticalOffsetY=0.15, verticalOffsetZ=-2.0, direction=0.0, bed=true},
		{object="gabz_pillbox_diagnostics_bed_02", verticalOffsetX=0.15, verticalOffsetY=0.15, verticalOffsetZ=-2.0, direction=0.0, bed=true},
		{object="gabz_pillbox_diagnostics_bed_03", verticalOffsetX=0.15, verticalOffsetY=0.15, verticalOffsetZ=-2.0, direction=0.0, bed=true}

	}
}

-- // YOU WILL FIND ALL BUTTONS HERE FOR CODE BELOW;P
-- [[ https://docs.fivem.net/game-references/controls/ ]]

Config.Text = {
	SitOnChair = '~INPUT_ARREST~ for at sætte dig',
	SitOnBed = '~INPUT_ARREST~ for at sætte dig på sengen',
	LieOnBed = '~INPUT_ARREST~ for at ligge dig på ',
	SwitchBetween = '~INPUT_CELLPHONE_LEFT~ ~INPUT_CELLPHONE_RIGHT~ skift i mellem',
	Standup = '~INPUT_ARREST~ for at rejse dig!',
}
