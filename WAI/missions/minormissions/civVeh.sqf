private ["_fileName", "_missionType", "_position", "_veharray", "_vehclass", "_vehname", "_picture", "_missionName", "_difficulty", "_missionDesc", "_winMessage", "_failMessage", "_veh", "_vehdir", "_objPosition", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_skinArray"];

_fileName = "civVeh";
_missionType = "Minor Mission";
_position = call WAI_findPos;

_veharray = ["BTR40_MG_TK_INS_EP1","ArmoredSUV_PMC","Pickup_PK_TERROR","EOffroad_DSHKM_TERROR"];
_vehclass = _veharray call BIS_fnc_selectRandom; 
_vehname	= getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");
_picture = getText (configFile >> "cfgVehicles" >> _vehclass >> "picture");

_missionName = _vehname;
_difficulty = "normal";
_missionDesc = format["A group of well-armed Survivors have just bought a %1 These guys will shoot on sight, Eliminate them and steal the %1 for yourself",_vehname];
_winMessage = format["The survivors have been wiped out. Well Done! the %1 is yours",_vehname];
_failMessage = format["The survivors have made off with the %1 - Mission Failed",_vehname];


/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_minor_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

//Vehicle
_veh = createVehicle [_vehclass,_position, [], 0, "CAN_COLLIDE"];
_vehdir = round(random 360);
_veh setDir _vehdir;
clearWeaponCargoGlobal _veh;
clearMagazineCargoGlobal _veh;
_veh setVariable ["ObjectID","1",true];
_veh setVehicleLock "LOCKED";
_veh setVariable ["R3F_LOG_disabled",true,true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_veh];
diag_log format["WAI: Mission civVeh spawned a %1",_vehname];

_objPosition = getPosATL _veh;

//Troops
_skinArray = ["Soldier_TL_PMC","Soldier_MG_PKM_PMC","Soldier_Sniper_KSVK_PMC"];
for "_i" from 1 to 3 do
	{
		private ["_rndnum"."_skinSel"];
		_rndnum = round (random 3) + 4;
		_skinSel = _skinArray call BIS_fnc_selectRandom;

		[_position,_rndnum,"normal","Random",4,"",_skinSel,"Random","minor","WAIminorArray"] call spawn_group;
		sleep 0.1;
	};


_missiontimeout = true;
_cleanmission = false;
_playerPresent = false;
_starttime = floor(time);

while {_missiontimeout} do {
	sleep 5;
	_currenttime = floor(time);
	{if((isPlayer _x) AND (_x distance _position <= 300)) then {_playerPresent = true};}forEach playableUnits;
	if (_currenttime - _starttime >= wai_minor_mission_timeout) then {_cleanmission = true;};
	if ((_playerPresent) OR (_cleanmission)) then {_missiontimeout = false;};
};
if (_playerPresent) then {
	[_position,"WAIminorArray"] call missionComplete;
	/* wait for mission complete, then spawn crates and unlock vehicle */
	_veh setVehicleLock "UNLOCKED";
	_veh setVariable ["R3F_LOG_disabled",false,true];	
	[_veh,[_vehdir,_objPosition],_vehclass,true,"0"] call custom_publish;
	
	diag_log format["WAI: Mission %1 Ended At %2",_fileName,_position];
	[nil,nil,rTitleText,format["%1",_winMessage], "PLAIN",10] call RE;
	uiSleep 300;
	["minorclean"] call WAIcleanup;
} else {
	clean_running_minor_mission = True;
	deleteVehicle _veh;
	["minorclean"] call WAIcleanup;
	
	diag_log format["WAI: Mission %1 Timed Out At %2",_fileName,_position];
	[nil,nil,rTitleText,format["%1",_failMessage], "PLAIN",10] call RE;
};
minor_missionrunning = false;