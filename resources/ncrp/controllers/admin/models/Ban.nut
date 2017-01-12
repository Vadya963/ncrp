class Ban extends ORM.Entity {

    static classname = "Ban";
    static table = "adm_bans";

    static fields = [
        ORM.Field.String({ name = "type", value = "default" }),
        ORM.Field.String({ name = "name", value = "" }),
        ORM.Field.String({ name = "serial", value = "" }),
        ORM.Field.String({ name = "reason", value = "" }),
        ORM.Field.String({ name = "banowner" value = ""}),
        ORM.Field.Integer({ name = "amount" }),
        ORM.Field.Integer({ name = "until" }),
        ORM.Field.Integer({ name = "created" }),
    ];

    constructor (...) {
        base.constructor();

        if (!vargv.len()) return;

        // put data
        this.banowner = vargv[0];
        this.name    = vargv[1];
        this.serial  = vargv[2];
        this.created = getTimestamp();
        this.amount  = vargv[3];
        this.until   = this.created.tointeger() + this.amount.tointeger();
        this.reason  = vargv[4];
    }
}
