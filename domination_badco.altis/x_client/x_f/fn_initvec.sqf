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

#define __planeSet [_vec] call d_fnc_planeSet

#define __chopset private _index = _car select 1;\
_vec setVariable ["d_choppertype", _index];\
_vec setVariable ["d_vec_type", "chopper"];\
switch (_index) do {\
	case 0: {_vec addEventHandler ["getin", {[_this,0] call d_fnc_checkhelipilot}]};\
	case 1: {_vec addEventHandler ["getin", {_this call d_fnc_checkhelipilot_wreck}]};\
	case 2: {_vec addEventHandler ["getin", {[_this,1] call d_fnc_checkhelipilot}]};\
};\
_vec addEventHandler ["getOut", {_this call d_fnc_checkhelipilotout}]

#define __vecname _vec setVariable ["d_vec_name", _car select 6]
#define __chopname _vec setVariable ["d_vec_name", _car select 7]
#define __pvecs private _fidx = d_p_vecs findIf {_x select 1 == _d_vec}; if (_fidx > -1) then {_car = d_p_vecs select _fidx}

#define __staticl \
_vec addAction[format ["<t color='#7F7F7F'>%1</t>", localize "STR_DOM_MISSIONSTRING_256"], {_this spawn d_fnc_load_static}, _d_vec, -1, false, true, "","count (_target getVariable ['d_CARGO_AR', []]) < d_max_truck_cargo"];\
_vec addAction[format ["<t color='#FF0000'>%1</t>", localize "STR_DOM_MISSIONSTRING_257"], {_this spawn d_fnc_unload_static}, _d_vec, -2, false, true, "","isNull objectParent player && {!((_target getVariable ['d_CARGO_AR', []]) isEqualTo [])}"]

#define __addchopm _vec addAction [format ["<t color='#7F7F7F'>%1</t>", localize "STR_DOM_MISSIONSTRING_258"], {_this call d_fnc_vecdialog},[],-1,false]

#ifdef __TT__
#define __sidew _vec setVariable ["d_side", blufor]
#define __sidee _vec setVariable ["d_side", opfor]
#define __checkenterer _vec addEventHandler ["getin", {_this call d_fnc_checkenterer}]
#define __pvecss(sname) private _fidx = d_p_vecs_##sname findIf {_x select 1 == _d_vec}; if (_fidx > -1) then {_car = d_p_vecs_##sname select _fidx}
#endif

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

