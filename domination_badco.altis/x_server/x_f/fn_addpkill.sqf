// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_addpkill.sqf"
#include "..\..\x_setup.sqf"

// 1 = radio tower

private _t_ps = d_player_store getVariable ((getPlayerUID (_this select 0)) + "_rvals");
if (!isNil "_t_ps") then {
	_t_ps set [_this select 1, (_t_ps select (_this select 1)) + 1];
};