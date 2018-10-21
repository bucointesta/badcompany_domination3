// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_call_cas.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

if !(d_cas_available) exitWith {
	[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_1712");
};

if (d_with_ranked && {score player < d_ranked_a select 22}) exitWith {
	[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_1713", score player, d_ranked_a select 22];
};

private _lt = laserTarget player;

__TRACE_1("","_lt")

if (isNil "_lt" || {isNull _lt}) exitWith {
	// laser target not valid
};

private _pos_lt = getPos _lt;
__TRACE_1("","_pos_lt")

#ifdef __DEBUG__
_arrow = "Sign_Arrow_Large_F" createVehicleLocal [0,0,0];
_arrow setPos _pos_lt;
#endif

if (player distance2D _pos_lt < 10) exitWith {
	systemChat (localize "STR_DOM_MISSIONSTRING_1529");
};

[_pos_lt, str player, 2] remoteExec ["d_fnc_moduleCAS", 2];
