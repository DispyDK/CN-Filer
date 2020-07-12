Config = {}

----------------------------------------------------
-------- Intervalles en secondes -------------------
----------------------------------------------------

-- Temps d'attente Antispam / Waiting time for antispam
Config.AntiSpamTimer = 10

-- Vérification et attribution d'une place libre / Verification and allocation of a free place
Config.TimerCheckPlaces = 5

-- Mise à jour du message (emojis) et accès à la place libérée pour l'heureux élu / Update of the message (emojis) and access to the free place for the lucky one
Config.TimerRefreshClient = 5

-- Mise à jour du nombre de points / Number of points updating
Config.TimerUpdatePoints = 10

----------------------------------------------------
------------ Nombres de points ---------------------
----------------------------------------------------

-- Nombre de points gagnés pour ceux qui attendent / Number of points earned for those who are waiting
Config.AddPoints = 1

-- Nombre de points perdus pour ceux qui sont entrés dans le serveur / Number of points lost for those who entered the server
Config.RemovePoints = 1

-- Nombre de points gagnés pour ceux qui ont 3 emojis identiques (loterie) / Number of points earned for those who have 3 identical emojis (lottery)
Config.LoterieBonusPoints = 25

-- Accès prioritaires / Priority access
Config.Points = {
	-- {'steamID', points},
}

----------------------------------------------------
------------- Textes des messages ------------------
----------------------------------------------------

-- Si steam n'est pas détecté / If steam is not detected
--Config.NoSteam = "Steam n'a pas été détecté. Veuillez (re)lancer Steam et FiveM, puis réessayer."
Config.NoSteam = "Tjek om du har dit steam åben og ellers prøv at genstarte det."

-- Message d'attente / Waiting text
--Config.EnRoute = "Vous êtes en route. Vous avez déjà parcouru"
Config.EnRoute = "Antal points: "

-- "points" traduits en langage RP / "points" for RP purpose
--Config.PointsRP = "kilomètres"
Config.PointsRP = ""

-- Position dans la file / position in the queue
--Config.Position = "Vous êtes en position "
Config.Position = "Din plads: "

-- Texte avant les emojis / Text before emojis
--Config.EmojiMsg = "Si les emojis sont figés, relancez votre client : "
Config.EmojiMsg = "Hvis emotene ikke skifter, genstart dit spil: "

-- Quand le type gagne à la loterie / When the player win the lottery
--Config.EmojiBoost = "!!! Youpi, " .. Config.LoterieBonusPoints .. " " .. Config.PointsRP .. " gagnés !!!"
Config.EmojiBoost = "!!! Du vandt, " .. Config.LoterieBonusPoints .. " " .. Config.PointsRP .. " points i køen !!!"

-- Anti-spam message / anti-spam text
--Config.PleaseWait_1 = "Veuillez patienter "
--Config.PleaseWait_2 = " secondes. La connexion se lancera automatiquement !"
Config.PleaseWait_1 = "Vent venligst "
Config.PleaseWait_2 = " sekunder."

-- Me devrait jamais s'afficher / Should never be displayed
--Config.Accident = "Oups, vous venez d'avoir un accident... Si cela se reproduit, vous pouvez en informer le support :)"
Config.Accident = "Der skete en fejl... Hvis det sker igen henven dig venligst i supporten!"

-- En cas de points négatifs / In case of negative points
--Config.Error = " ERREUR : RELANCEZ LA ROCADE ET CONTACTEZ LE SUPPORT DU SERVEUR "
Config.Error = " Der skete en fejl med dine point.. Rejoin venligst. "


Config.EmojiList = {
	'🐌',
	'🐍',
	'🐎',
	'🐑',
	'🐒',
	'🐘',
	'🐙',
	'🐛',
	'🐜',
	'🐝',
	'🐞',
	'🐟',
	'🐠',
	'🐡',
	'🐢',
	'🐤',
	'🐦',
	'🐧',
	'🐩',
	'🐫',
	'🐬',
	'🐲',
	'🐳',
	'🐴',
	'🐅',
	'🐈',
	'🐉',
	'🐋',
	'🐀',
	'🐇',
	'🐏',
	'🐐',
	'🐓',
	'🐕',
	'🐖',
	'🐪',
	'🐆',
	'🐄',
	'🐃',
	'🐂',
	'🐁',
	'🔥'
}
