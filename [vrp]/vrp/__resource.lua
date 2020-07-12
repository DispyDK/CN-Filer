description "CiviliansNetwork vRP Async - høhø"

dependency 'mysql-async'

ui_page "gui/index.html"

-- server scripts
server_scripts{
	"@mysql-async/lib/MySQL.lua",
  "lib/utils.lua",
  "base.lua",
  "modules/gui.lua",
  "modules/group.lua",
  "modules/admin.lua",
  "modules/survival.lua",
  "modules/player_state.lua",
  "modules/map.lua",
  "modules/money.lua",
  "modules/inventory.lua",
  "modules/identity.lua",
  "modules/business.lua",
  "modules/item_transformer.lua",
  "modules/emotes.lua",
  "modules/police.lua",
  "modules/home.lua",
  "modules/home_components.lua",
  "modules/mission.lua",
  "modules/aptitude.lua",
  "modules/paycheck.lua",

  -- basic implementations
  "modules/basic_phone.lua",
  "modules/basic_market.lua",
  "modules/basic_garage.lua",
  "modules/basic_items.lua",
  "modules/basic_skinshop.lua",
  "modules/basic_gunshop.lua",
  "modules/cloakroom.lua",
}

-- client scripts
client_scripts{
  "lib/utils.lua",
  "client/Tunnel.lua",
  "client/Proxy.lua",
  "client/base.lua",
  "client/iplloader.lua",
  "client/gui.lua",
  "client/player_state.lua",
  "client/survival.lua",
  "client/map.lua",
  "client/identity.lua",
  "client/basic_garage.lua",
  "client/gunshop.lua",
  "client/police.lua",
  "client/policespikes.lua",
  "client/drag.lua",
  "client/adminvehicle.lua",
  "client/admin.lua",
}

-- client files
files{
  "cfg/client.lua",
  "gui/index.html",
  "gui/design.css",
  "gui/bg.png",
  "gui/main.js",
  "gui/Menu.js",
  "gui/ProgressBar.js",
  "gui/WPrompt.js",
  "gui/RequestManager.js",
  "gui/AnnounceManager.js",
  "gui/Div.js",
  "gui/dynamic_classes.js"
}

--[[
__________         ___ ___                             .__
\______   \___.__./   |   \ ___.__.______   ___________|__| ____   ____
 |    |  _<   |  /    ~    <   |  |\____ \_/ __ \_  __ \  |/  _ \ /    \
 |    |   \\___  \    Y    /\___  ||  |_> >  ___/|  | \/  (  <_> )   |  \
 |______  // ____|\___|_  / / ____||   __/ \___  >__|  |__|\____/|___|  /
        \/ \/           \/  \/     |__|        \/                     \/
--]]
