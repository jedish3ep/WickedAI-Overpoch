private ["_fileName", "_missionType", "_position", "_vehclass", "_vehname", "_picture", "_missionName", "_difficulty", "_missionDesc", "_winMessage", "_failMessage", "_crash", "_body", "_body1", "_body2", "_body3", "_base", "_veh", "_veh1", "_vehdir", "_objPosition", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_crate1", "_crate2", "_crate3"];

_fileName = "uralAmbush";
_missionType = "Minor Mission";
_position = call WAI_findPos;
_vehclass = military_unarmed call BIS_fnc_selectRandom;
_vehname	= getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");
_picture = getText (configFile >> "cfgWeapons" >> "Cobalt_File" >> "picture");
_missionName = "Ural Ambush";
_difficulty = "easy";
_missionDesc = "Bandits have Ambushed a Ural Carrying Supplies!";
_winMessage = "Good job, the bandits are Dead and the supplies are yours";
_failMessage = "Time's Up! The bandits have escaped with the supplies";

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_minor_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

/* Scenery */
//We create the scenery
_crash = createVehicle ["UralWreck",_position,[], 0, "CAN_COLLIDE"];
_crash setDir 149.64919;
_body = createVehicle ["Body",[(_position select 0) - 2.2905,(_position select 1) - 3.3438,0],[], 0, "CAN_COLLIDE"];
_body setDir 61.798588;
_body1 = createVehicle ["Body",[(_position select 0) - 2.8511,(_position select 1) - 2.4346,0],[], 0, "CAN_COLLIDE"];
_body1 setDir 52.402905;
_body2 = createVehicle ["Body",[(_position select 0) - 3.435,(_position select 1) - 1.4297,0],[], 0, "CAN_COLLIDE"];
_body2 setDir -117.27345;
_body3 = createVehicle ["Body2",[(_position select 0) - 4.0337,(_position select 1) + 0.5,0],[], 0, "CAN_COLLIDE"];
_body3 setDir 23.664057;
_base = [_crash,_body,_body1,_body2,_body3];
{ minorBldList = minorBldList + [_x]; } forEach _base;
{ _x setVectorUp surfaceNormal position _x; } count _base;

/* Vehicle */
	_veh = createVehicle [_veh1,[(_position select 0) + 5.7534, (_position select 1) - 9.2149,0],[], 0, "CAN_COLLIDE"];
	_vehdir = round(random 360);
	_veh setDir _vehdir;
	clearWeaponCargoGlobal _veh;
	clearMagazineCargoGlobal _veh;
	_veh setVariable ["ObjectID","1",true];
	_veh setVehicleLock "LOCKED";
	_veh setVariable ["R3F_LOG_disabled",true,true];
	PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_veh];
	diag_log format["WAI: Mission %1 spawned a %2",_fileName,_vehname];
	_objPosition = getPosATL _veh;

/* Troops */
for "_i" from 1 to 3 do
	{
		[_position,4,_difficulty,"Random",3,"","","Random","minor","WAIminorArray"] call spawn_group;
		sleep 0.1;
	};


_missiontimeout = true;
_cleanmission = false;
_playerPresent = false;
_starttime = floor(time);

while {_missiontimeout} do {
	sleep 5;
	_currenttime = floor(time);
	{if((isPlayer _x) AND (_x distance _position <= 300)) then {_playerPresent = true};}forEach playableUnits;
	if (_currenttime - _starttime >= wai_minor_mission_timeout) then {_cleanmission = true;};
	if ((_playerPresent) OR (_cleanmission)) then {_missiontimeout = false;};
};
if (_playerPresent) then {
	[_position,"WAIminorArray"] call missionComplete;
		// wait for mission complete before publishing vehicle to hive
	_veh setDamage 0;
	[_veh,[_vehdir,_objPosition],_vehclass,true,"0"] call custom_publish;
	// UNLOCK AFTER PUBLISH
	_veh setVehicleLock "UNLOCKED";
	_veh setVariable ["R3F_LOG_disabled",false,true];
	
	_crate1 = createVehicle ["USBasicWeaponsBox",[(_position select 0) + 2.6778,(_position select 1) - 3.0889,0],[], 0, "CAN_COLLIDE"];
	_crate2 = createVehicle ["USBasicWeaponsBox",[(_position select 0) + 1.4805,(_position select 1) - 3.7432,0],[], 0, "CAN_COLLIDE"];
	_crate3 = createVehicle ["USBasicAmmunitionBox",[(_position select 0) + 2.5405,(_position select 1) - 4.1612,0],[], 0, "CAN_COLLIDE"];
	
	[_crate1] call Medical_Supply_Box;
	[_crate2] call Medical_Supply_Box;
	[_crate3] call Medium_Gun_Box;
	sleep 0.1;
	[_crate1] call markCrates;sleep 0.05;
	[_crate2] call markCrates;sleep 0.05;
	[_crate3] call markCrates;sleep 0.05;
	
	diag_log format["WAI: Mission %1 Ended At %2",_fileName,_position];
	[nil,nil,rTitleText,format["%1",_winMessage], "PLAIN",10] call RE;

	uiSleep 300;
	["minorclean"] call WAIcleanup;
} else {
	clean_running_minor_mission = True;
	deleteVehicle _veh;
	["minorclean"] call WAIcleanup;
	
	diag_log format["WAI: Mission %1 Timed Out At %2",_fileName,_position];
	[nil,nil,rTitleText,format["%1",_failMessage], "PLAIN",10] call RE;
};

minor_missionrunning = false;