/*
	File: fn_cleanup.sqf
	Auth: JakeHekesFists[DMD]
	Desc: Deletes Placed Items
	Allows each mission file to be cleaned with less code
*/

private ["_option","_cleanunits"];

_option = _this select 0;

switch (_option) do 
 {
 	case "minorclean" : 
 			{
 					{deleteVehicle _x} foreach minorBldList;
 					sleep 1;
 					minorBldList = [];
 			};
 	case "majorclean" : 
 			{
 					{deleteVehicle _x} foreach majorBldList;
 					sleep 1;
 					majorBldList = [];
 			};
 	case default {};
 };

 {_cleanunits = _x getVariable _option;
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