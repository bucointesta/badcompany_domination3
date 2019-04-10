// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_gettargetbonus.sqf"
#include "..\..\x_setup.sqf"

if (!isServer) exitWith {};

private _cur_tar_obj = missionNamespace getVariable format ["d_target_%1", d_current_target_index];

sleep 1.012;

#ifndef __TT__
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
	if (isClass (configFile>>"CfgVehicles">>_vectypetouse>>"Components">>"TransportPylonsComponent")) then {
		_vec remoteExecCall ["d_fnc_addpylon_action", [0, -2] select isDedicated];
	};
};
private _endpos = [];
private _dir = 0;
if (_vec isKindOf "Air") then {
	_endpos = (d_bonus_air_positions # d_bap_counter) # 0;
	_dir = (d_bonus_air_positions # d_bap_counter) # 1;
	d_bap_counter = d_bap_counter + 1;
	if (d_bap_counter > (count d_bonus_air_positions - 1)) then {d_bap_counter = 0};
} else {
	_endpos = (d_bonus_vec_positions # d_bvp_counter) # 0;
	_dir = (d_bonus_vec_positions # d_bvp_counter) # 1;
	d_bvp_counter = d_bvp_counter + 1;
	if (d_bvp_counter > (count d_bonus_vec_positions - 1)) then {d_bvp_counter = 0};
	_vec setVariable ["d_liftit", true, true];
};
_vec setDir _dir;
_vec setVehiclePosition [_endpos, [], 0, "NONE"];
_vec addMPEventHandler ["MPKilled", {if (isServer) then {_this call d_fnc_bonusvecfnc}}];
#else
private _vectypetouse_w = "";
private _vectypetouse_e = "";
private _vectypetouse_w_temp = "";
private _vectypetouse_e_temp = "";

if (!isNil "_cur_tar_obj" && {!isNull _cur_tar_obj}) then {
	private _vectypesv = _cur_tar_obj getVariable "d_bonusvec_w";
	if (!isNil "_vectypesv") then {
		_vectypetouse_w_temp = _vectypesv;
	};
	private _vectypesv = _cur_tar_obj getVariable "d_bonusvec_e";
	if (!isNil "_vectypesv") then {
		_vectypetouse_e_temp = _vectypesv;
	};
};

if (_vectypetouse_w_temp == "") then {
	_vectypetouse_w_temp = selectRandom (d_mt_bonus_vehicle_array # 0);
};
if (_vectypetouse_e_temp == "") then {
	_vectypetouse_e_temp = selectRandom (d_mt_bonus_vehicle_array # 1);
};

private _vec = objNull;
private _vec2 = objNull;
private ["_d_bonus_air_positions", "_d_bonus_air_positions2", "_d_bvp_counter", "_d_bvp_counter2", "_d_bap_counter", "_d_bap_counter2", "_d_bonus_vec_positions", "_d_bonus_vec_positions2"];

if (d_mt_winner == 1) then {
	_vectypetouse_w = _vectypetouse_w_temp;
	_vec = createVehicle [_vectypetouse_w, d_bonus_create_pos_w, [], 0, "NONE"];
	if (d_database_found) then {
		d_bonus_vecs_db_w pushBack _vec;
	};
	_vec setVariable ["D_VEC_SIDE", 2];
	_d_bonus_air_positions = d_bonus_air_positions_w;
	_d_bap_counter = d_bap_counter_w;
	_d_bonus_vec_positions = d_bonus_vec_positions_w;
	_d_bvp_counter = d_bvp_counter_w;
} else {
	if (d_mt_winner == 2) then {
		_vectypetouse_e = _vectypetouse_e_temp;
		_vec = createVehicle [_vectypetouse_e, d_bonus_create_pos_e, [], 0, "NONE"];
		if (d_database_found) then {
			d_bonus_vecs_db_e pushBack _vec;
		};
		_vec setVariable ["D_VEC_SIDE", 1];
		_d_bonus_air_positions = d_bonus_air_positions_e;
		_d_bap_counter = d_bap_counter_e;
		_d_bonus_vec_positions = d_bonus_vec_positions_e;
		_d_bvp_counter = d_bvp_counter_e;
	} else {
		_vectypetouse_w = _vectypetouse_w_temp;
		_vectypetouse_e = _vectypetouse_e_temp;
		_vec = createVehicle [_vectypetouse_w, d_bonus_create_pos_w, [], 0, "NONE"];
		if (d_database_found) then {
			d_bonus_vecs_db_w pushBack _vec;
		};
		_vec2 = createVehicle [_vectypetouse_e, d_bonus_create_pos_e, [], 0, "NONE"];
		if (d_database_found) then {
			d_bonus_vecs_db_e pushBack _vec;
		};
		_vec setVariable ["D_VEC_SIDE", 2];
		_vec2 setVariable ["D_VEC_SIDE", 1];
		_d_bonus_air_positions = d_bonus_air_positions_w;
		_d_bonus_air_positions2 = d_bonus_air_positions_e;
		_d_bap_counter = d_bap_counter_w;
		_d_bap_counter2 = d_bap_counter_e;
		_d_bonus_vec_positions = d_bonus_vec_positions_w;
		_d_bonus_vec_positions2 = d_bonus_vec_positions_e;
		_d_bvp_counter = d_bvp_counter_w;
		_d_bvp_counter2 = d_bvp_counter_e;
	};
};

private _endpos = [];
private _dir = 0;
if (_vec isKindOf "Air") then {
	_endpos = (_d_bonus_air_positions # _d_bap_counter) # 0;
	_dir = (_d_bonus_air_positions # _d_bap_counter) # 1;
	switch (d_mt_winner) do {
		case 1: {
			d_bap_counter_w = d_bap_counter_w + 1;
			if (d_bap_counter_w > (count d_bonus_air_positions_w - 1)) then {d_bap_counter_w = 0};
		};
		case 2: {
			d_bap_counter_e = d_bap_counter_e + 1;
			if (d_bap_counter_e > (count d_bonus_air_positions_e - 1)) then {d_bap_counter_e = 0};
		};
		case 3: {
			d_bap_counter_w = d_bap_counter_w + 1;
			if (d_bap_counter_w > (count d_bonus_air_positions_w - 1)) then {d_bap_counter_w = 0};
			d_bap_counter_e = d_bap_counter_e + 1;
			if (d_bap_counter_e > (count d_bonus_air_positions_e - 1)) then {d_bap_counter_e = 0};
		};
	};
} else {
	_endpos = (_d_bonus_vec_positions # _d_bvp_counter) # 0;
	_dir = (_d_bonus_vec_positions # _d_bvp_counter) # 1;
	switch (d_mt_winner) do {
		case 1: {
			d_bvp_counter_w = d_bvp_counter_w + 1;
			if (d_bvp_counter_w > (count d_bonus_vec_positions_w - 1)) then {d_bvp_counter_w = 0};
		};
		case 2: {
			d_bvp_counter_e = d_bvp_counter_e + 1;
			if (d_bvp_counter_e > (count d_bonus_vec_positions_e - 1)) then {d_bvp_counter_e = 0};
		};
		case 3: {
			d_bvp_counter_w = d_bvp_counter_w + 1;
			if (d_bvp_counter_w > (count d_bonus_vec_positions_w - 1)) then {d_bvp_counter_w = 0};
			d_bvp_counter_e = d_bvp_counter_e + 1;
			if (d_bvp_counter_e > (count d_bonus_vec_positions_e - 1)) then {d_bvp_counter_e = 0};
		};
	};
	_vec setVariable ["d_liftit", true, true];
};

if (!isNull _vec2) then {
	if (_vec2 isKindOf "Air") then {
		_endpos2 = (_d_bonus_air_positions2 # _d_bap_counter2) # 0;
		_dir2 = (_d_bonus_air_positions2 # _d_bap_counter2) # 1;
	} else {
		_endpos2 = (_d_bonus_vec_positions2 # _d_bvp_counter2) # 0;
		_dir2 = (_d_bonus_vec_positions2 # _d_bvp_counter2) # 1;
		_vec2 setVariable ["d_liftit", true, true];
	};
};

_vec setVehiclePosition [_endpos, [], 0, "NONE"];
_vec setDir _dir;
_vec setVariable ["d_WreckMaxRepair", "d_WreckMaxRepair", true];
_vec addMPEventHandler ["MPKilled", {if (isServer) then {(_this # 0) execFSM "fsms\Wreckmarker.fsm"}}];
if (!isNull _vec2) then {
	_vec2 setDir _dir2;
	_vec2 setVehiclePosition [_endpos2, [], 0, "NONE"];
	_vec2 setVariable ["d_WreckMaxRepair", "d_WreckMaxRepair", true];
	_vec2 addMPEventHandler ["MPKilled", {if (isServer) then {(_this # 0) execFSM "fsms\Wreckmarker.fsm"}}];
};
#endif

_vec addEventHandler ["getIn", {
	private _ma = (_this select 0) getVariable "d_abandoned_ma";
	if (!isNil "_ma") then {
		deleteMarker _ma;
		(_this select 0) setVariable ["d_abandoned_ma", nil];
	};
}];

_vec addEventHandler ["getOut", {
	params ["_vec"];
#ifndef __TT__
	if (alive _vec && {(crew _vec) findIf {alive _x} == -1 && {_vec distance2D d_FLAG_BASE > 800}}) then {
#else
	private _vside = _vec getVariable "D_VEC_SIDE";
	if (alive _vec && {(crew _vec) findIf {alive _x} == -1 && {_vside == 2 && {_vec distance2D d_WFLAG_BASE > 800} || {_vside == 1 && {_vec distance2D d_EFLAG_BASE > 800}}}}) then {
#endif
		private _mname = format ["%1_ab%2", _vec, time];
		[_mname, _vec, "ICON", "ColorBlue", [1,1], format [localize "STR_DOM_MISSIONSTRING_1566", [typeOf _vec, "CfgVehicles"] call d_fnc_GetDisplayName], 0, "mil_triangle"] call d_fnc_CreateMarkerGlobal;
		_vec setVariable ["d_abandoned_ma", _mname];
#ifdef __TT__
		if (_vside == 1) then {
			_mname remoteExecCall ["deleteMarkerLocal", west];
		} else {
			_mname remoteExecCall ["deleteMarkerLocal", east];
		};
#endif
	};
}];
_vec addMPEventhandler ["MPKilled", {_this # 0 setFuel 0}];
#ifdef __TT__
if (!isNull _vec2) then {
		_vec2 addEventHandler ["getIn", {
		private _ma = (_this select 0) getVariable "d_abandoned_ma";
		if (!isNil "_ma") then {
			deleteMarker _ma;
			(_this select 0) setVariable ["d_abandoned_ma", nil];
		};
	}];

	_vec2 addEventHandler ["getOut", {
		params ["_vec"];
		private _vside = _vec getVariable "D_VEC_SIDE";
		if (alive _vec && {(crew _vec) findIf {alive _x} == -1 && {_vside == 2 && {_vec distance2D d_WFLAG_BASE > 800} || {_vside == 1 } && {_vec distance2D d_EFLAG_BASE > 800}}}) then {
			_mname = format ["%1_ab%2", _vec, time];
			[_mname, _vec, "ICON", "ColorBlue", [1,1], format [localize "STR_DOM_MISSIONSTRING_1566", [typeOf _vec, "CfgVehicles"] call d_fnc_GetDisplayName], 0, "mil_triangle"] call d_fnc_CreateMarkerGlobal;
			_vec setVariable ["d_abandoned_ma", _mname];
			if (_vside == 1) then {
				_mname remoteExecCall ["deleteMarkerLocal", west];
			} else {
				_mname remoteExecCall ["deleteMarkerLocal", east];
			};
		};
	}];
	_vec2 addMPEventhandler ["MPKilled", {_this # 0 setFuel 0}];
};
#endif

call d_fnc_targetclearm;

#ifndef __TT__
_vectypetouse remoteExec ["d_fnc_target_clear_client", [0, -2] select isDedicated];
#else
[_vectypetouse_w,_vectypetouse_e] remoteExec ["d_fnc_target_clear_client", [0, -2] select isDedicated];
#endif

