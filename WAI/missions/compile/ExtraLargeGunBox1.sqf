//Extra Large Gun Box

_box = _this select 0;
_box setVariable ["ObjectID","1",true];
_box setVariable ["permaLoot",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_box];

clearWeaponCargoGlobal _box;
clearMagazineCargoGlobal _box;

// RIFLES
_box addWeaponCargoGlobal ["DMR_DZ", 1];
_box addWeaponCargoGlobal ["BAF_LRR_scoped_W", 1];
_box addWeaponCargoGlobal ["M4A3_RCO_GL_EP1", 1];
_box addWeaponCargoGlobal ["BAF_L85A2_RIS_CWS", 2];
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
_box addMagazineCargoGlobal ["30Rnd_556x45_Stanag", 15];
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

//BACKPACKS
_box addBackpackCargoGlobal ["DZ_LargeGunBag_EP1", 1];

_boxRand=floor(random 3);
	if (_boxRand == 0) then {
		// taser 
		_box addWeaponCargoGlobal ["DDOPP_X3_b",2];
		_box addmagazineCargoGlobal ["DDOPP_3Rnd_X3",8];
		// 2 extra rifles
		_box addWeaponCargoGlobal ["vil_SV_98",1];
		_box addmagazineCargoGlobal ["vil_10Rnd_762x54_SV",8];
		_box addWeaponCargoGlobal ["vil_SR25",1];
		_box addmagazineCargoGlobal ["20Rnd_762x51_DMR", 5]; // 5 extra DMR mags		
	};
	if (_boxRand == 1) then {
		// m32 gren launcher + sd cheytac
		_box addWeaponCargoGlobal ["USSR_cheytacM200_sd",1];
		_box addmagazineCargoGlobal ["USSR_5Rnd_408",5];
		_box addWeaponCargoGlobal ["M32_EP1",1];
		_box addmagazineCargoGlobal ["6Rnd_HE_M203",2];
		_box addMagazineCargoGlobal ["6Rnd_SmokeRed_M203",1];
		_box addMagazineCargoGlobal ["6Rnd_SmokeGreen_M203",1];
		_box addMagazineCargoGlobal ["6Rnd_SmokeYellow_M203",1];
	};
	if (_boxRand == 2) then {
		// add an extra rocket launcher
		_box addWeaponCargoGlobal ["SMAW", 1];
		_box addmagazineCargoGlobal ["SMAW_HEAA", 2];
	};

