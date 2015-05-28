_box = _this select 0;
_box setVariable ["ObjectID","1",true];
_box setVariable ["permaLoot",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_box];

clearWeaponCargoGlobal _box;
clearMagazineCargoGlobal _box;
clearBackpackCargoGlobal _box;
_box addBackpackCargoGlobal ["DZ_LargeGunBag_EP1", 1];

_boxRand=floor(random 3);
	if (_boxRand == 0) then {
		_box addWeaponCargoGlobal ["DMR_DZ", 1];
		_box addWeaponCargoGlobal ["BAF_LRR_scoped_W", 1];
		_box addWeaponCargoGlobal ["M4A3_RCO_GL_EP1", 1];
		_box addWeaponCargoGlobal ["M110_NVG_EP1", 1];
		_box addWeaponCargoGlobal ["Mk_48_DES_EP1", 1];
		_box addWeaponCargoGlobal ["M14_EP1", 1];
		_box addWeaponCargoGlobal ["M24", 1];
		_box addWeaponCargoGlobal ["M40A3", 1];
		_box addWeaponCargoGlobal ["SCAR_L_CQC_CCO_SD", 1];
		_box addWeaponCargoGlobal ["SCAR_H_LNG_Sniper_SD", 1];
		_box addWeaponCargoGlobal ["M60A4_EP1_DZE", 1];
		_box addWeaponCargoGlobal ["AK_47_M", 1];
		_box addWeaponCargoGlobal ["AA12_PMC", 1]; 
		_box addWeaponCargoGlobal ["MAAWS", 1];
		_box addMagazineCargoGlobal ["20Rnd_762x51_DMR", 5];
		_box addMagazineCargoGlobal ["5Rnd_86x70_L115A1", 5];
		_box addMagazineCargoGlobal ["30Rnd_556x45_Stanag", 10];
		_box addMagazineCargoGlobal ["20Rnd_762x51_B_SCAR", 10];
		_box addMagazineCargoGlobal ["100Rnd_762x51_M240", 4];
		_box addMagazineCargoGlobal ["20Rnd_762x51_DMR", 5];
		_box addMagazineCargoGlobal ["5Rnd_762x51_M24", 5];
		_box addMagazineCargoGlobal ["5Rnd_762x51_M24", 5];
		_box addMagazineCargoGlobal ["20Rnd_762x51_SB_SCAR", 4];
		_box addMagazineCargoGlobal ["20Rnd_762x51_SB_SCAR", 4];
		_box addMagazineCargoGlobal ["100Rnd_762x51_M240", 4];
		_box addMagazineCargoGlobal ["30Rnd_762x39_AK47", 8];
		_box addMagazineCargoGlobal ["20Rnd_B_AA12_74Slug", 10];
		_box addMagazineCargoGlobal ["20Rnd_B_AA12_HE", 4];
		_box addMagazineCargoGlobal ["MAAWS_HEAT", 2];
	};
	if (_boxRand == 1) then {
		_box addWeaponCargoGlobal ["DMR_DZ", 1];
		_box addWeaponCargoGlobal ["BAF_LRR_scoped_W", 1];
		_box addWeaponCargoGlobal ["M4A3_RCO_GL_EP1", 1];
		_box addWeaponCargoGlobal ["M110_NVG_EP1", 1];
		_box addWeaponCargoGlobal ["Mk_48_DES_EP1", 1];
		_box addWeaponCargoGlobal ["M14_EP1", 1];
		_box addWeaponCargoGlobal ["M24", 1];
		_box addWeaponCargoGlobal ["M40A3", 1];
		_box addWeaponCargoGlobal ["SCAR_L_CQC_CCO_SD", 1];
		_box addWeaponCargoGlobal ["SCAR_H_LNG_Sniper_SD", 1];
		_box addWeaponCargoGlobal ["M60A4_EP1_DZE", 1];
		_box addWeaponCargoGlobal ["AK_47_M", 1];
		_box addWeaponCargoGlobal ["AA12_PMC", 1]; 
		_box addWeaponCargoGlobal ["USSR_cheytacM200", 1];
		_box addWeaponCargoGlobal ["BAF_AS50_scoped", 1];
		_box addWeaponCargoGlobal ["MAAWS", 1];
		// PISTOLS
		_box addWeaponCargoGlobal ["M9", 1];
		_box addWeaponCargoGlobal ["M9SD", 1];
		_box addWeaponCargoGlobal ["UZI_SD_EP1", 1];
		_box addWeaponCargoGlobal ["bizon_silenced", 1];
		// AMMUNITION
		_box addMagazineCargoGlobal ["20Rnd_762x51_DMR", 5];
		_box addMagazineCargoGlobal ["5Rnd_86x70_L115A1", 5];
		_box addMagazineCargoGlobal ["30Rnd_556x45_Stanag", 10];
		_box addMagazineCargoGlobal ["20Rnd_762x51_B_SCAR", 10];
		_box addMagazineCargoGlobal ["100Rnd_762x51_M240", 4];
		_box addMagazineCargoGlobal ["20Rnd_762x51_DMR", 5];
		_box addMagazineCargoGlobal ["5Rnd_762x51_M24", 5];
		_box addMagazineCargoGlobal ["5Rnd_762x51_M24", 5];
		_box addMagazineCargoGlobal ["20Rnd_762x51_SB_SCAR", 4];
		_box addMagazineCargoGlobal ["20Rnd_762x51_SB_SCAR", 4];
		_box addMagazineCargoGlobal ["100Rnd_762x51_M240", 4];
		_box addMagazineCargoGlobal ["30Rnd_762x39_AK47", 8];
		_box addMagazineCargoGlobal ["20Rnd_B_AA12_74Slug", 10];
		_box addMagazineCargoGlobal ["20Rnd_B_AA12_HE", 4];
		_box addMagazineCargoGlobal ["USSR_5Rnd_408", 10];
		_box addMagazineCargoGlobal ["10Rnd_127x99_m107", 5];
		_box addMagazineCargoGlobal ["5Rnd_127x99_as50", 1];
		_box addMagazineCargoGlobal	["MAAWS_HEAT", 2];
		_box addMagazineCargoGlobal ["15Rnd_9x19_M9", 8];
		_box addMagazineCargoGlobal ["15Rnd_9x19_M9SD", 8];
		_box addMagazineCargoGlobal ["30Rnd_9x19_UZI_SD", 8];
		_box addMagazineCargoGlobal ["64Rnd_9x19_SD_Bizon", 8];
		// ITEMS
		_box addWeaponCargoGlobal ["Binocular_Vector", 2];
		_box addWeaponCargoGlobal ["NVGoggles", 2];
		_box addWeaponCargoGlobal ["ItemGPS", 1];
	};
if (_boxRand == 2) then {
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
		_box addWeaponCargoGlobal ["Binocular_Vector", 3];
		_box addMagazineCargoGlobal ["Skin_Sniper1_DZ", 3];
	};