// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_sideevac.sqf"
#include "..\..\x_setup.sqf"

if !(call d_fnc_checkSHC) exitWith {};

params ["_pos_array", "_endtime"];
private _poss = _pos_array select 0;

private _wreck = createVehicle [d_sm_wrecktype, _poss, [], 0, "NONE"];
_wreck setDir (random 360);
_wreck setPos _poss;
_wreck lock true;
d_x_sm_vec_rem_ar pushBack _wreck;

sleep 2;

private _owngroup = [d_side_player] call d_fnc_creategroup;
__TRACE_1("","_owngroup")
private _pilot1 = _owngroup createUnit [d_sm_pilottype, _poss, [], 60, "NONE"];
__TRACE_1("","_pilot1")
_pilot1 call d_fnc_removenvgoggles_fak;

private _pilot2 = _owngroup createUnit [d_sm_pilottype, getPosATL _pilot1, [], 0, "NONE"];
__TRACE_1("","_pilot2")
_pilot2 call d_fnc_removenvgoggles_fak;
[_pilot1, _pilot2] joinSilent _owngroup;

sleep 15;
_pilot1 disableAI "PATH";
_pilot1 setDamage 0.5;
_pilot1 setUnitPos "DOWN";
_pilot2 disableAI "PATH";
_pilot2 setDamage 0.5;
_pilot2 setUnitPos "DOWN";

_owngroup deleteGroupWhenEmpty true;

if (d_with_dynsim == 0) then {
	_owngroup enableDynamicSimulation true;
};

private _is_dead = false;
private _pilots_at_base = false;
private _rescued = false;
private _time_over = 3;
private _enemy_created = false;
private _resctimestarted = time;
private _rescuer = objnull;

private _pcheck_fnc = {
	params ["_u", "_p"];
	private _ogroup = group _u;
	_u setUnitPos "AUTO";
	_u enableAI "PATH";
	[_u] join _p;
	deleteGroup _ogroup;
};


while {!_pilots_at_base && {!_is_dead && {!d_sm_resolved}}} do {
	if (isMultiplayer) then {waitUntil {sleep (1.012 + random 1);_pnum = call d_fnc_PlayersNumber; if (_pnum == 0) then {_resctimestarted = time};_pnum > 0}};
	if (!alive _pilot1 && {!alive _pilot2}) then {
		_is_dead = true;
	} else {
		if (!_rescued) then {
			__TRACE("not rescued")
			if (alive _pilot1) then {
				__TRACE("_pilot1 alive")
				private _nobjs = (_pilot1 nearEntities ["Man", 20]) select {isPlayer _x};
				__TRACE_1("","_nobjs")
				if !(_nobjs isEqualTo []) then {
					_rescuer = _nobjs select 0;
					_resctimestarted = time;
					_rescued = true;
					[_pilot1, _rescuer] call _pcheck_fnc;
					[_pilot2, _rescuer] call _pcheck_fnc;
				};
			};
			
			if (!_rescued) then {
				if (alive _pilot2) then {
					__TRACE("_pilot2 alive")
					private _nobjs = (_pilot1 nearEntities ["Man", 20]) select {isPlayer _x};
					__TRACE_1("","_nobjs")
					if !(_nobjs isEqualTo []) then {
						_rescuer = _nobjs select 0;
						_resctimestarted = time;
						_rescued = true;
						[_pilot1, _rescuer] call _pcheck_fnc;
						[_pilot2, _rescuer] call _pcheck_fnc;
					};
				};
				if (!_rescued && {time - _resctimestarted > 3600}) then {
					_is_dead = true;
				};
			};
		} else {
			if (_pilot1 distance2D d_FLAG_BASE < 50 || {_pilot2 distance2D d_FLAG_BASE < 50}) exitWith {_pilots_at_base = true};
			if (!alive _rescuer) then {  
				_rescued = false;
				_pilot1 disableAI "PATH";
				_pilot1 setUnitPos "DOWN";
				_pilot2 disableAI "PATH";
				_pilot2 setUnitPos "DOWN";
			};
			if (time - _resctimestarted > 3600) then {
				_is_dead = true;
			};
		};
	};

	sleep 5.621;
	if (_time_over > 0) then {
		if (_time_over == 3) then {
			if (_endtime - time <= 600) then {
				_time_over = 2;
				[23] remoteExecCall ["d_fnc_DoKBMsg", 2];
			};
		} else {
			if (_time_over == 2) then {
				if (_endtime - time <= 300) then {
					_time_over = 1;
					[25] remoteExecCall ["d_fnc_DoKBMsg", 2];
				};
			} else {
				if (_time_over == 1) then {
					if (_endtime - time <= 120) then {
						_time_over = 0;
						[27] remoteExecCall ["d_fnc_DoKBMsg", 2];
					};
				};
			};
		};
	} else {
		if (!_enemy_created) then {
			_enemy_created = true;
			private _estart_pos = [_poss,250] call d_fnc_GetRanPointCircleOuter;
			private _unit_array = ["allmen", d_enemy_side_short] call d_fnc_getunitlistm;
			for "_i" from 1 to ([3,5] call d_fnc_GetRandomRangeInt) do {
				private _newgroup = [d_enemy_side] call d_fnc_creategroup;
				private _units = [_estart_pos, _unit_array, _newgroup] call d_fnc_makemgroup;
				_newgroup deleteGroupWhenEmpty true;
				sleep 1.045;
				private _leader = leader _newgroup;
				_leader setRank "LIEUTENANT";
				_newgroup allowFleeing 0;
				_newgroup setBehaviour "AWARE";
				private _gwp = _newgroup addWaypoint [_poss, 30];
				_gwp setWaypointtype "SAD";
				_gwp setWaypointCombatMode "YELLOW";
				_gwp setWaypointSpeed "FULL";
				d_x_sm_rem_ar append _units;
				{_x triggerDynamicSimulation true; false} count _units;
				sleep 1.012;
			};
			if (d_with_dynsim == 0) then {
				_owngroup enableDynamicSimulation false;
			};
			_unit_array = nil;
		};
	};
};

if (!d_sm_resolved) then {
	if (_is_dead) then {
		d_sm_winner = -700;
	} else {
		if (d_with_ranked) then {
			[missionNamespace, ["d_sm_p_pos", getPosATL d_FLAG_BASE]] remoteExecCall ["setVariable", [0, -2] select isDedicated];
		};
		d_sm_winner = 2;
	};
};

sleep 2.123;

if (!isNull _pilot1) then {
	if (!isNull objectParent _pilot1) then {
		(objectParent _pilot1) deleteVehicleCrew _pilot1;
	} else {
		deleteVehicle _pilot1;
	};
};
if (!isNull _pilot2) then {
	if (!isNull objectParent _pilot2) then {
		(objectParent _pilot2) deleteVehicleCrew _pilot2;
	} else {
		deleteVehicle _pilot2;
	};
};
sleep 0.5;

d_sm_resolved = true;
if (d_IS_HC_CLIENT) then {
	[missionNamespace, ["d_sm_winner", d_sm_winner]] remoteExecCall ["setVariable", 2];
	[missionNamespace, ["d_sm_resolved", true]] remoteExecCall ["setVariable", 2];
};