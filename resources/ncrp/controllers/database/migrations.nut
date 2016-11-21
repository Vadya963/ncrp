local __migrations = [];

// helper functios
function migrate(callback) {
    __migrations.push(callback);
}

function applyMigrations(connection) {
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
            __migrations[migration.current++](connection);
            log("[database][migration] applying migration #" + migration.current);
        }

        migration.save();
    });
}

/**
 * Apply your migrations below
 */

// 21.11.16
// added deposit field for character
migrate(function(connection) {
    connection.query("ALTER TABLE tbl_characters ADD COLUMN `deposit` FLOAT NOT NULL DEFAULT 0.0;");
});

