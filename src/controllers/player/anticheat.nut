/**
 * Table containing settings for
 * vehicle anti speed hacl
 *
 * Left side is a vehicle model
 * and right side is a array with
 * [soft limit, hard limit] where
 * soft limit is logging limit
 * hard limit is when player will be kicked
 *
 * @type {Object}
 */
local vehicleSpeedLimits = {
    all = [60.0, 70.0]
};

vehicleSpeedLimits[00] <- [56.0, 57.0];
vehicleSpeedLimits[01] <- [46.0, 47.0];
vehicleSpeedLimits[03] <- [21.0, 22.0];
vehicleSpeedLimits[04] <- [21.0, 22.0];
vehicleSpeedLimits[05] <- [32.5, 34.0];
vehicleSpeedLimits[06] <- [58.5, 62.5];
vehicleSpeedLimits[07] <- [51.5, 55.0];
vehicleSpeedLimits[08] <- [51.5, 55.0]; // have problem
vehicleSpeedLimits[09] <- [43.5, 45.0];
vehicleSpeedLimits[10] <- [55.0, 57.0];
vehicleSpeedLimits[11] <- [30.5, 32.0];
vehicleSpeedLimits[12] <- [30.5, 32.0];
vehicleSpeedLimits[13] <- [50.5, 52.0];
vehicleSpeedLimits[14] <- [40.5, 41.5];
vehicleSpeedLimits[15] <- [45.7, 46.2];
vehicleSpeedLimits[16] <- [45.1, 46.0]; // have problem
vehicleSpeedLimits[17] <- [47.1, 49.0];
vehicleSpeedLimits[18] <- [47.1, 49.0]; // have problem

vehicleSpeedLimits[19] <- [28.2, 30.0];
vehicleSpeedLimits[20] <- [26.0, 28.0];
vehicleSpeedLimits[24] <- [41.7, 42.5];
vehicleSpeedLimits[25] <- [36.8, 37.5];
vehicleSpeedLimits[31] <- [33.8, 35.0];
vehicleSpeedLimits[33] <- [36.5, 37.5];
vehicleSpeedLimits[35] <- [30.4, 32.5];
vehicleSpeedLimits[38] <- [30.0, 32.5];
vehicleSpeedLimits[42] <- [53.0, 54.0];
vehicleSpeedLimits[43] <- [32.5, 34.0];
vehicleSpeedLimits[47] <- [36.2, 36.9];
vehicleSpeedLimits[50] <- [41.5, 43.0];
vehicleSpeedLimits[51] <- [42.5, 43.5];
vehicleSpeedLimits[52] <- [53.0, 57.0];
vehicleSpeedLimits[53] <- [27.4, 28.5];


//local maxspeed = 0.0;
local playersInfo = {};
local maxToBan = 10; // minimun 2

