// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_checksmshothd.sqf"
#include "..\x_setup.sqf"

__TRACE_1("","_this")

if (!alive (param [0])) exitWith {
	(param [0]) removeAllEventHandlers "handleDamage";
};

if (toUpper(getText(configFile>>"CfgAmmo">>(param [4])>>"simulation")) in d_hd_sim_types) then {
	param [2]
} else {
	0
}