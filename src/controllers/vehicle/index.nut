const VEHICLE_RESPAWN_TIME      = 300; // 5 (real) minutes
const VEHICLE_FUEL_DEFAULT      = 40.0;
const VEHICLE_MIN_DIRT          = 0.25;
const VEHICLE_MAX_DIRT          = 0.75;
const VEHICLE_DEFAULT_OWNER     = "";
const VEHICLE_OWNERSHIP_NONE    = 0;
const VEHICLE_OWNERSHIP_SINGLE  = 1;
const VEHICLE_OWNER_CITY        = "__cityNCRP";

translate("en", {
    "vehicle.sell.amount"       : "You need to set the amount you wish to sell your car for."
    "vehicle.sell.2passangers"  : "You need potential buyer to sit in the vehicle with you."
    "vehicle.sell.ask"          : "%s offers you to buy his vehicle for $%.2f."
    "vehicle.sell.log"          : "You offered %s to buy your vehicle for $%.2f."
    "vehicle.sell.success"      : "You've successfuly sold this car."
    "vehicle.buy.success"       : "You've successfuly bought this car."
    "vehicle.sell.failure"      : "%s refused to buy this car."
    "vehicle.buy.failure"       : "You refused to buy this car."
    "vehicle.sell.notowner"     : "You can't sell car tht doesn't belong to you."
});

event("onScriptInit", function() {
    // police cars
    addVehicleOverride(42, function(id) {
        setVehicleColour(id, 255, 255, 255, 0, 0, 0);
        setVehicleSirenState(id, false);
        // setVehicleBeaconLight(id, false);
        setVehiclePlateText(id, getRandomVehiclePlate("PD"));
    });

    addVehicleOverride(51, function(id) {
        setVehicleColour(id, 0, 0, 0, 150, 150, 150);
        setVehicleSirenState(id, false);
        // setVehicleBeaconLight(id, false);
        // added override for plate number
        setVehiclePlateText(id, getRandomVehiclePlate("PD"));
    });

    // trucks
    addVehicleOverride(range(34, 39), function(id) {
        setVehicleColour(id, 30, 30, 30, 154, 154, 154);
    });

    // trucks fish
    addVehicleOverride(38, function(id) {
        setVehicleColour(id, 15, 32, 24, 80, 80, 80);
    });

    // armoured lassiter 75
    addVehicleOverride(17, function(id) {
        setVehicleColour(id, 0, 0, 0, 0, 0, 0);
    });

    // milk
    addVehicleOverride(19, function(id) {
        setVehicleColour(id, 154, 154, 154, 98, 26, 21);
    });
});

// binding events
event("onServerStarted", function() {
    log("[vehicles] starting...");
    local counter = 0;

    // load all vehicles from db
    Vehicle.findBy({ reserved = 0 }, function(err, results) {
        foreach (idx, vehicle in results) {

            // create vehicle
            local vehicleid = createVehicle( vehicle.model, vehicle.x, vehicle.y, vehicle.z, vehicle.rx, vehicle.ry, vehicle.rz );

            // load all the data
            setVehicleColour      ( vehicleid, vehicle.cra, vehicle.cga, vehicle.cba, vehicle.crb, vehicle.cgb, vehicle.cbb );
            setVehicleRotation    ( vehicleid, vehicle.rx, vehicle.ry, vehicle.rz );
            setVehicleTuningTable ( vehicleid, vehicle.tunetable );
            setVehicleDirtLevel   ( vehicleid, vehicle.dirtlevel );
            setVehicleFuel        ( vehicleid, vehicle.fuellevel );
            setVehiclePlateText   ( vehicleid, vehicle.plate );
            setVehicleOwner       ( vehicleid, vehicle.owner, vehicle.ownerid );

            // secial methods for custom vehicles
            setVehicleRespawnEx   ( vehicleid, false );
            setVehicleSaving      ( vehicleid, true );
            setVehicleEntity      ( vehicleid, vehicle );
            setVehicleData        ( vehicleid, vehicle.data );

            // block vehicle by default
            blockVehicle          ( vehicleid );

            local setWheelsGenerator = function(id, entity) {
                return function() {
                    setVehicleWheelTexture( id, 0, entity.fwheel );
                    setVehicleWheelTexture( id, 1, entity.rwheel );
                };
            };

            delayedFunction(1000, setWheelsGenerator(vehicleid, vehicle));
            counter++;
        }

        log("[vehicles] loaded " + counter + " vehicles from database.");
    });
});

// respawn cars and update passangers
event("onServerMinuteChange", function() {
    updateVehiclePassengers();
    checkVehicleRespawns();
});

