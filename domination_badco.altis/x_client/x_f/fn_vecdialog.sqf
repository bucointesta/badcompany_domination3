// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_vecdialog.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

params ["_vec"];

__TRACE_1("","_this")

if (!alive _vec) exitWith {
	__TRACE_1("not alive","_vec")
};

d_curvec_dialog = _vec;
d_curcaller_dialog = _this select 1;

if ((_vec getVariable ["d_vec_type", ""] == "MHQ") && {(count (allPlayers - entities "HeadlessClient_F")) >= 25}) exitWith {
	hint "MHQs are disabled when player count is above 25!";
};

createDialog "d_VecDialog";
