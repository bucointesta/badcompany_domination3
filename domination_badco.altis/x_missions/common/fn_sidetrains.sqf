// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_sidetrains.sqf"
#include "..\..\x_setup.sqf"

__TRACE_1("","_this")

if !(call d_fnc_checkSHC) exitWith {};

params ["_pos", "_trains"];

sleep 2.333;
["specops", 2, "allmen", 2, _pos, 200, true] spawn d_fnc_CreateInf;
sleep 2.333;
["aa", 1, "tracked_apc", 1, "tank", 1, _pos, 2, 300, true] spawn d_fnc_CreateArmor;

sleep 15.321;

private _num_t = count _trains;

while {true} do {
	call d_fnc_mpcheck;
	if ({damage _x >= 0.9 || {!alive _x}} count _trains == _num_t) exitWith {};
	sleep 5.321;
	__TRACE_1("","_trains")
	#ifdef __DEBUG__
	{
		__TRACE_3("","_x","damage _x","alive _x")
	} forEach _trains;
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