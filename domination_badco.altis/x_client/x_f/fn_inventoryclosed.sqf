// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_inventoryclosed.sqf"
#include "..\..\x_setup.sqf"

if (player getVariable ["d_isinprison", false]) exitWith {};

__TRACE_1("","_this")

private _box = param[1];

{if (_box in _x) exitWith {_box call d_fnc_replenishbox}; false} count d_static_ammoboxes;



	
