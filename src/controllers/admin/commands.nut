// /**
//  * Ban player account for some time.    <-------------------- Currently not working properly
//  * @param  {uint}   cheaterID
//  * @param  {String} reason    Explonation why player is cheater
//  * @param  {Number} adminID   Pass -1 by default if send ban from console
//  * @param  {Number} banDays   Pass 0 for permanent ban
//  * @return {void}
//  */
// function banPlayerAccount( cheaterID, reason = "", adminID = -1, banDays = 1 ) {
//     local banTime = banDays * 86400;
//     return banPlayer( cheaterID, adminID, banTime, reason );
// }


// /**
//  * Ban player account for some time
//  * @param  {uint}   cheaterID
//  * @param  {String} reason    Explonation why player is cheater
//  * @param  {Number} adminID   Pass -1 by default if send ban from console
//  * @param  {Number} banDays   Pass 0 for permanent ban
//  * @return {void}
//  */
// function banPlayerSerial( cheaterID, reason = "", adminID = -1, banDays = 1 ) {
//     local banTime = banDays * 86400;
//     local serial = getPlayerSerial( cheaterID );
//     return banSerial( serial, adminID, banTime, reason);
// }

acmd("name", function(playerid, targetid) {
    if (isPlayerConnected(playerid)) {
        msg(playerid, "Info: " + getIdentity(targetid.tointeger()), CL_MEDIUMPURPLE);
    } else {
        msg(playerid, "Player is not connected", CL_MEDIUMPURPLE);
    }
});

acmd("list", function(playerid) {
    msg(playerid, "Current player list:", CL_MEDIUMPURPLE);
    foreach (pid, value in getPlayers()) {
        msg(playerid, "Info: " + getIdentity(pid));
    }
});

acmd(["admin", "adm"], function(playerid, ...) {
    if(getPlayerSerial(playerid) == "940A9BF3DC69DC56BCB6BDB5450961B4") {
        return sendPlayerMessageToAll("[ADMIN] " + concat(vargv), CL_MEDIUMPURPLE.r, CL_MEDIUMPURPLE.g, CL_MEDIUMPURPLE.b);
    }
    else{
        return sendPlayerMessageToAll("[A] "+getAccountName(playerid)+": " + concat(vargv), CL_MEDIUMPURPLE.r, CL_MEDIUMPURPLE.g, CL_MEDIUMPURPLE.b);
    }
});

key("o", function(playerid) {
    if (isPlayerAdmin(playerid)) {
        trigger(playerid, "onServerToggleBlip", "v");
    }
});

key("i", function(playerid) {
    if (isPlayerAdmin(playerid)) {
        trigger(playerid, "onServerToggleBlip", "p");
    }
});

// acmd(["admin", "adm", "a"], "kick", function(playerid, targetid, ...) {
//     local targetid = targetid.tointeger();
//     local reason = concat(vargv);
//     dbg(reason);
//     log( getAuthor(playerid) + "'s kick " + getAuthor(targetid) + " for: " + reason);
//     freezePlayer( targetid, true );
//     stopPlayerVehicle( targetid );
//     msg(targetid, format("You has been kicked for: %s", reason), CL_RED);
//     delayedFunction(5000, function () {
//         kickPlayer( targetid );
//     });
// });




// acmd(["admin", "adm", "a"], "ban", function(playerid, targetid, srok, type, ...) {
//     local targetid = targetid.tointeger();

//     local srok = srok.tointeger();
//     local time = null;
//         local srok_title = "";
//     if (type == null) {
//         time = srok * 60;
//     }

//     else if (type == "year" || type == "years") {
//         time = srok * 31104000; srok_title = "year";
//     }

//     else if (type == "month" || type == "months") {
//         time = srok * 2592000; srok_title = "month";
//     }

//     else if (type == "day" || type == "day") {
//         time = srok * 86400; srok_title = "day";
//     }

//     else if (type == "hour" || type == "hours") {
//         time = srok * 3600; srok_title = "hour";
//     }

//     else if (type == "minute" || type == "minutes" || type == "min" || type == "mins") {
//         time = srok * 60; srok_title = "minute";
//     }

//     if (srok > 1) { srok_title = srok_title+"s";  }

//     local reason = concat(vargv);
//         dbg(reason);
//     log( getAuthor(playerid) + "'s banned " + getAuthor(targetid) + " for " + srok + " "+srok_title+". Reason: " + reason);
//     freezePlayer( targetid, true );
//     stopPlayerVehicle( targetid );
//     msg(targetid, format("You has been banned for: %s", reason), CL_RED);

//     delayedFunction(5000, function () {
//         banPlayerSerial( targetid, reason, playerid, time );
//     });
// });

function planServerRestart(playerid) {
    msga("autorestart.15min", [], CL_RED);

    delayedFunction(5*60*1000, function() {
        msga("autorestart.10min", [], CL_RED);
    });

    delayedFunction(10*60*1000, function() {
        msga("autorestart.5min", [], CL_RED);
    });

    delayedFunction(14*60*1000, function() {
        msga("autorestart.1min", [], CL_RED);
    });

    delayedFunction(15*60*1000, function() {
        msga("autorestart.3sec", [], CL_RED);

        trigger("native:onServerShutdown");

        // kick all dawgs
        delayedFunction(1000, function() {
            msga("autorestart.now", [], CL_RED);

            delayedFunction(1000, function() {
                // request restart
                dbg("server", "restart", "requested");
            });
        });
    });
}

acmd("restart", planServerRestart);

alternativeTranslate({
    "en|autorestart.15min"  : "[AUTO-RESTART] Server will be restarted in 15 minutes. Please, complete all your jobs. Thanks!"
    "ru|autorestart.15min"  : "[АВТО-РЕСТАРТ] Сервер будет перезагружен через 15 минут. Пожалуйста, завершите все свои задания. Спасибо!"
    "en|autorestart.10min"  : "[AUTO-RESTART] Server will be restarted in 10 minutes. Please, complete all your jobs. Thanks!"
    "ru|autorestart.10min"  : "[АВТО-РЕСТАРТ] Сервер будет перезагружен через 10 минут. Пожалуйста, завершите все свои задания. Спасибо!"
    "en|autorestart.5min"   : "[AUTO-RESTART] Server will be restarted in 5 minutes."
    "ru|autorestart.5min"   : "[АВТО-РЕСТАРТ] Сервер будет перезагружен через 5 минут."
    "en|autorestart.1min"   : "[AUTO-RESTART] Server will be restarted in 1 minute."
    "ru|autorestart.1min"   : "[АВТО-РЕСТАРТ] Сервер будет перезагружен через 1 минуту."
    "en|autorestart.3sec"   : "[AUTO-RESTART] Server will be restarted in 3 seconds. See you soon ;)"
    "ru|autorestart.3sec"   : "[АВТО-РЕСТАРТ] Сервер будет перезагружен через 3 секунды. До скорой встречи ;)"
    "en|autorestart.now"    : "[AUTO-RESTART] Restarting now!"
    "ru|autorestart.now"    : "[AВТО-РЕСТАРТ] Поехали!"
});
