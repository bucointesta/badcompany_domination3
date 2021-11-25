// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_createplayerbike.sqf"
#include "..\..\x_setup.sqf"

params ["_unit", "_vtype", "_b_mode"];
private _pos = getPosATL _unit;
private _vec = objNull;

// Hunter: could be land or water vehicle!
private _npos = _pos findEmptyPosition [0, 50, _vtype];
if !(_npos isEqualTo []) then {_pos = _npos};
_vec = createVehicle [_vtype, _pos, [], 0, "NONE"];

#ifndef __RHS__
	if (_vtype iskindof "B_LSV_01_unarmed_F") then {
		[_vec, ["Sand",1],["HideDoor1",1,"HideDoor2",1,"HideDoor3",1,"HideDoor4",1]] call BIS_fnc_initVehicle;
	};
#endif

_vec setDir direction _unit;
_vec remoteExecCall ["d_fnc_stocbike", _unit];
if (_b_mode != 1) then {
	//_vec setVariable ["d_end_time", _this select 3];
	_vec setVariable ["d_end_time", time + 1200];
	d_player_created pushBack _vec;
} else {
	private _ar = _unit getVariable ["d_all_p_vecs_s", []];
	if !(_ar isEqualTo []) then {
		_ar = _ar - [objNull];
	};
	_ar pushBack _vec;
	_unit getVariable ["d_all_p_vecs_s", _ar];
};
addToRemainsCollector [_vec];