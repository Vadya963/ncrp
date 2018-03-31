translation("en", {
"job.porter"                    : "station porter"
"job.porter.letsgo"             : "[PORTER] Go inside to Dipton Train Station."
"job.porter.already"            : "[PORTER] You're station porter already."
"job.porter.now"                : "[PORTER] You're a station porter now. Welcome!"
"job.porter.takeboxandcarry"    : "[PORTER] Take a box and carry it to the railway carriage."
"job.porter.not"                : "[PORTER] You're not a station porter."
"job.porter.takebox"            : "[PORTER] Go and take a box."
"job.porter.havebox"            : "[PORTER] You have a box already."
"job.porter.tookbox"            : "[PORTER] You took the box. Go to the railway carriage."
"job.porter.haventbox"          : "[PORTER] You haven't a box."
"job.porter.gotowarehouse"      : "[PORTER] Go to the railway carriage."
"job.porter.nicejob"            : "[PORTER] You put the box. You earned $%.2f."

"job.porter.help.title"         : "List of available commands for STATION PORTER JOB:"
"job.porter.help.job"           : "Get station porter job"
"job.porter.help.jobleave"      : "Leave station porter job"
"job.porter.help.take"          : "Take a box"
"job.porter.help.put"           : "Put box to the railway carriage"
});


include("modules/jobs/stationporter/commands.nut");

local job_porter = {};

const PORTER_RADIUS = 4.0;
const PORTER_JOB_X = -583.78; //Dipton Station Inside
const PORTER_JOB_Y = 1620.02; //Dipton Station Inside
const PORTER_JOB_Z = -15.6957; //Dipton Station Inside

const PORTER_JOB_TAKEBOX_X = -658.107;
const PORTER_JOB_TAKEBOX_Y = 1722.11;
const PORTER_JOB_TAKEBOX_Z = -23.2408;
/*
const PORTER_JOB_TAKEBOX_X = -645.541;
const PORTER_JOB_TAKEBOX_Y = 1626.6;
const PORTER_JOB_TAKEBOX_Z = -23.2145;
*/
const PORTER_JOB_PUTBOX_X = -632.416;
const PORTER_JOB_PUTBOX_Y = 1645.35;
const PORTER_JOB_PUTBOX_Z = -23.2408;
const PORTER_JOB_SKIN = 131;
const PORTER_SALARY = 0.30;
      PORTER_JOB_COLOR <- CL_CRUSTA;
local PORTER_JOB_GET_HOUR_START = 6;
local PORTER_JOB_GET_HOUR_END   = 18;
local PORTER_JOB_LEAVE_HOUR_START = 6;
local PORTER_JOB_LEAVE_HOUR_END   = 18;
local PORTER_JOB_WORKING_HOUR_START = 6;
local PORTER_JOB_WORKING_HOUR_END   = 18;
local PORTER_BOX_IN_HOUR = 35;
local PORTER_BOX_NOW = 29;


event("onServerStarted", function() {
    log("[jobs] loading porter job...");

    registerPersonalJobBlip("porter", PORTER_JOB_X, PORTER_JOB_Y);

});

event("onPlayerConnect", function(playerid) {
    job_porter[getCharacterIdFromPlayerId(playerid)] <- {};
    job_porter[getCharacterIdFromPlayerId(playerid)]["havebox"] <- false;
    job_porter[getCharacterIdFromPlayerId(playerid)]["blip3dtext"] <- [null, null, null];
    job_porter[getCharacterIdFromPlayerId(playerid)]["moveState"] <- null;
    job_porter[getCharacterIdFromPlayerId(playerid)]["press3Dtext"] <- null;
});

