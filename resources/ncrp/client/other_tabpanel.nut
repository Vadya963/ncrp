// scoreboard.nut By AaronLad

// Variables
local drawScoreboard = false;
local screenSize = getScreenSize( );

// Scoreboard math stuff
local fPadding = 5.0, fTopToTitles = 25.0;
local fWidth = 600.0, fHeight = ((fPadding * 2) + (fTopToTitles * 3));
local fOffsetID = 50.0, fOffsetName = 450.0;
local fPaddingPlayer = 20.0;
local fX = 0.0, fY = 0.0, fOffsetX = 0.0, fOffsetY = 0.0;

local initialized = false;
local players = array(MAX_PLAYERS, 0);

function tabDown()
{
    if (!initialized) return;
    drawScoreboard = true;
    showChat( false );

    // Add padding to the height for each connected player
    for( local i = 0; i < MAX_PLAYERS; i++ )
    {
        if( isPlayerConnected(i) )
            fHeight += fPaddingPlayer;
    }
}
bindKey("f6", "down", tabDown);

function tabUp()
{
    if (!initialized) return;
    drawScoreboard = false;
    showChat( true );

    // Reset the height
    fHeight = ((fPadding * 2) + (fTopToTitles * 3));
}
bindKey("f6", "up", tabUp);

// addEventHandler("onServerKeyboard", function(key, state) {
//     if (key == "tab" && state == "down") tabDown();
//     if (key == "tab" && state == "up") tabUp();
// });

function deviceReset()
{
    // Get the new screen size
    screenSize = getScreenSize();
}
addEventHandler( "onClientDeviceReset", deviceReset );

function frameRender( post_gui )
{
    if( post_gui && drawScoreboard )
    {
        fX = ((screenSize[0] / 2) - (fWidth / 2));
        fY = ((screenSize[1] / 2) - (fHeight / 2));
        fOffsetX = (fX + fPadding);
        fOffsetY = (fY + fPadding);

        dxDrawRectangle( fX, fY, fWidth, fHeight, fromRGB( 0, 0, 0, 128 ) );

        fOffsetX += 25.0;
        fOffsetY += 25.0;
        dxDrawText( "ID", fOffsetX, fOffsetY, 0xFFFFFFFF, true, "tahoma-bold" );

        fOffsetX += fOffsetID;
        dxDrawText( "Character", fOffsetX, fOffsetY, 0xFFFFFFFF, true, "tahoma-bold" );

        fOffsetX += fOffsetName;
        dxDrawText( "Ping", fOffsetX, fOffsetY, 0xFFFFFFFF, true, "tahoma-bold" );

        local localname = (getLocalPlayer() in players && players[getLocalPlayer()]) ? players[getLocalPlayer()] : getPlayerName(getLocalPlayer());

        // Draw the localplayer
        fOffsetX = (fX + fPadding + 25.0);
        fOffsetY += 20.0;
        dxDrawText( getLocalPlayer().tostring(), fOffsetX, fOffsetY, 0xFF019875, true, "tahoma-bold" );

        fOffsetX += fOffsetID;
        dxDrawText( localname, fOffsetX, fOffsetY, 0xFF019875, true, "tahoma-bold" );

        fOffsetX += fOffsetName;
        dxDrawText( getPlayerPing(getLocalPlayer()).tostring(), fOffsetX, fOffsetY, 0xFF019875, true, "tahoma-bold" );

        // Draw remote players
        for( local i = 0; i < MAX_PLAYERS; i++ )
        {
            if( i != getLocalPlayer() )
            {
                if( isPlayerConnected(i) && i in players && players[i])
                {
                    fOffsetX = (fX + fPadding + 25.0);
                    fOffsetY += fPaddingPlayer;
                    dxDrawText( i.tostring(), fOffsetX, fOffsetY, getPlayerColour(i), true, "tahoma-bold" );

                    fOffsetX += fOffsetID;
                    dxDrawText( players[i], fOffsetX, fOffsetY, getPlayerColour(i), true, "tahoma-bold" );

                    fOffsetX += fOffsetName;
                    dxDrawText( getPlayerPing(i).tostring(), fOffsetX, fOffsetY, getPlayerColour(i), true, "tahoma-bold" );
                }
            }
        }
    }
}
addEventHandler( "onClientFrameRender", frameRender );

addEventHandler("onServerPlayerAdded", function(playerid, charname) {
    initialized = true;

    if( drawScoreboard ) {
        fHeight += fPaddingPlayer;
    }

    players[playerid] = charname;
});

addEventHandler("onClientPlayerDisconnect", function(playerid) {
    // Are we rendering the scoreboard?
    if( drawScoreboard ) {
        // Remove the height from this player
        fHeight = fHeight - fPaddingPlayer;
    }
    players[playerid] = null;
});
