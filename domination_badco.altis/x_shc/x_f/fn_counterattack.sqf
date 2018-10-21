// by Xeno
#define THIS_FILE "fn_counterattack.sqf"
#include "..\..\x_setup.sqf"

if !(call d_fnc_checkSHC) exitWith {};

if (isServer && {!isNil "d_HC_CLIENT_OBJ_OWNER"}) exitWith {
	remoteExec ["d_fnc_counterattack", d_HC_CLIENT_OBJ_OWNER];
};

private _start_array = [d_cur_tgt_pos, d_cur_target_radius + 200, 1, 2] call d_fnc_getwparray;

private _vecs_counter_attack = if (d_WithLessArmor == 0) then {
	(5 call d_fnc_RandomFloor) max 2
} else {
	if (d_WithLessArmor == 1) then {
		1
	} else {
		0
	};
};

private _numvecs = if (d_WithLessArmor == 0) then {
	(_vecs_counter_attack - 2) max 1
} else {
	if (d_WithLessArmor == 1) then {
		1
	} else {
		0
	};
};

private _men = if (d_WithLessArmor == 0) then {
	(4 call d_fnc_RandomFloor) max 2
} else {
	if (d_WithLessArmor == 1) then {
		(6 call d_fnc_RandomFloor) max 3
	} else {
		7
	};
};

private _type_list_attack = [
	["allmen", 0, ceil (random _men)],
	["specops", 0, ceil (random _men)],
	["tank", [0, ceil random _numvecs] select (_numvecs > 0), [0, ceil (random (_vecs_counter_attack - 1))] select (_numvecs > 0)],
	["tracked_apc", [0, ceil random _numvecs] select (_numvecs > 0), [0, ceil (random (_vecs_counter_attack - 1))] select (_numvecs > 0)]
];

sleep 45 + random 25;

[20] remoteExecCall ["d_fnc_DoKBMsg", 2];

for "_xx" from 0 to (count _type_list_attack - 1) do {
	private _typeidx = _type_list_attack select _xx;
	private _nums = _typeidx select 2;
	if (_nums > 0) then {
		for "_i" from 1 to _nums do {
			[_typeidx select 0, _start_array, d_cur_tgt_pos, _typeidx select 1, "attack", d_enemy_side_short, 0, -1.111] call d_fnc_makegroup;
			sleep 5.123;
		};
	};
};

_start_array = nil;
_type_list_attack = nil;
_vecs_counter_attack = nil;

d_cur_tgt_pos spawn {
	scriptName "spawn_counterattack_trig";
	sleep 30.122;
	d_current_trigger = [_this, [350, 350, 0, false], [d_enemy_side, "PRESENT", false], ["'Tank' countType thislist  < 2 && {'CAManBase' countType thislist < 7}", "d_counterattack = false;if (d_IS_HC_CLIENT) then {[missionNamespace, ['d_counterattack', false]] remoteExecCall ['setVariable', 2];};deleteVehicle d_current_trigger", ""]] call d_fnc_createtriggerlocal;
};
