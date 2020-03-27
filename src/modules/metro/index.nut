include("modules/metro/commands.nut");
include("modules/metro/functions.nut");

translation("en", {
    "metro.toofaraway"                  : "[SUBWAY] You are too far from any station!"
    "metro.notenoughmoney"              : "[SUBWAY] Not enough money!"
    "metro.pay"                         : "[SUBWAY] You pay $%.2f for ticket."
    "metro.arrived"                     : "[SUBWAY] You arrived to %s station."
    "metro.herealready"                 : "[SUBWAY] You're here already."
    "metro.notexist"                    : "[SUBWAY] Selected station doesn't exist."
    "metro.nocar"                       : "[SUBWAY] Subway isn't ferry boat. Leave the car."

    "metro.listStations.title"          : "List of available stations:"
    "metro.listStations.station"        : "Station #%d - %s"
    "metro.listStations.station.closed" : "Station #%d - %s (closed)"

    "metro.station.closed.maintaince"   : "Station %s is closed for maintaince. Please move to another station or use other public transport."

    "metro.help.title"                  : "Find nearest subway station for travel by Subway: /subway"
    "metro.help.subway"                 : "Move to station by id"
    "metro.help.subwayList"             : "Show list of all stations"
    "metro.help.sub"                    : "Analog /subway id"
    "metro.help.metro"                  : "Analog /subway id"

    "metro.station.nearest.showblip"    : "[SUBWAY] Nearest station (%s) is marked by yellow icon on map."

    "metro.dipton"      : "Dipton"
    "metro.uptown"      : "Uptown"
    "metro.chinatown"   : "Chinatown"
    "metro.southport"   : "Southport"
    "metro.westside"    : "West Side"
    "metro.sandisland"  : "Sand Island"
    "metro.kingston"    : "Kingston"

    "metro.gui.window"   : "Empire Bay Subway"
    "metro.gui.youhere"  : "%s Station"
    "metro.gui.price"    : "Single ride: $%.2f"
    "metro.gui.close"    : "Close"
});

const METRO_RADIUS = 2.0;
const METRO_TICKET_COST = 0.15;

const METRO_KEY_AVALIABLE = "open";
const METRO_KEY_UNAVALIABLE = "closed";

local metro = {};

// x, y, z, "station caption", main 3d text radius, additional 3d text x_pos, additional 3d text y_pos, additional 3d text z_pos, key_status, for plocalize
metroInfos <- [
    [ -555.353,     1605.74,    -20.6639,   "Dipton",       4, "down", -532.406,   1605.85,    -16.6,       METRO_KEY_AVALIABLE, "metro.dipton"     ],
    [ -293.068512,  553.138000, -2.273677,  "Uptown",      40, "up",   null,       null,       null,        METRO_KEY_AVALIABLE, "metro.uptown"     ],
    [  234.378662,  396.031830, -9.407516,  "Chinatown",   15, "up",   259.013,    395.816,    -21.6287,    METRO_KEY_AVALIABLE, "metro.chinatown"  ],
    [ -98.685043,   -481.715393,-8.921828,  "Southport",   15, "up",   -98.6563,   -498.904,   -15.7404,    METRO_KEY_AVALIABLE, "metro.southport"  ],
    [ -498.224,     21.5297,    -4.50967,   "WestSide",     4, "down", -498.266,   -2.04015,   -0.539263,   METRO_KEY_AVALIABLE, "metro.westside"   ],
    [ -1550.738159, -231.029968,-13.589154, "SandIsland",  15, "up",   -1550.59,   -213.811,   -20.3354,    METRO_KEY_AVALIABLE, "metro.sandisland" ],
    [ -1117.73,     1363.49,    -17.5724,   "Kingston",     4, "down", -1141.32,   1363.65,    -13.5724,    METRO_KEY_AVALIABLE, "metro.kingston"   ]
];

const METRO_HEAD = 0;
const METRO_TAIL = 6; // total number of stations-1

event("onServerStarted", function() {
    logStr("[metro] loading metro stations...");
    //creating public 3dtext

});

event("onServerPlayerStarted", function(playerid) {
    foreach (station in metroInfos) {

        createPrivate3DText ( playerid, station[0], station[1], station[2]+0.35, [[ "SUBWAYSTATION", station[3].toupper()], "%s: %s"], CL_EUCALYPTUS, station[4] );
        createPrivate3DText ( playerid, station[0], station[1], station[2]+0.20, plocalize(playerid, "3dtext.job.press.E"), CL_WHITE.applyAlpha(150), METRO_RADIUS );

        if(station[6]) {
            createPrivate3DText ( playerid, station[6], station[7], station[8]+0.35, [[ "GO", station[5].toupper(), "TOTHESUBWAY"], "%s %s %s"], CL_EUCALYPTUS, 30 );
        }
    }
});

event("onPlayerConnect", function(playerid) {
    if ( ! (getPlayerName(playerid) in metro) ) {
    metro[getPlayerName(playerid)] <- {};
    metro[getPlayerName(playerid)]["currentStation"] <- null;
    metro[getPlayerName(playerid)]["metroList"] <- null;
    }
});

event("onPlayerDisconnect", function(playerid, reason) {
    if ( getPlayerName(playerid) in metro ) {
        delete metro[getPlayerName(playerid)];
    }
});

function showMetroGUI(playerid) {

    local nearestStationID = getNearStationIndex(playerid);

    if ( nearestStationID == "faraway") {
        return;
    }

    if( isPlayerInVehicle( playerid ) ) {
        return;
    }

    local metroList = metro[getPlayerName(playerid)]["metroList"];

    if(metro[getPlayerName(playerid)]["currentStation"] != nearestStationID) {
        metro[getPlayerName(playerid)]["currentStation"] = nearestStationID;
        metroList = metroGenerateListStations( playerid );
        metro[getPlayerName(playerid)]["metroList"] = metroList;
    }

    local windowText =  plocalize(playerid, "metro.gui.window");
    local label1Text =  plocalize(playerid, "metro.gui.youhere", [ plocalize(playerid, metroInfos[nearestStationID][10])  ]);
    local label2Text =  plocalize(playerid, "metro.gui.price", [ METRO_TICKET_COST ]);

    local button1Text = plocalize(playerid, metroInfos[metroList[0][0]][10]);
    local button2Text = plocalize(playerid, metroInfos[metroList[1][0]][10]);
    local button3Text = plocalize(playerid, metroInfos[metroList[2][0]][10]);
    local button4Text = plocalize(playerid, metroInfos[metroList[3][0]][10]);
    local button5Text = plocalize(playerid, metroInfos[metroList[4][0]][10]);
    local button6Text = plocalize(playerid, metroInfos[metroList[5][0]][10]);

    local button7Text = plocalize(playerid, "metro.gui.close");

    triggerClientEvent(playerid, "showMetroGUI", windowText, label1Text, button1Text, button2Text, button3Text, button4Text, button5Text, button6Text, label2Text, button7Text);
}


/* ---------------------------------------------------------------------------------------------- */

/**
 * Generate array for all stations, without current.
 * @param  {int} playerid
 * @return {array} metroList [id, name]
 */
function metroGenerateListStations( playerid ) {

    local nearestStationID = metro[getPlayerName(playerid)]["currentStation"];

    local metroList = [];
    foreach (index, station in metroInfos) {
        if (index == nearestStationID) continue;
        metroList.push( [ index, station[3] ]);
    }

    return metroList;
}

event("travelToStationGUI", function (playerid, buttonID) {
    local metroList = metro[getPlayerName(playerid)]["metroList"];
    travelToStation(playerid, metroList[buttonID][0]+1);
});

