// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_tjetservice.sqf"
#include "..\..\x_setup.sqf"

if ("Plane" countType _this == 0) exitWith {false};

params ["_plane"];

if (!isTouchingGround _plane) exitWith {
	false
};
if ((speed _plane) > 5) exitWith {
	false
};
if (isEngineOn _plane) exitWith {
	false
};

true
