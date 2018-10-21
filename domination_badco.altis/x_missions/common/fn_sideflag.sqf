// by Xeno
#define THIS_FILE "fn_sideflag.sqf"
#include "..\..\x_setup.sqf"

if !(call d_fnc_checkSHC) exitWith {};

params ["_posi_array"];

private _ran_pos = selectRandom _posi_array;

_posi_array = nil;

if (d_with_ranked) then {d_sm_p_pos = nil};

private _flag = createVehicle [d_flag_pole, _ran_pos, [], 0, "NONE"];
_flag setPos _ran_pos;

_flag setFlagTexture (call d_fnc_getenemyflagtex);

_flag setFlagside d_side_enemy;

sleep 2.123;
["aa", 1, "tracked_apc", 1, "tank", 1, _ran_pos,1,350,true] spawn d_fnc_CreateArmor;
sleep 2.123;
["specops", 2, "allmen", 1, _ran_pos,250,true] spawn d_fnc_CreateInf;

_ran_pos = nil;

sleep 15.111;

d_sm_flag_failed = false;
private _ownerthere = false;

while {true} do {
	call d_fnc_mpcheck;
	private _owner = flagOwner _flag;
	
	if (!isNull _owner && {isNil {_owner getVariable "d_flagowner"}}) then {
		_ownerthere = true;
		_owner setVariable ["d_flagowner", _owner addMPEventHandler ["MPKilled", {if (!isNil "d_sm_flag_failed") then {d_sm_flag_failed = true}}]];
	};

	if (!isNull _owner && {(_owner distance2D d_FLAG_BASE < 40)}) exitWith {
		if (d_with_ranked) then {
			[missionNamespace, ["d_sm_p_pos", getPosATL d_FLAG_BASE]] remoteExecCall ["setVariable", [0, -2] select isDedicated];
		};
		_flag setFlagOwner objNull;
		if (!d_sm_resolved) then {
			d_sm_winner = 2;
		};
		d_sm_resolved = true;
		if (d_IS_HC_CLIENT) then {
			[missionNamespace, ["d_sm_winner", d_sm_winner]] remoteExecCall ["setVariable", 2];
			[missionNamespace, ["d_sm_resolved", true]] remoteExecCall ["setVariable", 2];
		};
	};
	
	if (d_sm_flag_failed  || {_ownerthere && {isNil "_owner" || {isNull _owner}}}) exitWith {
		_flag setFlagOwner objNull;
		if (!d_sm_resolved) then {
			d_sm_winner = -900;
		};
		d_sm_resolved = true;
		if (d_IS_HC_CLIENT) then {
			[missionNamespace, ["d_sm_winner", d_sm_winner]] remoteExecCall ["setVariable", 2];
			[missionNamespace, ["d_sm_resolved", true]] remoteExecCall ["setVariable", 2];
		};
		if (!isNil "_owner" && {!isNull _owner}) then {
			_owner removeMPEventHandler ["MPKilled", _owner getVariable "d_flagowner"];
			_owner setVariable ["d_flagowner", nil];
		};
	};
	sleep 5.123;
	if (d_sm_resolved) exitWith {};
};

deleteVehicle _flag;

d_sm_flag_failed = nil;