// by Xeno
#define THIS_FILE "fn_sideprisoners.sqf"
#include "..\..\x_setup.sqf"

if !(call d_fnc_checkSHC) exitWith {};

private _pos = (param [0]) select 0;

if (d_with_ranked) then {d_sm_p_pos = nil};

sleep 2;

private _newgroup = [d_own_side] call d_fnc_creategroup;
[_pos, call d_fnc_getunitlistc, _newgroup] call d_fnc_makemgroup;
private _leader = leader _newgroup;
_leader setSkill 1;
sleep 2.0112;
_newgroup allowFleeing 0;
_newgroup deleteGroupWhenEmpty true;
private _units = units _newgroup;
{
	removeAllWeapons _x;
	_x setCaptive true;
	_x disableAI "PATH";
	false
} count _units;

if (d_with_dynsim == 0) then {
	_newgroup enableDynamicSimulation true;
};

sleep 2.333;
["specops", 2, "allmen", 2, _pos, 100, true] spawn d_fnc_CreateInf;
sleep 2.333;
["aa", 1, "tracked_apc", 1, "tank", 1, _pos, 1, 140, true] spawn d_fnc_CreateArmor;

sleep 32.123;

private _hostages_reached_dest = false;
private _all_dead = false;
private _rescued = false;
private _mforceendtime = time + 2400;

private _aiver_check_fnc = {
	if (!d_with_ai) then {
		(str _this) in d_can_use_artillery
	} else {
		true
	}
};

private _rescuer = objNull;
while {!_hostages_reached_dest && {!_all_dead && {!d_sm_resolved}}} do {
	call d_fnc_mpcheck;
	if ({alive _x} count _units == 0) exitWith {
		_all_dead = true;
	};
	if (!_rescued) then {
		_leader = leader _newgroup;
		private _nobjs = _leader nearEntities ["CAManBase", 20];
		if !(_nobjs isEqualTo []) then {
			{
				if (alive _x && {isPlayer _x && {!(_x getVariable ["xr_pluncon", false]) && {!(_x getVariable ["ace_isunconscious", false]) && {_x call _aiver_check_fnc}}}}) exitWith {
					_rescued = true;
					_mforceendtime = time + 2400;
					_rescuer = _x;
					{
						if (alive _x) then {
							_x setCaptive false;
							_x enableAI "PATH";
						};
						false
					} count _units;
					_units join _rescuer;
				};
				sleep 0.01;
			} forEach _nobjs;
		};
	} else {
		if (_winner == 2) then {
			_hostages_reached_dest = {alive _x && {(vehicle _x) distance2D d_EFLAG_BASE < 50}} count _units > 0;
		} else {
			_hostages_reached_dest = {alive _x && {(vehicle _x) distance2D d_WFLAG_BASE < 50}} count _units > 0;
		};
		private _tmp_flag = d_FLAG_BASE;
		_hostages_reached_dest = {alive _x && {(vehicle _x) distance2D _tmp_flag < 50}} count _units > 0;
		
		if (!_hostages_reached_dest) then {
			{
				if (alive _x) exitWith {
					_newgroup = group _x;
				};
				false
			} count _units;
			if (!isPlayer (leader _newgroup)) then {
				_rescued = false;
			};
		};
	};
	if (d_with_ranked && {_hostages_reached_dest}) then {
		private _tmp_flag = d_FLAG_BASE;
		[missionNamespace, ["d_sm_p_pos", getPosATL _tmp_flag]] remoteExecCall ["setVariable", [0, -2] select isDedicated];
	};
	if (time > _mforceendtime) then {
		{
			_x setDamage 1;
			false
		} count _units;
		_all_dead = true;
	};
	sleep 5.123;
};

if (!d_sm_resolved) then {
	if (_all_dead) then {
		d_sm_winner = -400;
	} else {
		if ({alive _x} count _units > 7) then {
			d_sm_winner = 2;
		} else {
			d_sm_winner = -400;
		};
	};
};

d_sm_resolved = true;
if (d_IS_HC_CLIENT) then {
	[missionNamespace, ["d_sm_winner", d_sm_winner]] remoteExecCall ["setVariable", 2];
	[missionNamespace, ["d_sm_resolved", true]] remoteExecCall ["setVariable", 2];
};

sleep 5.123;

{
	if (!isNull _x) then {
		if (!isNull objectParent _x) then {
			(vehicle _x) deleteVehicleCrew _x;
		} else {
			deleteVehicle _x;
		};
	};
	false
} count _units;
sleep 0.5321;
if (!isNull _newgroup) then {deleteGroup _newgroup};
