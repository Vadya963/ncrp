/**
 * Set if vehicle can be automatically saved
 * @param  {Integer} vehicleid
 * @param  {Boolean} value
 * @return {Boolean}
 */
function setVehicleSaving(vehicleid, value) {
    if (vehicleid in __vehicles) {
        return __vehicles[vehicleid].saving = value;
    }
}

/**
 * Get if vehicle is automatically saved
 * @param  {Integer} vehicleid
 * @return {Boolean}
 */
function getVehicleSaving(vehicleid) {
    return (vehicleid in __vehicles && __vehicles[vehicleid].saving);
}

/**
 * Tries to save all vehicles
 */
function saveAllVehicles() {
    foreach (vehicleid, vehicle in __vehicles) {
        if (vehicle && vehicle.saving) {
            trySaveVehicle(vehicleid);
        }
    }
}

/**
 * Try to save vehicle
 * make sure that vehicle is saveble via setVehicleSaving(vehicleid, true)
 *
 * @param  {integer} vehicleid
 * @return {bool} result
 */
function trySaveVehicle(vehicleid) {
    if (!(vehicleid in __vehicles)) {
        return dbg("[vehicle] trySaveVehicle: __vehicles no vehicleid #" + vehicleid);
    }

    local vehicle = __vehicles[vehicleid];

    if (!vehicle.saving) {
        return false;
    }

    if (!vehicle.entity) {
        vehicle.entity = Vehicle();
    }

    // save data
    local position = getVehiclePosition(vehicleid);
    local rotation = getVehicleRotation(vehicleid);

    vehicle.respawn.position.x = position[0];
    vehicle.respawn.position.y = position[1];
    vehicle.respawn.position.z = position[2];

    vehicle.respawn.rotation.x = rotation[0];
    vehicle.respawn.rotation.y = rotation[1];
    vehicle.respawn.rotation.z = rotation[2];

    vehicle.entity.x  = position[0];
    vehicle.entity.y  = position[1];
    vehicle.entity.z  = position[2];
    vehicle.entity.rx = rotation[0];
    vehicle.entity.ry = rotation[1];
    vehicle.entity.rz = rotation[2];

    local colors = getVehicleColour(vehicleid);

    vehicle.entity.cra = colors[0];
    vehicle.entity.cga = colors[1];
    vehicle.entity.cba = colors[2];
    vehicle.entity.crb = colors[3];
    vehicle.entity.cgb = colors[4];
    vehicle.entity.cbb = colors[5];

    vehicle.entity.model     = getVehicleModel(vehicleid);
    vehicle.entity.tunetable = getVehicleTuningTable(vehicleid);
    vehicle.entity.dirtlevel = getVehicleDirtLevel(vehicleid);
    vehicle.entity.fuellevel = vehicle.fuel;
    vehicle.entity.plate     = getVehiclePlateText(vehicleid);
    vehicle.entity.owner     = getVehicleOwner(vehicleid);
    vehicle.entity.ownerid   = getVehicleOwnerId(vehicleid);
    vehicle.entity.fwheel    = vehicle.wheels.front;
    vehicle.entity.rwheel    = vehicle.wheels.rear;
    vehicle.entity.data      = getVehicleData(vehicleid);

    vehicle.entity.save();
    // wtf?
    // vehicle.entity.data      = JSONParser.parse(vehicle.entity.data);

    if(vehicle.entity.inventory) {
        foreach (idx, item in vehicle.entity.inventory) {
            item.parent = vehicle.entity.id;
            item.save();
        }
    }

    if(vehicle.entity.interior) {
        foreach (idx, item in vehicle.entity.interior) {
            item.parent = vehicle.entity.id;
            item.save();
        }
    }

    return true;
}

// saving current vehicle data
event("onServerAutosave", function() {
    return saveAllVehicles();
});

// clearing all vehicles on server stop
event("onServerStopping", function() {
    return destroyAllVehicles();
});
