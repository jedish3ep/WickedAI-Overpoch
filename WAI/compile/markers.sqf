if(isServer) then {

	private ["_Major2","_position","_Major1","_name"];
	_position 	= _this select 0;
	_name 		= _this select 1;

	_Major1 	= "";
	_Major2 		= "";
	markerready = false;

	while {missionrunning} do {

		_Major1 		= createMarker ["Mission", _position];
		_Major1 		setMarkerColor "ColorRed";
		_Major1 		setMarkerShape "ELLIPSE";
		_Major1 		setMarkerBrush "Solid";
		_Major1 		setMarkerSize [300,300];
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