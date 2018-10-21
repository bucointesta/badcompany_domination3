// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_mhqmsg.sqf"
#include "..\..\x_setup.sqf"

private _mhqmsg = (param [0]) getVariable "d_vec_is_mhq";

if (!isNil "_mhqmsg") then {
	[47, _mhqmsg select 0] call d_fnc_DoKBMsg;
};