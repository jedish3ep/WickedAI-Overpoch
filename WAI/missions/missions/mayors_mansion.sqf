private ["_fileName", "_missionType", "_position", "_missionName", "_difficulty", "_worldName", "_picture", "_missionDesc", "_winMessage", "_failMessage", "_baserunover", "_rndnum", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box"];
  
_fileName = "osamaCompound";
_missionType = "Major Mission";
_position = call WAI_findPos;

_missionName = "Operation Neptune Spear";
_difficulty = "hard";
_worldName = toLower format ["%1", worldName];
_picture = getText (configFile >> "cfgWeapons" >> "Cobalt_File" >> "picture");
_missionDesc = format["Osama Bin Laden has been spotted in %1, Kill the HVT and secure the stolen loot",_worldName];
_winMessage = format["The HVT is Down. Secure the loot and RTB",_fileName];
_failMessage = format["The HVT has fled %1. Time's up",_worldName];

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_major_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

/* create the compound */
_baserunover = createVehicle ["Land_A_Villa_EP1",[(_position select 0), (_position select 1),0],[], 0, "CAN_COLLIDE"];
majorBldList = majorBldList + [_baserunover];

_rndnum = round (random 3) + 4;
[[_position select 0, _position select 1, 0],4,_difficulty,"Random",4,"","TK_INS_Soldier_EP1_DZ","Random","major","WAImajorArray"] call spawn_group;
[[_position select 0, _position select 1, 0],4,_difficulty,"Random",4,"","TK_GUE_Soldier_Sniper_EP1","Random","major","WAImajorArray"] call spawn_group;
[[_position select 0, _position select 1, 0],4,_difficulty,"Random",4,"","TK_GUE_Warlord_EP1","Random","major","WAImajorArray"] call spawn_group;
[[_position select 0, _position select 1, 0],4,_difficulty,"Random",4,"","TK_GUE_Soldier_HAT_EP1","Random","major","WAImajorArray"] call spawn_group;

//The HVT Himself
[[_position select 0, _position select 1, 0],1,"extreme","Random",4,"","TK_GUE_Soldier_TL_EP1","Random","major","WAImajorArray"] call spawn_group;

[[[(_position select 0) - 15, (_position select 1) + 15, 8]],"KORD_high_TK_EP1",0.8,"TK_INS_Soldier_AT_EP1",1,2,"","Random","major"] call spawn_static;
[[[(_position select 0) + 15, (_position select 1) - 15, 8]],"KORD_high_UN_EP1",0.8,"TK_Special_Forces_EP1",1,2,"","Random","major"] call spawn_static;

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
		_box = createVehicle ["BAF_VehicleBox",[(_position select 0),(_position select 1), .5], [], 0, "CAN_COLLIDE"];
		[_box] call Extra_Large_Gun_Box;//Large Gun Box

		// mark crates with smoke/flares
		[_box] call markCrates;
		
		diag_log format["WAI: Mission %1 Ended At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_winMessage], "PLAIN",10] call RE;
		uiSleep 5*60;
		["majorclean"] call WAIcleanup;
	}
		else 
	{
		clean_running_mission = True;
		uiSleep 5*60;
		["majorclean"] call WAIcleanup;
		diag_log format["WAI: Mission %1 Timed Out At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_failMessage], "PLAIN",10] call RE;
	};
 missionrunning = false;