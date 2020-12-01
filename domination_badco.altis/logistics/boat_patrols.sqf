#include "..\x_setup.sqf"

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
		(call d_fnc_PlayersNumber) > 52		
	};
	
	#ifdef __OWN_SIDE_BLUFOR__
		_boat = ([_initPos, 0, _vehType, east] call BIS_fnc_spawnVehicle) select 0;
	#else
		_boat = ([_initPos, 0, _vehType, west] call BIS_fnc_spawnVehicle) select 0;
	#endif
		
	_grp = group _boat;
	_units = units _grp;
		
	{
		_x call AI_setupUnitCustomLoadout;	
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
