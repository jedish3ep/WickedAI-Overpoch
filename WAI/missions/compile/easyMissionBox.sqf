/* easy mission box */

_box = _this select 0;
_box setVariable ["ObjectID","1",true];
_box setVariable ["permaLoot",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_box];

clearWeaponCargoGlobal _box;
clearMagazineCargoGlobal _box;

//MEDICAL SUPPLIES
_box addMagazineCargoGlobal ["ItemBandage", 6];
_box addMagazineCargoGlobal ["ItemMorphine", 2];
_box addMagazineCargoGlobal ["ItemEpinephrine", 1];
_box addMagazineCargoGlobal ["ItemPainkiller", 6];
_box addMagazineCargoGlobal ["ItemAntibiotic", 2];
_box addMagazineCargoGlobal ["ItemBloodbag", 4];

_box addMagazineCargoGlobal ["ItemWaterbottle", 3];
_box addMagazineCargoGlobal ["FoodCanBakedBeans", 3];

{_box addWeaponCargoGlobal [_x, 1];}	count ammo_box_tools;

_box addMagazineCargoGlobal ["ItemComboLock", 1];
_box addMagazineCargoGlobal ["ItemTentDomed", 1];
_box addMagazineCargoGlobal ["PartPlankPack", 10];
_box addMagazineCargoGlobal ["PartPlywoodPack", 10];
_box addMagazineCargoGlobal ["workbench_kit", 1];

_box addBackpackCargoGlobal ["DZ_LargeGunBag_EP1", 1];

_BoxRandomizer=floor(random 100);
if (_BoxRandomizer >= 75) then 
	{
		_box addMagazineCargoGlobal ["ItemGoldBar10oz", 1];
		_box addMagazineCargoGlobal ["30m_plot_kit", 1];
		if (_BoxRandomizer == 86) then
			{
				_box addMagazineCargoGlobal ["ItemHotwireKit", 1];
			};
	}
		else
	{
		_box addMagazineCargoGlobal ["ItemGoldBar10oz", 4];
		_box addMagazineCargoGlobal ["ItemLockbox", 1];
	};