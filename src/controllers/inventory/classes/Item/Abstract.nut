class Item.Abstract extends ORM.JsonEntity
{
    static classname = "Item.Abstract";
    static table = "tbl_items";

    fields = [
        ORM.Field.Integer({ name = "type", value = 0 }),
        ORM.Field.Integer({ name = "state", value = Item.State.NONE }),
        ORM.Field.Integer({ name = "slot", value = 0 }),
        ORM.Field.Integer({ name = "decay", value = 0 }),
        ORM.Field.Integer({ name = "parent", value = 0}),
        ORM.Field.Float  ({ name = "amount", value = 0.0}),
        ORM.Field.Integer({ name = "created", value = 0 }),
    ];

    traits = [
        ORM.Trait.Positionable(),
    ];

    handsOnly = false;
    destroyOnDrop = false;
    stackable   = false;
    maxstack    = 0;
    volume      = 0.0;
    unitvolume  = 0.0;
    capacity    = 0.0;
    default_decay = 600;

    static name = "Default Item"; // ?

    constructor () {
        base.constructor();

        if (this.created == 0) {
            this.created = getTimestamp();
        }
    }

    function pick(playerid, inventory) {
        if (inventory instanceof PlayerHandsContainer) {
            msg(playerid, "inventory.pickupinhands", [ plocalize(playerid, this.classname )], CL_SUCCESS);
        }
        else if (inventory instanceof PlayerItemContainer) {
            msg(playerid, "inventory.pickedup", [ plocalize(playerid, this.classname )], CL_SUCCESS);
        }
    }

    function use(playerid, inventory) {
        dbg("classes/Item.nut: trying to use item. Make sure you've overriden this method for your item", this.classname, getIdentity(playerid));
    }

    function transfer(playerid, inventory, targetid) {
        sendMsgToAllInRadius(playerid, "inventory.transfered", [ getPlayerName(playerid), getPlayerName(targetid), plocalize(playerid, this.classname ) ], CL_CHAT_ME, NORMAL_RADIUS);
        sendMsgToAllInRadius(targetid, "inventory.transferedfrom", [ getPlayerName(targetid), getPlayerName(playerid), plocalize(playerid, this.classname ) ], CL_CHAT_ME, NORMAL_RADIUS);
    }

    function destroy(playerid, inventory) {
        msg(playerid, "inventory.destroyed", [ plocalize(playerid, this.classname )], CL_FLAMINGO);
    }

    function move(playerid, inventory) {
        // nothing here
    }

    function drop(playerid, inventory) {
        msg(playerid, "inventory.dropped", [ plocalize(playerid, this.classname )], CL_SUCCESS);
    }

    function calculateVolume() {
        return this.volume;
    }

    function serialize() {
        local data = {
            classname   = this.classname,
            type        = this.getType(),
            slot        = this.slot,
            amount      = this.amount,
            volume      = this.calculateVolume(),
            id          = this.id,
        };

        if (this.x != 0.0 || this.y != 0.0 || this.z != 0.0) {
            data.x <- this.x;
            data.y <- this.y;
            data.z <- this.z;
        }

        return data;
        // return JSONEncoder.encode(data);
    }

    function canBeDestroyed() {
        return true;
    }

    static function getType() {
        return "Item.Abstract";
    }
}
