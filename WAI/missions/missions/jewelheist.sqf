private ["_fileName", "_missionType", "_missionName", "_difficulty", "_positionarray", "_position", "_vehclass", "_vehname", "_picture", "_missionDesc", "_winMessage", "_failMessage", "_tanktraps", "_veh", "_vehdir", "_objPosition", "_rndnum", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box"];

_fileName = "jewelHeist";
_missionType = "Major Mission";
_missionName = "Jewel Heist";
_difficulty = "extreme";

_positionarray = [[7352.2676,4199.4844,0],[10100.15,4907.896,0],[11468.288, 8656.8252,0],[12853.731,13510.467,0],[11628.281,13562.116,0],[10249.764,12872.967,0],[5314.1094,13544.473,0],[2354.7388,12587.786,0],[1485.0314,8441.3887,0]];
_position = _positionarray call BIS_fnc_selectRandom;

_vehclass = armed_vehicle call BIS_fnc_selectRandom;
_vehname	= getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");
_picture = getText (configFile >> "CfgMagazines" >> "ItemRuby" >> "picture");

_missionDesc = format["A group of Bandits have just pulled off a %1 They have been spotted in the woods. kill them all and secure the jewels for yourself",_missionName];
_winMessage = "Survivors have killed the bandits and taken the jewels, Well Done!";
_failMessage = "The bandits got away with the jewels!";

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_major_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;


/* Tank Traps */
_tanktraps = [_position] call tank_traps;

/* Armed Vehicle */
_veh = createVehicle [_vehclass,_position, [], 0, "CAN_COLLIDE"];
_vehdir = round(random 360);
_veh setDir _vehdir;
clearWeaponCargoGlobal _veh;
clearMagazineCargoGlobal _veh;
_veh setVariable ["ObjectID","1",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_veh];
_veh setVehicleLock "LOCKED";
_veh setVariable ["R3F_LOG_disabled",true,true];
diag_log format["WAI: Mission Jewel Heist spawned a %1",_vehname];
_objPosition = getPosATL _veh;

/* Troops */
_rndnum = round (random 3) + 3;
[[_position select 0, _position select 1, 0],_rndnum,_difficulty,"Random",4,"","","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;
[[_position select 0, _position select 1, 0],4,_difficulty,"Random",4,"","","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;
[[_position select 0, _position select 1, 0],4,_difficulty,"Random",4,"","","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;
[[_position select 0, _position select 1, 0],4,_difficulty,"Random",4,"","","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;

/* Static Weapons */
[[[(_position select 0) + 5, (_position select 1) + 7, 0],[(_position select 0) + 3.33, (_position select 1) - 9.45, 0]],"M2StaticMG",0.8,"",0,2,"","Random","major"] call spawn_static;

_missiontimeout = true;
_cleanmission = false;
_playerPresent = false;
_starttime = floor(time);

while {_missiontimeout} do
	{
		sleep 5;
		_currenttime = floor(time);
		{if((isPlayer _x) AND (_x distance _position <= 300)) then {_playerPresent = true};}forEach playableUnits;
		if (_currenttime - _starttime >= wai_mission_timeout) then {_cleanmission = true;};
		if ((_playerPresent) OR (_cleanmission)) then {_missiontimeout = false;};
	};

if (_playerPresent) then 
	{
		[_position,"WAImajorArray"] call missionComplete;
		diag_log format["WAI: Mission %1 Ended At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_winMessage], "PLAIN",10] call RE;
		// wait for mission complete. then spawn box and save vehicle to hive

		_box = createVehicle ["BAF_VehicleBox",[(_position select 0),(_position select 1) + 5,0], [], 0, "CAN_COLLIDE"];
		[_box] call Jewel_Heist_Box;
		[_box] call markCrates;

		_veh setVehicleLock "UNLOCKED";
		_veh setVariable ["R3F_LOG_disabled",false,true];
		[_veh,[_vehdir,_objPosition],_vehclass,true,"0"] call custom_publish;

		uiSleep 300;
		["majorclean"] call WAIcleanup;
	}
		else
	{
		clean_running_mission = True;
		deleteVehicle _veh;
		["majorclean"] call WAIcleanup;
		
		diag_log format["WAI: Mission %1 Timed Out At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_failMessage], "PLAIN",10] call RE;
	};

missionrunning = false;