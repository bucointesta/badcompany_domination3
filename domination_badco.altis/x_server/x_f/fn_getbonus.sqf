// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_getbonus.sqf"
#include "..\..\x_setup.sqf"

if (!isServer) exitWith {};

d_sm_winner = param [0];
d_current_sm_bonus_vec = param [1];

__TRACE("Starting")

if (d_MissionType == 2 || {d_bonus_vec_type in [1, 3]}) exitWith {
	[d_sm_winner, ""] remoteExecCall ["d_fnc_sm_res_client", [0, -2] select isDedicated];
	d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"MissionAccomplished",d_kbtel_chan];

	if !(isServer && {!isDedicated}) then {d_sm_winner = 0};
};

private _vec_type = "";
if (d_current_sm_bonus_vec == "") then {
	private _airval = 72;
	private _chance = 0;

	if (d_land_bonus_vecs == 0) then {
		_chance = _airval + 1;
	} else {
		if (d_air_bonus_vecs == 0) then {
			_chance = 0;
		} else {
			if (d_air_bonus_vecs > d_land_bonus_vecs) then {
				_airval = floor ((d_land_bonus_vecs / d_air_bonus_vecs) * 100);
			};
			_chance = floor (random 100);
		};
	};
	
	__TRACE_1("","_chance")

	private _btype = "";

	__TRACE_2("","d_land_bonus_vecs","d_air_bonus_vecs")
	while {_btype == ""} do {
		_vec_type = selectRandom d_sm_bonus_vehicle_array;
		__TRACE_1("","_vec_type")
		if (count d_sm_bonus_vehicle_array > 3 && {d_land_bonus_vecs > 2 && {d_air_bonus_vecs > 2}}) then {
			private _vecclass = getText(configFile>>"CfgVehicles">>_vec_type>>"vehicleClass");
			__TRACE_1("","_vecclass")
			if (_chance > _airval) then {
				if (_vecclass == "Air" && {d_last_bonus_vec != _vec_type}) then {_btype = _vec_type};
			} else {
				if (_vecclass != "Air" && {d_last_bonus_vec != _vec_type}) then {_btype = _vec_type};
			};
		} else {
			_btype = _vec_type;
		};
		sleep 0.01;
	};
} else {
	_vec_type = d_current_sm_bonus_vec;
	d_current_sm_bonus_vec = "";
};

__TRACE_1("","_vec_type")

d_last_bonus_vec = _vec_type;
sleep 1.012;

private _endpos = [];
private _dir = 0;
private _vec = createVehicle [_vec_type, d_bonus_create_pos, [], 0, "NONE"];
if (d_database_found) then {
	d_bonus_vecs_db pushBack _vec;
};
if (unitIsUAV _vec) then {
	createVehicleCrew _vec;
	_vec allowCrewInImmobile true;
};

__TRACE_1("","_vec")

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
_vec setVariable ["d_WreckMaxRepair", d_WreckMaxRepair, true];
_vec addMPEventHandler ["MPKilled", {if (isServer) then {_this select 0 setFuel 0;_this call d_fnc_bonusvecfnc}}];

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
		_vec setVariable ["d_abandoned_ma", [format ["%1_ab%2", _vec, time], _vec, "ICON", "ColorBlue", [1,1], format [localize "STR_DOM_MISSIONSTRING_1566", [typeOf _vec, "CfgVehicles"] call d_fnc_GetDisplayName], 0, "mil_triangle"] call d_fnc_CreateMarkerGlobal];
	};
}];

__TRACE_1("","d_sm_winner")
[d_sm_winner, _vec_type] remoteExecCall ["d_fnc_sm_res_client", [0, -2] select isDedicated];
d_kb_logic1 kbTell [d_kb_logic2,d_kb_topic_side,"MissionAccomplished",d_kbtel_chan];

if !(isServer && {!isDedicated}) then {d_sm_winner = 0};