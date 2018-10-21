// by Xeno
#define THIS_FILE "fn_sidearrest.sqf"
#include "..\..\x_setup.sqf"

if !(call d_fnc_checkSHC) exitWith {};

params ["_officer"];

private _offz_at_base = false;
private _is_dead = false;
private _rescued = false;
private _npls = [];
private _rescuer = objNull;

if (d_with_ranked) then {d_sm_p_pos = nil};

while {!_offz_at_base && {!_is_dead}} do {
	call d_fnc_mpcheck;
	if (!alive _officer) exitWith {_is_dead = true;};
	if (!_rescued) then {
		private _npls = (_officer nearEntities ["Man", 20]) select {isPlayer _x};
		_rescuer = _npls select 0;
		if (!(isNil "_rescuer") && {!(isNull _rescuer)}) then {
			_rescued = true;
			_officer enableAI "PATH";
			[_officer] join _rescuer;
			_officer setCaptive true;
		};
	} else {
		if (!alive _rescuer) then {  //what happen if the rescuer disconnect
					_rescued = false;
					_officer disableAI "PATH";
					[_officer] join grpNull;
					_officer setCaptive false;
		};
		if (_officer distance2D d_FLAG_BASE < 50) then {
			_offz_at_base = true;
		};
	};

	sleep 5.621;
};

if (!d_sm_resolved) then {
	if (_is_dead) then {
		d_sm_winner = -500;
	} else {
		if (_offz_at_base) then {
			if (d_with_ranked) then {
				[missionNamespace, ["d_sm_p_pos", getPosATL d_FLAG_BASE]] remoteExecCall ["setVariable", [0, -2] select isDedicated];
			};
			d_sm_winner = 2;
		};
	};
};


if (!isNull objectParent _officer) then {
	(objectParent _officer) deleteVehicleCrew _officer;
} else {
	deleteVehicle _officer;
};
sleep 0.5;

d_sm_arrest_not_failed = nil;
if (!isNil "d_sm_arrest_mp_unit") then {
	d_sm_arrest_mp_unit removeMPEventHandler ["MPKilled", d_sm_arrest_mp_unit getVariable "d_sm_ar_mpk_eh_idx"];
	d_sm_arrest_mp_unit setVariable ["d_sm_ar_mpk_eh_idx", nil];
	d_sm_arrest_mp_unit = nil;
};

d_sm_resolved = true;
if (d_IS_HC_CLIENT) then {
	[missionNamespace, ["d_sm_winner", d_sm_winner]] remoteExecCall ["setVariable", 2];
	[missionNamespace, ["d_sm_resolved", true]] remoteExecCall ["setVariable", 2];
};