include("controllers/chat/functions.nut");
include("controllers/chat/commands.nut");

translation("en", {
    "general.message.empty"         : "[INFO] You cant send an empty message",
    "general.noonearound"           : "There's noone around near you.",

    "chat.player.says"              : "%s says: %s",
    "chat.player.shout"             : "%s shout: %s",
    "chat.player.whisper"           : "%s whisper: %s",
    "chat.player.try.body"          : "[TRY] %s try %s",
    "chat.player.try.end.success"   : "%s (success).",
    "chat.player.try.end.fail"      : "%s (failed)."

    "chat.idea.success"             : "[IDEA] Your idea has been successfuly submitted!"
    "chat.report.success"           : "[REPORT] Your report has been successfuly submitted!"
    "chat.report.noplayer"          : "[REPORT] You can't report about player, which is not connected!"
    "chat.report.error"             : "[REPORT] You should provide report in a following format: /report ID TEXT"
});

translation("ru", {
    "general.message.empty"         : "[INFO] Вы не можете отправить пустую строку",
    "general.noonearound"           : "Рядом с вами никого нет.",

    "chat.player.says"              : "%s сказал: %s",
    "chat.player.shout"             : "%s крикнул: %s",
    "chat.player.whisper"           : "%s шепчет: %s",
    "chat.player.try.body"          : "[TRY] %s попытался %s",
    "chat.player.try.end.success"   : "%s (успех).",
    "chat.player.try.end.fail"      : "%s (провал)."
});

// settings
const NORMAL_RADIUS = 20.0;
const WHISPER_RADIUS = 4.0;
const SHOUT_RADIUS = 35.0;

// event handlers
event("native:onPlayerChat", function(playerid, message) {
    if (!isPlayerLogined(playerid)) {
        return false;
    }

    // inRadiusSendToAll(playerid, 
    //     localize("chat.player.says", [getAuthor( playerid ), message], getPlayerLocale(playerid)), 
    //     NORMAL_RADIUS, CL_YELLOW);
    __commands["say"][COMMANDS_DEFAULT](playerid, message);
    return false;
});
