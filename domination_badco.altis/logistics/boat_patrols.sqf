#include "..\x_setup.sqf"

_vestType = "V_TacChestrig_oli_F";
_uniformType = "rhs_uniform_gorka_r_g";
_helmetType = "rhs_ssh68";

scriptName "Boat_Patrol";

waitUntil {	
	time > 1
};

_grp = _this select 0;

_wpList = [];
{
	_wpList pushBack [waypointPosition _x, waypointType _x];
} foreach waypoints _grp;

_veh = vehicle leader _grp;
_vehType = typeof _veh;
_initPos = getpos _veh;
_initPos set [2,0];
{
	_veh deleteVehicleCrew _x;
} foreach crew _veh;
deleteVehicle _veh;

waitUntil {	
	sleep 5;	
	time > 60
};

while {true} do {

	waitUntil {
		sleep 20;		
		(call d_fnc_PlayersNumber) > 19		
	};
	
	#ifdef __OWN_SIDE_BLUFOR__
		_boat = ([_initPos, 0, _vehType, east] call BIS_fnc_spawnVehicle) select 0;
	#else
		_boat = ([_initPos, 0, _vehType, west] call BIS_fnc_spawnVehicle) select 0;
	#endif
		
	_grp = group _boat;
	_units = units _grp;
		
	{
		if (_vestType != "") then {
			_vestItems = vestItems _x;
			_x addvest _vestType;			
			_vc = vestContainer _x;
			{_vc addItemCargoGlobal [_x,1];} foreach _vestItems;
		};
		if (_helmetType != "") then {
			_x addheadgear _helmetType;
			removeAllAssignedItems _x;
			removeGoggles _x;
		};
		if (_uniformType != "") then {
			_uniformItems = uniformItems _x;
			_x addUniform _uniformType;			
			_vc = uniformContainer _x;
			{_vc addItemCargoGlobal [_x,1];} foreach _uniformItems;
		};		
	} foreach _units;

	{
		_wp = _grp addWaypoint [_x select 0, 0];
		_wp setWaypointType (_x select 1);
		_wp setWaypointSpeed "FULL";
	} foreach _wpList;
	
	_grp setCombatMode "RED";
	
	waitUntil {
		sleep 20;		
		({alive _x} count _units) == 0
	};
	
	{
		if ((vehicle _x) != _x) then {
			(vehicle _x) deleteVehicleCrew _x;
		} else {
			deleteVehicle _x;
		};
	} foreach _units;
	deleteVehicle _boat;	
	deleteGroup _grp;
	
	sleep 1800;
	
};
