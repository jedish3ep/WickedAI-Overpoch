/*
	File: strandedAPC.sqf
	Author: JakeHekesFists[DMD]
	Description: Minor Mission for WAI
	An APC has run out of fuel. AI are waiting for reinforcements to arrive
*/

private ["_playerPresent","_cleanmission","_currenttime","_starttime","_missiontimeout","_vehname","_veh","_position","_vehclass","_picture","_hint","_missionName","_difficulty","_worldName","_vehArray"];

_fileName = "strandedAPC";
_missionName = "Stranded APC";
_difficulty = "hard";
_missionType = "Minor Mission";

_position = call WAI_findPos;

_vehArray = ["AAV","BMP2_UN_EP1","BAF_FV510_W","M1128_MGS_EP1"];
_vehclass = _vehArray call BIS_fnc_selectRandom;
_picture = getText (configFile >> "cfgVehicles" >> _vehclass >> "picture");
_vehname	= getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");

_missionDesc = format["An %1 has ran out of fuel. The soldiers are stranded and waiting for reinforcements! Kill Them and secure the vehicle and weapons for yourselves. Remember to bring some petrol.",_vehname];
_winMessage = format["The Stranded %1 Weapons Truck has been Secured",_vehname];
_failMessage = format["The %1 has been refuelled and has left the area MISSION FAILED",_vehname];


/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_minor_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;



// apc with no fuel
_veh = createVehicle [_vehclass,[(_position select 0) - 10.6206, (_position select 1) - 0.49,0], [], 0, "CAN_COLLIDE"];
[_veh,0,0] call spawnTempVehicle; 
//[_veh,damage,fuel] call spawnTempVehicle;
_veh setVehicleLock "LOCKED";
_veh setVariable ["R3F_LOG_disabled",true,true];

diag_log format["WAI: Mission %1 spawned a %2",_fileName,_vehname];


//Troops
_rndnum = round (random 3) + 4;
[[_position select 0, _position select 1, 0],5,_difficulty,"Random",4,"","RU_Soldier_HAT","Random","minor","WAIminorArray"] call spawn_group;
sleep 0.1;
[[_position select 0, _position select 1, 0],5,_difficulty,"Random",4,"","RU_Soldier_Pilot","Random","minor","WAIminorArray"] call spawn_group;
sleep 0.1;
[[_position select 0, _position select 1, 0],1,_difficulty,"Random",4,"","RU_Commander","Random","minor","WAIminorArray"] call spawn_group;
sleep 0.1;
[[_position select 0, _position select 1, 0],5,_difficulty,"Random",4,"","RU_Soldier_HAT","Random","minor","WAIminorArray"] call spawn_group;
sleep 0.1;
//Heli Paradrop
[[(_position select 0), (_position select 1), 0],[7743.41, 7040.93, 0],400,"UH60M_EP1_DZE",5,_difficulty,"Random",4,"","RU_Soldier_Pilot","Random",False,"minor","WAIminorArray"] spawn heli_para;


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
	
	diag_log format["WAI: Mission %1 Ended At %2",_fileName,_position];
	[nil,nil,rTitleText,format["%1",_winMessage], "PLAIN",10] call RE;
	
	_veh setVehicleLock "UNLOCKED";
	_veh setVariable ["R3F_LOG_disabled",false,true];
	// wait for mission complete then spawn box
	_box = createVehicle ["RULaunchersBox",[(_position select 0) + 0.7408, (_position select 1) + 4.565, 0.10033049], [], 0, "CAN_COLLIDE"];
	[_box] call Large_Gun_Box; // large gun box

	// mark crates with smoke/flares
	[_box] call markCrates;

	uiSleep 5*60;
	["minorclean"] call WAIcleanup;
} else {
	clean_running_minor_mission = True;
	deleteVehicle _veh;
	["minorclean"] call WAIcleanup;
	
	diag_log format["WAI: Mission %1 Timed Out At %2",_fileName,_position];
	[nil,nil,rTitleText,format["%1",_failMessage], "PLAIN",10] call RE;
};

minor_missionrunning = false;