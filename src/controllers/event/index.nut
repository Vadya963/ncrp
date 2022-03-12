__events <- {};

// saving old
local nativeAddEventHandler = addEventHandler;
local nativeCallEvent = callEvent;
local nativeTriggerClientEvent   = triggerClientEvent;

/**
 * Method for proxying old events to new
 *
 * @param  {String} native
 * @param  {String} inner
 * @return {Booelan}
 */
function proxy(native, inner) {
    return nativeAddEventHandler(native, function(...) {
        local args = clone vargv;

        args.insert(0, null);
        args.insert(1, inner);

        trigger.acall(args);
    });
}

/**
 * Register event handler
 *
 * @param  {String|Array<Strings>}   names
 * @param  {Function} callback
 * @return {Boolean}
 */
function event(names, callback) {
    if (typeof names != "array") {
        names = [names];
    }

    foreach (idx, name in names) {
        if (!(name in __events)) {
            __events[name] <- [];
        }

        __events[name].push(callback);
    }

    return true;
}

/**
 * Trigger server or client event
 * (if playerid is first argument, its a client event)
 *
 * For server event:
 * @param  {String} event name
 * [ @param  {Mixed} argument 1 ]
 * [ @param  {Mixed} argument 2 ]
 * ...
 * [ @param  {Mixed} argument N ]
 *
 * For client event:
 * @param  {Integer} playerid
 * @param  {String} event name
 * [ @param  {Mixed} argument 1 ]
 * [ @param  {Mixed} argument 2 ]
 * ...
 * [ @param  {Mixed} argument N ]
 *
 * @return {Boolean} if triggering succeded
 */
function trigger(...) {
    local args = clone vargv;
    args.insert(0, getroottable());

    // triggering client
    if (vargv.len() > 1 && typeof vargv[0] == "integer") {
        return nativeTriggerClientEvent.acall(args);
    }

    // triggering server event
    if (vargv.len() > 0 && typeof vargv[0] == "string") {
        if (vargv[0] in __events) {
            args.remove(1); // remove event name
            foreach (idx, callback in __events[vargv[0]]) {
                try {
                    callback.acall(args);
                }
                catch (e) {
                    dbg("error calling event:", vargv[0], e);
                }
            }

            return true;
        }
    }

    return false;
}

/**
 * Removes event listener by passed callback functions
 *
 * @param  {String} event
 * @param  {Function} func
 */
function removeEvent(event, func) {
    if (event in __events) {
        __events[event].remove(__events[event].find(func));
    }
}

/**
 * Registering proxies
 */

// server
proxy("onScriptInit",      "native:onScriptInit"    );
proxy("onScriptExit",      "native:onScriptExit"    );
proxy("onScriptError",     "native:onScriptError"   );
proxy("onConsoleInput",    "native:onConsoleInput"  );
// proxy("onServerPulse",     "native:onServerPulse"   );
proxy("onServerShutdown",  "native:onServerShutdown");

// player
proxy("onPlayerConnect",            "native:onPlayerConnect"            );
proxy("onPlayerDisconnect",         "native:onPlayerDisconnect"         );
proxy("onPlayerConnectionRejected", "native:onPlayerConnectionRejected" );
proxy("onPlayerChat",               "native:onPlayerChat"               );
proxy("onPlayerSpawn",              "native:onPlayerSpawn"              );
proxy("onPlayerChangeNick",         "native:onPlayerChangeNick"         );
proxy("onPlayerDeath",              "native:onPlayerDeath"              );
proxy("onPlayerChangeWeapon",       "native:onPlayerChangeWeapon"       );
proxy("onPlayerChangeHealth",       "native:onPlayerChangeHealth"       );
proxy("onPlayerVehicleEnter",       "native:onPlayerVehicleEnter"       );
proxy("onPlayerVehicleExit",        "native:onPlayerVehicleExit"        );

// vehicle
proxy("onVehicleSpawn",             "onVehicleSpawn"             );

// aliases
addEventHandler    <- function(...) warning("addEventHandler deprecated. Use event(...) instead");
callEvent          <- function(...) warning("callEvent deprecated. Use trigger(...) instead");;
triggerClientEvent <- trigger;