event("onServerStarted", function() {

//createPlace("TestTeleport", -507.081, 599.982, -492.1, 618.343);

    local ticker = timer(function() {
        foreach (playerid, value in getPlayers()) {
            // anticheat check for speed-hack
            if (isPlayerInVehicle(playerid)) {
                local vehicleid = getPlayerVehicle(playerid);

                // block vehicle if player is driver and vehicle is blocked
                if (isPlayerVehicleDriver(playerid) && isVehicleBlocked(vehicleid) && !isPlayerAdmin(playerid)) {
                    blockVehicle(vehicleid);
                }

                local speed = getVehicleSpeed(vehicleid);
                local maxsp = max(fabs(speed[0]), fabs(speed[1]));
                local limits = vehicleSpeedLimits["all"];

                if (getVehicleModel(vehicleid) in vehicleSpeedLimits) {
                    limits = vehicleSpeedLimits[getVehicleModel(vehicleid)];
                }

                // debug
                /*
                if (maxsp > 5.0) {
                    if (maxsp > maxspeed) {
                        maxspeed = maxsp;
                        msg(playerid, "your speed " + maxsp);
                    }
                }
                */

                // check soft limit
                if (maxsp > limits[0]) {
                    dbg("anticheat", "speed", getIdentity(playerid), "model: " + getVehicleModel(vehicleid), maxsp);
                }

                // check hard limit
                if (maxsp > limits[1]) {
                    kick( -1, playerid, "speed-hack protection" );
                }
            } else {
                if(players.has(playerid)) {

                    local plaPos = getPlayerPosition(playerid);
                    local charId = players[playerid].id;
                    if( !(charId in playersInfo) ) return;

                    local oldPos = playersInfo[charId].pos;
                    local state = playersInfo[charId].state;

                    if(oldPos && state != null) {
                        local distance = getDistanceBetweenPoints2D( plaPos[0], plaPos[1], oldPos[0], oldPos[1] );
                        if(distance == 0) return;
                        if((state == 0 && distance > 1.1)
                        || (state == 1 && distance > 6.0)
                        || (state == 2 && distance > 4.0)
                        ) {
                            //log("================================================================ WARNING ===");
                            playersInfo[charId].counter += 1;
                            if(playersInfo[charId].counter > maxToBan) {
                                log("@everyone WARNING!!! "+getAuthor(playerid)+" - using trainer");
                                dbg("chat", "report", getAuthor(playerid), "Забанен за использование трейнера.");

                                freezePlayer(playerid, true);
                                delayedFunction(6000, function () {
                                    newban(playerid, playerid, 502009359, plocalize(playerid, "admin.ban.trainer"));
                                });

                                playersInfo[charId].counter = 0;
                            }
                        } else {
                            playersInfo[charId].counter = 0;
                        }
                        //log("distance distance distance distance distance "+state.tostring()+" distance: "+distance.tostring());
                    }
                    playersInfo[charId].pos = [plaPos[0], plaPos[1]];
                }

            }

            // anticheat - remove weapons
            if (!isOfficer(playerid) && !isPlayerAdmin(playerid)) {

                local weapon = getPlayerWeapon(playerid);
                if(weapon > 1 && weapon <= 21) {
                    //local weaponlist = [23, 5, 7, 9, 10, 11, 12, 13, 14, 17, 21];
                    local weaponlist = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 17, 21];
                    weaponlist.apply(function(id) {
                        removePlayerWeapon( playerid, id );
                    });
                    kick(-1, playerid, "Неправомерное получение оружия.");
                    dbg("chat", "report", getAuthor(playerid), "Кикнут за неправомерное получение оружия.");
                }
            }

        }
    }, 500, -1);
});

event("updateMoveState", function(playerid, state) {
    if (!players.has(playerid)) return;
    if (players[playerid].id in playersInfo) {
        playersInfo[players[playerid].id].state = state;
    }
});

event("onServerPlayerStarted", function(playerid) {
    local charId = getCharacterIdFromPlayerId(playerid);
    playersInfo[charId] <- {};
    playersInfo[charId].state <- null;
    playersInfo[charId].pos <- null;
    playersInfo[charId].counter <- 0;
});

event("onPlayerConnect", function(playerid) {
    local weaponlist = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 17, 21];
    weaponlist.apply(function(id) {
        removePlayerWeapon( playerid, id );
    });
});

// prevent nickname spoofing
event("native:onPlayerChangeNick", function(playerid, newname, oldnickname) {
    dbg("player", "anticheat", "nickchange", getIdentity(playerid));
    kick(-1, playerid, "nick change is not allowed in game.");
});

event("onServerMinuteChange", function() {
    foreach (playerid, value in getPlayers()) {
        if (!strip(getAccountName(playerid)).len()) {
            kick(-1, playerid, "nick change is not allowed in game.");
        }
    }
});

/*
event("onPlayerPlaceEnter", function(playerid, name) {
    if (name != "TestTeleport") {
        return;
    }
    setVehiclePosition(getPlayerVehicle(playerid), -892.147, 605.503, 20.7596);
    setVehicleRotation(getPlayerVehicle(playerid), 89.4356, -1.09522, 0.220736);

});


key("7", function(playerid) {
      maxspeed = 0.0;
});

*/
