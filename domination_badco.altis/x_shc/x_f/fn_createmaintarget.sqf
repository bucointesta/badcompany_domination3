// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_createmaintarget.sqf"
#include "..\..\x_setup.sqf"

if !(call d_fnc_checkSHC) exitWith {};

private _selectit = {
	(ceil (random (((param [0]) select (param [1])) select 1)))
};

private _selectitmen = {
	private _a_vng2 = (param [0]) select (param [1]);
	if (_a_vng2 select 0 > 0) then {private _num_ret = floor (random ((_a_vng2 select 0) + 1));if (_num_ret < _a_vng2 select 1) then {_a_vng2 select 1} else {_num_ret}} else {0}
};

private _selectitvec = {
	private _a_vng2 = ((param [0]) select (param [1])) select 0;
	if (_a_vng2 select 0 > 0) then {private _num_ret = floor (random ((_a_vng2 select 0) + 1));if (_num_ret < _a_vng2 select 1) then {_a_vng2 select 1} else {_num_ret}} else {0}
};

private _type_list_guard = [
	["allmen", 0, [d_footunits_guard, 0] call _selectitmen],
	["specops", 0, [d_footunits_guard, 1] call _selectitmen],
	["tank", [d_vec_numbers_guard, 0] call _selectit, [d_vec_numbers_guard,0] call _selectitvec],
	["tracked_apc", [d_vec_numbers_guard, 1] call _selectit, [d_vec_numbers_guard,1] call _selectitvec],
	["wheeled_apc", [d_vec_numbers_guard, 2] call _selectit, [d_vec_numbers_guard,2] call _selectitvec],
	["jeep_mg", [d_vec_numbers_guard, 3] call _selectit, [d_vec_numbers_guard,3] call _selectitvec],
	["jeep_gl", [d_vec_numbers_guard, 4] call _selectit, [d_vec_numbers_guard,4] call _selectitvec]
];

private _type_list_guard_static = [
	["allmen", 0, [d_footunits_guard_static, 0] call _selectitmen],
	["specops",0, [d_footunits_guard_static, 1] call _selectitmen],
	["tank", [d_vec_numbers_guard_static, 0] call _selectit, [d_vec_numbers_guard_static,0] call _selectitvec],
	["tracked_apc", [d_vec_numbers_guard_static, 1] call _selectit, [d_vec_numbers_guard_static,1] call _selectitvec],
	["aa", [d_vec_numbers_guard_static, 2] call _selectit, [d_vec_numbers_guard_static,2] call _selectitvec]
];

private _type_list_patrol = [
	["allmen", 0, [d_footunits_patrol, 0] call _selectitmen],
	["specops", 0, [d_footunits_guard_static, 1] call _selectitmen],
	["tank", [d_vec_numbers_patrol, 0] call _selectit, [d_vec_numbers_patrol,0] call _selectitvec],
	["tracked_apc", [d_vec_numbers_patrol, 1] call _selectit, [d_vec_numbers_patrol,1] call _selectitvec],
	["wheeled_apc", [d_vec_numbers_patrol, 2] call _selectit, [d_vec_numbers_patrol,2] call _selectitvec],
	["jeep_mg", [d_vec_numbers_patrol, 3] call _selectit, [d_vec_numbers_patrol,3] call _selectitvec],
	["jeep_gl", [d_vec_numbers_patrol, 4] call _selectit, [d_vec_numbers_patrol,4] call _selectitvec]
];

private _type_list_guard_static2 = [
	["stat_mg", 1, ceil (random 4)],
	["stat_gl", 1, ceil (random 3)]
];

_selectit = nil;
_selectitmen = nil;
_selectitvec = nil;

__TRACE_1("","_type_list_guard")

params ["_trgobj", "_radius"];
private _patrol_radius = _radius + 300 + random 300;

__TRACE_3("","_trgobj","_radius","_patrol_radius")
__TRACE_1("","_this")

private _trg_center = if (_trgobj isEqualType objNull) then {getPosATL _trgobj} else {_trgobj};
__TRACE_1("","_trg_center")
private _wp_array_inf = [_trg_center, _radius, 0, 0] call d_fnc_getwparray;
private _wp_array_vecs = [_trg_center, _radius, 0, 2] call d_fnc_getwparray;
__TRACE_1("","_trg_center")
private _wp_array_pat_inf = [_trg_center, _patrol_radius, 0, 0] call d_fnc_getwparray;
private _wp_array_pat_vecs = [_trg_center, _patrol_radius, 0, 2] call d_fnc_getwparray;
__TRACE_2("","_wp_array","_wp_array_pat")

sleep 0.112;

