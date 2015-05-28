private ["_fileName", "_missionType", "_position", "_vehname", "_picture", "_missionName", "_difficulty", "_missionDesc", "_winMessage", "_failMessage", "_base1", "_base2", "_base3", "_scenery", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box"];

_fileName = "easyAntiAir";
_missionType = "Minor Mission";
_position = call WAI_findPos;

_vehname	= getText (configFile >> "CfgVehicles" >> "Igla_AA_pod_East" >> "displayName");
_picture = getText (configFile >> "cfgVehicles" >> "Igla_AA_pod_East" >> "picture");
_missionName = "Hostile Anti Air Team";
_difficulty = "easy";
_missionDesc = format["Insurgents have set up %1 Anti Air Defence - You need to take them out ASAP",_vehname];
_winMessage = format["Good job, the %1 have been wiped out. The skies are safe again",_vehname];
_failMessage = format["Mission Failed: You did not destroy the %1 in Time",_vehname];


/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_minor_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

/* Mission Scenery */
_base1 = createVehicle ["TK_GUE_WarfareBAntiAirRadar_EP1",[(_position select 0), (_position select 1)],[], 0, "CAN_COLLIDE"];
_base2 = createVehicle ["FlagCarrierRU",[(_position select 0) + 1.0205, (_position select 1) - 16.6372],[], 0, "CAN_COLLIDE"];
_base3 = createVehicle ["FlagCarrierRU",[(_position select 0) - 0.7871, (_position select 1) + 9.979],[], 0, "CAN_COLLIDE"];

[_position,6,25,300,"minor"] call fn_createWrecks;
_scenery = [_base1,_base2,_base3];

{ minorBldList = minorBldList + [_x]; } forEach _scenery;
{ _x setVectorUp surfaceNormal position _x; } count _scenery;

/* Insurgents */
[_position,6,"easy","Random",3,"","","Random","minor","WAIminorArray"] call spawn_group;

/* Anti Aircraft */
for "_i" from 1 to 4 do
	{
		private ["_staticPos"];		
		_staticPos = _position findEmptyPosition [5,75,"Igla_AA_pod_East"];
		sleep 0.1;
		[[_staticPos],"Igla_AA_pod_East",0.8,"",1,2,"","Random","minor"] call spawn_static;
		sleep 0.1;
	};

_missiontimeout = true;
_cleanmission = false;
_playerPresent = false;
_starttime = floor(time);

while {_missiontimeout} do {
	sleep 5;
	_currenttime = floor(time);
	{if((isPlayer _x) AND (_x distance _position <= 300)) then {_playerPresent = true};}forEach playableUnits;
	if (_currenttime - _starttime >= wai_minor_mission_timeout) then {_cleanmission = true;};
	if ((_playerPresent) OR (_cleanmission)) then {_missiontimeout = false;};
};
if (_playerPresent) then {
	[_position,"WAIminorArray"] call missionComplete;
	
	_box = createVehicle ["USVehicleBox",[(_position select 0) + 6.6914,(_position select 1) + 1.1939,0], [], 0, "CAN_COLLIDE"];
	[_box] call easyMissionBox;		// Crate with Basic Loot
	[_box] call markCrates;		// mark crates with smoke/flares
	
	for "_i" from 1 to 4 do 
		{
			private ["_a1Box","_a2Box","_a1Pos","_a2Pos"];
			
			_a1Pos = _position findEmptyPosition [5,50,"AmmoBoxSmall_762"];
			_a1Box = createVehicle ["AmmoBoxSmall_762",_a1Pos, [], 0, "CAN_COLLIDE"];
			_a2Pos = _position findEmptyPosition [5,50,"AmmoBoxSmall_556"];
			_a2Box = createVehicle ["AmmoBoxSmall_556",_a2Pos, [], 0, "CAN_COLLIDE"];
			sleep 0.1;
		};

	diag_log format["WAI: Mission %1 Ended At %2",_fileName,_position];
	[nil,nil,rTitleText,format["%1",_winMessage], "PLAIN",10] call RE;

	uiSleep 300;
	["minorclean"] call WAIcleanup;
} else {
	clean_running_minor_mission = True;
	diag_log format["WAI: Mission %1 Timed Out At %2",_fileName,_position];
	[nil,nil,rTitleText,format["%1",_failMessage], "PLAIN",10] call RE;

	["minorclean"] call WAIcleanup;	
};

minor_missionrunning = false;