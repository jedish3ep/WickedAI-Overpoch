//Large Gun Box

_box = _this select 0;
_box setVariable ["ObjectID","1",true];
_box setVariable ["permaLoot",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_box];

clearWeaponCargoGlobal _box;
clearMagazineCargoGlobal _box;

// RIFLES
_box addWeaponCargoGlobal ["AK_74_GL", 1];
_box addWeaponCargoGlobal ["G36A_camo", 1];
_box addWeaponCargoGlobal ["DMR_DZ", 1];
_box addWeaponCargoGlobal ["M14_EP1", 1];
_box addWeaponCargoGlobal ["M16A4_GL", 1];
_box addWeaponCargoGlobal ["BAF_L85A2_RIS_CWS", 1];
_box addWeaponCargoGlobal ["M249_DZ", 1];
_box addWeaponCargoGlobal ["M24", 1];
_box addWeaponCargoGlobal ["M40A3", 1];
_box addWeaponCargoGlobal ["M4A3_RCO_GL_EP1", 1];
_box addWeaponCargoGlobal ["M4SPR", 1];
_box addWeaponCargoGlobal ["AA12_PMC", 1];
_box addWeaponCargoGlobal ["KSVK_DZE", 1];

// PISTOLS
_box addWeaponCargoGlobal ["glock17_EP1", 1];
_box addWeaponCargoGlobal ["UZI_EP1", 1];
_box addWeaponCargoGlobal ["Colt1911", 1];
_box addWeaponCargoGlobal ["bizon", 1];

// AMMUNITION
_box addMagazineCargoGlobal ["30Rnd_762x39_AK47", 8];
_box addMagazineCargoGlobal ["30Rnd_556x45_G36", 8];
_box addMagazineCargoGlobal ["20Rnd_762x51_DMR", 8];
_box addMagazineCargoGlobal ["20Rnd_762x51_DMR", 4];
_box addMagazineCargoGlobal ["30Rnd_556x45_Stanag", 12];
_box addMagazineCargoGlobal ["200Rnd_556x45_M249", 8];
_box addMagazineCargoGlobal ["5Rnd_762x51_M24", 5];
_box addMagazineCargoGlobal ["5Rnd_762x51_M24", 2];
_box addMagazineCargoGlobal ["30Rnd_556x45_Stanag", 8];
_box addMagazineCargoGlobal ["30Rnd_556x45_Stanag", 8];
_box addMagazineCargoGlobal ["20Rnd_B_AA12_74Slug", 8];
_box addMagazineCargoGlobal ["5Rnd_127x108_KSVK", 5];

_box addMagazineCargoGlobal ["17Rnd_9x19_glock17", 12];
_box addMagazineCargoGlobal ["30Rnd_9x19_UZI", 12];
_box addMagazineCargoGlobal ["7Rnd_45ACP_1911", 8];
_box addMagazineCargoGlobal ["64Rnd_9x19_Bizon", 6];

// TOOLS
_box addWeaponCargoGlobal ["ItemToolbox", 1];
_box addWeaponCargoGlobal ["ItemEtool", 1];
_box addWeaponCargoGlobal ["ItemCrowbar", 2];
_box addWeaponCargoGlobal ["ItemKnife", 1];

// BACKPACKS
_box addBackpackCargoGlobal ["DZ_LargeGunBag_EP1", 1];
