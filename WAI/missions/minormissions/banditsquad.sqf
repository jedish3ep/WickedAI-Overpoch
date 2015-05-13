private ["_fileName", "_missionName", "_difficulty", "_missionType", "_position", "_picture", "_missionDesc", "_winMessage", "_failMessage", "_rndnum", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime"];

_fileName = "banditSquad";
_missionName = "Bandit Squad";
_difficulty = "easy";
_missionType = "Minor Mission";

_position = [getMarkerPos "center",0,5500,10,0,2000,0] call BIS_fnc_findSafePos;

_picture = getText (configFile >> "cfgMagazines" >> "Moscow_Bombing_File" >> "picture");
_missionDesc = format["A %1 has been spotted! Stop them from completing their patrol!",_missionName];
_winMessage = format["The %1 bagged and tagged, Nice Work!",_missionName];
_failMessage = format["The %1 have completed their patrol - Mission Failed",_missionName];

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_minor_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

sleep 1;
_rndnum = round (random 3) + 5;

[[_position select 0, _position select 1, 0],
	_rndnum,			//Number Of units
	_difficulty,		//Skill level "normal" "hard" "extreme" or "random"
	"Random",		//Primary gun set number. "Random" for random weapon set.
	4,				//Number of magazines
	"",				//Backpack "" for random or classname here.
	"",				//Skin "" for random or classname here.
	"Random",		//Gearset number. "Random" for random gear set.
	"minor",			//mission type
	"WAIminorArray"
] call spawn_group;

sleep 1;

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

if (_playerPresent) then 
	{
		[_position,"WAIminorArray"] call missionComplete;
		
		diag_log format["WAI: Mission %1 Ended At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_winMessage], "PLAIN",10] call RE;
		
		uiSleep 300;
		["minorclean"] call WAIcleanup;
	} 
		else 
	{
		clean_running_minor_mission = True;
		["minorclean"] call WAIcleanup;
		
		diag_log format["WAI: Mission %1 Timed Out At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_failMessage], "PLAIN",10] call RE;
	};
minor_missionrunning = false;