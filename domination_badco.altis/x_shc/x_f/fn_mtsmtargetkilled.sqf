// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_mtsmtargetkilled.sqf"
#include "..\..\x_setup.sqf"

__TRACE_1("","_this")

d_side_main_done = true;
if (d_IS_HC_CLIENT) then {
	[missionNamespace, ["d_side_main_done", true]] remoteExecCall ["setVariable", 2];
};
private _type = param [count _this - 1];
[42, (["sec_over", _type] select (side (group (param [1])) == d_side_player)) call d_fnc_GetSMTargetMessage] remoteExecCall ["d_fnc_DoKBMsg", 2];
if (d_database_found) then {
	private _killer = param [1];
	if (!isNil "_killer" && {!isNull _killer && {isPlayer _killer}}) then {
		[_killer, 3] remoteExecCall ["d_fnc_addppoints", 2];
	};
};
d_sec_kind = 0; publicVariable "d_sec_kind";