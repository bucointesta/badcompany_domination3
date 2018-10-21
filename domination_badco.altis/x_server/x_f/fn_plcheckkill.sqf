// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_plcheckkill.sqf"
#include "..\..\x_setup.sqf"

params ["_killed", "_killer", "_istigator"];

if (!isServer) exitWith {};

//subtract point when the player got killed by enemy
if (d_with_ranked && {d_sub_kill_points != 0 && {!(side (group _killer) == side (group _killed))}}) then {
	_killed addScore d_sub_kill_points;
};

/*TEAMKILLING
if it is not a suicide and the killer is another player and killer and killed were not in the same vehicle, and they were on the same side 
	then
		assign to variable _par the killed player's array, extract the name (if exist) and assign it to _namep, otherwise use "An allied"
		assign to variable _par1 the killer player's array, extract the name (if exist) and assign it to _namek, otherwise use "An allied"
		add 1 to his teamkilling count and check if he did enough tk to be kicked (call TKKickCheck -params-> killer's name, killed's name, killer's object)
		display a message on each client (d_fnc_unit_tk -params-> killed's name, killer's name)
*/

if (!isNull _killer && {isPlayer _killer && {vehicle _killer != vehicle _killed}}) then {
	__TRACE_1("_killer",_killer)
	__TRACE_1("_istigator",_istigator)
	if ((!(isNil "_istigator")) && {!(isNull _istigator)}) then {_killer = _istigator};
	private _par = d_player_store getVariable (getPlayerUID _killed);
	__TRACE_1("_killed",_par)
	private _namep = [_par select 6, "An allied"] select (isNil "_par");
	private _par = d_player_store getVariable (getPlayerUID _killer);
	__TRACE_1("_killer",_par)
	private _namek = [_par select 6, "An allied"] select (isNil "_par");
	[_namek, _namep, _killer] call d_fnc_TKKickCheck;
	[_namep, _namek] remoteExecCall ["d_fnc_unit_tk", [0, -2] select isDedicated];
};
