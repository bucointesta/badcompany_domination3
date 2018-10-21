// by Xeno
#define THIS_FILE "fn_sidefactory.sqf"
#include "..\..\x_setup.sqf"

if !(call d_fnc_checkSHC) exitWith {};

private _barray = [];
{
	if (isNil "_x") exitWith {false};
	if (!isNull _x) then {
		_barray pushBack _x;
	};
	false
} count _this;

private _num_t = count _barray;

while {true} do {
	call d_fnc_mpcheck;
	if ({damage _x >= 0.9 || {!alive _x}} count _barray == _num_t) exitWith {};
	sleep 5.321;
	__TRACE_1("","_barray")
	#ifdef __DEBUG__
	{
		__TRACE_3("","_x","damage _x","alive _x")
	} forEach _barray;
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