-- Script made by TakenDK --
-- Made for Civilians Network --
-- Date and time 11/9/2019 --
-- This script shall not be shared with out my permission --

coords1 = {
  { custom1 = {['x']=1601.3715820313, ['y']=2553.7255859375, ['z']=44.864853668213}}
}

coords2 = {
  { custom2 = {['x']=1752.5910644531, ['y']=2503.9487304688, ['z']=44.864979553223}}
}

rgb = {r = 202, g = 237, b = 150}
alpha = 255

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
        for k,v in pairs (coords1) do
          local pos = v.custom1
          local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
          local ped = GetPlayerPed(-1)
        DrawMarker(1, pos.x, pos.y, pos.z, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 0.6, rgb.r, rgb.g, rgb.b, alpha, 1, 1, 0, 1, 0, 0, 0) -- WILL DRAW MARKERS IN THE COORDS YOU SET IN "coords1" lane 1

        RequestModel("prop_boxpile_06a")
        while not HasModelLoaded("prop_boxpile_06a") do
           Wait(1)
        end

        if (Vdist(pos.x, pos.y, pos.z, x, y, z, true) < 3) then
            helptext("Tryk ~INPUT_CONTEXT~ for at arbejde.")
            if IsControlJustPressed(0, 86) then -- E
                Wait(1000)
              local objectS = CreateObject(GetHashKey("prop_boxpile_06a"), x, y, z, true, true, true)
              PlaceObjectOnGroundProperly(objectS)
			  Wait(3*60000)
            end
        end
      end
      for k,v in pairs (coords2) do
        local pos = v.custom2
        local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
        local ped = PlayerPedId()
      DrawMarker(1, pos.x, pos.y, pos.z, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 0.6, rgb.r, rgb.g, rgb.b, alpha, 1, 1, 0, 1, 0, 0, 0) -- WILL DRAW MARKERS IN THE COORDS YOU SET IN "coords2" lane 1
      if (Vdist(pos.x, pos.y, pos.z, x, y, z, true) < 3)  then
          helptext("Tryk ~INPUT_CONTEXT~ for at aflevere pakken.")
          if IsControlJustPressed(0, 86) then -- E
            local objectId = GetClosestObjectOfType(x, y, z, 2.0, GetHashKey("prop_boxpile_06a"), true)
              if objectId ~= 0 then
                  DeleteObject(objectId)
                  TriggerServerEvent("indsat",ped)
                  Wait(3*60000)
              else
                  helptext("Kassen skal være i cirklen")
              end
          end
      end
    end
  end
end)


function helptext(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
