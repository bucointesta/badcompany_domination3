// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_remabox.sqf"
#include "..\..\x_setup.sqf"

params ["_bpos"];
if (_bpos isEqualType 1) exitWith {};
{
	if ((_x select 0) distance2D _bpos < 5) exitWith {
		deleteMarker (_x select 1);
		d_ammo_boxes deleteAt _forEachIndex;
	};
} forEach d_ammo_boxes;
publicVariable "d_ammo_boxes";

_this remoteExecCall ["d_fnc_RemABoxC", [0, -2] select isDedicated];
