// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_makemgroup.sqf"
#include "..\..\x_setup.sqf"

params ["_pos", "_unitliste", "_grp", ["_mchelper", true]];

if (isNil "_unitliste") exitWith {
	diag_log ["Attention, _unitlist (param 2) is nil, returning []", "_pos", _pos, "_grp", _grp];
	[]
};

__TRACE_3("","_pos","_unitliste","_grp")
__TRACE_1("","_mchelper")

private _ret = [];
_ret resize (count _unitliste);
private _subskill = if (diag_fps > 29) then {
	(0.1 + (random 0.2))
} else {
	(0.12 + (random 0.04))
};

if (!_mchelper) then {
	private _nnpos = _pos findEmptyPosition [0, 30, _unitliste # 0];
	if !(_nnpos isEqualTo []) then {_pos = _nnpos};
};

{
	private _one_unit = _grp createUnit [_x, _pos, [], 10, "NONE"];
	
	if (Hz_customUnitLoadouts) then {
		_one_unit call AI_setupUnitCustomLoadout;
	};
	// Hunter: prevent taking damage from getting run over by other AI or falling off buildings...
	_one_unit addEventHandler ["HandleDamage",{
		_return = _this select 2;
		_source = _this select 3;
		_unit = _this select 0;		
		if (((_this select 4) == "") && {(isnull _source) || {((side _source) getFriend (side _unit)) >= 0.6}}) then {
			_return = 0;
		};
		_return 
	}];
	
	//if (d_with_dynsim == 1) then {
	if (_mchelper) then {
		_one_unit spawn d_fnc_mchelper;
	};
	//};
#ifdef __TT__
	_one_unit addEventHandler ["Killed", {[[15, 3, 2, 1], _this # 1, _this # 0] remoteExecCall ["d_fnc_AddKills", 2]}];
#endif
	if (d_with_ai && {d_with_ranked}) then {
		_one_unit addEventHandler ["Killed", {
			[1, _this select 1] remoteExecCall ["d_fnc_addkillsai", 2];
			(_this select 0) removeAllEventHandlers "Killed";
		}];
	};
	/*
	_one_unit setUnitAbility ((d_skill_array # 0) + (random (d_skill_array # 1)));
	_one_unit setSkill ["aimingAccuracy", _subskill];
	_one_unit setSkill ["spotTime", _subskill];
	*/
	_one_unit call AI_setSkill;
	_ret set [_forEachIndex, _one_unit];
	_one_unit call d_fnc_removenvgoggles_fak;
#ifdef __GROUPDEBUG__
	// does not subtract if a unit dies!
	if (side _grp == d_side_enemy) then {
		d_infunitswithoutleader = d_infunitswithoutleader + 1;
	};
#endif
} forEach _unitliste;
_ret joinSilent _grp;
#ifdef __GROUPDEBUG__
if (side _grp == d_side_enemy) then {
	d_infunitswithoutleader = d_infunitswithoutleader - 1;
};
#endif
(leader _grp) setRank "SERGEANT";
#ifndef __TT__
_ret remoteExecCall ["d_fnc_addceo", 2];
#endif
_ret