private ["_fileName", "_missionType", "_positionarray", "_position", "_missionName", "_difficulty", "_picture", "_missionDesc", "_winMessage", "_failMessage", "_bldPos", "_bldPos1", "_bldPos2", "_gunnerPos1", "_gunnerPos2", "_baserunover", "_baserunover1", "_baserunover2", "_baserunover3", "_base", "_tanktraps", "_rndnum", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box", "_box2"];

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
_bldPos = [_position,0,100,3,0,5,0] call BIS_fnc_findSafePos;
_bldPos1 = [_position,0,100,3,0,5,0] call BIS_fnc_findSafePos;
_bldPos2 = [_position,0,100,3,0,5,0] call BIS_fnc_findSafePos;
_gunnerPos1 = [_position,0,50,3,0,5,0] call BIS_fnc_findSafePos;
_gunnerPos2 = [_position,0,50,3,0,5,0] call BIS_fnc_findSafePos;

_baserunover = createVehicle ["HMMWVWreck",[0,0,0],[], 0, "CAN_COLLIDE"];
_baserunover1 = createVehicle ["HMMWVWreck",[0,0,0],[], 0, "CAN_COLLIDE"];
_baserunover2 = createVehicle ["HMMWVWreck",[0,0,0],[], 0, "CAN_COLLIDE"];

_baserunover setPos _bldPos;
_baserunover1 setPos _bldPos;
_baserunover2 setPos _bldPos;

_baserunover setDir round(random 360);
_baserunover1 setDir round(random 360);
_baserunover2 setDir round(random 360);

_baserunover3 = createVehicle ["M1130_HQ_unfolded_EP1",[(_position select 0), (_position select 1),-0.2],[], 0, "CAN_COLLIDE"];
_baserunover3 setDir 270;

_base = [_baserunover,_baserunover1,_baserunover2,_baserunover3];

{ majorBldList = majorBldList + [_x]; } forEach _base;
{ _x setVectorUp surfaceNormal position _x; } count _base;

/* Tank Traps */
_tanktraps = [_position] call tank_traps;

/* Troops */
_rndnum = round (random 3) + 4;
[[_position select 0, _position select 1, 0],_rndnum,_difficulty,"Random",4,"","FR_OHara_DZ","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;
[[_position select 0, _position select 1, 0],4,_difficulty,"Random",4,"","GUE_Soldier_Sniper_DZ","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;
[[_position select 0, _position select 1, 0],4,_difficulty,"Random",4,"","GUE_Soldier_MG_DZ","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;
[[_position select 0, _position select 1, 0],4,_difficulty,"Random",4,"","GUE_Soldier_Crew_DZ","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;
[[_position select 0, _position select 1, 0],4,_difficulty,"Random",4,"","GUE_Soldier_MG_DZ","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;
 
/* Static Weapons */
[[_gunnerPos1],"KORD_high",0.8,"Ins_Soldier_GL_DZ",1,2,"","Random","major"] call spawn_static;
[[_gunnerPos2],"DSHKM_Gue",0.8,"GUE_Soldier_MG_DZ",1,2,"","Random","major"] call spawn_static;

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
		[_position,"WAImajorArray"] call missionComplete;
		
		diag_log format["WAI: Mission %1 Ended At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_winMessage], "PLAIN",10] call RE;
		
		// wait for mission complete then spawn crates

		_box = createVehicle ["RUVehicleBox",[(_position select 0) + 5,(_position select 1),0], [], 0, "CAN_COLLIDE"];
		[_box] call Extra_Large_Gun_Box1;//Extra Large Gun Box
		_box2 = createVehicle ["BAF_VehicleBox",[(_position select 0) - 10,(_position select 1) - 10,0], [], 0, "CAN_COLLIDE"];
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