if (_d_vec isEqualType []) exitWith {
	if (_d_vec # 1 != "") then {
		_vec setVariable ["d_ma_text", _d_vec # 1];
	} else {
		_vec setVariable ["d_ma_text", ""];
	};
	if (_d_vec # 0 != "") then {
		_vec setVariable ["d_ma_type", getText (configFile >>"CfgMarkers">>(_d_vec # 0)>>"icon")];
		_vec setVariable ["d_ism_vec", true];
	};
	_vec setVariable ["d_icon_type", getText (configFile >>"CfgVehicles">>typeOf _vec>>"icon")];
	if (_d_vec # 2 != "") then {
		_vec setVariable ["d_ma_color", getArray (configFile >>"CfgMarkerColors">>(_d_vec # 2)>>"color")];
	};
	d_marker_vecs pushBack _vec;
};

if (_d_vec < 100) exitWith {
	private _car = [];
#ifndef __TT__
	__pvecs;
#else
	__pvecss(blufor);
#endif
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car # 0, _vec];
		if (!alive _vec) exitWith {};
		__vecmarker;
#ifndef __TT__
		d_marker_vecs pushBack _vec;
		_vec setVariable ["d_ism_vec", true];
		d_mhq_3ddraw = d_mhq_3ddraw - [objNull];
		d_mhq_3ddraw pushBack _vec;
#else
		if (d_player_side == blufor) then {
			d_marker_vecs pushBack _vec;
			_vec setVariable ["d_ism_vec", true];
			d_mhq_3ddraw = d_mhq_3ddraw - [objNull];
			d_mhq_3ddraw pushBack _vec;
		};
#endif
		__vecname;
	};
	if (!alive _vec) exitWith {};
#ifdef __TT__
	if (d_player_side == blufor) then {
#endif
	_vec addAction [format ["<t color='#7F7F7F'>%1</t>", localize "STR_DOM_MISSIONSTRING_262"], {_this call d_fnc_vecdialog}, _d_vec, -1, false];
#ifdef __TT__
	} else {
		_vec setVariable ["d_liftit", false];
	};
#endif
	_vec setVariable ["d_vec_type", "MHQ"];
	_vec setAmmoCargo 0;
#ifdef __TT__
	__sidew;
	_vec addEventHandler ["getin", {_this call d_fnc_checkdriver}];
#endif
};

if (_d_vec < 200) exitWith {
	private _car = [];
#ifndef __TT__
	__pvecs;
#else
	__pvecss(blufor);
#endif
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car # 0, _vec];
		if (!alive _vec) exitWith {};
		__vecmarker;
#ifndef __TT__
		d_marker_vecs pushBack _vec;
		_vec setVariable ["d_ism_vec", true];
#else
		if (d_player_side == blufor) then {
			d_marker_vecs pushBack _vec;
			_vec setVariable ["d_ism_vec", true];
		};
#endif
		__vecname;
	};
	if (!alive _vec) exitWith {};
	_vec setAmmoCargo 0;
#ifdef __TT__
	__sidew;
	__checkenterer;
	if (d_player_side != blufor) then {
		_vec setVariable ["d_liftit", false];
	};
#endif
};

if (_d_vec < 300) exitWith {
	private _car = [];
#ifndef __TT__
	__pvecs;
#else
	__pvecss(blufor);
#endif
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car # 0, _vec];
		if (!alive _vec) exitWith {};
		__vecmarker;
#ifndef __TT__
		d_marker_vecs pushBack _vec;
		_vec setVariable ["d_ism_vec", true];
#else
		if (d_player_side == blufor) then {
			d_marker_vecs pushBack _vec;
			_vec setVariable ["d_ism_vec", true];
		};
#endif
		__vecname;
	};
	if (!alive _vec) exitWith {};
	// Hunter: 200s contain rearm/repair/refuel trucks so we shouldn't empty ammo here...
	//_vec setAmmoCargo 0;
#ifdef __TT__
	__sidew;
	__checkenterer;
	if (d_player_side != blufor) then {
		_vec setVariable ["d_liftit", false];
	};
#endif
};

if (_d_vec < 400) exitWith {
	private _car = [];
#ifndef __TT__
	__pvecs;
#else
	__pvecss(blufor);
#endif
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car # 0, _vec];
		if (!alive _vec) exitWith {};
		__vecmarker;
#ifndef __TT__
		d_marker_vecs pushBack _vec;
		_vec setVariable ["d_ism_vec", true];
#else
		if (d_player_side == blufor) then {
			d_marker_vecs pushBack _vec;
			_vec setVariable ["d_ism_vec", true];
		};
#endif
		__vecname;
	};
	if (!alive _vec) exitWith {};
	if (!d_no_ai || {player getUnitTrait "engineer"}) then {
		__staticl;
	} else {
		_vec addEventHandler ["getin", {_this call d_fnc_checktrucktrans}];
	};
	_vec setVariable ["d_vec_type", "Engineer"];
	_vec setAmmoCargo 0;
#ifdef __TT__
	__sidew;
	if (d_player_side != blufor) then {
		_vec setVariable ["d_liftit", false];
	};
#endif
};

//Hunter: reserve 400s for transport trucks that can carry ammo and has vehicle menu
if (_d_vec < 500) exitWith {
	private _car = [];
#ifndef __TT__
	__pvecs;
#else
	__pvecss(blufor);
#endif
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car # 0, _vec];
		if (!alive _vec) exitWith {};
		__vecmarker;
#ifndef __TT__
		d_marker_vecs pushBack _vec;
		_vec setVariable ["d_ism_vec", true];
#else
		if (d_player_side == blufor) then {
			d_marker_vecs pushBack _vec;
			_vec setVariable ["d_ism_vec", true];
		};
#endif
		__vecname;
	};
	if (!alive _vec) exitWith {};
	_vec setAmmoCargo 0;
	_vec addAction [format ["<t color='#7F7F7F'>%1</t>", "Transport Menu"], {_this call d_fnc_vecdialog}, _d_vec, -1, false];
#ifdef __TT__
	__sidew;
	__checkenterer;
	if (d_player_side != blufor) then {
		_vec setVariable ["d_liftit", false];
	};
#endif
};

if (_d_vec < 600) exitWith {
	private _car = [];
#ifndef __TT__
	__pvecs;
#else
	__pvecss(blufor);
#endif
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car # 0, _vec];
		if (!alive _vec) exitWith {};
		if (count _car > 7) then {_vec setVariable ["d_lift_types", _car # 7]};
		__vecmarker;
#ifndef __TT__
		d_marker_vecs pushBack _vec;
		_vec setVariable ["d_ism_vec", true];
#else
		if (d_player_side == blufor) then {
			d_marker_vecs pushBack _vec;
			_vec setVariable ["d_ism_vec", true];
		};
#endif
		__vecname;
	};
	if (!alive _vec) exitWith {};
	_vec setAmmoCargo 0;
#ifdef __TT__
	__sidew;
	if (d_player_side != blufor) then {
		_vec setVariable ["d_liftit", false];
	};
#endif
	_vec addEventHandler ["getin", {_this call d_fnc_checkdriver_wreck}];
};

#ifdef __TT__
if (_d_vec < 1100) exitWith {
	private _car = [];
	__pvecss(opfor);
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car # 0, _vec];
		if (!alive _vec) exitWith {};
		__vecmarker;
		if (d_player_side == opfor) then {
			d_marker_vecs pushBack _vec;
			_vec setVariable ["d_ism_vec", true];
			d_mhq_3ddraw = d_mhq_3ddraw - [objNull];
			d_mhq_3ddraw pushBack _vec;
		};
		__vecname;
	};
	if (!alive _vec) exitWith {};
	if (d_player_side == opfor) then {
		_vec addAction [format ["<t color='#7F7F7F'>%1</t>", localize "STR_DOM_MISSIONSTRING_262"], {_this call d_fnc_vecdialog}, _d_vec, -1, false];
	};
	_vec setVariable ["d_vec_type", "MHQ"];
	_vec setAmmoCargo 0;
	__sidee;
	_vec addEventHandler ["getin", {_this call d_fnc_checkdriver}];
	if (d_player_side != opfor) then {
		_vec setVariable ["d_liftit", false];
	};
};

if (_d_vec < 1200) exitWith {
	private _car = [];
	__pvecss(opfor);
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car # 0, _vec];
		if (!alive _vec) exitWith {};
		__vecmarker;
		if (d_player_side == opfor) then {
			d_marker_vecs pushBack _vec;
			_vec setVariable ["d_ism_vec", true];
		};
		__vecname;
	};
	if (!alive _vec) exitWith {};
	_vec setAmmoCargo 0;
	__sidee;
	__checkenterer;
	if (d_player_side != opfor) then {
		_vec setVariable ["d_liftit", false];
	};
};

if (_d_vec < 1300) exitWith {
	private _car = [];
	__pvecss(opfor);
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car # 0, _vec];
		if (!alive _vec) exitWith {};
		__vecmarker;
		if (d_player_side == opfor) then {
			d_marker_vecs pushBack _vec;
			_vec setVariable ["d_ism_vec", true];
		};
		__vecname;
	};
	if (!alive _vec) exitWith {};
	_vec setAmmoCargo 0;
	__sidee;
	__checkenterer;
	if (d_player_side != opfor) then {
		_vec setVariable ["d_liftit", false];
	};
};

