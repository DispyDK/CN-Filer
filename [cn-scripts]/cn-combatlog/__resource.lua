resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

client_script {
  'lib/Proxy.lua',
  'lib/Tunnel.lua',
  'deathevents.lua'

}

server_script {
  'lib/Proxy.lua',
  '@vrp/lib/utils.lua',
  'server.lua'
}
