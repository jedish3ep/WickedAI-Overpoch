private ["_fileName", "_missionType", "_positionarray", "_position", "_missionName", "_difficulty", "_picture", "_missionDesc", "_winMessage", "_failMessage", "_objArray", "_baseHQ", "_tanktraps", "_rndnum", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box", "_box2"];

_fileName = "siege";
_missionType = "Major Mission";

_positionarray = [[7546.7695,5144.9907,0],[5981.9287,10345.304,0],[12045.273,9092.3789,0],[11200.665,6572.3813,0],[4485.8018,6414.3247,0]];
_position = _positionarray call BIS_fnc_selectRandom;

_missionName = "City Under Siege";
_difficulty = "hard";

_picture = getText (configFile >> "cfgWeapons" >> "Cobalt_File" >> "picture");
_missionDesc = "Heavily armed insurgents have taken over the City, clear them out";
_winMessage = "The insurgents have been killed, the City is at peace";
_failMessage = "The Terrorists have won, The city has been laid to waste";

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_major_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

/* Scenery */
for "_i" from 1 to 8 do
	{
		private ["_scenery","_sceneryPos","_objType"];
		_objArray = ["HMMWVWreck","BRDMWreck","LADAWreck","SKODAWreck","datsun02Wreck","hiluxWreck","UralWreck","UH1Wreck"];
		_objType = _objArray call BIS_fnc_selectRandom;
		
		_sceneryPos = _position findEmptyPosition [10,150,_objType];
		_scenery = _objType createVehicle _sceneryPos;
		majorBldList = majorBldList + [_scenery];
	};

_baseHQ = createVehicle ["M1130_HQ_unfolded_EP1",_position,[], 0, "CAN_COLLIDE"];
_baseHQ setVectorUp surfaceNormal position _baseHQ;
majorBldList = majorBldList + [_baseHQ];


/* Tank Traps */
_tanktraps = [_position] call tank_traps;

/* Troops and Turrets */
for "_i" from 1 to 4 do
{
	private ["_skinArray","_selSkin","_rndnum","_staticPos"];
	_skinArray = ["FR_OHara_DZ","GUE_Soldier_Sniper_DZ","GUE_Soldier_MG_DZ","GUE_Soldier_Crew_DZ"];
	_selSkin = _skinArray call BIS_fnc_selectRandom;
	_rndnum = round (random 3) + 4;
	[_position,_rndnum,_difficulty,"Random",4,"",_selSkin,"Random","major","WAImajorArray"] call spawn_group;
	sleep 0.1;
	_staticPos = _position findEmptyPosition [5,25,"M2StaticMG"];
	[[_staticPos],"M2StaticMG",0.8,"",1,2,"","Random","major"] call spawn_static;	
};


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
		
		// wait for mission complete then spawn crates
		
		_boxPos = _position findEmptyPosition [1,10,"RUVehicleBox"];
		_box = createVehicle ["RUVehicleBox",_boxPos, [], 0, "CAN_COLLIDE"];
		[_box] call Extra_Large_Gun_Box1;//Extra Large Gun Box
		
		_box2Pos = _position findEmptyPosition [1,10,"BAF_VehicleBox"];
		_box2 = createVehicle ["BAF_VehicleBox",_box2Pos, [], 0, "CAN_COLLIDE"];
		[_box2] call Sniper_Gun_Box;//Sniper Box

		// mark crates with smoke/flares
		[_box] call markCrates;
		[_box2] call markCrates;

		uiSleep 300;
		["majorclean"] call WAIcleanup;
	}
		else
	{
		clean_running_mission = True;
		["majorclean"] call WAIcleanup;
	 
		diag_log format["WAI: Mission %1 Timed Out At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_failMessage], "PLAIN",10] call RE;
	};
 
missionrunning = false;