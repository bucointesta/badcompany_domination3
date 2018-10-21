// by Xeno
#define THIS_FILE "fn_checktrucktrans.sqf"
#include "..\..\x_setup.sqf"

private _enterer = param [2];
if (_enterer != player) exitWith {};

private _do_msg = true;

if (_do_msg) then {
	[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_182");
};
_enterer action ["getOut", param [0]];