// handle vehicle enter
event("native:onPlayerVehicleEnter", function(playerid, vehicleid, seat) {
    logger.logf(
        "[VEHICLE ENTER] (%s) %s (playerid: %d) | (vehid: %d) %s - %s (model: %d) | coords: [%.5f, %.5f, %.5f] | haveKey: %s",
            getAccountName(playerid),
            getPlayerName(playerid),
            playerid,
            vehicleid,
            getVehiclePlateText(vehicleid),
            getVehicleNameByModelId(getVehicleModel(vehicleid)),
            getVehicleModel(vehicleid),
            getVehiclePositionObj(vehicleid).x,
            getVehiclePositionObj(vehicleid).y,
            getVehiclePositionObj(vehicleid).z,
            isVehicleOwned(vehicleid) ? (isPlayerHaveVehicleKey(playerid, vehicleid) ? "true" : "false") : "city_ncrp"
    );

    if(!("seatPos" in __vehicles[vehicleid])) {
        __vehicles[vehicleid].seatPos <- [];
    }

    __vehicles[vehicleid].seatPos <- getVehiclePosition( vehicleid );


    // handle vehicle passangers
    addVehiclePassenger(vehicleid, playerid, seat);

    if (seat == 0) {
        // set state of the engine as on
        if (vehicleid in __vehicles) {
            __vehicles[vehicleid].state = true;
        }
    }

    // check blocking
    if (isVehicleOwned(vehicleid) && seat == 0) {

        dbg("player", "vehicle", "enter", getVehiclePlateText(vehicleid), getIdentity(playerid), "haveKey: " + isPlayerHaveVehicleKey(playerid, vehicleid));

        if (isPlayerHaveVehicleKey(playerid, vehicleid)) {
            unblockDriving(vehicleid);
            setVehicleOwner(vehicleid, playerid);
        } else {
            blockDriving(playerid, vehicleid);
            msg(playerid, "vehicle.owner.warning", CL_WARNING);
        }
    }

    // handle respawning and saving
    resetVehicleRespawnTimer(vehicleid);
    trySaveVehicle(vehicleid);

    // trigger other events
    trigger("onPlayerVehicleEnter", playerid, vehicleid, seat);
});

key(["w", "s"], function(playerid) {
    if (!isPlayerInVehicle(playerid)) {
        return;
    }

    local vehicleid = getPlayerVehicle(playerid);

    if (!isPlayerVehicleDriver(playerid)) {
        return;
    }

    if (vehicleid in __vehicles) {
        __vehicles[vehicleid].state = true;
    }
}, KEY_BOTH);

// handle vehicle exit
event("native:onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    logger.logf(
        "[VEHICLE EXIT] (%s) %s (playerid: %d) | (vehid: %d) %s - %s (model: %d) | coords: [%.5f, %.5f, %.5f] | owner: %s | fraction: %s",
            getAccountName(playerid),
            getPlayerName(playerid),
            playerid,
            vehicleid,
            getVehiclePlateText(vehicleid),
            getVehicleNameByModelId(getVehicleModel(vehicleid)),
            getVehicleModel(vehicleid),
            getVehiclePositionObj(vehicleid).x,
            getVehiclePositionObj(vehicleid).y,
            getVehiclePositionObj(vehicleid).z,
            isVehicleOwned(vehicleid) ? (isPlayerVehicleOwner(playerid, vehicleid) ? "true" : "false") : "city_ncrp",
            isVehicleFraction(vehicleid) ? "true" : "false"
    );

    if("seatPos" in __vehicles[vehicleid]) {
        local posOld = __vehicles[vehicleid].seatPos;
        local posNew = getVehiclePosition( vehicleid );
        local dis = getDistanceBetweenPoints3D( posOld[0], posOld[1], posOld[2], posNew[0], posNew[1], posNew[2] );
        if(dis > 0.4 && __vehicles[vehicleid].entity) {
            local history = __vehicles[vehicleid].entity.history == "" ? [] : JSONParser.parse(__vehicles[vehicleid].entity.history);
            if(history.len() == 10) {
                history.remove(0);
            }
            history.push([getRealDateTime(), getPlayerName(playerid), dis]);
            __vehicles[vehicleid].entity.history = JSONEncoder.encode(history);
        }
    }

    // handle vehicle passangers
    removeVehiclePassenger(vehicleid, playerid, seat);

    // check blocking
    if (isVehicleOwned(vehicleid) && isPlayerVehicleOwner(playerid, vehicleid)) {
        blockDriving(playerid, vehicleid);
    }

    // handle respawning and saving
    resetVehicleRespawnTimer(vehicleid);
    trySaveVehicle(vehicleid);

    // trigger other events
    trigger("onPlayerVehicleExit", playerid, vehicleid, seat);
});

// force resetting vehicle position to death point
event("onPlayerDeath", function(playerid) {
    dbg("player", "death", "vehicle", getAuthor(playerid), getVehiclePlateText(getPlayerVehicle(playerid)));

    if (isPlayerInVehicle(playerid)) {
        local vehicleid = getPlayerVehicle(playerid);

        delayedFunction(1500, function() {
            setVehiclePositionObj(vehicleid, getVehiclePositionObj(vehicleid));
        });

        delayedFunction(5000, function() {
            setVehiclePositionObj(vehicleid, getVehiclePositionObj(vehicleid));
        });
    }
});

event("onPlayerSpawned", function(playerid) {
    local ppos = players[playerid].getPosition();

    // special check for spawning inside closed truck
    foreach (vehicleid, value in __vehicles) {
        local vehModel = getVehicleModel(vehicleid);
        if (vehModel == 38 || vehModel == 34) {

            local vpos = getVehiclePosition(vehicleid);
            // if inside vehicle, set offsetted position
            if (getDistanceBetweenPoints3D(ppos.x, ppos.y, ppos.z, vpos[0], vpos[1], vpos[2]) < 4.0) {
                dbg("player", "spawn", getIdentity(playerid), "inside closed truck, respawning...");
                players[playerid].setPosition(ppos.x + 1.5, ppos.y + 1.5, ppos.z);
                return;
            }
        }
    }
});

include("controllers/vehicle/functions");
include("controllers/vehicle/commands.nut");
include("controllers/vehicle/vehicleInfo.nut");
include("controllers/vehicle/translations.nut");
//include("controllers/vehicle/hiddencars.nut");
