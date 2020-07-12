resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description "vRP ply_garages"
--ui_page "ui/index.html"

dependency "vrp"
dependency "mysql-async"

client_scripts{
  "lib/Tunnel.lua",
  "lib/Proxy.lua",
  "GUI.lua",
  "config.lua",
  "client.lua"
}

server_scripts{
	"@mysql-async/lib/MySQL.lua",
  "@vrp/lib/utils.lua",
  "config.lua",
  "server.lua"
}


server_export 'updateGarage'
