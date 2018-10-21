// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_shcinit.sqf"
#include "..\x_setup.sqf"

__TRACE("x_shcinit")

if !(call d_fnc_checkSHC) exitWith {};

d_delvecsmt = [];
d_no_more_observers = false;
d_counterattack = false;
d_create_new_paras = false;
d_x_sm_rem_ar = [];
d_x_sm_vec_rem_ar = [];
d_check_trigger = objNull;
d_first_time_after_start = true;
d_nr_observers = 0;
d_sm_resolved = false;
d_main_target_ready = false;
d_mt_spotted = false;
d_mt_radio_down = false;

if (d_IS_HC_CLIENT) then {
	call compile preprocessFileLineNumbers "x_shc\x_f\x_shcfunctions.sqf";
	call compile preprocessFileLineNumbers "i_server.sqf";
};

if (d_WithRecapture == 0 && {d_MissionType != 2}) then {execFSM "fsms\fn_Recapture.fsm"};

// start air AI after some time
if (d_MissionType != 2) then {
	0 spawn {
		scriptName "spawn_x_shcinit_airai";
		sleep 30;
		if (isMultiplayer && {isServer && {!isNil "HC_D_UNIT"}}) exitWith {};
		sleep 1200;
		["LAC"] execVM "x_shc\x_airai.sqf"; // LAC = Ligh Attack Chopper
		sleep 1200;
		["HAC"] execVM "x_shc\x_airai.sqf"; // HAC = Heavy Attack Chopper
		sleep 1200;
		["AP"] execVM "x_shc\x_airai.sqf"; // AP = Attack Plane
	};
};

if !(d_with_isledefense isEqualTo []) then {execVM "x_shc\x_isledefense.sqf"};

__TRACE("x_shcinit done")