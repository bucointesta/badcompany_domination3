// by Xeno
#define THIS_FILE "fn_checkveckillblufor.sqf"
#include "..\..\x_setup.sqf"

private _killer = param [1];

if (!isPlayer _killer) exitWith {};

if (side (group _killer) == opfor) then {
	d_points_opfor = d_points_opfor + (d_tt_points select 7);
	
	private _kpar = d_player_store getVariable (getPlayerUID _killer);
	if (isNil "_kpar") exitWith {};
	format [localize "STR_DOM_MISSIONSTRING_516", _kpar select 6, "WEST", "EAST", d_tt_points select 7] remoteExecCall ["systemChat", [0, -2] select isDedicated];
};
