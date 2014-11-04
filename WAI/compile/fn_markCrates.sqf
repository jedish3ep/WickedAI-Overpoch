/*

	File : fn_markCrates.sqf
	Auth : JakeHekesFists[DMD]
	Desc : Marks crates with smoke grenade or flares
			Based on Function in f3cuk's version of WickedAI
			https://github.com/f3cuk/WICKED-AI/tree/master/WAI

*/

private ["_box","_marker","_inRange","_smokeColours","_smokeShell"];

_box = _this select 0;

_smokeColours = ["SmokeShellGreen","SmokeShellRed","SmokeShellBlue","SmokeShellOrange"];
_smokeShell = _smokeColours call BIS_fnc_selectRandom;


if(sunOrMoon == 1) then {
	_marker = _smokeShell createVehicle getPosATL _box;
	_marker setPosATL (getPosATL _box);
	_marker attachTo [_box,[0,0,0]];
};

if (sunOrMoon != 1) then {
	_marker = "RoadFlare" createVehicle getPosATL _box;
	_marker setPosATL (getPosATL _box);
	_marker attachTo [_box, [0,0,0]];
	_inRange = _box nearEntities ["CAManBase",1250];

	{
		if(isPlayer _x && _x != player) then {
			PVDZE_send = [_x,"RoadFlare",[_marker,0]];
			publicVariableServer "PVDZE_send";
		};
	} count _inRange;
};