// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_checkdriver_wreck.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

params ["_vec", "_position", "_enterer"];

__TRACE_1("","_this")

if (_enterer != player) exitWith {};

private _exit_it = false;


if (!_exit_it && {_position == "driver"}) then {
	if (d_with_ranked && {rankId player < (d_wreck_lift_rank call d_fnc_GetRankIndex)}) exitWith {
		[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_179a", rank player, d_wreck_lift_rank call d_fnc_GetRankString];
		_exit_it = true;
	};
	hintSilent composeText[parseText("<t color='#f0a7ff31' size='1.5'>" + (localize "STR_DOM_MISSIONSTRING_659") + "</t>"), lineBreak,lineBreak, localize "STR_DOM_MISSIONSTRING_1744"];
	[_vec] spawn d_fnc_wreck_transport;
};

if (_exit_it) then {
	_enterer action ["getOut", _vec];
};