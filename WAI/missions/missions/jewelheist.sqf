// Jewel Heist by JakeHekesFists

private ["_playerPresent","_cleanmission","_currenttime","_starttime","_missiontimeout","_vehname","_veh","_position","_vehclass","_vehdir","_objPosition","_missionName","_hint","_picture","_tanktraps","_difficulty"];

_vehclass = armed_vehicle call BIS_fnc_selectRandom;

_vehname	= getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");
_missionName = "Jewel Heist";
_picture = getText (configFile >> "CfgMagazines" >> "ItemRuby" >> "picture");
_difficulty = "extreme";

_positionarray = [[7352.2676,4199.4844,0],[10100.15,4907.896,0],[11468.288, 8656.8252,0],[12853.731,13510.467,0],[11628.281,13562.116,0],[10249.764,12872.967,0],[5314.1094,13544.473,0],[2354.7388,12587.786,0],[1485.0314,8441.3887,0]];
_position = _positionarray call BIS_fnc_selectRandom;

// deploy roadkill defense (or not)
if(wai_enable_tank_traps) then {
_tanktraps = [_position] call tank_traps;
};


// Armed Vehicle
_veh = createVehicle [_vehclass,_position, [], 0, "CAN_COLLIDE"];
_vehdir = round(random 360);
_veh setDir _vehdir;
clearWeaponCargoGlobal _veh;
clearMagazineCargoGlobal _veh;
_veh setVariable ["ObjectID","1",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_veh];
diag_log format["WAI: Mission Jewel Heist spawned a %1",_vehname];

_objPosition = getPosATL _veh;
//[_veh,[_vehdir,_objPosition],_vehclass,true,"0"] call custom_publish;


//Troops
_rndnum = round (random 3) + 3;
[[_position select 0, _position select 1, 0],                  //position
_rndnum,						  //Number Of units
"extreme",					      //Skill level
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"",						  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
"major",
"WAImajorArray"
] call spawn_group;

[[_position select 0, _position select 1, 0],                  //position
4,						  //Number Of units
"extreme",					      //Skill level
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"",						  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
"major",
"WAImajorArray"
] call spawn_group;

[[_position select 0, _position select 1, 0],                  //position
4,						  //Number Of units
"extreme",					      //Skill level
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"",						  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
"major",
"WAImajorArray"
] call spawn_group;

[[_position select 0, _position select 1, 0],                  //position
4,						  //Number Of units
"extreme",					      //Skill level
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"",						  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
"major",
"WAImajorArray"
] call spawn_group;

//Turrets
[[[(_position select 0) + 5, (_position select 1) + 7, 0],[(_position select 0) + 3.33, (_position select 1) - 9.45, 0]], //position(s) (can be multiple).
"M2StaticMG",             //Classname of turret
0.8,					  //Skill level 0-1. Has no effect if using custom skills
"",			  //Skin "" for random or classname here.
0,						  //Primary gun set number. "Random" for random weapon set. (not needed if ai_static_useweapon = False)
2,						  //Number of magazines. (not needed if ai_static_useweapon = False)
"",						  //Backpack "" for random or classname here. (not needed if ai_static_useweapon = False)
"Random",				  //Gearset number. "Random" for random gear set. (not needed if ai_static_useweapon = False)
"major"
] call spawn_static;

//CREATE MARKER
[_position,_missionName,_difficulty] execVM wai_marker;

_hint = parseText format ["
	<t align='center' color='#1E90FF' shadow='2' size='1.75'>Priority Transmission</t><br/>
	<t align='center' color='#FFFFFF'>------------------------------</t><br/>
	<t align='center' color='#1E90FF' size='1.25'>Main Mission</t><br/>
	<t align='center' color='#FFFFFF' size='1.15'>Difficulty: <t color='#1E90FF'> EXTREME</t><br/>
	<t align='center'><img size='5' image='%1'/></t><br/>
	<t align='center' color='#FFFFFF'>A group of bandits have pulled off a jewel heist!</t><br/>
	<t align='center' color='#FFFFFF'>They have been spotted in the woods. Kill them all and secure the jewels for yourself!</t>", 
	_picture
	];
[nil,nil,rHINT,_hint] call RE;

[nil,nil,rTitleText,"A group of Bandits have just pulled off a Jewel Heist\nThey have been spotted in the woods. kill them all and secure the jewels for yourself", "PLAIN",10] call RE;

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
	[_position,"WAImajorArray"] call missionComplete;
	// wait for mission complete. then spawn box and save vehicle to hive

	_box = createVehicle ["BAF_VehicleBox",[(_position select 0),(_position select 1) + 5,0], [], 0, "CAN_COLLIDE"];
	[_box] call Jewel_Heist_Box;// Crate full of jewels

	// mark crates with smoke/flares
	[_box] call markCrates;

	[_veh,[_vehdir,_objPosition],_vehclass,true,"0"] call custom_publish;

	diag_log format["WAI: Mission Jewel Heist Ended At %1",_position];
	[nil,nil,rTitleText,"Survivors have killed the bandits and taken the jewels,\nWell Done!", "PLAIN",10] call RE;
	uiSleep 300;
	["majorclean"] call WAIcleanup;
} else {
	clean_running_mission = True;
	deleteVehicle _veh;
	["majorclean"] call WAIcleanup;
	
	diag_log format["WAI: Mission Jewel Heist Timed Out At %1",_position];
	[nil,nil,rTitleText,"The bandits got away with the jewels!", "PLAIN",10] call RE;
};
missionrunning = false;