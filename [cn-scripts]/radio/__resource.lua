resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

-- Example custom radios
supersede_radio "RADIO_03_HIPHOP_NEW" { url = "http://live-icy.gss.dr.dk:8000/A/A16L.mp3", volume = 0.1, name = "[DK] Radio P4" }
supersede_radio "RADIO_01_CLASS_ROCK" { url = "http://89.249.7.68/abc", volume = 0.1, name = "[DK] Radio ABC" }
supersede_radio "RADIO_05_TALK_01" { url = "http://stream.dbmedia.se/kp128", volume = 0.1, name = "[DK] Rock kanalen" }
supersede_radio "RADIO_02_POP" { url = "http://edge-bauerdk-03-gos2.sharp-stream.com/thevoice_dk_tunein_mp3?", volume = 0.1, name = "[DK] The voice" }
supersede_radio "RADIO_04_PUNK" { url = "http://stream.anr.dk/aura", volume = 0.1, name = "[DK] ANR" }
supersede_radio "RADIO_06_COUNTRY" { url = "http://stream.wlmm.dk/skagafm", volume = 0.1, name = "[DK] Skaga FM" }
supersede_radio "RADIO_07_DANCE_01" { url = "http://89.249.7.68:8050/solo", volume = 0.1, name = "[DK] Radio Solo" }
supersede_radio "RADIO_08_MEXICAN" { url = "http://stream1.partyfm.dk/Party256", volume = 0.1, name = "[DK] Party FM" }
supersede_radio "RADIO_09_HIPHOP_OLD" { url = "http://ipx.psyradio.org:8030/;", volume = 0.1, name = "[DK] Syre Musik" }
supersede_radio "RADIO_12_REGGAE" { url = "https://stream.laut.fm/best-of-techno", volume = 0.1, name = "[DK] Techno Musik" }




files {
	"index.html"
}

ui_page "index.html"

client_scripts {
	"data.js",
	"client.js"
}
