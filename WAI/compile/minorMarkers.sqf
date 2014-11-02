if(isServer) then {

	private ["_Minor2","_position","_Minor1","_name","_difficulty","_markerColor","_size"];
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

	_Minor1 	= "";
	_Minor2 		= "";
	minor_markerready = false;

	while {minor_missionrunning} do {

		_Minor1 		= createMarker ["MinorMission", _position];
		_Minor1 		setMarkerColor _markerColor;
		_Minor1 		setMarkerShape "ELLIPSE";
		_Minor1 		setMarkerBrush "Solid";
		_Minor1 		setMarkerSize [_size,_size];
		_Minor1 		setMarkerText _name;
		_Minor2 			= createMarker ["Minordot", _position];
		_Minor2 			setMarkerColor "ColorBlack";
		_Minor2 			setMarkerType "mil_dot";
		_Minor2 			setMarkerText _name;

		sleep 30;

		deleteMarker 	_Minor1;
		deleteMarker 	_Minor2;

	};

	if (_Minor1 == "MinorMission") then {

		deleteMarker 	_Minor1;
		deleteMarker 	_Minor2;

	};

	minor_markerready = true;
};