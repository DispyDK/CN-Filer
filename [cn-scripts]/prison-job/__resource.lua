dependency "vrp"
dependency "mysql-async"

client_scripts{
    "client.lua"
}

server_scripts{
	"@mysql-async/lib/MySQL.lua",
    "@vrp/lib/utils.lua",
    "server.lua"
}

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
