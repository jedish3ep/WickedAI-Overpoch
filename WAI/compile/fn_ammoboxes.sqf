/*
	file: fn_ammoboxes
	auth: jakehekesfists[DMD]
	usage:
		[_position,_loopTime,_maxDist,true/false,major/minor/""] call fn_ammoboxes;
		center position
		how many times to run the loop. 2 boxes per loop
		maximum distance from center point
		true / false to mark crates with flares or smoke shells?
*/

_position =	_this select 0;
_loopTime =	_this select 1;
_maxDist =	_this select 2;
_mark = 		_this select 3;
_missType =	_this select 4;

for "_i" from 1 to _loopTime do 
	{
		private ["_a1Box","_a2Box","_a1Pos","_a2Pos"];
		
		_a1Pos = _position findEmptyPosition [2.5,_maxDist,"AmmoBoxSmall_762"];
		_a1Box = createVehicle ["AmmoBoxSmall_762",_a1Pos, [], 0, "CAN_COLLIDE"];
		_a2Pos = _position findEmptyPosition [2.5,_maxDist,"AmmoBoxSmall_556"];
		_a2Box = createVehicle ["AmmoBoxSmall_556",_a2Pos, [], 0, "CAN_COLLIDE"];
		sleep 0.1;
		if (_mark) then
			{
				[_a1Box] call markCrates;
				[_a2Box] call markCrates;
			};
		if (_missType == "major") then 
			{
				majorBldList = majorBldList + [_a1Box];
				majorBldList = majorBldList + [_a2Box];
			};
		if (_missType == "minor") then 
			{
				minorBldList = minorBldList + [_a1Box];
				minorBldList = minorBldList + [_a2Box];
			};			
	};