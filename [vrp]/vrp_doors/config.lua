--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 02-02-2019
-- Time: 19:14
-- Made for CiviliansNetwork
--

local cfg = {}

cfg.doors = {
    -- Centrum PD stue
    [1] = {locked = false, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -1215222675, coords={434.74145507813,-981.09252929688,30.712087631226}, pairs = 2}, -- fordør cords
    [2] = {locked = false, key = "key_lspd", permission="police.pc", name = "Politistation", hash = 320433149, coords={434.78842163086,-982.70825195313,30.689336776733}, pairs = 1}, -- fordør cords
    [3] = {locked = true, key = "key_lspd", permission="politi.ledelse.doors", name = "Ledelses Kontor", hash=-1320876379, coords={447.09362792969,-980.115234375,30.689315795898 }}, --Captain
    [4] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -1033001619, coords={453.13778686523,-982.68402099609,30.689304351807}}, -- våbenkammer
    [5] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -1033001619, coords={445.21319580078,-998.99169921875,30.724500656128}, pairs = 6}, -- Til garage fra PD
    [6] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -1033001619, coords={445.97244262695,-999.00250244141,30.724214553833}, pairs = 5}, -- Til garage fra PD
    [7] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = 1557126584, coords={449.88836669922,-986.57958984375,30.689334869385}}, -- Til omklædning
    [8] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = 185711165, coords={445.25473022461,-989.41534423828,30.68932342529}, pairs = 9}, -- Til Kælder og garage indenfor
    [9] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = 185711165, coords={443.95629882813,-989.46459960938,30.689332962036}, pairs = 8}, -- Til Kælder og garage indenfor
    --Centrum PD Kælder
    [10] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -543497392, coords={446.10592651367,-987.17254638672,26.674179077148}, pairs = 11}, -- Mugshot rum
    [11] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -543497392, coords={445.81097412109,-985.62121582031,26.674167633057}, pairs = 10}, -- Mugshot rum
    [12] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -131296141, coords={443.48999023438,-988.24291992188,26.67414855957}}, -- Mugshot rum kriminel
    [13] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -131296141, coords={442.04235839844,-985.70086669922,26.67414855957}}, -- Mugshot rum politi
    [14] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -543497392, coords={451.32507324219,-983.90393066406,26.67414093017}, pairs = 15}, -- dør ind til medical peters kontor og kontoer
    [15] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -543497392, coords={452.88571166992,-983.87670898438,26.674167633057}, pairs = 14}, -- dør ind til medical peters kontor og kontoer
    [16] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -543497392, coords={451.8215637207,-979.56518554688,26.668563842773}}, -- Briefing Rum
    [17] = {locked = true, key = "key_lspd", permission="politi.ledelse.doors", name = "Alex Vargas", hash = -543497392, coords={445.10922241211,-979.54260253906,26.668563842773}}, -- (peters kontor)
    [18] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -543497392, coords={439.17065429688,-979.5458984375,26.668539047241}}, -- medical
    [19] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -543497392, coords={465.5885925293,-990.67163085938,24.914691925049}, pairs = 20}, -- dør ind til lager, server og lab
    [20] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -543497392, coords={465.65283203125,-989.37585449219,24.914712905884}, pairs = 19}, -- dør ind til lager, server og lab
    [21] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -131296141, coords={471.36511230469,-985.28692626953,24.914691925049}}, -- lager evidence locker
    [22] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -131296141, coords={468.52066040039,-977.97973632813,24.9146900177}}, -- server rum
    [23] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -131296141, coords={463.60006713867,-981.39489746094,24.914720535278}}, -- lab
    [24] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -1033001619, coords={467.64984130859,-1003.5553588867,24.91471862793}}, -- INTERVIEW
    [25] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -1033001619, coords={472.13125610352,-1003.564453125,24.91471862793}}, -- INTERVIEW
    [26] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -1033001619, coords={476.36715698242,-1003.5130615234,24.91471862793}}, -- INTERVIEW
    [27] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -1033001619, coords={480.61016845703,-1003.3960571289,24.914709091187}}, -- INTERVIEW
    [28] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -1033001619, coords={480.93423461914,-996.42108154297,24.914709091187}}, -- lukkede Celler
    [29] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -1033001619, coords={476.57382202148,-996.46960449219,24.914716720581}}, -- lukkede Celler
    [30] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -1033001619, coords={472.13314819336,-996.43225097656,24.914716720581}}, -- lukkede Celler
    [31] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -1033001619, coords={467.87561035156,-996.43469238281,24.914691925049}}, -- lukkede Celler
    [32] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -1033001619, coords={464.31146240234,-1003.5274047852,24.914712905884}}, -- tremmer Celler til baggård
    [33] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = 631614199, coords={461.8151550293,-993.91912841797,24.914709091187}}, -- tremmer Celler 1
    [34] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = 631614199, coords={461.70974731445,-998.33215332031,24.914699554443}}, -- tremmer Celle 2
    [35] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = 631614199, coords={462.21188354492,-1001.8206176758,24.914699554443}}, -- tremmer Celler 3
    [36] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = 631614199, coords={463.93350219727,-992.8134765625,24.914714813232}}, -- tremmer Celler til kontor
    [37] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -543497392, coords={470.10549926758,-1009.692199707,26.386318206787}}, -- Meeting Room
    [38] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -543497392, coords={470.08413696289,-1011.1427612305,26.386318206787}}, -- Meeting Room
    [39] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -2023754432, coords={467.89376831055,-1014.5333251953,26.386333465576}}, -- til baggarage
    [40] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -2023754432, coords={469.44607543945,-1014.5020141602,26.386360168457}}, -- til baggarage

    --Centrum PD førstesal
    [41] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -131296141, coords={449.44653320313,-992.46514892578,35.931114196777}}, -- Floor dør fra trappen
    [42] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -131296141, coords={445.25543212891,-988.76287841797,35.931106567383}}, -- Floor dør fra trappen/central. #2
    [43] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -131296141, coords={449.61264038086,-982.98364257813,35.931106567383}}, -- Floor dør/ til central. #3
    [44] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -131296141, coords={451.95767211914,-980.42333984375,35.931083679199}}, -- Dør til office
    [45] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -131296141, coords={461.09130859375,-980.11962890625,35.931091308594}}, -- Dør til office
    [46] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -131296141, coords={463.59411621094,-984.28265380859,35.931064605713}}, -- Til Trappe.
    [47] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -131296141, coords={463.36575317383,-990.35021972656,35.931102752686}}, -- Rengøring.
    [48] = {locked = true, key = "key_lspd", permission="politi.ledelse.doors", name = "Ledelses Kontor", hash = -131296141, coords={460.05459594727,-994.28491210938,35.93111038208}}, -- Kontor til P3 og P4 Kun Til lederrank.
    [49] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -131296141, coords={460.10800170898,-997.21813964844,35.931083679199}}, -- Printer.
    [50] = {locked = true, key = "key_lspd", permission="politi.ledelse.doors", name = "Emil Hansen", hash = -1320876379, coords={462.28314208984,-1000.7785644531,35.931087493896}}, -- Emil Hansen Kontor Kun til lederrank.
    [51] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -131296141, coords={475.69418334961,-992.18109130859,35.931098937988}}, -- Møde rum
    [52] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -131296141, coords={485.02639770508,-992.42651367188,35.931114196777}}, -- Møde rum
    [53] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -131296141, coords={477.47750854492,-1001.4261474609,35.931114196777}}, -- office
    [54] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -131296141, coords={478.02691650391,-1010.7937011719,35.931106567383}}, -- office
    [55] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -603023671, coords={429.09060668945,-994.67742919922,35.73685836792}}, -- Trasse.
    [56] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -603023671, coords={429.11758422852,-995.61328125,35.736854553223}}, -- Trasse.
    [57] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = 1622278560, coords={423.60632324219,-993.431640625,30.710691452026}}, -- Dør til biludtagning.
    [58] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -1603817716, coords={409.58587646484,-1025.4364013672,29.387027740479},range = 10.0}, -- Port til biludtagning.
    [59] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -368655288, coords={416.71878051758,-1018.5625610352,29.285278320313}, pairs = 60}, -- dør 2 til biludtagning.
    [60] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = -368655288, coords={417.89157104492,-1018.6293945313,29.288066864014}, pairs = 59}, --dør 2 til biludtagning
    [61] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation", hash = 507213820, coords={463.39117431641,-1011.2541503906,32.987205505371}}, -- Personale Taresse.
    
	-- Centrum PD bagport
    [62] = {locked = true, key = "key_lspd", permission="police.pc", name = "Centrum PD", hash=-1603817716, coords={488.91033935547,-1017.6137695313,28.212596893311}, range = 10.0},
    
	-- Politi Skydebane
	[63] = {locked = true, key = "key_lspd", permission="politi.assistent.doors", name = "Skydebane", hash= -1603817716, coords={-1141.3863525391,-1750.2001953125,4.090744972229}, range = 10.0},

	-- Frie spots
	--[85] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-2023754432,coords={1856.8505859375,3690.0349121094,34.267116546631}},
	--[86] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-2023754432,coords={1856.8505859375,3690.0349121094,34.267116546631}},
	--[87] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-2023754432,coords={1856.8505859375,3690.0349121094,34.267116546631}},
	--[88] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-2023754432,coords={1856.8505859375,3690.0349121094,34.267116546631}},
	--[89] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-2023754432,coords={1856.8505859375,3690.0349121094,34.267116546631}},
	--[90] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-2023754432,coords={1856.8505859375,3690.0349121094,34.267116546631}},
	--[91] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-2023754432,coords={1856.8505859375,3690.0349121094,34.267116546631}},
	--[92] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-2023754432,coords={1856.8505859375,3690.0349121094,34.267116546631}},
	--[93] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-2023754432,coords={1856.8505859375,3690.0349121094,34.267116546631}},
	--[94] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-2023754432,coords={1856.8505859375,3690.0349121094,34.267116546631}},
	--[95] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-2023754432,coords={1856.8505859375,3690.0349121094,34.267116546631}},
	--[96] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-2023754432,coords={1856.8505859375,3690.0349121094,34.267116546631}},
	--[97] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-2023754432,coords={1856.8505859375,3690.0349121094,34.267116546631}},
	--[98] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-2023754432,coords={1856.8505859375,3690.0349121094,34.267116546631}},
	--[99] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-2023754432,coords={1856.8505859375,3690.0349121094,34.267116546631}},
	--[100] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-2023754432,coords={1856.8505859375,3690.0349121094,34.267116546631}},
	
    --Pillbox Hospital
	[101] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=854291622,coords={308.14950561523,-597.47357177734,43.28401184082}},
	[102] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=854291622,coords={308.11547851563,-569.89660644531,43.284027099609}},
	[103] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-434783486,coords={313.04125976563,-571.85571289063,43.284496307373}, pairs = 104},
	[104] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-1700911976,coords={313.04125976563,-571.85571289063,43.284496307373}, pairs = 103},
	[105] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-434783486,coords={318.99060058594,-574.18243408203,43.286819458008}, pairs = 106},
	[106] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-1700911976,coords={318.99060058594,-574.18243408203,43.286819458008}, pairs = 105},
	[107] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-434783486,coords={324.36846923828,-576.19488525391,43.284042358398}, pairs = 108},
	[108] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-1700911976,coords={324.36846923828,-576.19488525391,43.284042358398}, pairs = 107},
	[109] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=854291622,coords={336.74993896484,-580.40222167969,43.284015655518}},
	[110] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=854291622,coords={341.25985717773,-582.04022216797,43.284027099609}},
	[111] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=854291622,coords={339.83416748047,-587.03082275391,43.284019470215}},
	[112] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=854291622,coords={337.57846069336,-592.96667480469,43.284027099609}},
	[113] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=854291622,coords={357.06970214844,-580.43499755859,43.292686462402}},
	[114] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=854291622,coords={356.06695556641,-584.13745117188,43.284023284912}},
	[115] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=854291622,coords={361.46646118164,-589.19720458984,43.284023284912}},
	[116] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=854291622,coords={359.52954101563,-594.01477050781,43.284019470215}},
	[117] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=854291622,coords={352.0751953125,-594.95275878906,43.284023284912}},
	[118] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=854291622,coords={347.46548461914,-584.27642822266,43.284019470215}},
	[119] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=854291622,coords={350.62890625,-598.54248046875,43.284023284912}},
	[120] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=854291622,coords={346.94076538086,-592.81976318359,43.284027099609}},
	[121] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-434783486,coords={327.75350952148,-593.91424560547,43.285713195801}, pairs = 122},
	[122] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-1700911976,coords={327.75350952148,-593.91424560547,43.285713195801}, pairs = 121},
	[123] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-434783486,coords={349.06948852539,-586.90454101563,43.284030914307}, pairs = 124},
	[124] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-1700911976,coords={348.75122070313,-588.10577392578,43.28392791748}, pairs = 123},
	-- Sandy Hospital
	[125] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	
	--[126] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	--[127] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	--[128] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	--[129] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	--[130] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	--[131] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	--[132] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	--[133] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	--[134] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	--[135] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	--[136] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	--[137] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	--[138] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	--[139] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	--[140] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	--[141] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	--[142] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	--[143] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	--[144] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	--[145] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	--[146] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	--[147] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	--[148] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	--[149] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	--[150] = {locked = true, key = "key_hospital", permission="emergency.key", name = "Hospital",hash=-770740285,coords={1837.8304443359,3684.6977539063,34.2727394104}},
	

    -- Ejendomsmægler
    [151] = {locked = true, key = "key_realestate", permission="realestate.key", name = "Ejendomsmægler",hash=220394186,coords={-140.21783447266,-626.10949707031,168.82043457031}, pairs = 152},
    [152] = {locked = true, key = "key_realestate", permission="realestate.key", name = "Ejendomsmægler",hash=220394186,coords={-139.44232788086,-626.13616943359,168.82040405273}, pairs = 151},
	[153] = {locked = true, key = "key_realestate", permission="realestate.key", name = "Ejendomsmægler",hash=1939954886,coords={-131.4874420166,-637.57611083984,168.82037353516}},
    [154] = {locked = true, key = "key_realestate", permission="realestate.key", name = "Ejendomsmægler",hash=1939954886,coords={-133.8650970459,-631.32440185547,168.82046508789}},

    -- Advokat
    [155] = {locked = true, key = "key_advokat", permission="advokat.duty", name = "Advokat",hash=-1821777087,coords={138.72561645508,-768.16802978516,242.1522064209}},
    [156] = {locked = true, key = "key_advokat", permission="advokat.duty", name = "Advokat",hash=-1821777087,coords={127.40701293945,-764.02618408203,242.15190124512}},
    [157] = {locked = true, key = "key_advokat", permission="advokat.duty", name = "Advokat",hash=-853859998,coords={133.0364074707,-767.99884033203,242.15209960938}},
	
    -- Bilforhandleren
    [158] = {locked = false, key = "key_bilforhandler", permission="bilforhandler.doors", name = "Bilforhandler",hash=2059227086,coords={-38.636848449707,-1108.3608398438,26.468864440918}, pairs = 159},	 -- Indgang 1
    [159] = {locked = false, key = "key_bilforhandler", permission="bilforhandler.doors", name = "Bilforhandler",hash=1417577297,coords={-37.818347930908,-1108.7191162109,26.468883514404}, pairs = 158},	 -- Indgang 1
    [160] = {locked = false, key = "key_bilforhandler", permission="bilforhandler.doors", name = "Bilforhandler",hash=-2051651622,coords={-34.122013092041,-1108.2292480469,26.422351837158}},    			 -- Kontor
    [161] = {locked = false, key = "key_bilforhandler", permission="bilforhandler.doors", name = "Bilforhandler",hash=-2051651622,coords={-31.903076171875,-1102.4223632813,26.422357559204}},    			 -- Kontor
    [162] = {locked = false, key = "key_bilforhandler", permission="bilforhandler.doors", name = "Bilforhandler",hash=2059227086,coords={-60.018104553223,-1093.4749755859,26.67373085022}, pairs = 163},    -- Indgang 2
    [163] = {locked = false, key = "key_bilforhandler", permission="bilforhandler.doors", name = "Bilforhandler",hash=1417577297,coords={-60.425937652588,-1094.2043457031,26.673414230347}, pairs = 162},   -- Indgang 2
    [164] = {locked = false, key = "key_bilforhandler", permission="bilforhandler.doors", name = "Bilforhandler",hash=1286535678,coords={-12.702404022217,-1088.6901855469,26.672050476074}, range = 10.0},  --port

    -- Fængsles Porte
    [165] = {locked = true, key = "key_lspd", permission="police.pc", name = "Fængsel", hash=741314661, coords={1845.0898,2609.6157,45.6005}, range = 10.0},
    [166] = {locked = true, key = "key_lspd", permission="police.pc", name = "Fængsel", hash=741314661, coords={1818.6126,2609.7465,45.6065}, range = 10.0},

    -- Casino
	[167] = {locked = true, key = "key_casino", permission="casino.adgang", name = "Casino",hash=680601509,coords={1122.3703613281,264.12133789063,-51.040699005127}, pairs = 168},
    [168] = {locked = true, key = "key_casino", permission="casino.adgang", name = "Casino",hash=680601509,coords={1122.3210449219,264.92446899414,-51.040710449219}, pairs = 167},
	[169] = {locked = true, key = "key_casinom", permission="casinomanager.adgang", name = "Casino",hash=-643593781,coords={1111.4016113281,251.03277587891,-45.84103012085}, pairs = 170},
    [170] = {locked = true, key = "key_casinom", permission="casinomanager.adgang", name = "Casino",hash=-643593781,coords={1110.630859375,251.08963012695,-45.841026306152}, pairs = 169},

	--Våben butik
	[176] = {locked = true, key = "key_drugdealer", permission="weapons.dealer", name = "Indgang",hash=-8873588,coords={811.23699951172,-2148.2788085938,29.619029998779}, pairs = 267}, -- Indgangs dør
	[177] = {locked = true, key = "key_drugdealer", permission="weapons.dealer", name = "Indgang",hash=97297972,coords={812.48699951172,-2148.2639160156,29.61900138855}, pairs = 266}, -- Indgangs dør
	[178] = {locked = true, key = "key_drugdealer", permission="weapons.dealer", name = "Indgang",hash=452874391,coords={826.70233154297,-2160.4514160156,29.618896484375}}, -- Indgangs dør

	--Vingården
    [179] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=1077118233,coords={-1889.5582275391,2052.0229492188,141.01428222656}, pairs = 180},
    [180] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=1077118233,coords={-1888.4501953125,2051.6123046875,141.00901794434}, pairs = 179},
    [181] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=1077118233,coords={-1886.9470214844,2050.9106445313,141.00761413574}, pairs = 182},
    [182] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=1077118233,coords={-1885.8067626953,2050.7346191406,141.00849914551}, pairs = 181},
    [183] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=1843224684,coords={-1908.1851806641,2072.4362792969,140.40837097168}, pairs = 184},
    [184] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=1843224684,coords={-1908.9870605469,2073.0437011719,140.40692138672}, pairs = 183},
    [185] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=1843224684,coords={-1910.6384277344,2074.3525390625,140.40142822266}, pairs = 186},
    [186] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=1843224684,coords={-1911.4051513672,2075.0734863281,140.40740966797}, pairs = 185},
    [187] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=1843224684,coords={-1911.2692871094,2079.2717285156,140.40574645996}, pairs = 188},
    [188] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=1843224684,coords={-1910.5539550781,2080.0788574219,140.40751647949}, pairs = 187},
    [189] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=1843224684,coords={-1907.2359619141,2084.1862792969,140.39529418945}, pairs = 190},
    [190] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=1843224684,coords={-1906.4099121094,2084.9401855469,140.44924926758}, pairs = 189},
    [191] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=1843224684,coords={-1902.4361572266,2086.1000976563,140.40347290039}, pairs = 192},
    [192] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=1843224684,coords={-1901.6147460938,2085.3176269531,140.40791320801}, pairs = 191},
    [193] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=1843224684,coords={-1899.82421875,2083.9777832031,140.4009857172277}, pairs = 194},
    [194] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=1843224684,coords={-1899.2318115234,2083.2368164063,140.40794372559}, pairs = 193},
    [195] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=1077118233,coords={-1886.6395263672,2074.0419921875,140.99830627441}, pairs = 196},
    [196] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=1077118233,coords={-1885.6127929688,2073.7260742188,141.00694274902}, pairs = 195},
    [197] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=1077118233,coords={-1875.0906982422,2069.7297363281,140.99748222998}, pairs = 198},
    [198] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=1077118233,coords={-1874.1032714844,2069.2875976563,140.99655151367}, pairs = 197},
    [199] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=1077118233,coords={-1859.8555908203,2054.1320800781,141.00971984863}, pairs = 200},
    [200] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=1077118233,coords={-1860.9278564453,2054.2165527344,141.00944519043}, pairs = 199},
    [201] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=1077118233,coords={-1893.4396972656,2074.880859375,141.007934527031}, pairs = 202},
    [202] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=1077118233,coords={-1894.2457275391,2075.5148925781,141.00793457031}, pairs = 201},
    [203] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=-1141522158,coords={-1864.2348632813,2060.5366210938,141.1234897988}, pairs = 204},
    [204] = {locked = true, key = "key_vineyard", permission="weapons.dealer", name = "Vingården", boomAble=true, hash=988364535,coords={-1864.2348632813,2060.5366210938,141.123489372988}, pairs = 203},

	---- [ Bank røverier ] ----
  -- Nationalbanken
	[205] = {locked = true, key = "", permission="politi.bank", name = "Banken", hash=-222270721,coords={257.05178833008,220.59799194336,106.28520202637}},
	[206] = {locked = true, key = "", permission="politi.bank", name = "Banken", hash=746855201,coords={261.56207275391,221.82202148438,106.28345489502}},
	[207] = {locked = true, key = "", permission="politi.bank", name = "Banken", hash=961976194,coords={253.79254150391,224.58407592773,101.87554168701},heading = 0.0, heading2= -200.0,freeze = true},


    --Alm. Brand Bank (Alta - Nord for LS Midtby)
    [208] = {locked = true, key = "", permission="politi.bank", name = "Banken", hash=2121050683,coords={311.97497558594,-283.65689086914,54.1647605896},heading = -200.0, heading2 = -110.0, freeze = true},
    [209] = {locked = true, key = "", permission="politi.bank", name = "Banken", hash=-1591004109,coords={313.89852905273,-285.77478027344,54.143043518066}},

    --Sydbank
    [210] = {locked = true, key = "", permission="politi.bank", name = "Banken", hash=2121050683,coords={-1210.8043212891,-335.20571899414,37.777481079102},heading = -200.0, heading2 = -65.0, freeze = true},
    [211] = {locked = true, key = "", permission="politi.bank", name = "Banken", hash=-1591004109,coords={-1208.0363769531,-335.56130981445,37.759269714355}},

    --Jyskebank
    [212] = {locked = true, key = "", permission="politi.bank", name = "Banken", hash=-1185205679,coords={-105.32761383057,6472.8159179688,31.626712799072},heading = -180.0, heading2 = 45.0, freeze = true},
    [213] = {locked = true, key = "", permission="politi.bank", name = "Banken", hash=1309269072,coords={-105.86994171143,6475.7109375,31.626710891724}},

    -- Ringkjøbing LandboBank
    [214] = {locked = true, key = "", permission="politi.bank", name = "Banken", hash=2121050683,coords={1175.2554931641,2711.6921386719,38.066223144531},heading = -5.0, heading2 = -270.0, freeze = true},
    [215] = {locked = true, key = "", permission="politi.bank", name = "Banken", hash=-1591004109,coords={1173.0814208984,2713.173828125,38.066265106201}},

    -- Nordea Bank
    [216] = {locked = true, key = "", permission="politi.bank", name = "Banken", hash=-63539571,coords={-2957.8088378906,482.41696166992,15.675259590149},heading = -110.0, heading2 = -3.0, freeze = true},
    [217] = {locked = true, key = "", permission="politi.bank", name = "Banken", hash=-1591004109,coords={-2956.234375,484.50592041016,15.675326347351}},

    -- Midtby Bank
    [218] = {locked = true, key = "", permission="politi.bank", name = "Banken", hash=2121050683,coords={147.86676025391,-1045.3984375,29.346273422241},heading = -200.0, heading2 = -110.0, freeze = true},
    [219] = {locked = true, key = "", permission="politi.bank", name = "Banken", hash=-1591004109,coords={149.48538208008,-1047.3760986328,29.346326828003}},

	---- [ Bank røverier ] ----

	-- Alex og musti's tøjbutik
	[220] = {locked = true, key = "key_a&m", permission="", name = "Alex Musti", hash=-1922281023,coords={-156.65487670898,-304.93368530273,39.733322143555}, pairs = 221},
	[221] = {locked = true, key = "key_a&m", permission="", name = "Alex Musti", hash=-1922281023,coords={-157.05023193359,-305.99588012695,39.733287811279}, pairs = 220},
	
	-- Kiosk midtby
	[222] = {locked = true, key = "", permission="", name = "Kiosk Midtby", hash=997554217,coords={29.646091461182,-1349.1127929688,29.497049331665}},
	[223] = {locked = true, key = "", permission="", name = "Kiosk Midtby", hash=1196685123,coords={28.600896835327,-1349.1954345703,29.497013092041}},

    -- Sandy pd NEW
    [224] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-1526530025,coords={1855.1737060547,3683.4392089844,34.273502349854}}, 
    [225] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=58829732,coords={1862.0808105469,3690.7971191406,34.277206420898}},
    [226] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-777304072,coords={1856.2344970703,3689.1328125,34.275787353516}},
    [227] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=58829732,coords={1847.9895019531,3683.6545410156,34.275356292725}, pairs = 228},
    [228] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-777304072,coords={1847.1025390625,3682.8686523438,34.275367736816}, pairs = 227},
    [229] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=58829732,coords={1850.3428955078,3683.3608398438,34.275276184082}, pairs = 230},
    [230] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-777304072,coords={1850.8577880859,3682.2807617188,34.275272369385}, pairs = 229},
    [231] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=58829732,coords={1851.2677001953,3691.0886230469,34.276798248291}, pairs = 232},
    [232] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-777304072,coords={1850.1097412109,3690.451171875,34.276733398438}, pairs = 231},
    [233] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=58829732,coords={1850.1519775391,3693.0056152344,34.276859283447}, pairs = 234},
	[234] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-777304072,coords={1848.85546875,3692.4091796875,34.276798248291}, pairs = 233},
    [235] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=1930067898,coords={1840.8920898438,3685.8186035156,30.267961502075}},
	[236] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=1930067898,coords={1841.0893554688,3681.546875,30.267944335938}},
    [237] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-2023754432,coords={1844.9624023438,3678.6657714844,30.267963409424}, pairs = 238},
	[238] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-2023754432,coords={1844.1907958984,3679.8935546875,30.267936706543}, pairs = 237},
	[240] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-2023754432,coords={1848.0628662109,3683.6252441406,30.267951965332}, pairs = 241},
	[241] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-2023754432,coords={1846.8842773438,3682.9606933594,30.267955780029}, pairs = 240},
	[242] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-2023754432,coords={1852.4035644531,3686.2563476563,30.267950057983}},
	[243] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-2023754432,coords={1855.3690185547,3687.8571777344,30.267957687378}},
	[245] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-1927754726,coords={1858.7370605469,3687.8520507813,30.267961502075}},
	[246] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-1927754726,coords={1862.4091796875,3688.8813476563,30.267944335938}},
	[247] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-1927754726,coords={1860.4670410156,3692.1511230469,30.267944335938}},
    [248] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-1927754726,coords={1858.6129150391,3695.2783203125,30.267944335938}},
    [249] = {locked = true, key = "key_lspd", permission="police.pc", name = "Politistation",hash=-1927754726,coords={1850.251953125,3682.9821777344,30.267963409424}}, 
	
	
	
	-- Retssal
	
	[250] = {locked = false, key = "key_dommer", permission="court.doors", name = "Retssal",hash=1877301548,coords={238.27935791016,-413.69869995117,48.110649108887}, pairs = 250},
	[251] = {locked = false, key = "key_dommer", permission="court.doors", name = "Retssal",hash=1877301548,coords={237.17977905273,-413.14483642578,48.111717224121}, pairs = 249},
	[252] = {locked = false, key = "key_dommer", permission="court.doors", name = "Retssal",hash=1877301548,coords={233.37515258789,-411.83065795898,48.111713409424}, pairs = 252},
	[253] = {locked = false, key = "key_dommer", permission="court.doors", name = "Retssal",hash=1877301548,coords={232.14311218262,-411.52490234375,48.076763153076}, pairs = 251},
	[254] = {locked = true, key = "key_dommer", permission="court.doors", name = "Retssal",hash=-553305514,coords={207.19679260254,-416.78454589844,48.076766967773}, pairs = 254},
	[255] = {locked = true, key = "key_dommer", permission="court.doors", name = "Retssal",hash=-553305514,coords={205.94604492188,-416.16772460938,48.076763153076}, pairs = 253},
	[256] = {locked = true, key = "key_dommer", permission="court.doors", name = "Retssal",hash=-553305514,coords={251.63171386719,-430.2926940918,48.076721191406}, pairs = 256},
	[257] = {locked = true, key = "key_dommer", permission="court.doors", name = "Retssal",hash=-553305514,coords={250.27755737305,-429.81433105469,48.076763153076}, pairs = 255},
	[258] = {locked = true, key = "key_dommer", permission="court.doors", name = "Retssal",hash=-553305514,coords={250.42726135254,-434.22229003906,48.07674407959}, pairs = 258},
	[259] = {locked = true, key = "key_dommer", permission="court.doors", name = "Retssal",hash=-553305514,coords={251.66146850586,-434.47714233398,48.07674407959}, pairs = 257},
	[260] = {locked = true, key = "key_dommer", permission="court.doors", name = "Retssal",hash=-553305514,coords={261.88571166992,-416.8017578125,48.226146697998}},
	[261] = {locked = true, key = "key_dommer", permission="court.doors", name = "Retssal",hash=-553305514,coords={250.53147888184,-412.68432617188,48.076725006104}},
	[262] = {locked = true, key = "key_dommer", permission="court.doors", name = "Retssal",hash=-553305514,coords={207.63148498535,-421.96475219727,48.076770782471}},
	[263] = {locked = true, key = "key_dommer", permission="court.doors", name = "Retssal",hash=-553305514,coords={217.1649017334,-404.23010253906,48.076770782471}},
	[264] = {locked = true, key = "key_dommer", permission="court.doors", name = "Retssal",hash=-553305514,coords={206.70843505859,-400.34173583984,48.076763153076}},
	
	
	}
return cfg
