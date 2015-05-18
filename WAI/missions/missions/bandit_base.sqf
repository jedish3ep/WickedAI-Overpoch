private ["_fileName", "_missionType", "_position", "_missionName", "_difficulty", "_picture", "_missionDesc", "_winMessage", "_failMessage", "_tanktraps", "_baserunover", "_baserunover1", "_baserunover2", "_baserunover3", "_baserunover4", "_baserunover5", "_baserunover6", "_baserunover7", "_base", "_rndnum", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box", "_box2"];
 
_fileName = "bandit_base";
_missionType = "Major Mission";

_position = call WAI_findPos;
_missionName = "Bandit Base";
_difficulty = "extreme";

_picture = getText (configFile >> "cfgWeapons" >> "Cobalt_File" >> "picture");

_missionDesc = "A Jungle task force have set up a temporary encampment! Go and ambush it to make it yours!";
_winMessage = "Survivors captured the base, HOOAH!!";
_failMessage = "The survivors were unable to capture the base time is up!";

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_major_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

/* Scenery */
_tanktraps = [_position] call tank_traps;

_baserunover = createVehicle ["land_fortified_nest_big",[(_position select 0) - 40, (_position select 1),-0.2],[], 0, "CAN_COLLIDE"];
_baserunover setDir 90;
_baserunover1 = createVehicle ["land_fortified_nest_big",[(_position select 0) + 40, (_position select 1),-0.2],[], 0, "CAN_COLLIDE"];
_baserunover1 setDir 270;
_baserunover2 = createVehicle ["land_fortified_nest_big",[(_position select 0), (_position select 1) - 40,-0.2],[], 0, "CAN_COLLIDE"];
_baserunover2 setDir 0;
_baserunover3 = createVehicle ["land_fortified_nest_big",[(_position select 0), (_position select 1) + 40,-0.2],[], 0, "CAN_COLLIDE"];
_baserunover3 setDir 180;
_baserunover4 = createVehicle ["Land_Fort_Watchtower",[(_position select 0) - 10, (_position select 1),-0.2],[], 0, "CAN_COLLIDE"];
_baserunover4 setDir 0;
_baserunover5 = createVehicle ["Land_Fort_Watchtower",[(_position select 0) + 10, (_position select 1),-0.2],[], 0, "CAN_COLLIDE"];
_baserunover5 setDir 180;
_baserunover6 = createVehicle ["Land_Fort_Watchtower",[(_position select 0), (_position select 1) - 10,-0.2],[], 0, "CAN_COLLIDE"];
_baserunover6 setDir 270;
_baserunover7 = createVehicle ["Land_Fort_Watchtower",[(_position select 0), (_position select 1) + 10,-0.2],[], 0, "CAN_COLLIDE"];
_baserunover7 setDir 90;

_base = [_baserunover,_baserunover1,_baserunover2,_baserunover3,_baserunover4,_baserunover5,_baserunover6,_baserunover7];

{ majorBldList = majorBldList + [_x]; } forEach _base;
{ _x setVectorUp surfaceNormal position _x; } count _base;


//Group Spawning
_rndnum = round (random 3) + 4;
[[_position select 0, _position select 1, 0],_rndnum,_difficulty,"Random",4,"","FR_OHara_DZ","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;
[[_position select 0, _position select 1, 0],4,_difficulty,"Random",4,"","GUE_Soldier_Sniper_DZ","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;
[[_position select 0, _position select 1, 0],4,_difficulty,"Random",4,"","GUE_Soldier_MG_DZ","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;
[[_position select 0, _position select 1, 0],4,_difficulty,"Random",4,"","GUE_Soldier_Crew_DZ","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;
[[_position select 0, _position select 1, 0],4,_difficulty,"Random",4,"","Ins_Soldier_GL_DZ","Random","major","WAImajorArray"] call spawn_group;sleep 0.1;
 
//Turrets
[[[(_position select 0) - 10, (_position select 1) + 10, 0]],"KORD_high",0.8,"Ins_Soldier_GL_DZ",1,2,"","Random","major"] call spawn_static;sleep 0.1;
[[[(_position select 0) + 10, (_position select 1) - 10, 0]],"M2StaticMG",0.8,"GUE_Soldier_MG_DZ",1,2,"","Random","major"] call spawn_static;sleep 0.1;
[[[(_position select 0) + 15, (_position select 1) + 15, 0]],"SPG9_TK_GUE_EP1",0.8,"FR_OHara_DZ",1,2,"","Random","major"] call spawn_static;sleep 0.1;
[[[(_position select 0) - 10, (_position select 1) - 10, 0]],"DSHKM_Gue",0.8,"GUE_Soldier_MG_DZ",1,2,"","Random","major"] call spawn_static;sleep 0.1;
[[[(_position select 0) - 15, (_position select 1) - 15, 0]],"SPG9_TK_GUE_EP1",0.8,"FR_OHara_DZ",1,2,"","Random","major"] call spawn_static;sleep 0.1;

//Heli Paradrop
[[(_position select 0), (_position select 1), 0],[7743.41, 7040.93, 0],400,"Mi17_TK_EP1",10,"extreme","Random",4,"","Ins_Soldier_GL_DZ","Random",False,"major","WAImajorArray"] spawn heli_para;

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
		
		// wait for mission complete before spawning boxes
		_box = createVehicle ["RUVehicleBox",[(_position select 0) -3,(_position select 1),0], [], 0, "CAN_COLLIDE"];
		[_box] call Extra_Large_Gun_Box1;//Extra Large Gun Box
		_box2 = createVehicle ["BAF_VehicleBox",[(_position select 0) +3,(_position select 1), -0.5], [], 0, "CAN_COLLIDE"];
		[_box2] call Construction_Supply_Box;//Construction Supply Box

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