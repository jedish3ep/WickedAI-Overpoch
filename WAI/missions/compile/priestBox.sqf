_box = _this select 0;
_box setVariable ["ObjectID","1",true];
_box setVariable ["permaLoot",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_box];

clearWeaponCargoGlobal _box;
clearMagazineCargoGlobal _box;
clearBackpackCargoGlobal _box;
_box addBackpackCargoGlobal ["DZ_LargeGunBag_EP1", 1];
_box addMagazineCargoGlobal ["Skin_Priest_DZ", 10];

BoxRandomizer=floor(random 3);
	if (BoxRandomizer == 0) then {
		_box addmagazineCargoGlobal ["ItemBriefcase100oz", 3];
		_box addMagazineCargoGlobal ["ItemEmerald", 1];
		_box addMagazineCargoGlobal ["ItemGoldBar", 20];
		_box addMagazineCargoGlobal ["ItemGoldBar10oz", 15];
		_box addMagazineCargoGlobal ["ItemSilverBar", 15];
		_box addMagazineCargoGlobal ["ItemSilverBar10oz", 30];
		};
	if (BoxRandomizer == 1) then {
		_box addMagazineCargoGlobal ["ItemBriefcase100oz", 2];
		_box addMagazineCargoGlobal ["ItemGoldBar", 10];
		_box addMagazineCargoGlobal ["ItemGoldBar10oz", 20];
		_box addMagazineCargoGlobal ["ItemSilverBar", 30];
		_box addMagazineCargoGlobal ["ItemSilverBar10oz", 30];
		};
	if (BoxRandomizer == 2) then {
		_box addMagazineCargoGlobal ["ItemBriefcase100oz", 4];
		_box addMagazineCargoGlobal ["ItemSapphire", 2];
		_box addMagazineCargoGlobal ["ItemGoldBar", 10];
		_box addMagazineCargoGlobal ["ItemGoldBar10oz", 10];
		_box addMagazineCargoGlobal ["ItemSilverBar", 10];
		_box addMagazineCargoGlobal ["ItemSilverBar10oz", 10];
		};