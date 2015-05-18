private ["_fileName", "_missionType", "_position", "_veharray", "_vehclass", "_vehname", "_picture", "_missionName", "_difficulty", "_missionDesc", "_winMessage", "_failMessage", "_destroyedMessage", "_skinArray", "_skin", "_veh", "_vehdir",  "_missiontimeout", "_cleanmission", "_playerPresent", "_endMissionFail", "_starttime", "_currenttime"];

_fileName = "easyDickMove";
_missionType = "Minor Mission";
_position = call WAI_findPos;

_veharray = ["SUV_Blue","SUV_Camo","SUV_Charcoal","SUV_Green","SUV_Orange","SUV_Red","SUV_Silver"];
_vehclass = _veharray call BIS_fnc_selectRandom; 
_vehname	= getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");
_picture = getText (configFile >> "cfgVehicles" >> _vehclass >> "picture");
_missionName = "Operation: Dick Move";
_difficulty = "easy";
_missionDesc = format["Some new guys have a %1 full of their starter gear, Be a Dick and take it off them",_vehname];
_winMessage = format["Way to go asshole, you killed the new guys and the %1 is yours",_vehname];
_failMessage = format["Time's Up! The new guys got their %1 to safety!",_vehname];
_destroyedMessage = format["Oh wow! you truly are a cunt. You blew up their Starter pack %1. MISSION FAIL!",_vehname];

_skinArray = ["Survivor2_DZ","Rocker2_DZ","Rocker1_DZ","Rocker4_DZ","Graves_Light_DZ","CZ_Soldier_Sniper_EP1_DZ","Soldier_Sniper_PMC_DZ","Pilot_EP1_DZ"];
_skin = _skinArray call BIS_fnc_selectRandom; 

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_minor_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

/* create the vehicle */
	_veh = createVehicle [_vehclass,_position, [], 0, "CAN_COLLIDE"];
	_vehdir = round(random 360);
	_veh setDir _vehdir;
	_veh setVehicleLock "LOCKED";
	_veh setVariable ["R3F_LOG_disabled",true,true];
	_veh setDamage 0;
	PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_veh];
	diag_log format["WAI: Mission %1 spawned a %2",_fileName,_vehname];

//Troops
[	[_position select 0, _position select 1, 0],
	4,				//Number Of units
	"easy",			//Skill level 0-1. Has no effect if using custom skills
	"Random",		//Primary gun set number. "Random" for random weapon set.
	3,				//Number of magazines
	"",				//Backpack "" for random or classname here.
	_skin,			//Skin "" for random or classname here.
	"Random",		//Gearset number. "Random" for random gear set.
	"minor",			
	"WAIminorArray"
] call spawn_group;

_missiontimeout = true;
_cleanmission = false;
_playerPresent = false;
_endMissionFail = false;
_starttime = floor(time);

while {_missiontimeout} do {
	sleep 5;
	_currenttime = floor(time);
	{if((isPlayer _x) AND (_x distance _position <= 150)) then {_playerPresent = true};}forEach playableUnits;
	if (_currenttime - _starttime >= wai_mission_timeout) then {_cleanmission = true;};
	if ((_playerPresent) OR (_cleanmission)) then {_missiontimeout = false;};
	//if ((damage _veh) >= 0.9) then {_endMissionFail = true;};
};

/* End Mission Fail Condition Specific for OP Dick Move Only
if (_endMissionFail) exitWith 
	{
		_veh setDamage 1;
		clean_running_minor_mission = True;
		["minorclean"] call WAIcleanup;
		diag_log format["WAI: Mission %1 Failed at %2 Players destroyed the %3",_fileName,_position,_vehname];
		[nil,nil,rTitleText,format["%1",_destroyedMessage], "PLAIN",10] call RE;
		minor_missionrunning = false;
		sleep 0.1;
		deleteVehicle _veh;
	};
*/
if (_playerPresent && !_endMissionFail) then {
	[_position,"WAIminorArray"] call missionComplete;
	
	[_veh] call fn_tempStarter;
	// UNLOCK AFTER PUBLISH
	_veh setVehicleLock "UNLOCKED";
	_veh setVariable ["R3F_LOG_disabled",false,true];
	
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