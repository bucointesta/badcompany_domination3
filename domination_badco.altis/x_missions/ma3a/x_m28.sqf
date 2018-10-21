// by Xeno
//#define __DEBUG__
#define THIS_FILE "x_m28.sqf"
#include "..\..\x_setup.sqf"

d_x_sm_pos = "d_sm_28" call d_fnc_smmapos; // index: 28,   Radio Tower on mount Didymos
d_x_sm_type = "normal"; // "convoy"

if (hasInterface) then {
	d_cur_sm_txt = localize "STR_DOM_MISSIONSTRING_849";
	d_current_mission_resolved_text = localize "STR_DOM_MISSIONSTRING_727";
};

if (call d_fnc_checkSHC) then {
	private _poss = d_x_sm_pos select 0;
	private _vec = createVehicle [d_illum_tower, _poss, [], 0, "NONE"];
	_vec setPos _poss;
	_vec setVectorUp [0,0,1];
	_vec call d_fnc_addKilledEHSM;
	d_x_sm_vec_rem_ar pushBack _vec;
	sleep 2.22;
	private _pos_other = d_x_sm_pos select 1;
	["aa", 1, "tracked_apc", 0, "tank", 0, _pos_other, 1, 0, false] spawn d_fnc_CreateArmor;
	sleep 2.333;
	["specops", 1, "allmen", 2, _poss, 200, true] spawn d_fnc_CreateInf;
	sleep 2.333;
	["aa", 0, "tracked_apc", 1, "tank", 1, _pos_other, 1, 400, true] spawn d_fnc_CreateArmor;
};
