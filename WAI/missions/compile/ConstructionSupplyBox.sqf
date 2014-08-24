//Contruction Supply Box

_box = _this select 0;
_box setVariable ["ObjectID","1",true];
_box setVariable ["permaLoot",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_box];

clearWeaponCargoGlobal _box;
clearMagazineCargoGlobal _box;

// CONSTRUCTION MATERIALS
_box addMagazineCargoGlobal ["CinderBlocks", 16];
_box addMagazineCargoGlobal ["MortarBucket", 4];
_box addMagazineCargoGlobal ["PartPlywoodPack", 8];
_box addMagazineCargoGlobal ["cinder_garage_kit", 1];
_box addMagazineCargoGlobal ["PartGeneric", 16];
_box addMagazineCargoGlobal ["ItemPole", 8];
_box addMagazineCargoGlobal ["ItemSandbag", 9];
_box addMagazineCargoGlobal ["ItemTankTrap", 8];
_box addMagazineCargoGlobal ["forest_large_net_kit", 1];
_box addMagazineCargoGlobal ["ItemComboLock", 1];
_box addMagazineCargoGlobal ["cinder_wall_kit", 1];
_box addMagazineCargoGlobal ["PartPlankPack", 9];
_box addMagazineCargoGlobal ["wood_ramp_kit", 1];
_box addMagazineCargoGlobal ["metal_floor_kit", 1];
_box addMagazineCargoGlobal ["metal_panel_kit", 1];
_box addMagazineCargoGlobal ["ItemWoodFloor", 1];

// TOOLS
_box addWeaponCargoGlobal ["ItemToolbox", 1];
_box addWeaponCargoGlobal ["ItemEtool", 1];
_box addWeaponCargoGlobal ["ItemCrowbar", 1];
_box addWeaponCargoGlobal ["ItemKnife", 1];
_box addWeaponCargoGlobal ["ItemSledge", 1];