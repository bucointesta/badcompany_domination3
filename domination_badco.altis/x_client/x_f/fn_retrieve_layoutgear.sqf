// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_retrieve_layoutgear.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

if (item_check_isArsenal) exitWith {

	if (item_check_arsenalChecked) exitWith {};

	item_check_arsenalChecked = true;
	player setUnitLoadout [item_check_arsenalSavedLoadout, true];

};

private _lg = player getVariable "d_layoutgear";
if (!isNil "_lg") then {
	player setUnitLoadout [_lg, true];
};

if (str player in d_badcompany) then {
	player remoteExecCall ["d_fnc_badco_uniform",-2, false];
};

