// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_setheight.sqf"
#include "..\..\x_setup.sqf"

// set only height of an object
// parameters: object, height
// example: [unit1, 30] call d_fnc_SetHeight;
private _p = getPosWorld (param [0]);(param [0]) setPos [_p select 0, _p select 1, param [1]]