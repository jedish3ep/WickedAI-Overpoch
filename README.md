WickedAI-Overpoch
=================

A modified version of Wicked AI customised for our servers

** PLEASE NOTE ** 
THESE FILES ARE NOT READY / INTENDED FOR PUBLIC RELEASE
FEEL FREE TO USE AND MODIFY THEM AS YOU SEE FIT, BUT BE ADVISED THAT THERE ARE MANY BUGS
AND MANY OF THE FEATURES ARE REALLY DESIGNED ONLY FOR TESTING/USE WITH OUR SERVERS


I have created a lot of new Missions for Wicked AI 
Currently ALL missions add to humanity for bandit kills, 
But many AI are skinned like Military or Survivors depending on the mission type

WARNING: These missions are designed for DayZ overpoch and the AI and crates contain a lot of overwatch weapons. 

These Missions can be started from Epoch Admin Tools 
by following these steps

dayz_server.pbo

at the very bottom of init\server_functions.sqf 
add

```SQF
call compile preprocessFileLineNumbers "\z\addons\dayz_server\adminevents\compiles.sqf";				// admin compiles
```

then create a folder called adminevents
and then create a file inside adminevents called compiles.sqf

```SQF
server_adminWAI = compile preprocessFileLineNumbers "\z\addons\dayz_server\adminevents\compiles\adminWAI.sqf";
server_adminWAIminor = compile preprocessFileLineNumbers "\z\addons\dayz_server\adminevents\compiles\adminWAIminor.sqf";
server_adminEvent = compile preprocessFileLineNumbers "\z\addons\dayz_server\adminevents\compiles\adminEvent.sqf";
```

next create a folder inside adminevents called compiles

and add the following 3 files

adminWAI.sqf
```SQF
private ["_date","_key","_result","_outcome","_datestr","_event"];
diag_log("ADMIN START WAI MISSION MANUALLY");
_event = _this select 0;
_key = "CHILD:307:";
_result = _key call server_hiveReadWrite;
_outcome = _result select 0;
if(_outcome == "PASS") then {
    _date = _result select 1;
    _datestr  = str(_date);
    diag_log ("RUNNING WAI MISSION: " + (_event) + " on " + _datestr);
    [] execVM "\z\addons\dayz_server\WAI\missions\missions\" + (_event) + ".sqf";
};
```
adminWAIminor.sqf
```SQF
private ["_date","_key","_result","_outcome","_datestr","_event"];
diag_log("ADMIN START WAI MINOR MISSION MANUALLY");
_event = _this select 0;
_key = "CHILD:307:";
_result = _key call server_hiveReadWrite;
_outcome = _result select 0;
if(_outcome == "PASS") then {
    _date = _result select 1;
    _datestr  = str(_date);
    diag_log ("RUNNING WAI MISSION: " + (_event) + " on " + _datestr);
    [] execVM "\z\addons\dayz_server\WAI\missions\minormissions\" + (_event) + ".sqf";
};
```
adminEvent.sqf (this will also allow you to create custom events, store them in your server.pbo and call them in using epoch admin tools)
```SQF
private ["_date","_key","_result","_outcome","_datestr","_event"];
diag_log("ADMIN STARTED EVENTS");
_event = _this select 0;
_key = "CHILD:307:";
_result = _key call server_hiveReadWrite;
_outcome = _result select 0;
if(_outcome == "PASS") then {
    _date = _result select 1;
    _datestr  = str(_date);
    diag_log ("RUNNING EVENT: " + (_event) + " on " + _datestr);
    [] execVM "\z\addons\dayz_server\adminevents\" + (_event) + ".sqf";
};
```

next in your mission.pbo 
go to your custom compiles and add the following
```SQF
if (isServer) then {
"PVDZE_adminWAI" addPublicVariableEventHandler {(_this select 1) spawn server_adminWAI};
"PVDZE_adminWAIminor" addPublicVariableEventHandler {(_this select 1) spawn server_adminWAIminor};
"PVDZE_adminEvent" addPublicVariableEventHandler {(_this select 1) spawn server_adminEvent};
};
```

