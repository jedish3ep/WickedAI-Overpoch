private ["_fileName", "_missionType", "_position", "_difficulty", "_vehclass", "_vehname", "_missionName", "_picture", "_missionDesc", "_winMessage", "_failMessage", "_tent", "_veh", "_vehdir", "_objPosition", "_rndnum", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box", "_box1"];

_fileName = "milVeh";
_missionType = "Major Mission";
_position = call WAI_findPos;
_difficulty = "hard";

_vehclass = "GAZ_Vodnik_HMG";
_vehname	= getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");
_missionName = _vehname;

_picture = getText (configFile >> "cfgVehicles" >> _vehclass >> "picture");

_missionDesc = format["The Russian Military has a %1 go take it off them!!",_vehname];
_winMessage = format["The Russians have been wiped out, and the %1 has been taken",_vehname];
_failMessage = format["Survivors did not secure the %1 in time!",_vehname];

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_major_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;


/* Scenery */
_tent = createVehicle ["Land_fort_rampart",[(_position select 0) - 21,(_position select 1) - 21,0], [], 0, "CAN_COLLIDE"];
majorBldList = majorBldList + [_tent];

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
diag_log format["WAI: Mission milVeh spawned a %1",_vehname];

_objPosition = getPosATL _veh;

/* Troops */
_rndnum = round (random 3) + 4;
[[_position select 0, _position select 1, 0],_rndnum,_difficulty,"Random",4,"","RU_Commander","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;
[[_position select 0, _position select 1, 0],4,_difficulty,"Random",4,"","RU_Soldier_HAT","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;
[[_position select 0, _position select 1, 0],4,_difficulty,"Random",4,"","MVD_Soldier_Marksman","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;
[[_position select 0, _position select 1, 0],4,_difficulty,"Random",4,"","RUS_Soldier3","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;

/* Static Guns */
[[[(_position select 0) + 10, (_position select 1) + 10, 0],[(_position select 0) + 10, (_position select 1) - 10, 0]],"M2StaticMG",0.8,"RU_Soldier_Pilot",0,2,"","Random","major"] call spawn_static;

/* Paradrop */
[[(_position select 0),(_position select 1),0],[(_position select 0) + 1500,(_position select 1),0],400,"BAF_Merlin_HC3_D",6,_difficulty,"Random",4,"","USMC_LHD_Crew_Blue","Random",False,"major","WAImajorArray"] spawn heli_para;

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
			
		// wait for mission complete, then spawn boxes and save vehicle to hive
		_veh setVehicleLock "UNLOCKED";
		_veh setVariable ["R3F_LOG_disabled",false,true];

		[_veh,[_vehdir,_objPosition],_vehclass,true,"0"] call custom_publish;
		
		_box = createVehicle ["LocalBasicWeaponsBox",[(_position select 0) - 20,(_position select 1) - 20,0], [], 0, "CAN_COLLIDE"];
		[_box] call Medical_Supply_Box;//Medical Supply Box
		_box1 = createVehicle ["LocalBasicWeaponsBox",[(_position select 0) + 15,(_position select 1) + 15,0], [], 0, "CAN_COLLIDE"];
		[_box1] call Large_Gun_Box;//Large Gun Box

		// mark crates with smoke/flares
		[_box] call markCrates;
		[_box1] call markCrates;

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