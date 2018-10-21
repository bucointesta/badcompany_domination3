// by Xeno
#define THIS_FILE "fn_waitforgps.sqf"
#include "..\..\x_setup.sqf"

disableSerialization;
sleep 10;
waitUntil {visibleGPS};
private _gps = controlNull;
{
	if (!isNil "_x" && {!isNull _x && {!isNil {_x displayctrl 101}}}) then {
		_gps = _x displayctrl 101;
	};
	false
} count (uiNamespace getVariable "IGUI_displays");
if (!isNull _gps) then {
	_gps ctrlAddEventHandler ["Draw", {[_this, 1] call d_fnc_mapondraw}];
};