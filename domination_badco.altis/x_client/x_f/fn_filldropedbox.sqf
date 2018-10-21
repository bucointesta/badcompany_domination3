// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_filldropedbox.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

params ["_box", "_boxcargo"];

_box setVariable ["d_player_ammobox", true];

clearMagazineCargo _box;
clearWeaponCargo _box;
clearItemCargo _box;
clearBackpackCargo _box;

[_box, _boxcargo select 0, false, false] call BIS_fnc_addVirtualWeaponCargo;
[_box, _boxcargo select 1, false, false] call BIS_fnc_addVirtualMagazineCargo;
[_box, _boxcargo select 2, false, false] call BIS_fnc_addVirtualItemCargo;
[_box, _boxcargo select 3, false, false] call BIS_fnc_addVirtualBackpackCargo;

d_all_p_a_boxes pushBack [_box, [1,1,0,0], localize "STR_DOM_MISSIONSTRING_1585"]; // yellow, Text "Virtual Arsenal"
__TRACE_1("","d_all_p_a_boxes")
