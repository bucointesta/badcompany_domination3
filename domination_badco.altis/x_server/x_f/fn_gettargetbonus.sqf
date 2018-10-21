// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_gettargetbonus.sqf"
#include "..\..\x_setup.sqf"

if (!isServer) exitWith {};

private _cur_tar_obj = missionNamespace getVariable format ["d_target_%1", d_current_target_index];

sleep 1.012;

private _vectypetouse = "";

if (!isNil "_cur_tar_obj" && {!isNull _cur_tar_obj}) then {
	private _vectypesv = _cur_tar_obj getVariable "d_bonusvec";
	if (!isNil "_vectypesv") then {
		_vectypetouse = _vectypesv;
	};
};
if (_vectypetouse == "") then {
	_vectypetouse = selectRandom d_mt_bonus_vehicle_array;
};
private _vec = createVehicle [_vectypetouse, d_bonus_create_pos, [], 0, "NONE"];
if (d_database_found) then {
	d_bonus_vecs_db pushBack _vec;
};
if (unitIsUAV _vec) then {
	createVehicleCrew _vec;
	_vec allowCrewInImmobile true;
};
private _endpos = [];
private _dir = 0;
if (_vec isKindOf "Air") then {
	_endpos = (d_bonus_air_positions select d_bap_counter) select 0;
	_dir = (d_bonus_air_positions select d_bap_counter) select 1;
	d_bap_counter = d_bap_counter + 1;
	if (d_bap_counter > (count d_bonus_air_positions - 1)) then {d_bap_counter = 0};
} else {
	_endpos = (d_bonus_vec_positions select d_bvp_counter) select 0;
	_dir = (d_bonus_vec_positions select d_bvp_counter) select 1;
	d_bvp_counter = d_bvp_counter + 1;
	if (d_bvp_counter > (count d_bonus_vec_positions - 1)) then {d_bvp_counter = 0};
};
_vec setDir _dir;
_vec setVehiclePosition [_endpos, [], 0, "NONE"];
_vec addMPEventHandler ["MPKilled", {if (isServer) then {_this call d_fnc_bonusvecfnc}}];

_vec addEventHandler ["getIn", {
	private _ma = (param [0]) getVariable "d_abandoned_ma";
	if (!isNil "_ma") then {
		deleteMarker _ma;
		(param [0]) setVariable ["d_abandoned_ma", nil];
	};
}];

_vec addEventHandler ["getOut", {
	params ["_vec"];
	if (alive _vec && {{alive _x} count crew _vec == 0 && {_vec distance2D d_FLAG_BASE > 800}}) then {
		private _mname = format ["%1_ab%2", _vec, time];
		[_mname, _vec, "ICON", "ColorBlue", [1,1], format [localize "STR_DOM_MISSIONSTRING_1566", [typeOf _vec, "CfgVehicles"] call d_fnc_GetDisplayName], 0, "mil_triangle"] call d_fnc_CreateMarkerGlobal;
		_vec setVariable ["d_abandoned_ma", _mname];
	};
}];
_vec addMPEventhandler ["MPKilled", {_this select 0 setFuel 0}];

call d_fnc_targetclearm;

_vectypetouse remoteExec ["d_fnc_target_clear_client", [0, -2] select isDedicated];
