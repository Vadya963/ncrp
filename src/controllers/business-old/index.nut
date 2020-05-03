include("controllers/business/functions.nut");
// include("controllers/business/commands.nut");

const BUSINESS_DEFAULT = 0;
const BUSINESS_DINER   = 1;
const BUSINESS_BAR     = 2;
const BUSINESS_WEAPON  = 3;
const BUSINESS_CLOTHES = 4;


const BUSINESS_BUY_DISTANCE      = 1.0;
const BUSINESS_VIEW_DISTANCE     = 5.0;

event("onServerStarted", function() {
    logStr("[business] loading all businesses...");
    Business.findAll(function(err, results) {
        foreach (idx, business in results) {
            loadBusiness(business);
        }
    });
});

translation("en", {
    "business.money.income"     : "You've received $%.2f from your business '%s'!"
    "business.error.cantbuy"    : "You can't buy that business right now!"
    "business.error.faraway"    : "You are far away from any business!"
    "business.error.owned"      : "You can't buy a business which is already owned!"
    "business.purchase.success" : "You've successfuly purchased '%s'!"
});

event("onServerStopping", saveBusinesses);
event("onServerAutosave", saveBusinesses);

event("onServerDayChange", function() {
    return calculateBusinessIncome();
});
