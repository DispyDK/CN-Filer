dependency "vrp"

server_scripts {
	'@vrp/lib/utils.lua',
	'server/main.lua'	
}

client_scripts {
	'config.lua',
	'client/main.lua',
	'client/lib/tunnel.lua',
	'client/lib/proxy.lua'
}
