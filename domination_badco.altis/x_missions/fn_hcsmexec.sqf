// by Xeno
#define THIS_FILE "fn_hcsmexec.sqf"
#include "..\x_setup.sqf"

execVM format ["x_missions\ma3a\%2%1.sqf", param [0], param [1]];
sleep 7.012;
[param [0], d_x_sm_pos, d_x_sm_type] remoteExecCall ["d_fnc_s_sm_up", 2];
