private ["_positionarray", "_position", "_missionName", "_difficulty", "_missionDesc", "_winMessage", "_failMessage", "_missionType", "_picture", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box1", "_box2", "_box3"];

_positionarray = [[7352.2676,4199.4844,0],[10100.15,4907.896,0],[11468.288, 8656.8252,0],[12853.731,13510.467,0],[11628.281,13562.116,0],[10249.764,12872.967,0],[5314.1094,13544.473,0],[2354.7388,12587.786,0],[1485.0314,8441.3887,0]];
_position = _positionarray call BIS_fnc_selectRandom;

_missionName = "Sniper Squad";
_difficulty = "easy";
_missionDesc = "A Sniper Squad has been spotted in the Woods";
_winMessage = "Good job, the Sniper Squad has been eliminated";
_failMessage = "Time's Up! The Sniper Squad have escaped";
_missionType = "Minor Mission";
_picture = getText(configFile >> "CfgWeapons" >> "KSVK" >> "picture");

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_minor_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

//Troops
[[_position select 0, _position select 1, 0],                  //position
	5,							//Number Of units
	"easy",						//Skill level "normal" "hard" "extreme" or "random"
	3,							//Primary gun set number. "Random" for random weapon set.
	4,							//Number of magazines
	"",							//Backpack "" for random or classname here.
	"TK_Soldier_SniperH_EP1",	//Skin "" for random or classname here.
	"Random",				  //Gearset number. "Random" for random gear set.
	"minor",					//mission type
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
	
	_box1 = createVehicle ["AmmoBoxSmall_762",[(_position select 0) - 3.7251,(_position select 1) - 2.3614, 0],[], 0, "CAN_COLLIDE"];
	_box2 = createVehicle ["AmmoBoxSmall_762",[(_position select 0) - 3.4346, 0, 0],[], 0, "CAN_COLLIDE"];
	_box3 = createVehicle ["AmmoBoxSmall_762",[(_position select 0) + 4.0996,(_position select 1) + 3.9072, 0],[], 0, "CAN_COLLIDE"];
	sleep 0.5;
	[_box1] call markCrates;
	[_box2] call markCrates;
	[_box3] call markCrates;
	
	diag_log format["WAI: Mission %1 Ended At %2",_missionName,_position];
	[nil,nil,rTitleText,format["%1",_winMessage], "PLAIN",10] call RE;

	uiSleep 300;
	["minorclean"] call WAIcleanup;
} else {
	clean_running_minor_mission = True;
	["minorclean"] call WAIcleanup;
	diag_log format["WAI: Minor Mission %1 Timed Out At %2",_missionName,_position];
	[nil,nil,rTitleText,format["%1",_failMessage], "PLAIN",10] call RE;
};
minor_missionrunning = false;