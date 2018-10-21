// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_getsidemission.sqf"
#include "..\x_setup.sqf"

if (!isServer || {d_all_sm_res}) exitWith{};

if (d_current_mission_counter == d_number_side_missions) exitWith {
	d_all_sm_res = true; publicVariable "d_all_sm_res";
	d_kb_logic1 kbTell [d_kb_logic2, d_kb_topic_side, "AllSMissionsResolved", d_kbtel_chan];
	deleteVehicle d_sm_triggervb;
	d_sm_triggervb = nil;
};

#ifndef __SMDEBUG__
if (d_MissionType != 2) then {
	while {!d_main_target_ready} do {sleep 2.321};
};
#endif

private _cur_sm_idx = d_side_missions_random select d_current_mission_counter;
d_current_mission_counter = d_current_mission_counter + 1;

__TRACE_1("","_cur_sm_idx")

{
	_x setDamage 0;
	false
} count d_house_objects2;
d_house_objects2 = [];

d_x_sm_rem_ar = [];
d_x_sm_vec_rem_ar = [];

//_cur_sm_idx = param [0];
//_cur_sm_idx = 19;

if (isNil "d_HC_CLIENT_OBJ_OWNER") then {
	execVM format ["x_missions\ma3a\%2%1.sqf", _cur_sm_idx, d_sm_fname];
	sleep 7.012;
	[_cur_sm_idx, d_x_sm_pos, d_x_sm_type] remoteExecCall ["d_fnc_s_sm_up", 2];
} else {
	[_cur_sm_idx, d_sm_fname] remoteExec ["d_fnc_hcsmexec", d_HC_CLIENT_OBJ_OWNER];
};
