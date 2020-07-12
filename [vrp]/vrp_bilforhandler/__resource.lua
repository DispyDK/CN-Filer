
description "vrp_bilforhandler"
--ui_page "ui/index.html"

dependency "vrp"
dependency 'mysql-async'

client_scripts{
  "client.lua"
}

server_scripts{
  "@mysql-async/lib/MySQL.lua",
  "@vrp/lib/utils.lua",
  "server.lua"
}
