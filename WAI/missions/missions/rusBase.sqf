private ["_fileName", "_missionType", "_missionName", "_difficulty", "_position", "_veharray", "_vehclass", "_vehname", "_picture", "_missionDesc", "_winMessage", "_failMessage", "_baserunover", "_baserunover1", "_baserunover2", "_baserunover3", "_baserunover4", "_baserunover5", "_base", "_veh", "_vehdir", "_objPosition", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box", "_box1"];

_fileName = "rusBase";
_missionType = "Major Mission";
_missionName = "Russian Outpost";
_difficulty = "extreme";

_position = call WAI_findPos;

_veharray = ["BRDM2_HQ_Gue","BTR90_HQ","BTR60_TK_EP1"];
_vehclass = _veharray call BIS_fnc_selectRandom; 
_vehname	= getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");
_picture = getText (configFile >> "cfgVehicles" >> _vehclass >> "picture");

_missionDesc = format["The Russian Military is setting up an outpost, They have building supplies, weapons and a %1",_vehname];
_winMessage = format["The Russian forces have been wiped out, and the %1 has been taken",_vehname];
_failMessage = format["Mission Failed: Survivors did not secure the %1 in time!",_vehname];

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_major_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

/* Scenery */
// center Anti Air tower
_baserunover = createVehicle ["TK_GUE_WarfareBAntiAirRadar_EP1",[(_position select 0), (_position select 1)],[], 0, "CAN_COLLIDE"];
_baserunover setVectorUp surfaceNormal position _baserunover;
// UAV Tower
_baserunover1 = createVehicle ["US_WarfareBUAVterminal_Base_EP1",[(_position select 0) + 1.0205, (_position select 1) - 16.6372],[], 0, "CAN_COLLIDE"];
_baserunover1 setVectorUp surfaceNormal position _baserunover1;
// HQ Unfolded
_baserunover2 = createVehicle ["M1130_HQ_unfolded_EP1",[(_position select 0) - 15.2851, (_position select 1) - 1.289],[], 0, "CAN_COLLIDE"];
_baserunover2 setDir 3.1487305;
_baserunover2 setVectorUp surfaceNormal position _baserunover2;
// light factory
_baserunover3 = createVehicle ["TK_WarfareBLightFactory_EP1",[(_position select 0) + 16.2246, (_position select 1) - 1.4355],[], 0, "CAN_COLLIDE"];
_baserunover3 setVectorUp surfaceNormal position _baserunover3;
// fire barrel
_baserunover4 = createVehicle ["Land_Fire_barrel_burning",[(_position select 0) - 1.5107, (_position select 1) + 9.8081],[], 0, "CAN_COLLIDE"];
_baserunover4 setVectorUp surfaceNormal position _baserunover4;
// russian flag
_baserunover5 = createVehicle ["FlagCarrierRU",[(_position select 0) - 0.7871, (_position select 1) + 9.979],[], 0, "CAN_COLLIDE"];
_baserunover5 setVectorUp surfaceNormal position _baserunover5;

_base = [_baserunover,_baserunover1,_baserunover2,_baserunover3,_baserunover4,_baserunover5];

{ majorBldList = majorBldList + [_x]; } forEach _base;
{ _x setVectorUp surfaceNormal position _x; } count _base;


// ARMOURED VEHICLE
_veh = createVehicle [_vehclass,[(_position select 0) + 6.8516,(_position select 1) + 14.3345,0], [], 0, "CAN_COLLIDE"];
_vehdir = round(random 360);
_veh setDir _vehdir;
clearWeaponCargoGlobal _veh;
clearMagazineCargoGlobal _veh;
_veh setVariable ["ObjectID","1",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_veh];
_veh setVehicleLock "LOCKED";
_veh setVariable ["R3F_LOG_disabled",true,true];
_objPosition = getPosATL _veh;
diag_log format["WAI: Mission %1 spawned a %2",_fileName,_vehname];

/* Troops */
_skinArray = ["RU_Commander","RU_Soldier_HAT","MVD_Soldier_Marksman","RUS_Soldier3","RU_Soldier_Pilot"];
for "_i" from 1 to 4 do 
	{
		private ["_rndnum","_skinSel"];
		_rndnum = round (random 3) + 4;
		_skinSel = _skinArray call BIS_fnc_selectRandom;
		[_position,_rndnum,_difficulty,"Random",4,"",_skinSel,"Random","major","WAImajorArray"] call spawn_group;
		sleep 0.1;		
	};

//Turrets
[[[(_position select 0), (_position select 1) + 21, 0],[(_position select 0), (_position select 1) - 25, 0]], //position(s) (can be multiple).
"KORD_high_TK_EP1",             //Classname of turret
0.8,					  //Skill level 0-1. Has no effect if using custom skills
"RU_Soldier_Pilot",			  //Skin "" for random or classname here.
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
		
		// wait for mission complete then spawn crates and publish vehicle to hive
		_veh setVehicleLock "UNLOCKED";
		_veh setVariable ["R3F_LOG_disabled",false,true];
		[_veh,[_vehdir,_objPosition],_vehclass,true,"0"] call custom_publish;
		
		_box = createVehicle ["USVehicleBox",[(_position select 0) + 6.6914,(_position select 1) + 1.1939,0], [], 0, "CAN_COLLIDE"];
		_box1 = createVehicle ["LocalBasicWeaponsBox",[(_position select 0) - 7.6396,(_position select 1) + 7.2813,0], [], 0, "CAN_COLLIDE"];
		
		[_box] call Construction_Supply_Box;
		[_box1] call Large_Gun_Box;

		[_box] call markCrates;
		[_box1] call markCrates;

		uiSleep 300;
		["majorclean"] call WAIcleanup;
	}
		else
	{
		clean_running_mission = True;
		diag_log format["WAI: Mission %1 Timed Out At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_failMessage], "PLAIN",10] call RE;
		sleep 30;
		deleteVehicle _veh;		
		["majorclean"] call WAIcleanup;		
	};
	
missionrunning = false;