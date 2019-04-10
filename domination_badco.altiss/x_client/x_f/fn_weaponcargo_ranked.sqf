// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_weaponcargo_ranked.sqf"
#include "..\..\x_setup.sqf"

waitUntil {!d_arsenal_opened};

private _rank = rank player;
private _vec = player;

_vec setVariable ["bis_addVirtualWeaponCargo_cargo", [[], [], [], []]];		

private _helperar = [];

_helperar append (d_misc_store getVariable (_rank + "_RIFLES"));
__TRACE_1("RIFLES","_helperar")

_helperar append (d_misc_store getVariable (_rank + "_LAUNCHERS"));		
__TRACE_1("LAUNCHERS","_helperar")

_helperar append (d_misc_store getVariable (_rank + "_PISTOLS"));
__TRACE_1("PISTOLS","_helperar")

[_vec, _helperar, false, false] call BIS_fnc_addVirtualWeaponCargo;

[_vec, bis_fnc_arsenal_data # 22, false, false] call BIS_fnc_addVirtualMagazineCargo;
[_vec, bis_fnc_arsenal_data # 23, false, false] call BIS_fnc_addVirtualMagazineCargo;
[_vec, bis_fnc_arsenal_data # 26, false, false] call BIS_fnc_addVirtualMagazineCargo;

_helperar = [];

_helperar append (d_misc_store getVariable (_rank + "_OPTICS"));
__TRACE_1("OPTICS","_helperar")

_helperar append (d_misc_store getVariable (_rank + "_MUZZLES"));
__TRACE_1("MUZZLES","_helperar")

_helperar append (d_misc_store getVariable (_rank + "_UNIFORMS"));
__TRACE_1("UNIFORMS","_helperar")

_helperar append (d_misc_store getVariable (_rank + "_ITEMS"));
__TRACE_1("ITEMS","_helperar")

[_vec, _helperar, false, false] call BIS_fnc_addVirtualItemCargo;

[_vec, bis_fnc_arsenal_data # 5, false, false] call BIS_fnc_addVirtualBackpackCargo;
