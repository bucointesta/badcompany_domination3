// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_p_o_ar.sqf"
#include "..\..\x_setup.sqf"

__TRACE_1("","_this")

switch (param [0]) do {
	case "a": {
		private _ar = d_placed_objs_store getVariable [param [1], []];
		__TRACE_1("","_ar")
		_ar pushBack (param [2]);
		d_placed_objs_store setVariable [param [1], _ar];
		_ar = param [2];
		__TRACE_1("","_ar")
		(_ar select 0) addMPEventhandler ["MPKilled", {if (isServer) then {_this call d_fnc_PlacedObjKilled}}];
		if ((_ar select 0) isKindOf d_mash) then {
			[_ar select 1, _ar select 0, "ICON", "ColorBlue", [0.5, 0.5], format ["Mash %1", _ar select 2], 0, "mil_dot"] call d_fnc_CreateMarkerGlobal;
		} else {
			if ((_ar select 0) isKindOf (d_farp_classes select 0)) then {
				[_ar select 1, _ar select 0, "ICON", "ColorBlue", [0.5, 0.5], format ["FARP %1", _ar select 2], 0, "mil_dot"] call d_fnc_CreateMarkerGlobal;
				if (isDedicated) then {
					private _farpc = (_ar select 0) getVariable ["d_objcont", []];
					if !(_farpc isEqualTo []) then {
						private _trig = _farpc select 0;
						_trig setTriggerActivation ["ANY", "PRESENT", true];
						_trig setTriggerStatements ["thislist call d_fnc_tallservice", "0 = [thislist] spawn d_fnc_reload", ""];
					};
				};
			};
		};
	};
	case "a2": {
		private _ar = d_placed_objs_store2 getVariable [param [1], []];
		if !(_ar isEqualTo []) then {_ar = _ar - [objNull]};
		_ar pushBack (param [2]);
		d_placed_objs_store2 setVariable [param [1], _ar];
	};
	case "r": {
		private _ar = d_placed_objs_store getVariable [param [1], []];
		__TRACE_1("","_ar")
		if !(_ar isEqualTo []) then {
			{
				if ((_x select 1) == (param [2])) exitWith {_ar deleteAt _forEachIndex};
			} forEach _ar;
		};
		deleteMarker (param [2]);
		d_placed_objs_store setVariable [param [1], _ar];
	};
	case "a2r": {
		private _ar = d_placed_objs_store2 getVariable [param [1], []];
		if !(_ar isEqualTo []) then {
			_ar = _ar - [param [1], objNull];
		};
		d_placed_objs_store2 setVariable [param [1], _ar];
	};
	case "aw": {
		private _ar = d_placed_objs_store3 getVariable [param [1], []];
		__TRACE_1("","_ar")
		if !(_ar isEqualTo []) then {
			{
				private _t = _x getVariable ["d_time_aw", -1];
				if (_t != -1 && {time > _t}) then {
					deleteVehicle _x;
					_ar set [_forEachIndex, objNull];
				};
			} forEach (_ar select {!isNull _x});
			_ar = _ar - [objNull];
		};
		_ar pushBack (param [2]);
		__TRACE_1("aw","_ar")
		(param [2]) setVariable ["d_time_aw", time + 1800];
		d_placed_objs_store3 setVariable [param [1], _ar];
	};
};