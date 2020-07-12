maxErrors = 5 -- Change the amount of Errors allowed for the player to pass the driver test, any number above this will result in a failed test

local options = {
	x = 0.1,
	y = 0.2,
	width = 0.2,
	height = 0.04,
	scale = 0.4,
	font = 0,
	menu_title = "Kørelærer",
	menu_subtitle = "Kategorier",
	color_r = 0,
	color_g = 128,
	color_b = 255,
}

local dmvped = {
	{type=4, hash=0xc99f21c4, x=239.471, y=-1380.96, z=32.74176, a=3374176},
}

local dmvpedpos = {
	{ ['x'] = 239.471, ['y'] = -1380.96, ['z'] = 33.74176 },
}

--[[Locals]]--

local dmvschool_location = {232.054, -1389.98, 29.4812}

local kmh = 3.6
local VehSpeed = 0

local speed_limit_resi = 60
local speed_limit_town = 90
local speed_limit_freeway = 140
local speed = kmh

local DTutOpen = false

--[[Events]]--

AddEventHandler("playerSpawned", function()
	TriggerServerEvent('dmv:LicenseStatus')
end)

TestDone = false

RegisterNetEvent('dmv:CheckLicStatus')
AddEventHandler('dmv:CheckLicStatus', function()
	--Check if player has completed theory test
	TestDone = true
	theorylock = false
	testlock = false
end)

--[[Functions]]--

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function DrawMissionText2(m_text, showtime)
	ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

function LocalPed()
	return GetPlayerPed(-1)
end

function GetCar()
	return GetVehiclePedIsIn(GetPlayerPed(-1),false)
end

function Chat(debugg)
	TriggerEvent("chatMessage", '', { 0, 0x99, 255 }, tostring(debugg))
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

--[[Arrays]]--
onTtest = false
onPtest = false
onTestEvent = 0
theorylock = false
testlock = true
DamageControl = 0
SpeedControl = 0
Error = 0

function startintro()
	DIntro()
	theorylock = false
end

function startttest()
	TriggerServerEvent('dmv:ttcharge')
end

RegisterNetEvent('dmv:startttest')
AddEventHandler('dmv:startttest', function()
	openGui()
	Menu.hidden = not Menu.hidden
end)

