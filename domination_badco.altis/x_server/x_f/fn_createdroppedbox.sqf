// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_createdroppedbox.sqf"
#include "..\..\x_setup.sqf"

__TRACE_1("","_this")

params ["_box_pos","_unit"];
private _mname = format ["d_bm_%1", _box_pos];
/*
#ifndef __TT__
d_ammo_boxes pushBack [_box_pos, _mname];
#else
d_ammo_boxes pushBack [_box_pos, _mname, _this select 2];
#endif
publicVariable "d_ammo_boxes";

[_mname, _box_pos, "ICON", "ColorBlue", [0.5, 0.5], localize "STR_DOM_MISSIONSTRING_523", 0, d_dropped_box_marker] call d_fnc_CreateMarkerGlobal;
#ifdef __TT__
_mname remoteExecCall ["deleteMarkerLocal", [blufor, opfor] select (_this select 2 == blufor)];
#endif
*/

//_this remoteExecCall ["d_fnc_create_boxNet", 2];

//changed to create actual global box
_box = d_the_box createVehicle [0,0,1000];
_box setpos _box_pos;
_box setDamage 0.9;
_markerName = createMarker [_mname, _box_pos];
_markerName setMarkerShape "ICON";
_markerName setMarkerType "hd_dot";
_markerName setMarkerColor "ColorBlue";
_markerName setMarkerText "Ammo box";
_box setVariable ["boxMarker",_markerName,true];
_box addEventHandler ["Killed",{

	deletemarker ((_this select 0) getVariable ["boxMarker",""]);
	d_num_ammo_boxes = d_num_ammo_boxes - 1;
	publicVariable "d_num_ammo_boxes";

}];