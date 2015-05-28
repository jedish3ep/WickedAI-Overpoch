_box = _this select 0;
_box setVariable ["ObjectID","1",true];
_box setVariable ["permaLoot",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_box];

clearWeaponCargoGlobal _box;
clearMagazineCargoGlobal _box;
clearBackpackCargoGlobal _box;
_box addBackpackCargoGlobal ["DZ_LargeGunBag_EP1", 1];
_box addMagazineCargoGlobal ["Skin_Priest_DZ", 10];
		
_gemArray = ["ItemBriefcase100oz","ItemEmerald","ItemGoldBar","ItemGoldBar10oz","ItemSilverBar","ItemSilverBar10oz","ItemGoldBar"];
for "_i" from 1 to 15 do
	{
		private ["_gemSelected"];
		_gemSelected = _gemArray call BIS_fnc_selectRandom;
		_box addMagazineCargoGlobal [_gemSelected, 1];
	};