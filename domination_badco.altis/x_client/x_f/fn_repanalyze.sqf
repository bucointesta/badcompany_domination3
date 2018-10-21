// by Xeno
#define THIS_FILE "fn_repanalyze.sqf"
#include "..\..\x_setup.sqf"

if !(local (param [1])) exitWith {};

private _rep_count = if (d_objectID2 isKindOf "Air") then {
	0.1
} else {
	if (d_objectID2 isKindOf "Tank") then {
		0.2
	} else {
		0.3
	};
};

private _fuel = fuel d_objectID2;
private _damage = damage d_objectID2;

private _coef = (_damage / _rep_count) max ((1 - _fuel) / _rep_count);

hintSilent format [localize "STR_DOM_MISSIONSTRING_323", _fuel, _damage, (ceil _coef) * 3, [typeOf (d_objectID2), "CfgVehicles"] call d_fnc_GetDisplayName];