if (_d_vec < 1400) exitWith {
	private _car = [];
	__pvecss(opfor);
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car # 0, _vec];
		if (!alive _vec) exitWith {};
		__vecmarker;
		if (d_player_side == opfor) then {
			d_marker_vecs pushBack _vec;
			_vec setVariable ["d_ism_vec", true];
		};
		__vecname;
	};
	if (!alive _vec) exitWith {};
	if (!d_no_ai || {player getUnitTrait "engineer"}) then {
		__staticl;
	} else {
		_vec addEventHandler ["getin", {_this call d_fnc_checktrucktrans}];
	};
	_vec setVariable ["d_vec_type", "Engineer"];
	_vec setAmmoCargo 0;
	__sidee;
	if (d_player_side != opfor) then {
		_vec setVariable ["d_liftit", false];
	};
};

if (_d_vec < 1500) exitWith {
	private _car = [];
	__pvecss(opfor);
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car # 0, _vec];
		if (!alive _vec) exitWith {};
		__vecmarker;
		if (d_player_side == opfor) then {
			d_marker_vecs pushBack _vec;
			_vec setVariable ["d_ism_vec", true];
		};
		__vecname;
	};
	if (!alive _vec) exitWith {};
	_vec setAmmoCargo 0;
	__sidee;
	__checkenterer;
	if (d_player_side != opfor) then {
		_vec setVariable ["d_liftit", false];
	};
};

