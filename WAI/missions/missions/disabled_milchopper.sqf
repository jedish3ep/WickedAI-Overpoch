//Military Chopper

private ["_playerPresent","_cleanmission","_currenttime","_starttime","_missiontimeout","_vehname","_veh","_position","_vehclass","_vehdir","_objPosition","_missionName","_hint","_picture","_tanktraps","_difficulty"];

_vehclass = armed_chopper call BIS_fnc_selectRandom;

_vehname	= getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");
_picture = getText (configFile >> "cfgVehicles" >> _vehclass >> "picture");

_missionName = _vehname;
_difficulty = "hard";

_position = [getMarkerPos "center",0,5500,10,0,2000,0] call BIS_fnc_findSafePos;
diag_log format["WAI: Mission Armed Chopper Started At %1",_position];

// deploy roadkill defense (or not)
if(wai_enable_tank_traps) then {
_tanktraps = [_position] call tank_traps;
};


//Military Chopper
_veh = createVehicle [_vehclass,_position, [], 0, "CAN_COLLIDE"];
_vehdir = round(random 360);
_veh setDir _vehdir;
clearWeaponCargoGlobal _veh;
clearMagazineCargoGlobal _veh;
_veh setVariable ["ObjectID","1",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_veh];
_veh setVehicleLock "LOCKED";
_veh setVariable ["R3F_LOG_disabled",true,true];
diag_log format["WAI: Mission Armed Chopper spawned a %1",_vehname];

_objPosition = getPosATL _veh;
//[_veh,[_vehdir,_objPosition],_vehclass,true,"0"] call custom_publish;


//Troops
_rndnum = round (random 3) + 3;
[[_position select 0, _position select 1, 0],                  //position
_rndnum,				  //Number Of units
"hard",					  //Skill level
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
"hard",					  //Skill level
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
"hard",					  //Skill level
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
"hard",					  //Skill level
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"",						  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
"major",
"WAImajorArray"
] call spawn_group;

//Turrets
[[[(_position select 0), (_position select 1) + 10, 0]], //position(s) (can be multiple).
"M2StaticMG",             //Classname of turret
0.8,					  //Skill level 0-1. Has no effect if using custom skills
"",				          //Skin "" for random or classname here.
1,						  //Primary gun set number. "Random" for random weapon set. (not needed if ai_static_useweapon = False)
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
	<t align='center' color='#FFFFFF' size='1.15'>Difficulty: <t color='#1E90FF'> HARD</t><br/>
	<t align='center'><img size='5' image='%1'/></t><br/>
	<t align='center' color='#FFFFFF'>A bandit %2 is taking off with a crate of snipers! Save the cargo and keep the guns for yourself</t>", 
	_picture, 
	_vehname
	];
[nil,nil,rHINT,_hint] call RE;

[nil,nil,rTitleText,"A bandit helicopter is taking off with a crate of snipers! Save the cargo and keep the guns for yourself.", "PLAIN",10] call RE;

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
	// publish vehicle after mission complete.
	[_veh,[_vehdir,_objPosition],_vehclass,true,"0"] call custom_publish;
	_veh setVehicleLock "UNLOCKED";
	_veh setVariable ["R3F_LOG_disabled",false,true];
	// wait for mission complete. then spawn crates	
	_box = createVehicle ["BAF_VehicleBox",[(_position select 0),(_position select 1) + 5,0], [], 0, "CAN_COLLIDE"];
	[_box] call Sniper_Gun_Box; //Sniper Gun Box

	// mark crates with smoke/flares
	[_box] call markCrates;
	
	diag_log format["WAI: Mission armed chopper Ended At %1",_position];
	[nil,nil,rTitleText,"Survivors have secured the armed chopper!", "PLAIN",10] call RE;
	uiSleep 300;
	["majorclean"] call WAIcleanup;
} else {
	clean_running_mission = True;
	deleteVehicle _veh;
	["majorclean"] call WAIcleanup;
	
	diag_log format["WAI: Mission armed chopper Timed Out At %1",_position];
	[nil,nil,rTitleText,"Survivors did not secure the armed chopper in time!", "PLAIN",10] call RE;
};
missionrunning = false;