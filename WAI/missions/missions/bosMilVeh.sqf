private ["_playerPresent","_cleanmission","_currenttime","_starttime","_missiontimeout","_vehname","_veharray","_veh","_position","_vehclass","_vehdir","_objPosition","_picture","_hint","_missionName"];

_veharray = ["LAV25_HQ","BTR90_HQ","BTR60_TK_EP1","BAF_Jackal2_L2A1_w","HMMWV_M998_crows_MK19_DES_EP1"];
_vehclass = _veharray call BIS_fnc_selectRandom; 

_vehname	= getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");
_missionName = "The Brotherhood of Steel";

_position = [getMarkerPos "center",0,5500,10,0,2000,0] call BIS_fnc_findSafePos;

diag_log format["WAI: Mission bosMilVeh Started At %1",_position];

_picture = getText (configFile >> "cfgVehicles" >> _vehclass >> "picture");



// Gun Crate
_box1 = createVehicle ["LocalBasicWeaponsBox",[(_position select 0) + 15,(_position select 1) + 15,0], [], 0, "CAN_COLLIDE"];
[_box1] call Large_Gun_Box;

//Rampart Barrier
_tent = createVehicle ["Land_fort_rampart",[(_position select 0) + 16,(_position select 1) + 16,0], [], 0, "CAN_COLLIDE"];

//Vehicle
_veh = createVehicle [_vehclass,_position, [], 0, "CAN_COLLIDE"];
_vehdir = round(random 360);
_veh setDir _vehdir;
clearWeaponCargoGlobal _veh;
clearMagazineCargoGlobal _veh;
_veh setVariable ["ObjectID","1",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_veh];
diag_log format["WAI: Mission bosMilVeh spawned a %1",_vehname];

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
"gsc_military_helmet_wdl",						  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
true
] call spawn_group;

[[_position select 0, _position select 1, 0],                  //position
_rndnum,						  //Number Of units
1,					      //Skill level 0-1. Has no effect if using custom skills
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"gsc_military_helmet_wdlSNP",						  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
true
] call spawn_group;

[[_position select 0, _position select 1, 0],                  //position
4,						  //Number Of units
1,					      //Skill level 0-1. Has no effect if using custom skills
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"gsc_military_head_wdl_AT",	  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
true					  // mission true
] call spawn_group;

[[_position select 0, _position select 1, 0],                  //position
4,						  //Number Of units
1,					      //Skill level 0-1. Has no effect if using custom skills
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"gsc_military_helmet_wdlSNP",						  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
true						// mission true
] call spawn_group;

//Turrets
[[[(_position select 0) + 10, (_position select 1) + 10, 0]], //position(s) (can be multiple).
"M2StaticMG",             //Classname of turret
0.8,					  //Skill level 0-1. Has no effect if using custom skills
"gsc_scientist1",		  //Skin "" for random or classname here.
0,						  //Primary gun set number. "Random" for random weapon set. (not needed if ai_static_useweapon = False)
2,						  //Number of magazines. (not needed if ai_static_useweapon = False)
"",						  //Backpack "" for random or classname here. (not needed if ai_static_useweapon = False)
"Random",				  //Gearset number. "Random" for random gear set. (not needed if ai_static_useweapon = False)
true
] call spawn_static;

[_position,_missionName] execVM wai_marker;

[nil,nil,rTitleText,"The Brotherhood of Steel have stolen an armed vehicle\nKill Them and steal it back", "PLAIN",10] call RE;

_hint = parseText format ["<t align='center' color='#FF0000' shadow='2' size='1.75'>Priority Transmission</t><br/><t align='center' color='#FF0000'>------------------------------</t><br/><t align='center' color='#FFFFFF' size='1.25'>Main Mission</t><br/><t align='center'><img size='5' image='%1'/></t><br/><t align='center' color='#FFFFFF'>The Brotherhood of Steel have stolen a<t color='#FF0000'> %2</t>go take it off them!!</t>", _picture, _vehname];
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
	diag_log format["WAI: Mission bosMilVeh Ended At %1",_position];
	[nil,nil,rTitleText,"The Brotherhood have been beaten into submission, and the armed vehicle has been taken", "PLAIN",10] call RE;
} else {
	clean_running_mission = True;
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
	
	diag_log format["WAI: Mission bosMilVeh Timed Out At %1",_position];
	[nil,nil,rTitleText,"The Brotherhood have escaped with the Armed Vehicle - Mission Failed", "PLAIN",10] call RE;
};
missionrunning = false;