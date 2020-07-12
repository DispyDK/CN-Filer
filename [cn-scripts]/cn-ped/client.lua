--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 10-03-2019
-- Time: 17:00
-- Made for CiviliansNetwork
--

local peds = {
    -- CLOTHING
    {model="s_f_y_shop_mid", voice="SHOPASSISTANT", coords={73.883,-1392.551,28.376,258.693}},
    {model="s_f_y_shop_mid", voice="SHOPASSISTANT", coords={-708.705,-152.150,36.415,118.490}},
    {model="s_f_y_shop_low", voice="SHOPASSISTANT", coords={126.824,-224.512,53.558,71.926}},
    {model="s_f_y_shop_low", voice="SHOPASSISTANT", coords={427.069,-806.280,28.491,84.203}},
    {model="s_f_y_shop_low", voice="SHOPASSISTANT", coords={-822.872 ,-1072.162,10.328,203.007}},
    {model="s_f_y_shop_low", voice="SHOPASSISTANT", coords={-1193.691,-766.863,16.316,216.273}}, --
    {model="s_f_y_shop_mid", voice="SHOPASSISTANT", coords={-1448.901,-238.138,48.814,48.307}},
    {model="s_f_y_shop_mid", voice="SHOPASSISTANT", coords={5.809,6511.428,30.878,40.329}},
    {model="s_f_y_shop_low", voice="SHOPASSISTANT", coords={1695.387,4823.019,41.063,96.539}},
    {model="s_f_y_shop_low", voice="SHOPASSISTANT", coords={613.015,2762.577,41.088,277.766}},
    {model="s_f_y_shop_low", voice="SHOPASSISTANT", coords={1196.435,2711.634,37.223,179.040}},
    {model="s_f_y_shop_low", voice="SHOPASSISTANT", coords={-3169.260,1043.606,19.863,57.917}},
    {model="s_f_y_shop_low", voice="SHOPASSISTANT", coords={-1102.184,2711.799,18.108,223.387}},
    -- FOOD
    { model="mp_m_shopkeep_01", voice="SHOPASSISTANT", coords={-46.313,-1757.504,28.421,46.395}},
  --  { model="mp_m_shopkeep_01", voice="SHOPASSISTANT", coords={24.376,-1345.558,28.421,267.940}},
    { model="mp_m_shopkeep_01", voice="SHOPASSISTANT", coords={1134.182,-982.477,45.416,275.432}},
    { model="mp_m_shopkeep_01", voice="SHOPASSISTANT", coords={373.015,328.332,102.566,257.309}},
    { model="mp_m_shopkeep_01", voice="SHOPASSISTANT", coords={2676.389,3280.362,54.241,332.305}},
    { model="mp_m_shopkeep_01", voice="SHOPASSISTANT", coords={1958.960,3741.979,31.344,303.196}},
    { model="mp_m_shopkeep_01", voice="SHOPASSISTANT", coords={-2966.391,391.324,14.043,88.867}},
    { model="mp_m_shopkeep_01", voice="SHOPASSISTANT", coords={1164.565,-322.121,68.205,100.492}},
    { model="mp_m_shopkeep_01", voice="SHOPASSISTANT", coords={-1486.530,-377.768,39.163,147.669}},
    { model="mp_m_shopkeep_01", voice="SHOPASSISTANT", coords={-1221.568,-908.121,11.326,31.739}},
    { model="mp_m_shopkeep_01", voice="SHOPASSISTANT", coords={-706.153,-913.464,18.216,82.056}},
    { model="mp_m_shopkeep_01", voice="SHOPASSISTANT", coords={-1820.230,794.369,137.089,130.327}},
    { model="mp_m_shopkeep_01", voice="SHOPASSISTANT", coords={2555.474,380.909,107.623,355.737}},
    { model="mp_m_shopkeep_01", voice="SHOPASSISTANT", coords={1728.614,6416.729,34.037,247.369}},
    { ishash=true, model=-1954728090, voice="SHOPASSISTANT", coords={-1195.36328125,-893.74407958984,12.995155334473,300.0}},
    -- BARBERS
    {model= "s_f_m_fembarber", voice="S_F_M_FEMBARBER_BLACK_MINI_01", coords={-817.349,-184.541,36.569,134.069}},
    {model= "s_f_m_fembarber", voice="S_F_M_FEMBARBER_BLACK_MINI_01", coords={134.749,-1708.106,28.292,146.281}},
    {model= "s_f_m_fembarber", voice="S_F_M_FEMBARBER_BLACK_MINI_01", coords={-1284.038,-1115.635,5.990,85.177}},
    {model= "s_f_m_fembarber", voice="S_F_M_FEMBARBER_BLACK_MINI_01", coords={1930.855,3728.141,31.844,220.243}},
    {model= "a_m_y_stbla_02", voice="S_M_M_HAIRDRESSER_01_BLACK_MINI_01", coords={1211.521,-470.704,65.208,79.543}},
    {model= "a_m_y_stbla_02", voice="S_M_M_HAIRDRESSER_01_BLACK_MINI_01", coords={-30.804,-151.648,56.077,349.238}},
    {model= "a_m_y_stbla_02", voice="S_M_M_HAIRDRESSER_01_BLACK_MINI_01", coords={-278.205,6230.279,30.696,49.216}},
    -- ULOVLIG JOB
    {ishash=true, model= 1581098148, dict="mini@strip_club@idles@bouncer@base", anim="base", voice="S_M_M_HAIRDRESSER_01_BLACK_MINI_01", coords={441.07043457031,-978.88665771484,29.689680099487,180.0}},
    {ishash=true, model= 0xe497bbef, dict="mini@strip_club@idles@bouncer@base", anim="base", voice="S_M_M_HAIRDRESSER_01_BLACK_MINI_01", coords={374.52453613281,798.8779296875,186.36087036133,180.0}},
    {ishash=true, model= 0xe497bbef, dict="mini@strip_club@idles@bouncer@base", anim="base", voice="S_M_M_HAIRDRESSER_01_BLACK_MINI_01", coords={1209.0776367188,-3120.9013671875,4.5403246879578,355.50384521484}},
    {ishash=true, model= 0xe497bbef, dict="mini@strip_club@idles@bouncer@base", anim="base", voice="S_M_M_HAIRDRESSER_01_BLACK_MINI_01", coords={2328.2131347656,2570.0119628906,45.676868438721,322.99401855469,90.0}},
    {ishash=true, model= 0xe497bbef, dict="mini@strip_club@idles@bouncer@base", anim="base", voice="S_M_M_HAIRDRESSER_01_BLACK_MINI_01", coords={752.75866699219,-3195.2644042969,5.0731477737427,263.27444458008}},
    {ishash=true, model= 0xe497bbef, dict="mini@strip_club@idles@bouncer@base", anim="base", voice="S_M_M_HAIRDRESSER_01_BLACK_MINI_01", coords={1444.3853759766,6333.2651367188,22.882966995239,87.295082092285}},
    {ishash=true, model= 0xe497bbef, dict="mini@strip_club@idles@bouncer@base", anim="base", voice="S_M_M_HAIRDRESSER_01_BLACK_MINI_01", coords={1669.4599609375,4972.16796875,41.282688140869,131.94779968262}},
    {ishash=true, model= 0xe497bbef, dict="mini@strip_club@idles@bouncer@base", anim="base", voice="S_M_M_HAIRDRESSER_01_BLACK_MINI_01", coords={-32.985454559326,1943.8756103516,189.18621826172,118.28873443604}},

    --Casino Cashier
    {ishash=true, model= 0xE7565327, dict="mini@strip_club@idles@bouncer@base", anim="base", voice="S_M_M_HAIRDRESSER_01_BLACK_MINI_01", coords={1117.3189697266,220.49467468262,-50.435123443604, 105.032322}},


    {ishash=true, model= 1832265812, voice="", coords={-444.65029907227,-2183.3427734375,9.590781211853,-56.5010032653809}},
    {ishash=true, model= -654717625, voice="", coords={-1866.6809082031,2063.2727050781,139.97654724121}},

    --Louises hus
    {ishash=true, model= 351016938, voice="", coords={-1094.2746582031,354.50039672852,67.509147644043}},
    --{ishash=true, model= 1193010354, voice="", coords={-1158.0103759766,369.32446289063,68.453422546387}},

}

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

