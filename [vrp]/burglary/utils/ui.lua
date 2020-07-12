-- Thanks to
-- https://github.com/shayandoust/Nexus-Events/blob/a630df758f8bfbcb323cf3b1e3cc03ee7151d5c8/functions/gui.lua

UI = {}

function UI.DrawTimerBar(title, text, barIndex)
	local width = 0.13
	local hTextMargin = 0.003
	local rectHeight = 0.038
	local textMargin = 0.008
	
	local rectX = GetSafeZoneSize() - width + width / 2
	local rectY = GetSafeZoneSize() - rectHeight + rectHeight / 2 - (barIndex - 1) * (rectHeight + 0.005)
	
	DrawSprite("timerbars", "all_black_bg", rectX, rectY, width, 0.038, 0, 0, 0, 0, 128)
	
	UI.DrawText(title, GetSafeZoneSize() - width + hTextMargin, rectY - textMargin, 0.32)
	UI.DrawText(string.upper(text), GetSafeZoneSize() - hTextMargin, rectY - 0.0175, 0.5, true, width / 2)
end

function UI.DrawNoiseBar(noise, barIndex)
	UI.DrawTimerBar("NOISE", math.floor(noise), barIndex)
end

function UI.DrawText(text, x, y, scale, right, width)
	SetTextFont(0)
	SetTextScale(scale, scale)
	SetTextColour(254, 254, 254, 255)

	if right then
		SetTextWrap(x - width, x)
		SetTextRightJustify(true)
	end
	
	BeginTextCommandDisplayText("STRING")	
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x, y)
end

function UI.DisplayHelpText(text)
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentSubstringPlayerName(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function UI.ShowSubtitle(text)
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandPrint(3500, 1)
end

function UI.ShowMPMessage(message, subtitle, ms)
	-- do this in another thread
	Citizen.CreateThread(function()
		local scaleform = RequestScaleformMovie("mp_big_message_freemode")
		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(0)
		end
		
		BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
		PushScaleformMovieMethodParameterString(message)
		PushScaleformMovieMethodParameterString(subtitle)
		PushScaleformMovieMethodParameterInt(0)
		EndScaleformMovieMethod()

		local time = GetGameTimer() + ms
        
        while(GetGameTimer() < time) do
			Citizen.Wait(0)
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
		end
	end)
end

function UI.DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
	DrawText(_x,_y)
	
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end