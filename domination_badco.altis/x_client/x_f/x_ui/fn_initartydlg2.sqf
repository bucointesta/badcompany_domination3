// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_initartydlg2.sqf"
#include "..\..\..\x_setup.sqf"

if (isDedicated) exitWith {};

disableSerialization;

d_cur_art_marker_ar = [];
d_arti_did_fire = nil;

//d_arttmx|1|32Rnd_155mm_Mo_shells|1

{
	private _ar = _x;
	__TRACE_1("","_ar")
	private _idx = 0; // 0 = netId, 1 = type, 2 = rounds
	private _netid_ar = "";
	private _type_ar = "";
	private _rounds_ar = "";
	private _start_idx = 9;
	private _car = count _ar;
	for "_i" from 9	to (_car - 1) do {
		if ((_ar select [_i, 1]) == "|" || {_i == (_car - 1)}) then { // 124 = |
			switch (_idx) do {
				case 0: {_netid_ar = _ar select [_start_idx, _i - _start_idx]};
				case 1: {_type_ar = _ar select [_start_idx, _i - _start_idx]};
				case 2: {_rounds_ar = _ar select [_start_idx, _car - _start_idx]};
			};
			_start_idx = _i + 1;
			_idx = _idx + 1;
		};
	};
	__TRACE_3("","_netid_ar","_type_ar","_rounds_ar")
	if (_netid_ar != "") then {
		d_cur_art_marker_ar pushBack [_x, _netid_ar, _type_ar, parseNumber _rounds_ar];
	};
	false
} count (allMapMarkers select {_x select [0, 9] == "d_arttmx|"});

__TRACE_1("","d_cur_art_marker_ar")

d_cur_artm_map_startpos = getPosWorld player;

private _disp = uiNamespace getVariable "d_ArtilleryDialog2";

private _ctrllb = _disp displayCtrl 1000;
lbClear _ctrllb;

if !(d_cur_art_marker_ar isEqualTo []) then {
	{
		private _name = if (isMultiplayer) then {
			name (objectFromNetId  (_x select 1))
		} else {
			name player
		};
		private _lbAdd = _ctrllb lbAdd _name;
		_ctrllb lbSetvalue [_lbAdd, _forEachIndex];
		_ctrllb lbSetData [_lbAdd, _x select 0];
	} forEach d_cur_art_marker_ar;
	_ctrllb lbSetcursel 0;
} else {
	(_disp displayCtrl 1002) ctrlEnable false;
	_ctrllb lbAdd format ["<< %1 >>", localize "STR_DOM_MISSIONSTRING_1649"];
	_ctrllb ctrlEnable false;
};
