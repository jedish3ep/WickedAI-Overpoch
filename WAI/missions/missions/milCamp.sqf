private ["_position","_box","_missiontimeout","_cleanmission","_playerPresent","_starttime","_currenttime","_cleanunits","_rndnum","_box2","_missionName","_vehclass","_hint"];
_vehclass = armed_vehicle call BIS_fnc_selectRandom;
_missionName = "Military Camp";
 
_position = [getMarkerPos "center",0,5500,10,0,2000,0] call BIS_fnc_findSafePos;

//Extra Large Gun Box
 _box = createVehicle ["RUVehicleBox",[(_position select 0) -15,(_position select 1),0], [], 0, "CAN_COLLIDE"];
[_box] call Extra_Large_Gun_Box1;

//Construction Supply Box
_box2 = createVehicle ["BAF_VehicleBox",[(_position select 0) +15,(_position select 1),0], [], 0, "CAN_COLLIDE"];
[_box2] call Construction_Supply_Box;
 
diag_log format["WAI: Mission milCamp Started At %1",_position];

_veh = createVehicle [_vehclass,[(_position select 0) - 30,(_position select 1) + 15,0], [], 0, "CAN_COLLIDE"];
_vehdir = round(random 360);
_veh setDir _vehdir;
clearWeaponCargoGlobal _veh;
clearMagazineCargoGlobal _veh;
_veh setVariable ["ObjectID","1",true];
PVDZE_serverObjectMonitor set [count PVDZE_serverObjectMonitor,_veh];
diag_log format["WAI: Mission MilCamp spawned a %1",_vehname];


//Buildings 
_baserunover = createVehicle ["US_WarfareBAntiAirRadar_Base_EP1",[(_position select 0), (_position select 1)],[], 0, "CAN_COLLIDE"];
_baserunover setDir 90;
_baserunover setVectorUp surfaceNormal position _baserunover;

_baserunover1 = createVehicle ["TK_WarfareBBarracks_EP1",[(_position select 0) + 25, (_position select 1)],[], 0, "CAN_COLLIDE"];
_baserunover1 setDir 90;
_baserunover1 setVectorUp surfaceNormal position _baserunover1;

_baserunover4 = createVehicle ["Misc_cargo_cont_net3",[(_position select 0) - 10, (_position select 1),-0.2],[], 0, "CAN_COLLIDE"];
_baserunover4 setDir 0;
_baserunover4 setVectorUp surfaceNormal position _baserunover4;
_baserunover5 = createVehicle ["Misc_cargo_cont_net2",[(_position select 0) + 10, (_position select 1),-0.2],[], 0, "CAN_COLLIDE"];
_baserunover5 setDir 180;
_baserunover5 setVectorUp surfaceNormal position _baserunover5;
_baserunover6 = createVehicle ["Misc_cargo_cont_net3",[(_position select 0), (_position select 1) - 10,-0.2],[], 0, "CAN_COLLIDE"];
_baserunover6 setDir 270;
_baserunover6 setVectorUp surfaceNormal position _baserunover6;
_baserunover7 = createVehicle ["Misc_cargo_cont_net2",[(_position select 0), (_position select 1) + 10,-0.2],[], 0, "CAN_COLLIDE"];
_baserunover7 setDir 90;
_baserunover7 setVectorUp surfaceNormal position _baserunover7;

//Group Spawning
_rndnum = round (random 3) + 4;
[[_position select 0, _position select 1, 0],_rndnum,1,"Random",4,"","UKSF_wdl_demo_l","Random",true] call spawn_group;
[[_position select 0, _position select 1, 0],4,1,"Random",4,"","Graves_Light_DZ","Random",true] call spawn_group;
[[_position select 0, _position select 1, 0],4,1,"Random",4,"","UKSF_wdl_mrk_l","Random",true] call spawn_group;
[[_position select 0, _position select 1, 0],4,1,"Random",4,"","UKSF_wdl_tl_l","Random",true] call spawn_group;
[[_position select 0, _position select 1, 0],4,1,"Random",4,"","Sniper1_DZ","Random",true] call spawn_group;
 
//Turrets
[[[(_position select 0) - 10, (_position select 1) + 10, 0]],"KORD_high",0.8,"UKSF_wdl_demo_l",1,2,"","Random",true] call spawn_static;
[[[(_position select 0) + 10, (_position select 1) - 10, 0]],"M2StaticMG",0.8,"Soldier_Sniper_PMC_DZ",1,2,"","Random",true] call spawn_static;
[[[(_position select 0) - 10, (_position select 1) - 10, 0]],"DSHKM_Gue",0.8,"UKSF_wdl_tl_l",1,2,"","Random",true] call spawn_static;
[[[(_position select 0) - 15, (_position select 1) - 15, 0]],"SPG9_TK_GUE_EP1",0.8,"Soldier_Sniper_PMC_DZ",1,2,"","Random",true] call spawn_static;

//Heli Paradrop
[[(_position select 0), (_position select 1), 0],[7743.41, 7040.93, 0],400,"BAF_Merlin_DZE",10,1,"Random",4,"","UKSF_wdl_tl_l","Random",True] spawn heli_para;
 
[_position,_missionName] execVM wai_marker;

_hint = parseText format ["<t align='center' color='#FF0000' shadow='2' size='1.75'>Priority Transmission</t><br/><t align='center' color='#FF0000'>------------------------------</t><br/><t align='center' color='#FFFFFF' size='1.25'>Main Mission</t><br/><t align='center' color='#FFFFFF'>The Military are setting up a camp, they have a %2, Kill them and take their supplies</t>",_vehname];
[nil,nil,rHINT,_hint] call RE;

[nil,nil,rTitleText,"The Military have been spotting building a base. Go kill them and steal their supplies!", "PLAIN",10] call RE;
_missiontimeout = true;
_cleanmission = false;
_playerPresent = false;
_starttime = floor(time);
while {_missiontimeout} do {
	sleep 5;
	_currenttime = floor(time);
	{if((isPlayer _x) AND (_x distance _position <= 150)) then {_playerPresent = true};}forEach playableUnits;
	if (_currenttime - _starttime >= wai_mission_timeout) then {_cleanmission = true;};
	if ((_playerPresent) OR (_cleanmission)) then {_missiontimeout = false;};
};
if (_playerPresent) then {
	waitUntil
	{
		sleep 5;
		_playerPresent = false;
		{if((isPlayer _x) AND (_x distance _position <= 30)) then {_playerPresent = true};}forEach playableUnits;
		(_playerPresent)
	};
	diag_log format["WAI: Mission milCamp Ended At %1",_position];
	[nil,nil,rTitleText,"The Military presence has been eliminated! Well Done", "PLAIN",10] call RE;
} else {
	clean_running_mission = True;
	deleteVehicle _box;
	{_cleanunits = _x getVariable "missionclean";
	if (!isNil "_cleanunits") then {
		switch (_cleanunits) do {
			case "ground" :  {ai_ground_units = (ai_ground_units -1);};
			case "air" :     {ai_air_units = (ai_air_units -1);};
			case "vehicle" : {ai_vehicle_units = (ai_vehicle_units -1);};
			case "static" :  {ai_emplacement_units = (ai_emplacement_units -1);};
		};
		deleteVehicle _x;
		sleep 0.05;
	};
	} forEach allUnits;
 
	diag_log format["WAI: Mission milCamp At %1",_position];
	[nil,nil,rTitleText,"Time's up! MISSION FAILED!!", "PLAIN",10] call RE;
};
 
missionrunning = false;