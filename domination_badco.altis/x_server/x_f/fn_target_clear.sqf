// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_target_clear.sqf"
#include "..\..\x_setup.sqf"
if (!isServer) exitWith{};

__TRACE_1("","_this")

sleep 1.123;

if (!isNil "d_HC_CLIENT_OBJ_OWNER") then {
	remoteExecCall ["d_fnc_xdelct", d_HC_CLIENT_OBJ_OWNER];
	[missionNamespace, ["d_mt_done", true]] remoteExecCall ["setVariable", d_HC_CLIENT_OBJ_OWNER];
} else {
	call d_fnc_xdelct;
	d_mt_done = true;
};
sleep 0.01;

if (!d_side_main_done) then {
	if (alive d_fixor_var) then {
		sleep 30 + random 30;
		if (alive d_fixor_var) then {
			d_fixor_var setDamage 1;
		};	
	};
	d_side_main_done = true;
};

private _cur_tgt_name = d_cur_tgt_name;

d_old_target_pos =+ d_cur_tgt_pos;
d_old_radius = d_cur_target_radius;

#ifndef __TT__
d_resolved_targets pushBack d_current_target_index;
publicVariable "d_resolved_targets";
#else
private _addpblufor = 0;
private _addpopfor = 0;
private _pdist = d_old_radius + 200;
{
	_x addScore (d_tt_points # 0);
	switch (side (group _x)) do {
		case blufor: {_addpblufor = _addpblufor + (d_tt_points # 0)};
		case opfor: {_addpopfor = _addpopfor + (d_tt_points # 0)};
	};
} forEach ((allPlayers - entities "HeadlessClient_F") select {alive _x && {!(_x getVariable ["xr_pluncon", false]) && {!(_x getVariable ["ace_isunconscious", false]) && {_x distance2D d_old_target_pos < _pdist}}}});

d_kill_points_blufor = d_kill_points_blufor + _addpblufor;
d_kill_points_opfor = d_kill_points_opfor + _addpopfor;

if (d_kill_points_blufor > d_kill_points_opfor) then {
	d_mt_winner = 1;
	d_points_blufor = d_points_blufor + (d_tt_points # 0);
} else {
	if (d_kill_points_opfor > d_kill_points_blufor) then {
		d_mt_winner = 2;
		d_points_opfor = d_points_opfor + (d_tt_points # 0);
	} else {
		if (d_kill_points_opfor == d_kill_points_blufor) then {
			d_mt_winner = 3;
			d_points_blufor = d_points_blufor + (d_tt_points # 1);
			d_points_opfor = d_points_opfor + (d_tt_points # 1);
		};
	};
};
publicVariable "d_mt_winner";
d_points_array = [d_points_blufor, d_points_opfor, d_kill_points_blufor, d_kill_points_opfor]; 
publicVariable "d_points_array";

d_resolved_targets pushBack [d_current_target_index, d_mt_winner];
publicVariable "d_resolved_targets";
sleep 0.5;
d_public_points = false;
__TRACE_1("","d_mt_winner")
#endif

if (!isNil "d_HC_CLIENT_OBJ_OWNER") then {
	remoteExecCall ["d_fnc_dodelintelu", d_HC_CLIENT_OBJ_OWNER];
} else {
	if (!isNull d_intel_unit) then {
		deleteVehicle d_intel_unit;
		d_intel_unit = objNull;
	};
};

sleep 0.5;

if !(d_maintargets_list isEqualTo []) then {
	if (d_bonus_vec_type in [0, 1]) then {
		0 spawn d_fnc_gettargetbonus;
	} else {
		call d_fnc_targetclearm;
	};
} else {
	d_target_clear = true; publicVariable "d_target_clear";
#ifndef __TT__
	("d_" + _cur_tgt_name + "_dommtm") setMarkerColor "ColorGreen";
	"" remoteExec ["d_fnc_target_clear_client", [0, -2] select isDedicated];
	d_kb_logic1 kbTell [d_kb_logic2, d_kb_topic_side, "Captured2", ["1", "", _cur_tgt_name, [_cur_tgt_name]],d_kbtel_chan];
#else
	private _mtcol = if (d_mt_winner == 1) then {
		"ColorBlue"
	} else {
		if (d_mt_winner == 2) then {
			"ColorRed"
		} else {
			"ColorGreen"
		};
	};
	("d_" + _cur_tgt_name + "_dommtm") setMarkerColor _mtcol;
	["", ""] remoteExec ["d_fnc_target_clear_client", [0, -2] select isDedicated];
	d_hq_logic_blufor1 kbTell [d_hq_logic_blufor2,"HQ_W","Captured2",["1","",_cur_tgt_name,[_cur_tgt_name]],"SIDE"];
	d_hq_logic_opfor1 kbTell [d_hq_logic_opfor2,"HQ_E","Captured2",["1","",_cur_tgt_name,[_cur_tgt_name]],"SIDE"];
#endif
};

sleep 2.123;

if !(d_maintargets_list isEqualTo []) then {
	if (!isNil "d_HC_CLIENT_OBJ_OWNER") then {
		[1, d_current_target_index] remoteExecCall ["d_fnc_doexechcf", d_HC_CLIENT_OBJ_OWNER];
	} else {
#ifndef __TT__
		{
			if (!isNull _x) then {
				_x spawn {
					sleep (60 + random 60);
					_this setDamage 0;
					deleteVehicle _this;
				};
			};
		} forEach d_mt_barracks_obj_ar;
		if (!isNull d_mt_mobile_hq_obj) then {
			d_mt_mobile_hq_obj spawn {
				sleep (60 + random 60);
				_this setDamage 0;
				deleteVehicle _this;
			};
		};
#endif
		d_current_target_index execFSM "fsms\fn_DeleteUnits.fsm";
	};
};

sleep 4.321;

if (d_WithJumpFlags == 1 && {!(d_maintargets_list isEqualTo [])}) then {0 spawn d_fnc_createjumpflag};

if (!isNil "d_HC_CLIENT_OBJ_OWNER") then {
	remoteExecCall ["d_fnc_dodelrspgrps", d_HC_CLIENT_OBJ_OWNER];
} else {
	call d_fnc_dodelrspgrps;
};

_del_camps_stuff = [];
{
	private _flag = _x getVariable "d_FLAG";
	deleteMarker (_x getVariable "d_camp_mar");
	_del_camps_stuff pushBack _x;
	if (!isNull _flag) then {
		_del_camps_stuff pushBack _flag;
	};
} forEach d_currentcamps;
d_currentcamps = [];
publicVariable "d_currentcamps";
#ifdef __TT__
d_campscaptured_w = 0;
publicVariable "d_campscaptured_w";
d_campscaptured_e = 0;
publicVariable "d_campscaptured_e";
#endif

sleep 0.245;

if (isNil "d_HC_CLIENT_OBJ_OWNER") then {
	[d_old_target_pos, d_old_radius, _del_camps_stuff] execFSM "fsms\fn_DeleteEmpty.fsm";
} else {
	[d_old_target_pos, d_old_radius, _del_camps_stuff] remoteExecCall ["d_fnc_DeleteEmpty", d_HC_CLIENT_OBJ_OWNER];
};

0 spawn d_fnc_rebbuil;

if !(d_maintargets_list isEqualTo []) then {
	if (d_MHQDisableNearMT != 0) then {
		{
			private _fux = _x getVariable "d_vecfuelmhq";
			if (fuel _x < _fux) then {
				[_x, _fux] remoteExecCall ["setFuel", _x];
			};
			_x setVariable ["d_vecfuelmhq", nil, true];
		} forEach (vehicles select {alive _x && {!isNil {_x getVariable "d_vecfuelmhq"}}});
	};
	sleep 15;
#ifdef __TT__
	d_kill_points_blufor = 0;
	d_kill_points_opfor = 0;
	d_public_points = true;
#endif
	if (d_database_found && {d_db_auto_save}) then {
		["d_dom_db_autosave", objNull] call d_fnc_saveprogress2db;
	};
	0 spawn d_fnc_createnexttarget;
} else {
#ifdef __TT__
	if (d_database_found && {d_db_auto_save}) then {
		"extdb3" callExtension format ["1:dom:missionsaveDelTT:%1", tolower (worldName + "d_dom_db_autosave" + briefingName)];
	};
	d_the_end = true; publicVariable "d_the_end";
	0 spawn d_fnc_DomEnd;
#else
	if (d_database_found && {d_db_auto_save}) then {
		"extdb3" callExtension format ["1:dom:missionsaveDel:%1", tolower (worldName + "d_dom_db_autosave" + briefingName)];
	};
	d_the_end = true; publicVariable "d_the_end";
	0 spawn d_fnc_DomEnd;
#endif
};

__TRACE("Done")