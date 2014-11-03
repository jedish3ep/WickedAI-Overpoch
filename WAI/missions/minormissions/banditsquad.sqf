private ["_playerPresent","_cleanmission","_currenttime","_starttime","_missiontimeout","_position","_hint","_missionName","_difficulty"];

_missionName = "Bandit Squad";
_difficulty = "normal";

_position = [getMarkerPos "center",0,5500,10,0,2000,0] call BIS_fnc_findSafePos;
diag_log format["WAI: Mission bandSquad Started At %1",_position];

//Troops
_rndnum = round (random 3) + 4;
[[_position select 0, _position select 1, 0],                  //position
_rndnum,				  //Number Of units
"normal",				  //Skill level "normal" "hard" "extreme" or "random"
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"",						  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
"minor",					  //mission type
"WAIminorArray"
] call spawn_group;

//CREATE MARKER
[_position,_missionName,_difficulty] execVM wai_minor_marker;

[nil,nil,rTitleText,"A Bandit Squad has been spotted!\nStop them from completing their patrol!", "PLAIN",10] call RE;

_hint = parseText format ["
	<t align='center' color='#1E90FF' shadow='2' size='1.75'>Priority Transmission</t><br/>
	<t align='center' color='#FFFFFF'>------------------------------</t><br/>
	<t align='center' color='#1E90FF' size='1.25'>Side Mission</t><br/>
	<t align='center' color='#FFFFFF' size='1.15'>Difficulty: <t color='#1E90FF'> NORMAL</t><br/>
	<t align='center' color='#FFFFFF'>%1 : A Bandit Squad has been spotted! Stop them from completing their patrol!</t>", 
	_missionName,
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
	diag_log format["WAI: Mission bandSquad Ended At %1",_position];
	[nil,nil,rTitleText,"All bandits bagged and tagged, Nice Work!", "PLAIN",10] call RE;
} else {
	clean_running_minor_mission = True;
	{_cleanunits = _x getVariable "minorclean";
	if (!isNil "_cleanunits") then {
		switch (_cleanunits) do {
			case "ground" :  {ai_ground_units = (ai_ground_units -1);};
			case "air" :     {ai_air_units = (ai_air_units -1);};
			case "vehicle" : {ai_vehicle_units = (ai_vehicle_units -1);};
			case "static" :  {ai_emplacement_units = (ai_emplacement_units -1);};
		};
		deleteVehicle _x;
		sleep 0.05;
	};	
	} forEach allUnits;
	
	diag_log format["WAI: Minor Mission bandSquad Timed Out At %1",_position];
	[nil,nil,rTitleText,"The Bandit Squad have completed their patrol - Mission Failed", "PLAIN",10] call RE;
};
minor_missionrunning = false;