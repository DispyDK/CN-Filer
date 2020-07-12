--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 02-02-2019
-- Time: 18:08
-- Made for CiviliansNetwork


 Citizen.CreateThread(function()
     while true do
         Citizen.Wait(5)
         local myCoords = GetEntityCoords(GetPlayerPed(-1))
         ClearAreaOfCops(myCoords.x, myCoords.y, myCoords.z, 100.0, 0)
         if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 471.38800048828,-989.81939697266,24.914737701416, true ) < 20 then
             ClearAreaOfPeds(471.38800048828,-989.81939697266,24.914737701416, 20.0, 0)
         end
     end
end)