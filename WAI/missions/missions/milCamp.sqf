private ["_fileName", "_missionType", "_missionName", "_difficulty", "_position", "_vehclass", "_vehname", "_picture", "_missionDesc", "_winMessage", "_failMessage", "_veh", "_vehdir", "_tanktraps", "_baserunover", "_baserunover1", "_baserunover4", "_baserunover5", "_baserunover6", "_baserunover7", "_base", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box", "_box2", "_skinArray", "_turretArray"];

_fileName = "milCamp";
_missionType = "Major Mission";
_missionName = "Military Camp";
_difficulty = "extreme";

_position = call WAI_findPos;

_vehclass = armed_vehicle call BIS_fnc_selectRandom;
_vehname = getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");
_picture = getText (configFile >> "cfgVehicles" >> _vehclass >> "picture");

_missionDesc = format["The Military are setting up a camp, they have a %1, Kill them and take their supplies",_vehname];
_winMessage = format["The Military presence has been eliminated and the %1 Secured! Well Done",_vehname];
_failMessage = format["Mission Failed: Survivors did not secure the %1 in time!",_vehname];

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_major_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

/* Vehicle */
_veh = createVehicle [_vehclass,[(_position select 0) - 30,(_position select 1) + 15,0], [], 0, "CAN_COLLIDE"];
_vehdir = round(random 360);
_veh setDir _vehdir;
clearWeaponCargoGlobal _veh;
clearMagazineCargoGlobal _veh;
_veh setVariable ["ObjectID","1",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_veh];
_veh setVehicleLock "LOCKED";
_veh setVariable ["R3F_LOG_disabled",true,true];
diag_log format["WAI: Mission %1 spawned a %2",_fileName,_vehname];

/* Tank Traps */
_tanktraps = [_position] call tank_traps;

/* Scenery */
_baserunover = createVehicle ["US_WarfareBAntiAirRadar_Base_EP1",[(_position select 0), (_position select 1)],[], 0, "CAN_COLLIDE"];
_baserunover setDir 90;
_baserunover1 = createVehicle ["TK_WarfareBBarracks_EP1",[(_position select 0) + 25, (_position select 1)],[], 0, "CAN_COLLIDE"];
_baserunover1 setDir 90;
_baserunover4 = createVehicle ["Misc_cargo_cont_net3",[(_position select 0) - 10, (_position select 1),-0.2],[], 0, "CAN_COLLIDE"];
_baserunover4 setDir 0;
_baserunover5 = createVehicle ["Misc_cargo_cont_net2",[(_position select 0) + 10, (_position select 1),-0.2],[], 0, "CAN_COLLIDE"];
_baserunover5 setDir 180;
_baserunover6 = createVehicle ["Misc_cargo_cont_net3",[(_position select 0), (_position select 1) - 10,-0.2],[], 0, "CAN_COLLIDE"];
_baserunover6 setDir 270;
_baserunover7 = createVehicle ["Misc_cargo_cont_net2",[(_position select 0), (_position select 1) + 10,-0.2],[], 0, "CAN_COLLIDE"];
_baserunover7 setDir 90;

_base = [_baserunover,_baserunover1,_baserunover4,_baserunover5,_baserunover6,_baserunover7];

{ majorBldList = majorBldList + [_x]; } forEach _base;
{ _x setVectorUp surfaceNormal position _x; } count _base;

/* Troops and Turrets */
_skinArray = ["UKSF_wdl_demo_l","Graves_Light_DZ","UKSF_wdl_mrk_l","UKSF_wdl_tl_l","Sniper1_DZ","Soldier_Sniper_PMC_DZ"];
_turretArray = ["KORD_high","M2StaticMG","DSHKM_Gue","SPG9_TK_GUE_EP1"];
for "_i" from 1 to 4 do 
	{
		private ["_rndnum","_skinSel","_turrSel","_staticPos"];
		_rndnum = round (random 3) + 4;
		_skinSel = _skinArray call BIS_fnc_selectRandom;
		_turrSel = _turretArray call BIS_fnc_selectRandom;	
		_staticPos = _position findEmptyPosition [15,25,_turrSel];
		
		[_position,_rndnum,_difficulty,"Random",4,"",_skinSel,"Random","major","WAImajorArray"] call spawn_group;
		[[_staticPos],_turrSel,0.8,_skinSel,1,2,"","Random","major"] call spawn_static;
		sleep 0.1;
	};
	
[[(_position select 0),(_position select 1),0],[(_position select 0) + 1500,(_position select 1),0],400,"BAF_Merlin_HC3_D",6,_difficulty,"Random",4,"","UKSF_wdl_demo_l","Random",False,"major","WAImajorArray"] spawn heli_para;

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
		
		// wait for mission complete before spawning crates	
		_box = createVehicle ["RUVehicleBox",[(_position select 0) -15,(_position select 1),0], [], 0, "CAN_COLLIDE"];
		_box2 = createVehicle ["BAF_VehicleBox",[(_position select 0) +15,(_position select 1),0], [], 0, "CAN_COLLIDE"];
		
		[_box] call Extra_Large_Gun_Box1;
		[_box2] call Construction_Supply_Box;

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