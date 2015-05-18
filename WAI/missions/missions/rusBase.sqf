private ["_playerPresent","_cleanmission","_currenttime","_starttime","_missiontimeout","_vehname","_veh","_position","_vehclass","_vehdir","_objPosition","_picture","_hint","_missionName","_difficulty","_base"];
_vehclass = "BRDM2_HQ_Gue";

_vehname	= getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");
_missionName = "Russian Outpost";
_difficulty = "extreme";

_position = [getMarkerPos "center",0,5500,10,0,2000,0] call BIS_fnc_findSafePos;
diag_log format["WAI: Mission rusBase Started At %1",_position];

_picture = getText (configFile >> "cfgVehicles" >> _vehclass >> "picture");

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

_base = [_baserunover,_baserunover1,_baserunover2,_baserunover3,_baserunover4,_baserunover5];

{ majorBldList = majorBldList + [_x]; } forEach _base;
{ _x setVectorUp surfaceNormal position _x; } count _base;


// ARMOURED VEHICLE
_veh = createVehicle [_vehclass,[(_position select 0) + 6.8516,(_position select 1) + 14.3345,0], [], 0, "CAN_COLLIDE"];
_vehdir = round(random 360);
_veh setDir _vehdir;
clearWeaponCargoGlobal _veh;
clearMagazineCargoGlobal _veh;
_veh setVariable ["ObjectID","1",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_veh];
diag_log format["WAI: Mission rusBase spawned a %1",_vehname];
_veh setVehicleLock "LOCKED";
_veh setVariable ["R3F_LOG_disabled",true,true];

_objPosition = getPosATL _veh;
//[_veh,[_vehdir,_objPosition],_vehclass,true,"0"] call custom_publish;

//Troops
_rndnum = round (random 3) + 4;
[[(_position select 0) - 23,(_position select 1) - 1.32, 0],                  //position
_rndnum,				  //Number Of units
"extreme",					      //Skill level
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"RU_Commander",						  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
"major",
"WAImajorArray"
] call spawn_group;

[[(_position select 0) + 28,(_position select 1) + 1, 0],                  //position
4,						  //Number Of units
"extreme",					      //Skill level
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"RU_Soldier_HAT",						  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
"major",
"WAImajorArray"
] call spawn_group;

[[(_position select 0) + 3.75,(_position select 1) - 11, 0],                  //position
4,						  //Number Of units
"extreme",					      //Skill level
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"MVD_Soldier_Marksman",	  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
"major",
"WAImajorArray"
] call spawn_group;

[[(_position select 0) + 11.1,(_position select 1) + 12.1, 0],                  //position
4,						  //Number Of units
"extreme",					      //Skill level
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"RUS_Soldier3",						  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
"major",
"WAImajorArray"
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
	<t align='center' color='#FFFFFF'>The Russian Military is setting up an outpost, They have building supplies, weapons and a <t color='#1E90FF'>%2</t>", 
	_picture, 
	_vehname
	];
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
	[_position,"WAImajorArray"] call missionComplete;
	// wait for mission complete then spawn crates and publish vehicle to hive

	_veh setVehicleLock "UNLOCKED";
	_veh setVariable ["R3F_LOG_disabled",false,true];

	_box = createVehicle ["USVehicleBox",[(_position select 0) + 6.6914,(_position select 1) + 1.1939,0], [], 0, "CAN_COLLIDE"];
	[_box] call Construction_Supply_Box;// Building Supplies

	_box1 = createVehicle ["LocalBasicWeaponsBox",[(_position select 0) - 7.6396,(_position select 1) + 7.2813,0], [], 0, "CAN_COLLIDE"];
	[_box1] call Large_Gun_Box;// Weapons Crate

	[_veh,[_vehdir,_objPosition],_vehclass,true,"0"] call custom_publish;

	// mark crates with smoke/flares
	[_box] call markCrates;
	[_box1] call markCrates;

	diag_log format["WAI: Mission rusBase Ended At %1",_position];
	[nil,nil,rTitleText,"The RU Forces have been killed, Great Job!", "PLAIN",10] call RE;
	uiSleep 300;
	["majorclean"] call WAIcleanup;
} else {
	clean_running_mission = True;
	deleteVehicle _veh;
	
	["majorclean"] call WAIcleanup;
	
	diag_log format["WAI: Mission rusBase Timed Out At %1",_position];
	[nil,nil,rTitleText,"Times Up! Mission Failed", "PLAIN",10] call RE;
};
missionrunning = false;