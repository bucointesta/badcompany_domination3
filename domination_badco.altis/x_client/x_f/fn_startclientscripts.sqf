// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_startclientscripts.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated || {!alive player || {player getVariable ["xr_pluncon", false] || {player getVariable ["ace_isunconscious", false]}}}) exitWith {};
if (!(d_clientScriptsAr select 0) && {(isMultiplayer && {d_pisadminp}) || {!isMultiplayer}}) then {
	d_clientScriptsAr set [0, true];
	//call d_fnc_isAdmin;
	execFSM "fsms\fn_IsAdmin.fsm";
};
if (!(d_clientScriptsAr select 1) && {!isNil "d_player_autokick_time"}) then {
	if (isNil "d_nomercyendtime") then {
		d_nomercyendtime = time + d_player_autokick_time;
		if (d_player_autokick_time <= 0) exitWith {
			d_clientScriptsAr set [1, true];
			d_player_autokick_time = nil;
			d_nomercyendtime = nil;
		};
	} else {
		if (time >= d_nomercyendtime) exitWith {
			d_clientScriptsAr set [1, true];
			d_player_autokick_time = nil;
			d_nomercyendtime = nil;
		};
		private _vec = vehicle player;
		if (_vec != player && {_vec isKindOf "Air"}) then {
			private _type = toUpper (typeOf _vec);
			if ((_type in d_mt_bonus_vehicle_array || {_type in d_sm_bonus_vehicle_array}) && {player == driver _vec || {player == gunner _vec || {player == commander _vec}}}) then {
		};
	};
};