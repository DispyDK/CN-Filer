--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 12-03-2019
-- Time: 16:43
-- Made for CiviliansNetwork
--
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependency 'mysql-async'

server_scripts {
    "@vrp/lib/utils.lua",
      "@mysql-async/lib/MySQL.lua",
    'server.lua'
}

client_scripts {
    'client.lua'
}
