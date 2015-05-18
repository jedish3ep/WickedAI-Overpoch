private ["_fileName", "_missionType", "_position", "_vehclass", "_vehname", "_picture", "_missionName", "_difficulty", "_missionDesc", "_winMessage", "_failMessage", "_tent", "_tent2", "_scenery", "_veh", "_rndnum", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box", "_box1"];

_fileName = "m2hummer";
_missionType = "Minor Mission";
_position = call WAI_findPos;

_vehclass = "HMMWV_M1151_M2_DES_EP1";
_vehname	= getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");
_picture = getText (configFile >> "cfgVehicles" >> _vehclass >> "picture");

_missionName = _vehname;
_difficulty = "normal";

_missionDesc = format["US Forces have been spotted with a %1 Kill the soldiers and make the vehicle your own!",_vehname];
_winMessage = format["US Forces have been wiped out, Good Work! the %1 is yours",_vehname];
_failMessage = format["The US Forces have left the Area with their %1 - Mission Failed!",_vehname];

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_minor_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

//Medical Tent
_tent = createVehicle ["Land_fort_rampart",[(_position select 0) - 21,(_position select 1),0], [], 0, "CAN_COLLIDE"];
_tent setDir 90;
_tent2 = createVehicle ["Land_fort_rampart",[(_position select 0) + 16,(_position select 1),0], [], 0, "CAN_COLLIDE"];
_tent2 setDir 270;
_scenery = [_tent,_tent2];

{ minorBldList = minorBldList + [_x]; } forEach _scenery;
{ _x setVectorUp surfaceNormal position _x; } count _scenery;

//Hummer
_veh = createVehicle [_vehclass,_position, [], 0, "CAN_COLLIDE"];
//[_veh,damage,fuel] call spawnTempVehicle;
[_veh,0,0.75] call spawnTempVehicle; 
_veh setVehicleLock "LOCKED";
_veh setVariable ["R3F_LOG_disabled",true,true];

//Troops
_rndnum = round (random 3) + 4;
[[_position select 0, _position select 1, 0],                  //position
_rndnum,				  //Number Of units
"normal",					      //Skill level 0-1. Has no effect if using custom skills
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"USMC_Soldier_LAT",						  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
"minor",
"WAIminorArray"
] call spawn_group;

[[_position select 0, _position select 1, 0],                  //position
4,						  //Number Of units
"normal",					      //Skill level 0-1. Has no effect if using custom skills
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"USMC_Soldier_SL",						  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
"minor",
"WAIminorArray"
] call spawn_group;

[[_position select 0, _position select 1, 0],                  //position
4,						  //Number Of units
"normal",					      //Skill level 0-1. Has no effect if using custom skills
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"USMC_SoldierM_Marksman",	  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
"minor",
"WAIminorArray"
] call spawn_group;

_missiontimeout = true;
_cleanmission = false;
_playerPresent = false;
_starttime = floor(time);

while {_missiontimeout} do 
	{
		sleep 5;
		_currenttime = floor(time);
		{if((isPlayer _x) AND (_x distance _position <= 150)) then {_playerPresent = true};}forEach playableUnits;
		if (_currenttime - _starttime >= wai_mission_timeout) then {_cleanmission = true;};
		if ((_playerPresent) OR (_cleanmission)) then {_missiontimeout = false;};
	};
if (_playerPresent) then {
	[_position,"WAIminorArray"] call missionComplete;
	/* wait for mission complete, then spawn crates and unlock vehicle */	
	_veh setVehicleLock "UNLOCKED";
	_veh setVariable ["R3F_LOG_disabled",false,true];

	_box = createVehicle ["LocalBasicWeaponsBox",[(_position select 0) - 20,(_position select 1),0], [], 0, "CAN_COLLIDE"];
	_box1 = createVehicle ["LocalBasicWeaponsBox",[(_position select 0) + 15,(_position select 1),0], [], 0, "CAN_COLLIDE"];

	[_box] call Medical_Supply_Box; // med supplies
	[_box1] call Medium_Gun_Box; // med gun box
	// mark crates with smoke/flares
	[_box] call markCrates;
	[_box1] call markCrates;
	diag_log format["WAI: Mission %1 Ended At %2",_fileName,_position];
	[nil,nil,rTitleText,format["%1",_winMessage], "PLAIN",10] call RE;
} else {
	clean_running_minor_mission = True;
	["minorclean"] call WAIcleanup;
	diag_log format["WAI: Mission %1 Timed Out At %2",_fileName,_position];
	[nil,nil,rTitleText,format["%1",_failMessage], "PLAIN",10] call RE;
};
minor_missionrunning = false;