in admintools\AdminToolsMain.sqf (you may need to edit this section  to suit your needs)
```
AdminMenu =
[
["",true],
	["Admin Mode (F4 for options)",[],"", -5,[["expression",format[_EXECscript1,"AdminMode\adminMode.sqf"]]],"1","1"],
	["Point to Repair Vehicle(Perm)",[],"", -5,[["expression", format[_EXECscript1,"PointToRepairPERM.sqf"]]], "1", "1"],
	["Point to Delete Vehicle(Perm)",[],"", -5,[["expression",format[_EXECscript1,"DatabaseRemove.sqf"]]],"1","1"],
	["Spectate player (F6 to cancel)",[],"", -5,[["expression", format[_EXECscript1,"spectate.sqf"]]], "1", "1"],
	["Gcam Spectate (SPACE to cancel)",[],"", -5,[["expression", format[_EXECscript7,"gcam.sqf"]]], "1", "1"],
	["Admin Events",[],"#USER:EventMenu", -5, [["expression", ""]], "1", "1"],
	["WAI Missions (Debug)",[],"#USER:WAIMenu", -5, [["expression", ""]], "1", "1"],
	["WAI Minor Missions (Debug)",[],"#USER:WAIMinorMenu", -5, [["expression", ""]], "1", "1"],
	["Zombie Shield",[],"", -5,[["expression",format[_EXECscript1,"zombieshield.sqf"]]],"1","1"],
	["Heal Players",[],"", -5, [["expression", format[_EXECscript1,"healp.sqf"]]], "1", "1"],	
	["Teleport Menu >>",[],"#USER:TeleportMenu", -5, [["expression", ""]], "1", "1"],
	["Humanity Menu >>",[],"#USER:HumanityMenu", -5, [["expression", ""]], "1", "1"],
	["", [], "", -5,[["expression", ""]], "1", "0"],
		["Main Menu", [20], "#USER:epochmenustart", -5, [["expression", ""]], "1", "1"]
];
EventMenu = 
[ // note: these are the events I have created, but this will provide an example of how to call them in
["",true],
	["Race: Kamenka - Zeleno", [], "", -5, [["expression", '["Race01"] call EventCall']], "1", "1"],
	["Race: Grozovoy Pass Canyon", [], "", -5, [["expression", '["Race02"] call EventCall']], "1", "1"],
	["", [], "", -5,[["expression", ""]], "1", "0"],
	["Vybor Briefcase Event", [], "", -5, [["expression", '["brief_vybor"] call EventCall']], "1", "1"],
	["Chaos in Cherno", [], "", -5, [["expression", '["chaos_cherno"] call EventCall']], "1", "1"],
	["Solnichniy Slaughter", [], "", -5, [["expression", '["solnich_event"] call EventCall']], "1", "1"],
	["Stadium Deathmatch", [], "", -5, [["expression", '["stad_event"] call EventCall']], "1", "1"],
	["", [], "", -5,[["expression", ""]], "1", "0"],
	["Event Cleanup", [], "", -5, [["expression", '["cleanup"] call EventCall']], "1", "1"],
		["Main Menu", [12], "#USER:epochmenustart", -5, [["expression", ""]], "1", "1"]
];

WAIMenu = 
[
["",true],
	["Russian Outpost", [], "", -5, [["expression", '["rusBase"] call WAICall']], "1", "1"],
	["BOS Mil Vehicle", [], "", -5, [["expression", '["bosMilVeh"] call WAICall']], "1", "1"],
	["Jewel Heist", [], "", -5, [["expression", '["jewelheist"] call WAICall']], "1", "1"],
	["City Under Siege", [], "", -5, [["expression", '["siege"] call WAICall']], "1", "1"],
	["Vodnik BPPU", [], "", -5, [["expression", '["milVeh"] call WAICall']], "1", "1"],
	["Military Camp", [], "", -5, [["expression", '["milCamp"] call WAICall']], "1", "1"],
	["Bandit Base", [], "", -5, [["expression", '["bandit_base"] call WAICall']], "1", "1"],
	["Osama's Compound", [], "", -5, [["expression", '["mayors_mansion"] call WAICall']], "1", "1"],
	["MV22 Osprey", [], "", -5, [["expression", '["MV22"] call WAICall']], "1", "1"],
	["Disabled Mil Chopper", [], "", -5, [["expression", '["disabled_milchopper"] call WAICall']], "1", "1"],
	["Ikea Convoy", [], "", -5, [["expression", '["convoy"] call WAICall']], "1", "1"],
	["", [], "", -5,[["expression", ""]], "1", "0"],
		["Main Menu", [12], "#USER:epochmenustart", -5, [["expression", ""]], "1", "1"]
];

WAIMinorMenu = 
[
["",true],
	["Civ Vehicle", [], "", -5, [["expression", '["civVeh"] call WAICallMinor']], "1", "1"],
	["Vehicle Ammo", [], "", -5, [["expression", '["vehAmmo"] call WAICallMinor']], "1", "1"],
	["M2 Hummer", [], "", -5, [["expression", '["m2hummer"] call WAICallMinor']], "1", "1"],
	["Bandit Squad", [], "", -5, [["expression", '["banditsquad"] call WAICallMinor']], "1", "1"],
	["Stash House", [], "", -5, [["expression", '["stashHouse"] call WAICallMinor']], "1", "1"],
	["", [], "", -5,[["expression", ""]], "1", "0"],
		["Main Menu", [12], "#USER:epochmenustart", -5, [["expression", ""]], "1", "1"]
];

EventCall = 
{
	do_event = {
		PVDZE_adminEvent = [_this select 0];
		publicVariableServer "PVDZE_adminEvent";
	};
	call do_event;
};

WAICall = 
{
	do_wai = {
		PVDZE_adminWAI = [_this select 0];
		publicVariableServer "PVDZE_adminWAI";
	};
	call do_wai;
};
WAICallMinor = 
{
	do_wai_minor = {
		PVDZE_adminWAIminor = [_this select 0];
		publicVariableServer "PVDZE_adminWAIminor";
	};
	call do_wai_minor;
};
```
