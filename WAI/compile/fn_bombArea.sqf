/*
	file: fn_bombArea.sqf
	auth: jakehekesfists[dmd]
	
	usage: [_position,_numberofBombs] call fn_bombArea;
*/

_position = _this select 0;
_numberofBombs = _this select 1;

for "_i" from 1 to _numberofBombs do
	{	
		private ["_plusMinus", "_dist1", "_dist2", "_dist3", "_bomb", "_position"];
		
		_plusMinus = floor (random 2);
		_dist1 = round (random 200) + 1;
		_dist2 = round (random 100) + 10;
		_dist3 = round (random 50) + 50;
		
		if (_plusMinus == 1) then 
			{
				_bomb = "Bo_GBU12_LGB" createVehicle [(_position select 0) + _dist2,(_position select 1) - _dist1, _dist3];
			}
				else
			{
				_bomb = "Bo_GBU12_LGB" createVehicle [(_position select 0) - _dist2,(_position select 1) + _dist1, _dist3];
			};
		sleep 5;
	};