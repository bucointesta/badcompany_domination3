// by Xeno
#define THIS_FILE "fn_s_b_client.sqf"
#include "..\..\x_setup.sqf"

d_searchbody setVariable ["d_search_id", d_searchbody addAction [localize "STR_DOM_MISSIONSTRING_518", {_this spawn d_fnc_searchbody}]];