function startptest()
	if testlock then
		TriggerEvent("pNotify:SendNotification",{text = "<b style='color:red>Låst</b>",type = "error",timeout = (4000),layout = "center",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
	else
		TriggerServerEvent('dmv:ptcharge')
	end
end

RegisterNetEvent('dmv:startptest')
AddEventHandler('dmv:startptest', function()
	onTestBlipp = AddBlipForCoord(238.90466308594,-1381.7158203125,33.741744995117)
	N_0x80ead8e2e1d5d52e(onTestBlipp)
	SetBlipRoute(onTestBlipp, 1)
	onTestEvent = 1
	DamageControl = 1
	SpeedControl = 1
	onPtest = true
	DTut()
end)

function EndDTest()
	if Error > maxErrors then
		TriggerEvent("pNotify:SendNotification",{text = "Du dumpede med <font style='color:#f90000'>"..Error.." fejl</font>",type = "error",timeout = (5000),layout = "center",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
		onPtest = false
		EndTestTasks()
	else
		--local licID = 1
		TriggerServerEvent('dmv:success')
		onPtest = false
		TestDone = true
		theorylock = false
		testlock = false
		TriggerEvent("pNotify:SendNotification",{text = "Du bestod med <font style='color:#f90000'>"..Error.." fejl</font>, tillykke!",type = "success",timeout = (5000),layout = "center",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
		EndTestTasks()
	end
end

function EndTestTasks()
	onTestBlipp = nil
	onTestEvent = 0
	DamageControl = 0
	Error = 0
	TaskLeaveVehicle(GetPlayerPed(-1), veh, 0)
	Wait(1000)
	CarTargetForLock = GetPlayersLastVehicle(GetPlayerPed(-1))
	lockStatus = GetVehicleDoorLockStatus(CarTargetForLock)
	SetVehicleDoorsLocked(CarTargetForLock, 2)
	SetVehicleDoorsLockedForPlayer(CarTargetForLock, PlayerId(), false)
	SetEntityAsMissionEntity(CarTargetForLock, true, true)
	Wait(2000)
	Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( CarTargetForLock ) )


end


function SpawnTestCar()
	Citizen.Wait(0)
	local myPed = GetPlayerPed(-1)
	local player = PlayerId()
	local vehicle = GetHashKey('blista')

	RequestModel(vehicle)

	while not HasModelLoaded(vehicle) do
		Wait(1)
	end
	colors = table.pack(GetVehicleColours(veh))
	extra_colors = table.pack(GetVehicleExtraColours(veh))
	plate = math.random(100, 900)
	local spawned_car = CreateVehicle(vehicle, 249.40971374512,-1407.2303466797,30.409454345703, true, false)
	SetVehicleColours(spawned_car,4,5)
	SetVehicleExtraColours(spawned_car,extra_colors[1],extra_colors[2])
	SetEntityHeading(spawned_car, 317.64)
	SetVehicleOnGroundProperly(spawned_car)
	SetPedIntoVehicle(myPed, spawned_car, - 1)
	SetModelAsNoLongerNeeded(vehicle)
	Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(spawned_car))
	DTutOpen = false
	SetEntityVisible(myPed, true)
	SetVehicleDoorsLocked(GetCar(), 4)
	FreezeEntityPosition(myPed, false)

	Citizen.CreateThread(function()
		Citizen.Wait(1000)
		TriggerEvent("advancedFuel:setEssence", 100, GetVehicleNumberPlateText(GetVehiclePedIsUsing(GetPlayerPed(-1))), GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(GetPlayerPed(-1)))))
	end)

end

function DIntro()
	Citizen.Wait(0)
	local myPed = GetPlayerPed(-1)
	DTutOpen = true
	SetEntityCoords(myPed,173.01181030273, -1391.4141845703, 29.408880233765,true, false, false,true)
	TriggerEvent("pNotify:SendNotification",{
		text = "<b style='color:#1E90FF'>Introduktion</b> <br /><br />Teori og praksis er begge en vigtig del af introduktionen.<br />Denne introduktion vil dække de basale ting som du skal kunne i både teoriprøven og praksis.<br /><br />Du får udleveret vigtig information i begge prøver, som kan gøre en væsentlig forskel når du køre ude i trafikken.<br /><br />Sæt dig godt til rette og lad os komme igang!",
		type = "alert",
		timeout = (15000),
		layout = "center",
		queue = "global"
	})
	SetEntityCoords(myPed,-428.49026489258, -993.306640625, 46.008815765381,true, false, false,true)
	TriggerEvent("pNotify:SendNotification",{
		text = "<b style='color:#1E90FF'>Dækmønster på dit køretøj</b> <br /> Det danske lovkrav om dækmønste lyder på 1,6 mm <br /> Hvis dette ikke bliver overholdt kan det forsage nogle fatale ulykker <br /> ",
		type = "alert",
		timeout = (15000),
		layout = "center",
		queue = "global"
	})
	Citizen.Wait(16500)
	Citizen.Wait(16500)
	SetEntityCoords(myPed,-428.49026489258, -993.306640625, 46.008815765381,true, false, false,true)
	TriggerEvent("pNotify:SendNotification",{
		text = "<b style='color:#1E90FF'>Ulykker, hændelser og miljøhensyn</b><br /><br /><b style='color:#87CEFA'>Færdselsregler for bilister</b><br />Alle bilister er forpligtet til at overholde alle færdselsregler for at undgå at skade andre. Ved ikke at overholde færdselsreglerne er du ansvarlig for alle skader herfra.<br /><br />Når du ser og/eller hører en sirene skal du give plads til udrykningskøretøjet, eventuelt ved at køre ind til højre.<br />Du skal holde ind til siden hvis en betjent sætter blink efter dig og/eller beder dig om det.<br /><br /><b style='color:#87CEFA'>Uansvarlig Kørsel</b><br />Færdsel som er til fare for andre bilister, fodgængere eller ejendele bliver anset som uansvarlig kørsel.<br />Uansvarlig kørsel kan føre til tragiske uheld. Det er klogt at køre forsigtigt og altid holde udkig fremad og tilbage for at formindste potentielle uheld.<br />",
		type = "alert",
		timeout = (15000),
		layout = "center",
		queue = "global"
	})
	Citizen.Wait(16500)
	SetEntityCoords(myPed,-282.55557250977, -282.55557250977, 31.633310317993,true, false, false,true)
	TriggerEvent("pNotify:SendNotification",{
		text = "<b style='color:#1E90FF'>Beboelsesområde</b> <br /><br />Hold en ansvarlig fart ved ikke at køre hurtigere end skiltet, og sænk farten ved traffikerede områder og ved køer.<br /><br />Sørg for at holde dig i midten af in vejbane og undgå at køre ude i parkerings-områder.<br /><br />Sørg for at holde en sikker afstand til de andre bilister. En god finger-regel er at holde halvdelen af din fart i meter-afstand til bilen foran dig.<br /><br />Fartgrænsen i boligområder er på 50kmt.<br />",
		type = "alert",
		timeout = (15000),
		layout = "center",
		queue = "global"
	})
	Citizen.Wait(16500)
	SetEntityCoords(myPed,246.35220336914, -1204.3403320313, 43.669715881348,true, false, false,true)
	TriggerEvent("pNotify:SendNotification",{
		text = "<b style='color:#1E90FF'>Tæt bebyggede områder/Byzone</b> <br /><br />Den generelle fartgrænse på 80km/t er gældende overalt, medmindre andet er angivet.<br />Kørsel ved højere hastigheder kan have fatale konsekvenser for dit helbred og dit kørekort.<br /><br />Sænk hastigheden når du:<br /><br />&bull; Kører på vejen med andre trafikkanter<br />&bull; Når du kører om natten, grundet forværret syn.<br />&bull; Kører i dårlige vejrforhold<br /><br />Husk, at større køretøjer og motorcykler har længere bremselængde<br /> Hastighedsgrænsen på en motortrafikvej er 80 km/t hvis ikke andet er skiltet.",
		type = "alert",
		timeout = (15000),
		layout = "center",
		queue = "global"
	})
	Citizen.Wait(16500)
	SetEntityCoords(myPed,-428.49026489258, -993.306640625, 46.008815765381,true, false, false,true)
	TriggerEvent("pNotify:SendNotification",{
		text = "<b style='color:#1E90FF'>Brug af horn</b> <br /> Du må bruge dit horn som en advarsel til andre bilister eller fodgængere. <br /> Eksempelvis må du bruge det hvis en kører ud foran dig og du er ved at køre galt <br />",
		type = "alert",
		timeout = (15000),
		layout = "center",
		queue = "global"
	})
	Citizen.Wait(16500)
	SetEntityCoords(myPed,-138.413, -2498.53, 52.2765,true, false, false,true)
	TriggerEvent("pNotify:SendNotification",{
		text = "<b style='color:#1E90FF'>Motorveje</b> <br /><br />Trafikken på motorvejen er generelt hurtigere end normal trafik på landeveje og i byzoner.<br />Det er virkelig vigtigt her, at du orientere dig langt frem, da der er flere ting at holde øje med.<br /><br />Hold øje med trafikken, og sørg for at din hastighed matcher de andre når du fletter ind.<br /><br />Fartgrænsen på motorvejen er 120 km/t.<br />",
		type = "alert",
		timeout = (15000),
		layout = "center",
		queue = "global"
	})
	Citizen.Wait(16500)
	SetEntityCoords(myPed,187.465, -1428.82, 43.9302,true, false, false,true)
	TriggerEvent("pNotify:SendNotification",{
		text = "<b style='color:#1E90FF'>Alkohol</b> <br /><br />Kørsel under indflydelse af alkohol kan være fatalt. Når du har alkohol i blodet, falder din reaktionshastighed og dit syn snævrer ind. Dog, tillader de danske love kørsel af køretøjer, hvis du har en promille på under 0.5‰<br /><br />",
		type = "alert",
		timeout = (15000),
		layout = "center",
		queue = "global"
	})
	Citizen.Wait(16500)
	SetEntityCoords(myPed,173.01181030273, -1391.4141845703, 29.408880233765,true, false, false,true)
	TriggerEvent("pNotify:SendNotification",{
		text = "<b style='color:#1E90FF'>Ansvarlig Kørsel</b> Når du sætter dig ind i et køretøj, og din promille er over 0,5 må du ikke køre køretøjet <br /> Derudover skal du køre ansvarligt, dvs. du kan godt få en bøde hvis du har en promille under den tilladte promille. Hvis du ikke kører ansvarligt. <br />",
		type = "alert",
		timeout = (15000),
		layout = "center",
		queue = "global"
	})
	Citizen.Wait(16500)
	SetEntityCoords(myPed,238.756, -1381.65, 32.743,true, false, false,true)
	SetEntityVisible(myPed, true)
	FreezeEntityPosition(myPed, false)
	DTutOpen = false
end

function DTut()
	Citizen.Wait(0)
	local myPed = GetPlayerPed(-1)
	DTutOpen = true
	SetEntityCoords(myPed,238.70791625977, -1394.7208251953, -1394.7208251953,true, false, false,true)
	SetEntityHeading(myPed, 314.39)
	TriggerEvent("pNotify:SendNotification",{
		text = "<b style='color:#1E90FF'>Køreskole instruktør:</b> <br /><br /> Vi er igang med at klargøre dit køretøj.<br /><br /><b style='color:#87CEFA'>Farthastigheden:</b><br />- Hold øje med <b style='color:#A52A2A'>fartgrænserne</b><br /><br />- Allerede nu, burde du kende de basale ting, dog vil Vi minde dig om når du <b style='color:#DAA520'>kører ind/ud</b> i/af områder med angivne fartgrænser",
		type = "alert",
		timeout = (15000),
		layout = "center",
		queue = "global"
	})
	Citizen.Wait(16500)
	SpawnTestCar()
	DTutOpen = false
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)


				if DTutOpen then
					local ply = GetPlayerPed(-1)
					local active = true
					SetEntityVisible(ply, false)
					FreezeEntityPosition(ply, true)
					DisableControlAction(0, 1, active) -- LookLeftRight
					DisableControlAction(0, 2, active) -- LookUpDown
					DisablePlayerFiring(ply, true) -- Disable weapon firing
					DisableControlAction(0, 142, active) -- MeleeAttackAlternate
					DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
				end
				Citizen.Wait(0)


		if onTtest then
			local ply = GetPlayerPed(-1)
			local active = true
			DisableControlAction(0, 1, active) -- LookLeftRight
			DisableControlAction(0, 2, active) -- LookUpDown
			DisablePlayerFiring(ply, true) -- Disable weapon firing
			DisableControlAction(0, 142, active) -- MeleeAttackAlternate
			DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
			if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
				SendNUIMessage({type = "click"})
			end
		end


		local veh = GetVehiclePedIsUsing(GetPlayerPed(-1))
		local ped = GetPlayerPed(-1)
		if HasEntityCollidedWithAnything(veh) and DamageControl == 1 then

			--Notification
			TriggerEvent("pNotify:SendNotification",{text = "Bilen fik en <b style='color:#B22222'>skade!</b><br /><br />Pas på!", type = "alert",timeout = (4000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
			Citizen.Wait(1000)
			Error = Error + 1
		elseif(IsControlJustReleased(1, 23)) and DamageControl == 1 then
			--Notification
			TriggerEvent("pNotify:SendNotification",{text = "Du kan <b style='color:#B22222'>ikke</b> forlade køretøjet under køreprøven",type = "alert",timeout = (4000), layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
		end

		if onTestEvent == 1 then
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 255.13990783691,-1400.7319335938,29.5374584198, true) > 4.0001 then
				DrawMarker(1,255.13990783691,-1400.7319335938,29.5374584198,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
			else
				if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
					Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
				end
				onTestBlipp = AddBlipForCoord(271.8747253418,-1370.5744628906,31.932783126831)
				N_0x80ead8e2e1d5d52e(onTestBlipp)

				--Notification
				TriggerEvent("pNotify:SendNotification",{text = "Kør til <b style='color:#ddf904'>næste</b> punkt.",type = "alert",timeout = (4000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})

				onTestEvent = 2
			end
		end

		if onTestEvent == 2 then
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),271.8747253418,-1370.5744628906,30.932783126831, true) > 4.0001 then
				DrawMarker(1,271.8747253418,-1370.5744628906,30.932783126831,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
			else
				if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
					Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
				end
				onTestBlipp = AddBlipForCoord(234.90780639648,-1345.3854980469, 30.542045593262)
				N_0x80ead8e2e1d5d52e(onTestBlipp)
				SetBlipRoute(onTestBlipp, 1)

				--Notification
				TriggerEvent("pNotify:SendNotification",{text = "Kør til <b style='color:#ddf904'>næste</b> punkt.",type = "alert",timeout = (4000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})

				onTestEvent = 3
			end
		end

		if onTestEvent == 3 then
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),234.90780639648,-1345.3854980469, 29.542045593262, true) > 4.0001 then
				DrawMarker(1,234.90780639648,-1345.3854980469, 29.542045593262,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
			else
				if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
					Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
				end
				onTestBlipp = AddBlipForCoord(217.82102966309,-1410.5201416016,29.292112350464)
				N_0x80ead8e2e1d5d52e(onTestBlipp)
				SetBlipRoute(onTestBlipp, 1)
				-- DrawMissionText2("Så laver vi et fint ~r~stop~s~ for fodgængere", 5000)

				--Notification
				TriggerEvent("pNotify:SendNotification",{text = "Vi holder lige et <b style='color:#ddf904'>stop</b> for fodgængerne.", type = "info", timeout = (3000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})

				PlaySound(-1, "RACE_PLACED", "HUD_AWARDS", 0, 0, 1)
				FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)), true) -- Freeze Entity
				Citizen.Wait(4000)
				FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)), false) -- Freeze Entity

				--Notification
				TriggerEvent("pNotify:SendNotification",{text = "Lad os <b style='color:#ddf904'>rulle!</b>",type = "info",timeout = (3000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
				onTestEvent = 4
			end
		end

		if onTestEvent == 4 then
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),217.82102966309,-1410.5201416016,28.292112350464, true) > 4.0001 then
				DrawMarker(1,217.82102966309,-1410.5201416016,28.292112350464,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
			else
				if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
					Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
				end
				onTestBlipp = AddBlipForCoord(178.55052185059,-1401.7551269531,28.725154876709)
				N_0x80ead8e2e1d5d52e(onTestBlipp)
				SetBlipRoute(onTestBlipp, 1)

				--Notification
				TriggerEvent("pNotify:SendNotification",{text = "<b style='color:#ddf904'>Stop</b> og kig til siderne før du kører videre",type = "info",timeout = (5000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})

				PlaySound(-1, "RACE_PLACED", "HUD_AWARDS", 0, 0, 1)
				FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)), true) -- Freeze Entity
				Citizen.Wait(6000)
				FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)), false) -- Freeze Entity

				--Notifications
				TriggerEvent("pNotify:SendNotification",{text = "Kør til <b style='color:#ddf904'>højre</b> og vælg din bane.",type = "info",timeout = (3000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
				TriggerEvent("pNotify:SendNotification",{text = "Område: <font style='color:#ddf904'>Byzone</font> |<font style='color:#ddf904'>Færtgrænse</font> 50 KM/T | <font style='color:#222222'>Fejl</font> ".. Error.."/"..maxErrors,type = "info",timeout = (4000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})

				SpeedControl = 2
				onTestEvent = 5
				Citizen.Wait(4000)
			end
		end

		if onTestEvent == 5 then
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),178.55052185059,-1401.7551269531,27.725154876709, true) > 4.0001 then
				DrawMarker(1,178.55052185059,-1401.7551269531,27.725154876709,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
			else
				if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
					Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
				end
				onTestBlipp = AddBlipForCoord(113.16044616699,-1365.2762451172,28.725179672241)
				N_0x80ead8e2e1d5d52e(onTestBlipp)
				SetBlipRoute(onTestBlipp, 1)
				-- DrawMissionText2("Hold øje med ~y~lyskrydset~s~ !", 5000)
				TriggerEvent("pNotify:SendNotification",{text = "Hold øje med lyskrydset",type = "info",timeout = (3000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
				onTestEvent = 6
			end
		end

		if onTestEvent == 6 then
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),113.16044616699,-1365.2762451172,27.725179672241, true) > 4.0001 then
				DrawMarker(1,113.16044616699,-1365.2762451172,27.725179672241,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
			else
				if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
					Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
				end
				onTestBlipp = AddBlipForCoord(-73.542953491211,-1364.3355712891,27.789325714111)
				N_0x80ead8e2e1d5d52e(onTestBlipp)
				SetBlipRoute(onTestBlipp, 1)
				onTestEvent = 7
			end
		end


		if onTestEvent == 7 then
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-73.542953491211,-1364.3355712891,27.789325714111, true) > 4.0001 then
				DrawMarker(1,-73.542953491211,-1364.3355712891,27.789325714111,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
			else
				if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
					Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
				end
				onTestBlipp = AddBlipForCoord(-355.14373779297,-1420.2822265625,27.868143081665)
				N_0x80ead8e2e1d5d52e(onTestBlipp)
				SetBlipRoute(onTestBlipp, 1)
				--Notifications
				TriggerEvent("pNotify:SendNotification",{text = "Husk at holde tilbage for <b style='color:#ddf904'>krydsende</b> trafik.",type = "info",timeout = (3000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
				onTestEvent = 8
			end
		end

		if onTestEvent == 8 then
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-355.14373779297,-1420.2822265625,27.868143081665, true) > 4.0001 then
				DrawMarker(1,-355.14373779297,-1420.2822265625,27.868143081665,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
			else
				if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
					Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
				end
				onTestBlipp = AddBlipForCoord(-439.14846801758,-1417.1004638672,27.704095840454)
				N_0x80ead8e2e1d5d52e(onTestBlipp)
				SetBlipRoute(onTestBlipp, 1)
				onTestEvent = 9
			end
		end

		if onTestEvent == 9 then
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-439.14846801758,-1417.1004638672,27.704095840454, true) > 4.0001 then
				DrawMarker(1,-439.14846801758,-1417.1004638672,27.704095840454,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
			else
				if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
					Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
				end
				onTestBlipp = AddBlipForCoord(-453.79092407227,-1444.7265625,27.665870666504)
				N_0x80ead8e2e1d5d52e(onTestBlipp)
				SetBlipRoute(onTestBlipp, 1)
				onTestEvent = 10
			end
		end

		if onTestEvent == 10 then
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-453.79092407227,-1444.7265625,27.665870666504, true) > 4.0001 then
				DrawMarker(1,-453.79092407227,-1444.7265625,27.665870666504,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
			else
				if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
					Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
				end
				onTestBlipp = AddBlipForCoord(-463.23712158203,-1592.1785888672,37.519771575928)
				N_0x80ead8e2e1d5d52e(onTestBlipp)
				SetBlipRoute(onTestBlipp, 1)
				--Notifications
				TriggerEvent("pNotify:SendNotification",{text = "Tid til at ramme <b style='color:#ddf904'>motorvejen. <br>Husk</b> at øge din hastighed for ikke at skabe uheld.",type = "info",timeout = (4000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})

				PlaySound(-1, "RACE_PLACED", "HUD_AWARDS", 0, 0, 1)
				--Notifications

				TriggerEvent("pNotify:SendNotification",{text = "Område: <font style='color:#ddf904'>Motorvej</font> |<font style='color:#ddf904'>Færtgrænse</font> 130 KM/T | <font style='color:#222222'>Fejl</font> ".. Error.."/"..maxErrors,type = "info",timeout = (4000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
				onTestEvent = 11
				SpeedControl = 3
				Citizen.Wait(4000)
			end
		end

		if onTestEvent == 11 then
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-463.23712158203,-1592.1785888672,37.519771575928, true) > 4.0001 then
				DrawMarker(1,-463.23712158203,-1592.1785888672,37.519771575928,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
			else
				if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
					Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
				end
				onTestBlipp = AddBlipForCoord(-900.64721679688,-1986.2814941406,26.109502792358)
				N_0x80ead8e2e1d5d52e(onTestBlipp)
				SetBlipRoute(onTestBlipp, 1)
				onTestEvent = 12
			end
		end

		if onTestEvent == 12 then
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-900.64721679688,-1986.2814941406,26.109502792358, true) > 4.0001 then
				DrawMarker(1,-900.64721679688,-1986.2814941406,26.109502792358,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
			else
				if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
					Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
				end
				onTestBlipp = AddBlipForCoord(1225.7598876953,-1948.7922363281,38.718940734863)
				N_0x80ead8e2e1d5d52e(onTestBlipp)
				SetBlipRoute(onTestBlipp, 1)
				onTestEvent = 13
			end
		end

		if onTestEvent == 13 then
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),1225.7598876953,-1948.7922363281,38.718940734863, true) > 4.0001 then
				DrawMarker(1,1225.7598876953,-1948.7922363281,38.718940734863,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
			else
				if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
					Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
				end
				onTestBlipp = AddBlipForCoord(209.54621887207,-1412.8677978516,29.652387619019)
				N_0x80ead8e2e1d5d52e(onTestBlipp)
				SetBlipRoute(onTestBlipp, 1)
				onTestEvent = 14
			end
		end

		if onTestEvent == 14 then
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),1225.7598876953,-1948.7922363281,38.718940734863, true) > 4.0001 then
				DrawMarker(1,1225.7598876953,-1948.7922363281,38.718940734863,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
			else
				if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
					Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
				end
				onTestBlipp = AddBlipForCoord(1163.6030273438,-1841.7713623047,35.679168701172)
				N_0x80ead8e2e1d5d52e(onTestBlipp)
				SetBlipRoute(onTestBlipp, 1)
				--Notifications
				TriggerEvent("pNotify:SendNotification",{text = "Du kører ind i <b style='color:#ddf904'>byzonen.</b><br>Pas på din hastighed.",type = "info",timeout = (5000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
				TriggerEvent("pNotify:SendNotification",{text = "Område: <font style='color:#ddf904'>Byzone</font> |<font style='color:#ddf904'>Færtgrænse</font> 50 KM/T | <font style='color:#222222'>Fejl</font> ".. Error.."/"..maxErrors,type = "info",timeout = (4000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
				onTestEvent = 15
			end
		end

		if onTestEvent == 15 then
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),1163.6030273438,-1841.7713623047,35.679168701172, true) > 4.0001 then
				DrawMarker(1,1163.6030273438,-1841.7713623047,35.679168701172,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
			else
				if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
					Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
				end
				onTestBlipp = AddBlipForCoord(235.28327941895,-1398.3292236328,28.921098709106)
				N_0x80ead8e2e1d5d52e(onTestBlipp)
				SetBlipRoute(onTestBlipp, 1)
				PlaySound(-1, "RACE_PLACED", "HUD_AWARDS", 0, 0, 1)
				--Notifications
				TriggerEvent("pNotify:SendNotification",{text = "Fedt! Lad os køre tilbage til <b style='color:#ddf904'>køreskolen.</b>",type = "info",timeout = (5000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
				TriggerEvent("pNotify:SendNotification",{text = "Område: <font style='color:#ddf904'>Byzone</font> |<font style='color:#ddf904'>Færtgrænse</font> 50 KM/T | <font style='color:#222222'>Fejl</font> ".. Error.."/"..maxErrors,type = "info",timeout = (4000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
				SpeedControl = 2
				onTestEvent = 16
			end
		end

		if onTestEvent == 16 then
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),235.28327941895,-1398.3292236328,28.921098709106, true) > 4.0001 then
				DrawMarker(1,235.28327941895,-1398.3292236328,28.921098709106,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
			else
				if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
					Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
				end
				EndDTest()
			end
		end

		CarSpeed = GetEntitySpeed(GetCar()) * speed
		if(IsPedInAnyVehicle(GetPlayerPed(-1), false)) and SpeedControl == 1 and CarSpeed >= speed_limit_resi then
			TriggerEvent("pNotify:SendNotification",{
				text = "Du kører for hurtigt! <b style='color:#B22222'>Sænk farten, </b><br /><br />du kører i et <b style='color:#DAA520'>boligområde!</b>",
				type = "alert",
				timeout = (2000),
				layout = "bottomCenter",
				queue = "global"
			})
			Error = Error + 1
			Citizen.Wait(10000)
		elseif(IsPedInAnyVehicle(GetPlayerPed(-1), false)) and SpeedControl == 2 and CarSpeed >= speed_limit_town then
			TriggerEvent("pNotify:SendNotification",{
				text = "Du kører for hurtigt! <b style='color:#B22222'>Sænk farten,</b><br /><br />du kører i en <b style='color:#DAA520'>byzone!</b>",
				type = "alert",
				timeout = (2000),
				layout = "bottomCenter",
				queue = "global"
			})
			Error = Error + 1
			Citizen.Wait(10000)
		elseif(IsPedInAnyVehicle(GetPlayerPed(-1), false)) and SpeedControl == 3 and CarSpeed >= speed_limit_freeway then
			TriggerEvent("pNotify:SendNotification",{
				text = "Du kører for hurtigt! <b style='color:#B22222'>Sæt farten ned!</b><br /><br />Du kører på <b style='color:#DAA520'>motorvejen!</b>",
				type = "alert",
				timeout = (2000),
				layout = "bottomCenter",
				queue = "global"
			})
			Error = Error + 1
			Citizen.Wait(10000)
		end
	end
end)

----Theory Test NUI Operator

-- ***************** Open Gui and Focus NUI
function openGui()
	onTtest = true
	SetNuiFocus(true)
	SendNUIMessage({openQuestion = true})
end

-- ***************** Close Gui and disable NUI
function closeGui()
	SetNuiFocus(false)
	SendNUIMessage({openQuestion = false})
end


-- ***************** NUI Callback Methods
-- Callbacks pages opening
RegisterNUICallback('question', function(data, cb)
	SendNUIMessage({openSection = "question"})
	cb('ok')
end)

-- Callback actions triggering server events
RegisterNUICallback('close', function(data, cb)
	-- if question success
	closeGui()
	cb('ok')
	--Notifications
	TriggerEvent("pNotify:SendNotification",{text = "Tillykke! Du bestod teoriprøven<br>Held og lykke med køreprøven!",type = "success",timeout = (5000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
	theorylock = true
	testlock = false
	onTtest = false
end)

RegisterNUICallback('kick', function(data, cb)
	closeGui()
	cb('ok')
	--Notifications
	TriggerEvent("pNotify:SendNotification",{text = "Desværre, du dumpede teoriprøven<br><br>Kom igen i morgen",type = "error",timeout = (5000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
	onTtest = false
end)



----Theory Test NUI Operator

-- ***************** Open Gui and Focus NUI
function openGui()
	onTtest = true
	SetNuiFocus(true)
	SendNUIMessage({openQuestion = true})
end

-- ***************** Close Gui and disable NUI
function closeGui()
	SetNuiFocus(false)
	SendNUIMessage({openQuestion = false})
end

-- ***************** Disable controls while GUI open


-- ***************** NUI Callback Methods
-- Callbacks pages opening
RegisterNUICallback('question', function(data, cb)
	SendNUIMessage({openSection = "question"})
	cb('ok')
end)

-- Callback actions triggering server events
RegisterNUICallback('close', function(data, cb)
	-- if question success
	closeGui()
	cb('ok')
	--Notifications
	TriggerEvent("pNotify:SendNotification",{text = "Tillykke! Du bestod teoriprøven<br>Held og lykke med køreprøven!",type = "success",timeout = (5000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
	theorylock = true
	testlock = false
	onTtest = false
end)

RegisterNUICallback('close', function(data, cb)
	closeGui()
	cb('ok')
	--Notifications
	TriggerEvent("pNotify:SendNotification",{text = "Desværre, du dumpede teoriprøven<br>Kom igen i morgen",type = "error",timeout = (5000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
	onTtest = false
end)

---------------------------------- DMV PED ----------------------------------

Citizen.CreateThread(function()

	RequestModel(GetHashKey("a_m_y_business_01"))
	while not HasModelLoaded(GetHashKey("a_m_y_business_01")) do
		Wait(1)
	end

	RequestAnimDict("mini@strip_club@idles@bouncer@base")
	while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
		Wait(1)
	end

	-- Spawn the DMV Ped
	for _, item in pairs(dmvped) do
		dmvmainped =  CreatePed(item.type, item.hash, item.x, item.y, item.z, item.a, false, true)
		SetEntityHeading(dmvmainped, 137.71)
		FreezeEntityPosition(dmvmainped, true)
		SetEntityInvincible(dmvmainped, true)
		SetBlockingOfNonTemporaryEvents(dmvmainped, true)
		TaskPlayAnim(dmvmainped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
	end
end)

local talktodmvped = true
--DMV Ped interaction
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local pos = GetEntityCoords(GetPlayerPed(-1), false)
		for k,v in ipairs(dmvpedpos) do
			if(Vdist(v.x, v.y, v.z, pos.x, pos.y, pos.z) < 1.0)then
				DisplayHelpText("Tryk ~INPUT_CONTEXT~ for at snakke med ~y~kørelæren")
				if(IsControlJustReleased(1, 38))then
					if talktodmvped then
						Notify("Velkommen til køreskolen!")
						Citizen.Wait(500)
						DMVMenu()
						Menu.hidden = false
						talktodmvped = false
					else
						talktodmvped = true
					end
				end
				Menu.renderGUI(options)
			end
		end
	end
end)

------------
------------ DRAW MENUS
------------
function DMVMenu()
	ClearMenu()
	options.menu_title = "Køreskole"
	Menu.addButton("Tag kørekort","VehLicenseMenu",nil)
	Menu.addButton("Luk","CloseMenu",nil)
end

function VehLicenseMenu()
	ClearMenu()
	options.menu_title = "Køreskole"
	Menu.addButton("Introduktion    Gratis","startintro",nil)
	Menu.addButton("Teori    5000 DKK","startttest",nil)
	Menu.addButton("Praksis    5000 DKK","startptest",nil)
	Menu.addButton("Tilbage","DMVMenu",nil)
end

function CloseMenu()
	Menu.hidden = true
end

function Notify(text)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(true, true)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

----------------
----------------blip
----------------



Citizen.CreateThread(function()
	pos = dmvschool_location
	local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
	SetBlipSprite(blip,198)
	SetBlipColour(blip,35)
	SetBlipScale(blip,0.8)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Køreskole')
	EndTextCommandSetBlipName(blip)
	SetBlipAsShortRange(blip,true)
	SetBlipAsMissionCreatorBlip(blip,true)
end)
