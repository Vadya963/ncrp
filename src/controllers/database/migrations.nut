local __migrations = [];

// helper functios
function migrate(callback) {
    __migrations.push(callback);
}

function applyMigrations(callback, type) {
    local migration;

    MigrationVersion.findAll(function(err, migrations) {
        if (err || !migrations || migrations.len() < 1) {
            migration = MigrationVersion();
            migration.current = __migrations.len();
            migration.save();
        } else {
            migration = migrations[0];
        }

        // if current version is old, migrate to new
        while (migration.current < __migrations.len()) {
            __migrations[migration.current++](callback, type);
            logStr("[database][migration] applying migration #" + migration.current);
        }

        migration.save();
    });
}

/**
 * Apply your migrations below
 */

// 21.11.16
// added deposit field for character
migrate(function(query, type) {
    query("ALTER TABLE tbl_characters ADD COLUMN `deposit` FLOAT NOT NULL DEFAULT 0.0;");
});

// 24.11.16
// added vehicle wheel saving
migrate(function(query, type) {
    query("ALTER TABLE tbl_vehicles ADD COLUMN `fwheel` INT(255) NOT NULL DEFAULT 0;");
    query("ALTER TABLE tbl_vehicles ADD COLUMN `rwheel` INT(255) NOT NULL DEFAULT 0;");
});

// 26.11.16
// added character language saving
migrate(function(query, type) {
    query("ALTER TABLE tbl_characters ADD COLUMN `locale` VARCHAR(255) NOT NULL DEFAULT 'en';");
});

// 04.11.16
// added accounts serial and ip saving
migrate(function(query, type) {
    query("ALTER TABLE tbl_accounts ADD COLUMN `ip` VARCHAR(255) NOT NULL DEFAULT '';");
    query("ALTER TABLE tbl_accounts ADD COLUMN `serial` VARCHAR(255) NOT NULL DEFAULT '';");
});

// 05.11.16
// added character health saving
migrate(function(query, type) {
    query("ALTER TABLE tbl_characters ADD COLUMN `health` FLOAT NOT NULL DEFAULT 720.0;");
});

// 05.11.16
// added account locale saving
migrate(function(query, type) {
    query("ALTER TABLE tbl_accounts ADD COLUMN `locale` VARCHAR(255) NOT NULL DEFAULT 'en';");
});

// 05.11.16
// added account layout saving
migrate(function(query, type) {
    query("ALTER TABLE tbl_accounts ADD COLUMN `layout` VARCHAR(255) NOT NULL DEFAULT 'qwerty';");
});

// 20.12.16
// added account time of creation and last login
migrate(function(query, type) {
    query("ALTER TABLE tbl_accounts ADD COLUMN `created` INT(255) NOT NULL DEFAULT 0;");
    query("ALTER TABLE tbl_accounts ADD COLUMN `logined` INT(255) NOT NULL DEFAULT 0;");
});

// 21.12.16
// added character state saving
migrate(function(query, type) {
    query("ALTER TABLE tbl_characters ADD COLUMN `state` VARCHAR(255) NOT NULL DEFAULT 'free';");
});

// 29.12.16
// added account email
migrate(function(query, type) {
    query("ALTER TABLE tbl_accounts ADD COLUMN `email` VARCHAR(255) NOT NULL DEFAULT '';");
});

// 29.12.16
// added account email
migrate(function(query, type) {
    query("ALTER TABLE tbl_accounts ADD COLUMN `email` VARCHAR(255) NOT NULL DEFAULT '';");
});

