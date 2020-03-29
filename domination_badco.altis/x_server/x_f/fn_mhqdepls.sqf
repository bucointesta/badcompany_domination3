// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_mhqdepls.sqf"
#include "..\..\x_setup.sqf"

if (local (_this select 0)) then {
	if (_this select 1) then {
		(_this select 0) setVehicleLock "LOCKED";
	} else {
		(_this select 0) setVehicleLock "UNLOCKED";
	};
};
if (_this select 1) then {
	(_this select 0) call d_fnc_createMHQEnemyTeleTrig;
} else {
	(_this select 0) call d_fnc_removeMHQEnemyTeleTrig;
};

_this remoteExecCall ["d_fnc_mhqdeplNet", [0, -2] select isDedicated];
