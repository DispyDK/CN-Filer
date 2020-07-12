
description "vRP fishing"
--ui_page "ui/index.html"

dependency "vrp"

client_scripts{ 
  "lib/Proxy.lua",
  "lib/Tunnel.lua",
  "client.lua",
  "lang.lua"
}

server_scripts{ 
  "@vrp/lib/utils.lua",
  "server.lua"
}