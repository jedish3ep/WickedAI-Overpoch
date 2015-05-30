private ["_fileName", "_missionName", "_difficulty", "_missionType", "_position", "_picture", "_missionDesc", "_winMessage", "_failMessage", "_rndnum", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime"];

_fileName = "banditSquad";
_missionName = "Bandit Squad";
_difficulty = "easy";
_missionType = "Minor Mission";

_position = call WAI_findPos;

_picture = getText (configFile >> "cfgWeapons" >> "Cobalt_File" >> "picture");
_missionDesc = format["A %1 has been spotted! Stop them from completing their patrol!",_missionName];
_winMessage = format["The %1 bagged and tagged, Nice Work!",_missionName];
_failMessage = format["The %1 have completed their patrol - Mission Failed",_missionName];

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_minor_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

_rndnum = round (random 3) + 5;
[_position,_rndnum,_difficulty,"Random",4,"","","Random","minor","WAIminorArray"] call spawn_group;

[_position,4,100,false,"minor"] call fn_ammoboxes;

_missiontimeout = true;
_cleanmission = false;
_playerPresent = false;
_starttime = floor(time);

while {_missiontimeout} do 
	{
		sleep 5;
		_currenttime = floor(time);
		{if((isPlayer _x) AND (_x distance _position <= 300)) then {_playerPresent = true};}forEach playableUnits;
		if (_currenttime - _starttime >= wai_minor_mission_timeout) then {_cleanmission = true;};
		if ((_playerPresent) OR (_cleanmission)) then {_missiontimeout = false;};
	};

if (_playerPresent) then 
	{
		[_position,"WAIminorArray"] call missionComplete;
		
		diag_log format["WAI: Mission %1 Ended At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_winMessage], "PLAIN",10] call RE;
		["minorclean"] call WAIcleanup;
	} 
		else 
	{
		clean_running_minor_mission = True;
		diag_log format["WAI: Mission %1 Timed Out At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_failMessage], "PLAIN",10] call RE;
		["minorclean"] call WAIcleanup;
	};
minor_missionrunning = false;