class PlayerItemContainer extends ItemContainer
{
    static classname = "PlayerItemContainer";

    id      = null;
    parent  = null;
    limit   = 35;

    sizeX = 5;
    sizeY = 6;

    /**
     * Create new instance
     * @return {PlayerContainer}
     */
    constructor(playerid) {
        base.constructor();
        this.__ref = Item.Abstract;

        this.id     = md5(this.tostring());
        this.parent = playerid;
    }
}
