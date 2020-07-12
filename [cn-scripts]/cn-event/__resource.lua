resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

dependency "vrp"

client_scripts {
	"lib/Tunnel.lua",
	"lib/Proxy.lua",
	'client.lua'
}
server_scripts {
	"@vrp/lib/utils.lua",
	"server.lua"
}
--[[
Made by Lasse Mejdahl Christensen aka LasseAaB
.____                                   _____        __________ 
|    |   _____    ______ ______ ____   /  _  \ _____ \______   \
|    |   \__  \  /  ___//  ___// __ \ /  /_\  \\__  \ |    |  _/
|    |___ / __ \_\___ \ \___ \\  ___//    |    \/ __ \|    |   \
|_______ (____  /____  >____  >\___  >____|__  (____  /______  /
        \/    \/     \/     \/     \/        \/     \/       \/ 

Patreon: LasseAaB

--]]