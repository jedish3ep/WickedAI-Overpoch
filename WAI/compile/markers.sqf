if(isServer) then {

	private ["_Major2","_position","_Major1","_name", "_markerColor","_size","_difficulty"];
	_position 	= _this select 0;
	_name 		= _this select 1;
	_difficulty = _this select 2;

	call 
		{
			if (_difficulty == "normal") exitWith 
				{
					_markerColor = "ColorYellow";	
					_name = "[Normal] " + _name;
					_size = 200;
				};

			if (_difficulty == "hard") exitWith 
				{
					_markerColor = "ColorOrange";	
					_name = "[Hard] " + _name;
					_size = 250;
				};
			if (_difficulty == "extreme") exitWith 
				{
					_markerColor = "ColorRed";	
					_name = "[Hard] " + _name;
					_size = 300;
				};

			_markerColor = _difficulty;
		};

	_Major1 	= "";
	_Major2 		= "";
	markerready = false;

	while {missionrunning} do {

		_Major1 		= createMarker ["Mission", _position];
		_Major1 		setMarkerColor _markerColor;
		_Major1 		setMarkerShape "ELLIPSE";
		_Major1 		setMarkerBrush "Solid";
		_Major1 		setMarkerSize [_size,_size];
		_Major1 		setMarkerText _name;
		_Major2 			= createMarker ["dot", _position];
		_Major2 			setMarkerColor "ColorBlack";
		_Major2 			setMarkerType "mil_dot";
		_Major2 			setMarkerText _name;

		sleep 30;

		deleteMarker 	_Major1;
		deleteMarker 	_Major2;

	};

	if (_Major1 == "Mission") then {

		deleteMarker 	_Major1;
		deleteMarker 	_Major2;

	};

	markerready = true;
};