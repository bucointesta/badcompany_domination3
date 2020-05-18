// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_retrieve_respawngear.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

private _lg = player getVariable "d_respawngear";
if (!isNil "_lg") then {
	player setUnitLoadout [_lg, false];
};

if (str player in d_badcompany) then {
	[] spawn {
		sleep 3;
		player remoteExecCall ["d_fnc_badco_uniform",-2,false];
	};	
};

