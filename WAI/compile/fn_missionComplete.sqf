// fn_missionComplete.sqf
// used to ensure 75% of AI are killed before allowing mission to complete
// adapted from DZMS function by JakeHekesFists[DMD]
// https://github.com/SMVampire/DZMS-DayZMissionSystem/blob/master/DZMS/DZMSFunctions.sqf
// credits to Vampire

private["_position","_unitArray","_numSpawned","_numKillReq"];

_position = _this select 0;
_unitArray = _this select 1;

call compile format["_numSpawned = count %1;",_unitArray];

_numKillReq = ceil(0.75 * _numSpawned);

diag_log text format["[WAI]: (%3) Waiting for %1/%2 Units or Less to be Alive and a Player to be Near the Objective.",(_numSpawned - _numKillReq),_numSpawned,_unitArray];

call compile format["waitUntil{sleep 1; ({isPlayer _x && _x distance _position <= 30} count playableUnits > 0) && ({alive _x} count %1 <= (_numSpawned - _numKillReq));};",_unitArray];
