private ["_playerPresent","_cleanmission","_currenttime","_starttime","_missiontimeout","_vehname","_veh","_position","_vehclass","_vehdir","_objPosition","_picture","_hint","_missionName"];

_vehclass = civil_vehicles call BIS_fnc_selectRandom;
_vehname	= getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");

_missionName = "Stash House";

_position = [getMarkerPos "center",0,5500,10,0,2000,0] call BIS_fnc_findSafePos;
diag_log format["WAI: Mission stashHouse Started At %1",_position];

_picture = getText (configFile >> "cfgVehicles" >> _vehclass >> "picture");


// STASH HOUSE 
_base = createVehicle ["Land_HouseV_1I4",_position, [], 0, "CAN_COLLIDE"];
_base setDir 152.66766;
_base1 = createVehicle ["Land_kulna",[(_position select 0) + 5.4585, (_position select 1) - 2.885,0],[], 0, "CAN_COLLIDE"];
_base1 setDir -28.282881;

_box = createVehicle ["USBasicAmmunitionBox",[(_position select 0) + 0.7408, (_position select 1) + 1.565, 0.10033049], [], 0, "CAN_COLLIDE"];
[_box] call Medical_Supply_Box;

_box1 = createVehicle ["USBasicAmmunitionBox",[(_position select 0) - 0.2387, (_position select 1) + 1.043, 0.10033049], [], 0, "CAN_COLLIDE"];
[_box1] call Medium_Gun_Box;

// civ car
_veh = createVehicle [_vehclass,[(_position select 0) - 10.6206, (_position select 1) - 0.49,0], [], 0, "CAN_COLLIDE"];
_vehdir = round(random 360);
_veh setDir _vehdir;
clearWeaponCargoGlobal _veh;
clearMagazineCargoGlobal _veh;
_veh setVariable ["ObjectID","1",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_veh];
diag_log format["WAI: Mission stashHouse spawned a %1",_vehname];

_objPosition = getPosATL _veh;
//[_veh,[_vehdir,_objPosition],_vehclass,true,"0"] call custom_publish;

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

[[_position select 0, _position select 1, 0],                  //position
4,						  //Number Of units
1,					      //Skill level 0-1. Has no effect if using custom skills
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"",						  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
true
] call spawn_group;



//CREATE MARKER
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

[nil,nil,rTitleText,"Bandits have set up a Weapon Stash House!\nGo Empty it Out!", "PLAIN",10] call RE;

_hint = parseText format ["<t align='center' color='#FF0000' shadow='2' size='1.75'>Priority Transmission</t><br/><t align='center' color='#FF0000'>------------------------------</t><br/><t align='center' color='#FFFFFF' size='1.25'>Side Mission</t><br/><t align='center' color='#FFFFFF'>%2 : Bandits have set up a Weapon Stash House! Go Empty it Out!</t>", _picture, _missionName];
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
	[_veh,[_vehdir,_objPosition],_vehclass,true,"0"] call custom_publish;
	waitUntil
	{
		sleep 5;
		_playerPresent = false;
		{if((isPlayer _x) AND (_x distance _position <= 30)) then {_playerPresent = true};}forEach playableUnits;
		(_playerPresent)
	};
	diag_log format["WAI: Mission stashHouse Ended At %1",_position];
	[nil,nil,rTitleText,"The Stash House is under Survivor Control!", "PLAIN",10] call RE;
	deleteMarker "_Minor1";
	deleteMarker "_Minor2";
} else {
	clean_running_minor_mission = True;
	deleteVehicle _veh;
	deleteVehicle _box;
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
	
	diag_log format["WAI: Mission stashHouse Timed Out At %1",_position];
	[nil,nil,rTitleText,"Time's up! MISSION FAILED", "PLAIN",10] call RE;
	deleteMarker "_Minor1";
	deleteMarker "_Minor2";
};
minor_missionrunning = false;