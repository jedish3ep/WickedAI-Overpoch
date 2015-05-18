/*
	File: wepsTruck.sqf
	Author: JakeHekesFists[DMD]
	Description: Minor Mission for WAI
	Based on SM6 for DZMS - Weapon Truck Crash by lazyink (Full credit for code to TheSzerdi & TAW_Tonic) & Vampire

	Damaged Truck, Low Fuel
	Box of Vehicle Parts
	Extra Large Box of Weapons
	3 Small Groups of AI
	
	added difficulty randomiser, mission may now have either easy or normal ai
*/

private ["_fileName", "_missionType", "_position", "_vehclass", "_vehname", "_picture", "_worldName", "_missionName", "_difficultyArray", "_difficulty", "_missionDesc", "_winMessage", "_failMessage", "_veh", "_rndnum", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box", "_box1", "_box2"];

_fileName = "wepsTruck";
_missionType = "Minor Mission";
_position = call WAI_findPos;

_vehclass = cargo_trucks call BIS_fnc_selectRandom;
_vehname	= getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");
_picture = getText (configFile >> "cfgVehicles" >> _vehclass >> "picture");

_worldName = toLower format ["%1", worldName];

_missionName = "Weapons Truck";
_difficultyArray = ["normal","easy"];
_difficulty = _difficultyArray call BIS_fnc_selectRandom;

_missionDesc = format["A %1 carrying weapons across %2 has crashed. Kill Them and secure the vehicle and weapons for yourself!",_vehname,_worldName];
_winMessage = format["The Crashed %1 and the Weapons have been Secured",_vehname];
_failMessage = format["Mission Failed: The bandits have repaired the %1 and fled %2",_vehname,_worldName];


/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_minor_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

// crashed truck
_veh = createVehicle [_vehclass,[(_position select 0) - 10.6206, (_position select 1) - 0.49,0], [], 0, "CAN_COLLIDE"];
[_veh,0.75,0.15] call spawnTempVehicle; 
//[_veh,damage,fuel] call spawnTempVehicle;
_veh setVehicleLock "LOCKED";
_veh setVariable ["R3F_LOG_disabled",true,true];

diag_log format["WAI: Mission wepsTruck spawned a %1",_vehname];

//Troops
_rndnum = round (random 3) + 4;
[[_position select 0, _position select 1, 0],_rndnum,_difficulty,"Random",4,"","","Random","minor","WAIminorArray"] call spawn_group;
sleep 0.1;
[[_position select 0, _position select 1, 0],2,_difficulty,"Random",4,"","","Random","minor","WAIminorArray"] call spawn_group;
sleep 0.1;
[[_position select 0, _position select 1, 0],4,_difficulty,"Random",4,"","","Random","minor","WAIminorArray"] call spawn_group;
sleep 0.1;

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

		_veh setVehicleLock "UNLOCKED";
		_veh setVariable ["R3F_LOG_disabled",false,true];
		
		// Wait for mission complete, then spawn the crates
		_box = createVehicle ["BAF_VehicleBox",[(_position select 0) + 0.7408, (_position select 1) + 4.565, 0.10033049], [], 0, "CAN_COLLIDE"];
		[_box] call vehicle_wreck_box;
		
		_box1 = createVehicle ["RULaunchersBox",[(_position select 0) - 0.2387, (_position select 1) + 1.043, 0.10033049], [], 0, "CAN_COLLIDE"];
		_box2 = createVehicle ["RULaunchersBox",[(_position select 0) + 2, (_position select 1) - 3, 0.10033049], [], 0, "CAN_COLLIDE"];
		
		
		
		if (_difficulty == "normal") then 
			{
				[_box1] call Extra_Large_Gun_Box;
				[_box2] call Sniper_Gun_Box;
			}
				else
			{
				[_box1] call easyGunCrate;
				[_box2] call Sniper_Gun_Box;
			};
				
		

		// mark crates with smoke/flares
		[_box] call markCrates;
		[_box1] call markCrates;
		[_box2] call markCrates;

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