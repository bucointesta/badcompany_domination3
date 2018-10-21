// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_killedsmtargetnormal.sqf"
#include "..\x_setup.sqf"

__TRACE_1("","_this")

params ["_dvec", "_killer"];
if !(_dvec isKindOf "CAManBase") then {
	addToRemainsCollector [_dvec];
};
if (!isNull _killer && {_killer != _dvec}) then {
	d_sm_winner = [-1, 2] select (side (group _killer) == d_side_player);
} else {
	d_sm_winner = -1;
};

_dvec removeAllEventHandlers "killed";
d_sm_resolved = true;
if (d_IS_HC_CLIENT) then {
	[missionNamespace, ["d_sm_winner", d_sm_winner]] remoteExecCall ["setVariable", 2];
	[missionNamespace, ["d_sm_resolved", true]] remoteExecCall ["setVariable", 2];
};
