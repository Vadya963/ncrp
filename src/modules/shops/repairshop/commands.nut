key("e", function(playerid) {
    repairShopRepairCar (playerid);
});

// cmd( "repaint", function(playerid, red, green, blue) {
//     local r = min(red.tointeger(), 255);
//     local g = min(green.tointeger(), 255);
//     local b = min(blue.tointeger(), 255);

//     if (!isPlayerInVehicle(playerid)) {
//         return;
//     }

//     if (isNearRepairShop(playerid)) {
//         local vehicleid = getPlayerVehicle(playerid);
//         if ( !isPlayerVehicleOwner(playerid, vehicleid) ) {
//             return msg(playerid,"shops.repairshop.ownership.wrong");
//         }
//         if ( canMoneyBeSubstracted(playerid, SHOP_REPAINT_COST) ) {
//             msg(playerid, "shops.repairshop.needwait");
//             screenFadeinFadeoutEx(playerid, 250, 3000, null, function() {
//                 setVehicleColour(vehicleid, r, g, b, r, g, b);
//                 subPlayerMoney(playerid, SHOP_REPAINT_COST);
//                 return msg(playerid, "shops.repairshop.repaint.payed", [SHOP_REPAINT_COST, getPlayerBalance(playerid)]);
//             });
//         } else {
//             msg(playerid, "shops.repairshop.money.notenough");
//         }  
//     }
// });

