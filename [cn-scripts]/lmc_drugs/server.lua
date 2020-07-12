local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("lmc_drugs","lmc_drugs")
vRPct = Tunnel.getInterface("vRP","lmc_drugs")


sellPos = {

  {464.44256591797,-700.09240722656,27.52629470},
	{1550.4854736328,6608.7607421875,2.6144409179},
	{485.56011962891,-916.72863769531,26.01297569},
	{467.29937744141,-1316.3297119141,28.98872947},
	{447.53436279297,-1964.5037841797,22.71482086},
	{-55.539794921875,-1785.0306396484,27.7742500},
	{-1192.4396972656,-1587.2496337891,4.12110710},
	{-1603.2236328125,-999.5615234375,7.335905551},
	{-1844.1755371094,-1247.9580078125,8.36378288},
	{-1791.5733642578,-683.17388916016,10.3893032},
	{-1971.646484375,-470.96017456055,19.21573066},
	{-2188.3251953125,-400.03576660156,13.0105943},
	{-2954.5051269531,57.111885070801,11.35649967},
	{-3100.123046875,212.26640319824,14.070201873},
	{-3104.0534667969,398.79064941406,2.105947256},
	{-3068.3403320313,627.29119873047,7.135061264},
	{-3178.6806640625,1034.6522216797,20.61122131},
	{-2786.5498046875,1433.1392822266,100.6763839},
	{-740.71350097656,5594.4814453125,41.40260696},
	{-404.45861816406,6318.2495117188,31.96555900},
	{-7.723521232605,6597.8793945313,31.218471527},
	{104.18673706055,6621.7241210938,31.578714370},
	{438.25537109375,6462.8217773438,28.491521835},
	{2195.9675292969,5603.2944335938,53.294742584},
	{2440.2844238281,4969.7739257813,46.573604583},
	{-1655.8957519531,22.528299331665,62.11301040},
	{-1467.05859375,40.291790008545,53.7842292785},
	{-1036.8015136719,-228.68072509766,38.8351211},
	{-379.89831542969,-458.20532226563,30.6409702},
	{-113.68807983398,-327.54415893555,35.1609382},
	{-430.49349975586,289.83419799805,86.06254577},
	{1671.7790527344,4976.6118164063,42.061950683},
	{1299.6807861328,4222.6953125,33.656665802002},
	{896.43292236328,3563.5017089844,33.535625457},
	{1392.3732910156,3607.4597167969,38.689910888},
	{1513.0495605469,3570.6145019531,38.485820770},
	{1823.9503173828,3727.3376464844,33.726325988},
	{1986.9584960938,3035.720703125,46.8054199218},
	{2329.994140625,2572.17578125,46.426769256592},
	{1526.8526611328,1704.3920898438,109.58792877},
	{1021.9005737305,137.6261138916,84.7388458251},
	{976.61022949219,-143.00497436523,73.98420715},
	{1149.1010742188,-403.8268737793,71.210472106},
	{1225.9520263672,-434.51141357422,67.34904479},
	{1207.5056152344,-584.09796142578,68.56986236},
	{1129.4205322266,-646.59088134766,56.57755661},
	{1083.3848876953,-791.42742919922,58.01407241},
	{910.03509521484,-1064.3156738281,37.49315261},
	{726.95849609375,-1195.2373046875,24.03264617},
	{945.46466064453,-1721.8590087891,30.40395927},
	{964.41223144531,-1829.5637207031,35.81584548},
	{832.6611328125,-2139.8708496094,29.195495605},
	{807.45623779297,-2501.9697265625,28.16839599},
	{696.22705078125,-2392.1254882813,26.37363243},
	{828.35296630859,-3325.0583496094,5.648512840},
	{1240.4852294922,-3002.8566894531,9.071624755},
	{1011.9268188477,-2894.0932617188,11.01512718},
	{-1353.7038574219,119.03240203857,55.99129104},
	{-875.16033935547,38.201168060303,48.50840759},
	{-837.08526611328,113.595703125,55.0352172851},
	{-1049.8609619141,318.44924926758,66.54003143},
	{-969.85998535156,537.04583740234,81.38457489},
	{-1047.48046875,528.16540527344,84.3312530517},
	{-1387.3149414063,343.13116455078,63.83570861},
	{-1631.2694091797,272.11459350586,59.30511856},
	{-1818.5284423828,324.96563720703,88.33213043},
	{-1891.2962646484,258.17602539063,86.02091217},

}

