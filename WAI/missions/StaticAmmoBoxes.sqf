/* 20% chance of spawning two static ammo crates at different spots around the map */

private ["_randomNumber", "_arrayOfBoxTypes", "_box1Type", "_box2Type", "_arrayOfBoxes", "_box1Contents", "_box2Contents", "_position1", "_position2", "_gridPos1", "_gridPos2", "_box1", "_box2"];

_randomNumber = floor(random 5);

if (_randomNumber == 3) then 
	{
		_arrayOfBoxTypes = ["USOrdnanceBox","MedBox0","FoodBox0","BAF_BasicWeapons","USSpecialWeaponsBox","USSpecialWeapons_EP1","USVehicleBox","RUSpecialWeaponsBox","RUVehicleBox","BAF_VehicleBox"];
		_box1Type = _arrayOfBoxTypes call BIS_fnc_selectRandom;
		_box2Type = _arrayOfBoxTypes call BIS_fnc_selectRandom;
		
		_arrayOfBoxes = [Medical_Supply_Box,Sniper_Gun_Box,Extra_Large_Gun_Box,Large_Gun_Box,Small_Gun_Box,easyMissionBox,easyGunCrate,Medical_Supply_Box,Food_Box,Food_Box];
		_box1Contents = _arrayOfBoxes call BIS_fnc_selectRandom;
		_box2Contents = _arrayOfBoxes call BIS_fnc_selectRandom;
		
		_position1 = call WAI_findPos;
		_position2 = call WAI_findPos;
		_gridPos1 = mapGridPosition _position1;
		_gridPos2 = mapGridPosition _position2;
		
		sleep 60;
		
		_box1 = createVehicle [_box1Type,_position1, [], 0, "CAN_COLLIDE"];
		[_box1] call _box1Contents;
		[_box1] call markCrates;
		
		sleep 1;
		
		_box2 = createVehicle [_box2Type,_position2, [], 0, "CAN_COLLIDE"];
		[_box2] call _box2Contents;	
		[_box2] call markCrates;
		
		sleep 1;
		
		diag_log format["WAI: Spawned Static crate 1 @ Grid Pos: %1 ",_gridPos1];		
		diag_log format["WAI: Spawned Static crate 2 @ Grid Pos: %1 ",_gridPos2];
	};