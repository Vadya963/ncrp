class VehicleComponent.Hull extends VehicleComponent
{
    static classname = "VehicleComponent.Hull";

    limit = 1;

    constructor(data) {
        dbg("called hull creation");
        base.constructor(data);

        if (this.data == null) {
            this.data = {model = 0, color1 = 0, color2 = 0, dirt=1.0};
        }
    }

    function correct() {
        local c1 = toRGBA(this.data.color1);
        local c2 = toRGBA(this.data.color2);

        setVehicleColour(this.parent.vehicleid, c1[0], c1[1], c1[2], c2[0], c2[1], c2[2]);

        return true;
    }

    function getModel() {
        return this.data.model;
    }

    function setModel(model, respawn = false) {
        this.data.model = model;

        if (this.parent.state == Vehicle.State.Spawned && respawn) {
            this.parent.despawn();

            // re-spawn vehicle with delay
            local self = this;
            delayedFunction(500, function(){
                self.parent.spawn();
            })
        }

        return true;//this;
    }

    function getDirt() {
        return this.data.dirt;
    }

    function setDirt(value) {
        this.data.model = model;

        if (this.parent.state == Vehicle.State.Spawned) {
            setVehicleDirtLevel(this.parent.vehicleid, this.data.dirt);
        }

        return true;//this;
    }

    function repair() {
        repairVehicle( this.parent.vehicleid );
    }
}
