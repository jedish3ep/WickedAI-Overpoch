_box = _this select 0;
_box setVariable ["ObjectID","1",true];
_box setVariable ["permaLoot",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_box];

clearWeaponCargoGlobal _box;
clearMagazineCargoGlobal _box;
clearBackpackCargoGlobal _box;
_box addBackpackCargoGlobal ["DZ_LargeGunBag_EP1", 1];

BoxRandomizer=floor(random 3);
	if (BoxRandomizer == 0) then {
		_box addmagazineCargoGlobal ["ItemBriefcase100oz", 15];
		_box addMagazineCargoGlobal ["ItemEmerald", 1];
		};
	if (BoxRandomizer == 1) then {
		_box addMagazineCargoGlobal ["ItemBriefcase100oz", 8];
		_box addmagazineCargoGlobal ["ItemSapphire", 2];
		_box addmagazineCargoGlobal ["ItemRuby", 1];
		_box addMagazineCargoGlobal ["ItemEmerald", 1];
		};
	if (BoxRandomizer == 2) then {
		_box addMagazineCargoGlobal ["ItemBriefcase100oz", 4];
		_box addmagazineCargoGlobal ["ItemRuby", 1];
		_box addMagazineCargoGlobal ["ItemSapphire", 2];
		_box addMagazineCargoGlobal ["ItemEmerald", 1];
		_box addMagazineCargoGlobal ["ItemTopaz", 2];
		_box addMagazineCargoGlobal ["ItemAmethyst", 2];
		};