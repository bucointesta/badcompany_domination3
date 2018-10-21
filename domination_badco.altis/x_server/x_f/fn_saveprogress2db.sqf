// by Xeno
//#define __DEBUG__
#define THIS_FILE "fn_saveprogress2db.sqf"
#include "..\..\x_setup.sqf"

params ["_sname", "_sender"];

__TRACE_2("","_sname","_sender")

_sname = toLower _sname;

d_bonus_vecs_db = d_bonus_vecs_db - [objNull];
private _bonus_vecs_db = d_bonus_vecs_db apply {typeOf _x};

private _maintargets_list =+ d_maintargets_list;

if (d_current_target_index != -1 && {!(d_current_target_index in d_resolved_targets) && {!(d_current_target_index in d_maintargets_list)}}) then {
	_maintargets_list = [d_current_target_index] + _maintargets_list;
};

private _current_mission_counter = if (d_cur_sm_idx == -1) then {
	d_current_mission_counter
} else {
	d_current_mission_counter - 1
};
if (_current_mission_counter < 0) then {_current_mission_counter = 0};

__TRACE_1("","_maintargets_list")
__TRACE_1("","d_current_target_index")
__TRACE_1("","d_maintargets_list")
__TRACE_1("","d_resolved_targets")

if !(_sname in d_db_savegames) then {
	d_db_savegames pushBack _sname;
	publicVariable "d_db_savegames";
	"extdb3" callExtension format ["1:dom:missionInsert:%1:%2:%3:%4:%5:%6:%7:%8:%9:%10:%11:%12:%13:%14", _sname, d_maintargets, _maintargets_list, d_current_target_index, d_cur_sm_idx, d_resolved_targets, d_recapture_indices, d_side_missions_random, _current_mission_counter, d_searchintel, _bonus_vecs_db, tolower worldname, tolower (worldName + _sname), tolower (worldName + _sname + briefingname)];
} else {
	"extdb3" callExtension format ["1:dom:missionUpdate:%1:%2:%3:%4:%5:%6:%7:%8:%9:%10:%11", d_maintargets, _maintargets_list, d_current_target_index, d_cur_sm_idx, d_resolved_targets, d_recapture_indices, d_side_missions_random, _current_mission_counter, d_searchintel, _bonus_vecs_db, tolower (worldName + _sname)];
};

if (!isNull _sender) then {
	[format [localize "STR_DOM_MISSIONSTRING_1749", _sname], "GLOBAL"] remoteExecCall ["d_fnc_HintChatMsg", _sender];
};
