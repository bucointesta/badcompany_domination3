// by Xeno, A.Renton, K.Hunter
//#define __DEBUG__
#define THIS_FILE "fn_ptakeweapon.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};
if (player getVariable ["d_isinprison", false]) exitWith {};

__TRACE_1("","_this")

params ["_unit", "_container", "_item"];

if (_unit != player) exitWith {};
if (item_check_isInArsenal) exitWith {};

if (d_without_nvg == 0 && {_item call d_fnc_isnvgoggles}) then {
	_unit unlinkItem _item;
};

_item = [_item] call BIS_fnc_baseWeapon;

_disallowedItemFound = false;

if (!(_item in restrictions_allAllowedItems)) then {

	debug_forbidden_item = _item;
	_disallowedItemFound = true;
	
	player removeItems _item;
	player unlinkItem _item;
	player removeMagazines _item;
	player removeWeapon _item;
	player removePrimaryWeaponItem _item;
	player removeSecondaryWeaponItem _item;
	player removeHandgunItem _item;
	
	if ((headgear player) == _item) exitWith {
		removeHeadgear player;
	};
	if ((headgear player) == _item) exitWith {
		removeHeadgear player;
	};
	if ((goggles player) == _item) exitWith {
		removeGoggles player;
	};
	if ((uniform player) == _item) exitWith {
		removeUniform player;
	};
	if ((vest player) == _item) exitWith {
		removeVest player;
	};
	if ((backpack player) == _item) exitWith {
		//some problem with removing backpacks... try a delay
		_item spawn {
			sleep 1;
			waitUntil {(backpack player) == _this};
			removeBackpack player;
		};
	};

};

if (_disallowedItemFound) then {
	hint "You cannot use this item with your chosen role.";
} else {
	if ((uniform player) == _item) exitWith {
		{
			[player, uniformContainer player, _x] call d_fnc_ptakeweapon;
		} foreach (uniformItems player);
	};
	if ((vest player) == _item) exitWith {
		{
			[player, vestContainer player, _x] call d_fnc_ptakeweapon;
		} foreach (vestItems player);
	};
	if ((backpack player) == _item) exitWith {
		_item spawn {
			sleep 1;
			waitUntil {(backpack player) == _this};
			{
				[player, backpackContainer player, _x] call d_fnc_ptakeweapon;
			} foreach (backpackItems player);
		};
	};
};

// disable remote connecting to base AA
{
	player disableUAVConnectability [_x, true];
} foreach d_baseAAremotevics;

if (!d_with_ranked) exitWith {};

private _cfgi = configFile>>"CfgWeapons">>_item;

if (!isClass(_cfgi)) exitWith {
	__TRACE_1("not of type weapon","_item")
};

_item = toUpper _item;

private _rank = rank player;
__TRACE_1("","_rank")
private _isvalid = _item in (d_misc_store getVariable (_rank + "_ONED"));

private _exit_it = false;
if (!_isvalid && {!(_item in d_non_check_items)}) then {
	private _prw = player getVariable "d_pprimweap";
	if (_prw != primaryWeapon player) then {
		player removeWeapon (primaryWeapon player);
		player addWeapon _prw;
		
		private _secits = player getVariable "d_pprimweapitems";
		if !(primaryWeaponItems player isEqualTo _secits) then {
			removeAllPrimaryWeaponItems player;
			{player addPrimaryWeaponItem _x} forEach (_secits select {_x != ""});
		};
		
		_exit_it = true;
	} else {
		private _psw = player getVariable "d_psecweap";
		if (_psw != secondaryWeapon player) then {
			player removeWeapon (secondaryWeapon player);
			player addWeapon _psw;
			
			private _secits = player getVariable "d_psecweapitems";
			if !(secondaryWeaponItems player isEqualTo _secits) then {
				// removeAllSecondaryWeaponItems player; // this command does not exist in A3 even after 3 year...
				{
					player removeSecondaryWeaponItem _x;
				} forEach (secondaryWeaponItems player);
				{player addSecondaryWeaponItem _x} forEach (_secits select {_x != ""});
			};
			
			_exit_it = true;
		} else {
			private _phw = player getVariable "d_phandgweap";
			if (_phw != handgunWeapon player) then {
				player removeWeapon (handgunWeapon player);
				player addWeapon _phw;
				
				private _secits = player getVariable "d_phandgweapitems";
				if !(handgunItems player isEqualTo _secits) then {
					removeAllHandgunItems player;
					{player addHandgunItem _x} forEach (_secits select {_x != ""});
				};
				
				_exit_it = true;
			};
		};
	};
};

if (_exit_it) exitWith {
	(_this select 1) addItemCargo [_item, 1];
	systemChat format [localize "STR_DOM_MISSIONSTRING_1564", _rank, getText(_cfgi>>"displayname")];
};

call d_fnc_store_rwitems;
