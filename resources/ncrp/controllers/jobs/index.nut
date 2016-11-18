jobtext <- {
    "need" : "You need a ",
    "notCDD" : "You're not a cargo delivery driver."
};


include("controllers/jobs/commands.nut");
include("controllers/jobs/busdriver");
include("controllers/jobs/fuel");
include("controllers/jobs/taxi");
include("controllers/jobs/milkdriver");
include("controllers/jobs/cargodriver");
include("controllers/jobs/telephone");

addEventHandlerEx("onServerStarted", function() {
    // nothing there anymore :C
    log("[jobs] starting...");
});

