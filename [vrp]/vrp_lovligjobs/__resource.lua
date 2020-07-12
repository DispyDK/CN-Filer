resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "nui/ui.html"

files {
		"nui/ui.html",
   	"nui/ui.js",
		"nui/ui.css",
		 "nui/img/logo.png",
		 "nui/empregos.html",
		 "nui/style-job.css",
}

client_script {
	'Proxy.lua',
  'click.lua',
}

server_script {
	'Proxy.lua',
  '@vrp/lib/utils.lua',
  'server.lua'
}
