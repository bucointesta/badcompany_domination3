// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_detachchemlight.sqf"
#include "..\..\x_setup.sqf"

if (isDedicated) exitWith {};

private _clattachedobj = player getVariable ["d_p_clattachedobj", objNull];
if (!isNull _clattachedobj) then {
	deleteVehicle _clattachedobj;
};
player setVariable ["d_p_clattachedobj", nil];
player setVariable ["d_p_clattached", nil];
d_commandingMenuIniting = false;
