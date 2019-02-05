include("modules/shops/cardealer/models/CarDealer.nut");

local coords = [-1586.8, 1694.74, -0.336785, 150.868, 0.000169911, -0.00273992];

local carDealerLoadedData = [];
local availableCars = [0, 1, 4, 6, 7, 8, 9, 10, 12, 13, 14, 15, 17, 18, 22, 23, 25, 28, 29, 30, 31, 32, 41, 43, 44, 45, 46, 47, 48, 50, 52, 53];

local margin_percent = 0.02; // наценка в процентах
local sell_percent = 0.65; // наценка в процентах

event("onServerStarted", function() {
    log("[shops] loading car dealer...");

    // load records (horses and etc.)
    carDealerLoadedDataRead();

    create3DText ( coords[0], coords[1], coords[2]+0.35, "CAR DEALER", CL_ROYALBLUE, 4.0 );
    create3DText ( coords[0], coords[1], coords[2]+0.20, "/dealer", CL_WHITE.applyAlpha(100), 2.0 );

    createBlip  ( -1600.67, 1687.52, [ 25, 0 ], 4000.0 );

    createPlace("CarDealer", -1613.24, 1674.64, -1583.06, 1703.82);
});


event("onServerPlayerStarted", function( playerid ){
    local characterid = players[playerid].id;
    //local temp = clone(carDealerLoadedData);
    foreach (idx, car in carDealerLoadedData) {
        if (car.ownerid == characterid) {
            local vehicleid = getVehicleIdFromEntityId( car.vehicleid );
            local plate   = getVehiclePlateText( vehicleid );
            local modelid = getVehicleModel( vehicleid );
            local modelName = getVehicleNameByModelId( modelid );

            if(car.status == "sale") {
                msg (playerid, "cardealer.onSaleYet", [modelName, plate], CL_SUCCESS);
            }
            if(car.status == "sold_offline") {
                msg (playerid, "cardealer.Sold", [modelName, plate], CL_SUCCESS);
                addMoneyToDeposit(playerid, car.price);
                car.status = "completed";
                car.save();
                //carDealerLoadedData.remove(idx);
            }
        }
    }
    //delete temp;
});


event ( "onPlayerVehicleEnter", function ( playerid, vehicleid, seat ) {
    // if (isPlayerVehicleOwner(playerid, vehicleid)) {
    //     return;
    // }

    local entityid = getVehicleEntityId( vehicleid );

    foreach (idx, car in carDealerLoadedData) {
        if (car.vehicleid == entityid && car.status == "sale") {
            local characterid = players[playerid].id;

            local margin = car.price * margin_percent;

            if (characterid != car.ownerid) {
                return msg(playerid, "cardealer.canBuy", [car.price+margin], CL_FIREBUSH);
            }

            return msg(playerid, "cardealer.canReturn", [margin], CL_FIREBUSH);
        }
    }
});


event("onPlayerPlaceEnter", function(playerid, name) {
    if (isPlayerInVehicle(playerid) && name == "CarDealer") {
        local vehicleid = getPlayerVehicle(playerid);
        setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
        msg(playerid, "cardealer.enterZone");
        msg(playerid, "cardealer.enterZoneMore");
    }
});

cmd("dealer", function(playerid) {
    if (!isPlayerInVehicle(playerid)) return;

    local vehicleid     = getPlayerVehicle( playerid );
    local vehPos        = getVehiclePosition( vehicleid );
    local modelid       = getVehicleModel( vehicleid );
    local entityid      = getVehicleEntityId( vehicleid );

    if(!isInPlace("CarDealer", vehPos[0], vehPos[1])) {
        return msg(playerid, "cardealer.saleAvailable", CL_ERROR);
    }

    if (!isPlayerHaveVehicleKey(playerid, vehicleid)) {
        return msg(playerid, "cardealer.info.no", CL_ERROR);
    }

    local carInfo = getCarInfoModelById(modelid);

    msg(playerid, "cardealer.info.title", CL_HELP_LINE);
    msg(playerid, "cardealer.info.subtitle", CL_HELP);
    msg(playerid, "cardealer.info.way1");
    msg(playerid, "cardealer.info.way2", [ carInfo.price * sell_percent ]);

})

