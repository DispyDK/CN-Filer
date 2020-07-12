resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependency "vrp"
dependency 'mysql-async'


-- Tell FiveM's NUI system what the main html file is for this resource
ui_page "nui/ui.html"

-- Add the files that need to be used/loaded
files {
	"nui/ui.html",
	"nui/ui.js",
	"nui/ui.css",
	"nui/Roboto.ttf",
	"nui/Captain.ttf"
}

client_scripts{
    "lib/Tunnel.lua",
    "lib/Proxy.lua",
    "client.lua"
}

server_scripts{
	"@mysql-async/lib/MySQL.lua",
    "@vrp/lib/utils.lua",
    "server.lua"
}
