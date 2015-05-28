/*	File: humveeCrash.sqf | Author: JakeHekesFists[DMD]	*/

private ["_fileName", "_missionType", "_position", "_veharray", "_vehclass", "_vehname", "_worldName", "_missionName", "_difficulty", "_missionDesc", "_winMessage", "_failMessage", "_picture", "_veh", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box", "_box1"];

_fileName = "humveeCrash";
_missionType = "Minor Mission";
_position = call WAI_findPos;

_veharray = ["HMMWV_DZ","HMMWV_M1035_DES_EP1","HMMWV_M1151_M2_DES_EP1","HMMWV_M998A2_SOV_DES_EP1_DZE","HMMWV_M998_crows_MK19_DES_EP1"];
_vehclass = _veharray call BIS_fnc_selectRandom;
_vehname	= getText (configFile >> "CfgVehicles" >> _vehclass >> "displayName");
_worldName = toLower format ["%1", worldName];
_missionName = "Crashed Hummer";
_difficulty = "normal";
_missionDesc = format["Some Shitlord Bandits have stacked their %1, They were transporting some weapons across %2. Kill Them and secure the vehicle and weapons for yourself!",_vehname,_worldName];
_winMessage = format["The Crashed %1 has been Secured",_vehname];
_failMessage = format["Time's Up! You Failed to secure the %1 in Time",_vehname];
_picture = getText (configFile >> "cfgVehicles" >> _vehclass >> "picture");

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_minor_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;


/* Hummvee */
_veh = createVehicle [_vehclass,[(_position select 0) - 10.6206, (_position select 1) - 0.49,0], [], 0, "CAN_COLLIDE"];
[_veh,0.75,0.15] call spawnTempVehicle;
_veh setVehicleLock "LOCKED";
_veh setVariable ["R3F_LOG_disabled",true,true]; 


/* Troops */
for "_i" from 1 to 2 do
	{
		private ["_rndnum"];
		_rndnum = round (random 3) + 4;
		[[_position select 0, _position select 1, 0],_rndnum,_difficulty,"Random",4,"","","Random","minor","WAIminorArray"] call spawn_group;
		sleep 0.1;
	};

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
		/* wait for mission complete, then spawn crates and unlock vehicle */	
		_veh setVehicleLock "UNLOCKED";
		_veh setVariable ["R3F_LOG_disabled",false,true];
		
		_box = createVehicle ["BAF_VehicleBox",[(_position select 0) + 0.7408, (_position select 1) + 4.565, 0.10033049], [], 0, "CAN_COLLIDE"];	
		_box1 = createVehicle ["RULaunchersBox",[(_position select 0) - 0.2387, (_position select 1) + 1.043, 0.10033049], [], 0, "CAN_COLLIDE"];
		
		[_box] call vehicle_wreck_box;
		[_box1] call Large_Gun_Box;
		[_box] call markCrates;
		[_box1] call markCrates;

		diag_log format["WAI: Mission %1 Ended At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_winMessage], "PLAIN",10] call RE;
		
		uiSleep 300;
		["minorclean"] call WAIcleanup;
	} else {
		clean_running_minor_mission = True;
		diag_log format["WAI: Mission %1 Timed Out At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_failMessage], "PLAIN",10] call RE;
		sleep 10;
		deleteVehicle _veh;
		["minorclean"] call WAIcleanup;
	};

minor_missionrunning = false;