event("onServerPlayerStarted", function( playerid ) {

    //creating 3dtext for bus depot
    create3DText ( PORTER_JOB_X, PORTER_JOB_Y, PORTER_JOB_Z+0.35, plocalize(playerid, "3dtext.job.porter"), CL_ROYALBLUE );

    if(players[playerid]["job"] == "porter") {
        job_porter[getCharacterIdFromPlayerId(playerid)]["blip3dtext"] = porterJobCreatePrivateBlipText(playerid, PORTER_JOB_TAKEBOX_X, PORTER_JOB_TAKEBOX_Y, PORTER_JOB_TAKEBOX_Z, plocalize(playerid, "TAKEBOXHERE"), plocalize(playerid, "3dtext.job.press.E"));
        job_porter[getCharacterIdFromPlayerId(playerid)]["press3Dtext"] = createPrivate3DText (playerid, PORTER_JOB_X, PORTER_JOB_Y, PORTER_JOB_Z+0.20, plocalize(playerid, "3dtext.job.press.leave"), CL_WHITE.applyAlpha(100), 3.0 );
    } else {
        job_porter[getCharacterIdFromPlayerId(playerid)]["press3Dtext"] = createPrivate3DText (playerid, PORTER_JOB_X, PORTER_JOB_Y, PORTER_JOB_Z+0.20, plocalize(playerid, "3dtext.job.press.getjob"), CL_WHITE.applyAlpha(100), 3.0 );
    }
});

event("onServerHourChange", function() {
    PORTER_BOX_NOW = PORTER_BOX_IN_HOUR + random(-11, 12);
});

/**
 * Create private 3DTEXT AND BLIP
 * @param  {int}  playerid
 * @param  {float} x
 * @param  {float} y
 * @param  {float} z
 * @param  {string} text
 * @param  {string} cmd
 * @return {array} [idtext1, id3dtext2, idblip]
 */
function porterJobCreatePrivateBlipText(playerid, x, y, z, text, cmd) {
    return [
            createPrivate3DText (playerid, x, y, z+0.35, text, CL_RIPELEMON, 30 ),
            createPrivate3DText (playerid, x, y, z+0.20, cmd, CL_WHITE.applyAlpha(150), PORTER_RADIUS ),
            createPrivateBlip (playerid, x, y, ICON_YELLOW, 300.0)
    ];
}

/**
 * Remove private 3DTEXT AND BLIP
 * @param  {int}  playerid
 */
function porterJobRemovePrivateBlipText ( playerid ) {
    if(job_porter[getCharacterIdFromPlayerId(playerid)]["blip3dtext"][0] != null) {
        remove3DText ( job_porter[getCharacterIdFromPlayerId(playerid)]["blip3dtext"][0] );
        remove3DText ( job_porter[getCharacterIdFromPlayerId(playerid)]["blip3dtext"][1] );
        removeBlip   ( job_porter[getCharacterIdFromPlayerId(playerid)]["blip3dtext"][2] );
    }
}


