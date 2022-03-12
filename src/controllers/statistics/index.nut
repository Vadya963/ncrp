const STATISICS_ENABLED = false;

function statisticsPushObject(object, type, additional = "") {
    // create object
    local entity = StatisticPoint();

    // set values
    entity.x = object.x;
    entity.y = object.y;
    entity.z = object.z;
    entity.type = type;
    entity.created = getDateTime();
    entity.additional = additional;

    // save it to db
    entity.save();
    entity.clean();
    return true;
}

function statisticsPushText(type, playerid, content, additional = "") {
    // create object
    local entity = StatisticText();
    local object = getPlayerPositionObj(playerid);

    // set values
    entity.type    = type;
    entity.author  = getIdentity(playerid);
    entity.content = content;
    entity.created = getDateTime();
    entity.additional = additional;

    entity.x = object.x;
    entity.y = object.y;
    entity.z = object.z;

    // save it to db
    entity.save();
    entity.clean();
    return true;
}

function statisticsPushMessage(playerid, message, type = "") {
    // special handling for gamechat
    if (type == "ooc_") {
        nano({
            "path": "discord-gamechat",
            "server": "ncrp",
            "channel": "gamechat",
            "name": getPlayerName(playerid),
            "msg": message,
        })
    } else {
        dbg("ncrp", "console", getIdentity(playerid), message);
    }

    return statisticsPushText("message", playerid, message, type);
}

function statisticsPushCommand(playerid, command, result = "") {
    //dbg("command", getIdentity(playerid), command, result);
    statisticsPushText("command", playerid, command, result);
    return;
}

function statisticsPushPlayers() {
    local amount = 0;

    playerList.each(function(playerid) {
        local additional = isPlayerInVehicle(playerid) ? "invehicle" : "onfoot";
        statisticsPushObject( getPlayerPositionObj(playerid), "player",  additional);
        amount++;
    });

    return amount;
}

function statisticsPushVehicles() {
    local amount = 0;

    foreach (vehicleid in getCustomPlayerVehicles()) {
        local additional = isVehicleEmpty(vehicleid) ? "empty" : "driven";
        statisticsPushObject( getVehiclePositionObj(vehicleid), "vehicle", additional );
        amount++;
    }

    return amount;
}

event("onServerAutosave", function() {
    if (!STATISICS_ENABLED) {
        return;
    }

    local amount = 0;
    amount += statisticsPushPlayers();
    amount += statisticsPushVehicles();
    // logStr("[stats] collected info #" + amount + " records");
});
