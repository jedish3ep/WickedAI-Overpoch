private ["_fileName", "_missionName", "_difficulty", "_missionType", "_position", "_picture", "_missionDesc", "_winMessage", "_failMessage", "_vehclass", "_vehname", "_base", "_base1", "_veh", "_vehdir", "_objPosition", "_rndnum", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box", "_box1"];

_fileName = "stashHouse";
_missionName = "Stash House";
_difficulty = "normal";
_missionType = "Minor Mission";

_position = call WAI_findPos;

_picture = getText (configFile >> "cfgWeapons" >> "Cobalt_File" >> "picture");
_missionDesc = format["Bandits have set up a Weapon %1! Go Empty it Out!",_missionName];
_winMessage = format["The Weapons %1 is under Survivor Control!",_missionName];
_failMessage = format["Time's up! MISSION FAILED",_missionName];

_vehclass = civil_vehicles call BIS_fnc_selectRandom;
_vehname	= getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_minor_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

/* Create Scenery */
_base = createVehicle ["Land_HouseV_1I4",_position, [], 0, "CAN_COLLIDE"];
_base setDir 152.66766;
_base1 = createVehicle ["Land_kulna",[(_position select 0) + 5.4585, (_position select 1) - 2.885,0],[], 0, "CAN_COLLIDE"];
_base1 setDir -28.282881;

minorBldList = minorBldList + [_base];
minorBldList = minorBldList + [_base1];

// civ car
_veh = createVehicle [_vehclass,[(_position select 0) - 10.6206, (_position select 1) - 0.49,0], [], 0, "CAN_COLLIDE"];
_vehdir = round(random 360);
_veh setDir _vehdir;
clearWeaponCargoGlobal _veh;
clearMagazineCargoGlobal _veh;
_veh setVariable ["ObjectID","1",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_veh];
_veh setVehicleLock "LOCKED";
_veh setVariable ["R3F_LOG_disabled",true,true];
diag_log format["WAI: Mission stashHouse spawned a %1",_vehname];

_objPosition = getPosATL _veh;
//[_veh,[_vehdir,_objPosition],_vehclass,true,"0"] call custom_publish;

//Troops
_rndnum = round (random 3) + 4;
[
	[_position select 0, _position select 1, 0],                  //position
	_rndnum,				  //Number Of units
	_difficulty,					      //Skill level 0-1. Has no effect if using custom skills
	"Random",			      //Primary gun set number. "Random" for random weapon set.
	4,						  //Number of magazines
	"",						  //Backpack "" for random or classname here.
	"",						  //Skin "" for random or classname here.
	"Random",				  //Gearset number. "Random" for random gear set.
	"minor",
	"WAIminorArray"
] call spawn_group;

sleep 0.1;

[
	[_position select 0, _position select 1, 0],                  //position
	4,						  //Number Of units
	_difficulty,					      //Skill level 0-1. Has no effect if using custom skills
	"Random",			      //Primary gun set number. "Random" for random weapon set.
	4,						  //Number of magazines
	"",						  //Backpack "" for random or classname here.
	"",						  //Skin "" for random or classname here.
	"Random",				  //Gearset number. "Random" for random gear set.
	"minor",
	"WAIminorArray"
] call spawn_group;

_missiontimeout = true;
_cleanmission = false;
_playerPresent = false;
_starttime = floor(time);

while {_missiontimeout} do 
	{
		sleep 5;
		_currenttime = floor(time);
		{if((isPlayer _x) AND (_x distance _position <= 150)) then {_playerPresent = true};}forEach playableUnits;
		if (_currenttime - _starttime >= wai_mission_timeout) then {_cleanmission = true;};
		if ((_playerPresent) OR (_cleanmission)) then {_missiontimeout = false;};
	};

if (_playerPresent) then 
	{
		
		[_position,"WAIminorArray"] call missionComplete;
		
		diag_log format["WAI: Mission %1 Ended At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_winMessage], "PLAIN",10] call RE;
		
		// wait for mission complete then publish vehicle and spawn crates
		_veh setVehicleLock "UNLOCKED";
		_veh setVariable ["R3F_LOG_disabled",false,true];
		[_veh,[_vehdir,_objPosition],_vehclass,true,"0"] call custom_publish;
		

		_box = createVehicle ["USBasicAmmunitionBox",[(_position select 0) + 0.7408, (_position select 1) + 1.565, 0.10033049], [], 0, "CAN_COLLIDE"];
		[_box] call Medical_Supply_Box; // medical supplies
		_box1 = createVehicle ["USBasicAmmunitionBox",[(_position select 0) - 0.2387, (_position select 1) + 1.043, 0.10033049], [], 0, "CAN_COLLIDE"];
		[_box1] call Medium_Gun_Box; // med gun box

		// mark crates with smoke/flares
		[_box] call markCrates;
		[_box1] call markCrates;

		uiSleep 5*60;
		["minorclean"] call WAIcleanup;
	}
		else
	{
		clean_running_minor_mission = True;
		deleteVehicle _veh;
		["minorclean"] call WAIcleanup;
		
		diag_log format["WAI: Mission %1 Timed Out At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_failMessage], "PLAIN",10] call RE;
	};
	
minor_missionrunning = false;