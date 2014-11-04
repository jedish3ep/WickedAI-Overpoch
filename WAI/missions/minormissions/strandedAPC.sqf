/*
	File: strandedAPC.sqf
	Author: JakeHekesFists[DMD]
	Description: Minor Mission for WAI
	An APC has run out of fuel. AI are waiting for reinforcements to arrive

	APC - No Damage
	No Fuel

	Large Box of Weapons
	3 Small Groups of hard AI
	1 Small Group of Normal AI
	1 Small Paradrop Reinforcement Group (x5)
*/

private ["_playerPresent","_cleanmission","_currenttime","_starttime","_missiontimeout","_vehname","_veh","_position","_vehclass","_picture","_hint","_missionName","_difficulty","_worldName","_vehArray"];

_vehArray = ["AAV","BMP2_UN_EP1","BAF_FV510_W","M1128_MGS_EP1"];
_vehclass = _vehArray call BIS_fnc_selectRandom;

_vehname	= getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");
_worldName = toLower format ["%1", worldName];

_missionName = "Stranded APC";
_difficulty = "hard";

_position = [getMarkerPos "center",0,5500,10,0,2000,0] call BIS_fnc_findSafePos;
diag_log format["WAI: Mission strandedAPC Started At %1",_position];

_picture = getText (configFile >> "cfgVehicles" >> _vehclass >> "picture");


// apc with no fuel
_veh = createVehicle [_vehclass,[(_position select 0) - 10.6206, (_position select 1) - 0.49,0], [], 0, "CAN_COLLIDE"];
[_veh,0,0] call spawnTempVehicle; 
//[_veh,damage,fuel] call spawnTempVehicle;

diag_log format["WAI: Mission strandedAPC spawned a %1",_vehname];


//Troops
_rndnum = round (random 3) + 4;
[[_position select 0, _position select 1, 0],5,"hard","Random",4,"","RU_Soldier_HAT","Random","minor","WAIminorArray"] call spawn_group;
[[_position select 0, _position select 1, 0],5,"hard","Random",4,"","RU_Soldier_Pilot","Random","minor","WAIminorArray"] call spawn_group;
[[_position select 0, _position select 1, 0],1,"hard","Random",4,"","RU_Commander","Random","minor","WAIminorArray"] call spawn_group;
[[_position select 0, _position select 1, 0],5,"normal","Random",4,"","RU_Soldier_HAT","Random","minor","WAIminorArray"] call spawn_group;

//Heli Paradrop
[[(_position select 0), (_position select 1), 0],[7743.41, 7040.93, 0],400,"UH60M_EP1_DZE",5,"hard","Random",4,"","RU_Soldier_Pilot","Random",False,"minor","WAIminorArray"] spawn heli_para;


//CREATE MARKER
[_position,_missionName,_difficulty] execVM wai_minor_marker;

[nil,nil,rTitleText,"An APC has run out of Fuel, The soldiers are waiting for reinforcements\nGo and claim the APC for yourselves", "PLAIN",10] call RE;

_hint = parseText format ["
	<t align='center' color='#1E90FF' shadow='2' size='1.75'>Priority Transmission</t><br/>
	<t align='center' color='#FFFFFF'>------------------------------</t><br/>
	<t align='center' color='#1E90FF' size='1.25'>Side Mission</t><br/>
	<t align='center' color='#FFFFFF' size='1.15'>Difficulty: <t color='#1E90FF'> NORMAL</t><br/>
	<t align='center'><img size='5' image='%1'/></t><br/>
	<t align='center' color='#FFFFFF'>%2 : An %4 has ran out of fuel. The soldiers are stranded and waiting for reinforcements! Kill Them and secure the vehicle and weapons for yourselves. Remember to bring some petrol.</t>",
	_picture, 
	_missionName, 
	_worldName,
	_vehname
];
[nil,nil,rHINT,_hint] call RE;

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
	// wait for mission complete then spawn box
	_box = createVehicle ["RULaunchersBox",[(_position select 0) + 0.7408, (_position select 1) + 4.565, 0.10033049], [], 0, "CAN_COLLIDE"];
	[_box] call Large_Gun_Box; // large gun box

	// mark crates with smoke/flares
	[_box] call markCrates;

	diag_log format["WAI: Mission strandedAPC Ended At %1",_position];
	[nil,nil,rTitleText,"The Crashed Weapons Truck has been Secured", "PLAIN",10] call RE;
	uiSleep 300;
	["minorclean"] call WAIcleanup;
} else {
	clean_running_minor_mission = True;
	deleteVehicle _veh;
	["minorclean"] call WAIcleanup;
	
	diag_log format["WAI: Mission strandedAPC Timed Out At %1",_position];
	[nil,nil,rTitleText,"You Failed to Clear the Mission in Time", "PLAIN",10] call RE;
};

minor_missionrunning = false;