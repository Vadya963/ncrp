include("controllers/fraction/classes/Fraction.nut");
include("controllers/fraction/classes/FractionRole.nut");
include("controllers/fraction/classes/FractionMember.nut");
include("controllers/fraction/classes/FractionContainer.nut");
// require("controllers/fraction/classes/FractionRoleContainer.nut");

fractions <- FractionContainer();

event("onServerStarted", function() {
    local __globalroles = {};

    Fraction.findAll(function(err, results) {
        foreach (idx, fraction in results) {
            fractions.add(fraction.id, fraction);

            if (fraction.shortcut) {
                fractions.add(fraction.shortcut, fraction);
            }
        }
    });

    FractionRole.findAll(function(err, results) {
        foreach (idx, role in results) {
            if (!fractions.exists(role.fractionid)) {
                dbg("fractions", "non existant fraction", role.fractionid, "with attached role", role.id);
                continue;
            }

            __globalroles[role.id] <- role;
            fractions[role.fractionid].roles.add(fractions[role.fractionid].roles.len(), role);
            // fractions[role.fractionid].__globalroles.add(role.id, role);

            if (role.shortcut) {
                fractions[role.fractionid].roles.add(role.shortcut, role);
            }
        }
    });

    FractionMember.findAll(function(err, results) {
        foreach (idx, member in results) {
            if (!fractions.exists(member.fractionid)) {
                dbg("fractions", "non existant fraction", role.fractionid, "with attached member", member.characterid);
                continue;
            }

            if (!fractions.get(member.fractionid).roles.exists(member.roleid)) {
                dbg("fractions", "non existant fraction role", member.roleid, "for fraction", member.fractionid, "with attached member", member.characterid);
                continue;
            }

            // fractions[member.fractionid].add(member.characterid, fractions[member.fractionid].__globalroles[member.roleid]);
            fractions[member.fractionid].add(member.characterid, __globalroles[member.roleid]);
        }
    });

    // local f = Fraction();
    // f.title = "ZE WATAFUCKZ";
    // f.created = getTimestamp();
    // f.shortcut = "WTF";
    // f.money = 124242.42;
    // f.save();

    // local fr = FractionRole();
    // fr.title = "BIG BO$$";
    // fr.created = getTimestamp();
    // fr.level = 0;
    // fr.fractionid = 1;
    // fr.save();

    // dbg(fr);

    // local fm = FractionMember();
    // fm.characterid = 1069;
    // fm.roleid = fr.id;
    // fm.fractionid = 1;
    // fm.created = getTimestamp();
    // fm.save();
});

cmd("f", "roles", function(playerid) {
    local fracs = fractions.getManaged(playerid);

    if (!fracs.len()) {
        return msg(playerid, "You are not fraction admin.", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];

    msg(playerid, "List of roles in %s:", fraction.title, CL_INFO);

    foreach (idx, role in fraction.roles) {
        local string = format("#%d, Title: %s, Level: %s", idx, role.title, role.level);
        msg(playerid, string);
        dbg(string);
    }
})

cmd("f", "invite", function(playerid, invitee, rolenum) {

});

cmd("tune", function(playerid, level) {
    if (!isPlayerInVehicle(playerid)) {
        return;
    }

    if (!fractions["brio"].exists(playerid)) {
        return;
    }

    local role = fractions["brio"][playerid];

    if (role.level > 3) {
        return;
    }

    // setVehicleTuningTable
});
