// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_cgraa.sqf"
#include "..\..\x_setup.sqf"

base_defense_vehicles = [];
{
	private _grp = [_this select 0] call d_fnc_creategroup;
	if (d_with_ai) then {
		[_grp, ["d_do_not_delete", true]] remoteExecCall ["setVariable", 2];
	};
	(([1, markerPos _x, _this select 1, _grp, markerDir _x, false, true] call d_fnc_makevgroup) # 0) params ["_av"];
	_grp deleteGroupWhenEmpty true;
	_av lock true;
	base_defense_vehicles pushBack _av;
	if (!isNull (driver _av)) then {
		_av lockDriver true;
		_av deleteVehicleCrew (driver _av);
		_av lock 2;
	};
} forEach (allMapMarkers select {_x select [0, 15] == "d_base_anti_air"});

if ((count base_defense_vehicles) < 1) exitWith {};

[] spawn {

	scriptname "Rearm_base_defenses";
	
	sleep 300;
	
	while {(count base_defense_vehicles) > 0} do {
			
		{
			
			if (({alive _x} count crew _x) > 0) then {
			
				_x setVehicleAmmoDef 1;
				
			} else {
			
				base_defense_vehicles = base_defense_vehicles - [_x];
			
			};
		
		} foreach base_defense_vehicles;
		
		sleep 300;
	
	};

};
