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

/* Troops */
[_position,5,_difficulty,3,4,"","TK_Soldier_SniperH_EP1","Random","minor","WAIminorArray"] call spawn_group;

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

		for "_i" from 1 to 3 do 
			{
				private ["_a1Box","_a1Pos"];
				
				_a1Pos = _position findEmptyPosition [5,50,"AmmoBoxSmall_762"];
				_a1Box = createVehicle ["AmmoBoxSmall_762",_a1Pos, [], 0, "CAN_COLLIDE"];
				[_a1Box] call markCrates;
				sleep 0.1;
			};

		diag_log format["WAI: Mission %1 Ended At %2",_missionName,_position];
		[nil,nil,rTitleText,format["%1",_winMessage], "PLAIN",10] call RE;

		uiSleep 300;
		["minorclean"] call WAIcleanup;
	}
		else
	{
		clean_running_minor_mission = True;
		diag_log format["WAI: Minor Mission %1 Timed Out At %2",_missionName,_position];
		[nil,nil,rTitleText,format["%1",_failMessage], "PLAIN",10] call RE;

		["minorclean"] call WAIcleanup;	
	};

minor_missionrunning = false;