{
	private _nums = _x select 2;
	if (_nums > 0) then {
		private _curar = [_wp_array_vecs, _wp_array_inf] select (_x select 1 == 0);
		for "_xxx" from 1 to _nums do {
			private _wp_ran = (count _curar) call d_fnc_RandomFloor;
			[_x select 0, [_curar select _wp_ran], _trg_center, _x select 1, "guard", d_enemy_side_short, 0, -1.111, 1, [_trg_center, _radius]] call d_fnc_makegroup;
			_curar deleteAt _wp_ran;
			sleep 0.4;
		};
	};
} forEach _type_list_guard;

sleep 0.233;

{
	private _nums = _x select 2;
	if (_nums > 0) then {
		private _curar = [_wp_array_vecs, _wp_array_inf] select (_x select 1 == 0);
		for "_xxx" from 1 to _nums do {
			private _wp_ran = (count _curar) call d_fnc_RandomFloor;
			[_x select 0, [_curar select _wp_ran], _trg_center, _x select 1, "guardstatic", d_enemy_side_short, 0, -1.111, 1, [_trg_center, _radius]] call d_fnc_makegroup;
			_curar deleteAt _wp_ran;
			sleep 0.4;
		};
	};
} forEach _type_list_guard_static;

{
	private _nums = _x select 2;
	if (_nums > 0) then {
		for "_xxx" from 1 to _nums do {
			private _wp_ran = (count _wp_array_inf) call d_fnc_RandomFloor;
			[_x select 0, [_wp_array_inf select _wp_ran], _trg_center, _x select 1, "guardstatic2", d_enemy_side_short, 0, -1.111, 1, [_trg_center, _radius]] call d_fnc_makegroup;
			_wp_array_inf deleteAt _wp_ran;
			sleep 0.1;
		};
	};
} forEach _type_list_guard_static2;

d_del_mtd_objects = [];

{
	private _nums = _x select 2;
	if (_nums > 0) then {
		private _curar = [_wp_array_pat_vecs, _wp_array_pat_inf] select (_x select 1 == 0);
		for "_xxx" from 1 to _nums do {
			private _wp_ran = (count _curar) call d_fnc_RandomFloor;
			[_x select 0, [_curar select _wp_ran], _trg_center, _x select 1, ["patrol", "patrol2mt"] select (_x select 0 == "allmen" || {_x select 0 == "specops"}), d_enemy_side_short, 0, -1.111, 1, [_trg_center, _patrol_radius]] call d_fnc_makegroup;
			_curar deleteAt _wp_ran;
			sleep 0.4;
		};
	};
} forEach _type_list_patrol;

_type_list_guard = nil;
_type_list_guard_static = nil;
_type_list_guard_static2 = nil;
_type_list_patrol = nil;

sleep 2.124;

if (!d_no_more_observers) then {
	d_nr_observers = floor random 4;
	if (d_nr_observers < 2) then {d_nr_observers = 2};

	d_obs_array = [objNull, objNull, objNull];
	private _unit_array = ["arti_observer", d_enemy_side_short] call d_fnc_getunitlistm;
	for "_xx" from 0 to d_nr_observers - 1 do {
		private _agrp = [d_side_enemy] call d_fnc_creategroup;
		private _xx_ran = (count _wp_array_inf) call d_fnc_RandomFloor;
		private _xpos = _wp_array_inf select _xx_ran;
		_wp_array_inf deleteAt _xx_ran;
		private _observer = ([_xpos, _unit_array, _agrp] call d_fnc_makemgroup) select 0;
		_agrp deleteGroupWhenEmpty true;
		[_agrp, _xpos, [_trg_center, _radius], [5, 20, 40], "", 0] spawn d_fnc_MakePatrolWPX;
		_agrp setVariable ["d_PATR", true];
		if (d_with_dynsim == 0) then {
			_agrp enableDynamicSimulation true;
		};
		_observer addEventHandler ["killed", {d_nr_observers = d_nr_observers - 1;
			if (d_nr_observers == 0) then {
				[3] remoteExecCall ["d_fnc_DoKBMsg", 2];
			};
			(param [0]) removeAllEventHandlers "killed";
		}];
		d_obs_array set [_xx, _observer];
		sleep 0.4;
	};
	_unit_array = nil;

	[6, d_nr_observers] remoteExecCall ["d_fnc_DoKBMsg", 2];
	0 spawn d_fnc_handleobservers;
	sleep 1.214;
};

[_wp_array_vecs, d_cur_target_radius, _trg_center] spawn d_fnc_createsecondary;

//call d_fnc_RespawnGroups;
if (d_mt_respawngroups == 0) then {
	execFSM "fsms\fn_RespawnGroups.fsm";
};

_wp_array_pat = nil;
