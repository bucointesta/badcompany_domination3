// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_makepatrolwpx.sqf"
#include "..\..\x_setup.sqf"

// supports also patrols in square areas, including angle
__TRACE_1("","_this")
params ["_grp", "_start_pos", "_wp_array", ["_timeout", []], ["_wpstatements", ""], ["_mindist", 2]];
if (_start_pos isEqualType objNull) then {_start_pos = getPosATL _start_pos};
if (!(_start_pos isEqualType []) || {_start_pos isEqualTo [] || {isNull _grp}}) exitWith {};
__TRACE_3("","_grp","_start_pos","_wp_array")
if (_wp_array isEqualType objNull) then {_wp_array = getPosATL _wp_array};
if !(_wp_array isEqualType []) exitWith {};
_grp setBehaviour "SAFE";
private _cur_pos = _start_pos;
private _no_pos_found = false;
for "_i" from 0 to (2 + (floor (random 3))) do {
	private _wp_pos = switch (count _wp_array) do {
		case 2: {[_wp_array select 0, _wp_array select 1, _mindist] call d_fnc_GetRanPointCircle};
		case 4: {[_wp_array select 0, _wp_array select 1, _wp_array select 2, _wp_array select 3] call d_fnc_GetRanPointSquare};
	};
	if (_wp_pos isEqualTo []) exitWith {_no_pos_found = true};
	private _counter = 0;
	while {_wp_pos distance2D _cur_pos < ((_wp_array select 1)/6) && {_counter < 100}} do {
		_wp_pos = switch (count _wp_array) do {
			case 2: {[_wp_array select 0, _wp_array select 1, _mindist] call d_fnc_GetRanPointCircle};
			case 4: {[_wp_array select 0, _wp_array select 1, _wp_array select 2, _wp_array select 3] call d_fnc_GetRanPointSquare};
		};
		if (_wp_pos isEqualTo []) exitWith {};
		_counter = _counter + 1;
	};
	if (_wp_pos isEqualTo []) exitWith {_no_pos_found = true};
	_wp_pos = _wp_pos call d_fnc_WorldBoundsCheck;
	_cur_pos = _wp_pos;
	private _wp = _grp addWaypoint [_wp_pos, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointCompletionRadius (0 + random 10);
	if !(_timeout isEqualTo []) then {
		_wp setWaypointTimeout _timeout;
	};
	
	if (_i == 0) then {
		_wp setWaypointSpeed "LIMITED";
		_wp setWaypointFormation "STAG COLUMN";
	};
	if (_wpstatements != "") then {
		_wp setWaypointStatements ["TRUE", _wpstatements];
	};
};
private "_wp1";
if (_no_pos_found) exitWith {
	_wp1 = _grp addWaypoint [_start_pos, 0];
	_wp1 setWaypointType "SAD";
};
_wp1 = _grp addWaypoint [_start_pos, 0];
_wp1 setWaypointType "MOVE";
_wp1 setWaypointCompletionRadius (10 + random 10);
if !(_timeout isEqualTo []) then {
	_wp1 setWaypointTimeout _timeout;
};
if (_wpstatements != "") then {
	_wp1 setWaypointStatements ["TRUE", _wpstatements];
};
private _wp = _grp addWaypoint [_start_pos, 0];
_wp setWaypointType "CYCLE";
_wp setWaypointCompletionRadius (10 + random 10);