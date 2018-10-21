// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_addkillednormal.sqf"
#include "..\x_setup.sqf"

__TRACE_1("","_this")

_this addEventhandler ["killed", {_this call d_fnc_KilledSMTargetNormal}];