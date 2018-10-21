// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_artytypeselchanged2.sqf"
#include "..\..\..\x_setup.sqf"

if (isDedicated) exitWith {};

disableSerialization;
params ["_selection"];

private _selIdx = _selection select 1;
if (_selIdx == -1) exitWith {};

private _mag = (_selection select 0) lbData _selIdx;

private _wpos = markerPos "d_temp_mark_arty_marker";

private _warty = d_ao_arty_vecs select 0;

private _inrange = _wpos inRangeOfArtillery [[_warty], _mag];

__TRACE_3("","_mag","_wpos","_warty")
__TRACE_1("","_inrange")

private _ctrl = (uiNamespace getVariable "d_MarkArtilleryDialog") displayCtrl 900;
_ctrl ctrlSetText format [localize "STR_DOM_MISSIONSTRING_1458", round ([0, _warty getArtilleryETA [_wpos, _mag]] select _inrange)];

_ctrl = (uiNamespace getVariable "d_MarkArtilleryDialog") displayCtrl 890;
if (_inrange) then {
	_ctrl ctrlSetText localize "STR_DOM_MISSIONSTRING_1244b";
	_ctrl ctrlEnable true;
} else {
	_ctrl ctrlSetText localize "STR_DOM_MISSIONSTRING_1244a";
	_ctrl ctrlEnable false;
};