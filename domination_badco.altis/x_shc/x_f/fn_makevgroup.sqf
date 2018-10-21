// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_makevgroup.sqf"
#include "..\..\x_setup.sqf"

params ["_numvecs", "_pos", "_vname", "_grp", "_dir"];
private _the_vecs = [];
private _crews = [];
private _npos = _pos;

__TRACE_1("","_this")

private _grpskill = (d_skill_array select 0) + (random (d_skill_array select 1));

private _toupvname = toUpper _vname;
_the_vecs resize _numvecs;
private _nnvnum = _numvecs - 1;
for "_n" from 0 to _nnvnum do {
	__TRACE_1("","_npos")
	private _vec_ar = [_npos, [floor random 360, _dir] select (_dir != -1.111), _vname, _grp] call d_fnc_spawnVehicle;
	private _vec = _vec_ar select 0;
	_crews append (_vec_ar select 1);
	
	_the_vecs set [_n, _vec];
	if (_n < _nnvnum) then {
		_npos = _vec modelToWorld [0, -12, 0];
	};
	
	if !(_toupvname in d_heli_wreck_lift_types) then {
		_vec addEventHandler ["killed", {_this call d_fnc_handleDeadVec}];
		addToRemainsCollector [_vec];
	};
	private _is_locked = false;
	if (d_LockArmored == 0 && {_vec isKindOf "Tank"}) then {
		_vec lock true;
		_is_locked = true;
	} else {
		if (d_LockCars == 0 && {_vec isKindOf "Wheeled_APC" || {_vec isKindOf "Wheeled_APC_F" || {_vec isKindOf "Car"}}}) then {
			_vec lock true;
			_is_locked = true;
		} else {
			if (d_LockAir == 0 && {_vec isKindOf "Air"}) then {
				_vec lock true;
				_is_locked = true;
			};
		};
	};
};
(leader _grp) setSkill _grpskill;
[_the_vecs, _crews]