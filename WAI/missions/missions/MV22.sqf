private ["_fileName", "_missionType", "_position", "_vehclass", "_vehname", "_picture", "_missionName", "_difficulty", "_missionDesc", "_winMessage", "_failMessage", "_tent", "_veh", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box"];

_fileName = "MV22";
_missionType = "Major Mission";
_position = call WAI_findPos;

_vehclass = "MV22_DZ";
_vehname	= getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");
_picture = getText (configFile >> "cfgVehicles" >> _vehclass >> "picture");

_missionName = format["Red Cross %1",_vehname];
_difficulty = "hard";

_missionDesc = format["Bandits have captured a Red Cross %1, Our informant has advised there is medical supplies. Your map has been updated with the location!",_vehname];
_winMessage = format["Survivors have secured the Red Cross %1!",_vehname];
_failMessage = format["Survivors did not secure the Red Cross %1 in time!",_vehname];

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_major_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

/* Scenery */
_tent = createVehicle ["USMC_WarfareBFieldHospital",[(_position select 0) - 20,(_position select 1) - 20,0], [], 0, "CAN_COLLIDE"];
majorBldList = majorBldList + [_tent];

[_position,6,10,500,"major"] call fn_createWrecks;

/* Osprey */
_veh = createVehicle [_vehclass,_position, [], 0, "CAN_COLLIDE"];
[_veh,0,0.75] call spawnTempVehicle;
_veh setVehicleLock "LOCKED";
_veh setVariable ["R3F_LOG_disabled",true,true];

/* Troops */
for "_i" from 1 to 3 do 
	{
		private ["_rndnum"];
		_rndnum = round (random 3) + 4;
		[_position,4,_difficulty,"Random",_rndnum,"","","Random","major","WAImajorArray"] call spawn_group;
		sleep 0.1;
	};
	
//Turrets
[
	[
		[(_position select 0) + 10, (_position select 1) + 10, 0],
		[(_position select 0) + 10, (_position select 1) - 10, 0]
	], //position(s) (can be multiple).
	"M2StaticMG",             //Classname of turret
	0.8,					  //Skill level 0-1. Has no effect if using custom skills
	"",			  //Skin "" for random or classname here.
	0,						  //Primary gun set number. "Random" for random weapon set. (not needed if ai_static_useweapon = False)
	2,						  //Number of magazines. (not needed if ai_static_useweapon = False)
	"",						  //Backpack "" for random or classname here. (not needed if ai_static_useweapon = False)
	"Random",				  //Gearset number. "Random" for random gear set. (not needed if ai_static_useweapon = False)
	"major"
] call spawn_static;

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
		
		_veh setVehicleLock "UNLOCKED";
		_veh setVariable ["R3F_LOG_disabled",false,true];
		// wait for mission complete then spawn crate
		_box = createVehicle ["LocalBasicWeaponsBox",[(_position select 0) - 20,(_position select 1) - 20,0], [], 0, "CAN_COLLIDE"];
		[_box] call Medical_Supply_Box;//Medical Supply Box

		// mark crates with smoke/flares
		[_box] call markCrates;
		
		uiSleep 300;
		["majorclean"] call WAIcleanup;
	}
		else
	{
		clean_running_mission = True;
		deleteVehicle _veh;
		["majorclean"] call WAIcleanup;
		
		diag_log format["WAI: Mission %1 Timed Out At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_failMessage], "PLAIN",10] call RE;
	};
missionrunning = false;