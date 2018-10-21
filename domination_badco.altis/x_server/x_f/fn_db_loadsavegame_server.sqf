// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_db_loadsavegame_server.sqf"
#include "..\..\x_setup.sqf"

params ["_sname", "_sender"];

__TRACE_1("","_sname")

private _dbresult = if (_sender != objNull) then {
	parseSimpleArray ("extdb3" callExtension format ["0:dom:missionGet:%1", toLower (worldName + _sname)]);
} else {
	parseSimpleArray ("extdb3" callExtension format ["0:dom:missionGet2:%1", tolower (worldName + _sname + briefingname)]);
};

__TRACE_1("","_dbresult")

if (_dbresult select 0 != 1 || {(_dbresult select 1) isEqualTo []}) exitWith {
	if (!isNull _sender) then {
		[format [localize "STR_DOM_MISSIONSTRING_1752", _sname], "GLOBAL"] remoteExecCall ["d_fnc_HintChatMsg", _sender];
	};
};

private _ar = (_dbresult select 1) select 0;

d_maintargets = _ar select 0;
publicVariable "d_MainTargets";
d_maintargets_list = _ar select 1;
//d_current_target_index = _ar select 2;
//publicVariable "d_current_target_index";
//d_cur_sm_idx = _ar select 3;
//publicVariable "d_cur_sm_idx";
d_resolved_targets = _ar select 4;
publicVariable "d_resolved_targets";
__TRACE_1("","d_resolved_targets")
d_recapture_indices = _ar select 5;
d_side_missions_random = _ar select 6;
d_current_mission_counter = _ar select 7;
d_searchintel = _ar select 8;
publicVariable "d_searchintel";
d_bonus_vecs_db = _ar select 9;
{
	private _vec = createVehicle [_x, d_bonus_create_pos, [], 0, "NONE"];
	if (unitIsUAV _vec) then {
		createVehicleCrew _vec;
		_vec allowCrewInImmobile true;
	};
	private ["_endpos", "_dir"];
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

	_vec addMPEventHandler ["MPKilled", {if (isServer) then {_this select 0 setFuel 0; _this call d_fnc_bonusvecfnc}}];
	
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
	d_bonus_vecs_db set [_forEachIndex, _vec];
} forEach d_bonus_vecs_db;

{
	private _res = _x;
	
	private _tgt_ar = d_target_names select _res;
	private _cur_tgt_name = _tgt_ar select 1;
	private _no = missionNamespace getVariable format ["d_target_%1", _res];
	private _tstate = !isNull _no && {!isNil {_no getVariable "d_recaptured"}};
	
	private _color = if (!_tstate) then {"ColorGreen"} else {d_e_marker_color};

	private _mar = format ["d_%1_dommtm", _cur_tgt_name];
	[_mar, _tgt_ar select 0, "ELLIPSE", _color, [ _tgt_ar select 2,  _tgt_ar select 2]] call d_fnc_CreateMarkerGlobal;
	_mar setMarkerAlpha d_e_marker_color_alpha;
	
	if (_tstate) then {
		_mar setMarkerBrush "FDiagonal";
	};
	
	false
} count d_resolved_targets;


if (!isNull _sender) then {
	[_sender, ["dDBLoad", [localize "STR_DOM_MISSIONSTRING_1750", "<font face='RobotoCondensed' size=24 color='#ffffff'>" + format [localize "STR_DOM_MISSIONSTRING_1753", _sname] + "</font>"]]] remoteExecCall ["createDiaryRecord", _sender];
};
