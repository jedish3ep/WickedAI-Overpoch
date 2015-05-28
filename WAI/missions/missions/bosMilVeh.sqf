private ["_fileName", "_missionType", "_position", "_missionName", "_difficulty", "_veharray", "_vehclass", "_vehname", "_picture", "_missionDesc", "_winMessage", "_failMessage", "_base", "_veh", "_vehdir", "_objPosition", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box"];

_fileName = "bosMilVeh";
_missionType = "Major Mission";

_position = call WAI_findPos;
_missionName = "The Brotherhood of Steel";
_difficulty = "hard";

_veharray = ["LAV25_HQ","BTR90_HQ","BTR60_TK_EP1","BAF_Jackal2_L2A1_w","HMMWV_M998_crows_MK19_DES_EP1","GAZ_Vodnik_HMG"];
_vehclass = _veharray call BIS_fnc_selectRandom; 

/* If the vehicle is better, then make the mission harder */
if (_vehclass == "BTR60_TK_EP1") then {_difficulty = "extreme";};
if (_vehclass == "GAZ_Vodnik_HMG") then {_difficulty = "extreme";};

_vehname = getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");
_picture = getText (configFile >> "cfgVehicles" >> _vehclass >> "picture");

_missionDesc = format["%1 have stolen a %2 go take it off them!!",_missionName,_vehname];
_winMessage = format["%1 have been beaten into submission, and the %2 has been taken",_missionName,_vehname];
_failMessage = format["%1 have escaped with the %2 - Mission Failed",_missionName,_vehname];

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_major_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

/* Scenery */
_base = createVehicle ["Land_fort_rampart",[(_position select 0) + 16,(_position select 1) + 16,0], [], 0, "CAN_COLLIDE"];
majorBldList = majorBldList + [_base];

//Vehicle
_veh = createVehicle [_vehclass,_position, [], 0, "CAN_COLLIDE"];
_vehdir = round(random 360);
_veh setDir _vehdir;
clearWeaponCargoGlobal _veh;
clearMagazineCargoGlobal _veh;
_veh setVariable ["ObjectID","1",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_veh];
diag_log format["WAI: Mission %1 spawned a %2",_fileName,_vehname];
_veh setVehicleLock "LOCKED";
_veh setVariable ["R3F_LOG_disabled",true,true];

_objPosition = getPosATL _veh;

/* Troops */
_skinArray = ["gsc_military_helmet_wdl","gsc_military_helmet_wdlSNP","gsc_military_head_wdl_AT"];
for "_i" from 1 to 4 do
	{
		private ["_rndnum","_skinSel"];		
		_rndnum = round (random 3) + 4;
		_skinSel = _skinArray call BIS_fnc_selectRandom;
		
		[_position,_rndnum,_difficulty,"Random",4,"",_skinSel,"Random","major","WAImajorArray"] call spawn_group;
		sleep 0.1;
	};

/* Turrets */
[[[(_position select 0) + 10, (_position select 1) + 10, 0]],"M2StaticMG",0.8,"gsc_scientist1",0,2,"","Random","major"] call spawn_static;


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
		
		[_veh,[_vehdir,_objPosition],_vehclass,true,"0"] call custom_publish;
		_veh setVehicleLock "UNLOCKED";
		_veh setVariable ["R3F_LOG_disabled",false,true];
		
		// wait for mission complete. then spawn crates
		_box = createVehicle ["LocalBasicWeaponsBox",[(_position select 0) + 5,(_position select 1) - 5,0], [], 0, "CAN_COLLIDE"];
		[_box] call Large_Gun_Box;// Gun Crate

		// mark crates with smoke/flares
		[_box] call markCrates;

		uiSleep 300;
		["majorclean"] call WAIcleanup;
	} else {
		clean_running_mission = True;
		diag_log format["WAI: Mission %1 Timed Out At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_failMessage], "PLAIN",10] call RE;
		deleteVehicle _veh;
		sleep 30;
		["majorclean"] call WAIcleanup;
	};
	
missionrunning = false;