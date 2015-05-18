private ["_fileName", "_position", "_missionName", "_missionType", "_difficulty", "_picture", "_missionDesc", "_winMessage", "_failMessage", "_net", "_artNest", "_bagFence", "_scenery", "_rndnum", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box", "_box1", "_box2", "_box3"];

_fileName = "easyWeaponsCrate";
_position = call WAI_findPos;

_missionName = "Weapons Crate";
_missionType = "Minor Mission";
_difficulty = "easy";
_picture = getText(configFile >> "CfgWeapons" >> "SCAR_H_STD_EGLM_Spect" >> "picture");
_missionDesc = "Bandits have stolen a shipment of weapons bound for the Black Market Trader";
_winMessage = "Good job, the bandits are Dead and the Weapons are now yours";
_failMessage = "Time's Up! The bandits have escaped with the weapons";

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_minor_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

/* Mission Scenery */
_net = createVehicle ["Land_CamoNetB_NATO",[(_position select 0) - 0.0649, (_position select 1) + 0.6025,0],[], 0, "CAN_COLLIDE"];
_artNest = createVehicle ["Land_fort_artillery_nest",[(_position select 0) - 5.939,(_position select 1) + 10.0459,0],[], 0, "CAN_COLLIDE"];
_artNest setDir -31.158424;
_bagFence = createVehicle ["Land_fort_bagfence_corner",[(_position select 0) - 0.8936, (_position select 1) + 8.1582,0],[], 0, "CAN_COLLIDE"];
_bagFence setDir -56.044361;

_scenery = [_net,_artNest,_bagFence];
{ minorBldList = minorBldList + [_x]; } forEach _scenery;
{ _x setVectorUp surfaceNormal position _x; } count _scenery;


//Troops
_rndnum = round (random 3) + 4;
[	
	[_position select 0, _position select 1, 0],
	_rndnum,			//Number Of units
	"easy",			//Skill level 0-1. Has no effect if using custom skills
	"Random",		//Primary gun set number. "Random" for random weapon set.
	3,				//Number of magazines
	"",				//Backpack "" for random or classname here.
	"",				//Skin "" for random or classname here.
	"Random",		//Gearset number. "Random" for random gear set.
	"minor",			
	"WAIminorArray"
] call spawn_group;
sleep 0.1;
[	
	[_position select 0, _position select 1, 0],
	2,				//Number Of units
	"easy",			//Skill level 0-1. Has no effect if using custom skills
	"Random",		//Primary gun set number. "Random" for random weapon set.
	3,				//Number of magazines
	"",				//Backpack "" for random or classname here.
	"",				//Skin "" for random or classname here.
	"Random",		//Gearset number. "Random" for random gear set.
	"minor",			
	"WAIminorArray"
] call spawn_group;

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
	[_position,"WAIminorArray"] call missionComplete;
	_box = createVehicle ["USVehicleBox",_position,[], 0, "CAN_COLLIDE"];
	[_box] call easyGunCrate;
	[_box] call markCrates;		// mark crates with smoke/flares
	_box1 = createVehicle ["AmmoBoxSmall_556",[(_position select 0) - 3.7251,(_position select 1) - 2.3614, 0],[], 0, "CAN_COLLIDE"];
	_box2 = createVehicle ["AmmoBoxSmall_762",[(_position select 0) - 3.4346, 0, 0],[], 0, "CAN_COLLIDE"];
	_box3 = createVehicle ["AmmoBoxSmall_556",[(_position select 0) + 4.0996,(_position select 1) + 3.9072, 0],[], 0, "CAN_COLLIDE"];
	diag_log format["WAI: Mission %1 Ended At %2",_fileName,_position];
	[nil,nil,rTitleText,format["%1",_winMessage], "PLAIN",10] call RE;
	
	uiSleep 300;
	["minorclean"] call WAIcleanup;
} else {
	clean_running_minor_mission = True;
	["minorclean"] call WAIcleanup;
	diag_log format["WAI: Mission %1 Timed Out At %2",_fileName,_position];
	[nil,nil,rTitleText,format["%1",_failMessage], "PLAIN",10] call RE;
};
minor_missionrunning = false;