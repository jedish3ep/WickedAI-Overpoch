//Medium Gun Box

_box = _this select 0;
_box setVariable ["ObjectID","1",true];
_box setVariable ["permaLoot",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_box];

clearWeaponCargoGlobal _box;
clearMagazineCargoGlobal _box;

// RIFLES
_box addWeaponCargoGlobal ["G36C", 1];
_box addWeaponCargoGlobal ["M4A1_AIM_CAMO", 1];
_box addWeaponCargoGlobal ["BAF_L85A2_RIS_CWS", 1];
_box addWeaponCargoGlobal ["AK_47_M", 1];
_box addWeaponCargoGlobal ["RPK_74", 1];
_box addWeaponCargoGlobal ["M4A1_AIM_SD_camo", 1];
_box addWeaponCargoGlobal ["M110_NVG_EP1", 1];
_box addWeaponCargoGlobal ["AA12_PMC", 1]; 

// PISTOLS
_box addWeaponCargoGlobal ["glock17_EP1", 1];
_box addWeaponCargoGlobal ["UZI_EP1", 1];

// AMMUNITION
_box addMagazineCargoGlobal ["30Rnd_556x45_G36", 8];
_box addMagazineCargoGlobal ["30Rnd_556x45_Stanag", 12];
_box addMagazineCargoGlobal ["30Rnd_762x39_AK47", 8];
_box addMagazineCargoGlobal ["30Rnd_556x45_Stanag", 8];
_box addMagazineCargoGlobal ["75Rnd_545x39_RPK", 4];
_box addMagazineCargoGlobal ["30Rnd_556x45_StanagSD", 8];
_box addMagazineCargoGlobal ["20Rnd_762x51_B_SCAR", 4];
_box addMagazineCargoGlobal ["20Rnd_B_AA12_74Slug", 4];
_box addMagazineCargoGlobal ["20Rnd_B_AA12_HE", 2];


_box addMagazineCargoGlobal ["17Rnd_9x19_glock17", 6];
_box addMagazineCargoGlobal ["30Rnd_9x19_UZI", 6];

// ITEMS
_box addWeaponCargoGlobal ["ItemToolbox", 1];
_box addWeaponCargoGlobal ["ItemEtool", 2];

// CLOTHING
_box addMagazineCargoGlobal ["Skin_Soldier1_DZ", 1];
_box addMagazineCargoGlobal ["Skin_Camo1_DZ", 2];

// BACKPACKS
_box addBackpackCargoGlobal ["DZ_LargeGunBag_EP1", 1];
