/*
	file: fn_createWrecks
	auth: jakehekesfists[dmd]
	
	usage: [_position,_numberofwrecks,_minDistance,_maxDistance,_missionType] call fn_createWrecks;
*/

_position = _this select 0;
_numberofwrecks = _this select 1;
_minDistance = _this select 2;
_maxDistance = _this select 3;
_missionType = _this select 4;

_objArray = ["HMMWVWreck","BRDMWreck","LADAWreck","SKODAWreck","datsun02Wreck","hiluxWreck","UralWreck","UH1Wreck"];

if (_missionType == "major") then
	{
		_buildArray = majorBldList;
	}
		else
	{
		_buildArray = minorBldList;
	};

for "_i" from 1 to _numberofwrecks do
	{
		private ["_scenery","_sceneryPos","_objType"];
		_objType = _objArray call BIS_fnc_selectRandom;
		
		_sceneryPos = _position findEmptyPosition [_minDistance,_maxDistance,_objType];
		_scenery = _objType createVehicle _sceneryPos;
		_buildArray = _buildArray + [_scenery];
	};