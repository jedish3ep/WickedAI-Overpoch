/* * *	WickedAI | Doges of Mass Destruction Edit * * */
/* * *	JakeHekesFists[DMD] ||	v2.5.20150513		* * */

spawn_group = 				compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\SpawnGroup.sqf";
group_waypoints = 			compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\patrol.sqf";
spawn_static  = 				compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\SpawnStatic.sqf";
heli_para  = 					compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\heli_para.sqf";
heli_patrol = 				compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\heli_patrol.sqf";
vehicle_patrol = 				compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\vehicle_patrol.sqf";
on_kill = 					compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\ai_killed.sqf";
ai_monitor = 					compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\AImonitor.sqf";
veh_monitor = 				compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\vehicle_monitor.sqf";

/* 21DMD Functions */
missionComplete = 			compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\fn_missionComplete.sqf";
spawnTempVehicle = 			compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\fn_tempVeh.sqf";
markCrates = 					compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\fn_markCrates.sqf";
WAIcleanup = 					compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\fn_cleanup.sqf";
fn_parseHint = 				compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\fn_parseHint.sqf";
fn_tempStarter = 				compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\fn_tempStarter.sqf";

/* 3rd Party Functions */
//cache_units	=				compile preprocessFileLineNumbers "\z\addons\dayz_server\WAI\compile\cache_units.sqf";

createCenter east;
WEST setFriend [EAST,0];
EAST setFriend [WEST,0];
WAIconfigloaded = False;
WAImissionconfig = False;

ai_ground_units = 0;
ai_emplacement_units = 0;
ai_air_units = 0;
ai_vehicle_units = 0;

/* Unit and Scenery Arrays for Cleanup */
WAIminorArray = [];
WAImajorArray = [];
WAIcompoundArray = [];
minorBldList = [];
majorBldList = [];

WAIBlackList = [
	[[6710.0474, 2571.0735, 0],500],
	[[10340.616, 2068.4207, 0],500],
	[[12100.296, 9311.5938, 0],500],
	[[6612.915, 14183.943, 0],1500],
	[[6325.6772, 7807.7412, 0],800],
	[[7220.1836, 3005.275, 0],500],
	[[12116.242, 9726.7061, 0],500],
	[[12060.471, 12638.533, 0],500],
	[[4985.93, 9704.6885, 0],500],
	[[12944.227, 12766.889, 0],500],
	[[1606.6443, 7803.5156, 0],500],
	[[2242.6792, 10761.169, 0],500],
	[[4361.4937, 2259.9526, 0],300],
	[[13441.16, 5429.3013, 0],150]
];

/* Define marker pos to prevent missions spawning too close to each other */
if (isNil "WAIMajorPos")then{WAIMajorPos = [0,0,0];};
if (isNil "WAIMinorPos")then{WAIMinorPos = [0,0,0];};

WAI_findPos = 
	{
		private ["_centerPos", "_mapRadius", "_hardXPos", "_hardYPos", "_runLoop", "_posX", "_posY", "_waterFeeler1", "_waterFeeler2", "_waterFeeler3", "_waterFeeler4", "_isNotWater", "_majorDistance", "_minorDistance", "_okDis", "_blackListedZone", "_playerNear", "_result"];

		_centerPos = [7100, 7750, 0];
		_mapRadius = 5500;
			
		_hardXPos = _centerPos select 0;
		_hardYPos = _centerPos select 1;
	   
			/* loop find safe pos so center pos not returned */
			_runLoop = true;
			while {_runLoop} do
				{
					_pos = [_centerPos,0,_mapRadius,60,0,20,0] call BIS_fnc_findSafePos;
				   
					_posX = _pos select 0;
					_posY = _pos select 1;
				   
				   /* Check for Water */
					_waterFeeler1 = [_posX, _posY+50, 0];
					_waterFeeler2 = [_posX+50, _posY, 0];
					_waterFeeler3 = [_posX, _posY-50, 0];
					_waterFeeler4 = [_posX-50, _posY, 0];
					_isNotWater = (!surfaceIsWater _pos && !surfaceIsWater _waterFeeler1 && !surfaceIsWater _waterFeeler2 && !surfaceIsWater _waterFeeler3 && !surfaceIsWater _waterFeeler4);

					/* Make sure isn't to close to another mission */
					_majorDistance = (_pos distance WAIMajorPos);
					_minorDistance = (_pos distance WAIMinorPos);
					_okDis = ((_majorDistance > 1000) AND (_minorDistance > 1000));
				   
					/* Check for Blacklist */
					_blackListedZone = false;
					{
						if ((_pos distance (_x select 0)) <= (_x select 1)) then {_blackListedZone = true;};
					} forEach WAIBlackList;
					
					/* Don't Spawn Missions on top of Players */
					_playerNear = {isPlayer _x} count (_pos nearEntities ["CAManBase", 600]) > 0;
					
					/* Complete the Loop */
					if ((_posX != _hardXPos) AND (_posY != _hardYPos) AND _isNotWater AND _okDis AND !_blackListedZone AND !_playerNear) then 
						{
							_runLoop = false;
						};
					
					sleep 2;
				};
	   
		_result = [(_pos select 0), (_pos select 1), 0];
		_result
	};
	
//Load config
[] ExecVM "\z\addons\dayz_server\WAI\AIconfig.sqf";

//Wait for config
waitUntil {WAIconfigloaded};
diag_log "WAI: AI Config File Loaded";
[] spawn ai_monitor;

if (ai_mission_sysyem) then 
	{
		//Load AI mission system
		[] ExecVM "\z\addons\dayz_server\WAI\missions\missionIni.sqf";
	};