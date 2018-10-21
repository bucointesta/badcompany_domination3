// by Bucointesta
//#define __DEBUG__
#include "..\..\x_setup.sqf"
#define THIS_FILE "fn_createnexttarget.sqf"

if (!isServer) exitWith{};


params ["_trigger", "_objs"];

//open the gate
{
	private _trigcheck = _x select 0;
	private _gate = _x select 1;
	private _door = _x select 2;
	if (_trigger == _trigcheck) then {_gate animate [format["Door_%1_rot",_door], 1]};
} forEach d_entrances;

{
	waitUntil {!(_x inArea _trigger)};
} forEach _objs;

sleep 5;

{
	if (_trigger == _x select 0) then {(_x select 1) animate [format["Door_%1_rot",_x select 2], 0]};		
} forEach d_entrances;