// 02.01.17
// added character update fields
migrate(function(query, type) {
    query("ALTER TABLE tbl_characters ADD COLUMN `accountid` INT(255) NOT NULL DEFAULT 0;");
    query("ALTER TABLE tbl_characters ADD COLUMN `firstname` VARCHAR(255) NOT NULL DEFAULT '';");
    query("ALTER TABLE tbl_characters ADD COLUMN `lastname` VARCHAR(255) NOT NULL DEFAULT '';");
    query("ALTER TABLE tbl_characters ADD COLUMN `race` INT(255) NOT NULL DEFAULT 0;");
    query("ALTER TABLE tbl_characters ADD COLUMN `sex` INT(255) NOT NULL DEFAULT 0;");
    query("ALTER TABLE tbl_characters ADD COLUMN `birthdate` VARCHAR(255) NOT NULL DEFAULT '01.01.1920';");
    query("ALTER TABLE tbl_characters ADD COLUMN `x` FLOAT NOT NULL DEFAULT 0.0;");
    query("ALTER TABLE tbl_characters ADD COLUMN `y` FLOAT NOT NULL DEFAULT 0.0;");
    query("ALTER TABLE tbl_characters ADD COLUMN `z` FLOAT NOT NULL DEFAULT 0.0;");
    query("ALTER TABLE tbl_characters ADD COLUMN `rx` FLOAT NOT NULL DEFAULT 0.0;");
    query("ALTER TABLE tbl_characters ADD COLUMN `ry` FLOAT NOT NULL DEFAULT 0.0;");
    query("ALTER TABLE tbl_characters ADD COLUMN `rz` FLOAT NOT NULL DEFAULT 0.0;");
    query("UPDATE tbl_characters SET x = housex WHERE id > 0;");
    query("UPDATE tbl_characters SET y = housey WHERE id > 0;");
    query("UPDATE tbl_characters SET z = housez WHERE id > 0;");
});

//05.01.2017
//added moderator access level, number of player warnings/blocks
migrate(function(query, type) {
    query("ALTER TABLE tbl_accounts ADD COLUMN `moderator` INT(255) NOT NULL DEFAULT 0;");
    query("ALTER TABLE tbl_accounts ADD COLUMN `warns` INT(255) NOT NULL DEFAULT 0;");
    query("ALTER TABLE tbl_accounts ADD COLUMN `blocks` INT(255) NOT NULL DEFAULT 0;");
});

// 09.01.2017
// added migration for attaching new owned vehicles to players
migrate(function(query, type) {
    query("ALTER TABLE tbl_vehicles ADD COLUMN `ownerid` INT(255) NOT NULL DEFAULT -1;");
});

// 10.01.2017
// added migration for businesses and adding ids for owners
// and attaching id references to all stuff
migrate(function(query, type) {
    query("ALTER TABLE tbl_businesses ADD COLUMN `ownerid` INT(255) NOT NULL DEFAULT -1;");

    local data = {};

    Account.findAll(function(err, accounts) {
        data.accounts <- accounts;
    });

    Character.findAll(function(err, characters) {
        data.characters <- characters;
    });

    Vehicle.findAll(function(err, vehicles) {
        data.vehicles <- vehicles;
    });

    Business.findAll(function(err, businesses) {
        data.businesses <- businesses;
    });

    foreach (idx1, character in data.characters) {

        // update references to accountid in character
        foreach (idx2, account in data.accounts) {
            if (character.name == account.username) {
                character.accountid = account.id;
                character.save();
            }
        }

        // update vehicle references
        foreach (idx2, vehicle in data.vehicles) {
            if (character.name == vehicle.owner) {
                vehicle.ownerid = character.id;
                // vehicle.owner   = character.getName();
                vehicle.save();
            }
        }

        // update business references
        foreach (idx2, business in data.businesses) {
            if (character.name == business.owner) {
                business.ownerid = character.id;
                // business.owner   = character.getName();
                business.save();
            }
        }
    }
});


// 09.01.2017
// added migration for police ticket
migrate(function(query, type) {
    query("ALTER TABLE tbl_policetickets ADD COLUMN `who` VARCHAR(255) NOT NULL DEFAULT '';");
});

//12.01.2017
//added owner in bans table
migrate(function(query, type) {
    query("ALTER TABLE adm_bans ADD COLUMN `owner` VARCHAR(255) NOT NULL DEFAULT '';");
});

