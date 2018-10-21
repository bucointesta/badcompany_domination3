// by Xeno
#define THIS_FILE "fn_statusdialoginit.sqf"
#include "..\..\..\x_setup.sqf"
#define __ctrl(vctrl) _ctrl = _disp displayCtrl vctrl
#define __ctrl2(ectrl) (_disp displayCtrl ectrl)

params ["_disp"];

if (!d_pisadminp) then {
	__ctrl2(123123) ctrlShow false;
	__ctrl2(123124) ctrlShow false;
	if (!d_database_found) then {
		__ctrl2(123125) ctrlShow false;
	};
} else {
	if (!d_database_found) then {
		__ctrl2(123124) ctrlShow false;
		__ctrl2(123125) ctrlShow false;
	};
};

private _tgt_ar = [];

private _cur_tgt_name = if (d_current_target_index != -1) then {
	d_cur_tgt_name
} else {
	localize "STR_DOM_MISSIONSTRING_539"
};

if (isNil "_cur_tgt_name") then {_cur_tgt_name = ""};


private _s = call {
	if (d_all_sm_res) exitWith {localize "STR_DOM_MISSIONSTRING_522"};
	if (d_cur_sm_idx == -1) exitWith {localize "STR_DOM_MISSIONSTRING_540"};
	format ["%1     #%2", d_cur_sm_txt, d_cur_sm_idx]
};

__ctrl2(11002) ctrlSetText _s;

if (d_WithRevive == 1) then {
	__ctrl2(30000) ctrlShow false;
	__ctrl2(30001) ctrlShow false;
} else {
	__ctrl2(30001) ctrlSetText str (player getVariable "xr_lives");
};

private _intels = "";
{
	if (_x == 1) then {
		_tmp = switch (_forEachIndex) do {
			case 0: {localize "STR_DOM_MISSIONSTRING_542"};
			case 1: {localize "STR_DOM_MISSIONSTRING_543"};
			case 2: {localize "STR_DOM_MISSIONSTRING_544"};
			case 3: {localize "STR_DOM_MISSIONSTRING_545"};
			case 4: {localize "STR_DOM_MISSIONSTRING_546"};
			case 5: {localize "STR_DOM_MISSIONSTRING_547"};
		};
		_intels = _intels + _tmp + "\n";
	};
} forEach d_searchintel;
if (_intels == "") then {
	_intels = localize "STR_DOM_MISSIONSTRING_548";
};
__ctrl2(11018) ctrlSetText _intels;

__ctrl2(11003) ctrlSetText _cur_tgt_name;

__ctrl2(11006) ctrlSetText format ["%1/%2", count d_resolved_targets + 1, d_MainTargets];

__ctrl2(11233) ctrlSetText str(score player);

private "_ctrl";
__ctrl(11278);
_ctrl ctrlSetText format ["%1/%2", d_campscaptured, d_numcamps];

//if (player in d_leaders) then {
__ctrl(11009);
_ctrl ctrlSetText (localize "STR_DOM_MISSIONSTRING_552");
/*}; else {
	if (group player != grpNull) then {
		LEAVE GROUP
	} else {
		ASK FOR GROUP
	};
}*/

_s = "";
if (d_current_target_index != -1) then {
	_s = switch (d_sec_kind) do {
		case 1: {
			format [localize "STR_DOM_MISSIONSTRING_554", _cur_tgt_name]
		};
		case 2: {
			format [localize "STR_DOM_MISSIONSTRING_556", _cur_tgt_name]
		};
		case 3: {
			format [localize "STR_DOM_MISSIONSTRING_557", _cur_tgt_name]
		};
		case 4: {
			format [localize "STR_DOM_MISSIONSTRING_559", _cur_tgt_name]
		};
		case 5: {
			format [localize "STR_DOM_MISSIONSTRING_561", _cur_tgt_name]
		};
		case 6: {
			format [localize "STR_DOM_MISSIONSTRING_562", _cur_tgt_name]
		};
		case 7: {
			format [localize "STR_DOM_MISSIONSTRING_563", _cur_tgt_name]
		};
		case 8: {
			format [localize "STR_DOM_MISSIONSTRING_565", _cur_tgt_name]
		};
		case 9: {
			format [localize "STR_DOM_MISSIONSTRING_566", _cur_tgt_name]
		};
		case 10: {
			format [localize "STR_DOM_MISSIONSTRING_567", _cur_tgt_name]
		};
		default {
			localize "STR_DOM_MISSIONSTRING_568"
		};
	};
} else {
	_s = localize "STR_DOM_MISSIONSTRING_568";
};

__ctrl2(11007) ctrlSetText _s;

_rank_p = rank player;
__ctrl2(12010) ctrlSetText (_rank_p call d_fnc_GetRankPic);

__ctrl2(11014) ctrlSetText (_rank_p call d_fnc_GetRankString);

__ctrl2(12016) ctrlSetText serverName;
