// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_createdroppedbox.sqf"
#include "..\..\x_setup.sqf"

__TRACE_1("","_this")

params ["_box_pos"];
private _mname = format ["d_bm_%1", _box_pos];
d_ammo_boxes pushBack [_box_pos, _mname];
publicVariable "d_ammo_boxes";
[_mname, _box_pos, "ICON", "ColorBlue", [0.5, 0.5], localize "STR_DOM_MISSIONSTRING_523", 0, d_dropped_box_marker] call d_fnc_CreateMarkerGlobal;

_this remoteExecCall ["d_fnc_create_boxNet", [0, -2] select isDedicated];
