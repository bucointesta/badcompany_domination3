// by Xeno
#define THIS_FILE "fn_hcexecsm.sqf"
#include "..\..\x_setup.sqf"

d_x_sm_rem_ar = [];
d_x_sm_vec_rem_ar = [];
d_sm_resolved = false;
d_sm_winner = 0;
execVM (param [0]);
(param [1]) spawn {
	sleep 7.012;
	[_this, d_x_sm_pos, d_x_sm_type] remoteExecCall ["d_fnc_s_sm_up", 2];
};