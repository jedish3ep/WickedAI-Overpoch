/*
	File: fn_tempStarter.sqf
	Author: JakeHekesFists[DMD]
	Desc: loads a vehicle with starter crate contents
*/
_veh = 		_this select 0;

_vehID = str(round(random 999999));	// generate a random uid so vehicle can be sold at traders

_vehdir = round(random 360);

_veh setDir _vehdir;
_veh setFuel 0.5;
_veh setDamage 0;

clearWeaponCargoGlobal _veh;
clearMagazineCargoGlobal _veh;

_veh setVariable ["MalSar",1,true];
_veh setVariable ["ObjectID", _vehID, true];
_veh setVariable ["ObjectUID", _vehID, true];
_veh setVariable ["permaLoot",true]; // not sure if needed. keep anyways

_veh addEventHandler ["GetIn",{_nil = [nil,(_this select 2),"loc",rTITLETEXT,"Nice job asshole! you stole those poor AI's starter vehicle. It will despawn on restart, so take the gear and sell the car before restart!","PLAIN DOWN",5] call RE;}];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_veh];

// STARTER GEAR 
_veh addWeaponCargoGlobal ["ItemCrowbar", 1];
_veh addWeaponCargoGlobal ["ItemEtool", 1];
_veh addWeaponCargoGlobal ["ItemHatchet_DZE", 1];
_veh addWeaponCargoGlobal ["ItemMatchbox_DZE", 1];
_veh addWeaponCargoGlobal ["ItemSledge", 1];
_veh addWeaponCargoGlobal ["ItemKnife", 1];

_veh addMagazineCargoGlobal ["ItemGoldBar10oz", 1];
_veh addMagazineCargoGlobal ["30m_plot_kit", 1];
_veh addMagazineCargoGlobal ["ItemComboLock", 1];
_veh addMagazineCargoGlobal ["ItemTentDomed", 1];
_veh addMagazineCargoGlobal ["ItemLockbox", 1];
_veh addMagazineCargoGlobal ["ItemWoodFloor", 2];
_veh addMagazineCargoGlobal ["ItemWoodWallGarageDoorLocked", 1];
_veh addMagazineCargoGlobal ["ItemWoodWallLg", 2];
_veh addMagazineCargoGlobal ["ItemWoodWallwithDoorLg", 1];
_veh addMagazineCargoGlobal ["ItemWoodWallWindowLg", 2];
_veh addMagazineCargoGlobal ["metal_floor_kit", 1];
_veh addMagazineCargoGlobal ["workbench_kit", 1];

_veh addBackpackCargoGlobal ["DZ_LargeGunBag_EP1", 1];

_veh setVariable ["permaLoot",true];