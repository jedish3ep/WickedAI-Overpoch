private ["_fileName", "_missionType", "_picture", "_worldName", "_missionName", "_difficulty", "_missionDesc", "_winMessage", "_failMessage", "_position", "_base", "_rndnum", "_missiontimeout", "_cleanmission", "_playerPresent", "_starttime", "_currenttime", "_box"];

_fileName = "pervertPriest";
_missionType = "Minor Mission";

_picture = getText (configFile >> "cfgWeapons" >> "Cobalt_File" >> "picture");
_worldName = toLower format ["%1", worldName];
_missionName = "Pervert Priest";
_difficulty = "normal";

_missionDesc = "Reverend Cross has been accused of diddling little boys and stealing from the collection plate, An allegation which he denies. He has hired some of his parishioners as bodyguards to protect himself. Send this filth to hell and take the gold for yourself!";
_winMessage = format["Reverend Cross has been killed, Children of %1 Rejoice!",_worldName];
_failMessage = format["Time's up! Reverend Pedo has left %1 and gone into hiding",_worldName];

/* create marker and display messages */
diag_log format["WAI: Mission %1 Started At %2",_fileName,_position];
[_position,_missionName,_difficulty] execVM wai_minor_marker;
[_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;
[nil,nil,rTitleText,format["%1",_missionDesc], "PLAIN",10] call RE;
sleep 0.1;

/* Scenery */
_base = createVehicle ["Land_Church_03",_position, [], 0, "CAN_COLLIDE"];
_base setVectorUp surfaceNormal position _base;
minorBldList = minorBldList + [_base];


/* Troops */

/* priest */
_rndnum = round (random 3) + 4;
[
	[(_position select 0) - 26.6187, (_position select 1) - 1.0669, 0],
	1,							//Number Of units
	"hard",			    		//Skill level
	"Random",			    	//Primary gun set number. "Random" for random weapon set.
	2,							//Number of magazines
	"",							//Backpack "" for random or classname here.
	"Priest_DZ",			  		//Skin "" for random or classname here.
	"Random",				  	//Gearset number. "Random" for random gear set.
	"minor",
	"WAIminorArray"
] call spawn_group;

/* parishioners */
[
	[(_position select 0) - 27.6187, (_position select 1) - 0.0669, 0],
	_rndnum,
	"normal",
	"Random",
	4,
	"",
	"Functionary1_EP1_DZ",
	"Random",
	"minor",
	"WAIminorArray"
] call spawn_group;

_missiontimeout = true;
_cleanmission = false;
_playerPresent = false;
_starttime = floor(time);

while {_missiontimeout} do
	{
		sleep 5;
		_currenttime = floor(time);
		{if((isPlayer _x) AND (_x distance _position <= 150)) then {_playerPresent = true};}forEach playableUnits;
		if (_currenttime - _starttime >= wai_mission_timeout) then {_cleanmission = true;};
		if ((_playerPresent) OR (_cleanmission)) then {_missiontimeout = false;};
	};

if (_playerPresent) then 
	{
		[_position,"WAIminorArray"] call missionComplete;
		// wait for mission complete then spawn crate
		_box = createVehicle ["RUOrdnanceBox",[(_position select 0) + 6.0991, (_position select 1) + 4.1523, 1], [], 0, "CAN_COLLIDE"];
		[_box] call priest_gold_box;

		// mark crates with smoke/flares
		[_box] call markCrates;
		
		diag_log format["WAI: Mission %1 Ended At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_winMessage], "PLAIN",10] call RE;

		uiSleep 5*60;
		["minorclean"] call WAIcleanup;

	}
		else
	{

		clean_running_minor_mission = True;
		["minorclean"] call WAIcleanup;

		diag_log format["WAI: Mission %1 Timed Out At %2",_fileName,_position];
		[nil,nil,rTitleText,format["%1",_failMessage], "PLAIN",10] call RE;
	};

minor_missionrunning = false;