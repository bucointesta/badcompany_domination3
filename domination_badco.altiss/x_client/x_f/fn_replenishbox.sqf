// by Bucointesta
//#define __DEBUG__
#define THIS_FILE "fn_replenishbox.sqf"
#include "..\..\x_setup.sqf"

private _box = _this; 
private _obj = "";
private _count = 0;
private _i = 0;

private _objar = getWeaponCargo _box;
private _list = _box getVariable ["weapons",[]];
{
	_i = 0;
	_obj = _x select 0;
	_qty = _x select 1;
	{ 
		if (_x == _obj) exitWith {_qty = _qty - ((_objar select 1) select _i)};
		_i = _i + 1;
	} count (_objar select 0);
	if (_qty > 0) then {_box addWeaponCargoGlobal [_obj, _qty]};
} forEach _list;

_objar = getMagazineCargo _box;
_list = _box getVariable ["magazines",[]];	
{
	_i = 0;
	_obj = _x select 0;
	_qty = _x select 1;
	{ 
		if (_x == _obj) exitWith {_qty = _qty - ((_objar select 1) select _i)};
		_i = _i + 1;
	} count (_objar select 0);
	if (_qty > 0) then {_box addMagazineCargoGlobal [_obj, _qty]};
} forEach _list;
	
_objar = getBackpackCargo _box;
_list = _box getVariable ["backpacks",[]];
{
	_i = 0;
	_obj = _x select 0;
	_qty = _x select 1;
	{ 
		if (_x == _obj) exitWith {_qty = _qty - ((_objar select 1) select _i)};
		_i = _i + 1;
	} count (_objar select 0);
	if (_qty > 0) then {_box addBackpackCargoGlobal [_obj, _qty]};
} forEach _list;

_objar = getItemCargo _box;
_list = _box getVariable ["items",[]];
{
	_i = 0;
	_obj = _x select 0;
	_qty = _x select 1;
	{ 
		if (_x == _obj) exitWith {_qty = _qty - ((_objar select 1) select _i)};
		_i = _i + 1;
	} count (_objar select 0);
	if (_qty > 0) then {_box addItemCargoGlobal [_obj, _qty]};
} forEach _list;


