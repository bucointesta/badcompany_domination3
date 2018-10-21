// by Xeno
#define THIS_FILE "fn_allowedvec.sqf"
#include "..\..\x_setup.sqf"

params ["_vec"];

private _not_allowed = false;
private _needed_rank = "";

private _index = rankId player;
__TRACE_1("","_index")
if (_vec isKindOf "LandVehicle") then {
	if (_vec isKindOf "StaticWeapon") then {
		private _vrs = d_ranked_a select 8;
		__TRACE_1("StaticWeapon APC","_vrs")
		if (_index < ((toUpper (_vrs select 0)) call d_fnc_GetRankIndex)) then {
			_not_allowed = true;
			_needed_rank = _vrs select 0;
		};
	} else {
		if (_vec isKindOf "Wheeled_APC" || {_vec isKindOf "Wheeled_APC_F"}) then {
			private _vrs = d_ranked_a select 8;
			__TRACE_1("Wheeled APC","_vrs")
			if (_index < ((toUpper (_vrs select 0)) call d_fnc_GetRankIndex)) then {
				_not_allowed = true;
				_needed_rank = _vrs select 0;
			};
		} else {
			if (_vec isKindOf "Tank") then {
				private _vrs = d_ranked_a select 8;
				__TRACE_1("Tank","_vrs")
				if (_index < ((toUpper (_vrs select 1)) call d_fnc_GetRankIndex)) then {
					_not_allowed = true;
					_needed_rank = _vrs select 1;
				};
			};
		};
	};
} else {
	if (_vec isKindOf "Air") then {
		if (_vec isKindOf "Helicopter") then {
			private _vrs = d_ranked_a select 8;
			__TRACE_1("Helicopter","_vrs")
			if (_index < ((toUpper (_vrs select 2)) call d_fnc_GetRankIndex)) then {
				_not_allowed = true;
				_needed_rank = _vrs select 2;
			};
		} else {
			if (_vec isKindOf "Plane") then {
				private _vrs = d_ranked_a select 8;
				__TRACE_1("Plane","_vrs")
				if (_index < ((toUpper (_vrs select 3)) call d_fnc_GetRankIndex)) then {
					_not_allowed = true;
					_needed_rank = _vrs select 3;
				};
			};
		};
	} else {
		if (_vec isKindOf "Ship") then {
			private _vrs = d_ranked_a select 8;
			__TRACE_1("Ship","_vrs")
			if (_index < ((toUpper (_vrs select 4)) call d_fnc_GetRankIndex)) then {
				_not_allowed = true;
				_needed_rank = _vrs select 4;
			};
		};
	};
};

[_not_allowed, _needed_rank]