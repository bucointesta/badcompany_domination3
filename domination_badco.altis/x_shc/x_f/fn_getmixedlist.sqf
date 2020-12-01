// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_getmixedlist.sqf"
#include "..\..\x_setup.sqf"

//Hunter: this function only seems to be used for the random map patrols... so here can set vehicle types

params ["_side"];
private _types = if (d_WithLessArmor == 0) then {
	//[switch (floor random 2) do {case 0: {"wheeled_apc"};case 1: {"jeep_mg"};}, "tracked_apc", "tank", "aa"]
	["wheeled_apc", "jeep_mg", "jeep_mg", "jeep_mg", "jeep_mg", "jeep_gl", "wheeled_apc", "tracked_apc", "tank",  "jeep_mg", "jeep_mg", "jeep_mg", "jeep_mg", "aa", "jeep_gl"]
} else {
	if (d_WithLessArmor == 1) then {
		["wheeled_apc", "jeep_mg", "wheeled_apc", "jeep_mg", "wheeled_apc"]
	} else {
		["jeep_mg", "jeep_mg", "jeep_mg", "jeep_mg", "jeep_mg"]
	};
};

private _ret_list = [];
{
	_ret_list pushBack ([_x, _side] call d_fnc_getunitlistv);
} forEach _types;
_ret_list