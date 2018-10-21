// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_create_vecx.sqf"
#include "..\..\..\x_setup.sqf"

if (isDedicated || {!alive player || {player getVariable ["xr_pluncon", false] ||{player getVariable ["ace_isunconscious", false]}}}) exitWith {};

disableSerialization;
private _idx = lbCurSel ((uiNamespace getVariable "d_VecDialog") displayCtrl 44449);
closeDialog 0;
if (_idx < 0) exitWith {};
[0, 0, 0, [d_create_bike select _idx, 0]] spawn d_fnc_bike;