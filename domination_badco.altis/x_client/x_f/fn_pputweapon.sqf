// by Bucointesta
//#define __DEBUG__
#define THIS_FILE "fn_pputweapon.sqf"
#include "..\..\x_setup.sqf"

/*

//if (isDedicated) exitWith {};
if (player getVariable ["d_isinprison", false]) exitWith {};

__TRACE_1("","_this")

private _container = param [1];
private _item = param [2];
private _exit = false;

diag_log format ["container %1", _container];

{
	if (_container == (backpackContainer _x)) exitWith {[_x, player, _item] remoteExecCall ["d_fnc_ptakeweapon", _x]; if (!([_x, _item] call d_fnc_checkitem)) then {call d_fnc_retrieve_layoutgear}};
} forEach (allPlayers - entities "HeadlessClient_F");

*/

params ["_unit", "_container", "_item"];

private _parent = objectParent _container;

if ((!local _parent) && {_parent isKindOf "CAManBase"}) then {
	
	[_parent, _container, _item] remoteExecCall ["d_fnc_ptakeweapon", _parent, false];

};