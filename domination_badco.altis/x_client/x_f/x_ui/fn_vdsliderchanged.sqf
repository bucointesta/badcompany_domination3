// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_vdsliderchanged.sqf"
#include "..\..\..\x_setup.sqf"

if (isDedicated) exitWith {};

disableSerialization;
private _newvd = round (_this select 1);
((uiNamespace getVariable "D_StatusDialog") displayCtrl 1999) ctrlSetText format [localize "STR_DOM_MISSIONSTRING_358", _newvd];
setViewDistance _newvd;
private _objvd = _newvd*0.9;
setObjectViewDistance [_objvd, _objvd*0.1];

profileNamespace setVariable ["dom_viewdistance", _newvd];