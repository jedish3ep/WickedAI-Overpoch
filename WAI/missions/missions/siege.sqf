//City Under Siege - by jakehekesfists
 
private ["_position","_box","_missiontimeout","_cleanmission","_playerPresent","_starttime","_currenttime","_cleanunits","_rndnum","_box2","_hint","_missionName"];
 
_positionarray = [[7546.7695,5144.9907,0],[5981.9287,10345.304,0],[12045.273,9092.3789,0],[11200.665,6572.3813,0],[4485.8018,6414.3247,0]];
_position = _positionarray call BIS_fnc_selectRandom;
_missionName = "City Under Siege";

//Extra Large Gun Box
_box = createVehicle ["RUVehicleBox",[(_position select 0) + 5,(_position select 1),0], [], 0, "CAN_COLLIDE"];
[_box] call Extra_Large_Gun_Box1;
_box2 = createVehicle ["BAF_VehicleBox",[(_position select 0) - 10,(_position select 1) - 10,0], [], 0, "CAN_COLLIDE"];
[_box2] call Sniper_Gun_Box;
 
diag_log format["WAI: Mission City Siege Started At %1",_position];

//Decorations  
_baserunover = createVehicle ["HMMWVWreck",[(_position select 0) - 40, (_position select 1),-0.2],[], 0, "CAN_COLLIDE"];
_baserunover setDir 90;
_baserunover setVectorUp surfaceNormal position _baserunover;
_baserunover1 = createVehicle ["M1130_HQ_unfolded_EP1",[(_position select 0), (_position select 1),-0.2],[], 0, "CAN_COLLIDE"];
_baserunover1 setDir 270;

//Group Spawning
_rndnum = round (random 3) + 4;
[[_position select 0, _position select 1, 0],_rndnum,1,"Random",4,"","FR_OHara_DZ","Random",true] call spawn_group;
[[_position select 0, _position select 1, 0],4,1,"Random",4,"","GUE_Soldier_Sniper_DZ","Random",true] call spawn_group;
[[_position select 0, _position select 1, 0],4,1,"Random",4,"","GUE_Soldier_MG_DZ","Random",true] call spawn_group;
[[_position select 0, _position select 1, 0],4,1,"Random",4,"","GUE_Soldier_Crew_DZ","Random",true] call spawn_group;
[[_position select 0, _position select 1, 0],4,1,"Random",4,"","GUE_Soldier_MG_DZ","Random",true] call spawn_group;
[[_position select 0, _position select 1, 0],4,1,"Random",4,"","Ins_Soldier_GL_DZ","Random",true] call spawn_group;
 
//Turrets
[[[(_position select 0) - 5, (_position select 1) + 30, 0]],"KORD_high",0.8,"Ins_Soldier_GL_DZ",1,2,"","Random",true] call spawn_static;
[[[(_position select 0) - 5, (_position select 1) - 5, 0]],"DSHKM_Gue",0.8,"GUE_Soldier_MG_DZ",1,2,"","Random",true] call spawn_static;

//CREATE MARKER
while {missionrunning} do {
	_Major1 =	createMarker ["_Major1", _position];
	_Major1 setMarkerText "";
	_Major1 setMarkerColor "ColorRed";
	_Major1 setMarkerShape "ELLIPSE";
	_Major1 setMarkerBrush "Solid";
	_Major1 setMarkerSize [300,300];

	_Major2 =	createMarker ["_Major2", _position];
	_Major2 setMarkerColor "ColorBlack";
	_Major2 setMarkerType "mil_dot";
	_Major2 setMarkerText _missionName;
	sleep 30;
	deleteMarker _Major1;
	deleteMarker _Major2;
};
if (_Major1 == "Mission") then {
	deleteMarker _Major1;
	deleteMarker _Major2;
};

_hint = parseText format ["<t align='center' color='#FF0000' shadow='2' size='1.75'>Priority Transmission</t><br/><t align='center' color='#FF0000'>------------------------------</t><br/><t align='center' color='#FFFFFF' size='1.25'>Main Mission</t><br/><t align='center' color='#FFFFFF'>%1 : Heavily armed insurgents have taken over the City, clear them out</t>", _missionName];
[nil,nil,rHINT,_hint] call RE;

[nil,nil,rTitleText,"Insurgents have taken over the city, clear them out!", "PLAIN",10] call RE;
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
	diag_log format["WAI: Mission City Siege Ended At %1",_position];
	[nil,nil,rTitleText,"The insurgents have been killed, the City is at peace", "PLAIN",10] call RE;
	deleteMarker "_Major1";
	deleteMarker "_Major2";
} else {
	clean_running_mission = True;
	deleteVehicle _box;
	deleteVehicle _box2;
	deleteVehicle _baserunover;
	deleteVehicle _baserunover1;	
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
 
	diag_log format["WAI: Mission City Siege At %1",_position];
	[nil,nil,rTitleText,"The Terrorists have won, The city has been laid to waste", "PLAIN",10] call RE;
	deleteMarker "_Major1";
	deleteMarker "_Major2";
};
 
missionrunning = false;