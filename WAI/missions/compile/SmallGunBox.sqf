//Small Gun Box

_box = _this select 0;
_box setVariable ["ObjectID","1",true];
_box setVariable ["permaLoot",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_box];

clearWeaponCargoGlobal _box;
clearMagazineCargoGlobal _box;

// RIFLES
_box addWeaponCargoGlobal ["m8_carbine", 1];
_box addWeaponCargoGlobal ["AKS_74_kobra", 1];
_box addWeaponCargoGlobal ["LeeEnfield", 1];
_box addWeaponCargoGlobal ["Remington870_lamp", 1];
_box addWeaponCargoGlobal ["SVD", 1];
_box addWeaponCargoGlobal ["SCAR_H_LNG_Sniper_SD", 1];
_box addWeaponCargoGlobal ["M60A4_EP1_DZE", 1];

// PISTOLS
_box addWeaponCargoGlobal ["glock17_EP1", 1];
_box addWeaponCargoGlobal ["Colt1911", 1];

// AMMUNITION
_box addMagazineCargoGlobal ["20Rnd_556x45_Stanag", 4];
_box addMagazineCargoGlobal ["30Rnd_545x39_AK", 4];
_box addMagazineCargoGlobal ["10x_303", 10];
_box addMagazineCargoGlobal ["8Rnd_B_Beneli_Pellets", 4];
_box addMagazineCargoGlobal ["10Rnd_762x54_SVD", 4];
_box addMagazineCargoGlobal ["20Rnd_762x51_SB_SCAR", 4];
_box addMagazineCargoGlobal ["100Rnd_762x51_M240", 2];

_box addMagazineCargoGlobal ["17Rnd_9x19_glock17", 8];
_box addMagazineCargoGlobal ["7Rnd_45ACP_1911", 8];

// TOOLS
_box addWeaponCargoGlobal ["ItemToolbox", 2];
_box addWeaponCargoGlobal ["NVGoggles", 1];
_box addWeaponCargoGlobal ["ItemGPS", 1];

// BACKPACKS
_box addBackpackCargoGlobal ["DZ_British_ACU", 1];
