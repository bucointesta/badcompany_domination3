// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_weaponcargo.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

__TRACE_1("","_this")

params ["_vec"];
clearMagazineCargoGlobal _vec;
clearWeaponCargoGlobal _vec;
clearItemCargoGlobal _vec;
clearBackpackCargoGlobal _vec;

_vec setVariable ["d_player_ammobox", true];

d_all_p_a_boxes pushBack [_vec, [1,1,0,0], "Ammobox"]; // yellow, Text "Virtual Arsenal"
__TRACE_1("","d_all_p_a_boxes")

__TRACE_1("","_vec")

{if (!(_x isEqualto [])) then {_vec addWeaponCargoGlobal _x};} count (d_ammobox_0 getVariable ["weapons",[]]);
{if (!(_x isEqualto [])) then {_vec addMagazineCargoGlobal _x};} count (d_ammobox_0 getVariable ["magazines",[]]);
{if (!(_x isEqualto [])) then {_vec addBackpackCargoGlobal _x};} count (d_ammobox_0 getVariable ["backpacks",[]]);
{if (!(_x isEqualto [])) then {_vec addItemCargoGlobal _x};} count (d_ammobox_0 getVariable ["items",[]]);	
