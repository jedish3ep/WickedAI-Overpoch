private ["_playerPresent","_cleanmission","_currenttime","_starttime","_missiontimeout","_vehname","_veh","_position","_vehclass","_vehdir","_objPosition","_picture","_hint","_missionName","_difficulty"];

_vehclass = "KamazReammo";

_vehname	= getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");
_missionName = _vehname;
_difficulty = "hard";

_position = [getMarkerPos "center",0,5500,10,0,2000,0] call BIS_fnc_findSafePos;
diag_log format["WAI: Mission vehAmmo Started At %1",_position];

_picture = getText (configFile >> "cfgVehicles" >> _vehclass >> "picture");

//Medical Supply Box
_box = createVehicle ["LocalBasicWeaponsBox",[(_position select 0) - 20,(_position select 1) - 20,0], [], 0, "CAN_COLLIDE"];
[_box] call Chain_Bullet_Box;

_box1 = createVehicle ["LocalBasicWeaponsBox",[(_position select 0) + 15,(_position select 1) + 15,0], [], 0, "CAN_COLLIDE"];
[_box1] call Chain_Bullet_Box;

//Medical Tent
_tent = createVehicle ["MAP_HBarrier5_round15",[(_position select 0) - 21,(_position select 1) - 21,0], [], 0, "CAN_COLLIDE"];
_tent setDir 270;
_tent2 = createVehicle ["MAP_HBarrier5_round15",[(_position select 0) + 16,(_position select 1) + 16,0], [], 0, "CAN_COLLIDE"];
_tent2 setDir 90;

//Truck
_veh = createVehicle [_vehclass,_position, [], 0, "CAN_COLLIDE"];
_vehdir = round(random 360);
_veh setDir _vehdir;
clearWeaponCargoGlobal _veh;
clearMagazineCargoGlobal _veh;
_veh setVariable ["ObjectID","1",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_veh];
diag_log format["WAI: Mission vehAmmo spawned a %1",_vehname];

_objPosition = getPosATL _veh;
//[_veh,[_vehdir,_objPosition],_vehclass,true,"0"] call custom_publish;

//Troops
_rndnum = round (random 3) + 4;
[[_position select 0, _position select 1, 0],                  //position
_rndnum,				  //Number Of units
"normal",					      //Skill level 0-1. Has no effect if using custom skills
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"TK_Soldier_B_EP1",						  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
"minor",
"WAIminorArray"
] call spawn_group;

[[_position select 0, _position select 1, 0],                  //position
4,						  //Number Of units
"hard",					      //Skill level 0-1. Has no effect if using custom skills
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"TK_Aziz_EP1",						  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
"minor",
"WAIminorArray"
] call spawn_group;

[[_position select 0, _position select 1, 0],                  //position
4,						  //Number Of units
"hard",					      //Skill level 0-1. Has no effect if using custom skills
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"TK_Commander_EP1",	  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
"minor",
"WAIminorArray"
] call spawn_group;

//Turrets
[[[(_position select 0) + 10, (_position select 1) + 10, 0],[(_position select 0) + 10, (_position select 1) - 10, 0]], //position(s) (can be multiple).
"M2StaticMG",             //Classname of turret
0.8,					  //Skill level 0-1. Has no effect if using custom skills
"TK_Soldier_Pilot_EP1",	  //Skin "" for random or classname here.
0,						  //Primary gun set number. "Random" for random weapon set. (not needed if ai_static_useweapon = False)
2,						  //Number of magazines. (not needed if ai_static_useweapon = False)
"",						  //Backpack "" for random or classname here. (not needed if ai_static_useweapon = False)
"Random",				  //Gearset number. "Random" for random gear set. (not needed if ai_static_useweapon = False)
"minor"
] call spawn_static;


//CREATE MARKER
[_position,_missionName,_difficulty] execVM wai_minor_marker;

[nil,nil,rTitleText,"A Truck carrying vehicle ammo has been spotted, Kill the militia and claim the ammo", "PLAIN",10] call RE;

_hint = parseText format ["
	<t align='center' color='#1E90FF' shadow='2' size='1.75'>Priority Transmission</t><br/>
	<t align='center' color='#FFFFFF'>------------------------------</t><br/>
	<t align='center' color='#1E90FF' size='1.25'>Side Mission</t><br/>
	<t align='center' color='#FFFFFF' size='1.15'>Difficulty: <t color='#1E90FF'> HARD</t><br/>
	<t align='center'><img size='5' image='%1'/></t><br/>
	<t align='center' color='#FFFFFF'>A<t color='#1E90FF'> %2</t> carrying Vehicle ammo has been spotted, Kill the militia and claim the ammo for yourself</t>", _picture, _vehname];
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
	[_position,"WAIminorArray"] call missionComplete;
	diag_log format["WAI: Mission vehAmmo Ended At %1",_position];
	[nil,nil,rTitleText,"Mission Complete - Job well done boys!", "PLAIN",10] call RE;
} else {
	clean_running_minor_mission = True;
	deleteVehicle _veh;
	deleteVehicle _box;
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
	
	diag_log format["WAI: Mission vehAmmo Timed Out At %1",_position];
	[nil,nil,rTitleText,"The militia escaped! Mission Failed", "PLAIN",10] call RE;
};
minor_missionrunning = false;