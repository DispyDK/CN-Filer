resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependency "vrp"
dependency 'mysql-async'


client_scripts {
    "lib/Tunnel.lua",
    "lib/Proxy.lua",
    "lib/enum.lua",
  	"client/main.lua",
	  "client/radar.lua",
    "client/nowanted.lua",
    "client/pointfinger.lua",
    "client/scope.lua",
    "client/vinduerul.lua",
    "client/noweapondrops.lua",
    "client/cruise.lua",
    "client/RemoveFiveMShit.lua",
    "client/dive.lua",
    "client/NPC-Control.lua",
    "client/crouch.lua",
    "client/DriveByLimit.lua",
    "client/opgiv.lua",
    "client/stamina.lua",
    "client/dogo_client.lua",
    "client/police.lua",
	  "client/toggleengine.lua",
    "client/components.lua",
    "client/pole.lua",
    "client/market.lua",
    "client/packing.lua",
    "client/skiftbil.lua",
    "client/nobunnyhop.lua",
    "client/tow.lua",
    "client/zone.lua",
    "client/farming.lua"
}

ui_page 'h.html'
files {
  'weaponsnowball.meta',
}

data_file 'WEAPONINFO_FILE_PATCH' 'weaponsnowball.meta'

server_scripts {
  "@mysql-async/lib/MySQL.lua",
    "@vrp/lib/utils.lua",
    "server/dive.lua",
    "server/drift.lua",
    "server/pole.lua",
    "server/revive.lua",
    "server/vinduerul.lua",
    "server/components.lua",
    "server/radio.lua",
    "server/market.lua",
    "server/packing.lua",
    "server/farming.lua"
}
