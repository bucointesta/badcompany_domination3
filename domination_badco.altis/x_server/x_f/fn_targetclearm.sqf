// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_targetclearm.sqf"
#include "..\..\x_setup.sqf"

d_target_clear = true; publicVariable "d_target_clear";
["d_" + d_cur_tgt_name + "_dommtm", "ColorGreen"] remoteExecCall ["setMarkerColor", 2];

if (d_bonus_vec_type in [2, 3]) then {
	"" remoteExec ["d_fnc_target_clear_client", [0, -2] select isDedicated];
};
d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"Captured",["1","",d_cur_tgt_name,[d_cur_tgt_name]],d_kbtel_chan];
