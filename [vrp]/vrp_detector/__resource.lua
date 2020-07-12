
description "vrp_detector"
--ui_page "ui/index.html"

dependency "vrp"

client_scripts{
  "client.lua"
}

server_scripts{ 
  "@vrp/lib/utils.lua",
  "server.lua"
}
