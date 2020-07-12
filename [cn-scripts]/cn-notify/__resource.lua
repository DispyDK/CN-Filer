--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 26-01-2019
-- Time: 12:26
-- Made for CiviliansNetwork
--
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependency 'vrp'

server_scripts {
    '@vrp/lib/utils.lua',
    'server.lua'
}

client_scripts {
    'client.lua'
}