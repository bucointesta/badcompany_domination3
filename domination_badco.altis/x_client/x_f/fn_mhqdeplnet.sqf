// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_mhqdeplnet.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

params ["_mhq", "_isdeployed"];

if (local _mhq) then {
	_mhq lock _isdeployed;
};
private _name = _mhq getVariable "d_vec_name";
__TRACE_3("","_mhq","_isdeployed","_name")
if (isNil "_name") exitWith {};
if (_isdeployed) then {
	[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_647", _name];
} else {
	[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_648", _name];
};