// by duda123
//#define __DEBUG__
#define THIS_FILE "fn_getcorners.sqf"
#include "..\..\x_setup.sqf"

params ["_vec"];
private _cOfMass = getCenterOfMass _vec;
(boundingBoxReal _vec) params ["_p1", "_p2"];
private _wOffset = (((abs ((_p2 select 0) - (_p1 select 0))) / 2) - abs ( _cOfMass select 0 )) * 0.75;
private _lOffset = (((abs ((_p2 select 1) - (_p1 select 1))) / 2) - abs (_cOfMass select 1 )) * 0.75;
[[(_cOfMass select 0) + _wOffset, (_cOfMass select 1) - _lOffset, _cOfMass select 2], [(_cOfMass select 0) - _wOffset, (_cOfMass select 1) - _lOffset, _cOfMass select 2],
[(_cOfMass select 0) + _wOffset, (_cOfMass select 1) + _lOffset, _cOfMass select 2], [(_cOfMass select 0) - _wOffset, (_cOfMass select 1) + _lOffset, _cOfMass select 2]];