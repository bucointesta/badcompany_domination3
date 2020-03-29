// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_tvecservice.sqf"
#include "..\..\x_setup.sqf"

if ("Ship" countType _this == 0) exitWith {
	__TRACE("No vec inside trigger")
	false
};
_veh = _this select 0;
if ((speed _veh) > 1.5) exitWith {
	false
};
if (isEngineOn _veh) exitWith {
	false
};
__TRACE("true")
true
