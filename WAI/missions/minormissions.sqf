if(!isServer) exitWith {};

diag_log "WAI: Starting AI Minor Missions Monitor";

minor_missionrunning = false;
_startTime = floor(time);
_result = 0;

while {true} do
{
	_cnt = {alive _x} count playableUnits;
	_currTime = floor(time);
	if((_currTime - _startTime >= wai_minor_mission_timer) AND (!minor_missionrunning)) then {_result = 1};
	
	if(minor_missionrunning) then
	{
		_startTime = floor(time);
	};
	
	if((_result == 1) AND (_cnt >= 1))  then
    {
		clean_running_minor_mission = False;
        _minormission = wai_minor_missions call BIS_fnc_selectRandom;
        execVM format ["\z\addons\dayz_server\WAI\missions\minormissions\%1.sqf",_minormission];
		minor_missionrunning = true;
        diag_log format["WAI: Starting Minor Mission %1",_minormission];
        _startTime = floor(time);
        _result = 0;
    } else {
    	sleep 60;
    };    
};
