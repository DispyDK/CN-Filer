local cfg = {}
-- LANG --
cfg.lang = {
  hoveringTextStart = "Tryk ~g~E~s~ for at starte ~r~",
  hoveringTextStop = "Tryk ~g~K~s~ for at stoppe ~r~",
  invehicle = "Stig ud af bilen"
}
-- LANG --

-- BUTTONS --
cfg.buttons = {
  start = 38, -- E
  stop = 311 -- K
}
-- BUTTONS --

-- ZONES --
-- pastebin.com/6mrYTdQv Scenarios
cfg.area_size = 3.0 -- Needs to be [number.0]
cfg.marker_size = 6.0 -- Needs to be [number.0]
cfg.marker_visibledist = 20
cfg.zone_types = {
  ["Skunk Farm"]  = { -- Has to be the same as the [cfg.zones_pos]
    _config = {animation="PROP_HUMAN_PARKING_METER"},
  },
  ["Kokainblad Farm"]  = { -- Has to be the same as the [cfg.zones_pos]
    _config = {animation="PROP_HUMAN_PARKING_METER"},
  },
  ["Opiumvalmue Farm"]  = { -- Has to be the same as the [cfg.zones_pos]
    _config = {animation="PROP_HUMAN_PARKING_METER"},
	},
  ["Ketamin Farm"]  = { -- Has to be the same as the [cfg.zones_pos]
    _config = {animation="PROP_HUMAN_PARKING_METER"},
  }
}

cfg.zones_pos = {
  {"Skunk Farm",3282.560546875,5187.2446289063,18.540157318115},
  {"Kokainblad Farm",2287.0676269531,4763.7192382813,37.800},
  {"Opiumvalmue Farm",-1691.7947998047,1959.1016845703,131.652},
  {"Ketamin Farm",-310.30453491211,-1353.5920410156,28.774549484253}
}
-- ZONES --

return cfg
