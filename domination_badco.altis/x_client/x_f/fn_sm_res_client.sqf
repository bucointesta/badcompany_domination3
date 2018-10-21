// by Xeno
#define THIS_FILE "fn_sm_res_client.sqf"
#include "..\..\x_setup.sqf"

if (!hasInterface) exitWith {};

__TRACE_1("","_this")
playSound "d_Notebook";
d_sm_winner = param [0];
if (d_with_ranked) then {
	d_sm_running = false
};
(param [1]) spawn d_fnc_sidemissionwinner