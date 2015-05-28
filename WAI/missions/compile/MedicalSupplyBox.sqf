//Medical Supply Box

_box = _this select 0;
_box setVariable ["ObjectID","1",true];
_box setVariable ["permaLoot",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_box];

clearWeaponCargoGlobal _box;
clearMagazineCargoGlobal _box;

//MEDICAL SUPPLIES
_box addMagazineCargoGlobal ["ItemBandage", 18];
_box addMagazineCargoGlobal ["ItemMorphine", 10];
_box addMagazineCargoGlobal ["ItemEpinephrine", 5];
_box addMagazineCargoGlobal ["ItemPainkiller", 15];
_box addMagazineCargoGlobal ["ItemWaterbottle", 3];
_box addMagazineCargoGlobal ["FoodCanBakedBeans", 10];
_box addMagazineCargoGlobal ["ItemAntibiotic", 6];
_box addMagazineCargoGlobal ["ItemBloodbag", 15];

_boxRand=floor(random 100);
if (_boxRand == 6) then
	{
			_box addMagazineCargoGlobal ["ItemHotwireKit", 1];
	};
