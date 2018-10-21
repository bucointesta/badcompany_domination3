// by Xeno
#define THIS_FILE "fn_sideconvoy.sqf"
#include "..\..\x_setup.sqf"

if !(call d_fnc_checkSHC) exitWith {};

params ["_pos_start", "_pos_end", "_direction"];

if (d_with_ranked) then {d_sm_p_pos = nil};

d_confvdown = 0;
private _numconfv = count d_sm_convoy_vehicles;
private _newgroup = [d_side_enemy] call d_fnc_creategroup;

private _nextpos =+ _pos_start;
private _allSMVecs = [];

for "_i" from 0 to (_numconfv - 1) do {
	private _reta = [1, _nextpos, (d_sm_convoy_vehicles select _i), _newgroup, _direction] call d_fnc_makevgroup;
	private _vehicles = _reta select 0;
	private _onevec = _vehicles select 0;
	_onevec lock true;
	_onevec allowCrewInImmobile true;
	_nextpos = _onevec modeltoworld [0, -15, 0];
	_nextpos set [2,0];
	_onevec addEventHandler ["killed", {
		d_confvdown = d_confvdown + 1;
		(param [0]) removeAllEventHandlers "killed";
		{(param [0]) deleteVehicleCrew _x;false} count (crew (param [0]));
	}];
	_allSMVecs pushBack _onevec;
	d_x_sm_vec_rem_ar append _vehicles;
	d_x_sm_rem_ar append (_reta select 1);
	_onevec setConvoySeparation 20;
	_vehicles = nil;
	sleep 1.933;
};

private _leader = leader _newgroup;
_leader setRank "LIEUTENANT";
_newgroup allowFleeing 0;
_newgroup setCombatMode "GREEN";
_newgroup setFormation "COLUMN";
_newgroup setSpeedMode "LIMITED";

_newgroup deleteGroupWhenEmpty true;

private _wp =_newgroup addWaypoint[_pos_start, 0];
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "NORMAL";
_wp setwaypointtype "MOVE";
_wp setWaypointFormation "COLUMN";
_wp setWaypointTimeout [30,50,40];
_wp setWaypointForceBehaviour true;
_wp = _newgroup addWaypoint[_pos_end, 0];
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "NORMAL";
_wp setwaypointtype "MOVE";
_wp setWaypointFormation "COLUMN";
_wp setWaypointForceBehaviour true;

sleep 20.123;

private _convoy_reached_dest = false;
private _endtime = time + 4800;

while {true} do {
	call d_fnc_mpcheck;
	if (d_confvdown == _numconfv || {{canMove _x} count _allSMVecs == 0}) exitWith {};
	if ((getPosATL (leader _newgroup)) distance2D _pos_end < 100) exitWith {
		_convoy_reached_dest = true;
	};
	if (d_with_ranked) then {
		[missionNamespace, ["d_sm_p_pos", getPosATL _leader]] remoteExecCall ["setVariable", [0, -2] select isDedicated];
	};
	if (time > _endtime) exitWith {_convoy_reached_dest = true};
	sleep 5.123;
	if (d_sm_resolved) exitWith {};
};

if (!d_sm_resolved) then {
	d_sm_winner = if (_convoy_reached_dest) then {
		-300
	} else {
		2
	};
};

d_sm_resolved = true;
if (d_IS_HC_CLIENT) then {
	[missionNamespace, ["d_sm_winner", d_sm_winner]] remoteExecCall ["setVariable", 2];
	[missionNamespace, ["d_sm_resolved", true]] remoteExecCall ["setVariable", 2];
};