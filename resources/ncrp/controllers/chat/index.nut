/**
 * Chat module
 * Auther: LoOnyRider & Inlife 
 * Date: nov 2016
 */
const NORMAL_RADIUS = 20.0;
const SHOUT_RADIUS = 35.0;

function chatcmd(names, callback)  {
    cmd(names, function(playerid, ...) {
        local text = concat(vargv);

        if (!text || text.len() < 1) {
            return msg(playerid, "[INFO] You cant send an empty message.", CL_YELLOW);
        }

        // call registered callback
        return callback(playerid, text);
    });
}


function msg(playerid, text, color = CL_WHITE ) {
	sendPlayerMessage(playerid, text, color.r, color.g, color.b);
}

function msg_a(text, color = CL_WHITE){
	sendPlayerMessageToAll(text, color.r, color.g, color.b);
}

include("controllers/chat/commands.nut");