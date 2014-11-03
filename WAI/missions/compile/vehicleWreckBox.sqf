_box = _this select 0;
_box setVariable ["ObjectID","1",true];
_box setVariable ["permaLoot",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_box];

clearWeaponCargoGlobal _box;
clearMagazineCargoGlobal _box;
clearBackpackCargoGlobal _box;

_box addBackpackCargoGlobal ["DZ_LargeGunBag_EP1", 1];

_box addWeaponCargoGlobal ["ItemToolbox", 4];
_box addWeaponCargoGlobal ["ItemCrowbar", 4];

_box addMagazineCargoGlobal ["ItemJerrycan", 5];
_box addMagazineCargoGlobal ["PartEngine", 10];
_box addMagazineCargoGlobal ["PartFueltank", 10];
_box addMagazineCargoGlobal ["PartGeneric", 20];
_box addMagazineCargoGlobal ["PartGlass", 8];
_box addMagazineCargoGlobal ["PartVRotor", 2];
_box addMagazineCargoGlobal ["PartWheel", 16];
