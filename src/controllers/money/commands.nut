cmd( ["money"], function( playerid ) {
    msg( playerid, "Your cash: $" + getPlayerBalance(playerid) );
});

cmd( ["give", "send"], sendMoneyBlock );
cmd( ["invoice"], sendInvoice );
cmd( ["accept"], invoiceAccept );
cmd( ["decline"], invoiceDecline );

cmd( ["pay"], invoiceAcceptNew );
cmd( ["cancel"], invoiceDeclineNew );
