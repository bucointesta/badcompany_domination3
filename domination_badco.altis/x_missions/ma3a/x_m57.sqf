// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_m57.sqf"
#include "..\..\x_setup.sqf"

d_x_sm_pos = "d_sm_57" call d_fnc_smmapos; // index:57 A lonewolf sniper has been sent to make attempt to kill the Civilian Leader of Orekokastro. Find and eliminate him Intel says hes near the Castle.
d_x_sm_type = "normal"; // "convoy"

if (hasInterface) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_1814";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_1545";
};

if (call d_fnc_checkSHC) then {
	d_x_sm_pos params ["_poss"];
	private _newpos = [_poss, 150] call d_fnc_GetRanPointCircle;
	private _ogroup = [d_side_enemy] call d_fnc_creategroup;
	private _sm_vec = _ogroup createUnit [d_sniper, _newpos, [], 0, "NONE"];
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
	private _leadero = leader _ogroup;
	_leadero setRank "COLONEL";
	_ogroup allowFleeing 0;
	_ogroup setBehaviour "AWARE";
	if (d_with_dynsim == 0) then {
		_sm_vec enableDynamicSimulation true;
	};
};
