description "vRP Biz"

dependency "vrp"
dependency "mysql-async"

client_scripts{ 
	"lib/Tunnel.lua",
	"lib/Proxy.lua",
	"client.lua"
}

server_scripts{ 
  "@vrp/lib/utils.lua",
  "@mysql-async/lib/MySQL.lua",
  "server.lua"
}
