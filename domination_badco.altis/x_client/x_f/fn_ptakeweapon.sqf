// by Bucointesta
//#define __DEBUG__
#define THIS_FILE "fn_ptakeweapon.sqf"
#include "..\..\x_setup.sqf"


if (isDedicated) exitWith {};
if (player getVariable ["d_isinprison", false]) exitWith {};

__TRACE_1("","_this")

private _unit = param [0];
if (_unit != player) exitWith {};
private _container = param [1];
private _item = param [2];
private _itemtype = ((_item call BIS_fnc_itemType) select 1);

if ([player, _item] call d_fnc_checkitem) then {
	if (secondaryWeapon player == "launch_NLAW_F") then {
		player removeWeapon "launch_NLAW_F";
		if (backpack player == "") then {
			player addbackpack "B_AssaultPack_khk";
			[player, "launch_NLAW_F", 1] call BIS_fnc_addWeapon;
			removeBackpack player;
		} else {
			if (player canAddItemToBackpack "NLAW_F") then {
				[player, "launch_NLAW_F", 1] call BIS_fnc_addWeapon;
			} else {
				private _objlist = backpackItems player;
				clearAllItemsFromBackpack player;
				[player, "launch_NLAW_F", 1] call BIS_fnc_addWeapon;
				{player addItemToBackpack _x; false} count _objlist;
			};
		};
	};
	if (_itemtype == "Backpack") then {
		{if !([player, _x] call d_fnc_checkitem) exitWith {debug_forbidden_item = _x; call d_fnc_forbidden_item}; false} count (backpackItems player);
	} else {
		if (_itemtype == "Vest") then {
			{if !([player, _x] call d_fnc_checkitem) exitWith {debug_forbidden_item = _x; call d_fnc_forbidden_item}; false} count (vestItems player);
		} else {
			if (_itemtype == "Uniform") then {
				{if !([player, _x] call d_fnc_checkitem) exitWith {debug_forbidden_item = _x; call d_fnc_forbidden_item}; false} count (uniformItems player);
			};
		};
	};
	call d_fnc_allowed_item;
} else {
	debug_forbidden_item = _item; call d_fnc_forbidden_item;
};

if ((_itemtype == "Uniform") && {str _unit in d_badcompany}) exitWith {
	player remoteExecCall ["d_fnc_badco_uniform",-2];
};
