// by Xeno
#define THIS_FILE "fn_plcheckkill.sqf"
#include "..\..\x_setup.sqf"

if (!isServer) exitWith {};

params ["_killed", "", "_killer"];

if ((d_with_ranked || {d_database_found}) && {d_sub_kill_points != 0 && {side (group _killer) getFriend side (group _killed) < 0.6}}) then {
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

if (d_with_ai) then {	
	if (!isNull _killer && {!(_killer call d_fnc_isplayer) && {side (group _killer) getFriend side (group _killed) >= 0.6 && {vehicle _killed != vehicle _killer}}}) then {
		_leader_killer = leader _killer;
		if (_leader_killer call d_fnc_isplayer) then {
			private _par = d_player_store getVariable (getPlayerUID _killed);
			private _namep = [_par # 6, "Unknown"] select (isNil "_par");
			private _par = d_player_store getVariable (getPlayerUID _leader_killer);
			[[_par # 6, "Unknown"] select (isNil "_par"), _namep, _killer] call d_fnc_TKKickCheck;
		};
	};
};

if (!isNull _killer && {(_killer call d_fnc_isplayer) && {(vehicle _killer) != (vehicle _killed)}}) then {
	private _par = d_player_store getVariable (getPlayerUID _killed);
	__TRACE_1("_killed",_par)
	private _namep = [_par # 6, "Unknown"] select (isNil "_par");
	private _par = d_player_store getVariable (getPlayerUID _killer);
	__TRACE_1("_killer",_par)
	private _namek = [_par # 6, "Unknown"] select (isNil "_par");
	
	private _ramKill = false;
	if (((vehicle _killed) != _killed) && {!alive (vehicle _killed)}) then {
		_ramKill = true;
	}; 
	if ((((vehicle _killer) iskindOf "LandVehicle") || {((vehicle _killer) iskindOf "Ship")}) && {_killer == (driver vehicle _killer)} && {
		// Hunter: notify this as teamkilling  but don't activate tk counter for this one... could still be innocent
		if ((vehicle _killed) == _killed) then {
			true
		} else {
			_ramKill = true;
			false
		}
	}) exitWith {
		[_namep, _namek] remoteExecCall ["d_fnc_unit_tk", [0, -2] select isDedicated];
	};
	[_namep, _namek] remoteExecCall ["d_fnc_unit_tk", [0, -2] select isDedicated];
	[_namek, _namep, _killer, _ramKill] call d_fnc_TKKickCheck;	
};
