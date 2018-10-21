// by Xeno
#define THIS_FILE "fn_rem_sb_id.sqf"
#include "..\..\x_setup.sqf"

if (!isNil {d_searchbody getVariable "d_search_id"}) then {
	d_searchbody removeAction (d_searchbody getVariable "d_search_id");
};