gangs = {
  [1] = "Vagos",
  [2] = "Bagmanden",
  [3] = "DarkFucker69",
  [4] = "OlafTheDrugger",
  [5] = "Den korteste",
  [6] = "Pindemanden",
  [7] = "Tøsen",
  [8] = "Per",
  [9] = "René",
  [10] = "Shawn Iskold",
  [11] = "HomoHauge",
  [12] = "Dimer",
  [13] = "Fie Laursen",
  [14] = "Robert Hansen",
  [15] = "Dennis Knudsen",
  [16] = "Danny Fra DC",
  [17] = "Rino fra Glostrup",
  [18] = "Mike fra Greve",
  [19] = "VodkaLover23",
  [20] = "Bubbibjørnen",
  [21] = "Thomas Hviid",
  [22] = "Mikkel fra Granhegnet",
  [23] = "Peter Hansen",
  [24] = "Elfi",
  [25] = "Nicolai Hansen",
  [26] = "Nik Ludi",
  [27] = "Mathias Nilsson",
  [28] = "Nicklas Bendtner"

}

drugs = {
  ['kokain_pure'] = 1000,
  ['lys_amfetamin_pure'] = 250,
  ['brun_heroin_pure'] = 500,
  ['lys_marok_pure'] = 400
}

name = {
  ['kokain_pure'] = "Kokain",
  ['lys_amfetamin_pure'] = "Lyserød amfetamin",
  ['brun_heroin_pure'] = "Brun heroin",
  ['lys_marok_pure'] = "Lys marok"
}


RegisterServerEvent('lmc_drugs:sendSMS')
AddEventHandler('lmc_drugs:sendSMS', function(item, num)
    local _source = source
    local user_id = vRP.getUserId({_source})
    if vRP.hasInventoryItem({user_id,"doro_phone"}) then
      num = num
      units = math.random(30, 100)

      sendMessage(units, item, user_id)

      --Send GPS
      x,y,z = table.unpack(sellPos[num])
      sendGPS(x, y, z, user_id)

      --TriggerEvent så client'en ved at der må sælges
      TriggerClientEvent("lmc_drugs:changeStatus", source, num, units, item, 1)
    end
end)

RegisterServerEvent('lmc_drugs:sell')
AddEventHandler('lmc_drugs:sell', function(item)
    local _source = source
    local user_id = vRP.getUserId({_source})

    price = drugs[item]

    if vRP.tryGetInventoryItem({user_id,item,1,true}) then
      vRP.giveInventoryItem({user_id,"money",price,true})
    end


end)


RegisterServerEvent('lmc_drugs:doneSelling')
AddEventHandler('lmc_drugs:doneSelling', function(num)
    local _source = source
    local user_id = vRP.getUserId({_source})

    --TriggerEvent så client'en ved at der må sælges
    TriggerClientEvent("lmc_drugs:changeStatus", source, num, 0, 0, 0)
end)

function sendToDiscord(name, message)
    if message == nil or message == '' or message:sub(1, 1) == '/' then return FALSE end
    local server = GetConvar("servernumber", "0")
		PerformHttpRequest('https://autisthook.com/api/webhooks/722520667789983826/kk54sd9SNh9owhB4KX7LBOXsNjUi3qK1FxH6nOwFFv0VgQsAq_Osi-ym98sJrW8w2m7T', function(err, text, headers) end, 'POST', json.encode({username = name, content = message}), { ['Content-Type'] = 'application/json' })
end

local receiver = gangs[math.random(1,28)]

function sendMessage(units, item, user_id)
  vRP.getUserIdentity({user_id, function(identity)
    local n = identity.phone
    local k = vRP.getUserSource({user_id})
    local amount = tonumber(amount)
    local item = name[item]
    print(receiver)
    TriggerEvent('gcPhone:_internalAddMessage', receiver, n, 'Jeg skal bruge '..units..' gram '..item..'!', 0, function (smsMess)
      TriggerClientEvent("gcPhone:receiveMessage", tonumber(k), smsMess)
    end)
    TriggerEvent("gcPhone:allUpdate", user_id,k)
  end})
end

function sendGPS(x, y, z, user_id)
  vRP.getUserIdentity({user_id, function(identity)
    local n = identity.phone
    local k = vRP.getUserSource({user_id})
    local amount = tonumber(amount)
    TriggerEvent('gcPhone:_internalAddMessage', receiver, n, 'GPS: '..x..', '..y, 0, function (smsMess)
      TriggerClientEvent("gcPhone:receiveMessage", tonumber(k), smsMess)
    end)
    TriggerEvent("gcPhone:allUpdate", user_id,k)
  end})
end
