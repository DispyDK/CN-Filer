resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependency "vrp"

server_scripts {
    "@vrp/lib/utils.lua",
    "config.lua",
    "port_sv.lua",
    "races_sv.lua",
}

client_scripts {
    "config.lua",
    "races_cl.lua",
}
