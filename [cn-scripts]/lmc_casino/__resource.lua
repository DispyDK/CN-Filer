resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
-- this_is_a_map 'yes'
dependency "vrp"

client_scripts {
	'client.lua'
}
-- 1100.39 220.09 -48.75
server_scripts {
	"@mysql-async/lib/MySQL.lua",
	"@vrp/lib/utils.lua",
	'server.lua'
}
