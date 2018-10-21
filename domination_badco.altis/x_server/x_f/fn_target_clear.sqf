// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_target_clear.sqf"
#include "..\..\x_setup.sqf"
if (!isServer) exitWith{};

__TRACE_1("","_this")

sleep 1.123;

if (!isNil "d_f_check_triggers") then {
	{
		deleteVehicle _x;
		false
	} count d_f_check_triggers;
};
deleteVehicle d_current_trigger;
if (!isNil "d_HC_CLIENT_OBJ_OWNER") then {
	remoteExecCall ["d_fnc_xdelct", d_HC_CLIENT_OBJ_OWNER];
	[missionNamespace, ["d_mt_done", true]] remoteExecCall ["setVariable", d_HC_CLIENT_OBJ_OWNER];
} else {
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

d_counterattack = false;
private _start_real = false;
private _channel = d_kbtel_chan;
if ((random 100) > 96) then {
	d_counterattack = true;
	_start_real = true;
	d_kb_logic1 kbTell [d_kb_logic2, d_kb_topic_side, "CounterattackEnemy", ["1", "", _cur_tgt_name, []], _channel];
	0 spawn d_fnc_counterattack;
};

while {d_counterattack} do {sleep 3.123};

if (_start_real) then {
	d_kb_logic1 kbTell [d_kb_logic2, d_kb_topic_side, "CounterattackDefeated", _channel];
	sleep 2.321;
};

d_old_target_pos =+ d_cur_tgt_pos;
d_old_radius = d_cur_target_radius;

d_resolved_targets pushBack d_current_target_index;
publicVariable "d_resolved_targets";

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
	//["d_" + _cur_tgt_name + "_dommtm", "ColorGreen"] remoteExecCall ["setMarkerColor", 2];
	("d_" + _cur_tgt_name + "_dommtm") setMarkerColor "ColorGreen";
	"" remoteExec ["d_fnc_target_clear_client", [0, -2] select isDedicated];
	d_kb_logic1 kbTell [d_kb_logic2, d_kb_topic_side, "Captured2", ["1", "", _cur_tgt_name, [_cur_tgt_name]],_channel];
};

sleep 2.123;

if !(d_maintargets_list isEqualTo []) then {
	if (!isNil "d_HC_CLIENT_OBJ_OWNER") then {
		//d_current_target_index remoteExecCall ["d_fnc_deleteunits", d_HC_CLIENT_OBJ_OWNER];
		[1, d_current_target_index] remoteExecCall ["d_fnc_doexechcf", d_HC_CLIENT_OBJ_OWNER];
	} else {
		//d_current_target_index call d_fnc_DeleteUnits;
		d_current_target_index execFSM "fsms\fn_DeleteUnits.fsm";
	};
};

sleep 4.321;

if (d_WithJumpFlags == 1 && {!(d_maintargets_list isEqualTo [])}) then {0 spawn d_fnc_createjumpflag};

if (!isNil "d_HC_CLIENT_OBJ_OWNER") then {
	remoteExecCall ["d_fnc_dodelrspgrps", d_HC_CLIENT_OBJ_OWNER];
} else {
	if !(d_respawn_ai_groups isEqualTo []) then {
		0 spawn {
			__TRACE_1("","d_respawn_ai_groups")
			{
				_x params ["_rgrp"];
				__TRACE_1("","_rgrp")
				if (!isNil "_rgrp" && {_rgrp isEqualType grpNull && {!isNull _rgrp}}) then {
					{
						private _v = vehicle _x;
						__TRACE_1("","_v")
						if (_v != _x && {alive _v}) then {_v setDamage 1};
						if (alive _x) then {_x setDamage 1};
						false
					} count ((units _rgrp) select {!isNil "_x" && {!isNull _x}});
				};
				false
				} count (d_respawn_ai_groups select {_x isEqualType []});
		};
	};
};

_del_camps_stuff = [];
{
	private _flag = _x getVariable "d_FLAG";
	deleteMarker format ["d_camp%1",_x getVariable "d_INDEX"];
	_del_camps_stuff pushBack _x;
	if (!isNull _flag) then {
		_del_camps_stuff pushBack _flag;
	};
	false
} count d_currentcamps;
d_currentcamps = [];

sleep 0.245;

if (isNil "d_HC_CLIENT_OBJ_OWNER") then {
	//[d_old_target_pos, d_old_radius, _del_camps_stuff] call d_fnc_DeleteEmpty;
	[d_old_target_pos, d_old_radius, _del_camps_stuff] execFSM "fsms\fn_DeleteEmpty.fsm";
} else {
	[d_old_target_pos, d_old_radius, _del_camps_stuff] remoteExecCall ["d_fnc_DeleteEmpty", d_HC_CLIENT_OBJ_OWNER];
};

0 spawn d_fnc_rebbuil;

if !(d_maintargets_list isEqualTo []) then {
	if (d_MHQDisableNearMT != 0) then {
		{
			private _fux = _x getVariable "d_vecfuelmhq";
			if (!isNil "_fux") then {
				if (fuel _x < _fux) then {
					[_x, _fux] remoteExecCall ["setFuel", _x];
				};
				_x setVariable ["d_vecfuelmhq", nil, true];
			};
			false
		} count (vehicles select {alive _x});
	};
	sleep 15;
	if (d_database_found && {d_db_auto_save}) then {
		["d_dom_db_autosave", objNull] call d_fnc_saveprogress2db;
	};
	0 spawn d_fnc_createnexttarget;
} else {
	if (d_WithRecapture == 0) then {
		if (d_recapture_indices isEqualTo []) then {
			if (d_database_found && {d_db_auto_save}) then {
				"extdb3" callExtension format ["1:dom:missionsaveDel:%1", tolower (worldName + "d_dom_db_autosave" + briefingName)];
			};
			d_the_end = true; publicVariable "d_the_end";
			0 spawn d_fnc_DomEnd;
		} else {
			0 spawn {
				scriptName "spawn_x_target_clear_waitforrecap";
				while {!(d_recapture_indices isEqualTo [])} do {
					sleep 2.543;
				};
				if (d_database_found && {d_db_auto_save}) then {
					"extdb3" callExtension format ["1:dom:missionsaveDel:%1", tolower (worldName + "d_dom_db_autosave" + briefingName)];
				};
				d_the_end = true; publicVariable "d_the_end";
				0 spawn d_fnc_DomEnd;
			};
		};
	} else {
		if (d_database_found && {d_db_auto_save}) then {
			"extdb3" callExtension format ["1:dom:missionsaveDel:%1", tolower (worldName + "d_dom_db_autosave" + briefingName)];
		};
		d_the_end = true; publicVariable "d_the_end";
		0 spawn d_fnc_DomEnd;
	};
};

__TRACE("Done")