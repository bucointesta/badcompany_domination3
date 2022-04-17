// by Xeno
#define THIS_FILE "fn_handleattackgroups.sqf"
#include "..\..\x_setup.sqf"

if (!isServer) exitWith {};

params ["_grps", "_unitLimit", "_playerCount"];

private _allunits = [];
{
	_allunits append ((units _x) select {alive _x});
} forEach _grps;

if (_allunits isEqualTo []) exitWith {
	d_c_attacking_grps = [];
	d_create_new_paras = true;
};

sleep 1.2123;

{
	_x forceSpeed 20;
} foreach _allunits;

_unitLimit = 4;

while {!d_mt_radio_down} do {
	
	// Hunter: based on same calculation as chopper count (assumed 10 units per chopper)
	// so when ~ 1/3 of units left call reinforcements
	// probably should centralise this...
	
	_playerCount = call d_fnc_PlayersNumber;
	switch (true) do {
		case (_playerCount > 59) : { _unitLimit = 14};
		case (_playerCount > 44) : { _unitLimit = 11};
		case (_playerCount > 34) : { _unitLimit = 8 };
		default {_unitLimit = 4};
	};

	if ({alive _x} count _allunits < _unitLimit) exitWith {
		d_c_attacking_grps = [];
		d_create_new_paras = true;
	};
	sleep 10.623;
};