Citizen.CreateThread(function()

    for k,v in ipairs(peds) do
        local lmodel = (v.ishash) and v.model or GetHashKey(v.model)
        RequestModel(lmodel)
        while not HasModelLoaded(lmodel) do
            Wait(10)
        end
        local lPed = CreatePed(4, lmodel, v.coords[1], v.coords[2], v.coords[3], v.coords[4], false, false)

          SetEntityInvincible(lPed, true)
          FreezeEntityPosition(lPed, true)
          SetBlockingOfNonTemporaryEvents(lPed, true)

        SetAmbientVoiceName(lPed, v.voice)
        if v.dict ~= nil then
            loadAnimDict(v.dict)
            TaskPlayAnim(lPed,v.dict,v.anim, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
        else
            -- TaskStartScenarioInPlace(lPed, "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", 0, 0)
        end
        SetModelAsNoLongerNeeded(lmodel)
    end
end)

Citizen.CreateThread(function()


        local lmodel = 307287994
        RequestModel(lmodel)
        while not HasModelLoaded(lmodel) do
            Wait(10)
        end
        local lPed = CreatePed(4, 307287994, -1877.1163330078,2080.0205078125,140.24682617188, false, false)
        while true do
          TaskGoToCoordAnyMeans(lPed,-1876.3210449219,2085.8820800781,141.22752380371, 1.0, 0, 0, 786603, 1.0)
          Wait(6000)
          TaskGoToCoordAnyMeans(lPed,-1877.4564208984,2077.1791992188,141.25692749023, 1.0, 0, 0, 786603, 1.0)
          Wait(4000)
        end

        SetModelAsNoLongerNeeded(lmodel)

end)


Citizen.CreateThread(function()


        local lmodel = 1318032802
        RequestModel(lmodel)
        while not HasModelLoaded(lmodel) do
            Wait(10)
        end
        local lPed = CreatePed(4, 1318032802, -1114.8598632813,386.60397338867,71.082939147949, false, false)
        while true do
          TaskGoToCoordAnyMeans(lPed,-1114.8598632813,386.60397338867,71.082939147949, 1.0, 0, 0, 786603, 1.0)
          Wait(8000)
          TaskGoToCoordAnyMeans(lPed,-1102.9946289063,376.69030761719,69.769241333008, 1.0, 0, 0, 786603, 1.0)
          Wait(6000)
        end

        SetModelAsNoLongerNeeded(lmodel)

end)

Citizen.CreateThread(function()
  local dmodel = -1950698411
  RequestModel(dmodel)
  while not HasModelLoaded(dmodel) do
      Wait(10)
  end
  local delfin = CreatePed(4, -1950698411, -1158.0103759766,369.32446289063,67.453422546387, false, false)

  SetModelAsNoLongerNeeded(dmodel)
end)
