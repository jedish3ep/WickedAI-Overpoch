private ["_playerPresent","_cleanmission","_currenttime","_starttime","_missiontimeout","_position","_hint","_missionName"];

_missionName = "Bandit Squad";

_position = [getMarkerPos "center",0,5500,10,0,2000,0] call BIS_fnc_findSafePos;
diag_log format["WAI: Mission bandSquad Started At %1",_position];

//Troops
_rndnum = round (random 3) + 4;
[[_position select 0, _position select 1, 0],                  //position
_rndnum,				  //Number Of units
1,					      //Skill level 0-1. Has no effect if using custom skills
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"",						  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
true
] call spawn_group;

//CREATE MARKER
while {minor_missionrunning} do {
	_Minor1 =	createMarker ["_Minor1", _position];
	_Minor1 setMarkerText "";
	_Minor1 setMarkerColor "ColorRed";
	_Minor1 setMarkerShape "ELLIPSE";
	_Minor1 setMarkerBrush "Solid";
	_Minor1 setMarkerSize [200,200];

	_Minor2 =	createMarker ["_Minor2", _position];
	_Minor2 setMarkerColor "ColorBlack";
	_Minor2 setMarkerType "mil_dot";
	_Minor2 setMarkerText _missionName;
	sleep 30;
	deleteMarker _Minor1;
	deleteMarker _Minor2;
};
if (_Minor1 == "Mission") then {
	deleteMarker _Minor1;
	deleteMarker _Minor2;
};

[nil,nil,rTitleText,"A Bandit Squad has been spotted!\nStop them from completing their patrol!", "PLAIN",10] call RE;

_hint = parseText format ["<t align='center' color='#FF0000' shadow='2' size='1.75'>Priority Transmission</t><br/><t align='center' color='#FF0000'>------------------------------</t><br/><t align='center' color='#FFFFFF' size='1.25'>Side Mission</t><br/><t align='center' color='#FFFFFF'>%1 : A Bandit Squad has been spotted! Stop them from completing their patrol!</t>", _missionName, _vehname];
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
	waitUntil
	{
		sleep 5;
		_playerPresent = false;
		{if((isPlayer _x) AND (_x distance _position <= 30)) then {_playerPresent = true};}forEach playableUnits;
		(_playerPresent)
	};
	diag_log format["WAI: Mission bandSquad Ended At %1",_position];
	[nil,nil,rTitleText,"All bandits bagged and tagged, Nice Work!", "PLAIN",10] call RE;
	deleteMarker "_Minor1";
	deleteMarker "_Minor2";
} else {
	clean_running_minor_mission = True;
	{_cleanunits = _x getVariable "missionclean";
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
	
	diag_log format["WAI: Mission bandSquad Timed Out At %1",_position];
	[nil,nil,rTitleText,"The Bandit Squad have completed their patrol - Mission Failed", "PLAIN",10] call RE;
	deleteMarker "_Minor1";
	deleteMarker "_Minor2";
};
minor_missionrunning = false;