cmd("dealer", "sell", function(playerid, price) {
    if (!isPlayerInVehicle(playerid)) return;

    local vehicleid     = getPlayerVehicle( playerid );
    local entityid      = getVehicleEntityId( vehicleid );
    local vehPos        = getVehiclePosition( vehicleid );
    local modelid       = getVehicleModel( vehicleid );
    local modelName     = getVehicleNameByModelId( modelid );
    local plate         = getVehiclePlateText(vehicleid);
    local characterid   = getCharacterIdFromPlayerId(playerid);


    if (!isInPlace("CarDealer", vehPos[0], vehPos[1])) {
        return msg(playerid, "cardealer.saleAvailable", CL_ERROR);
    }

    local onsale = false;
    local owned  = false;

    if (isPlayerHaveVehicleKey(playerid, vehicleid)) {
        owned = true;
    }

    foreach (idx, carItem in carDealerLoadedData) {
        if (carItem.vehicleid == entityid) {
            if(carItem.status == "sale") {
                onsale = true;
            }
            if (carItem.ownerid == characterid) {
                owned = true;
            }
        }
    }

    if (!owned) { return msg(playerid, "cardealer.notYourCar", CL_ERROR); }

    if (owned && onsale) {
        return msg(playerid, "cardealer.carAlreadyOnSale", CL_ERROR);
    }

    if (!isPlayerHaveValidVehicleTax(playerid, vehicleid, 10)) {
        return msg(playerid, "cardealer.needValidVehicleTax", [ plate, 10 ], CL_ERROR);
    }

    if (availableCars.find(modelid) == null) {
        return;
    }

    if (!price) {
        return msg(playerid, "cardealer.needPrice", CL_ERROR);
    }

    blockVehicle(vehicleid);

    local positionInInventory = -1;
    foreach (idx, item in players[playerid].inventory) {
        if(item._entity == "Item.VehicleKey") {
            if (item.data.id == entityid) {
                positionInInventory = idx;
                break;
            }
        }
    }

    if (positionInInventory >= 0) {

        local item = players[playerid].inventory.remove(positionInInventory);
        players[playerid].inventory.sync();
        item.remove();
        players[playerid].save()
    }

    local carInfo = getCarInfoModelById(modelid);

    local car = CarDealer();

    // put data
    car.vehicleid  = entityid;
    car.status     = "sale";
    car.created    = getTimestamp();

    if (price == "now") {
        local amount = round(carInfo.price * sell_percent, 2);
        addMoneyToPlayer(playerid, amount);
        car.ownerid = 4;
        car.price = round(carInfo.price * 0.85, 2);
        car.until = car.created.tointeger() + 86400;
        msg(playerid, "cardealer.soldNow", [ amount ], CL_SUCCESS);
        dbg("chat", "report", getPlayerName(playerid), format("Продал автомобиль «%s» (%s) за $%.2f", modelName, plate, amount));
    } else {
        car.ownerid = getVehicleOwnerId( vehicleid );
        car.price   = round(fabs(price.tofloat()), 2);
        car.until   = car.created.tointeger() + 14400;
        msg(playerid, "cardealer.onSaleNow", CL_SUCCESS);
        dbg("chat", "report", getPlayerName(playerid), format("Выставил на продажу автомобиль «%s» (%s) за $%.2f", modelName, plate, car.price));
    }
    setVehicleOwner(vehicleid, "[System] CarDealer", 4);
    // insert into database
    car.save();
    carDealerLoadedDataRead();
});