/**
 * Check is player is a porter
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPorter(playerid) {
    return (isPlayerHaveValidJob(playerid, "porter"));
}


/**
 * Check is porter have box
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPorterHaveBox(playerid) {
    return job_porter[getCharacterIdFromPlayerId(playerid)]["havebox"];
}


function porterJob( playerid ) {

    if(!isPlayerInValidPoint(playerid, PORTER_JOB_X, PORTER_JOB_Y, PORTER_RADIUS)) {
        return;
    }

    if(isPorter( playerid )) {
        return msg( playerid, "job.porter.already", PORTER_JOB_COLOR );
    }

    local hour = getHour();
    if(hour < PORTER_JOB_GET_HOUR_START || hour >= PORTER_JOB_GET_HOUR_END) {
        return msg( playerid, "job.closed", [ PORTER_JOB_GET_HOUR_START.tostring(), PORTER_JOB_GET_HOUR_END.tostring()], PORTER_JOB_COLOR );
    }

    if(isPlayerHaveJob(playerid)) {
        return msg( playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid), PORTER_JOB_COLOR );
    }

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg( playerid, "job.porter.now", PORTER_JOB_COLOR );
        msg( playerid, "job.porter.takeboxandcarry", PORTER_JOB_COLOR );

        setPlayerJob( playerid, "porter");
        setPlayerModel( playerid, PORTER_JOB_SKIN );

        // create private blip job
        // createPersonalJobBlip( playerid, PORTER_JOB_X, PORTER_JOB_Y);

        remove3DText(job_porter[getCharacterIdFromPlayerId(playerid)]["press3Dtext"]);
        job_porter[getCharacterIdFromPlayerId(playerid)]["press3Dtext"] = createPrivate3DText (playerid, PORTER_JOB_X, PORTER_JOB_Y, PORTER_JOB_Z+0.20, plocalize(playerid, "3dtext.job.press.leave"), CL_WHITE.applyAlpha(100), 3.0 );
        job_porter[getCharacterIdFromPlayerId(playerid)]["blip3dtext"] = porterJobCreatePrivateBlipText(playerid, PORTER_JOB_TAKEBOX_X, PORTER_JOB_TAKEBOX_Y, PORTER_JOB_TAKEBOX_Z, plocalize(playerid, "TAKEBOXHERE"), plocalize(playerid, "3dtext.job.press.E"));

    });
}

// working good, check
function porterJobLeave( playerid ) {

    if(!isPlayerInValidPoint(playerid, PORTER_JOB_X, PORTER_JOB_Y, PORTER_RADIUS)) {
        return;
        // msg( playerid, "job.porter.letsgo", PORTER_JOB_COLOR );
    }

    if(!isPorter( playerid )) {
        return msg( playerid, "job.porter.not", PORTER_JOB_COLOR );
    }

    local hour = getHour();
    if(hour < PORTER_JOB_LEAVE_HOUR_START || hour >= PORTER_JOB_LEAVE_HOUR_END) {
        return msg( playerid, "job.closed", [ PORTER_JOB_LEAVE_HOUR_START.tostring(), PORTER_JOB_LEAVE_HOUR_END.tostring()], PORTER_JOB_COLOR );
    }

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg( playerid, "job.leave", PORTER_JOB_COLOR );

        setPlayerJob( playerid, null );
        restorePlayerModel(playerid);

        job_porter[getCharacterIdFromPlayerId(playerid)]["havebox"] = false;

        //setPlayerAnimStyle(playerid, "common", "default");
        //setPlayerHandModel(playerid, 1, 0);

        // remove private blip job
        removePersonalJobBlip ( playerid );

        porterJobRemovePrivateBlipText ( playerid );

        remove3DText(job_porter[getCharacterIdFromPlayerId(playerid)]["press3Dtext"]);
        job_porter[getCharacterIdFromPlayerId(playerid)]["press3Dtext"] = createPrivate3DText (playerid, PORTER_JOB_X, PORTER_JOB_Y, PORTER_JOB_Z+0.20, plocalize(playerid, "3dtext.job.press.getjob"), CL_WHITE.applyAlpha(100), 3.0 );

    });
}

// working good, check
function porterJobTakeBox( playerid ) {
    if(!isPorter( playerid )) {
        return msg( playerid, "job.porter.not", PORTER_JOB_COLOR );
    }

    if(!isPlayerInValidPoint(playerid, PORTER_JOB_TAKEBOX_X , PORTER_JOB_TAKEBOX_Y, PORTER_RADIUS)) {
        return;
    }

    if (isPorterHaveBox(playerid)) {
        return msg( playerid, "job.porter.havebox", PORTER_JOB_COLOR );
    }

    local hour = getHour();
    if(hour < PORTER_JOB_WORKING_HOUR_START || hour >= PORTER_JOB_WORKING_HOUR_END) {
        return msg( playerid, "job.closed", [ PORTER_JOB_WORKING_HOUR_START.tostring(), PORTER_JOB_WORKING_HOUR_END.tostring()], PORTER_JOB_COLOR );
    }

    if(PORTER_BOX_NOW < 1) {
        return msg( playerid, "job.nojob", PORTER_JOB_COLOR );
    }

    if (job_porter[getCharacterIdFromPlayerId(playerid)]["moveState"] == 1 || job_porter[getCharacterIdFromPlayerId(playerid)]["moveState"] == 2){
        return  msg( playerid, "job.porter.presscapslock" );
    }

    porterJobRemovePrivateBlipText ( playerid );

    job_porter[getCharacterIdFromPlayerId(playerid)]["havebox"] = true;

    //setPlayerAnimStyle(playerid, "common", "CarryBox");
    //setPlayerHandModel(playerid, 1, 98); // put box in hands
    msg( playerid, "job.porter.tookbox", PORTER_JOB_COLOR );

    job_porter[getCharacterIdFromPlayerId(playerid)]["blip3dtext"] = porterJobCreatePrivateBlipText(playerid, PORTER_JOB_PUTBOX_X, PORTER_JOB_PUTBOX_Y, PORTER_JOB_PUTBOX_Z, plocalize(playerid, "PUTBOXHERE"), plocalize(playerid, "3dtext.job.press.E"));
    //delayedFunction(250, function () { setPlayerAnimStyle(playerid, "common", "CarryBox"); });
    //delayedFunction(500, function () { setPlayerAnimStyle(playerid, "common", "CarryBox"); });
    //delayedFunction(750, function () { setPlayerAnimStyle(playerid, "common", "CarryBox"); });
    //delayedFunction(1000, function () { setPlayerAnimStyle(playerid, "common", "CarryBox"); });
}

// working good, check
function porterJobPutBox( playerid ) {
    if(!isPorter( playerid )) {
        return msg( playerid, "job.porter.not", PORTER_JOB_COLOR );
    }

    if (!isPorterHaveBox(playerid)) {
        return msg( playerid, "job.porter.haventbox", PORTER_JOB_COLOR );
    }

    if(!isPlayerInValidPoint(playerid, PORTER_JOB_PUTBOX_X, PORTER_JOB_PUTBOX_Y, PORTER_RADIUS)) {
        return msg( playerid, "job.porter.gotowarehouse", PORTER_JOB_COLOR );
    }

    //setPlayerAnimStyle(playerid, "common", "default");
    //setPlayerHandModel(playerid, 1, 0);

    porterJobRemovePrivateBlipText ( playerid );

    job_porter[getCharacterIdFromPlayerId(playerid)]["havebox"] = false;
    local amount = PORTER_SALARY + round(getSalaryBonus() / 100, 2);
    msg( playerid, "job.porter.nicejob", amount, PORTER_JOB_COLOR );
    addMoneyToPlayer(playerid, amount);

    job_porter[getCharacterIdFromPlayerId(playerid)]["blip3dtext"] = porterJobCreatePrivateBlipText(playerid, PORTER_JOB_TAKEBOX_X, PORTER_JOB_TAKEBOX_Y, PORTER_JOB_TAKEBOX_Z, plocalize(playerid, "TAKEBOXHERE"), plocalize(playerid, "3dtext.job.press.E"));
    //delayedFunction(250, function () { setPlayerAnimStyle(playerid, "common", "default"); });
    //delayedFunction(500, function () { setPlayerAnimStyle(playerid, "common", "default"); });
    //delayedFunction(750, function () { setPlayerAnimStyle(playerid, "common", "default"); });
    //delayedFunction(1000, function () { setPlayerAnimStyle(playerid, "common", "default"); });
}

/*
event("updateMoveState", function(playerid, state) {
    job_porter[getCharacterIdFromPlayerId(playerid)]["moveState"] = state;
    if(isPorter( playerid ) && isPorterHaveBox(playerid)) {
        if(state == 1 || state == 2) {
            setPlayerAnimStyle(playerid, "common", "default");
            setPlayerHandModel(playerid, 1, 0);


            porterJobRemovePrivateBlipText ( playerid );

            job_porter[getCharacterIdFromPlayerId(playerid)]["havebox"] = false;
            msg( playerid, "job.porter.dropped", PORTER_JOB_COLOR );
            msg( playerid, "job.porter.presscapslock" )
            job_porter[getCharacterIdFromPlayerId(playerid)]["blip3dtext"] = porterJobCreatePrivateBlipText(playerid, PORTER_JOB_TAKEBOX_X, PORTER_JOB_TAKEBOX_Y, PORTER_JOB_TAKEBOX_Z, "TAKE BOX HERE", "press E");
            delayedFunction(250, function () { setPlayerAnimStyle(playerid, "common", "default"); });
            delayedFunction(500, function () { setPlayerAnimStyle(playerid, "common", "default"); });
            delayedFunction(750, function () { setPlayerAnimStyle(playerid, "common", "default"); });
            delayedFunction(1000, function () { setPlayerAnimStyle(playerid, "common", "default"); });
        }
    }
});
*/
