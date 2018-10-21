// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_artmselchanged.sqf"
#include "..\..\..\x_setup.sqf"

if (isDedicated) exitWith {};

disableSerialization;

__TRACE_1("","_this")

private _disp = uiNamespace getVariable "d_ArtilleryDialog2";

private _selIdx = param [1];
if (_selIdx == -1) exitWith {};

private _lbctrl = param [0];

private _arele = d_cur_art_marker_ar select (_lbctrl lbValue _selIdx);

(_disp displayCtrl 2000) ctrlSetText (_lbctrl lbText _selIdx);
(_disp displayCtrl 2001) ctrlSetText getText(configFile>>"CfgMagazines">>(_arele select 2)>>"displayName");
(_disp displayCtrl 2002) ctrlSetText str (_arele select 3);

private _ctrlmap = _disp displayCtrl 1001;
ctrlMapAnimClear _ctrlmap;

private _end_pos = markerPos (_lbctrl lbData _selIdx);
_ctrlmap ctrlMapAnimAdd [0.0, 1.00, d_cur_artm_map_startpos];
_ctrlmap ctrlMapAnimAdd [1.2, 1.00, _end_pos];
_ctrlmap ctrlMapAnimAdd [0.5, 0.30, _end_pos];
ctrlMapAnimCommit _ctrlmap;
d_cur_artm_map_startpos = _end_pos;
