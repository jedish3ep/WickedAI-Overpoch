private ["_position","_box","_missiontimeout","_cleanmission","_playerPresent","_starttime","_currenttime","_cleanunits","_rndnum","_missionName","_hint"];
vehclass = military_unarmed call BIS_fnc_selectRandom;
 
_position = [getMarkerPos "center",0,5500,10,0,2000,0] call BIS_fnc_findSafePos;
_missionName = "Osama's Compound";

//Large Gun Box
_box = createVehicle ["BAF_VehicleBox",[(_position select 0),(_position select 1), .5], [], 0, "CAN_COLLIDE"];
[_box] call Extra_Large_Gun_Box;
 
diag_log format["WAI: Mission Osamas Compound Started At %1",_position];

//Mayors Mansion
_baserunover = createVehicle ["Land_A_Villa_EP1",[(_position select 0), (_position select 1),0],[], 0, "CAN_COLLIDE"];

_rndnum = round (random 3) + 4;
[[_position select 0, _position select 1, 0],4,1,"Random",4,"","TK_INS_Soldier_EP1_DZ","Random",true] call spawn_group;
[[_position select 0, _position select 1, 0],4,1,"Random",4,"","TK_GUE_Soldier_Sniper_EP1","Random",true] call spawn_group;
[[_position select 0, _position select 1, 0],4,1,"Random",4,"","TK_GUE_Warlord_EP1","Random",true] call spawn_group;
[[_position select 0, _position select 1, 0],4,1,"Random",4,"","TK_GUE_Soldier_HAT_EP1","Random",true] call spawn_group;

//The HVT Himself
[[_position select 0, _position select 1, 0],1,1,"Random",4,"","TK_GUE_Soldier_TL_EP1","Random",true] call spawn_group;
 
[[[(_position select 0) - 15, (_position select 1) + 15, 8]],"KORD_high_TK_EP1",0.8,"TK_INS_Soldier_AT_EP1",1,2,"","Random",true] call spawn_static;
[[[(_position select 0) + 15, (_position select 1) - 15, 8]],"KORD_high_UN_EP1",0.8,"TK_Special_Forces_EP1",1,2,"","Random",true] call spawn_static;
 
//CREATE MARKER
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

_hint = parseText format ["<t align='center' color='#FF0000' shadow='2' size='1.75'>Priority Transmission</t><br/><t align='center' color='#FF0000'>------------------------------</t><br/><t align='center' color='#FFFFFF' size='1.25'>Main Mission</t><br/><t align='center' color='#FFFFFF'>%1 : Osama Bin Laden has been spotted in the Region, Kill the HVT and secure the stolen loot</t>", _missionName];
[nil,nil,rHINT,_hint] call RE;
 
[nil,nil,rTitleText,"Operation Neptune Spear - Kill the HVT and Secure the loot", "PLAIN",10] call RE;
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
	diag_log format["WAI: Mission Osamas Compound Ended At %1",_position];
	[nil,nil,rTitleText,"The HVT is Down. Secure the loot and RTB", "PLAIN",10] call RE;
	deleteMarker "_Major1";
	deleteMarker "_Major2";
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
 
	diag_log format["WAI: Mission Osamas Compound At %1",_position];
	[nil,nil,rTitleText,"The HVT has fled the region. Time's up", "PLAIN",10] call RE;
	deleteMarker "_Major1";
	deleteMarker "_Major2";
};
 
missionrunning = false;