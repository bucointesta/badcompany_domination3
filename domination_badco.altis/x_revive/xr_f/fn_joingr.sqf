// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_joingr.sqf"
#include "..\..\x_macros.sqf"

__TRACE("joingr")
if (player getVariable "xr_isleader") then {
	[xr_pl_group, player] remoteExecCall ["selectLeader", groupOwner xr_pl_group];
};
player setVariable ["xr_isleader", false];