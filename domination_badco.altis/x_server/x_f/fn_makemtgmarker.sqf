// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_makemtgmarker.sqf"
#include "..\..\x_setup.sqf"

[format ["d_%1_dommtm", d_cur_tgt_name], d_cur_tgt_pos, "ELLIPSE", d_e_marker_color, [d_cur_target_radius, d_cur_target_radius]] remoteExecCall ["d_fnc_CreateMarkerGlobal", 2];
[format ["d_%1_dommtm", d_cur_tgt_name], d_e_marker_color_alpha] remoteExecCall ["setMarkerAlpha", 2];