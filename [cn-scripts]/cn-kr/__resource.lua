resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "client/html/ui.html"

dependency 'vrp'
dependency 'mysql-async'

files {
	"client/html/ui.html",
	"client/html/styles.css",
	"client/html/scripts.js",
	"client/html/debounce.min.js",
	"client/html/sweetalert2.all.min.js",
	"client/html/logo.png"

}

client_scripts {
	"lib/Tunnel.lua",
	"lib/Proxy.lua",
	"Proxy.lua",
	"config.lua",
	"client/main.lua"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"@mysql-async/lib/MySQL.lua",
	"config.lua",
	"server/main.lua"
}
