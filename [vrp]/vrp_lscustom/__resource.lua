--[[
vRP Los Santos Customs V1.2
Credits - MythicalBro and マーモット#2533 for the vRP version and some bug fixes
/////License/////
Do not reupload/re release any part of this script without my permission
]]

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependency "vrp"
dependency "mysql-async"

client_scripts {
    	"lib/Proxy.lua",
    	"lib/Tunnel.lua",
    "lsconfig.lua",
    "menu.lua",
    "client.lua"
}

server_scripts {
  "@mysql-async/lib/MySQL.lua",
    "@vrp/lib/utils.lua",
    "server.lua"
}
