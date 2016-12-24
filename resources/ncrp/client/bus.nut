local busses = {};
local syncing = [];
local ticker = null;

addEventHandler("onServerClientStarted", function(version) {
    if (ticker) return;

    // check for distances of the busses
    ticker = timer(function() {
        syncing.clear();

        foreach (idx, passangers in busses) {
            local bus = getVehiclePosition(idx);
            local pos = getPlayerPosition(getLocalPlayer());
            if (getDistanceBetweenPoints2D(bus[0], bus[1], pos[0], pos[1]) < 50.0) {
                syncing.push(idx);
            }
        }
    }, 1000, -1);
});

addEventHandler("onServerClientStopped", function() {
    ticker.Kill();
    ticker = null;
});

addEventHandler("onServerPlayerBusEnter", function(playerid, busid) {
    if (!(busid in busses)) {
        busses[busid] <- [];
    }

    busses[busid].push(playerid);
});

addEventHandler("onServerPlayerBusExit", function(playerid, busid) {
    if (!(busid in busses)) {
        return;
    }

    local idx = busses[busid].find(playerid);

    if (idx) {
        busses[busid].remove(idx);
    }
});

addEventHandler("onClientFrameRender", function(a) {
    if (a) {
        for (local i = 0; i < syncing.len(); i++) {
            local busid = syncing[i];
            local pos = getVehiclePosition(busid);

            foreach (idx, playerid in busses[busid]) {
                setPlayerPosition(playerid, pos[0], pos[1], pos[2] + 0.5);
            }
        }
    }
});
