private ["_fileName", "_missionType", "_position", "_vehname", "_picture", "_missionName", "_difficulty", "_missionDesc", "_winMessage", "_failMessage", "_base1", "_base2", "_base3", "_scenery", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box", "_box1", "_box2", "_box3", "_box4", "_veh"];

_fileName = "easyAntiAir";
_missionType = "Minor Mission";
_position = [getMarkerPos "center",0,5500,10,0,2000,0] call BIS_fnc_findSafePos;

_vehname	= getText (configFile >> "CfgVehicles" >> "Igla_AA_pod_East" >> "displayName");
_picture = getText (configFile >> "cfgVehicles" >> "Igla_AA_pod_East" >> "picture");
_missionName = "Hostile Anti Air Team";
_difficulty = "easy";
_missionDesc = format["Insurgents have set up %1 Anti Air Defence - You need to take them out ASAP",_vehname];
_winMessage = format["Good job, the %1 have been wiped out. The skies are safe again",_vehname];
_failMessage = format["Mission Failed: You did not destroy the %1 in Time",_vehname];


/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_minor_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

/* Mission Scenery */
_base1 = createVehicle ["TK_GUE_WarfareBAntiAirRadar_EP1",[(_position select 0), (_position select 1)],[], 0, "CAN_COLLIDE"];
_base2 = createVehicle ["FlagCarrierRU",[(_position select 0) + 1.0205, (_position select 1) - 16.6372],[], 0, "CAN_COLLIDE"];
_base3 = createVehicle ["FlagCarrierRU",[(_position select 0) - 0.7871, (_position select 1) + 9.979],[], 0, "CAN_COLLIDE"];

_scenery = [_base1,_base2,_base3];
{ minorBldList = minorBldList + [_x]; } forEach _scenery;
{ _x setVectorUp surfaceNormal position _x; } count _scenery;

/* Insurgents */
[	[_position select 0, _position select 1, 0],
	6,			//Number Of units
	"easy",		//Skill level 0-1. Has no effect if using custom skills
	"Random",	//Primary gun set number. "Random" for random weapon set.
	3,			//Number of magazines
	"",			//Backpack "" for random or classname here.
	"",			//Skin "" for random or classname here.
	"Random",	//Gearset number. "Random" for random gear set.
	"minor",			
	"WAIminorArray"
] call spawn_group;

/* Anti Aircraft */
[[[(_position select 0), (_position select 1) + 21, 0],[(_position select 0), (_position select 1) - 25, 0]], //position(s) (can be multiple).
"Igla_AA_pod_East",	//Classname of turret
0.8,					//Skill level 0-1. Has no effect if using custom skills
"",					//Skin "" for random or classname here.
0,					//Primary gun set number. "Random" for random weapon set. (not needed if ai_static_useweapon = False)
2,					//Number of magazines. (not needed if ai_static_useweapon = False)
"",					//Backpack "" for random or classname here. (not needed if ai_static_useweapon = False)
"Random",			//Gearset number. "Random" for random gear set. (not needed if ai_static_useweapon = False)
"minor"
] call spawn_static;

_missiontimeout = true;
_cleanmission = false;
_playerPresent = false;
_starttime = floor(time);
while {_missiontimeout} do {
	sleep 5;
	_currenttime = floor(time);
	{if((isPlayer _x) AND (_x distance _position <= 150)) then {_playerPresent = true};}forEach playableUnits;
	if (_currenttime - _starttime >= wai_mission_timeout) then {_cleanmission = true;};
	if ((_playerPresent) OR (_cleanmission)) then {_missiontimeout = false;};
};
if (_playerPresent) then {
	[_position,"WAIminorArray"] call missionComplete;
	
	_box = createVehicle ["USVehicleBox",[(_position select 0) + 6.6914,(_position select 1) + 1.1939,0], [], 0, "CAN_COLLIDE"];
	[_box] call easyMissionBox;		// Crate with Basic Loot
	[_box] call markCrates;		// mark crates with smoke/flares
	
	_box1 = createVehicle ["AmmoBoxSmall_762",[(_position select 0) - 7.6396,(_position select 1) + 7.2813,0], [], 0, "CAN_COLLIDE"];
	_box2 = createVehicle ["AmmoBoxSmall_556",[(_position select 0) - 3.4346, 0, 0],[], 0, "CAN_COLLIDE"];
	_box3 = createVehicle ["AmmoBoxSmall_556",[(_position select 0) + 4.0996,(_position select 1) + 3.9072, 0],[], 0, "CAN_COLLIDE"];
	_box4 = createVehicle ["AmmoBoxSmall_762",[(_position select 0) - 3.7251,(_position select 1) - 2.3614, 0],[], 0, "CAN_COLLIDE"];
	
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