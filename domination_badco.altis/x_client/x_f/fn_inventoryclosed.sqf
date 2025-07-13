// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_inventoryclosed.sqf"
#include "..\..\x_setup.sqf"

if (player getVariable ["d_isinprison", false]) exitWith {};

params ["_unit", "_container"];

if ((!(d_string_player in d_is_engineer)) && {!(_container isKindOf "GroundWeaponHolder")}) exitWith {

  private _exit = false;
  private _thisContainer = objNull;
  {
    _thisContainer = _x;
    {
      if (_x in d_explosives) exitWith {
        _exit = true;
        deleteVehicle _thisContainer;
      };
    } foreach itemCargo _thisContainer;
    if (_exit) exitWith {};
  } foreach ((player nearObjects ["GroundWeaponHolder", 2]) select {local _x});
  
};

__TRACE_1("","_this")

/*
private _box = param[1];

{if (_box in _x) exitWith {_box call d_fnc_replenishbox}; false} count d_static_ammoboxes;

*/



	
