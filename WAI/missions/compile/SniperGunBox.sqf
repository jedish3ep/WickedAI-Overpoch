//Sniper Gun Box

_box = _this select 0;
_box setVariable ["ObjectID","1",true];
_box setVariable ["permaLoot",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_box];

clearWeaponCargoGlobal _box;
clearMagazineCargoGlobal _box;

// RIFLES
_box addWeaponCargoGlobal ["DMR_DZ", 1];
_box addWeaponCargoGlobal ["M40A3", 1];
_box addWeaponCargoGlobal ["M24_des_EP1", 1];
_box addWeaponCargoGlobal ["SVD", 1];
_box addWeaponCargoGlobal ["BAF_LRR_scoped", 1];
_box addWeaponCargoGlobal ["M110_NVG_EP1", 1];
_box addWeaponCargoGlobal ["KSVK_DZE", 1];
// PISTOLS
_box addWeaponCargoGlobal ["M9SD", 2];
// AMMUNITION
_box addMagazineCargoGlobal ["15Rnd_9x19_M9SD", 15];
_box addMagazineCargoGlobal ["10Rnd_762x54_SVD", 8];
_box addMagazineCargoGlobal ["5Rnd_762x51_M24", 12];
_box addMagazineCargoGlobal ["20Rnd_762x51_DMR", 6];
_box addMagazineCargoGlobal ["5Rnd_86x70_L115A1", 5];
_box addMagazineCargoGlobal ["20Rnd_762x51_B_SCAR", 5];
_box addMagazineCargoGlobal ["5Rnd_127x108_KSVK", 4];
//TOOLS
_box addWeaponCargoGlobal ["Binocular_Vector", 3];
// CLOTHING
_box addMagazineCargoGlobal ["Skin_Sniper1_DZ", 3];
// BACKPACKS
_box addBackpackCargoGlobal ["DZ_LargeGunBag_EP1", 1];

BoxRandomizer=floor(random 100);
	if (BoxRandomizer == 99) then {
		_box addWeaponCargoGlobal ["BAF_AS50_scoped",1];
		_box addmagazineCargoGlobal ["5Rnd_127x99_AS50", 10];
		};
	if (BoxRandomizer == 66) then {
		_box addWeaponCargoGlobal ["BAF_AS50_TWS",1];
		_box addmagazineCargoGlobal ["5Rnd_127x99_AS50", 5];
		};
	if (BoxRandomizer == 33) then {
		_box addWeaponCargoGlobal ["USSR_cheytacM200",1];
		_box addWeaponCargoGlobal ["USSR_cheytacM200_sd",1];
		_box addmagazineCargoGlobal ["USSR_5Rnd_408", 25];
		};