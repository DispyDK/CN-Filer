description "Simple Notification Script using https://notifyjs.com/"

ui_page "html/index.html"

client_script "cl_notify.lua"

export "SetQueueMax"
export "SendNotification"

files {
    "html/index.html",
    "html/pNotify.js",
    "html/noty.js",
    "html/noty.css",
    "html/themes.css",
    "html/seatbelt.wav",
    "html/modtaget.ogg",
    "html/modtagetpos.ogg",
    "html/sendt.ogg",
    "html/mobilepay.ogg",
    "html/handcuff.ogg",
    "html/jail.ogg",
    "html/Anchorup.ogg",
    "html/Anchordown.ogg",
    "html/paycheck.ogg",
    "html/sms.ogg",
    "html/twitternotify.ogg"
}