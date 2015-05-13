/*
	fn_parseHint.sqf
	JakeHekesFists[DMD]
	13/05/2015
	Converts array of info into a uniform Hint Message for AI Missions
*/

// Usage:
// [_missionName,_missionType,_difficulty,_picture,_missionDesc] call fn_parseHint;


private ["_missionName", "_missionType", "_difficulty", "_picture", "_missionDesc", "_misName", "_misType", "_misDiff", "_misPict", "_misDesc", "_hint"];

_misName = _this select 0;
_misType = _this select 1;
_misDiff = _this select 2;
_misPict = _this select 3;
_misDesc = _this select 4;


_hint = parseText format [
	"<t align='center' color='#1E90FF' shadow='2' size='1.75'>Priority Transmission</t><br/>" +
	"<t align='center' color='#FFFFFF'>------------------------------</t><br/>" +
	"<t align='center' color='#1E90FF' size='1.25'>%1</t><br/>" +
	"<t align='center' color='#FFFFFF' size='1.25'>%2</t><br/>" +
	"<t align='center' color='#FFFFFF' size='0.9'>Difficulty: <t color='#1E90FF'> %3</t><br/>" +
	"<t align='center'><img size='5' image='%4'/></t><br/>" +
	"<t align='center' color='#FFFFFF'>%5</t>"
	,
	_misName,
	_misType,
	_misDiff,
	_misPict,
	_misDesc	
];

[nil,nil,rHINT,_hint] call RE;