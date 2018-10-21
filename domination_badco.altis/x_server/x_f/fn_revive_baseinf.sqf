// by Bucointesta
//#define __DEBUG__
#define THIS_FILE "fn_revive_baseinf.sqf"
#include "..\..\x_setup.sqf"

private _veh = _this;

createVehicleCrew _veh;
{
[_x] join d_baseinf;
_x setVariable ["gun", _veh];
removeAllWeapons _x;
_x addEventHandler ["killed", {[param [0], param [1], param[2]] remoteExecCall ["d_fnc_plcheckkill", 2]; private _gun = (param[0]) getVariable "gun";  _gun spawn { sleep 300; _this call d_fnc_revive_baseinf; }}];
} forEach crew _veh;

