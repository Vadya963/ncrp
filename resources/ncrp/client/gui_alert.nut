const ELEMENT_TYPE_BUTTON = 2;

// added check for 2x widht bug
local screen = getScreenSize();
local screenX = screen[0].tofloat();
local screenY = screen[1].tofloat();

if ((screenX / screenY) > 2.0) {
    screenX = 0.5 * screenX;
}

screen = [screenX, screenY];

local window;
local label;
local button;
local oldCursorState = false;

addEventHandler("onAlert", function (title, message, lines = 0) {
    if (!window || (window && !guiIsVisible(window))) {
        oldCursorState = isCursorShowing();
    }
    if(window){
        guiSetVisible(window,true);
        guiSetText(label, message.tostring());
    }
    else{
        window = guiCreateElement( ELEMENT_TYPE_WINDOW, title, screen[0]/2 - 150, screen[1]/2 - 50 - (lines/2 * 20.0), 300.0, 100.0 + 20.0 * lines );
        label = guiCreateElement( ELEMENT_TYPE_LABEL, message.tostring(), 12.0, 20.0, 300.0, 50.0 + 20.0 * lines, false, window);
        button = guiCreateElement( ELEMENT_TYPE_BUTTON, "OK" , 100.0, 70.0 + 20.0 * lines, 100.0, 20.0, false, window);
    }
    if(!oldCursorState){
        showCursor(true);
    }
    //guiSetMovable(window,false);
    guiSetSizable(window,false);
    guiBringToFront( window );
    guiSetAlwaysOnTop( window, true );
});

addEventHandler( "onGuiElementClick",function(element){
    if(element == button){
        guiSetText(label, "");
        guiSetVisible(window,false);
        delayedFunction(200, function() {
            showCursor(oldCursorState);
        });
    }
});

function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}

addEventHandler( "onClientPlayerMoveStateChange", function( playerid, oldMoveState, newMoveState ){
    triggerServerEvent("updateMoveState",newMoveState);
});

/*
addEventHandler( "getClientMoveState", getMoveStatefunction(){
    local state = getPlayerMoveState(getLocalPlayer());
    return state;
});
*/
