private ["_playerPresent","_cleanmission","_currenttime","_starttime","_missiontimeout","_vehname","_veharray","_veh","_position","_vehclass","_vehdir","_objPosition","_picture","_hint","_missionName","_difficulty"];

_veharray = ["LAV25_HQ","BTR90_HQ","BTR60_TK_EP1","BAF_Jackal2_L2A1_w","HMMWV_M998_crows_MK19_DES_EP1"];
_vehclass = _veharray call BIS_fnc_selectRandom; 
_difficulty = "hard";

_vehname	= getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");
_missionName = "The Brotherhood of Steel";

_position = [getMarkerPos "center",0,5500,10,0,2000,0] call BIS_fnc_findSafePos;

diag_log format["WAI: Mission bosMilVeh Started At %1",_position];

_picture = getText (configFile >> "cfgVehicles" >> _vehclass >> "picture");


//Rampart Barrier
_base = createVehicle ["Land_fort_rampart",[(_position select 0) + 16,(_position select 1) + 16,0], [], 0, "CAN_COLLIDE"];
majorBldList = majorBldList + [_base];

//Vehicle
_veh = createVehicle [_vehclass,_position, [], 0, "CAN_COLLIDE"];
_vehdir = round(random 360);
_veh setDir _vehdir;
clearWeaponCargoGlobal _veh;
clearMagazineCargoGlobal _veh;
_veh setVariable ["ObjectID","1",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_veh];
diag_log format["WAI: Mission bosMilVeh spawned a %1",_vehname];
_veh setVehicleLock "LOCKED";
_veh setVariable ["R3F_LOG_disabled",true,true];

_objPosition = getPosATL _veh;
//[_veh,[_vehdir,_objPosition],_vehclass,true,"0"] call custom_publish;

//Troops
_rndnum = round (random 3) + 4;
[[_position select 0, _position select 1, 0],                  //position
_rndnum,				  //Number Of units
"hard",					  //Skill level
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"gsc_military_helmet_wdl",						  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
"major",
"WAImajorArray"
] call spawn_group;

[[_position select 0, _position select 1, 0],                  //position
_rndnum,					//Number Of units
"hard",					    //Skill level
"Random",					//Primary gun set number. "Random" for random weapon set.
4,							//Number of magazines
"",							//Backpack "" for random or classname here.
"gsc_military_helmet_wdlSNP",  //Skin "" for random or classname here.
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
"gsc_military_head_wdl_AT",	  //Skin "" for random or classname here.
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
"gsc_military_helmet_wdlSNP",						  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
"major",
"WAImajorArray"
] call spawn_group;

// STATIC WEAPONS
[[[(_position select 0) + 10, (_position select 1) + 10, 0]], //position(s) (can be multiple).
"M2StaticMG",             //Classname of turret
0.8,					  //Skill level 0-1. Has no effect if using custom skills
"gsc_scientist1",		  //Skin "" for random or classname here.
0,						  //Primary gun set number. "Random" for random weapon set. (not needed if ai_static_useweapon = False)
2,						  //Number of magazines. (not needed if ai_static_useweapon = False)
"",						  //Backpack "" for random or classname here. (not needed if ai_static_useweapon = False)
"Random",				  //Gearset number. "Random" for random gear set. (not needed if ai_static_useweapon = False)
"major"
] call spawn_static;

[_position,_missionName,_difficulty] execVM wai_marker;

[nil,nil,rTitleText,"The Brotherhood of Steel have stolen an armed vehicle\nKill Them and steal it back", "PLAIN",10] call RE;

_hint = parseText format ["
	<t align='center' color='#1E90FF' shadow='2' size='1.75'>Priority Transmission</t><br/>
	<t align='center' color='#FFFFFF'>------------------------------</t><br/>
	<t align='center' color='#1E90FF' size='1.25'>Main Mission</t><br/>
	<t align='center' color='#FFFFFF' size='1.15'>Difficulty: <t color='#1E90FF'> HARD</t><br/>
	<t align='center'><img size='5' image='%1'/></t><br/>
	<t align='center' color='#FFFFFF'>The Brotherhood of Steel have stolen a <t color='#1E90FF'> %2</t>go take it off them!!</t>", 
	_picture, 
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
	[_position,"WAImajorArray"] call missionComplete;
	
	[_veh,[_vehdir,_objPosition],_vehclass,true,"0"] call custom_publish;
	_veh setVehicleLock "UNLOCKED";
	_veh setVariable ["R3F_LOG_disabled",false,true];
	
	// wait for mission complete. then spawn crates
	_box = createVehicle ["LocalBasicWeaponsBox",[(_position select 0) + 15,(_position select 1) + 15,0], [], 0, "CAN_COLLIDE"];
	[_box] call Large_Gun_Box;// Gun Crate

	// mark crates with smoke/flares
	[_box] call markCrates;
	
	diag_log format["WAI: Mission bosMilVeh Ended At %1",_position];
	[nil,nil,rTitleText,"The Brotherhood have been beaten into submission, and the armed vehicle has been taken", "PLAIN",10] call RE;
	uiSleep 300;
	["majorclean"] call WAIcleanup;
} else {
	clean_running_mission = True;
	deleteVehicle _veh;
	["majorclean"] call WAIcleanup;
		
	diag_log format["WAI: Mission bosMilVeh Timed Out At %1",_position];
	[nil,nil,rTitleText,"The Brotherhood have escaped with the Armed Vehicle - Mission Failed", "PLAIN",10] call RE;
};
missionrunning = false;