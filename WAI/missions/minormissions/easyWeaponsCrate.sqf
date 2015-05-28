private ["_fileName", "_position", "_missionName", "_missionType", "_difficulty", "_picture", "_missionDesc", "_winMessage", "_failMessage", "_net", "_artNest", "_bagFence", "_scenery", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box"];

_fileName = "easyWeaponsCrate";
_position = call WAI_findPos;

_missionName = "Weapons Crate";
_missionType = "Minor Mission";
_difficulty = "easy";
_picture = getText(configFile >> "CfgWeapons" >> "SCAR_H_STD_EGLM_Spect" >> "picture");
_missionDesc = "Bandits have stolen a shipment of weapons bound for the Black Market Trader";
_winMessage = "Good job, the bandits are Dead and the Weapons are now yours";
_failMessage = "Time's Up! The bandits have escaped with the weapons";

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_minor_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

/* Mission Scenery */
_net = createVehicle ["Land_CamoNetB_NATO",[(_position select 0) - 0.0649, (_position select 1) + 0.6025,0],[], 0, "CAN_COLLIDE"];
_artNest = createVehicle ["Land_fort_artillery_nest",[(_position select 0) - 5.939,(_position select 1) + 10.0459,0],[], 0, "CAN_COLLIDE"];
_artNest setDir -31.158424;
_bagFence = createVehicle ["Land_fort_bagfence_corner",[(_position select 0) - 0.8936, (_position select 1) + 8.1582,0],[], 0, "CAN_COLLIDE"];
_bagFence setDir -56.044361;

_scenery = [_net,_artNest,_bagFence];
{ minorBldList = minorBldList + [_x]; } forEach _scenery;
{ _x setVectorUp surfaceNormal position _x; } count _scenery;

for "_i" from 1 to 2 do 
	{
		[_position,4,_difficulty,"Random",3,"","","Random","minor","WAIminorArray"] call spawn_group;
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
		_box = createVehicle ["USVehicleBox",_position,[], 0, "CAN_COLLIDE"];
		[_box] call easyGunCrate;
		[_box] call markCrates;		// mark crates with smoke/flares

		for "_i" from 1 to 2 do 
			{
				private ["_a1Box","_a2Box","_a1Pos","_a2Pos"];
				
				_a1Pos = _position findEmptyPosition [5,50,"AmmoBoxSmall_762"];
				_a1Box = createVehicle ["AmmoBoxSmall_762",_a1Pos, [], 0, "CAN_COLLIDE"];
				_a2Pos = _position findEmptyPosition [5,50,"AmmoBoxSmall_556"];
				_a2Box = createVehicle ["AmmoBoxSmall_556",_a2Pos, [], 0, "CAN_COLLIDE"];
				sleep 0.1;
			};
		
		diag_log format["WAI: Mission %1 Ended At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_winMessage], "PLAIN",10] call RE;
		
		uiSleep 300;
		["minorclean"] call WAIcleanup;
	}
		else
	{
		clean_running_minor_mission = True;
		diag_log format["WAI: Mission %1 Timed Out At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_failMessage], "PLAIN",10] call RE;
		["minorclean"] call WAIcleanup;
	};
minor_missionrunning = false;