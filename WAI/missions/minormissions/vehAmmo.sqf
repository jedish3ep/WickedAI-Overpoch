private ["_fileName", "_missionType", "_position", "_vehclass", "_vehname", "_picture", "_worldName", "_missionName", "_difficultyArray", "_difficulty", "_missionDesc", "_winMessage", "_failMessage", "_tent", "_tent2", "_base", "_veh", "_vehdir", "_objPosition", "_skinArray", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box", "_box1"];

_fileName = "vehAmmo";
_missionType = "Minor Mission";
_position = call WAI_findPos;
_vehclass = "KamazReammo";
_vehname	= getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");
_picture = getText (configFile >> "cfgVehicles" >> _vehclass >> "picture");
_worldName = toLower format ["%1", worldName];
_missionName = _vehname;
_difficultyArray = ["normal","hard"];
_difficulty = _difficultyArray call BIS_fnc_selectRandom;
_missionDesc = format["A %1 carrying weapons across %2 has crashed. Kill Them and secure the Vehicle Ammo for yourself!",_vehname,_worldName];
_winMessage = format["The Crashed %1 and the Vehicle Ammo have been Secured",_vehname];
_failMessage = format["Mission Failed: The bandits have repaired the %1 and fled %2",_vehname,_worldName];

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_minor_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

/* Scenery */
_tent = createVehicle ["MAP_HBarrier5_round15",[(_position select 0) - 21,(_position select 1) - 21,0], [], 0, "CAN_COLLIDE"];
_tent setDir 270;
_tent2 = createVehicle ["MAP_HBarrier5_round15",[(_position select 0) + 16,(_position select 1) + 16,0], [], 0, "CAN_COLLIDE"];
_tent2 setDir 90;
_base = [_tent,_tent2];
{ minorBldList = minorBldList + [_x]; } forEach _base;
{ _x setVectorUp surfaceNormal position _x; } count _base;

/* Truck */
_veh = createVehicle [_vehclass,_position, [], 0, "CAN_COLLIDE"];
_vehdir = round(random 360);
_veh setDir _vehdir;
clearWeaponCargoGlobal _veh;
clearMagazineCargoGlobal _veh;
_veh setVariable ["ObjectID","1",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_veh];
_veh setVehicleLock "LOCKED";
_veh setVariable ["R3F_LOG_disabled",true,true];
diag_log format["WAI: Mission vehAmmo spawned a %1",_vehname];
_objPosition = getPosATL _veh;


/* Troops */
_skinArray = ["TK_Soldier_B_EP1","TK_Aziz_EP1","TK_Commander_EP1"];
for "_i" from 1 to 3 do 
	{
		private ["_rndnum","_skinSel"];
		_rndnum = round (random 3) + 4;
		_skinSel = _skinArray call BIS_fnc_selectRandom;
		[_position,_rndnum,_difficulty,"Random",4,"",_skinSel,"Random","minor","WAIminorArray"] call spawn_group;
		sleep 0.1;		
	};

/* Turrets */
[[[(_position select 0) + 10, (_position select 1) + 10, 0],[(_position select 0) + 10, (_position select 1) - 10, 0]],"M2StaticMG",0.8,"TK_Soldier_Pilot_EP1",0,2,"","Random","minor"] call spawn_static;

_missiontimeout = true;
_cleanmission = false;
_playerPresent = false;
_starttime = floor(time);

while {_missiontimeout} do 
	{
		sleep 5;
		_currenttime = floor(time);
		{if((isPlayer _x) AND (_x distance _position <= 300)) then {_playerPresent = true};}forEach playableUnits;
		if (_currenttime - _starttime >= wai_minor_mission_timeout) then {_cleanmission = true;};
		if ((_playerPresent) OR (_cleanmission)) then {_missiontimeout = false;};
	};

if (_playerPresent) then
	{
		[_position,"WAIminorArray"] call missionComplete;
		
		diag_log format["WAI: Mission %1 Ended At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_winMessage], "PLAIN",10] call RE;
		
		// wait for mission complete. then spawn boxes and publish vehicle to hive
		[_veh,[_vehdir,_objPosition],_vehclass,true,"0"] call custom_publish;
		_veh setVehicleLock "UNLOCKED";
		_veh setVariable ["R3F_LOG_disabled",false,true];
		_box = createVehicle ["LocalBasicWeaponsBox",[(_position select 0) - 10,(_position select 1) - 10,0], [], 0, "CAN_COLLIDE"];
		[_box] call Chain_Bullet_Box;
		[_box] call markCrates;
		
		if (_difficulty == "hard") then 
			{
				_box1 = createVehicle ["LocalBasicWeaponsBox",[(_position select 0) + 15,(_position select 1) + 15,0], [], 0, "CAN_COLLIDE"];
				[_box1] call Chain_Bullet_Box;
				[_box1] call markCrates;
			};
		
		for "_i" from 1 to 4 do 
			{
				private ["_a1Box","_a1Pos"];
				
				_a1Pos = _position findEmptyPosition [5,50,"AmmoBoxSmall_762"];
				_a1Box = createVehicle ["AmmoBoxSmall_762",_a1Pos, [], 0, "CAN_COLLIDE"];
				[_a1Box] call markCrates;
				sleep 0.1;
			};
			
		uiSleep 300;
		["minorclean"] call WAIcleanup;
	} 
		else
	{
		clean_running_minor_mission = True;
		deleteVehicle _veh;
		["minorclean"] call WAIcleanup;
		
		diag_log format["WAI: Mission %1 Timed Out At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_failMessage], "PLAIN",10] call RE;
	};
	
minor_missionrunning = false;