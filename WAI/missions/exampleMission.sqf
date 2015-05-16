// generate Private array from http://killzonekid.com/arma-simple-private-variable-extractor/

_fileName = "fileName";
_missionType = "Major Mission";
_position = [getMarkerPos "center",0,5500,10,0,2000,0] call BIS_fnc_findSafePos;

_missionName = "";
_difficulty = "hard";
_worldName = toLower format ["%1", worldName];
_picture = getText (configFile >> "cfgMagazines" >> "Moscow_Bombing_File" >> "picture");
_missionDesc = format["%1",_worldName];
_winMessage = format["%1",_fileName];
_failMessage = format["%1",_worldName];

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_major_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

/* create the compound */
_baseItem = createVehicle ["TK_GUE_WarfareBAntiAirRadar_EP1",[(_position select 0), (_position select 1)],[], 0, "CAN_COLLIDE"];
_baseItem1 = createVehicle ["TK_GUE_WarfareBAntiAirRadar_EP1",[(_position select 0), (_position select 1)],[], 0, "CAN_COLLIDE"];
_baseItem2 = createVehicle ["TK_GUE_WarfareBAntiAirRadar_EP1",[(_position select 0), (_position select 1)],[], 0, "CAN_COLLIDE"];
_baseItem3 = createVehicle ["TK_GUE_WarfareBAntiAirRadar_EP1",[(_position select 0), (_position select 1)],[], 0, "CAN_COLLIDE"];
_baseItem4 = createVehicle ["TK_GUE_WarfareBAntiAirRadar_EP1",[(_position select 0), (_position select 1)],[], 0, "CAN_COLLIDE"];
_baseItem5 = createVehicle ["TK_GUE_WarfareBAntiAirRadar_EP1",[(_position select 0), (_position select 1)],[], 0, "CAN_COLLIDE"];

_base = [_baseItem,_baseItem1,_baseItem2,_baseItem3,_baseItem4,_baseItem5];
{ majorBldList = majorBldList + [_x]; } forEach _base;
{ _x setVectorUp surfaceNormal position _x; } count _base;


/* spawn AI squads */

_rndnum = round (random 3) + 4;
[[(_position select 0) - 23,(_position select 1) - 1.32, 0],                  //position
_rndnum,					  //Number Of units
_difficulty,			      //Skill level
"Random",			      //Primary gun set number. "Random" for random weapon set.
4,						  //Number of magazines
"",						  //Backpack "" for random or classname here.
"",						  //Skin "" for random or classname here.
"Random",				  //Gearset number. "Random" for random gear set.
"major",
"WAImajorArray"
] call spawn_group;

/* spawn emplaced gunners */
[[[(_position select 0) + 15, (_position select 1) - 15, 8]],"KORD_high_UN_EP1",0.8,"TK_Special_Forces_EP1",1,2,"","Random","major"] call spawn_static;

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