acmd(["spawn"], function(playerid) {
    setPlayerPosition( playerid, -1551.560181, -169.915466, -19.672523 );
    setPlayerHealth( playerid, 720.0 );
});

acmd(["weapons"], function(playerid) {
    if(!isPlayerAdmin(playerid)) {
        return msg(playerid, "msg.weapons");
    }
    givePlayerWeapon( playerid, 2, 2500 );
    givePlayerWeapon( playerid, 3, 2500 );
    givePlayerWeapon( playerid, 4, 2500 );
    givePlayerWeapon( playerid, 5, 2500 );
    givePlayerWeapon( playerid, 6, 2500 );
    givePlayerWeapon( playerid, 8, 2500 );
    givePlayerWeapon( playerid, 9, 2500 );
    givePlayerWeapon( playerid, 10, 2500 );
    givePlayerWeapon( playerid, 11, 2500 );
    givePlayerWeapon( playerid, 13, 2500 );
    givePlayerWeapon( playerid, 15, 2500 );
    givePlayerWeapon( playerid, 17, 2500 );
    //player:InventoryAddItem(36) -- отмычки
});

acmd(["aheal"], function( playerid, targetid = null ) {
    if(!targetid) targetid = playerid;
    setPlayerHealth( targetid.tointeger(), 720.0 );
});

acmd(["die"], function( playerid, targetid = null ) {
    if(!targetid) targetid = playerid;
    setPlayerHealth( targetid.tointeger(), 0.0 );
});

// acmd("skin", function(playerid, id, targetid = null ) {
//     if(!targetid) targetid = playerid;
//     setPlayerModel(targetid.tointeger(), id.tointeger(), true);
// });

acmd(["skininc"], function ( playerid ) {
    local skin = getPlayerModel(playerid);
    if ( skin < 171) {
        skin += 1;
        setPlayerModel(playerid, skin, true);
        msg( playerid,  "Skin model changed on " + skin );
    } else {
        msg( playerid,  "Skin top limit" );
    }
});

acmd(["skindec"], function ( playerid ) {
    local skin = getPlayerModel(playerid);
    if ( skin > 0) {
        skin -= 1;
        setPlayerModel(playerid, skin, true);
        msg( playerid,  "Skin model changed on " + skin );
    } else {
        msg( playerid,  "Skin lower limit" );
    }
});

cmd("checkmyjob", function ( playerid ) {
    local job = getPlayerJob(playerid);
    if(job) {
        msg( playerid, "job.checkmyjob", getLocalizedPlayerJob(playerid) );
    } else {
        msg( playerid, "job.unemployed" );
    }
});

cmd(["clearchat"], function(playerid) {
    for(local i = 0; i <15;i++){
        sendPlayerMessage(playerid,"")
    }
});

acmd(["clearchatall"], function(playerid) {
    foreach (idx, value in players) {
        if (getPlayerOOC(idx)) {
            for(local i = 0; i <15;i++){
                sendPlayerMessage(idx,"");
            }
        }
    }
});


acmd(["firstname"], function(playerid, targetid = null, newname = null) {

    if (targetid == null || !isPlayerConnected(targetid.tointeger())) {
        return msg(playerid, "ID игрока не указан! Формат: /firstname id имя", CL_ERROR);
    }

    if (newname == null || newname.len() == 0) {
        return msg(playerid, "Новое имя персонажа не указано! Формат: /firstname id имя", CL_ERROR);
    }

    targetid = targetid.tointeger();

    players[targetid].firstname = newname;
    msg(playerid, format("Имя персонажа для игрока с ID %d изменено на %s.", targetid, newname), CL_SUCCESS);

});

acmd(["lastname"], function(playerid, targetid = null, newname = null) {

    if (targetid == null || !isPlayerConnected(targetid.tointeger())) {
        return msg(playerid, "ID игрока не указан! Формат: /lastname id фамилия", CL_ERROR);
    }

    if (newname == null || newname.len() == 0) {
        return msg(playerid, "Новая фамилия персонажа не указана! Формат: /lastname id фамилия", CL_ERROR);
    }

    targetid = targetid.tointeger();

    players[targetid].lastname = newname;
    msg(playerid, format("Фамилия персонажа для игрока с ID %d изменена на %s.", targetid, newname), CL_SUCCESS);

});
