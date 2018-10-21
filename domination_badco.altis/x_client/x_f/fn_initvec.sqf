// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_initvec.sqf"
#include "..\..\x_setup.sqf"
#define __vecmarker _vec setVariable ["d_ma_text", _car select 5]; \
_vec setVariable ["d_ma_type", getText (configFile >>"CfgMarkers">>(_car select 3)>>"icon")]; \
_vec setVariable ["d_ma_color", getArray (configFile >>"CfgMarkerColors">>(_car select 4)>>"color")]; \
_vec setVariable ["d_icon_type", getText (configFile >>"CfgVehicles">>typeOf _vec>>"icon")]; \
_vec setVariable ["d_icon_size", 28];

#define __chopmarker _vec setVariable ["d_ma_text", _car select 6]; \
_vec setVariable ["d_ma_type", getText (configFile >>"CfgMarkers">>(_car select 4)>>"icon")]; \
_vec setVariable ["d_ma_color", getArray (configFile >>"CfgMarkerColors">>(_car select 5)>>"color")]; \
_vec setVariable ["d_icon_type", getText (configFile >>"CfgVehicles">>typeOf _vec>>"icon")]; \
_vec setVariable ["d_icon_size", 28]; \
if (count _car > 8) then {_vec setVariable ["d_lift_types", _car select 8]}

#define __planemarker _vec setVariable ["d_ma_text", _car select 6]; \
_vec setVariable ["d_ma_type", getText (configFile >>"CfgMarkers">>(_car select 4)>>"icon")]; \
_vec setVariable ["d_ma_color", getArray (configFile >>"CfgMarkerColors">>(_car select 5)>>"color")]; \
_vec setVariable ["d_icon_type", getText (configFile >>"CfgVehicles">>typeOf _vec>>"icon")]; \
_vec setVariable ["d_icon_size", 28];

#define __chopset private _index = _car select 1;\
_vec setVariable ["d_choppertype", _index];\
_vec setVariable ["d_vec_type", "chopper"];

#define __planeset private _index = _car select 1;\
_vec setVariable ["d_planetype", _index];\
_vec setVariable ["d_vec_type", "plane"];

#define __vecname _vec setVariable ["d_vec_name", _car select 6]
#define __chopname _vec setVariable ["d_vec_name", _car select 7]
#define __planename _vec setVariable ["d_vec_name", _car select 7]
#define __pvecs {if ((_x select 1) == _d_vec) exitWith {_car = _x;false};false} count d_p_vecs

#define __staticl \
_vec addAction[format ["<t color='#7F7F7F'>%1</t>", localize "STR_DOM_MISSIONSTRING_256"], {_this spawn d_fnc_load_static}, _d_vec, -1, false, true, "","count (_target getVariable ['d_CARGO_AR', []]) < d_max_truck_cargo"];\
_vec addAction[format ["<t color='#FF0000'>%1</t>", localize "STR_DOM_MISSIONSTRING_257"], {_this spawn d_fnc_unload_static}, _d_vec, -2, false, true, "","isNull objectParent player && {!((_target getVariable ['d_CARGO_AR', []]) isEqualTo [])}"]

#define __addchopm _vec addAction [format ["<t color='#7F7F7F'>%1</t>", localize "STR_DOM_MISSIONSTRING_258"], {_this call d_fnc_vecdialog},[],-1,false]


if (isDedicated) exitWith {};

private _vec = _this;

__TRACE_1("","_vec")

private _desm = _vec getVariable ["d_deserted_marker", ""];

if (_desm != "" && {!(markerPos _desm isEqualTo [0,0,0])}) then {
	[_desm, _vec, "ICON", "ColorBlack", [1, 1], format [localize "STR_DOM_MISSIONSTRING_260", [typeOf _vec, "CfgVehicles"] call d_fnc_GetDisplayName], 0, "hd_dot"] call d_fnc_CreateMarkerLocal;
};

private _d_vec = _vec getVariable "d_vec";
if (isNil "_d_vec") exitWith {};

if (!isNil {_vec getVariable "d_vcheck"}) exitWith {};
_vec setVariable ["d_vcheck", true];

