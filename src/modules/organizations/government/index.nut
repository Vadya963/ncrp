// nothing there yet :p
local coords = [-122.331, -62.9116, -12.041];
local tax_fixprice = 20.0;
local tax = 0.05;  // 2 percents

event("onServerStarted", function() {
    log("[organizations] government...");

    create3DText ( coords[0], coords[1], coords[2]+0.35, "SECRETARY OF GOVERNMENT", CL_ROYALBLUE);
    create3DText ( coords[0], coords[1], coords[2]+0.20, "/tax", CL_WHITE.applyAlpha(100), 2.0 );

    createBlip  ( coords[0], coords[1], [ 24, 0 ], 4000.0 );

});


alternativeTranslate({

    "en|tax.help.title"  : "Tax for vehicle:"
    "ru|tax.help.title"  : "Налог на автомобиль:"

    "en|tax.help.tax"    : "/tax  PlateNumber"
    "ru|tax.help.tax"    : "/tax  НомерАвтомобиля"

    "en|tax.help.desc"   : "Pay tax"
    "ru|tax.help.desc"   : "Оплатить налог"

    "en|tax.toofar"      : "You can pay tax at city government."
    "ru|tax.toofar"      : "Оплатить налог можно в мэрии города."

    "en|tax.toofar"      : "This car can't registered."
    "ru|tax.toofar"      : "Оплатить налог можно в мэрии города."

    "en|tax.notrequired" : "This car not required to tax."
    "ru|tax.notrequired" : "Указанный автомобиль не облагается налогом."

    "en|tax.payed"       : "You payed tax $%.2f for vehicle with plate %s."
    "ru|tax.payed"       : "Вы оплатили налог $%.2f за автомобиль с номером %s."

    "en|tax.money.notenough"  : "Not enough money. Need $%.2f."
    "ru|tax.money.notenough"  : "Недостаточно денег. Для оплаты требуется $%.2f."

    "en|tax.info.title"       : "Information about tax for vehicle:"
    "ru|tax.info.title"       : "Информация об оплате налога на автомобиль:"

    "en|tax.info.plate"       : "Plate: %s"
    "ru|tax.info.plate"       : "Номер: %s"

    "en|tax.info.model"       : "Model: %s"
    "ru|tax.info.model"       : "Модель: %s"

    "en|tax.info.issued"      : "Issued: %s"
    "ru|tax.info.issued"      : "Выдан: %s"

    "en|tax.info.expires"     : "Expires: %s"
    "ru|tax.info.expires"     : "Истекает: %s"

});

function taxHelp( playerid ) {
    local title = "tax.help.title";
    local commands = [
        { name = "tax.help.tax",    desc = "tax.help.desc" }
    ];
    msg_help(playerid, title, commands);
}


cmd("tax", function( playerid, plateText = 0 ) {

    if (plateText == 0) {
        return taxHelp( playerid );
    }

    if (!isPlayerInValidPoint(playerid, coords[0], coords[1], 1.0 )) {
        return msg(playerid, "tax.toofar", [], CL_THUNDERBIRD);
    }

    if(!players[playerid].inventory.isFreeSpace(1)) {
        return msg(playerid, "inventory.space.notenough", CL_THUNDERBIRD);
    }

    local taxObj = Item.VehicleTax();
    if (!players[playerid].inventory.isFreeWeight(taxObj)) {
        return msg(playerid, "inventory.weight.notenough", CL_THUNDERBIRD);
    }

    local plateText = plateText.toupper();
    local vehicleid = getVehicleByPlateText(plateText.toupper());
    if(vehicleid == null) {
        return msg( playerid, "parking.checkPlate");
    }

    local modelid = getVehicleModel( vehicleid );
    local carInfo = getCarInfoModelById( modelid );

    if (carInfo == null || isVehicleCarRent(vehicleid)) {
        return msg(playerid, "tax.notrequired");
    }

    local price = tax_fixprice + carInfo.price * tax;
    if (!canMoneyBeSubstracted(playerid, price)) {
        return msg(playerid, "tax.money.notenough", [ price ], CL_THUNDERBIRD);
    }

    msg(playerid, "tax.payed", [ price, plateText ], CL_SUCCESS);
    subMoneyToPlayer(playerid, price);

    taxObj.setData("plate", plateText);
    taxObj.setData("model",  modelid );

    local day   = getDay();
    local month = getMonth() + 1;
    local year  = getYear();
    if (month == 13) { month = 1; year += 1; }
    if (day < 10)   { day = "0"+day; }
    if (month < 10) { month = "0"+month; }
    taxObj.setData("issued",  getDate());
    taxObj.setData("expires", day+"."+month+"."+year);

    players[playerid].inventory.push( taxObj );
    taxObj.save();
    players[playerid].inventory.sync();

});


