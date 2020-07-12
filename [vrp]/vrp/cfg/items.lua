-- define items, see the Inventory API on github

local cfg = {}
-- see the manual to understand how to create parametric items
-- idname = {name or genfunc, description or genfunc, genfunc choices or nil, weight or genfunc}
-- a good practice is to create your own item pack file instead of adding items here
cfg.items = {
	["polet"] = {"Polet", "Kan veksles på casinoet", nil, 0.10}, -- no choices
	["kul"] = {"Kul", "Du kan lave det til diamanter", nil, 1.5}, -- no choices
	["diamant"] = {"Diamant", "Kan sælges for høj profit", nil, 0.10}, -- no choices
	["guldmalm"] = {"Guldmalm", "Kan laves til guldbarre", nil, 5.00}, -- no choices
	["guldbar"] = {"Guldbar", "Kan sælges for profit", nil, 2.50}, -- no choices

	-- Nyt Drug system
		-- Amfetamin
	["amfetamin_pure"] = {"Ren Amfetamin", "", nil, 0.37}, -- no choices
	["cut_amfetamin"] = {"Cuttet Amfetamin", "", nil, 0.09}, -- no choices
	["pak_amfetamin"] = {"Pakket Amfetamin", "", nil, 55.50}, -- no choices
	["lys_amfetamin_pure"] = {"Lys Ren Amfetamin", "", nil, 0.125}, -- no choices
		-- Kokain
	["cokepasta_pure"] = {"Kokain Pasta", "", nil, 0.37}, -- no choices
	["cut_pasta"] = {"Cuttet Kokain", "", nil, 0.375}, -- no choices
	["pak_kokain"] = {"Pakket Kokain", "", nil, 55.50}, -- no choices
	["kokain_pure"] = {"Ren Kokain", "", nil, 0.50}, -- no choices
		-- Heroin
	["heroin_pure"] = {"Ren Heroin", "", nil, 0.37}, -- no choices
	["cut_heroin"] = {"Cuttet Heroin", "", nil, 0.187}, -- no choices
	["pak_heroin"] = {"Pakket Heroin", "", nil, 55.50}, -- no choices
	["brun_heroin_pure"] = {"Brun Heroin", "", nil, 0.25}, -- no choices
		-- Skunk
	["topskud_pure"] = {"Topskud", "", nil, 0.37}, -- no choices
	["cut_topskud"] = {"Ryst", "", nil, 0.15}, -- no choices
	["pak_topskud"] = {"Pakket Hash", "", nil, 55.50}, -- no choices
	["lys_marok_pure"] = {"Lys Marok", "", nil, 0.20}, -- no choices
		-- Tilføjelser
	["acetone"] = {"Acetone", "", nil, 0.37}, -- no choices
	["frugt_farve"] = {"Frugt Farve", "", nil, 0.37}, -- no choices
	["sukker"] = {"Sukker", "", nil, 0.37}, -- no choices
	["klistermaerke"] = {"Klistermærke", "", nil, 0.37}, -- no choices
	["hightablecoin"] = {"The High Table Coin", "Coin of the High table, extremely valuable.", nil, 0.37}, -- no choices

	--Hvidløg
	["hvidløg"] = {"Hvidløg", "Bruges til at lave hvidløgsprodukter", nil, 0.10}, -- no choices
	["hvidløgspulver"] = {"Hvidløgs pulver", "Kan sælges", nil, 0.10}, -- no choices

	--Stof kasser
	["kokainkasse"] = {"Kokain kasse", "Kasse med kokain", nil, 25.0}, -- no choices
	["amfetaminkasse"] = {"Amfetamin kasse", "Kasse med amfetamin", nil, 25.0}, -- no choices
	["ketaminkasse"] = {"Ketamin kasse", "Kasse med ketamin", nil, 25.0}, -- no choices
	["lsdkasse"] = {"LSD kasse", "Kasse med LSD", nil, 25.0}, -- no choices
	["skunkkasse"] = {"Skunk kasse", "Kasse med skunk", nil, 25.0}, -- no choices

	--joint
	["skunk"] = {"Skunk", "Ulovligt! Kan sælges.", nil, 0.10}, -- no choices
	["paper"] = {"Paper", "Rul en joint", nil, 0.02}, -- no choices
	["ristetcigaret"] = {"Ristet cigaret", "Rul en joint", nil, 0.02}, -- no choices

--Juvelbutik røveri
	["rolex"] = {"Rolex Ur", "Rendyrket guld", nil, 0.02}, -- no choices
	["guldklaede"] = {"Guldhalskæde", "Lavet af guld", nil, 0.02}, -- no choices
	["gucci"] = {"Gucci taske", "Ægte taske fra Gucci", nil, 0.02}, -- no choices

--Juvelbutik shop
	["soelvring"] = {"Sølv ring", "Lavet af sølv", nil, 0.10}, -- no choices
	["guldring"] = {"Guld ring", "Lavet af guld", nil, 0.10}, -- no choices
	["diamantring"] = {"Diamant ring", "Lavet af hvidguld med en diamant sten", nil, 0.10}, -- no choices

	-- Våben Frames
	["snsframe"] = {"SNS Ramme", "Bruges til en SNS Pistol", nil, 0.40}, -- no choices
	["pistolframe"] = {"Pistol Ramme", "Bruges til en pistol", nil, 0.40}, -- no choices
	["heavypistolframe"] = {"Heavy Pistol Ramme", "Bruges til en Heavy Pistol", nil, 0.40}, -- no choices
	["pistol50frame"] = {"Pistol .50 Ramme", "Bruges til en Pistol .50", nil, 0.40}, -- no choices
	["appistolframe"] = {"Ap pistol Ramme", "Bruges til en Ap Pistol", nil, 0.40}, -- no choices
	["tec9pistolframe"] = {"Tec9 Ramme", "Bruges til en Tec9", nil, 0.40}, -- no choices
	["oversavetjagtgeværframe"] = {"Oversavet Jagtgevær Ramme", "Bruges til et Oversavet Jagtgevær", nil, 0.40}, -- no choices
	["microsmgframe"] = {"MicroSMG Ramme", "Bruges til en Micro SMG", nil, 0.40}, -- no choices
	-- Våben Barrels
	["snsbarrel"] = {"SNS Løb", "Bruges til en SNS Pistol", nil, 0.40}, -- no choices
	["pistolbarrel"] = {"Pistol Løb", "Bruges til en pistol", nil, 0.40}, -- no choices
	["heavypistolbarrel"] = {"Heavy Pistol Løb", "Bruges til en Heavy Pistol", nil, 0.40}, -- no choices
	["pistol50barrel"] = {"Pistol .50 Løb", "Bruges til en Pistol .50", nil, 0.40}, -- no choices
	["appistolbarrel"] = {"Ap pistol Løb", "Bruges til en Ap Pistol", nil, 0.40}, -- no choices
	["tec9pistolbarrel"] = {"Tec9 Løb", "Bruges til en Tec9", nil, 0.40}, -- no choices
	["oversavetjagtgeværbarrel"] = {"Oversavet Jagtgevær Løb", "Bruges til et Oversavet Jagtgevær", nil, 0.40}, -- no choices
	["microsmgbarrel"] = {"MicroSMG Løb", "Bruges til en Micro SMG", nil, 0.40}, -- no choices
	-- Våben Trigger
	["snstrigger"] = {"SNS Aftrækker", "Bruges til en SNS Pistol", nil, 0.40}, -- no choices
	["pistoltrigger"] = {"Pistol Aftrækker", "Bruges til en pistol", nil, 0.40}, -- no choices
	["heavypistoltrigger"] = {"Heavy Pistol Aftrækker", "Bruges til en Heavy Pistol", nil, 0.40}, -- no choices
	["pistol50trigger"] = {"Pistol .50 Aftrækker", "Bruges til en Pistol .50", nil, 0.40}, -- no choices
	["appistoltrigger"] = {"Ap pistol Aftrækker", "Bruges til en Ap pistol", nil, 0.40}, -- no choices
	["tec9pistoltrigger"] = {"Tec9 Aftrækker", "Bruges til en Tec9", nil, 0.40}, -- no choices
	["oversavetjagtgeværtrigger"] = {"Oversavet Jagtgevær Aftrækker", "Bruges til et Oversavet Jagtgevær", nil, 0.40}, -- no choices
	["microsmgtrigger"] = {"MicroSMG Aftrækker", "Bruges til en Micro SMG", nil, 0.40}, -- no choices
	-- Molotov
	["flaske"] = {"Flaske", "Kan bruges til at lave en molotov.", nil, 0.20}, -- no choices
	["klud"] = {"Klud", "Kan bruges til at lave en molotov.", nil, 0.15}, -- no choices
	["benzin"] = {"Benzin", "Kan bruges til at lave en molotov.", nil, 0.50}, -- no choices

    -- Fængselsjob
	["planke1"] = {"Planke", "En... Planke.", nil, 25}, -- no choices
	["planke2"] = {"Skårede planker", "Skårede planker, klar til brug!", nil, 25}, -- no choices
	["planke3"] = {"Træstol", "Smukt konstrueret arbejde!", nil, 25}, -- no choices



	--boxes
	["kasse1"] = {"Kasse", "Bruges til opvaring", nil, 50.00}, -- no choices
	["kasse2"] = {"Kasse", "Bruges til opvaring", nil, 50.00}, -- no choices
	["kasse3"] = {"Kasse", "Bruges til opvaring", nil, 50.00}, -- no choices
	["kasse4"] = {"Kasse", "Bruges til opvaring", nil, 50.00}, -- no choices
	["kasse5"] = {"Kasse", "Bruges til opvaring", nil, 5.00}, -- no choices
	["kasse6"] = {"Kasse", "Bruges til opvaring", nil, 5.00}, -- no choices
	["kasse7"] = {"Kasse", "Bruges til opvaring", nil, 5.00}, -- no choices
	["kasse8"] = {"Kasse", "Bruges til opvaring", nil, 5.00}, -- no choices
	["kasse9"] = {"Kasse", "Bruges til opvaring", nil, 5.00}, -- no choices
	["kasse10"] = {"Kasse", "Bruges til opvaring", nil, 5.00}, -- no choices
	["kasse11"] = {"Kasse", "Bruges til opvaring", nil, 5.00}, -- no choices
	["kasse12"] = {"Kasse", "Bruges til opvaring", nil, 5.00}, -- no choices


	--bank stuff
	["nationalbankenplan"] = {"Plan for røveri af national banken","Plan for røveri af national banken", nil, 0.00}, -- no choices
	["goldencard"] = {"goldencard", nil,"Kan sælges for profit", 0.00}, -- no choices
	["silvercard"] = {"silvercard","Kan sælges for profit", nil, 0.00}, -- no choices
	["thermite"] = {"thermite","thermite bombe", nil, 2.50}, -- no choices

	-- Våben Andet
	["gunpowder"] = {"Sortkrudt", "Bruges til våben ammunition", nil, 0.01}, -- no choices

	["aluminium"] = {"Aluminium oxide", "Kan laves til aluminium bar", nil, 0.25}, -- no choices
	["aluminiumbar"] = {"Aluminium bar", "Kan sælges for profit", nil, 0.40}, -- no choices

	["steel"] = {"Stål", "Kan laves til rustfri stål", nil, 0.30}, -- no choices
	["stainless"] = {"Rustfri stål", "Kan sælges for profit", nil, 0.50}, -- no choices
	["chromium"] = {"Chromium", "Skal bruges til rustfri stål", nil, 0.05}, -- no choices
	["nickel"] = {"Nickel", "Skal bruges til rustfri stål", nil, 0.05}, -- no choices

	["sulfur"] = {"Svovl", "Bliver brugt til gummi", nil, 0.10}, -- no choices

	["paraply"] = {"Paraply", "Bruges til og holde en tør når det regner</br>Brug: /paraply", nil, 0.60}, -- no choices
	["pizza"] = {"Pizza", "Pizza bakke</br>Brug: /pizza", nil, 0.50}, -- no choices
	["stok"] = {"Stok", "Er du for gamle til og gå ordenligt? Så brug en stok!</br>Brug: /stok", nil, 0.50}, -- no choices
	["kuffert"] = {"Kuffert", "Kuffert, skal du se prof ud jamen så gå med den!</br>Brug: /kuffert", nil, 0.50}, -- no choices
	["box"] = {"Box", "En kasse med? Hvem ved.</br>Brug: /box", nil, 0.50}, -- no choices
	["regentsglas"] = {"Regentsglas", "Brugt til at opbevare væske", nil, 0.25}, -- no choices
	["unicorn"] = {"Unicorn", "Skal du være fancy? Jamen så rid da på en unicorn!?</br>Brug: /unicorn", nil, 0.50}, -- no choices
	["kikkert"] = {"Kikkert", "Bruges til at se ting på lang afstand", nil, 1.50}, -- no choices

	["dirty_money"] = {"Dollars", "Real American Dollars", nil, 0.50},
	["bank_penge"] = {"Penge Fra Banken", "DKK.", nil, 0}, -- no choices
	["iphone"] = {"iPhone X", "Bruges til at sende beskeder mm", nil, 0.2},
	["samsung"] = {"Samsung Galaxy S9", "Bruges til at sende beskeder mm", nil, 0.2},
	["oneplus"] = {"OnePlus 6T", "Bruges til at sende beskeder mm", nil, 0.2},
	["træ"] = {"Træ", "Bruges til at laves om til planker", nil, 3},
	["planke"] = {"Planker", "Kan sælges i byen", nil, 1.0},
	["rod"] = {"Mekaniker Rod", "", nil, 0.50}, -- no choices
	["vindruer"] = {"Vindruer", "Kan sælges", nil , 0.01},
	["pakke"] = {"Pakke", "Skal afleveres til kunder", nil , 3.0},
	["brev"] = {"Brev", "Skal afleveres til kunder", nil , 0.5},
	["lægerapport"] = {"Læge Journal", "Bliver krævet afleveret til andet hospital", nil , 0.2},
	["medicin"] = {"Medicin", "Bliver krævet afleveret til andet hospital", nil , 1},
	["førstehjælpskasse"] = {"Førstehjælps Kasse", "Til at udøve førstehjælp", nil , 1},
	["dive"] = {"Dykker Udstyr", "Bruges til at dykke med", nil , 1},
	["gelatine"] = {"Gelatine", "Det anvendes til at gøre vandige levnedsmidler tykkere", nil , 0.1},

	--Amfetamin produktion
	["amfetamin"] = {"Amfetamin", "Amfetamin.", nil, 0.20},
	["p2np"] = {"P2NP", "P2NP.", nil, 0.25},
	["isopropanol"] ={"Isopropanol", "Isopropanol.", nil, 0.25},
	["sølvpapir"] = {"Sølvpapir", "Sølvpapir.", nil, 0.25},
	["eddikesyre"] = {"Eddikesyre" , "Eddikkesyre.", nil, 0.25},
	["naoh"] = {"NaOH", "NaOH.", nil, 0.25},
	["h2so4"] = {"H2SO4", "H2SO4.", nil, 0.25},
	["natrium"] = {"Natrium","Natrium", nil, 0.25},

	--buglary
	["tyvegods"] = {"Tyvegods","Stjålne ting", nil, 5.0},

	--Keys

	--Klubber/egendomme
	["key_bahmas"] = {"Nøgle - Bahama Mama","Nøgler Bahama Mama", nil, 0.01},
	["key_stripklub2"] = {"Nøgle - Stripklubben","Nøgler til stripklubben", nil, 0.01},
	["key_yachten"] = {"Nøgle - Yacht","Nøgler til yachten", nil, 0.01},
	["key_galaxy2"] = {"Nøgle - Galaxy","Nøgler til Galaxy", nil, 0.01},
	["key_brugtvogn"] = {"Nøgle - Brugtvognsforhandler","Nøgler til Brugtvognsforhandleren", nil, 0.01},
	--Jobs
	["key_advokat"] = {"Nøgle - Advokat","Nøgler til advokatkontor", nil, 0.01},
	["key_realestate"] = {"Nøgle - Ejendomsmægler","Nøgler til ejendomsmægler kontor", nil, 0.01},
	["key_lifeinvader2"] = {"Nøgle - Lifeinvader","Nøgler til lifeinvader", nil, 0.01},
	["key_bilforhandler"] = {"Nøgle - Bilforhandler","Nøgler til Bilforhandleren", nil, 0.01},
	["key_panthersecurity"] = {"Nøgle - Panther Security","Nøgler til Panther Security", nil, 0.01},
	["key_elforsyning"] = {"Nøgle - El Forsyning ApS","Nøgler til El Forsyning ApS", nil, 0.01},
	["key_kirke"] = {"Nøgle - til kirken","Nøgler til kirken", nil, 0.01},

	--Ejendomsmægler
	["key_bolig1"] = {"Nøgle - Bolig 1","Nøgler til bolig 1", nil, 0.01},
	["key_bolig2_1"] = {"Nøgle - Bolig 2","Nøgler til bolig 2", nil, 0.01},
	["key_bolig6"] = {"Nøgle - Bolig 6","Nøgler til bolig 6", nil, 0.01},
	["key_bolig7"] = {"Nøgle - Bolig 7","Nøgler til bolig 7", nil, 0.01},
	["key_bolig22"] = {"Nøgle - Bolig 22","Nøgler til Bolig 22", nil, 0.01},
	["key_bolig33"] = {"Nøgle - Bolig 33","Nøgler til Bolig 33", nil, 0.01},
	["key_bolig32"] = {"Nøgle - Bolig 32","Nøgler til Bolig 32", nil, 0.01},
	["key_vinewoodhills2"] = {"Nøgle - Vinewood Hills 2","Nøgler til Vinewood Hills 2", nil, 0.01},
	["key_vinewoodhills3"] = {"Nøgle - Vinewood Hills 3","Nøgler til Vinewood Hills 3", nil, 0.01},
	["key_madwayne"] = {"Nøgle - Mad Wayne","Nøgler til porten", nil, 0.01},
	["key_kure"] = {"Nøgle - Kures hus","Nøgler til porten", nil, 0.01},
	["key_domingo"] = {"Nøgle - Playboy Mansion","Nøgler til porten", nil, 0.01},
	["key_sandylab"] = {"Nøgle - Sandy Laboratorie","Nøgler til Laboratoriet", nil, 0.01},
	["key_vineyard"] = {"Nøgle - Vingården","Nøgler til Vingården", nil, 0.01},
	["key_westvw"] = {"Nøgle - West Vinewood","Nøgler til West Vinewood", nil, 0.01},
	["key_westvw2"] = {"Nøgle - West Vinewood (Værelse)","Nøgler til West Vinewood (Værelse)", nil, 0.01},
	["key_gentrylane"] = {"Nøgle - Gentry Lane","Nøgler til Gentry Lane", nil, 0.01},
	["key_vargas"] = {"Nøgle - Alex Vargas","Nøgler til Alex Vargas' hus", nil, 0.01},
	["key_a&m"] = {"Nøgle - Alex Musti","Nøgler til Alex musti tøjbutik", nil, 0.01},
	["key_rogers"] = {"Nøgle - Rogers","Nøgler til Rogers lagerbygning", nil, 0.01},
	["key_alberto"] = {"Nøgle - Alberto","Nøgler til Alberto's hus", nil, 0.01},
	["key_lacelu"] = {"Nøgle - La Celu","Nøgler til La Celu", nil, 0.01},
	["key_gumpher"] = {"Nøgle - Gumpher Market","Nøgler til Gumpher Market", nil, 0.01},
	["key_mike"] = {"Nøgle - Mike Larsen","Nøgler til Mike Larsen", nil, 0.01},
	["key_octopus"] = {"Nøgle - Octopus INC","Nøgler til Octopus inc", nil, 0.01},
	["key_innovation"] = {"Nøgle - innovation","Nøgler til innovation cars & auto", nil, 0.01},
	["key_ling"] = {"Nøgle - Shi ling","Nøgler til Shi ling", nil, 0.01},
	["key_ziza"] = {"Nøgle - Shi ling","Nøgler til Ziza David", nil, 0.01},
	
	--Nye system!

	["key_nudistlejr"] = {"Nøgle - key_nudistlejr", "Nøgler til key_nudistlejr", nil, 0.01},
	["key_lamesa"] = {"Nøgle - key_lamesa", "Nøgler til key_lamesa", nil, 0.01},
	["key_madwaynethunder"] = {"Nøgle - key_madwaynethunder", "Nøgler til key_madwaynethunder", nil, 0.01},
	["key_route68lager"] = {"Nøgle - key_route68lager", "Nøgler til key_route68lager", nil, 0.01},
	["key_elburroheights"] = {"Nøgle - key_elburroheights", "Nøgler til key_elburroheights", nil, 0.01},
	["key_fudgeln"] = {"Nøgle - key_fudgeln", "Nøgler til key_fudgeln", nil, 0.01},
	["key_losvargas1"] = {"Nøgle - key_losvargas1", "Nøgler til key_losvargas1", nil, 0.01},
	["key_losvargas2"] = {"Nøgle - key_losvargas2", "Nøgler til key_losvargas2", nil, 0.01},
	["key_westeclipse1"] = {"Nøgle - key_westeclipse1", "Nøgler til key_westeclipse1", nil, 0.01},
	["key_westeclipse2"] = {"Nøgle - key_westeclipse2", "Nøgler til key_westeclipse2", nil, 0.01},
	["key_appleboulevard"] = {"Nøgle - key_appleboulevard", "Nøgler til key_appleboulevard", nil, 0.01},
	["key_yachten1"] = {"Nøgle - key_yachten1", "Nøgler til key_yachten1", nil, 0.01},
	["key_uni"] = {"Nøgle - key_uni", "Nøgler til key_uni", nil, 0.01},
	["key_elysian"] = {"Nøgle - key_elysian", "Nøgler til key_elysian", nil, 0.01},
	["key_sanchianski1"] = {"Nøgle - key_sanchianski1", "Nøgler til key_sanchianski1", nil, 0.01},
	["key_sanchianski2"] = {"Nøgle - key_sanchianski2", "Nøgler til key_sanchianski2", nil, 0.01},
	["key_gården"] = {"Nøgle - key_gården", "Nøgler til key_gården", nil, 0.01},
	["key_vespucciblvd"] = {"Nøgle - key_vespucciblvd", "Nøgler til key_vespucciblvd", nil, 0.01},
	["key_pinkcagemotel1"] = {"Nøgle - key_pinkcagemotel1", "Nøgler til key_pinkcagemotel1", nil, 0.01},
	["key_pinkcagemotel3"] = {"Nøgle - key_pinkcagemotel3", "Nøgler til key_pinkcagemotel3", nil, 0.01},
	["key_pinkcagemotel4"] = {"Nøgle - key_pinkcagemotel4", "Nøgler til key_pinkcagemotel4", nil, 0.01},
	["key_pinkcagemotel5"] = {"Nøgle - key_pinkcagemotel5", "Nøgler til key_pinkcagemotel5", nil, 0.01},
	["key_pinkcagemotel6"] = {"Nøgle - key_pinkcagemotel6", "Nøgler til key_pinkcagemotel6", nil, 0.01},
	["key_pinkcagemotel7"] = {"Nøgle - key_pinkcagemotel7", "Nøgler til key_pinkcagemotel7", nil, 0.01},
	["key_pinkcagemotel11"] = {"Nøgle - key_pinkcagemotel11", "Nøgler til key_pinkcagemotel11", nil, 0.01},
	["key_pinkcagemotel13"] = {"Nøgle - key_pinkcagemotel13", "Nøgler til key_pinkcagemotel13", nil, 0.01},
	["key_pinkcagemotel14"] = {"Nøgle - key_pinkcagemotel14", "Nøgler til key_pinkcagemotel14", nil, 0.01},
	["key_pinkcagemotel15"] = {"Nøgle - key_pinkcagemotel15", "Nøgler til key_pinkcagemotel15", nil, 0.01},
	["key_pinkcagemotel32"] = {"Nøgle - key_pinkcagemotel32", "Nøgler til key_pinkcagemotel32", nil, 0.01},
	["key_pinkcagemotel18"] = {"Nøgle - key_pinkcagemotel18", "Nøgler til key_pinkcagemotel18", nil, 0.01},
	["key_pinkcagemotel17"] = {"Nøgle - key_pinkcagemotel17", "Nøgler til key_pinkcagemotel17", nil, 0.01},
	["key_pinkcagemotel29"] = {"Nøgle - key_pinkcagemotel29", "Nøgler til key_pinkcagemotel29", nil, 0.01},
	["key_pinkcagemotel23"] = {"Nøgle - key_pinkcagemotel23", "Nøgler til key_pinkcagemotel23", nil, 0.01},
	["key_trevorstrailer"] = {"Nøgle - key_trevorstrailer", "Nøgler til key_trevorstrailer", nil, 0.01},
	["key_strawberryave"] = {"Nøgle - key_strawberryave", "Nøgler til key_strawberryave", nil, 0.01},
	["key_meteorst"] = {"Nøgle - key_meteorst", "Nøgler til key_meteorst", nil, 0.01},
	["key_winewoodhills"] = {"Nøgle - key_winewoodhills", "Nøgler til key_winewoodhills", nil, 0.01},
	["key_dutchlondonindustri"] = {"Nøgle - key_dutchlondonindustri", "Nøgler til key_dutchlondonindustri", nil, 0.01},
	["key_trailerpark2"] = {"Nøgle - key_trailerpark2", "Nøgler til key_trailerpark2", nil, 0.01},
	["key_grove"] = {"Nøgle - key_grove", "Nøgler til key_grove", nil, 0.01},
	["key_trailerpark1"] = {"Nøgle - key_trailerpark1", "Nøgler til key_trailerpark1", nil, 0.01},
	["key_clintonave"] = {"Nøgle - key_clintonave", "Nøgler til key_clintonave", nil, 0.01},
	["key_whispymounddrive"] = {"Nøgle - key_whispymounddrive", "Nøgler til key_whispymounddrive", nil, 0.01},
	["key_paletowoodmotel1"] = {"Nøgle - key_paletowoodmotel1", "Nøgler til key_paletowoodmotel1", nil, 0.01},
	["key_paletowoodmotel2"] = {"Nøgle - key_paletowoodmotel2", "Nøgler til key_paletowoodmotel2", nil, 0.01},
	["key_paletowoodmotel3"] = {"Nøgle - key_paletowoodmotel3", "Nøgler til key_paletowoodmotel3", nil, 0.01},
	["key_paletowoodmotel4"] = {"Nøgle - key_paletowoodmotel4", "Nøgler til key_paletowoodmotel4", nil, 0.01},
	["key_paletowoodmotel5"] = {"Nøgle - key_paletowoodmotel5", "Nøgler til key_paletowoodmotel5", nil, 0.01},
	["key_paletowoodmotel6"] = {"Nøgle - key_paletowoodmotel6", "Nøgler til key_paletowoodmotel6", nil, 0.01},
	["key_paletowoodmotel7"] = {"Nøgle - key_paletowoodmotel7", "Nøgler til key_paletowoodmotel7", nil, 0.01},
	["key_paletowoodmotel8"] = {"Nøgle - key_paletowoodmotel8", "Nøgler til key_paletowoodmotel8", nil, 0.01},
	["key_paletowoodmotel9"] = {"Nøgle - key_paletowoodmotel9", "Nøgler til key_paletowoodmotel9", nil, 0.01},
	["key_paletowoodmotel10"] = {"Nøgle - key_paletowoodmotel10", "Nøgler til key_paletowoodmotel10", nil, 0.01},
	["key_delperrofwy"] = {"Nøgle - key_delperrofwy", "Nøgler til key_delperrofwy", nil, 0.01},
	["key_pennenabeachmotel1"] = {"Nøgle - key_pennenabeachmotel1", "Nøgler til key_pennenabeachmotel1", nil, 0.01},
	["key_pennenabeachmotel2"] = {"Nøgle - key_pennenabeachmotel2", "Nøgler til key_pennenabeachmotel2", nil, 0.01},
	["key_pennenabeachmotel3"] = {"Nøgle - key_pennenabeachmotel3", "Nøgler til key_pennenabeachmotel3", nil, 0.01},
	["key_pennenabeachmotel4"] = {"Nøgle - key_pennenabeachmotel4", "Nøgler til key_pennenabeachmotel4", nil, 0.01},
	["key_pennenabeachmotel5"] = {"Nøgle - key_pennenabeachmotel5", "Nøgler til key_pennenabeachmotel5", nil, 0.01},
	["key_pennenabeachmotel6"] = {"Nøgle - key_pennenabeachmotel6", "Nøgler til key_pennenabeachmotel6", nil, 0.01},
	["key_pennenabeachmotel7"] = {"Nøgle - key_pennenabeachmotel7", "Nøgler til key_pennenabeachmotel7", nil, 0.01},
	["key_pennenabeachmotel8"] = {"Nøgle - key_pennenabeachmotel8", "Nøgler til key_pennenabeachmotel8", nil, 0.01},
	["key_pennenabeachmotel9"] = {"Nøgle - key_pennenabeachmotel9", "Nøgler til key_pennenabeachmotel9", nil, 0.01},
	["key_pennenabeachmotel10"] = {"Nøgle - key_pennenabeachmotel10", "Nøgler til key_pennenabeachmotel10", nil, 0.01},
	["key_pennenabeachmotel11"] = {"Nøgle - key_pennenabeachmotel11", "Nøgler til key_pennenabeachmotel11", nil, 0.01},
	["key_pennenabeachmotel12"] = {"Nøgle - key_pennenabeachmotel12", "Nøgler til key_pennenabeachmotel12", nil, 0.01},
	["key_pennenabeachmotel13"] = {"Nøgle - key_pennenabeachmotel13", "Nøgler til key_pennenabeachmotel13", nil, 0.01},
	["key_pennenabeachmotel14"] = {"Nøgle - key_pennenabeachmotel14", "Nøgler til key_pennenabeachmotel14", nil, 0.01},
	["key_pennenabeachmotel15"] = {"Nøgle - key_pennenabeachmotel15", "Nøgler til key_pennenabeachmotel15", nil, 0.01},
	["key_pennenabeachmotel16"] = {"Nøgle - key_pennenabeachmotel16", "Nøgler til key_pennenabeachmotel16", nil, 0.01},
	["key_pennenabeachmotel17"] = {"Nøgle - key_pennenabeachmotel17", "Nøgler til key_pennenabeachmotel17", nil, 0.01},
	["key_pennenabeachmotel18"] = {"Nøgle - key_pennenabeachmotel18", "Nøgler til key_pennenabeachmotel18", nil, 0.01},
	["key_pennenabeachmotel19"] = {"Nøgle - key_pennenabeachmotel19", "Nøgler til key_pennenabeachmotel19", nil, 0.01},
	["key_pennenabeachmotel20"] = {"Nøgle - key_pennenabeachmotel20", "Nøgler til key_pennenabeachmotel20", nil, 0.01},
	["key_pennenabeachmotel21"] = {"Nøgle - key_pennenabeachmotel21", "Nøgler til key_pennenabeachmotel21", nil, 0.01},
	["key_pennenabeachmotel22"] = {"Nøgle - key_pennenabeachmotel22", "Nøgler til key_pennenabeachmotel22", nil, 0.01},
	["key_pennenabeachmotel23"] = {"Nøgle - key_pennenabeachmotel23", "Nøgler til key_pennenabeachmotel23", nil, 0.01},
	["key_pennenabeachmotel24"] = {"Nøgle - key_pennenabeachmotel24", "Nøgler til key_pennenabeachmotel24", nil, 0.01},
	["key_pennenabeachmotel25"] = {"Nøgle - key_pennenabeachmotel25", "Nøgler til key_pennenabeachmotel25", nil, 0.01},
	["key_pennenabeachmotel26"] = {"Nøgle - key_pennenabeachmotel26", "Nøgler til key_pennenabeachmotel26", nil, 0.01},
	["key_pennenabeachmotel27"] = {"Nøgle - key_pennenabeachmotel27", "Nøgler til key_pennenabeachmotel27", nil, 0.01},
	["key_pennenabeachmotel28"] = {"Nøgle - key_pennenabeachmotel28", "Nøgler til key_pennenabeachmotel28", nil, 0.01},
	["key_pennenabeachmotel29"] = {"Nøgle - key_pennenabeachmotel29", "Nøgler til key_pennenabeachmotel29", nil, 0.01},
	["key_pennenabeachmotel30"] = {"Nøgle - key_pennenabeachmotel30", "Nøgler til key_pennenabeachmotel30", nil, 0.01},
	["key_pennenabeachmotel31"] = {"Nøgle - key_pennenabeachmotel31", "Nøgler til key_pennenabeachmotel31", nil, 0.01},
	["key_pennenabeachmotel32"] = {"Nøgle - key_pennenabeachmotel32", "Nøgler til key_pennenabeachmotel32", nil, 0.01},
	["key_pennenabeachmotel33"] = {"Nøgle - key_pennenabeachmotel33", "Nøgler til key_pennenabeachmotel33", nil, 0.01},
	["key_pennenabeachmotel34"] = {"Nøgle - key_pennenabeachmotel34", "Nøgler til key_pennenabeachmotel34", nil, 0.01},
	["key_pennenabeachmotel35"] = {"Nøgle - key_pennenabeachmotel35", "Nøgler til key_pennenabeachmotel35", nil, 0.01},
	["key_pennenabeachmotel36"] = {"Nøgle - key_pennenabeachmotel36", "Nøgler til key_pennenabeachmotel36", nil, 0.01},
	["key_lapuerta1"] = {"Nøgle - key_lapuerta1", "Nøgler til key_lapuerta1", nil, 0.01},
	["key_lapuerta2"] = {"Nøgle - key_lapuerta2", "Nøgler til key_lapuerta2", nil, 0.01},
	["key_lapuerta3"] = {"Nøgle - key_lapuerta3", "Nøgler til key_lapuerta3", nil, 0.01},
	["key_lapuerta4"] = {"Nøgle - key_lapuerta4", "Nøgler til key_lapuerta4", nil, 0.01},
	["key_westvinewood"] = {"Nøgle - key_westvinewood", "Nøgler til key_westvinewood", nil, 0.01},
	["key_steeleway"] = {"Nøgle - key_steeleway", "Nøgler til key_steeleway", nil, 0.01},
	["key_themotormotel1"] = {"Nøgle - key_themotormotel1", "Nøgler til key_themotormotel1", nil, 0.01},
	["key_themotormotel2"] = {"Nøgle - key_themotormotel2", "Nøgler til key_themotormotel2", nil, 0.01},
	["key_themotormotel3"] = {"Nøgle - key_themotormotel3", "Nøgler til key_themotormotel3", nil, 0.01},
	["key_themotormotel4"] = {"Nøgle - key_themotormotel4", "Nøgler til key_themotormotel4", nil, 0.01},
	["key_themotormotel5"] = {"Nøgle - key_themotormotel5", "Nøgler til key_themotormotel5", nil, 0.01},
	["key_themotormotel6"] = {"Nøgle - key_themotormotel6", "Nøgler til key_themotormotel6", nil, 0.01},
	["key_themotormotel7"] = {"Nøgle - key_themotormotel7", "Nøgler til key_themotormotel7", nil, 0.01},
	["key_themotormotel8"] = {"Nøgle - key_themotormotel8", "Nøgler til key_themotormotel8", nil, 0.01},
	["key_themotormotel9"] = {"Nøgle - key_themotormotel9", "Nøgler til key_themotormotel9", nil, 0.01},
	["key_westvinewoodmotel"] = {"Nøgle - key_westvinewoodmotel", "Nøgler til key_westvinewoodmotel", nil, 0.01},


	["key_havnelager1"] = {"Nøgle - Havne lager 1", "Nøgler til havne lager 1", nil, 0.01},
	["key_havnelager2"] = {"Nøgle - Havne lager 2", "Nøgler til havne lager 2", nil, 0.01},


	--Bande huse
	["key_TL"] = {"Nøgle - Teqi-la-la	","Nøgler til Teqi-la-la	", nil, 0.01},
	["key_kartel3"] = {"Nøgle - Kartellet","Nøgler Kartellet", nil, 0.01},
	["key_yj2"] = {"Nøgle - Yellow Jack","Nøgler Yellow Jack", nil, 0.01},
	["key_borgen"] = {"Nøgle - Borgen","Nøgler til Borgen", nil, 0.01},
	["key_lostmc"] = {"Nøgle - Trailerpark","Nøgler til Trailerpark", nil, 0.01},
	["key_lager"] = {"Nøgle - Lager","Nøgler til lageret", nil, 0.01},
	["key_jakeconnor"] = {"Nøgle - Jake Connor","Nøgler til porten", nil, 0.01},
	["key_soa2"] = {"Nøgle - Sons of Anarchy","Nøgler til porten", nil, 0.01},
	["key_vagos"] = {"Nøgle - Russian Brotherhood","Nøgler til døren", nil, 0.01},
	["key_bloodz"] = {"Nøgle - Bloodz","Nøgler til døren", nil, 0.01},
	["key_lafamilia"] = {"Nøgle - La Familia","Nøgler til døren", nil, 0.01},

	--Cali kister
	["key_gurli"] = {"Nøgle - Gurli","Nøgler", nil, 0.01},
	["key_gris"] = {"Nøgle - Gris","Nøgler", nil, 0.01},

	["key_drugdealer"] = {"Nøgle - Drugkartel","Nøgler til drugkartellet", nil, 0.01},

	["mechabo"] = {"Süper Mechanics - Abbonement","Süper Mechanics - Abbonement", nil, 0.01},


	--Forsyningen, A&M, osv
	["gavekort1"] = {"Gavekort - 10000 kr", "", nil, 0},
	["gavekort2"] = {"Gavekort - 25000 kr", "", nil, 0},
	["gavekort3"] = {"Gavekort - 50000 kr", "", nil, 0},
	["gavekort4"] = {"Gavekort - 100000 kr", "", nil, 0},
	["faxekondi"] = {"Faxekondi", "", nil, 0},

	["vasketøj"] = {"Beskidt vasketøj", "", nil, 25},
	-- [""] = {"Sure sokker", "", nil, 0.1},


-- FISH
	["fisk1"] = {"Laks", "", nil, 2.00},
	["fisk2"] = {"Gedde", "", nil, 2.00},
	["fisk3"] = {"Ål", "", nil, 1.00},
	["fisk4"] = {"Regnbueørred", "", nil, 4.00},
	["fisk5"] = {"Brasen", "", nil, 3.00},
	["fisk6"] = {"Aborre", "", nil, 0.50},


-- Radioer
	["radio"] = {"Radio", "", nil, 2.00},


-- Bandetøj

	-- POLO GANG
	["polov1"] = {"Polo Vest (Normal)", "", nil, 0},
	["polov2"] = {"Polo Vest (Bombe)", "", nil, 0},
	["polot1"] = {"Polo T-shirt (Grøn)", "", nil, 0},
	["polot2"] = {"Polo T-shirt (Grå)", "", nil, 0},
	["polot3"] = {"Polo Hoodie (Grøn)", "", nil, 0},
	["polot4"] = {"Polo Hoodie (Grå)", "", nil, 0},

	-- CALI CARTEL
	["caliv1"] = {"Cali Vest", "", nil, 0},
	["calit1"] = {"Cali Dunjakke", "", nil, 0},
	["calit2"] = {"Cali Hoodie", "", nil, 0},

	-- LA CELU
	["celut1"] = {"La Celu Halskrage", "", nil, 0},
	["celuv1"] = {"La Celu Vest", "", nil, 0},

	-- LORENZO FAMILY
	["lorenzov1"] = {"Lorenzo Vest", "", nil, 0},

	-- NINERS
	["ninerst1"] = {"Niners Hoodie", "", nil, 0},
	["ninerst2"] = {"Niners T-Shirt", "", nil, 0},
	["ninersv1"] = {"Niners Vest", "", nil, 0},



}

-- load more items function
local function load_item_pack(name)
	local items = module("cfg/item/"..name)
	if items then
		for k,v in pairs(items) do
			cfg.items[k] = v
		end
	else
		print("[vRP] item pack ["..name.."] not found")
	end
end

-- PACKS
load_item_pack("ting")
load_item_pack("required")
load_item_pack("jobs")
load_item_pack("food")
load_item_pack("drugs")
load_item_pack("weapons")

return cfg
