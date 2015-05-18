private ["_markerName", "_difficulty", "_markerColor", "_size", "_Major1", "_Major2"];

WAIMajorPos	= _this select 0;
_markerName = _this select 1;
_difficulty = _this select 2;



call 
	{
		if (_difficulty == "easy") exitWith 
			{
				_markerColor = "ColorGreen";	
				_markerName = "[Easy] " + _markerName;
				_size = 150;
			};
	
		if (_difficulty == "normal") exitWith 
			{
				_markerColor = "ColorYellow";	
				_markerName = "[Normal] " + _markerName;
				_size = 200;
			};

		if (_difficulty == "hard") exitWith 
			{
				_markerColor = "ColorOrange";	
				_markerName = "[Hard] " + _markerName;
				_size = 250;
			};
		if (_difficulty == "extreme") exitWith 
			{
				_markerColor = "ColorRed";	
				_markerName = "[Hard] " + _markerName;
				_size = 300;
			};

		_markerColor = _difficulty;
	};

_Major1 	= "";
_Major2 	= "";
markerready = false;

while {missionrunning} do {

	_Major1 		= createMarker ["Mission", WAIMajorPos];
	_Major1 		setMarkerColor _markerColor;
	_Major1 		setMarkerShape "ELLIPSE";
	_Major1 		setMarkerBrush "Solid";
	_Major1 		setMarkerSize [_size,_size];
	_Major1 		setMarkerText _markerName;
	_Major2 		= createMarker ["dot", WAIMajorPos];
	_Major2 		setMarkerColor "ColorBlack";
	_Major2 		setMarkerType "mil_dot";
	_Major2 		setMarkerText _markerName;

	sleep 30;

	deleteMarker 	_Major1;
	deleteMarker 	_Major2;

};

if (_Major1 == "Mission") then {

	deleteMarker 	_Major1;
	deleteMarker 	_Major2;

};

markerready = true;
WAIMajorPos = [0,0,0];