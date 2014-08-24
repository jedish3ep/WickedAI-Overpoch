private ["_playerPresent","_cleanmission","_currenttime","_starttime","_missiontimeout","_vehname","_veh","_position","_vehclass","_vehdir","_objPosition","_picture","_hint","_smokeColours","_smokey","_missionName"];
_vehclass = "BRDM2_HQ_Gue";

wai_smoke = true;

_vehname	= getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");
_missionName = "Russian Outpost";

_position = [getMarkerPos "center",0,5500,10,0,2000,0] call BIS_fnc_findSafePos;
diag_log format["WAI: Mission rusBase Started At %1",_position];

_picture = getText (configFile >> "cfgVehicles" >> _vehclass >> "picture");


_smokeColours = ["SmokeShellGreen","SmokeShellRed","SmokeShellBlue","SmokeShellOrange"];
_smokey = _smokeColours call BIS_fnc_selectRandom;

// BUILDINGS
// center Anti Air tower
_baserunover = createVehicle ["TK_GUE_WarfareBAntiAirRadar_EP1",[(_position select 0), (_position select 1)],[], 0, "CAN_COLLIDE"];
_baserunover setVectorUp surfaceNormal position _baserunover;
// UAV Tower
_baserunover1 = createVehicle ["US_WarfareBUAVterminal_Base_EP1",[(_position select 0) + 1.0205, (_position select 1) - 16.6372],[], 0, "CAN_COLLIDE"];
_baserunover1 setVectorUp surfaceNormal position _baserunover1;
// HQ Unfolded
_baserunover2 = createVehicle ["M1130_HQ_unfolded_EP1",[(_position select 0) - 15.2851, (_position select 1) - 1.289],[], 0, "CAN_COLLIDE"];
_baserunover2 setDir 3.1487305;
_baserunover2 setVectorUp surfaceNormal position _baserunover2;
// light factory
_baserunover3 = createVehicle ["TK_WarfareBLightFactory_EP1",[(_position select 0) + 16.2246, (_position select 1) - 1.4355],[], 0, "CAN_COLLIDE"];
_baserunover3 setVectorUp surfaceNormal position _baserunover3;
// fire barrel
_baserunover4 = createVehicle ["Land_Fire_barrel_burning",[(_position select 0) - 1.5107, (_position select 1) + 9.8081],[], 0, "CAN_COLLIDE"];
_baserunover4 setVectorUp surfaceNormal position _baserunover4;
// russian flag
_baserunover5 = createVehicle ["FlagCarrierRU",[(_position select 0) - 0.7871, (_position select 1) + 9.979],[], 0, "CAN_COLLIDE"];
_baserunover5 setVectorUp surfaceNormal position _baserunover5;

// SMOKE EFFECTS
if(wai_smoke) then {
	_smoke1 = createVehicle [_smokey,[(_position select 0) - 9.6377,(_position select 1) - 11.9394,0], [], 0, "CAN_COLLIDE"];
	_smoke2 = createVehicle [_smokey,[(_position select 0) + 13.1592,(_position select 1) - 1.2251,0], [], 0, "CAN_COLLIDE"];
	_smoke3 = createVehicle [_smokey,[(_position select 0),(_position select 1) + 8,0], [], 0, "CAN_COLLIDE"];
	_smoke4 = createVehicle [_smokey,[(_position select 0) - 13,(_position select 1) - 2,0], [], 0, "CAN_COLLIDE"];
	sleep 25; 
};

// Building Supplies
_box = createVehicle ["USVehicleBox",[(_position select 0) + 6.6914,(_position select 1) + 1.1939,0], [], 0, "CAN_COLLIDE"];
[_box] call Construction_Supply_Box;

// Weapons Crate
_box1 = createVehicle ["LocalBasicWeaponsBox",[(_position select 0) - 7.6396,(_position select 1) + 7.2813,0], [], 0, "CAN_COLLIDE"];
[_box1] call Large_Gun_Box;

