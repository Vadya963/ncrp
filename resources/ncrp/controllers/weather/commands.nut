acmd("weather", function(playerid, weatherId) {
    if (setCurrentWeather(weatherId.tointeger())) {
        return sendPlayerMessage(playerid, "You've successfully changed the weather");
    }
});

acmd("weatherCustom", function(playerid, weather) {
    triggerClientEvent(playerid, "onServerWeatherSync", weather);
});


acmd("season", function(playerid, season) {
    if (season == "s" || season == "summer") {
        return setSummer(true);
    }

    if (season == "w" || season == "winter") {
        return setSummer(false);
    }
});
