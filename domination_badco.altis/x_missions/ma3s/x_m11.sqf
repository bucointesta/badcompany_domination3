// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_m11.sqf"
#include "..\..\x_setup.sqf"

d_x_sm_pos = "d_sm_11" call d_fnc_smmapos; // Find and eliminate Nib Nedal in the region near Keiros Bay
d_x_sm_type = "normal"; // "convoy"

if (hasInterface) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_826";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_827";
};

if (call d_fnc_checkSHC) then {
	private _newpos = [d_x_sm_pos # 0, 400] call d_fnc_GetRanPointCircle;
	private _ogroup = [d_side_enemy] call d_fnc_creategroup;
	private _sm_vec = _ogroup createUnit [d_soldier_officer, _newpos, [], 0, "NONE"];
	[_sm_vec] joinSilent _ogroup;
	_ogroup deleteGroupWhenEmpty true;
	_newpos set [2, 0];
	[_sm_vec, _newpos] call d_fnc_setposagls;
	_sm_vec call d_fnc_removenvgoggles_fak;
	_sm_vec call d_fnc_addkillednormal;
	if (Hz_customUnitLoadouts) then {
		_sm_vec call AI_setupUnitCustomLoadout;
	};
	_sm_vec setSkill 1;
	d_x_sm_rem_ar pushBack _sm_vec;
	sleep 2.123;
	["specops", 1, "allmen", 0, _newpos, 0, true] call d_fnc_CreateInf;
	sleep 2.123;
	private _leadero = leader _ogroup;
	_leadero setRank "COLONEL";
	_ogroup allowFleeing 0;
	_ogroup setBehaviour "AWARE";
	_leadero disableAI "PATH";
	if (d_with_dynsim == 0) then {
		_sm_vec enableDynamicSimulation true;
	};
};
