metroInfos <- [
	[ -555.864136, 1592.924927, -21.863888, "Dipton" ], 		
	[ -293.068512, 553.138000, -2.273677, "Uptown" ],  		
	[ 234.378662, 396.031830, -9.407516, "Chinatown" ], 		
	[ -98.685043, -481.715393, -8.921828, "Southport" ],				
	[ -511.283478, 21.851606, -5.709612, "Westside" ],					
	[ -1550.738159, -231.029968, -13.589154, "SandIsland" ], 			
	[ -1117.546509, 1363.452026, -17.572432, "Kingston" ]
]; 

addCommandHandler( "sub", function( playerid, id ) {
    log("Choden " + metroInfos[id][4]);
    //setPlayerPosition(playerid, metroInfos[id][1], metroInfos[id][2], metroInfos[id][3]);
});