if (_d_vec < 100) exitWith {
	private _car = [];
	__pvecs;
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car select 0, _vec];
		if (!alive _vec) exitWith {};
		__vecmarker;
		d_marker_vecs pushBack _vec;
		d_mhq_3ddraw = d_mhq_3ddraw - [objNull];
		d_mhq_3ddraw pushBack _vec;
		__vecname;
	};
	if (!alive _vec) exitWith {};
	_vec setVariable ["d_canbelifted", true];
	_vec addAction [format ["<t color='#7F7F7F'>%1</t>", localize "STR_DOM_MISSIONSTRING_262"], {_this call d_fnc_vecdialog}, _d_vec, -1, false];
	_vec setVariable ["d_vec_type", "MHQ"];
	_vec setAmmoCargo 0;
};

if (_d_vec < 200) exitWith {
	private _car = [];
	__pvecs;
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car select 0, _vec];
		if (!alive _vec) exitWith {};
		__vecmarker;
		d_marker_vecs pushBack _vec;
		__vecname;
	};
	if (!alive _vec) exitWith {};
	_vec setVariable ["d_canbelifted", true];
	_vec setAmmoCargo 0;
};

if (_d_vec < 300) exitWith {
	private _car = [];
	__pvecs;
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car select 0, _vec];
		if (!alive _vec) exitWith {};
		__vecmarker;
		d_marker_vecs pushBack _vec;
		__vecname;
	};
	if (!alive _vec) exitWith {};
	_vec setVariable ["d_canbelifted", true];
	_vec setAmmoCargo 0;
};

if (_d_vec < 400) exitWith {
	private _car = [];
	__pvecs;
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car select 0, _vec];
		if (!alive _vec) exitWith {};
		__vecmarker;
		d_marker_vecs pushBack _vec;
		__vecname;
	};
	if (!alive _vec) exitWith {};
	_vec setVariable ["d_canbelifted", true];
	if (!d_no_ai || {player getVariable ["d_is_engineer", false]}) then {
		__staticl;
	} else {
		_vec addEventHandler ["getin", {_this call d_fnc_checktrucktrans}];
	};
	_vec setVariable ["d_vec_type", "Engineer"];
	_vec setAmmoCargo 0;
};

if (_d_vec < 500) exitWith {
	private _car = [];
	__pvecs;
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car select 0, _vec];
		if (!alive _vec) exitWith {};
		__vecmarker;
		d_marker_vecs pushBack _vec;
		__vecname;
	};
	if (!alive _vec) exitWith {};
	_vec setVariable ["d_canbelifted", true];
	_vec setAmmoCargo 0;
};

if (_d_vec < 600) exitWith {
	private _car = [];
	__pvecs;
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car select 0, _vec];
		if (!alive _vec) exitWith {};
		if (count _car > 7) then {_vec setVariable ["d_lift_types", _car select 7]};
		__vecmarker;
		d_marker_vecs pushBack _vec;
		__vecname;
	};
	if (!alive _vec) exitWith {};
	_vec setAmmoCargo 0;
};

if (_d_vec < 800) exitWith {
	if (!alive _vec) exitWith {};
	_vec setVariable ["d_canbelifted", false];
};

if (_d_vec <= 1000) exitWith {
	private _car = [];
	__pvecs;
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car select 0, _vec];
		if (!alive _vec) exitWith {};
		__vecmarker;
		d_marker_vecs pushBack _vec;
		__vecname;
	};
	if (!alive _vec) exitWith {};
	_vec setVariable ["d_canbelifted", true];
	_vec setAmmoCargo 0;
};

if (_d_vec < 3099) exitWith {
	private _car = [];
	{if ((_x select 3) == _d_vec) exitWith {_car = _x;false};false} count d_choppers;
	__TRACE_1("","_car")
	if !(_car isEqualTo []) then {
		if (!alive _vec) exitWith {};
		missionNamespace setVariable [_car select 0, _vec];
		__chopname;
		__chopmarker;
		d_marker_vecs pushBack _vec;
	};
	if (!alive _vec) exitWith {};
	__addchopm;
	__chopset;
};
if (_d_vec < 4000) exitWith {
	private _car = [];
	{if ((_x select 3) == _d_vec) exitWith {_car = _x;false};false} count d_planes;
	__TRACE_1("","_car")
	if !(_car isEqualTo []) then {
		if (!alive _vec) exitWith {};
		missionNamespace setVariable [_car select 0, _vec];
		__planename;
		__planemarker;
		d_marker_vecs pushBack _vec;
	};
	if (!alive _vec) exitWith {};
	__planeset;
};
