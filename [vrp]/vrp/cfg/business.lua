
local cfg = {}

-- minimum capital to open a business
cfg.minimum_capital = 500000

-- capital transfer reset interval in minutes
-- default: reset every 24h
cfg.transfer_reset_interval = 24*60

-- commerce chamber {blipid,blipcolor}
cfg.blip = {408,69}

-- positions of commerce chambers
cfg.commerce_chambers = { --{x,y,z,showblip}
	{707.29656982422,-966.90386962891,30.412847518921,true},
	{109.10571289063,-747.24206542969,242.15196228027,false},
}


return cfg
