include("controllers/vehicle/functions/lights.nut");
include("controllers/vehicle/functions/validators.nut");
include("controllers/vehicle/functions/additional.nut");
include("controllers/vehicle/functions/overrides.nut");
include("controllers/vehicle/functions/passengers.nut");
include("controllers/vehicle/functions/respawning.nut");
include("controllers/vehicle/functions/ownership.nut");
include("controllers/vehicle/functions/saving.nut");
include("controllers/vehicle/functions/blocking.nut");
include("controllers/vehicle/functions/fuel.nut");
include("controllers/vehicle/functions/plates.nut");
include("controllers/vehicle/functions/colors.nut");
include("controllers/vehicle/functions/distance.nut");
include("controllers/vehicle/functions/models.nut");
include("controllers/vehicle/functions/dirt.nut");
include("controllers/vehicle/functions/engine.nut");

// saving original vehicle method
local old__createVehicle = createVehicle;
local old__setVehicleWheelTexture = setVehicleWheelTexture;

// creating storage for vehicles
__vehicles <- {};
__vehiclesR <- {};


// NVEHICLES: overrides for new system
original__createVehicle     <- createVehicle;
original__isPlayerInVehicle <- isPlayerInVehicle;
original__getPlayerVehicle  <- getPlayerVehicle;

// NVEHICLES: overrides for old system
isPlayerInVehicle <- function(playerid) {
    local result = original__isPlayerInVehicle(playerid);
    if (!result) return false;

    local vehicleid = original__getPlayerVehicle(playerid);
    if (!(vehicleid in __vehicles)) return false;
}

getPlayerVehicle <- function(playerid) {
    return isPlayerInVehicle(playerid) ? original__getPlayerVehicle(playerid) : -1;
}
// NVEHICLES: END OF overrides for old system


// overriding to custom one
createVehicle = function(modelid, x, y, z, rx, ry, rz) {
    local vehicleid = old__createVehicle(
        modelid.tointeger(), x.tofloat(), y.tofloat(), z.tofloat(), rx.tofloat(), ry.tofloat(), rz.tofloat()
    );

    // save vehicle record
    __vehicles[vehicleid] <- {
        saving  = false,
        entity = null,
        respawn = {
            enabled = true,
            position = { x = x.tofloat(), y = y.tofloat(), z = z.tofloat() },
            rotation = { x = rx.tofloat(), y = ry.tofloat(), z = rz.tofloat() },
            time = getTimestamp(),
        },
        ownership = {
            status   = VEHICLE_OWNERSHIP_NONE,
            owner    = null,
            ownerid  = -1,
        },
        wheels = {
            front = -1,
            rear  = -1
        },
        dirt = 0.0,
        state = false,
        fuel = getDefaultVehicleFuel(vehicleid),
    };

    // apply default functions
    setVehicleRotation(vehicleid, rx.tofloat(), ry.tofloat(), rz.tofloat());
    setVehicleDirtLevel(vehicleid, randomf(VEHICLE_MIN_DIRT, VEHICLE_MAX_DIRT));
    setVehiclePlateText(vehicleid, getRandomVehiclePlate());
    setRandomVehicleColors(vehicleid);
    setVehicleEngineState(vehicleid, false);

    // apply overrides
    getVehicleOverride(vehicleid, modelid.tointeger());

    return vehicleid;
};

// overriding to custom one
setVehicleWheelTexture = function(vehicleid, wheel, textureid) {
    if (textureid != 255 && textureid != -1) {

        if (vehicleid in __vehicles) {
            // add info for saving
            if (wheel == 0) __vehicles[vehicleid].wheels.front = textureid;
            if (wheel == 1) __vehicles[vehicleid].wheels.rear  = textureid;
        }

        // call native
        return old__setVehicleWheelTexture(vehicleid, wheel, textureid);
    }
}

/**
 * Remove player vehicle from database
 * @param  {Integer} vehicleid
 * @return {Boolean}
 */
function removePlayerVehicle(vehicleid) {
    if (vehicleid in __vehicles) {
        dbg("removing player vehicle from database", getVehiclePlateText(vehicleid));
        if (__vehicles[vehicleid].entity) {
            __vehicles[vehicleid].entity.remove();
            delete __vehicles[vehicleid];
        }

        destroyVehicle(vehicleid);

        return true;
    }
}

function setVehicleEntity(vehicleid, entity) {
    __vehiclesR[entity.id] <- entity;

    if (vehicleid in __vehicles) {
        return __vehicles[vehicleid].entity = entity;
    }
}

/**
 * Destroy all vehicles spawned on server
 */
function destroyAllVehicles() {
    foreach (vehicleid, vehicle in __vehicles) {
        trySaveVehicle(vehicleid);
        destroyVehicle(vehicleid);
    }
}

/**
 * Return array of vehicleids which are saveble
 * @return {array}
 */
function getCustomPlayerVehicles() {
    local ids = [];

    foreach (vehicleid, vehicle in __vehicles) {
        if (vehicle.saving) {
            ids.push(vehicleid);
        }
    }

    return ids;
}

/**
 * @deprecated
 * @return {[type]} [description]
 */
function getAllServerVehicles() {
    return __vehicles;
}


/**
 * Return Entity.id from tbl_vehicles by vehicleid
 * @return {array}
 */
function getVehicleEntityId (vehicleid) {
    return vehicleid in __vehicles && __vehicles[vehicleid].entity ? __vehicles[vehicleid].entity.id : -1;
}

/**
 * Return vehicleid by EntityId
 * or false if vehicle was not found
 * @param {Integer} EntityId
 * @return {Integer} vehicleid
 */
function getVehicleIdFromEntityId(entityid) {
    foreach(vehicleid, value in __vehicles) {
        if(value.entity != null && value.entity.id == entityid) {
            return vehicleid;
        }
    }
    return false;
}
