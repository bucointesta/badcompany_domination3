// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_prespawned.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

player setVariable ["d_isinaction", false];

d_player_in_air = false;

if (d_WithMHQTeleport == 0 && {!isNil "d_fnc_dlgopenx" && {d_WithRevive == 1}}) then {
	d_player_in_base = true;
	call d_fnc_dlgopenx;
};
[1, _this] call d_fnc_playerspawn;

if (!isNil "d_flag_vec" && {!isNull d_flag_vec}) then {
	private _vc = d_flag_vec getVariable ["d_fl_v_kc", 0];
	if (_vc < 4) then {
		_vc = _vc + 1;
		d_flag_vec setVariable ["d_fl_v_kc", _vc];
	} else {
		deleteVehicle d_flag_vec;
	};
};