cmd("dealer", "buy", function(playerid) {
    if (!isPlayerInVehicle(playerid)) return;

    local vehicleid     = getPlayerVehicle( playerid );
    local entityid      = getVehicleEntityId( vehicleid );
    local vehPos        = getVehiclePosition( vehicleid );
    local modelid       = getVehicleModel( vehicleid );
    local modelName     = getVehicleNameByModelId( modelid );
    local plate         = getVehiclePlateText( vehicleid );
    local characterid   = players[playerid].id;

    if(!isInPlace("CarDealer", vehPos[0], vehPos[1])) {
        return msg(playerid, "cardealer.buyingAvailable", CL_ERROR);
    }

    local owned  = false;
    local onsale = false;
    local car = null;

    foreach (idx, carItem in carDealerLoadedData) {
        if (carItem.vehicleid == entityid) {
            if(carItem.status == "sale") {
                onsale = true;
                car = carItem;
            }
        }
    }

    if (isPlayerHaveVehicleKey(playerid, vehicleid)) {
        owned = true;
    }

    if (owned) {
        return msg(playerid, "cardealer.thisYourCarAlready", CL_ERROR);
    }

    if(!onsale) { return msg(playerid, "cardealer.notForSale", CL_ERROR); }

    if(!players[playerid].inventory.isFreeSpace(1)) {
        return msg(playerid, "inventory.space.notenough", CL_THUNDERBIRD);
    }

    local vehicleKey = Item.VehicleKey();
    if (!players[playerid].inventory.isFreeWeight(vehicleKey)) {
        return msg(playerid, "inventory.weight.notenough", CL_THUNDERBIRD);
    }

    local margin = car.price * margin_percent;
    local amount = car.price + margin;
    local playeridOldOwner = getPlayerIdFromCharacterId(car.ownerid);


    if(playeridOldOwner >= 0) {

    /* возврат авто + оплата комиссии */
        if(playeridOldOwner == playerid) {
            if(!canMoneyBeSubstracted(playerid, margin)) {
                return msg(playerid, "cardealer.notenoughmoney", CL_ERROR);
            }
            subMoneyToPlayer(playerid, margin);
            //addMoneyToTreasury(margin);
            msg(playeridOldOwner, "cardealer.returnedCar", margin, CL_FIREBUSH);
            car.status = "canceled";
            car.total_price = margin;
            dbg("chat", "report", getPlayerName(playerid), format("Забрал с продажи автомобиль «%s» (%s) за $%.2f", modelName, plate, margin));
        }

    /* покупка авто. продавец онлайн */
        if(playeridOldOwner != playerid) {
            if(!canMoneyBeSubstracted(playerid, amount)) {
                return msg(playerid, "cardealer.notenoughmoney", CL_ERROR);
            }
            subMoneyToPlayer(playerid, amount);
            addMoneyToDeposit(playeridOldOwner, amount);
            msg(playerid, "cardealer.boughtCar", CL_SUCCESS);
            msg(playeridOldOwner, "cardealer.Sold", [modelName, plate], CL_FIREBUSH);
            car.total_price = amount;
            car.status = "sold";
            dbg("chat", "report", getPlayerName(playerid), format("Купил автомобиль «%s» (%s) за $%.2f", modelName, plate, amount));
        }
    }

    /* покупка авто. продавец оффлайн */
    if(playeridOldOwner == -1) {
        if(!canMoneyBeSubstracted(playerid, amount)) {
            return msg(playerid, "cardealer.notenoughmoney", CL_ERROR);
        }
        subMoneyToPlayer(playerid, amount);
        msg(playerid, "cardealer.boughtCar", CL_SUCCESS);
        car.total_price = amount;
        car.status = "sold_offline";
        dbg("chat", "report", getPlayerName(playerid), format("Купил автомобиль «%s» (%s) за $%.2f (offine)", modelName, plate, amount));
    }

    car.save();

    vehicleKey.setData("id", entityid);
    players[playerid].inventory.push( vehicleKey );
    vehicleKey.save();
    players[playerid].inventory.sync();

    carDealerLoadedDataRead();

    setVehicleOwner(vehicleid, playerid);
    __vehicles[vehicleid].entity.save();
    unblockVehicle(vehicleid);

});

function carDealerLoadedDataRead() {
    CarDealer.findAll(function(err, results) {
        carDealerLoadedData = (results.len()) ? results : [];
    });
}

