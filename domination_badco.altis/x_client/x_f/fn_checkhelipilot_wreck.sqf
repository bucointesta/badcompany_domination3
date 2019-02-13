// by Xeno
#define THIS_FILE "fn_checkhelipilot_wreck.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

params ["_vec", "_position", "_enterer"];

if (_enterer != player) exitWith {};

private _exit_it = false;

#ifdef __TT__
private _d_side = _vec getVariable "d_side";
if (!isNil "_d_side") then {
	if (d_player_side == blufor && {_d_side == opfor}) then {
		_exit_it = true;
		[localize "STR_DOM_MISSIONSTRING_173", "SIDE"] call d_fnc_HintChatMsg;
	} else {
		if (d_player_side == opfor && {_d_side == blufor}) then {
			_exit_it = true;
			[localize "STR_DOM_MISSIONSTRING_174", "SIDE"] call d_fnc_HintChatMsg;
		};
	};
};
#endif

if (!_exit_it && {_position == "driver"}) then {
	if (d_with_ranked && {rankId player < (d_wreck_lift_rank call d_fnc_GetRankIndex)}) exitWith {
		[playerSide, "HQ"] sideChat format [localize "STR_DOM_MISSIONSTRING_179", rank player, d_wreck_lift_rank call d_fnc_GetRankString];
		_exit_it = true;
	};
	//Hunter: Not needed since already handled by getInMan EH
	/*if (d_pilots_only == 0 && {!([str _enterer,_vec,_vec getvariable ["d_vec",0]] call d_fnc_isPilotCheck)}) exitWith {
		_exit_it = true;
	};*/
	if (d_chophud_on) then {
		player setVariable ["d_hud_id", _vec addAction [format ["<t color='#7F7F7F'>%1</t>", localize "STR_DOM_MISSIONSTRING_176"], {_this call d_fnc_sethud},0,-1,false]];
	} else {
		player setVariable ["d_hud_id", _vec addAction [format ["<t color='#7F7F7F'>%1</t>", localize "STR_DOM_MISSIONSTRING_177"], {_this call d_fnc_sethud},1,-1,false]];
	};
	[_vec] spawn d_fnc_helilift_wreck;
};

if (_exit_it) then {
	_enterer action ["getOut", _vec];
};