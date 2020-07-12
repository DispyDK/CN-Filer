local salary = {
	["Rigspolitichef"] = {salary = 25000, perm = "politiledelse.paycheck"},
	["Vice Rigspolitichef"] = {salary = 25000, perm = "politiviceledelse.paycheck"},
	["Politidirektør"] = {salary = 22500, perm = "policedirector.paycheck"},
	["Vice Politidirektør"] = {salary = 22500, perm = "policevicedirector.paycheck"},
	["Politiinspektør"] = {salary = 20000, perm = "policeinspector.paycheck"},
	["Politikommissær"] = {salary = 17500, perm = "policecommissioner.paycheck"},
	["Politiassistent Første Grad"] = {salary = 15000, perm = "politiassistent1grad.paycheck"},
	["Politiassistent"] = {salary = 13750, perm = "politiassistent.paycheck"},
	["Politibetjent"] = {salary = 12500, perm = "police.paycheck"},
	["Politielev"] = {salary = 10000, perm = "politielev.paycheck"},

	["PET"] = {salary = 15500, perm = "pet.paycheck"},

	["Højesterets Dommer"] = {salary = 20000, perm = "dommerchef.paycheck"},
	["Dommer"] = {salary = 20000, perm = "dommer.paycheck"},


	["Regionschef"] = {salary = 25000, perm = "regionschef.paycheck"},
	["Overlæge"] = {salary = 22500, perm = "headdoctor.paycheck"},
	["Læge"] = {salary = 19500, perm = "doctor.paycheck"},
	["Paramediciner"] = {salary = 17000, perm = "paramediciner.paycheck"},
	["Ambulanceredder"] = {salary = 15500, perm = "emergency.paycheck"},
	["Sygeplejerske"] = {salary = 12500, perm = "nurse.paycheck"},
	["Ambulanceelev"] = {salary = 10000, perm = "emergencyelev.paycheck"},

	["Mekaniker Chef"] = {salary = 12500, perm = "mekanikerchef.paycheck"},
	["Mekaniker"] = {salary = 7500, perm = "mekaniker.paycheck"},
	
	["Gumphermarket Ejer"] = {salary = 12500, perm = "gumphermarketejer.paycheck"},
	["Gumphermarket Butiks Assistent"] = {salary = 10000, perm = "gumphermarketbutiksassistent.paycheck"},
	["Gumphermarket Ansat"] = {salary = 7500, perm = "gumphermarketansat.paycheck"},
	["Gumphermarket Prøve"] = {salary = 6000, perm = "gumphermarketprøve.paycheck"},
	
	["Casino Manager"] = {salary = 15000, perm = "casinomanager.paycheck"},
	["Casino Ansat"] = {salary = 10000, perm = "casinoansat.paycheck"},
	["Casino Prøve Ansat"] = {salary = 7500, perm = "casinoprøveansat.paycheck"},
	
	["Kørelærer Chef"] = {salary = 12500, perm = "kørelærerchef.paycheck"},
	["Kørelærer Ansat"] = {salary = 7500, perm = "kørelæreransat.paycheck"},

	["Politiadvokat Chef"] = {salary = 17500, perm = "politiadvokatchef.paycheck"},
	["Politiadvokat"] = {salary = 15000, perm = "politiadvokat.paycheck"},

	["Advokat Chef"] = {salary = 17500, perm = "advokatchef.paycheck"},
	["Advokatpartner"] = {salary = 16500, perm = "advokatpartner.paycheck"},
	["Advokat"] = {salary = 15000, perm = "advokat.paycheck"},
	["Advokatelev"] = {salary = 13500, perm = "advokatelev.paycheck"},

	["Sikkerhedsvagt Chef"] = {salary = 15000, perm = "sikkerhedsvagtchef.paycheck"},
	["Sikkerhedsvagt"] = {salary = 10000, perm = "sikkerhedsvagt.paycheck"},

	["Taxa"] = {salary = 9000, perm = "taxi.paycheck"},

	["Våbendealer"] = {salary = 15000, perm = "weapondealer.paycheck"},
	["Drugdealer"] = {salary = 15000, perm = "drugdealer.paycheck"},

	["Lastbil Chauffør"] = {salary = 7500, perm = "trucker.paycheck"},

	["Ejendomsmægler Chef"] = {salary = 15000, perm = "realestatechef.paycheck"},
	["Ejendomsmægler"] = {salary = 12500, perm = "realestate.paycheck"},

	["Bilforhandler Chef"] = {salary = 12500, perm = "bilforhandlerchef.paycheck"},
	["Bilforhandler"] = {salary = 7500, perm = "bilforhandler.paycheck"},

	["Miner"] = {salary = 6000, perm = "miner.paycheck"},
	["Skov Hugger"] = {salary = 6000, perm = "skovhugger.paycheck"},
	["Arbejdsløs"] = {salary = 4500, perm = "nojob.paycheck"},

}

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(1800000) -- Every X ms you'll get paid (300000 = 5 min)
		for user_id,source in pairs(vRP.getUsers()) do
			for k,v in pairs(salary) do
				Citizen.Wait(50)
				if vRP.hasPermission(user_id,v.perm) then
					vRP.giveBankMoney(user_id,tonumber(v.salary))
					TriggerClientEvent("pNotify:SendNotification", source,{text = "Lønudbetaling: <b style='color: #4E9350'>"..format_thousands(math.floor(tonumber(v.salary))).." DKK</b>.<br/>Erhverv: <b style='color: #72AEE5'>"..k.."</b>.", type = "info", queue = "global",timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
					break
				end
			end
		end
	end
end)

function format_thousands(v)
	local s = string.format("%d", math.floor(v))
	local pos = string.len(s) % 3
	if pos == 0 then pos = 3 end
	return string.sub(s, 1, pos)
			.. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end
