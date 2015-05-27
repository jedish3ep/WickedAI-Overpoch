private ["_fileName", "_missionType", "_position", "_missionName", "_difficulty", "_worldName", "_picture", "_missionDesc", "_winMessage", "_failMessage", "_base1", "_base2", "_base3", "_base4", "_base5", "_base6", "_base7", "_base8", "_base9", "_base10", "_base11", "_base12", "_base", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box0", "_box1", "_bomb"];

_fileName = "fobAardvark";
_missionType = "Major Mission";
_position = call WAI_findPos;

_missionName = "Capture FOB Aardvark";
_difficulty = "hard";
_worldName = toLower format ["%1", worldName];
_picture = getText (configFile >> "cfgWeapons" >> "Cobalt_File" >> "picture");
_missionDesc = format["Bandits have taken over FOB Aardvark, %1 - We need you to help re-secure the base",_worldName];
_winMessage = "Survivors have captured FOB Aardvark, Help yourself to whatever supplies you need. Thanks for the Assist";
_failMessage = "The Bandits have burned FOB Aardvark to the ground. Mission Failed";

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_major_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

/* Scenery */
_base1 = createVehicle ["Land_CncBlock",[(_position select 0) + 3.3208,(_position select 1) - 1.84375,0],[], 0, "CAN_COLLIDE"];
_base1 setDir 111.643;
_base2 = createVehicle ["Land_CncBlock",[(_position select 0) - 0.382324,(_position select 1) + 3.86133,0],[], 0, "CAN_COLLIDE"];
_base2 setDir 180.554;
_base3 = createVehicle ["Land_CncBlock",[(_position select 0) + 1.79346,(_position select 1) - 3.66699,0],[], 0, "CAN_COLLIDE"];
_base3 setDir 148.872;
_base4 = createVehicle ["Land_CncBlock",[(_position select 0) - 2.65723,(_position select 1) + 3.15918,0],[], 0, "CAN_COLLIDE"];
_base4 setDir 329.425;
_base5 = createVehicle ["Barrels",[(_position select 0) - 3.99658,(_position select 1) - 1.19824,0],[], 0, "CAN_COLLIDE"];
_base6 = createVehicle ["Land_CncBlock",[(_position select 0) - 2.2905,(_position select 1) - 4.30859,0],[], 0, "CAN_COLLIDE"];
_base7 = createVehicle ["Land_CncBlock",[(_position select 0) - 4.20801,(_position select 1) + 1.53418,0],[], 0, "CAN_COLLIDE"];
_base7 setDir 292.196;
_base8 = createVehicle ["Land_fort_bagfence_round",[(_position select 0) - 5.08105,(_position select 1) - 3.3438,0],[], 0, "CAN_COLLIDE"];
_base8 setDir 237.15;
_base9 = createVehicle ["Land_Fort_Watchtower",[(_position select 0) - 15, (_position select 1),-0.2],[], 0, "CAN_COLLIDE"];
_base9 setDir 0;
_base10 = createVehicle ["Land_Fort_Watchtower",[(_position select 0) + 15, (_position select 1),-0.2],[], 0, "CAN_COLLIDE"];
_base10 setDir 180;
_base11 = createVehicle ["Land_Fort_Watchtower",[(_position select 0), (_position select 1) - 15,-0.2],[], 0, "CAN_COLLIDE"];
_base11 setDir 270;
_base12 = createVehicle ["Land_Fort_Watchtower",[(_position select 0), (_position select 1) + 15,-0.2],[], 0, "CAN_COLLIDE"];
_base12 setDir 90;

_base = [_base1,_base2,_base3,_base4,_base5,_base6,_base7,_base8,_base9,_base10,_base11,_base12];
{ majorBldList = majorBldList + [_x]; } forEach _base;

/* Troops */
for "_i" from 1 to 4 do
	{
		private ["_rndnum"];
		_rndnum = round (random 3) + 4;
		[_position,_rndnum,_difficulty,"Random",4,"","","Random","major","WAImajorArray"] call spawn_group;
		sleep 0.1;
	};

/* Static Weapons */
[[[(_position select 0) + 0.916504, (_position select 1) -2.87305, 0.01]],"KORD_high_TK_EP1",0.8,"",1,2,"","Random","major"] call spawn_static;
[[[(_position select 0) - 1.63867, (_position select 1) + 2.79004, 0.01]],"KORD_high_UN_EP1",0.8,"",1,2,"","Random","major"] call spawn_static;

[[(_position select 0), (_position select 1), 0],[(_position select 0) + 2500, (_position select 1) - 2000, 0],400,"Mi17_TK_EP1",6,_difficulty,"Random",4,"","Ins_Soldier_GL_DZ","Random",False,"major","WAImajorArray"] spawn heli_para;

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
		// wait for complete status. then spawn box		
	
		_box0 = createVehicle ["USBasicWeaponsBox",[(_position select 0) - 2.8501,(_position select 1) - 3.5, .5], [], 0, "CAN_COLLIDE"];
		_box0 setDir 91.2137;
		[_box0] call Extra_Large_Gun_Box;
		
		_box1 = createVehicle ["USBasicWeaponsBox",[(_position select 0) + 2.8501,(_position select 1) + 3.5, .5], [], 0, "CAN_COLLIDE"];
		_box1 setDir -91.2137;
		[_box1] call Construction_Supply_Box;
		
		sleep 0.1;
		
		// mark crates with smoke/flares
		[_box0] call markCrates;
		[_box1] call markCrates;
		
		diag_log format["WAI: Mission %1 Ended At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_winMessage], "PLAIN",10] call RE;
		uiSleep 300;
		["majorclean"] call WAIcleanup;
	}
		else 
	{
		clean_running_mission = True;
		[nil,nil,rTitleText,"Bombs have been launched at FOB Aardvark you have 30 seconds. GTFO of there!!!!", "PLAIN",10] call RE;
		uiSleep 30;
		/* Mission Failed - Obliterate the Area */
		[_position,10] call fn_bombArea;
		
		uiSleep 150;
		["majorclean"] call WAIcleanup;
		diag_log format["WAI: Mission %1 Timed Out At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_failMessage], "PLAIN",10] call RE;
	};
 missionrunning = false;