if (_d_vec < 1600) exitWith {
	private _car = [];
	__pvecss(blufor);
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car # 0, _vec];
		if (!alive _vec) exitWith {};
		__vecmarker;
		if (d_player_side == blufor) then {
			d_marker_vecs pushBack _vec;
			_vec setVariable ["d_ism_vec", true];
		};
		__vecname;
	};
	if (!alive _vec) exitWith {};
	_vec setAmmoCargo 0;
	__sidew;
	_vec addEventHandler ["getin", {_this call d_fnc_checkdriver_wreck}];
	if (d_player_side != opfor) then {
		_vec setVariable ["d_liftit", false];
	};
};
#endif


//ATVs
if (_d_vec < 800) exitWith {};

if (_d_vec < 1000) exitWith {
	private _car = [];
#ifndef __TT__
	__pvecs;
#else
	__pvecss(blufor);
#endif
	if !(_car isEqualTo []) then {
		missionNamespace setVariable [_car # 0, _vec];
		if (!alive _vec) exitWith {};
		__vecmarker;
#ifndef __TT__
		d_marker_vecs pushBack _vec;
		_vec setVariable ["d_ism_vec", true];
#else
		if (d_player_side == blufor) then {
			d_marker_vecs pushBack _vec;
			_vec setVariable ["d_ism_vec", true];
		};
#endif
		__vecname;
	};
	if (!alive _vec) exitWith {};
	_vec setAmmoCargo 0;
#ifdef __TT__
	__sidew;
	__checkenterer;
	if (d_player_side != blufor) then {
		_vec setVariable ["d_liftit", false];
	};
#endif
};

if (_d_vec < 4000) exitWith {
	private _car = [];
#ifndef __TT__
	private _fidx = d_choppers findIf {_x # 3 == _d_vec}; if (_fidx > -1) then {_car = d_choppers # _fidx};
#else
	private _fidx = d_choppers_blufor findIf {_x # 3 == _d_vec}; if (_fidx > -1) then {_car = d_choppers_blufor # _fidx};
#endif
	__TRACE_1("","_car")
	if !(_car isEqualTo []) then {
		if (!alive _vec) exitWith {};
		_vec setAmmoCargo 0;
		missionNamespace setVariable [_car # 0, _vec];
		__chopname;
		__chopmarker;
#ifndef __TT__		
		d_marker_vecs pushBack _vec;
		_vec setVariable ["d_ism_vec", true];
#else
		if (d_player_side == blufor) then {
			d_marker_vecs pushBack _vec;
			_vec setVariable ["d_ism_vec", true];
		};
#endif
	};
	if (!alive _vec) exitWith {};
	if (_d_vec < 3100) then {__addchopm;} else {__planeSet;};	
	__chopset;
#ifdef __TT__
	__sidew;
	if (d_player_side != blufor) then {
		_vec setVariable ["d_liftit", false];
	};
#endif
};

#ifdef __TT__
if (_d_vec < 5000) exitWith {
	private _car = [];
	private _fidx = d_choppers_opfor findIf {_x # 3 == _d_vec}; if (_fidx > -1) then {_car = d_choppers_opfor # _fidx};
	__TRACE_1("","_car")
	if !(_car isEqualTo []) then {
		if (!alive _vec) exitWith {};
		missionNamespace setVariable [_car # 0, _vec];
		__chopname;
		__chopmarker;
		if (d_player_side == opfor) then {
			d_marker_vecs pushBack _vec;
			_vec setVariable ["d_ism_vec", true];
		};
	};
	if (!alive _vec) exitWith {};
	_vec setAmmoCargo 0;
	__addchopm;
	__chopset;
	__sidee;
	if (d_player_side != opfor) then {
		_vec setVariable ["d_liftit", false];
	};
};
#endif
