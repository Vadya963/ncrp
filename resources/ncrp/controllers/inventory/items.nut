enum ITEM_TYPE {
    NONE,
    FOOD,
    DRUNK,
    CLOTHES,
    OTHER,
    WEAPON,
    AMMO,
};

ITEM_STATE <- {
    NONE            = 0,
    GROUND          = 1,
    PLAYER_HAND     = 2,
    PLAYER_INV      = 3,
    VEHICLE_INV     = 4,
    BUILDING_INV    = 5,
};


// big separate entities
include("controllers/inventory/classes/Item.nut");
include("controllers/inventory/classes/Weapon.nut");
include("controllers/inventory/classes/Ammo.nut");

// small similar entities
include("controllers/inventory/classes/weapons.nut");

local items = [
    Item.Revolver12,
    Item.MauserC96,
    Item.ColtM1911A1,
    Item.ColtM1911Spec,
    Item.Revolver19,
    Item.MK2,
    Item.Remington870,
    Item.M3GreaseGun,
    Item.MP40,
    Item.Thompson1928,
    Item.M1A1Thompson,
    Item.Beretta38A,
    Item.MG42,
    Item.M1Garand,
    Item.Kar98k,
    Item.Molotov,
    Item.Ammo45ACP,
    Item.Ammo357magnum,
    Item.Ammo12mm,
    Item.Ammo9x19mm,
    Item.Ammo792x57mm,
    Item.Ammo762x63mm,
    Item.Ammo38Special,
];







//{id, weight, type, stackable,img }

// local items = [
//     { id = 0,   weight = 0.0,   type = ITEM_TYPE.NONE,    stackable = false, maxstack = 0, expiration = 0, img = "none.jpg"},
//     { id = 1,   weight = 0.0,   type = ITEM_TYPE.OTHER,   stackable = false, maxstack = 0, expiration = 0, img = "money.jpg"},
// /* ---------------------------------------------------------------WEAPONS/AMMO--------------------------------------------------------------------------------------- */
//     { id = 2,   weight = 0.5,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "12Revolver.jpg"},
//     { id = 3,   weight = 1.2,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "MauserC96.jpg"},
//     { id = 4,   weight = 1.1,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "ColtM1911A1.jpg"},
//     { id = 5,   weight = 1.5,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "ColtM1911Spec.jpg"},
//     { id = 6,   weight = 0.9,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "19Revolver.jpg"},
//     { id = 7,   weight = 0.6,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "MK2.jpg"},
//     { id = 8,   weight = 3.6,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "Remington870.jpg"},
//     { id = 9,   weight = 3.5,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "M3GreaseGun.jpg"},
//     { id = 10,  weight = 4.7,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "MP40.jpg"},
//     { id = 11,  weight = 4.9,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "Thompson1928.jpg"},
//     { id = 12,  weight = 4.8,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "M1A1Thompson.jpg"},
//     { id = 13,  weight = 3.3,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "Beretta38A.jpg"},
//     { id = 14,  weight = 11.5,  type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "MG42.jpg"},
//     { id = 15,  weight = 4.3,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "M1Garand.jpg"},
//     { id = 16,  weight = 0.007, type = ITEM_TYPE.AMMO,    stackable = true,  maxstack = 0, expiration = 0, img = "38Special.jpg"},
//     { id = 17,  weight = 3.9,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "Kar98k.jpg"},
//     { id = 18,  weight = 0.012, type = ITEM_TYPE.AMMO,    stackable = true,  maxstack = 0, expiration = 0, img = "45ACP.jpg"},
//     { id = 19,  weight = 0.01,  type = ITEM_TYPE.AMMO,    stackable = true,  maxstack = 0, expiration = 0, img = "357magnum.jpg"},
//     { id = 20,  weight = 0.017, type = ITEM_TYPE.AMMO,    stackable = true,  maxstack = 0, expiration = 0, img = "12mm.jpg"},
//     { id = 21,  weight = 1.0,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "Molotov.jpg"},
//     { id = 22,  weight = 0.0,   type = ITEM_TYPE.AMMO,    stackable = true,  maxstack = 0, expiration = 0, img = "9x19mm.jpg"},
//     { id = 23,  weight = 0.012, type = ITEM_TYPE.AMMO,    stackable = true,  maxstack = 0, expiration = 0, img = "7,92x57mm.jpg"},
//     { id = 24,  weight = 0.01,  type = ITEM_TYPE.AMMO,    stackable = true,  maxstack = 0, expiration = 0, img = "7,62x63mm.jpg"},
// /* ---------------------------------------------------------------FOOD/DRUNK--------------------------------------------------------------------------------------- */
//     /*{ id = 25,  weight = 0.01,  type = ITEM_TYPE.FOOD,    stackable = true,  maxstack = 0, expiration = 0, img = ""},
//     { id = 26,  weight = 0.01,  type = ITEM_TYPE.FOOD,    stackable = true,  maxstack = 0, expiration = 0, img = ""},
//     { id = 27,  weight = 0.01,  type = ITEM_TYPE.DRUNK,    stackable = true,  maxstack = 0, expiration = 0, img = ""},
//     { id = 28,  weight = 0.01,  type = ITEM_TYPE.FOOD,    stackable = true,  maxstack = 0, expiration = 0, img = ""},
//     { id = 29,  weight = 0.01,  type = ITEM_TYPE.FOOD,    stackable = true,  maxstack = 0, expiration = 0, img = ""},
//     { id = 30,  weight = 0.01,  type = ITEM_TYPE.DRUNK,    stackable = true,  maxstack = 0, expiration = 0, img = ""},*/
// ];



// function getIdxFromID(id){
//     foreach (idx, value in items) {
//             if(value.id == id.tointeger()){
//                 return value.id;
//             }
//         }
// }

// function getItemImageById (itemid) {
//     local idx = getIdxFromID(itemid);
//     return items[itemid].img;
// }

// function getItemWeigtById (itemid) {
//     local idx = getIdxFromID(itemid);
//     return items[itemid].weight;
// }

// function getItemTypeById (itemid) {
//     local idx = getIdxFromID(itemid);
//     return items[itemid].type;
// }

// function isItemStackable (itemid) {
//     local idx = getIdxFromID(itemid);
//     return items[itemid].stackable;
// }



// /*
// local itemsDescription = [

// ];
//  */

// local weaponsProp = [
//     { id = 2,  capacity = },
//     { id = 3,  capacity = },
//     { id = 4,  capacity = },
//     { id = 5,  capacity = },
//     { id = 6,  capacity = },
//     { id = 7,  capacity = },
//     { id = 8,  capacity = },
//     { id = 9,  capacity = },
//     { id = 10, capacity = },
//     { id = 11, capacity = },
//     { id = 12, capacity = },
//     { id = 13, capacity = },
//     { id = 14, capacity = },
//     { id = 15, capacity = },
//     { id = 17, capacity = },
//     { id = 21, capacity = },
// ];

// local ammoProp = [
// ];
