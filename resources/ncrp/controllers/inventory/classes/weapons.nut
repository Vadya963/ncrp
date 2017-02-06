/**
 * Weapons
 */
class Item.Revolver12       extends Item.Weapon { static classname = "Item.Revolver12";     constructor () { base.constructor(); this.weight = 0.200; this.model =  2; this.ammo = "Item.Ammo38Special"; this.capacity =   6 }}
class Item.MauserC96        extends Item.Weapon { static classname = "Item.MauserC96";      constructor () { base.constructor(); this.weight = 1.200; this.model =  3; this.ammo = "Item.Ammo45ACP";     this.capacity =  10 }}
class Item.ColtM1911A1      extends Item.Weapon { static classname = "Item.ColtM1911A1";    constructor () { base.constructor(); this.weight = 1.100; this.model =  4; this.ammo = "Item.Ammo45ACP";     this.capacity =   7 }}
class Item.ColtM1911Spec    extends Item.Weapon { static classname = "Item.ColtM1911Spec";  constructor () { base.constructor(); this.weight = 1.500; this.model =  5; this.ammo = "Item.Ammo45ACP";     this.capacity =  23 }}
class Item.Revolver19       extends Item.Weapon { static classname = "Item.Revolver19";     constructor () { base.constructor(); this.weight = 0.900; this.model =  6; this.ammo = "Item.Ammo357magnum"; this.capacity =   6 }}
class Item.MK2              extends Item.Weapon { static classname = "Item.MK2";            constructor () { base.constructor(); this.weight = 0.600; this.model =  7; this.ammo = "none";               this.capacity =   1 }}
class Item.Remington870     extends Item.Weapon { static classname = "Item.Remington870";   constructor () { base.constructor(); this.weight = 3.600; this.model =  8; this.ammo = "Item.Ammo12mm";      this.capacity =   8 }}
class Item.M3GreaseGun      extends Item.Weapon { static classname = "Item.M3GreaseGun";    constructor () { base.constructor(); this.weight = 3.500; this.model =  9; this.ammo = "Item.Ammo45ACP";     this.capacity =  30 }}
class Item.MP40             extends Item.Weapon { static classname = "Item.MP40";           constructor () { base.constructor(); this.weight = 4.700; this.model = 10; this.ammo = "Item.Ammo9x19mm";    this.capacity =  32 }}
class Item.Thompson1928     extends Item.Weapon { static classname = "Item.Thompson1928";   constructor () { base.constructor(); this.weight = 4.900; this.model = 11; this.ammo = "Item.Ammo45ACP";     this.capacity =  50 }}
class Item.M1A1Thompson     extends Item.Weapon { static classname = "Item.M1A1Thompson";   constructor () { base.constructor(); this.weight = 4.800; this.model = 12; this.ammo = "Item.Ammo45ACP";     this.capacity =  30 }}
class Item.Beretta38A       extends Item.Weapon { static classname = "Item.Beretta38A";     constructor () { base.constructor(); this.weight = 3.300; this.model = 13; this.ammo = "Item.Ammo9x19mm";    this.capacity =  30 }}
class Item.MG42             extends Item.Weapon { static classname = "Item.MG42";           constructor () { base.constructor(); this.weight = 11.50; this.model = 14; this.ammo = "Item.Ammo792x57mm";  this.capacity = 100 }}
class Item.M1Garand         extends Item.Weapon { static classname = "Item.M1Garand";       constructor () { base.constructor(); this.weight = 4.300; this.model = 15; this.ammo = "Item.Ammo792x63mm";  this.capacity =   8 }}
class Item.Kar98k           extends Item.Weapon { static classname = "Item.Kar98k";         constructor () { base.constructor(); this.weight = 3.900; this.model = 17; this.ammo = "Item.Ammo792x57mm";  this.capacity =   5 }}
class Item.Molotov          extends Item.Weapon { static classname = "Item.Molotov";        constructor () { base.constructor(); this.weight = 1.000; this.model = 21; this.ammo = "none";               this.capacity =   1 }}

/**
 * Ammo
 */
class Item.Ammo45ACP        extends Item.Ammo   { static classname = "Item.Ammo45ACP";      constructor () { base.constructor(); this.weight = 0.012 }}
class Item.Ammo357magnum    extends Item.Ammo   { static classname = "Item.Ammo357magnum";  constructor () { base.constructor(); this.weight = 0.010 }}
class Item.Ammo12mm         extends Item.Ammo   { static classname = "Item.Ammo12mm";       constructor () { base.constructor(); this.weight = 0.017 }}
class Item.Ammo9x19mm       extends Item.Ammo   { static classname = "Item.Ammo9x19mm";     constructor () { base.constructor(); this.weight = 0.010 }}
class Item.Ammo792x57mm     extends Item.Ammo   { static classname = "Item.Ammo792x57mm";   constructor () { base.constructor(); this.weight = 0.012 }}
class Item.Ammo762x63mm     extends Item.Ammo   { static classname = "Item.Ammo762x63mm";   constructor () { base.constructor(); this.weight = 0.010 }}
class Item.Ammo38Special    extends Item.Ammo   { static classname = "Item.Ammo38Special";  constructor () { base.constructor(); this.weight = 0.007 }}
