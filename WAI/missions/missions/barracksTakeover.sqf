private ["_fileName", "_missionType", "_positionarray", "_position", "_missionName", "_difficulty", "_picture", "_missionDesc", "_winMessage", "_failMessage", "_tanktraps", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box0", "_box1", "_box2"];

_fileName = "barracksTakeover";
_missionType = "Major Mission";

// change these to wherever you have your own custom barracks located!
_positionarray = [[5168.07,2241.01, 0],[2053.01,5132.07, 0],[12958.9,9605,0],[13167.246,6841.5205, 0],[9616.2998,11297.247, 0],[2260.99,10750.4, 0]];
_position = _positionarray call BIS_fnc_selectRandom;

_missionName = "Barracks Takeover";
_difficulty = "hard";

_picture = getText (configFile >> "cfgWeapons" >> "Cobalt_File" >> "picture");
_missionDesc = "Bandits are looting the Barracks, They have amassed a stockpile of weaponry and are killing anyone that comes near the place, We need you to go and kill them!";
_winMessage = "The Bandits have been killed and the weapons have been secured! Job well done boys!";
_failMessage = "Those bastards have rigged explosives to the buildings. CLEAR THE AREA BEFORE IT BLOWS! Mission Failed!";

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_major_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

/* Scenery */
[_position,6,25,200,"major"] call fn_createWrecks;
_tanktraps = [_position] call tank_traps;
[_position,4,125,false,"major"] call fn_ammoboxes;

/* Troops */
for "_i" from 1 to 3 do
	{
		private ["_rndnum"];
		_rndnum = round (random 3) + 3;
		[_position,_rndnum,_difficulty,"Random",4,"","","Random","major","WAImajorArray"] call spawn_group;
		sleep 0.1;
	};
	
_staticPos = _position findEmptyPosition [1,25,"M2StaticMG"];
[[_staticPos],"M2StaticMG",0.8,"",1,2,"","Random","major"] call spawn_static;


_missiontimeout = true;
_cleanmission = false;
_playerPresent = false;
_starttime = floor(time);

while {_missiontimeout} do
	{
		sleep 5;
		_currenttime = floor(time);
		{if((isPlayer _x) AND (_x distance _position <= 300)) then {_playerPresent = true};}forEach playableUnits;
		if (_currenttime - _starttime >= wai_mission_timeout) then {_cleanmission = true;};
		if ((_playerPresent) OR (_cleanmission)) then {_missiontimeout = false;};
	};

if (_playerPresent) then 
	{
		[_position,"WAImajorArray"] call missionComplete;
		diag_log format["WAI: Mission %1 Ended At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_winMessage], "PLAIN",10] call RE;
		// wait for mission complete. then spawn box and save vehicle to hive

		_box0Pos = _position findEmptyPosition [0,10,"BAF_VehicleBox"];
		_box0 = createVehicle ["BAF_VehicleBox",_box0Pos, [], 0, "CAN_COLLIDE"];
		
		_box1Pos = _position findEmptyPosition [0,10,"BAF_VehicleBox"];
		_box1 = createVehicle ["BAF_VehicleBox",_box1Pos, [], 0, "CAN_COLLIDE"];
		
		_box2Pos = _position findEmptyPosition [0,10,"USBasicWeaponsBox"];
		_box2 = createVehicle ["USBasicWeaponsBox",_box2Pos, [], 0, "CAN_COLLIDE"];
		
		[_box0] call Extra_Large_Gun_Box1;
		[_box1] call Sniper_Gun_Box;
		[_box2] call Medium_Gun_Box;
		
		[_box0] call markCrates;
		[_box1] call markCrates;
		[_box2] call markCrates;

		uiSleep 300;
		["majorclean"] call WAIcleanup;
	}
		else
	{
		clean_running_mission = True;
			
		diag_log format["WAI: Mission %1 Timed Out At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_failMessage], "PLAIN",10] call RE;
		uiSleep 30;
		/* Mission Failed - Obliterate the Area */
		[_position,6] call fn_bombArea;
		uiSleep 150;
		["majorclean"] call WAIcleanup;
	};

missionrunning = false;