//12.01.2017
//added moderator lvl in character table
migrate(function(query, type) {
    query("ALTER TABLE tbl_characters ADD COLUMN `mlvl` INT(255) NOT NULL DEFAULT 0;");
});

// 24.02.2017
// added character hunger and thirst
migrate(function(query, type) {
    query("ALTER TABLE tbl_characters ADD COLUMN `hunger` FLOAT NOT NULL DEFAULT 100.0;");
    query("ALTER TABLE tbl_characters ADD COLUMN `thirst` FLOAT NOT NULL DEFAULT 100.0;");
});

// 26.02.2017
// added fraction role salary
migrate(function(query, type) {
    // query("ALTER TABLE tbl_fraction_role ADD COLUMN `salary` FLOAT NOT NULL DEFAULT 0.0;");
});

// 26.02.2017
// added fraction role salary
migrate(function(query, type) {
    query("ALTER TABLE tbl_fraction_roles ADD COLUMN `salary` FLOAT NOT NULL DEFAULT 0.0;");
});

// moved migrations
migrate(@(a,b) 1);
migrate(@(a,b) 1);
migrate(@(a,b) 1);
migrate(@(a,b) 1);
migrate(@(a,b) 1);
migrate(@(a,b) 1);
migrate(@(a,b) 1);

// 07.05.2017
// added data field for Character, Fraction, FractionRole
migrate(function(query, type) {
    query("ALTER TABLE tbl_characters ADD COLUMN `data` TEXT NOT NULL DEFAULT '{}';");
    query("ALTER TABLE tbl_fractions ADD COLUMN `data` TEXT NOT NULL DEFAULT '{}';");
    query("ALTER TABLE tbl_fraction_roles ADD COLUMN `data` TEXT NOT NULL DEFAULT '{}';");
});

// 13.05.2017
// added vehicle state field
migrate(function(query, type) {
    query("ALTER TABLE tbl_vehicles ADD COLUMN `reserved` INT(5) NOT NULL DEFAULT 0;");
});

// 10.05.2017
// added Police 2.0
migrate(function(query, type) {
    local fraction = fraction__Create("Police", "police", "police");
    fraction__Role(fraction, "Police Chief"    ,    "police.chief"            ,  FRACTION_FULL_PERMISSION);
    fraction__Role(fraction, "Assist. chief"   ,    "police.assistantchief"   ,  FRACTION_FULL_PERMISSION);
    fraction__Role(fraction, "Detective"       ,    "police.detective"        ,  FRACTION_FULL_PERMISSION);
    fraction__Role(fraction, "Captain"         ,    "police.сaptain"          ,  FRACTION_FULL_PERMISSION);
    fraction__Role(fraction, "Lieutenant"      ,    "police.lieutenant"       ,  FRACTION_FULL_PERMISSION);
    fraction__Role(fraction, "Sergeant"        ,    "police.sergeant"         ,  FRACTION_FULL_PERMISSION);
    fraction__Role(fraction, "Patrol"          ,    "police.patrol"           ,  FRACTION_FULL_PERMISSION);
    fraction__Role(fraction, "Cadet"           ,    "police.cadet"            ,  FRACTION_FULL_PERMISSION);
});

// 11.05.2017
// added data,updated field for FractionMember
migrate(function(query, type) {
    query("ALTER TABLE tbl_fraction_members ADD COLUMN `data` TEXT NOT NULL DEFAULT '{}';");
    query("ALTER TABLE tbl_fraction_members ADD COLUMN `updated` INT(255) NOT NULL DEFAULT 0;");
});

// 10.12.2017
// added data field for Businesses
migrate(function(query, type) {
    query("ALTER TABLE tbl_businesses ADD COLUMN `alias` TEXT NOT NULL DEFAULT '';");
    query("ALTER TABLE tbl_businesses ADD COLUMN `data` TEXT NOT NULL DEFAULT '{}';");
});


// 12.01.2019
// added data field for Businesses
migrate(function(query, type) {
    query("ALTER TABLE tbl_vehicles ADD COLUMN `data` TEXT NOT NULL DEFAULT '{}';");
});
