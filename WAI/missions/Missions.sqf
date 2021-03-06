if(isServer) then {

diag_log "WAI: Starting AI Missions Monitor";

missionrunning = false;
_startTime = floor(time);
_result = 0;

	while {true} do
	{
		_cnt = {alive _x} count playableUnits;
		_currTime = floor(time);
		if((_currTime - _startTime >= wai_mission_timer) && (!missionrunning)) then {_result = 1};
		
		if(missionrunning) then
		{
			_startTime = floor(time);
		};
		
		if((_cnt >= 1) && ((diag_fps) > 5)) then 
		{
			if(_result == 1) then
			{
				// clean previous missions AI if they're still alive
				{_cleanunits = _x getVariable "majorclean";
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
				// empty the existing array
				WAImajorArray = [];

				clean_running_mission = False;
				_mission = wai_missions call BIS_fnc_selectRandom;
				execVM format ["\z\addons\dayz_server\WAI\missions\missions\%1.sqf",_mission];
				missionrunning = true;
				diag_log format["WAI: Starting Mission %1",_mission];
				_startTime = floor(time);
				_result = 0;
			};
		};
		sleep 1;
	};
};