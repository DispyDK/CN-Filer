resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"


dependency 'vrp'

server_scripts {
	'sv_hospital.lua'
}

client_script {
    "lib/Tunnel.lua",
    "lib/Proxy.lua",
    "config.lua",
	'cl_hospital.lua'
}
