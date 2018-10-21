// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_addkilledehsm.sqf"
#include "..\x_setup.sqf"
__TRACE_1("","_this")


_this addEventHandler ["killed", {
	__TRACE_1("killed","_this")
	d_sm_winner = 2;
	__TRACE_1("","d_sm_winner")
	d_sm_resolved = true;
	if (d_IS_HC_CLIENT) then {
		[missionNamespace, ["d_sm_winner", d_sm_winner]] remoteExecCall ["setVariable", 2];
		[missionNamespace, ["d_sm_resolved", true]] remoteExecCall ["setVariable", 2];
	};
}];
_this addEventHandler ["handleDamage", {_this call d_fnc_CheckSMShotHD}];
d_x_sm_vec_rem_ar pushBack _this;