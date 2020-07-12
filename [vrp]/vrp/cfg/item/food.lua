-- define some basic inventory items

local items = {}

local function play_eat(player)
	local seq = {
		{"mp_player_inteat@burger", "mp_player_int_eat_burger_enter",1},
		{"mp_player_inteat@burger", "mp_player_int_eat_burger",1},
		{"mp_player_inteat@burger", "mp_player_int_eat_burger_fp",1},
		{"mp_player_inteat@burger", "mp_player_int_eat_exit_burger",1}
	}

	vRPclient.playAnim(player,{true,seq,false})
end

local function play_drink(player)
	local seq = {
		{"mp_player_intdrink","intro_bottle",1},
		{"mp_player_intdrink","loop_bottle",1},
		{"mp_player_intdrink","loop_bottle",1},
		{"mp_player_intdrink","outro_bottle",1}
	}

	vRPclient.playAnim(player,{true,seq,false})
end

-- gen food choices as genfunc
-- idname
-- ftype: eat or drink
-- vary_hunger
-- vary_thirst
local function gen(ftype, vary_hunger, vary_thirst, vary_promille)
	local fgen = function(args)
		local idname = args[1]
		local choices = {}
		local act = "Unknown"
		if ftype == "eat" then act = "> Spis" elseif ftype == "drink" then act = "> Drik" end
		local name = vRP.getItemName(idname)

		choices[act] = {function(player,choice)
			local user_id = vRP.getUserId(player)
			if user_id ~= nil then
				if vRP.tryGetInventoryItem(user_id,idname,1,false) then
					if vary_hunger ~= 0 then vRP.varyHunger(user_id,vary_hunger) end
					if vary_thirst ~= 0 then vRP.varyThirst(user_id,vary_thirst) end
					if vary_promille ~= 0 then vRP.varyPromille(user_id,vary_promille) end

					if ftype == "drink" then
						TriggerClientEvent("pNotify:SendNotification",player,{text = "Drikker <b style='color: #4E9350'>" ..name.. "</b>",type = "success", timeout = (3000),layout = "centerLeft"})
						play_drink(player)
					elseif ftype == "eat" then
						TriggerClientEvent("pNotify:SendNotification",player,{text = "Spiser <b style='color: #4E9350'>" ..name.. "</b>",type = "success", timeout = (3000),layout = "centerLeft"})
						play_eat(player)
					end

					vRP.closeMenu(player)
				end
			end
		end}

		return choices
	end

	return fgen

end

-- DRINKS --

items["water"] = {"Vand flaske","", gen("drink",0,-25,0),0.1}
items["milk"] = {"Mælk","", gen("drink",0,-10,0),0.1}
items["coffee"] = {"Kaffe","", gen("drink",0,-10,0),0.1}
items["tea"] = {"Te","", gen("drink",0,-15,0),0.1}
items["icetea"] = {"Is Te","", gen("drink",0,-20,0), 0.1}
items["orangejuice"] = {"Appelsin juice","", gen("drink",0,-25,0),0.1}
items["gocagola"] = {"Læskedrik","", gen("drink",0,-35,0),0.1}
items["redgull"] = {"Redbull","", gen("drink",0,-40,0),0.1}
items["lemonlimonad"] = {"Limonade","", gen("drink",0,-45,0),0.1}
items["sure"] = {"Små Sure","", gen("drink",15,-10,0.25),0.1}
items["vodka"] = {"Vodka","", gen("drink",15,-10,0.25),0.1}
items["sodavand"] = {"Stor Sodavand","", gen("drink",0,-25,0),0.1}
items["romogcola"] = {"Rom og Cola","", gen("drink",0,-5,0.25),0.1}
items["ginogtonic"] = {"Gin og Tonic","", gen("drink",0,-5,0.25),0.1}
items["tequilla"] = {"Tequilla Sunrise","", gen("drink",0,-5,0.25),0.1}
items["sexbeach"] = {"Sex on the beach","", gen("drink",0,-5,0.25),0.1}
items["whisky"] = {"Whisky","", gen("drink",0,-5,0.25),0.1}
items["gin"] = {"Gin","", gen("drink",0,-5,0.25),0.1}
items["vodkajuice"] = {"Vodka Juice","", gen("drink",0,-5,0.25),0.1}
items["kinder"] = {"Kinderæg Shot","", gen("drink",-10,0,0.25),0.1}
items["monsterh"] = {"Hvid Monster Energy","", gen("drink",0,-40,0),0.1}
items["monsterg"] = {"Grøn Monster Energy","", gen("drink",0,-40,0),0.1}
items["ginandlemon"] = {"Gin & Lemon","", gen("drink",0,-5,0.25),0.1}
items["strawberrydaiquiri"] = {"Strawberry daiquiri","", gen("drink",0,-5,0.25),0.1}
items["aeblekageshots"] = {"Æblekage shots","", gen("drink",0,-5,0.25),0.1}
items["tequilashot"] = {"Tequila shot","", gen("drink",0,-5,0.25),0.1}
items["skumbanan"] = {"Skumbanan","", gen("drink",0,-5,0.25),0.1}
items["mojito"] = {"Mojito","", gen("drink",0,-5,0.25),0.1}
items["pinacolada"] = {"Piña colada","", gen("drink",0,-5,0.25),0.1}
items["champagneglas"] = {"Champagne Glas","", gen("drink",0,-5,0.25),0.1}
items["belvederevodka"] = {"Belvedere Vodka","", gen("drink",0,-5,0.25),0.1}
items["isbjoern"] = {"Isbjørn","", gen("drink",0,-5,0.25),0.1}
items["groentuborg"] = {"Grøn tuborg","", gen("drink",0,-5,0.25),0.1}
items["greygoosevodka"] = {"Grey Goose Vodka","", gen("drink",0,-5,0.25),0.1}
items["newcastlebrownale"] = {"Newcastle brown ale","", gen("drink",0,-5,0.25),0.1}
items["guinnesskilkenny"] = {"Guinness Kilkenny","", gen("drink",0,-5,0.25),0.1}
items["hvidvinsglas"] = {"Hvidvins glas","", gen("drink",0,-5,0.25),0.1}
items["roedvinsglas"] = {"Rødvins glas","", gen("drink",0,-5,0.25),0.1}
items["aleno16"] = {"Ale no 16","", gen("drink",0,-5,0.25),0.1}

