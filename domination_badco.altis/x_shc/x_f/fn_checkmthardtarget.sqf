// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_checkmthardtarget.sqf"
#include "..\..\x_setup.sqf"

params ["_vec"];
_vec addEventHandler ["killed", {
	d_mt_spotted = false;
	if (d_IS_HC_CLIENT) then {
		[missionNamespace, ["d_mt_spotted", false]] remoteExecCall ["setVariable", 2];
	};
	d_mt_radio_down = true;
	[missionNamespace, ["d_mt_radio_down", true]] remoteExecCall ["setVariable", 2];
	"d_main_target_radiotower" remoteExecCall ["deleteMarker", 2];
	[37] remoteExecCall ["d_fnc_DoKBMsg", 2];
	(param [0]) spawn {
		sleep (60 + random 60);
		_this setDamage 0;
		deleteVehicle _this;
	};
	if (d_database_found) then {
		private _killer = param [1];
		if (!isNil "_killer" && {!isNull _killer && {isPlayer _killer}}) then {
			[_killer, 1] remoteExecCall ["d_fnc_addppoints", 2];
		};
	};
	(param [0]) removeAllEventHandlers "killed";
}];
_vec addEventHandler ["handleDamage", {_this call d_fnc_CheckMTShotHD}];