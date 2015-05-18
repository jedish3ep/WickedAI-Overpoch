private ["_fileName", "_missionType", "_position", "_missionName", "_difficulty", "_picture", "_missionDesc", "_winMessage", "_failMessage", "_vehclass", "_vehclass2", "_vehclass3", "_veh", "_vehdir", "_objPosition", "_veh2", "_veh3", "_vehList", "_rndnum", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box"];

_fileName = "convoy";
_missionType = "Major Mission";
_position = call WAI_findPos;

_missionName = "Ikea Convoy";
_difficulty = "extreme";
_picture = getText (configFile >> "CfgMagazines" >> "CinderBlocks" >> "picture");

_missionDesc = "An Ikea delivery has been hijacked by Bandits, Take over the convoy and the building supplies are all yours!";
_winMessage = "Survivors have secured the building supplies!";
_failMessage = "Survivors did not secure the convoy in time!";

_vehclass = cargo_trucks call BIS_fnc_selectRandom;
_vehclass2 = refuel_trucks call BIS_fnc_selectRandom;
_vehclass3 = military_unarmed call BIS_fnc_selectRandom;

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_major_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;


_veh = createVehicle [_vehclass,[(_position select 0) - 15,(_position select 1),0], [], 0, "CAN_COLLIDE"];
_vehdir = round(random 360);
_veh setDir _vehdir;
clearWeaponCargoGlobal _veh;
clearMagazineCargoGlobal _veh;
_veh setVariable ["ObjectID","1",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_veh];
diag_log format["WAI: Mission Convoy spawned a %1",_vehclass];
_veh setVehicleLock "LOCKED";
_veh setVariable ["R3F_LOG_disabled",true,true];

_objPosition = getPosATL _veh;
// CARGO TRUCK WILL SAVE! 

_veh2 = createVehicle [_vehclass2,[(_position select 0) + 15,(_position select 1),0], [], 0, "CAN_COLLIDE"];
[_veh2,0.25,0.75] call spawnTempVehicle;
_veh2 setVehicleLock "LOCKED";
_veh2 setVariable ["R3F_LOG_disabled",true,true];
//[_veh,damage,fuel] call spawnTempVehicle;

_veh3 = createVehicle [_vehclass3,[(_position select 0) + 30,(_position select 1),0], [], 0, "CAN_COLLIDE"];
[_veh3,0.75,0.67] call spawnTempVehicle;
_veh3 setVehicleLock "LOCKED";
_veh3 setVariable ["R3F_LOG_disabled",true,true];
//[_veh,damage,fuel] call spawnTempVehicle;

_vehList = [_veh,_veh2,_veh3];

//Troops
_rndnum = round (random 3) + 5;
[[_position select 0, _position select 1, 0],_rndnum,"extreme","Random",4,"","USMC_LHD_Crew_Yellow","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;
[[_position select 0, _position select 1, 0],5,"extreme","Random",4,"","USMC_LHD_Crew_Blue","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;
[[_position select 0, _position select 1, 0],5,"extreme","Random",4,"","USMC_LHD_Crew_Blue","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;
[[_position select 0, _position select 1, 0],5,"extreme","Random",4,"","USMC_LHD_Crew_Blue","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;

//Turrets
[[[(_position select 0) + 5, (_position select 1) + 10, 0]],"M2StaticMG",0.7,"USMC_LHD_Crew_Yellow",1,2,"","Random","major"] call spawn_static;
[[[(_position select 0) - 5, (_position select 1) - 10, 0]],"M2StaticMG",0.7,"USMC_LHD_Crew_Blue",1,2,"","Random","major"] call spawn_static;

_missiontimeout = true;
_cleanmission = false;
_playerPresent = false;
_starttime = floor(time);

while {_missiontimeout} do 
	{
		sleep 5;
		_currenttime = floor(time);
		{if((isPlayer _x) AND (_x distance _position <= 600)) then {_playerPresent = true};}forEach playableUnits;
		if (_currenttime - _starttime >= wai_mission_timeout) then {_cleanmission = true;};
		if ((_playerPresent) OR (_cleanmission)) then {_missiontimeout = false;};
	};
	
if (_playerPresent) then 
	{
		/* Wait for player present before sending in chopper */
		[[(_position select 0),(_position select 1),0],[(_position select 0) + 1500,(_position select 1),0],400,"BAF_Merlin_HC3_D",6,_difficulty,"Random",4,"","USMC_LHD_Crew_Blue","Random",False,"major","WAImajorArray"] spawn heli_para;
		
		[_position,"WAImajorArray"] call missionComplete;		
		diag_log format["WAI: Mission %1 Ended At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_winMessage], "PLAIN",10] call RE;
		
		[_veh,[_vehdir,_objPosition],_vehclass,true,"0"] call custom_publish;

		{_x setVehicleLock "UNLOCKED";_x setVariable ["R3F_LOG_disabled",false,true];} forEach _vehList;
		
		//wait for mission complete. then spawn crates
		_box = createVehicle ["BAF_VehicleBox",[(_position select 0),(_position select 1),0], [], 0, "CAN_COLLIDE"];
		[_box] call Construction_Supply_box;
		[_box] call markCrates;

		uiSleep 300;
		["majorclean"] call WAIcleanup;
	}
		else
	{
		clean_running_mission = True;
		{deleteVehicle _x;} forEach _vehList;
		["majorclean"] call WAIcleanup;
		
		diag_log format["WAI: Mission %1 Timed Out At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_failMessage], "PLAIN",10] call RE;
	};
	
missionrunning = false;