items["ol1"] = {"Tuborg","", gen("drink",0,-5,0.25),0.1}
items["ol2"] = {"Tuborg Classic","", gen("drink",0,-5,0.25),0.1}
items["ol3"] = {"Carlsberg","", gen("drink",0,-5,0.25),0.1}


--FOOD

-- create Breed item
items["kinderegg"] = {"Kinderæg","", gen("eat",-10,0,0),0.1}
items["bread"] = {"Brød","", gen("eat",-10,0,0),0.1}
items["pizza"] = {"Pizza","", gen("eat",-10,0,0),0.1}
items["pizzasnegl"] = {"Pizzasnegl","", gen("eat",-5,0,0),0.1}
items["donut"] = {"Donut","", gen("eat",-15,0,0),0.1}
items["tacos"] = {"Tacos","", gen("eat",-20,0,0),0.1}
items["sandwich"] = {"Sandwich","A tasty snack.", gen("eat",-25,0,0),0.1}
items["kebab"] = {"Kebab","", gen("eat",-45,0,0),0.1}
items["pdonut"] = {"Chokolade donut","", gen("eat",-25,0,0),0.1}
items["makrel2"] = {"Grillet makrel","",gen("eat",-40,0,0),1.5}
items["torsk2"] = {"Grillet torsk","",gen("eat",-35,0,0),2.5}
items["reje2"] = {"Grillet reje","",gen("eat",-10,0,0),0.09}
items["brunkager"] = {"brunkager","",gen("eat",-10,0,0),0.10}
items["pebernødder"] = {"pebernødder","",gen("eat",-10,0,0),0.10}
items["bedstemors_småkager"] = {"Bedstemors småkager","",gen("eat",-10,0,0),0.10 }

items["bigmac"] = {"Big Mac","",gen("eat",-30,0,0),0.5}
items["cct"] = {"Chili Cheese Tops","",gen("eat",-15,0,0),0.2}
items["cheeseburger"] = {"Cheeseburger","",gen("eat",-15,0,0),0.40}
items["hamburger"] = {"Hamburger","",gen("eat",-15,0,0),0.40}

items["chips1"] = {"Kims Sour Cream & Onion Chips","",gen("eat",-15,0,0),0.40}
items["chips2"] = {"Kims Paprika Chips","",gen("eat",-15,0,0),0.40}
items["chips3"] = {"Kims Salt Chips","",gen("eat",-15,0,0),0.40}
items["chips4"] = {"Kims Ostepops","",gen("eat",-15,0,0),0.40}

items["bacon"] = {"Bacon","",gen("eat",-5,0,0),0.05}

-- DINER FOOD
items["hotwings"] = {"Hot wings","", gen("eat",-15,0,0),0.1}
items["pulletpork"] = {"Pullet Pork BBQ","", gen("eat",-30,0,0),0.3}
items["ccf"] = {"Chili Cheese Fries","", gen("eat",-15,0,0),0.2}
items["favburger"] = {"Henry’s Favorite burger","", gen("eat",-25,0,0),0.3}
items["baconburg"] = {"Bacon Cheeseburger","", gen("eat",-25,0,0),0.3}
items["gayburger"] = {"Tasty Veggie Burger","", gen("eat",-15,0,0),0.3}
items["empsteak"] = {"The Empire Steak","", gen("eat",-35,0,0,0),0.4}
items["strawshake"] = {"Strawberry shake","", gen("drink",0,-10,0),0.3}
items["banashake"] = {"Banana Shake","", gen("drink",0,-10,0),0.3}
items["drpepper"] = {"Dr. Pepper","", gen("drink",0,-20,0),0.2}


return items
