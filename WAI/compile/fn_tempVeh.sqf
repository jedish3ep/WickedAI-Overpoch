/*
	File: fn_tempVeh.sqf
	Author: JakeHekesFists[DMD]
	Desc: Single Function to allow Temporary Vehicles to be Spawned at AI Missions
*/
private ["_veh","_vehdir","_objPosition","_damage","_fuel","_objectID"];

_veh = 		_this select 0;
_damage =	_this select 1;
_fuel = 	_this select 2;

_objectID = str(round(random 999999));	// generate a random uid so vehicle can be sold at traders

_vehdir = round(random 360);

_veh setDir _vehdir;
_veh setFuel _fuel;
_veh setDamage _damage;

clearWeaponCargoGlobal _veh;
clearMagazineCargoGlobal _veh;

_veh setVariable ["MalSar",1,true];
_veh setVariable ["ObjectID", _objectID, true];
_veh setVariable ["ObjectUID", _objectID, true];
_veh setVariable ["permaLoot",true]; // not sure if needed. keep anyways

_veh addEventHandler ["GetIn",{_nil = [nil,(_this select 2),"loc",rTITLETEXT,"Warning: This Vehicle will despawn on Server Restart. Either sell it or go fuck shit up!","PLAIN DOWN",5] call RE;}];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_veh];