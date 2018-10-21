// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_getranpointcircle.sqf"
#include "..\..\x_setup.sqf"

// get a random point inside a circle
// parameters:
// center position, radius of the circle
// example: _random_point = [position trigger1, 200] call d_fnc_GetRanPointCircle;
__TRACE_1("","_this")
params ["_rcenter", "_rradius", ["_mindist", 2]];
__TRACE_2("","_rcenter","_rradius")
private _ret_val = [];
for "_co" from 0 to 150 do {
	private _isFlat = (_rcenter getPos [random _rradius, random 360]) isFlatEmpty [
		_mindist,	//--- Minimal distance from another object
		-1,				//--- If 0, just check position. If >0, select new one // 0
		0.7,				//--- Max gradient
		4,	//--- Gradient area
		0,				//--- 0 for restricted water, 2 for required water,
		false,				//--- True if some water can be in 25m radius
		objNull			//--- Ignored object
	];
	__TRACE_1("","_isFlat")
	if !(_isFlat isEqualTo []) exitWith {
		_ret_val = ASLToATL _isFlat;
	};
};
__TRACE_1("","_ret_val")
_ret_val