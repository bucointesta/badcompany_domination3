// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_checkmtshothd.sqf"
#include "..\..\x_setup.sqf"

__TRACE_1("","_this")

params ["_tower"];
if (!alive _tower) exitWith {
	_tower removeAllEventHandlers "handleDamage";
};
private _r = if (d_MTTowerSatchelsOnly == 1 || {toUpper(getText(configFile>>"CfgAmmo">>(param [4])>>"simulation")) in d_hd_sim_types}) then {
	param [2]
} else {
	0
};
__TRACE_1("_r new","_r")
if (_r > 0) then {
	private _val = _tower getVariable ["d_damt", 0];
	__TRACE_1("","_val")
	if (_val > 0) then {_r = _r + _val};
	_tower setVariable ["d_damt", _r];
	__TRACE_1("_r result","_r")
};
_r