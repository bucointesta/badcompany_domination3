// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_inventoryopened.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};
if (player getVariable ["d_isinprison", false]) exitWith {};

__TRACE_1("","_this")

call d_fnc_save_layoutgear;

private _box = _this select 1;

if (_box getVariable ["d_player_ammobox", false]) then {
	_box spawn {
		if (!d_with_ranked) then {
			if (!d_with_ace) then {
				["Open", true] call bis_fnc_arsenal;
			} else {
				[player, player, true] call ace_arsenal_fnc_openBox;
			};
		} else {
			["Open", [nil, player]] call bis_fnc_arsenal;
		};
	};
	true
} else {
//Hunter: following was commented out by Xeno
	/*0 spawn {
		private _disp = displayNull;
		waitUntil {_disp = findDisplay 602;!isNull _disp || {!alive player || {player getVariable ["xr_pluncon", false] || {player getVariable ["ace_isunconscious", false]}}}};
		
		if (!alive player || {player getVariable ["xr_pluncon", false] || {player getVariable ["ace_isunconscious", false]}}) exitWith {};
		
		private _ctrl = _disp ctrlCreate ["RscButtonMenu", 12000];
		
		private _sfwh = (safezoneW / safezoneH) min 1.2;
		private _xpos = 14.6 * (_sfwh / 40) + (safezoneX + (safezoneW - _sfwh) / 2);
		private _ypos = 24.3 * ((_sfwh / 1.2) / 25) + (safezoneY + (safezoneH - (_sfwh / 1.2)) / 2);
		private _w = 9.6 * (_sfwh / 40);
		private _h = 1.2 * ((_sfwh / 1.2) / 25);
		
		_ctrl ctrlSetPosition [_xpos, _ypos, _w, _h];
		
		_ctrl ctrlSetText "Repack Magazines";
		
		_ctrl ctrlAddEventHandler ["ButtonClick", {
			hint "Starting to repack magazines...";
			0 spawn d_fnc_repack_mags;
		}];
		
		_ctrl ctrlCommit 0;
	};*/
	false
};