alternativeTranslate({

    "en|cardealer.onSaleYet"              :  "Your car «%s» with plate %s is on sale now."
    "ru|cardealer.onSaleYet"              :  "Ваш автомобиль «%s» (%s) пока ещё не продан."

    "en|cardealer.Sold"                   :  "Your car «%s» with plate %s sold. Money transferred to the bank account."
    "ru|cardealer.Sold"                   :  "Ваш автомобиль «%s» (%s) продан. Деньги переведены на счёт в банк."

    "en|cardealer.soldNow"                :  "You sold you car for $%.2f"
    "ru|cardealer.soldNow"                :  "Вы продали автомобиль за $%.2f"

    "en|cardealer.canBuy"                 :  "You can buy this car for $%.2f via /dealer buy"
    "ru|cardealer.canBuy"                 :  "Вы можете купить этот автомобиль за $%.2f: /dealer buy"

    "en|cardealer.canReturn"              :  "This is your car, but it on sale. You can return it with $%.2f commission via /dealer buy"
    "ru|cardealer.canReturn"              :  "Это ваш автомобиль, но он выставлен на продажу. Вы можете забрать его c комиссией в $%.2f: /dealer buy"

    "en|cardealer.enterZone"              :  "Want to sell car? Park the car neatly."
    "ru|cardealer.enterZone"              :  "Хотите продать автомобиль? Припаркуйтесь аккуратно."

    "en|cardealer.enterZoneMore"          :  "More info: /dealer"
    "ru|cardealer.enterZoneMore"          :  "Подробнее: /dealer"

    "en|cardealer.saleAvailable"          :  "Sale car available only in dealer area."
    "ru|cardealer.saleAvailable"          :  "Выставить автомобиль на продажу можно только на территории дилера."

    "en|cardealer.notYourCar"             :  "This is not your car."
    "ru|cardealer.notYourCar"             :  "Этот автомобиль вам не принадлежит."

    "en|cardealer.carAlreadyOnSale"       :  "This car already on sale."
    "ru|cardealer.carAlreadyOnSale"       :  "Этот автомобиль уже выставлен на продажу."

    "en|cardealer.needValidVehicleTax"    :  "Need valid vehicle tax for car with plate %s minimum for %d days."
    "ru|cardealer.needValidVehicleTax"    :  "Нужна действительная квитанция об оплате налога на автомобиль %s минимум на %d ближайших дней."

    "en|cardealer.needPrice"              :  "You need to set price or sell immediately. More /dealer"
    "ru|cardealer.needPrice"              :  "Необходимо указать цену продажи или продать немедленно. Подробнее /dealer"

    "en|cardealer.onSaleNow"              :  "The car is on sale now."
    "ru|cardealer.onSaleNow"              :  "Вы выставили автомобиль на продажу."

    "en|cardealer.buyingAvailable"        :  "Buying car available only in dealer area."
    "ru|cardealer.buyingAvailable"        :  "Приобрести автомобиль можно только на территории дилера."

    "en|cardealer.thisYourCarAlready"     :  "This is your car already."
    "ru|cardealer.thisYourCarAlready"     :  "Этот автомобиль уже ваш."

    "en|cardealer.notForSale"             :  "This car is not for sale."
    "ru|cardealer.notForSale"             :  "Этот автомобиль не выставлен на продажу."

    "en|cardealer.boughtCar"              :  "You bought this car."
    "ru|cardealer.boughtCar"              :  "Вы приобрели этот автомобиль."

    "en|cardealer.returnedCar"            :  "You returned your car back for $%.2f."
    "ru|cardealer.returnedCar"            :  "Вы забрали автомобиль, заплатив $%.2f."

    "en|cardealer.notenoughmoney"         :   "Not enough money to pay!"
    "ru|cardealer.notenoughmoney"         :   "Увы, у тебя недостаточно денег."

    "en|cardealer.info.no"                :   "No information for this car"
    "ru|cardealer.info.no"                :   "Нет информации по данному автомобилю"


    "en|cardealer.info.title"             :   "================= CAR DEALER =================="
    "ru|cardealer.info.title"             :   "================= АВТОДИЛЕР =================="

    "en|cardealer.info.subtitle"          :   "You can sell your car by two ways:"
    "ru|cardealer.info.subtitle"          :   "Вы можете продать автомобиль двумя способами:"

    "en|cardealer.info.way1"              :   "1. Set price and await a customer: /dealer sell 100, where 100 is price"
    "ru|cardealer.info.way1"              :   "1. Указать цену и ждать: /dealer sell 100, где 100 - цена в $"

    "en|cardealer.info.way2"              :   "2. Sell now for $%.2f: /dealer sell now"
    "ru|cardealer.info.way2"              :   "2. Продать сейчас же за $%.2f: /dealer sell now"

});
