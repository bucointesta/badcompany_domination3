// by Xeno
#define THIS_FILE "fn_sidetanks.sqf"
#include "..\..\x_setup.sqf"

if !(call d_fnc_checkSHC) exitWith {};

params ["_posi_array", "_dirs"];


private _tanks_ar = [];
for "_ii" from 1 to (count _posi_array) - 1 do {
	private _tank = createVehicle [d_sm_tank, _posi_array select _ii, [], 0, "NONE"];
	_tank setDir (_dirs select 0);
	_tank setPos (_posi_array select _ii);
	d_x_sm_vec_rem_ar pushBack _tank;
	_tank lock true;
	_tanks_ar pushBack _tank;
	sleep 0.512;
};

sleep 2.333;
["specops", 2, "allmen", 2, _posi_array select 0, 300, true] spawn d_fnc_CreateInf;
sleep 2.333;
["aa", 1, "tracked_apc", 1, "tank", 1, _posi_array select 0, 2, 400, true] spawn d_fnc_CreateArmor;

_dirs = nil;
_posi_array = nil;

sleep 15.321;

private _num_t = count _tanks_ar;

while {true} do {
	if ({damage _x >= 0.9 || {!alive _x}} count _tanks_ar == _num_t) exitWith {};
	sleep 5.321;
	__TRACE_1("","_tanks_ar")
	#ifdef __DEBUG__
	{
		__TRACE_3("","_x","damage _x","alive _x")
	} forEach _tanks_ar;
	#endif
	if (d_sm_resolved) exitWith {};
};

if (!d_sm_resolved) then {
	d_sm_winner = 2;
};

d_sm_resolved = true;
if (d_IS_HC_CLIENT) then {
	[missionNamespace, ["d_sm_winner", d_sm_winner]] remoteExecCall ["setVariable", 2];
	[missionNamespace, ["d_sm_resolved", true]] remoteExecCall ["setVariable", 2];
};