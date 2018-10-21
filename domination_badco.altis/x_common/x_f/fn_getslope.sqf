//#define __DEBUG__
#define THIS_FILE "fn_getslope.sqf"
#include "..\..\x_setup.sqf"

// from warfare
// Returns an average slope value of terrain within passed radius.
// a little bit modified. no need to create a "global" logic, local is enough, etc
// parameters: position, radius
// example: _slope = [the_pos, the_radius] call d_fnc_GetSlope;
params ["_pos", "_radius"];
d_SlopeObject setPos _pos;
private _cheight = getPosASL d_SlopeObject select 2;
private _height = 0; private _dir = 0;
for "_w" from 0 to 7 do {
	private _npos = _pos getPos [_radius, _dir];
	_npos set [2, 0];
	d_SlopeObject setPos _npos;
	_dir = _dir + 45;
	_height = _height + abs (_cheight - (getPosASL d_SlopeObject select 2));
};
_height / 8