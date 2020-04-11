// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_makegroup.sqf"
#include "..\..\x_setup.sqf"

if !(call d_fnc_checkSHC) exitWith {};

params ["_grptype", "_wp_array", "_target_pos", "_numvecs", "_type", "_side", "_grp_in", "_vec_dir", ["_add_to_ar_type", 0], "_center_rad", ["_mchelper", true]];

__TRACE_1("","_this")
private _vecs = [];
private _uinf = [];

private _grp = [_grp_in, [_side] call d_fnc_creategroup] select (_grp_in isEqualType 0);
private _pos = selectRandom _wp_array;

__TRACE_1("","_grp")

private _msize = 0;
if (_numvecs > 0) then {
	if !(_grptype in ["stat_mg", "stat_gl", "arty"]) then {
		_vecs append (([_numvecs, _pos, [_grptype, _side] call d_fnc_getunitlistv, _grp, _vec_dir] call d_fnc_makevgroup) # 0);
	} else {
		([_numvecs, _pos, [_grptype, _side] call d_fnc_getunitlistv, _grp, _vec_dir, true] call d_fnc_makevgroup) params ["_tmpvecs"];
		{
			_x enableWeaponDisassembly false;
		} forEach _tmpvecs;
		_vecs append _tmpvecs;
	};
	_grp setSpeedMode "LIMITED";
	_msize = 2;
} else {
	__TRACE("from makegroup")
	_uinf = [_pos, [_grptype, _side] call d_fnc_getunitlistm, _grp, _mchelper] call d_fnc_makemgroup;
};

_grp deleteGroupWhenEmpty true;

if (_add_to_ar_type > 0) then {
#ifndef __TT__
	if (d_mt_respawngroups == 0) then {
		if !(_grptype in ["stat_mg", "stat_gl", "arty"]) then { // don't add static weapons !!!!, respawn doesn't make sense, they can't travel from the respawn camp to another location
			if !((toLower _grptype) in ["allmen", "specops"]) then {
				d_respawn_ai_groups pushBack [_grp, [toLower _grptype, [], _target_pos, _numvecs, "patrol2", _side, 0, _vec_dir, _add_to_ar_type, _center_rad, false, d_enemyai_respawn_pos]];
			} else {
				d_respawn_ai_groups pushBack [_grp, [toLower _grptype, [], _target_pos, _numvecs, "patrol2", _side, 0, _vec_dir, _add_to_ar_type, _center_rad, false, []]];
			};
		};
	};
#endif
	if !(_vecs isEqualTo []) then {
		d_delvecsmt append _vecs;
	};
	if !(_uinf isEqualTo []) then {
		d_delinfsm  append _uinf;
	};
};

_grp allowFleeing (((floor random 3) + 1) / 10);

private _sleepti = [5, 15] select (_grptype == "allmen" || {_grptype == "specops"});

private _wpstatements = if (d_house_patrol == 0 && {_type in ["patrol", "patrol2mt"] && {(toLower _grptype) in ["allmen", "specops"]}}) then {
	"if (random 100 < 50) then {0 = [thisList] spawn d_fnc_dohousepatrol}"
} else {
	""
};

switch (_type) do {
	case "patrol": {
		_grp setVariable ["d_PATR",true];
		private _min = 1 + random 15;
		private _max = _min + (1 + random 15);
		private _mid = _min + (random (_max - _min));	
		[_grp, _pos, _center_rad, [_min, _mid, _max], _wpstatements, _msize] spawn d_fnc_MakePatrolWPX;
	};
	case "patrol2mt": {
		_grp setVariable ["d_PATR",true];
		private _min = 1 + random 15;
		private _max = _min + (1 + random 15);
		private _mid = _min + (random (_max - _min));
		[_grp, _pos, _center_rad, [_min, _mid, _max], _wpstatements, _msize] spawn d_fnc_MakePatrolWPX;
	};
	case "patrol2": {
		_grp setVariable ["d_PATR",true];
		private _min = 1 + random 15;
		private _max = _min + (1 + random 15);
		private _mid = _min + (random (_max - _min));
		[_grp, _pos, _center_rad, [_min, _mid, _max], "", _msize] spawn d_fnc_MakePatrolWPX2;
	};
	case "guard": {
		if (_grptype == "allmen" || {_grptype == "specops"}) then {
			_grp setVariable ["d_defend", true];
			[_grp, _pos] spawn d_fnc_taskDefend;
		} else {
			_grp setCombatMode "RED";
			_grp setFormation selectRandom ["COLUMN","STAG COLUMN","WEDGE","ECH LEFT","ECH RIGHT","VEE","LINE","FILE","DIAMOND"];
			_grp setFormDir (floor random 360);
			_grp setSpeedMode "NORMAL";
			_grp setBehaviour "AWARE";
		};
	};
	case "guardstatic": {
		if (_grptype == "allmen" || {_grptype == "specops"}) then {
			_grp setVariable ["d_defend", true];
			// Hunter: Make these guys garrison buildings instead
			//[_grp, _pos] spawn d_fnc_taskDefend;
			[_grp,500,true,[100,2],true,2] execVM "logistics\garrison.sqf";
		} else {
			_grp setCombatMode "RED";
			_grp setFormation selectRandom ["COLUMN","STAG COLUMN","WEDGE","ECH LEFT","ECH RIGHT","VEE","LINE","FILE","DIAMOND"];
			_grp setFormDir (floor random 360);
			_grp setSpeedMode "NORMAL";
			_grp setBehaviour "AWARE";
		};
	};
	case "guardstatic2": {
		// Hunter: make direction more sensible
		//(_vecs # 0) setDir (floor random 360);
		(_vecs # 0) setdir (d_cur_tgt_pos getdir (_vecs # 0));
		(_vecs # 0) setPos (getpos (_vecs # 0)); // Hunter: might prevent static weapons from tipping over?
		(_vecs # 0) setSkill 1;
	};
	case "attack": {
		_grp setBehaviour "AWARE";
		_grp setCombatMode "RED";
		private _gwp = _grp addWaypoint [_target_pos, 30];
		_gwp setWaypointtype "SAD";
		_gwp setWaypointCombatMode "RED";
		_gwp setWaypointSpeed "FULL";
	};
};

// Hunter: Max out all vehicle AI skills
{
	if ((vehicle _x) != _x) then {	
		_x setSkill 1;	
	};
} foreach units _grp;
_grp setBehaviour "COMBAT";

if (d_with_dynsim == 0) then {
	[_grp, _sleepti] spawn {
		sleep (_this select 1);
		(_this select 0) enableDynamicSimulation true;
	};
};
