include("controllers/money/commands.nut");

function addMoneyToPlayer(playerid, amount) {
    players[playerid]["money"] += amount;
}

function subMoney(playerid, amount) {
    players[playerid]["money"] -= amount;
}
