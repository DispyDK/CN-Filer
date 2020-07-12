local cfg = {}

-- mysql credentials
cfg.db = {
  host = "localhost", -- database ip (default is local)
  database = "vrp",   -- name of database
  user = "root",    --  database username
  password = ""   -- password of your database
}

cfg.save_interval = 20 -- seconds
cfg.whitelist = true -- enable/disable whitelist

cfg.ignore_ip_identifier = true
cfg.ignore_license_identifier = true
cfg.ignore_xbox_identifier = true
cfg.ignore_live_identifier = true
cfg.ignore_discord_identifier = true

-- delay the tunnel at loading (for weak connections)
cfg.load_duration = 1 -- seconds, player duration in loading mode at the first spawn
cfg.load_delay = 10 -- milliseconds, delay the tunnel communication when in loading mode
cfg.global_delay = 0 -- milliseconds, delay the tunnel communication when not in loading mode

cfg.ping_timeout = 5 -- number of minutes after a client should be kicked if not sending pings
                -- SET YOUR LANGUAGE HERE - MAKE SURE IT'S INSIDE THE ""
cfg.lang = "da" -- en / fr / it / ger / pt / ru / lith / dan / ar / pl / es / swe / fin / cn / ro
                -- English/Français/Italiano/Deutsche/Português/Pусский/Lietuvių/Dansk/العربية/Polskie/Español/Svenska/Suomalainen/中文/Română
cfg.debug = false


return cfg
