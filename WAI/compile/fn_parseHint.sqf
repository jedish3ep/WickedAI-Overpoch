/*
	fn_parseHint.sqf
	JakeHekesFists[DMD]
	13/05/2015
	Converts array of info into a uniform Hint Message for AI Missions
*/

// Usage:
// [_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;


private ["_missionName", "_missionType", "_difficulty", "_picture", "_missionDesc", "_misName", "_misType", "_misDiff", "_misPict", "_misDesc", "_hint", "_compoundMSG"];

_misName = _this select 0;
_misType = _this select 1;
_misDiff = _this select 2;
_misPict = _this select 3;
_misDesc = _this select 4;


_hint = parseText format [
	"<t align='center' color='#1E90FF' shadow='2' size='1.75'>Priority Transmission</t><br/>" +
	"<t align='center' color='#FFFFFF'>------------------------------</t><br/>" +
	"<t align='center' color='#1E90FF' size='1.5'>%1</t><br/>" +
	"<t align='center' color='#FFFFFF' size='1.5'>%2</t><br/>" +
	"<t align='center' color='#FFFFFF' size='1'>Difficulty: <t size='1.1' color='#1E90FF'> %3</t><br/>" +
	"<t align='center'><img size='4' image='%4'/></t><br/>" +
	"<t align='center' size='1.1' color='#FFFFFF'>%5</t>"
	,
	_misName,
	_misType,
	_misDiff,
	_misPict,
	_misDesc	
];
[nil,nil,rHINT,_hint] call RE;


/* You need to have a broadcaster in your mission file for this bit below to work! */
_compoundMSG + format ["<img size='1.1' align='left' image='%1'/>",_misPict];
_compoundMSG = _compoundMSG + format ["<t align='left' size='0.7'> %1 | </t>",_misType];
_compoundMSG = _compoundMSG + format ["<t align='left' size='0.7' color='#1E90FF'> %1 </t>",_misName];

compoundMessage = [_compoundMSG];
publicVariable "compoundMessage";

/* Copy below into your mission files init.sqf and uncomment it! */
/*
 if (!isDedicated) then
	{
		fnc_compound_message = {
		private ["_finaltxt"];
			_finaltxt = _this select 0;
			[
				_finaltxt,
				safeZoneX+0.05,
				safeZoneY+0.1,
				30,
				0.5
			] spawn BIS_fnc_dynamicText;
		};
		"compoundMessage" addPublicVariableEventHandler {(_this select 1) call fnc_compound_message;};
	};
*/