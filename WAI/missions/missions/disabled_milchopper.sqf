private ["_fileName", "_missionType", "_position", "_vehclass", "_vehname", "_picture", "_missionName", "_difficulty", "_missionDesc", "_winMessage", "_failMessage", "_tanktraps", "_veh", "_vehdir", "_objPosition", "_rndnum", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box"];

_fileName = "disabled_milchopper";
_missionType = "Major Mission";
_position = call WAI_findPos;

_vehclass = armed_chopper call BIS_fnc_selectRandom;
_vehname = getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");
_picture = getText (configFile >> "cfgVehicles" >> _vehclass >> "picture");

_missionName = format["Disabled %1",_vehname];
_difficulty = "hard";

_missionDesc = format["A bandit %1 is taking off with a crate of Sniper Rifles! Save the cargo and keep the guns for yourself",_vehname];
_winMessage = format["Survivors have secured the %1",_vehname];
_failMessage = format["Survivors did not secure the %1 in time!",_vehname];

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_major_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

/* secure the area with tank traps */
_tanktraps = [_position] call tank_traps;

/* Vehicle */
_veh = createVehicle [_vehclass,_position, [], 0, "CAN_COLLIDE"];
_vehdir = round(random 360);
_veh setDir _vehdir;
clearWeaponCargoGlobal _veh;
clearMagazineCargoGlobal _veh;
_veh setVariable ["ObjectID","1",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_veh];
_veh setVehicleLock "LOCKED";
_veh setVariable ["R3F_LOG_disabled",true,true];
diag_log format["WAI: Mission %1 spawned a %2",_fileName,_vehname];
_objPosition = getPosATL _veh;

/* Troops */
_rndnum = round (random 3) + 3;
[[_position select 0, _position select 1, 0],_rndnum,_difficulty,"Random",4,"","","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;
[[_position select 0, _position select 1, 0],4,_difficulty,"Random",4,"","","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;
[[_position select 0, _position select 1, 0],4,_difficulty,"Random",4,"","","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;
[[_position select 0, _position select 1, 0],4,_difficulty,"Random",4,"","","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;

/* Static Weapons */
[[[(_position select 0), (_position select 1) + 10, 0]],"M2StaticMG",0.8,"",1,2,"","Random","major"] call spawn_static;

_missiontimeout = true;
_cleanmission = false;
_playerPresent = false;
_starttime = floor(time);

while {_missiontimeout} do 
	{
		sleep 5;
		_currenttime = floor(time);
		{if((isPlayer _x) AND (_x distance _position <= 500)) then {_playerPresent = true};}forEach playableUnits;
		if (_currenttime - _starttime >= wai_mission_timeout) then {_cleanmission = true;};
		if ((_playerPresent) OR (_cleanmission)) then {_missiontimeout = false;};
	};
	
if (_playerPresent) then 
	{
		[_position,"WAImajorArray"] call missionComplete;
		diag_log format["WAI: Mission %1 Ended At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_winMessage], "PLAIN",10] call RE;
		
		// publish vehicle after mission complete.
		[_veh,[_vehdir,_objPosition],_vehclass,true,"0"] call custom_publish;
		_veh setVehicleLock "UNLOCKED";
		_veh setVariable ["R3F_LOG_disabled",false,true];
		
		// wait for mission complete. then spawn crates	
		_box = createVehicle ["BAF_VehicleBox",[(_position select 0),(_position select 1) + 5,0], [], 0, "CAN_COLLIDE"];
		[_box] call Sniper_Gun_Box;
		[_box] call markCrates;

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