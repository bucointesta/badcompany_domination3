// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_nearplayercheck.sqf"
#include "..\..\x_macros.sqf"

private _xr_near_players = [];
{
	if (!isNull _x) then {
		_xr_near_players append (crew _x);
	};
	false
} count (player nearEntities 50);

xr_near_players = _xr_near_players select {isPlayer _x && {_x != player && {!(_x getVariable ["xr_pluncon", false]) && {side (group _x) == xr_side_pl}}}};

__TRACE_1("","xr_near_players")
if !(xr_near_players isEqualTo []) then {
	{
		player remoteExecCall ["xr_fnc_announcenear", _x];
		false
	} count xr_near_players;
};
xr_next_pl_near_check = time + 60;

if (_this) then {
	call xr_fnc_nearplayercheckui;
};