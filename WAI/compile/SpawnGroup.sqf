private ["_RPG","_mission","_aipack","_aicskill","_position","_unitnumber","_skill","_gun","_mags","_backpack","_skin","_gear","_aiweapon","_aigear","_aiskin","_skillarray","_unitGroup","_weapon","_magazine","_weaponandmag","_gearmagazines","_geartools","_unit","_unitArray"];
// Arguments
_position = _this select 0;
_unitnumber = _this select 1;
_skill = _this select 2;
_gun = _this select 3;
_mags = _this select 4;
_backpack = _this select 5;
_skin = _this select 6;
_gear = _this select 7;
_mission = _this select 8;
_unitArray = _this select 9; 

_RPG = 1;
_aiweapon = [];
_aigear = [];
_aiskin = "";
_aicskill = [];
_aipack = "";
_skillarray = ["aimingAccuracy","aimingShake","aimingSpeed","endurance","spotDistance","spotTime","courage","reloadSpeed","commanding","general"];
_unitGroup = createGroup east;

if (!isServer) exitWith {};

for "_x" from 1 to _unitnumber do 
	{
		switch (_gun) do
			{
				case 0 : {_aiweapon = ai_wep0;};
				case 1 : {_aiweapon = ai_wep1;};
				case 2 : {_aiweapon = ai_wep2;};
				case 3 : {_aiweapon = ai_wep3;};
				case 4 : {_aiweapon = ai_wep4;};
				case "Random" : {_aiweapon = ai_wep_random call BIS_fnc_selectRandom;};
			};
			
		_weaponandmag = _aiweapon call BIS_fnc_selectRandom;
		_weapon = _weaponandmag select 0;
		_magazine = _weaponandmag select 1;
		
		switch (_gear) do 
			{
				case 0 : {_aigear = ai_gear0;};
				case 1 : {_aigear = ai_gear1;};
				case 2 : {_aigear = ai_gear2;};
				case 3 : {_aigear = ai_gear3;};
				case 4 : {_aigear = ai_gear4;};
				case "Random" : {_aigear = ai_gear_random call BIS_fnc_selectRandom;};
			};
			
		_gearmagazines = _aigear select 0;
		_geartools = _aigear select 1;
		
		if (_skin == "") then
			{
				_aiskin = ai_skin call BIS_fnc_selectRandom;
			}
				else
			{
				_aiskin = _skin
			};
			
		_unit = _unitGroup createUnit [_aiskin, [(_position select 0),(_position select 1),(_position select 2)], [], 10, "PRIVATE"];
		[_unit] joinSilent _unitGroup;
		
		if (_backpack == "") then
			{
				_aipack = ai_packs call BIS_fnc_selectRandom;
			}
				else
			{
				_aipack = _backpack
			};
			
		_unit enableAI "TARGET";
		_unit enableAI "AUTOTARGET";
		_unit enableAI "MOVE";
		_unit enableAI "ANIM";
		_unit enableAI "FSM";
		_unit setCombatMode ai_combatmode;
		_unit setBehaviour ai_behaviour;
		removeAllWeapons _unit;
		removeAllItems _unit;

		if (sunOrMoon != 1) then
			{
				_unit addweapon "NVGoggles";
			};
		
		_unit addweapon _weapon;
		
		for "_i" from 1 to _mags do
			{
				_unit addMagazine _magazine;
			};
			
		if ((_x == 1) && (_RPG > 0)) then
			{
				_unit addweapon "RPG7V"; 
				_unit addmagazine "PG7VR"; 
				_unit addmagazine "PG7VR";
			}
				else
			{
				_unit addBackpack _aipack;	
			};
			
		{_unit addMagazine _x} forEach _gearmagazines;
		{_unit addweapon _x} forEach _geartools;

		call
			{
				if(_skill == "easy") exitWith { _aicskill = ai_skill_easy; };
				if(_skill == "normal") exitWith { _aicskill = ai_skill_normal; };
				if(_skill == "hard") exitWith { _aicskill = ai_skill_hard; };
				if(_skill == "extreme") exitWith { _aicskill = ai_skill_extreme; };
				if(_skill == "random") exitWith { _aicskill = ai_skill_random call BIS_fnc_selectRandom; };
				_aicskill = ai_skill_random call BIS_fnc_selectRandom;
			};
			
		{_unit setSkill [(_x select 0),(_x select 1)]} count _aicskill;

		ai_ground_units = (ai_ground_units + 1);
		_unit addEventHandler ["Killed",{[_this select 0, _this select 1, "ground"] call on_kill;}];
		
		if (_mission == "major") then 
			{
				_unit setVariable ["majorclean", "ground"];
			};
			
		if (_mission == "minor") then
			{
				_unit setVariable ["minorclean", "ground"];
			};
			
		if (_mission == "compound") then
			{
				_unit setVariable ["compoundclean", "ground"];
			};
			
	};

// load the unit groups into a passed array name so they can be cleaned up later
call compile format["%1 = %1 + (units _unitGroup);",_unitArray];

_unitGroup selectLeader ((units _unitGroup) select 0);
/** FUNCTION DISABLED DUE TO PROBLEMS WITH CACHING 
if (_mission != "compound") then 
	{
		[_unitGroup] spawn cache_units;
	};
**/	
[_unitGroup, _position, _mission] call group_waypoints;

diag_log format ["WAI: Spawned a group of %1 Bandits at %2 - AI Type: %3",_unitnumber,_position,_mission];