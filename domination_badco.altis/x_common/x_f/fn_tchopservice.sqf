// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_tchopservice.sqf"
#include "..\..\x_setup.sqf"

if ("Helicopter" countType _this == 0) exitWith {
	__TRACE("No heli inside trigger")
	false
};
_heli = _this select 0;
if (!isTouchingGround _heli) exitWith {
	__TRACE("Heli is not touching ground")
	false
};
if ((speed _heli) > 5) exitWith {
	false
};
if (isEngineOn _heli) exitWith {
	false
};
__TRACE("true")
true
