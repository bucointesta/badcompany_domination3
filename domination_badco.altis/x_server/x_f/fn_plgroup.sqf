// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_plgroup.sqf"
#include "..\..\x_setup.sqf"

private _idx = (param [0]) getVariable "d_pgidx";
if (isNil "_idx") then {
	d_player_groups pushBack (param [0]);
	_idx = d_player_groups_lead pushBack (param [1]);
	(param [0]) setVariable ["d_pgidx", _idx];
} else {
	d_player_groups_lead set [_idx, param [1]];
};