// by Xeno
#define THIS_FILE "fn_shootari.sqf"
#include "..\..\x_setup.sqf"

if !(call d_fnc_checkSHC) exitWith {};

params ["_pos_enemy", "_kind"];

private _which = [d_ArtyShellsBlufor, d_ArtyShellsOpfor] select (d_enemy_side == "EAST");
private _height = 1000;

private _type = call {
	if (_kind == 0) exitWith {_which # 2};
	if (_kind == 1) exitWith {_which # 0};
	_height = 1; _which # 1
};

#ifndef __TT__
	if (d_searchintel # 4 == 1) then {
#else
	if (floor random 3 == 0) then {
#endif
		_pos_enemy remoteExecCall ["d_fnc_doarti", [0, -2] select isDedicated];
	};

private _num_shells = 4 + (ceil random 4);
if (_kind == 0) then {
	_num_shells = 2;
};

// Hunter: increased "flight time" for better long-range arty simulation
sleep 45 + (random 15);
for "_i" from 0 to (_num_shells - 1) do {
	private _npos = _pos_enemy getPos [random 50, floor random 360];
	_npos set [2, _height];
	private _shell = createVehicle [_type, _npos, [], 0, "NONE"];
	_shell setVelocity [0, 0, -150];
	sleep 0.923 + ((ceil random 10) / 10);
	if (_kind == 0) then {
		sleep (7 + (random 5));
	};
};
