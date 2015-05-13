private ["_box"];

_box = _this select 0;

_box setVariable ["ObjectID","1",true];
_box setVariable ["permaLoot",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_box];

clearWeaponCargoGlobal _box;
clearMagazineCargoGlobal _box;
clearBackpackCargoGlobal _box;

_box addBackpackCargoGlobal ["DZ_LargeGunBag_EP1", 1];
_box addWeaponCargoGlobal ["DMR_DZ", 2];
_box addWeaponCargoGlobal ["M4A3_RCO_GL_EP1", 1];
_box addWeaponCargoGlobal ["M110_NVG_EP1", 1];
_box addWeaponCargoGlobal ["AK_47_M", 1];
_box addWeaponCargoGlobal ["UZI_SD_EP1", 1];
_box addWeaponCargoGlobal ["bizon_silenced", 1];
_box addMagazineCargoGlobal ["20Rnd_762x51_DMR", 10];
_box addMagazineCargoGlobal ["30Rnd_556x45_Stanag", 10];
_box addMagazineCargoGlobal ["20Rnd_762x51_B_SCAR", 10];
_box addMagazineCargoGlobal ["30Rnd_762x39_AK47", 10];
_box addMagazineCargoGlobal ["30Rnd_9x19_UZI_SD", 10];
_box addMagazineCargoGlobal ["64Rnd_9x19_SD_Bizon", 10];
_box addWeaponCargoGlobal ["Binocular_Vector", 2];
_box addWeaponCargoGlobal ["NVGoggles", 2];
_box addWeaponCargoGlobal ["ItemGPS", 1];
_box addMagazineCargoGlobal ["Skin_Sniper1_DZ", 2];