// by Xeno
#define THIS_FILE "fn_plcheckkill.sqf"
#include "..\..\x_setup.sqf"

if (!isServer) exitWith {};

params ["_killed", "", "_killer"];

private _vkiller = vehicle _killer;
private _vkilled = vehicle _killed;

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

if (!isNull _killer && {(_killer call d_fnc_isplayer) && {_vkiller != _vkilled}}) then {
	
	// Hunter: no need to use the store for this...?
	/*
	private _par = d_player_store getVariable (getPlayerUID _killed);
	__TRACE_1("_killed",_par)
	private _namep = [_par # 6, "Unknown"] select (isNil "_par");
	private _par = d_player_store getVariable (getPlayerUID _killer);
	__TRACE_1("_killer",_par)
	private _namek = [_par # 6, "Unknown"] select (isNil "_par");
	*/	
	private _namep = name _killed;
	private _namek = name _killer;
	
	// try to ignore deaths from people running into aircraft...
	if (
		(_vkiller isKindOf "Air")
		&& {_vkilled == _killed}
		&& {(driver _vkiller) == _killer}
		&& {(_vkiller distance _killed) < 20}
		&& {((count (_vkiller weaponsTurret [-1])) == 0) || {(needReload _vkiller) == 0} || {_killed getVariable ["AR_Is_Rappelling", false]} || {((getPos _killed) select 2) > 20}}
	) exitWith {};
	
	private _baseKill = (_killed distance2D d_flag_base) < 700;
		
	private _baseRamKill = false;
	
	if ((_vkiller iskindOf "LandVehicle") && {_killer == (driver _vkiller)} && {_baseKill} && {
		// tolerate up to 2 roadkill tk's, 3rd one is punished
		if (_vkilled == _killed) then {
			private _varStr = (getPlayerUID _killer) + "_runOverKillCount";
			missionNamespace setVariable [_varStr, (missionNamespace getVariable [_varStr, 0]) + 1];
			if ((missionNamespace getVariable _varStr) > 2) then {
				_baseRamKill = true;
				false
			} else {
				true
			}
		} else {
			_baseRamKill = true;
			false
		}
	}) then {
		_baseKill = false;
	};
	[_namep, _namek] remoteExecCall ["d_fnc_unit_tk", [0, -2] select isDedicated];
	[_namek, _namep, _killer, _baseKill, _baseRamKill] call d_fnc_TKKickCheck;	
};
