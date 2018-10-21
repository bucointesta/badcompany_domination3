// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_addactions.sqf"
#include "..\..\x_macros.sqf"

if (isDedicated || {player == _this}) exitWith {};

private _unit = _this;
if (_unit getVariable ["xr_ReviveAction", -9999] == -9999) then {
	private _id = [
		/* 0 object */						_unit,
		/* 1 action title */				"<t color='#FF0000'>" + (if (xr_pl_can_revive) then {localize "STR_DOM_MISSIONSTRING_923"} else {localize "STR_DOM_MISSIONSTRING_924"}) + " " + name _unit + "</t>",
		/* 2 idle icon */					"\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_revive_ca.paa",
		/* 3 progress icon */				"A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_reviveMedic_ca.paa",
		/* 4 condition to show */			"_this distance2D _target <= 3.5 && {_target getVariable 'xr_pluncon' && {!(_this getVariable 'xr_pisinaction') && {!(_target getVariable 'xr_dragged')}}}",
		/* 5 condition for action */		"true",
		/* 6 code executed on start */		{(name player) remoteExecCall ["xr_fnc_yougetrevivedm", param [0]]},
		/* 7 code executed per tick */		{},
		/* 8 code executed on completion */	{_this call xr_fnc_cdorevive},
		/* 9 code executed on interruption */	{},
		/* 10 arguments */					[_unit],
		/* 11 action duration */			[6, 3] select (player getUnitTrait "medic"),
		/* 12 priority */					-1,
		/* 13 remove on completion */		false,
		/* 14 show unconscious */			false
	] call bis_fnc_holdActionAdd;
	__TRACE_1("id1","_id")
	_unit setVariable ["xr_ReviveAction", _id];
	
	_id = _unit addAction [format ["<t color='#FF0000'>%2 %1</t>", name _unit, localize "STR_DOM_MISSIONSTRING_1704"], {player setVariable ["xr_cursorTarget", param [0]]; 0 spawn xr_fnc_drag}, [], -2, false, false, "", "_target getVariable 'xr_pluncon' && {!(_this getVariable 'xr_pisinaction') && {!(_target getVariable 'xr_dragged')}}", 3];
	__TRACE_1("id2","_id")
	_unit setVariable ["xr_DragAction", _id];
};

xr_uncon_units pushBackUnique _unit;
