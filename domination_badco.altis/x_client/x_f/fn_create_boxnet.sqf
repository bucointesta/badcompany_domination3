// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_create_boxnet.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

__TRACE_1("","_this")

params ["_pos", "_unit"];

__TRACE_2("","_pos","_unit")
private _box = d_the_box createVehicleLocal [0,0,0];
_box setPos _pos;
__TRACE_2("","_box","_pos")
player reveal _box;
_box allowDamage false;
private _boxcargo = _unit getVariable "d_boxcargo";
if (isNil "_boxcargo") then {
	[_box] call d_fnc_weaponcargo;
} else {
	__TRACE_1("","_boxcargo")
	[_box, _boxcargo] call d_fnc_fillDropedBox;
	_unit setVariable ["d_boxcargo", nil];
};