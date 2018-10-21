// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_getranpointcirclebig.sqf"
#include "..\..\x_setup.sqf"

// get a random point inside a circle for bigger objects
// parameters:
// center position, radius of the circle
// example: _random_point = [position trigger1, 200] call d_fnc_GetRanPointCircleBig;

params ["_center", "_radius"];
private _ret_val = [];
for "_co" from 0 to 99 do {
	_isFlat = (_center getPos [random _radius, random 360]) isFlatEmpty [
		4,	//--- Minimal distance from another object was 9 before
		-1,				//--- If 0, just check position. If >0, select new one // 0
		0.7,				//--- Max gradient
		13,	//--- Gradient area
		0,				//--- 0 for restricted water, 2 for required water,
		false,				//--- True if some water can be in 25m radius
		objNull			//--- Ignored object
	];
	if (!(_isFlat isEqualTo []) && {!isOnRoad _isFlat}) exitWith {
		_ret_val = ASLToATL _isFlat;
	};
};
__TRACE_1("","_ret_val")
_ret_val