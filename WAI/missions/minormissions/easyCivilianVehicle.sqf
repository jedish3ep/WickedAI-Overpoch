private ["_fileName", "_missionType", "_position", "_veharray", "_vehclass", "_vehname", "_picture", "_missionName", "_difficulty", "_missionDesc", "_winMessage", "_failMessage", "_veh", "_vehdir", "_objPosition", "_rndnum", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box"];

_fileName = "easyCivilianVehicle";
_missionType = "Minor Mission";
_position = call WAI_findPos;

_veharray = [
		"AH6X_DZ",
		"GAZ_Vodnik_MedEvac",
		"HMMWV_Ambulance",
		"LandRover_CZ_EP1",
		"MH6J_DZ",
		"UAZ_INS"
	];
_vehclass = _veharray call BIS_fnc_selectRandom; 
_vehname	= getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");
_picture = getText (configFile >> "cfgVehicles" >> _vehclass >> "picture");
_missionName = _vehname;
_difficulty = "easy";
_missionDesc = format["Bandits have captured a %1 Kill them, and steal the %1 for yourself",_vehname];
_winMessage = format["Good job, the bandits are Dead and the %1 is yours",_vehname];
_failMessage = format["Time's Up! The bandits have escaped with the %1",_vehname];


/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_minor_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

//Vehicle
	_veh = createVehicle [_vehclass,_position, [], 0, "CAN_COLLIDE"];
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

//Troops
_rndnum = round (random 3) + 5;
[	[_position select 0, _position select 1, 0],
	_rndnum,			//Number Of units
	"easy",			//Skill level 0-1. Has no effect if using custom skills
	"Random",		//Primary gun set number. "Random" for random weapon set.
	3,				//Number of magazines
	"",				//Backpack "" for random or classname here.
	"",				//Skin "" for random or classname here.
	"Random",		//Gearset number. "Random" for random gear set.
	"minor",			
	"WAIminorArray"
] call spawn_group;

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
	
	_box = createVehicle ["BAF_VehicleBox",[(_position select 0),(_position select 1) + 5,0], [], 0, "CAN_COLLIDE"];
	[_box] call easyMissionBox;		// Crate with Basic Loot
	[_box] call markCrates;		// mark crates with smoke/flares
	
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