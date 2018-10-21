// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_cgraa.sqf"
#include "..\..\x_setup.sqf"

for "_io" from 1 to 20 do {
	private _mmm = format ["d_base_anti_air%1", _io];
	if (markerPos _mmm isEqualTo [0,0,0]) exitWith {};
	
	private _grp = [param [0]] call d_fnc_creategroup;
	private _av = (([1, markerPos _mmm, param [1], _grp, markerDir _mmm] call d_fnc_makevgroup) select 0) select 0;
	_grp deleteGroupWhenEmpty true;
	_av lock true;
	if (!isNull (driver _av)) then {
		_av lockDriver true;
		_av deleteVehicleCrew (driver _av);
		_av lock 2;
	};
};