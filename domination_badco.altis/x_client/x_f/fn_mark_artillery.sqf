// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_mark_artillery.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

private _lt = laserTarget player;

__TRACE_1("","_lt")

if (isNil "_lt" || {isNull _lt}) exitWith {
	// laser target not valid
};

private _pos_lt = getPos _lt;
_pos_lt set [2, 0];

__TRACE_1("","_pos_lt")

#ifdef __DEBUG__
_arrow = "Sign_Arrow_Large_F" createVehicleLocal [0,0,0];
_arrow setPos _pos_lt;
#endif

if (player distance2D _pos_lt < 10) exitWith {
	systemChat (localize "STR_DOM_MISSIONSTRING_1529");
};

["d_temp_mark_arty_marker", _pos_lt, "ICON", d_color_m_marker, [1, 1], name player, 0, d_arty_m_marker] call d_fnc_CreateMarkerLocal;

d_ari_type = "";
d_ari_salvos = 1;
createDialog "d_MarkArtilleryDialog";

waitUntil {d_ari_type != "" || {!d_markarti_dialog_open || {!alive player || {player getVariable ["xr_pluncon", false] || {player getVariable ["ace_isunconscious", false]}}}}};

deleteMarkerLocal "d_temp_mark_arty_marker";
if (!alive player || {player getVariable ["xr_pluncon", false] || {player getVariable ["ace_isunconscious", false]}}) exitWith {
	if (d_markarti_dialog_open) then {closeDialog 0};
};

__TRACE_2("","d_ari_type","d_ari_salvos")

if (d_ari_type != "") then {
	[player, _pos_lt, name player, d_ari_type, d_ari_salvos] remoteExecCall ["d_fnc_at_serv", 2];

	systemChat format [localize "STR_DOM_MISSIONSTRING_1523", mapGridPosition _pos_lt];
} else {
	[playerSide, "HQ"] sideChat (localize "STR_DOM_MISSIONSTRING_1525");
};