// ARMOURED VEHICLE
_veh = createVehicle [_vehclass,[(_position select 0) + 6.8516,(_position select 1) + 14.3345,0], [], 0, "CAN_COLLIDE"];
_vehdir = round(random 360);
_veh setDir _vehdir;
clearWeaponCargoGlobal _veh;
clearMagazineCargoGlobal _veh;
_veh setVariable ["ObjectID","1",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_veh];
diag_log format["WAI: Mission rusBase spawned a %1",_vehname];

_objPosition = getPosATL _veh;
//[_veh,[_vehdir,_objPosition],_vehclass,true,"0"] call custom_publish;

//Troops
_rndnum = round (random 3) + 4;
[[(_position select 0) - 23,(_position select 1) - 1.32, 0],                  //position
_rndnum,				  //Number Of units
1,					      //Skill level 0-1. Has no effect if using custom skills
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"RU_Commander",						  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
true
] call spawn_group;

[[(_position select 0) + 28,(_position select 1) + 1, 0],                  //position
4,						  //Number Of units
1,					      //Skill level 0-1. Has no effect if using custom skills
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"RU_Soldier_HAT",						  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
true
] call spawn_group;

[[(_position select 0) + 3.75,(_position select 1) - 11, 0],                  //position
4,						  //Number Of units
1,					      //Skill level 0-1. Has no effect if using custom skills
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"MVD_Soldier_Marksman",	  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
true					  // mission true
] call spawn_group;

[[(_position select 0) + 11.1,(_position select 1) + 12.1, 0],                  //position
4,						  //Number Of units
1,					      //Skill level 0-1. Has no effect if using custom skills
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"RUS_Soldier3",						  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
true						// mission true
] call spawn_group;

//Turrets
[[[(_position select 0), (_position select 1) + 21, 0],[(_position select 0), (_position select 1) - 25, 0]], //position(s) (can be multiple).
"KORD_high_TK_EP1",             //Classname of turret
0.8,					  //Skill level 0-1. Has no effect if using custom skills
"RU_Soldier_Pilot",			  //Skin "" for random or classname here.
0,						  //Primary gun set number. "Random" for random weapon set. (not needed if ai_static_useweapon = False)
2,						  //Number of magazines. (not needed if ai_static_useweapon = False)
"",						  //Backpack "" for random or classname here. (not needed if ai_static_useweapon = False)
"Random",				  //Gearset number. "Random" for random gear set. (not needed if ai_static_useweapon = False)
true
] call spawn_static;

//CREATE MARKER
[_position,_missionName] execVM wai_marker;

_hint = parseText format ["<t align='center' color='#FF0000' shadow='2' size='1.75'>Priority Transmission</t><br/><t align='center' color='#FF0000'>------------------------------</t><br/><t align='center' color='#FFFFFF' size='1.25'>Main Mission</t><br/><t align='center'><img size='5' image='%1'/></t><br/><t align='center' color='#FFFFFF'>The Russian Military is setting up an outpost, They have building supplies, weapons and a %2</t>", _picture, _vehname];
[nil,nil,rHINT,_hint] call RE;

[nil,nil,rTitleText,"Russian Troops have been spotted building an outpost", "PLAIN",10] call RE;

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
	diag_log format["WAI: Mission rusBase Ended At %1",_position];
	[nil,nil,rTitleText,"The RU Forces have been killed, Great Job!", "PLAIN",10] call RE;
	wai_smoke = false;
} else {
	clean_running_mission = True;
	deleteVehicle _veh;
	deleteVehicle _box;
	deleteVehicle _box1;	
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
	
	diag_log format["WAI: Mission rusBase Timed Out At %1",_position];
	[nil,nil,rTitleText,"Times Up! Mission Failed", "PLAIN",10] call RE;
	wai_smoke = false;
};
missionrunning = false;